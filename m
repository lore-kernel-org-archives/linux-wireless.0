Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbeASMof (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 07:44:35 -0500
Date: Fri, 19 Jan 2018 15:44:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, venkateswara.kaja@microchip.com,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com
Subject: Re: [PATCH 04/14] staging: wilc1000: rename
 host_int_ParseJoinBssParam() and it's variable using camelCase
Message-ID: <20180119124417.5upkxkhfrk7om23s@mwanda> (sfid-20180119_134439_471365_ABB65F79)
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
 <1516281432-7724-5-git-send-email-ajay.kathat@microchip.com>
 <63fc190a-15cd-3c7f-21d0-e726bdff8283@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="km3ys2ihhhfv6tco"
In-Reply-To: <63fc190a-15cd-3c7f-21d0-e726bdff8283@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--km3ys2ihhhfv6tco
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 19, 2018 at 01:20:00PM +0200, Claudiu Beznea wrote:
> It is hard to review this. Anyway, Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> 

I have a script I use.  It's sort of hacky, but it's a time saver.  I've
attached it.

To review this one, I do `cat <email.txt> | rename_rev.pl -a`

regards,
dan carpenter

--km3ys2ihhhfv6tco
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="rename_rev.pl"

#!/usr/bin/perl

# This is a tool to help review variable rename patches. The goal is
# to strip out the automatic sed renames and the white space changes
# and leaves the interesting code changes.
#
# Example 1: A patch renames openInfo to open_info:
#     cat diff | rename_review.pl openInfo open_info
#
# Example 2: A patch swaps the first two arguments to some_func():
#     cat diff | rename_review.pl \
#                    -e 's/some_func\((.*?),(.*?),/some_func\($2, $1,/'
#
# Example 3: A patch removes the xkcd_ prefix from some but not all the
# variables.  Instead of trying to figure out which variables were renamed
# just remove the prefix from them all:
#     cat diff | rename_review.pl -ea 's/xkcd_//g'
#
# Example 4: A patch renames 20 CamelCase variables.  To review this let's
# just ignore all case changes and all '_' chars.
#     cat diff | rename_review -ea 'tr/[A-Z]/[a-z]/' -ea 's/_//g'
#
# The other arguments are:
# -nc removes comments
# -ns removes '\' chars if they are at the end of the line.

use strict;
use File::Temp qw/ :mktemp  /;

sub usage() {
    print "usage: cat diff | $0 old new old new old new...\n";
    print "   or: cat diff | $0 -e 's/old/new/g'\n";
    print " -a : auto";
    print " -e : execute on old lines\n";
    print " -ea: execute on all lines\n";
    print " -nc: no comments\n";
    print " -nb: no unneeded braces\n";
    print " -ns: no slashes at the end of a line\n";
    print " -pull: for function pull.  deletes context.\n";
    print " -r <recipe>: NULL, bool";
    exit(1);
}
my @subs;
my @strict_subs;
my @cmds;
my $strip_comments;
my $strip_braces;
my $strip_slashes;
my $pull_context;
my $auto;

sub filter($) {
    my $line = shift();
    my $old = 0;
    if ($line =~ /^-/) {
        $old = 1;
    }
    # remove the first char
    $line =~ s/^[ +-]//;
    if ($strip_comments) {
        $line =~ s/\/\*.*?\*\///g;
        $line =~ s/\/\/.*//;
    }
    foreach my $cmd (@cmds) {
        if ($old || $cmd->[0] =~ /^-ea$/) {
            eval "\$line =~ $cmd->[1]";
        }
    }
    foreach my $sub (@subs) {
        if ($old) {
            $line =~ s/$sub->[0]/$sub->[1]/g;
        }
    }
    foreach my $sub (@strict_subs) {
        if ($old) {
            $line =~ s/\b$sub->[0]\b/$sub->[1]/g;
        }
    }

    # remove the newline so we can move curly braces here if we want.
    $line =~ s/\n//;
    return $line;
}

while (my $param1 = shift()) {
    if ($param1 =~ /^-a$/) {
        $auto = 1;
        next;
    }
    if ($param1 =~ /^-nc$/) {
        $strip_comments = 1;
        next;
    }
    if ($param1 =~ /^-nb$/) {
        $strip_braces = 1;
        next;
    }
    if ($param1 =~ /^-ns$/) {
        $strip_slashes = 1;
        next;
    }
    if ($param1 =~ /^-pull$/) {
        $pull_context = 1;
        next;
    }
    my $param2 = shift();
    if ($param2 =~ /^$/) {
        usage();
    }
    if ($param1 =~ /^-e(a|)$/) {
        push @cmds, [$param1, $param2];
        next;
    }
    if ($param1 =~ /^-r$/) {
        if ($param2 =~ /bool/) {
            push @cmds, ["-e", "s/== true//"];
            push @cmds, ["-e", "s/true ==//"];
            push @cmds, ["-e", "s/([a-zA-Z\-\>\._]+) == false/!\$1/"];
            next;
        } elsif ($param2 =~ /NULL/) {
            push @cmds, ["-e", "s/ != NULL//"];
            push @cmds, ["-e", "s/([a-zA-Z\-\>\._0-9]+) == NULL/!\$1/"];
            next;
        } elsif ($param2 =~ /BIT/) {
            push @cmds, ["-e", 's/1[uU]* *<< *(\d+)/BIT($1)/'];
            push @cmds, ["-e", 's/\(1 *<< *(\w+)\)/BIT($1)/'];
            push @cmds, ["-e", 's/\(BIT\((.*?)\)\)/BIT($1)/'];
            next;
        }
        usage();
    }

    push @subs, [$param1, $param2];
}

my ($oldfh, $oldfile) = mkstemp("/tmp/oldXXXXX");
my ($newfh, $newfile) = mkstemp("/tmp/newXXXXX");

my @input = <STDIN>;

# auto works on the observation that the - line comes before the + line when we
# rename variables.  Take the first - line.  Find the first + line.  Find the
# one word difference.  Test that the old word never occurs in the new text.
if ($auto) {
    my %c_keywords = (  auto => 1,
                        break => 1,
                        case => 1,
                        char => 1,
                        const => 1,
                        continue => 1,
                        default => 1,
                        do => 1,
                        double => 1,
                        else => 1,
                        enum => 1,
                        extern => 1,
                        float => 1,
                        for => 1,
                        goto => 1,
                        if => 1,
                        int => 1,
                        long => 1,
                        register => 1,
                        return => 1,
                        short => 1,
                        signed => 1,
                        sizeof => 1,
                        static => 1,
                        struct => 1,
                        switch => 1,
                        typedef => 1,
                        union => 1,
                        unsigned => 1,
                        void => 1,
                        volatile => 1,
                        while => 1);
    my %old_words;
    my %new_words;
    my %added_cmds;
    my @new_subs;

    my $inside = 0;
    foreach my $line (@input) {
        if ($line =~ /^(---|\+\+\+)/) {
            next;
        }

        if ($line =~ /^@/) {
            $inside = 1;
        }
        if ($inside && !(($_ =~ /^[- @+]/) || ($_ =~ /^$/))) {
            $inside = 0;
        }
        if (!$inside) {
            next;
        }

        if ($line =~ /^-/) {
            s/-//;
            my @words = split(/\W+/, $line);
            foreach my $word (@words) {
                $old_words{$word} = 1;
            }
        } elsif ($line =~ /^\+/) {
            s/\+//;
            my @words = split(/\W+/, $line);
            foreach my $word (@words) {
                $new_words{$word} = 1;
            }
        }
    }

    my $old_line;
    my $new_line;
    $inside = 0;
    foreach my $line (@input) {
        if ($line =~ /^(---|\+\+\+)/) {
            next;
        }

        if ($line =~ /^@/) {
            $inside = 1;
        }
        if ($inside && !(($_ =~ /^[- @+]/) || ($_ =~ /^$/))) {
            $inside = 0;
        }
        if (!$inside) {
            next;
        }


        if ($line =~ /^-/ && !$old_line) {
            s/^-//;
            $old_line = $line;
            next;
        } elsif ($old_line && $line =~ /^\+/) {
            s/^\+//;
            $new_line = $line;
        } else {
            next;
        }

        my @old_words = split(/\W+/, $old_line);
        my @new_words = split(/\W+/, $new_line);
        my @new_cmds;

        my $i;
        my $diff_count = 0;
        for ($i = 0; ; $i++) {
            if (!defined($old_words[$i]) && !defined($new_words[$i])) {
                last;
            }
            if (!defined($old_words[$i]) || !defined($new_words[$i])) {
                $diff_count = 1000;
                last;
            }
            if ($old_words[$i] eq $new_words[$i]) {
                next;
            }
            if ($c_keywords{$old_words[$i]}) {
                $diff_count = 1000;
                last;
            }
            if ($new_words{$old_words[$i]}) {
                $diff_count++;
            }
            push @new_cmds, [$old_words[$i], $new_words[$i]];
        }
        if ($diff_count <= 2) {
            foreach my $sub (@new_cmds) {
                if ($added_cmds{$sub->[0] . $sub->[1]}) {
                    next;
                }
                $added_cmds{$sub->[0] . $sub->[1]} = 1;
                push @new_subs, [$sub->[0] , $sub->[1]];
            }
        }

        $old_line = 0;
    }

    if (@new_subs) {
        print "RENAMES:\n";
        foreach my $sub (@new_subs) {
            print "$sub->[0] => $sub->[1]\n";
            push @strict_subs, [$sub->[0] , $sub->[1]];
        }
        print "---\n";
    }
}

my $output;

#recreate an old file and a new file
my $stored_brace_line = "";
my $stored_remove_output = "";
my $del_close_brace = 0;
my $inside = 0;
foreach (@input) {
    my $orig = $_;


    if ($pull_context && !($orig =~ /^[+-@]/)) {
        next;
    }

    if ($orig =~ /^(---|\+\+\+)/) {
        next;
    }

    if ($orig =~ /^@/) {
        $inside = 1;
    }
    if ($inside && !(($orig =~ /^[- @+]/) || ($orig =~ /^$/))) {
        $inside = 0;
    }
    if (!$inside) {
        next;
    }

    $output = filter($orig);

    if ($strip_braces && $stored_brace_line =~ /^$/ && $orig =~ /^-(.*)\{$/) {
        $stored_brace_line = $output;
        next;
    }

    if ($strip_braces && $orig =~ /^-/ && !($stored_brace_line =~ /^$/)) {
        $stored_remove_output = $stored_remove_output . "\n" . $output;
        next;
    }

    if ($strip_braces && $del_close_brace && $orig =~ /^-\W+}\W+/) {
        $del_close_brace = 0;
        next;
    }

    if ($strip_braces && $orig =~ /^\+.*/ && !($stored_brace_line =~ /^$/)) {
        my $stripped_old = $stored_brace_line;
        my $stripped_new = $output;

        $stripped_old =~ s/(.*)\w*{/$1/;

        if ($stripped_old eq $stripped_new) {
            $orig = " ";
            $output = $stripped_new;
            $stored_brace_line = "";
            $del_close_brace = 1;
        }
    }

    if ($strip_braces && $orig =~ /^(\+|-)\W+{/) {
        $output =~ s/^[\t ]+(.*)/ $1/;
    } else {
        $output = "\n" . $output;
    }

    if ($orig =~ /^-/) {
        print $oldfh $output;
        next;
    }

    if ($orig =~ /^\+/) {
        print $newfh $output;
        next;
    }
    print $oldfh $output;
    print $newfh $output;

    if (!($stored_remove_output =~ /^$/)) {
            print $oldfh $stored_brace_line;
            print $oldfh $stored_remove_output;
            $stored_brace_line = "";
            $stored_remove_output = "";
    }
}
print $oldfh "\n";
print $newfh "\n";
# git diff puts a -- and version at the end of the diff.  put the -- into the
# new file as well so it's ignored
if ($output =~ /\n-/) {
    print $newfh "-\n";
}

my $hunk;
my $old_txt;
my $new_txt;

open diff, "diff -uw $oldfile $newfile |";
while (<diff>) {
    if ($_ =~ /^(---|\+\+\+)/) {
        next;
    }

    if ($_ =~ /^@/) {

        if ($strip_comments) {
            $old_txt =~ s/\/\*.*?\*\///g;
            $new_txt =~ s/\/\*.*?\*\///g;
        }
        if ($strip_braces) {
            $old_txt =~ s/{([^;{]*?);}/$1;/g;
            $new_txt =~ s/{([^;{]*?);}/$1;/g;
            # this is a hack because i don't know how to replace nested
            # unneeded curly braces.
            $old_txt =~ s/{([^;{]*?);}/$1;/g;
            $new_txt =~ s/{([^;{]*?);}/$1;/g;
        }

        if ($old_txt ne $new_txt) {
            print $hunk;
            print $_;
        }
        $hunk = "";
        $old_txt = "";
        $new_txt = "";
        next;
    }

    $hunk = $hunk . $_;

    if ($strip_slashes) {
        s/\\$//;
    }

    if ($_ =~ /^-/) {
        s/-//;
        s/[ \t\n]//g;
        $old_txt = $old_txt . $_;
        next;
    }
    if ($_ =~ /^\+/) {
        s/\+//;
        s/[ \t\n]//g;
        $new_txt = $new_txt . $_;
        next;
    }
    if ($_ =~ /^ /) {
        s/^ //;
        s/[ \t\n]//g;
        $old_txt = $old_txt . $_;
        $new_txt = $new_txt . $_;
    }
}

if ($old_txt ne $new_txt) {
    if ($strip_comments) {
        $old_txt =~ s/\/\*.*?\*\///g;
        $new_txt =~ s/\/\*.*?\*\///g;
    }
    if ($strip_braces) {
        $old_txt =~ s/{([^;{]*?);}/$1;/g;
        $new_txt =~ s/{([^;{]*?);}/$1;/g;
        $old_txt =~ s/{([^;{]*?);}/$1;/g;
        $new_txt =~ s/{([^;{]*?);}/$1;/g;
    }

    print $hunk;
}

# print "old = $oldfile new = $newfile\n";
unlink($oldfile);
unlink($newfile);

print "\ndone.\n";

--km3ys2ihhhfv6tco--
