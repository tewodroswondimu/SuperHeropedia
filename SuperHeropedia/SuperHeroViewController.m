//
//  ViewController.m
//  SuperHeropedia
//
//  Created by Tewodros Wondimu on 1/19/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SuperHeroViewController.h"

@interface SuperHeroViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *heroesArray;
@property (weak, nonatomic) IBOutlet UITableView *heroesTableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property UIActivityIndicatorView *navbarActivityIndicator;

@end

@implementation SuperHeroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create a navbar activity indicator, insert it into a UIBarButtonItem and set it right of the nav item
    self.navbarActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *navSpinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navbarActivityIndicator];
    [self.navItem setRightBarButtonItem:navSpinnerBarButtonItem];

    // Start animating the spinner on view load
    [self.navbarActivityIndicator startAnimating];

    // The heroes array is an array of dictionary items
//    self.heroesArray = @[
//                         @{
//                             @"name" : @"Iron Man",
//                             @"age"  : @32
//                         },
//                         @{
//                             @"name" : @"Dr. Strange",
//                             @"age"  : @45
//                         },
//                         @{
//                             @"name" : @"Thor",
//                             @"age"  : @342
//                         },
//                         @{
//                             @"name" : @"Moonknight",
//                             @"age"  : @41
//                         },
//                         @{
//                             @"name" : @"Juggernaut",
//       76yuu                          y@"age"  : @39
//                         },
//                         @{
//                             @"name" : @"Wolverine",
//                             @"age"  : @122
//                         },
//                        ];

    NSURL *jsonUrl = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-lib/superheroes.json"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:jsonUrl];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.heroesArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.heroesTableView reloadData];

        // Stop the spinner once the data is loaded
        [self.navbarActivityIndicator stopAnimating];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.heroesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuperheroCell"];

    // Superhero stores the dictionaries inside the heroes array
    NSDictionary *superhero = [self.heroesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = superhero[@"name"];

    // Find image from JSON
    NSURL *imageURL = [NSURL URLWithString:superhero[@"avatar_url"]];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];

    // Insert the description from the JSON url into the subtitle
    cell.detailTextLabel.text = superhero[@"description"];
    cell.detailTextLabel.numberOfLines = 3;

    return cell;
}

@end
