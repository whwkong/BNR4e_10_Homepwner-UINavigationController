//
//  BNRItemsViewController.m
//  HomePwner
//
//  Created by William Kong on 2014-05-17.
//  Copyright (c) 2014 William Kong. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"


@interface BNRItemsViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end


@implementation BNRItemsViewController

- (instancetype)init
{
    // call the superclass' designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}


- (IBAction)addNewItem:(id)sender
{
    // Create new BNRItem and add it to store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    // Determine index of last item in the array
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    // Make new index path for Section 0, last row
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // insert this new row into table
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)toggleEditingMode:(id)sender
{
    // if you are currently in editing mode ...
    if (self.isEditing) {
        // change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        // turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        // turn off editing mode
        [self setEditing:YES animated:YES];
    }
}

- (UIView*)headerView
{
    // if headerView is not loaded yet
    if (!_headerView) {
        
        // load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    
    return _headerView;
}


// implementation required UITableViewDataSource method
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

// implement required UITableViewDataSource method
-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView:cellForRowAtIndexPath:%d,%d", indexPath.section, indexPath.row);
        
    // get a cell from data pool
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    // set text
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    return cell;
}

// tableView handler for deleting or inserting rows.
-(void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        // also, remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    // TBD the other editing style is Inserting a Row.
}

// tableView handler for moving rows 
- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}


@end
