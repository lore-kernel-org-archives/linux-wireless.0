Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60141 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757023Ab2EGXZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 19:25:00 -0400
Message-ID: <1336433097.20924.18.camel@joe2Laptop> (sfid-20120508_012509_388174_1C9BFAC8)
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Miller <davem@davemloft.net>, dh.herrmann@googlemail.com,
	gustavo@padovan.org, linville@tuxdriver.com,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 16:24:57 -0700
In-Reply-To: <1336425731.5970.124.camel@aeonflux>
References: <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
	 <20120506.145304.1998242927519675381.davem@davemloft.net>
	 <1336410360.5970.103.camel@aeonflux>
	 <20120507.135547.704675228233645115.davem@davemloft.net>
	 <1336425731.5970.124.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-07 at 14:22 -0700, Marcel Holtmann wrote:
> I would love
> to see the idea realized that checkpatch.pl does the enabling/disabling
> of coding style warnings automatically based on the path.

Hey Marcel.

Please try this out:

It adds a new "C: " line to MAINTAINERS sections
that can add --strict or --ignore=foo to suit
specific maintainer taste when using checkpatch.pl

I only added --strict to drivers/net/ to test.

Play with it and let me know if it works for you.

not-signed-off-by: Joe Perches <joe@perches.com>

---

 MAINTAINERS               |    5 +++++
 scripts/checkpatch.pl     |   34 ++++++++++++++++++++++++++++++++--
 scripts/get_maintainer.pl |   17 +++++++++++++++--
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 77fddaf..38c1745 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -84,6 +84,10 @@ Descriptions of section entries:
 	   Obsolete:	Old code. Something tagged obsolete generally means
 			it has been replaced by a better system and you
 			should be using that.
+	C: Checkpatch options for this section
+	   Options are used in addition to any command line or
+	   checkpatch.conf arguments.  All sections that match
+	   a particular file's F: patterns are used.
 	F: Files and directories with wildcard patterns.
 	   A trailing slash includes all files and subdirectory files.
 	   F:	drivers/net/	all files in and below drivers/net
@@ -4727,6 +4731,7 @@ W:	http://www.linuxfoundation.org/en/Net
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
 S:	Odd Fixes
+C:	--strict
 F:	drivers/net/
 F:	include/linux/if_*
 F:	include/linux/*device.h
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cb08290..8b2ac0d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -13,6 +13,7 @@ $P =~ s@.*/@@g;
 my $V = '0.32';
 
 use Getopt::Long qw(:config no_auto_abbrev);
+use Getopt::Long qw(GetOptionsFromString);
 
 my $quiet = 0;
 my $tree = 1;
@@ -33,6 +34,7 @@ my %ignore_type = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
+my $maintainer_conf = 1;
 
 sub help {
 	my ($exitcode) = @_;
@@ -51,6 +53,8 @@ Options:
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
+  --c, --maintainer_prefs    use MAINTAINER C: checkpatch preferences lines
+                             default: true (disable with --noc)
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -105,6 +109,8 @@ GetOptions(
 	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
+	'maintainer_prefs!' => \$maintainer_conf,
+	'c!'		=> \$maintainer_conf,
 	'ignore=s'	=> \@ignore,
 	'show-types!'	=> \$show_types,
 	'root=s'	=> \$root,
@@ -1497,6 +1503,7 @@ sub process {
 
 	$realcnt = 0;
 	$linenr = 0;
+	my $last_realfile = "";
 	foreach my $line (@lines) {
 		$linenr++;
 
@@ -1554,11 +1561,15 @@ sub process {
 		# extract the filename as it passes
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@;
+			if (!$file) {
+				$realfile =~ s@^([^/]*)/@@;
+			}
 			$in_commit_log = 0;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@;
+			if (!$file) {
+				$realfile =~ s@^([^/]*)/@@;
+			}
 			$in_commit_log = 0;
 
 			$p1_prefix = $1;
@@ -1577,6 +1588,25 @@ sub process {
 
 		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
+		if (-f "$realfile" && -f "$root/scripts/get_maintainer.pl" &&
+		    $last_realfile ne $realfile) {
+			$last_realfile = $realfile;
+			my $m_conf = `perl $root/scripts/get_maintainer.pl -f --checkpatch --noemail --nol --nogit --nogit-fallback $realfile`;
+
+			$m_conf =~ s/\s*\n?$//g;
+			$m_conf =~ s/^\s*//g;
+			$m_conf =~ s/\s+/ /g;
+
+			if ($m_conf ne "") {
+				GetOptionsFromString($m_conf,
+						 'subjective!'	=> \$check,
+						 'strict!'	=> \$check,
+						 'ignore=s'	=> \@ignore,
+						 'show-types!'	=> \$show_types,
+						 'test-only=s'	=> \$tst_only);
+			}
+		}
+
 		my $hereline = "$here\n$rawline\n";
 		my $herecurr = "$here\n$rawline\n";
 		my $hereprev = "$here\n$prevrawline\n$rawline\n";
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 0948c6b..98e57ff 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -47,6 +47,7 @@ my $subsystem = 0;
 my $status = 0;
 my $keywords = 1;
 my $sections = 0;
+my $checkpatch = 0;
 my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
@@ -206,6 +207,7 @@ if (!GetOptions(
 		'status!' => \$status,
 		'scm!' => \$scm,
 		'web!' => \$web,
+		'checkpatch!' => \$checkpatch,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
 		'sections!' => \$sections,
@@ -243,12 +245,13 @@ if ($sections) {
     $status = 0;
     $subsystem = 0;
     $web = 0;
+    $checkpatch = 0;
     $keywords = 0;
     $interactive = 0;
 } else {
-    my $selections = $email + $scm + $status + $subsystem + $web;
+    my $selections = $email + $scm + $status + $subsystem + $web + $checkpatch;
     if ($selections == 0) {
-	die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+	die "$P:  Missing required option: email, scm, status, subsystem, web or checkpatch\n";
     }
 }
 
@@ -469,6 +472,7 @@ my %hash_list_to;
 my @list_to = ();
 my @scm = ();
 my @web = ();
+my @checkpatch = ();
 my @subsystem = ();
 my @status = ();
 my %deduplicate_name_hash = ();
@@ -502,6 +506,11 @@ if ($web) {
     output(@web);
 }
 
+if ($checkpatch) {
+    @checkpatch = uniq(@checkpatch);
+    output(@checkpatch);
+}
+
 exit($exit);
 
 sub range_is_maintained {
@@ -548,6 +557,7 @@ sub get_maintainers {
     @list_to = ();
     @scm = ();
     @web = ();
+    @checkpatch = ();
     @subsystem = ();
     @status = ();
     %deduplicate_name_hash = ();
@@ -751,6 +761,7 @@ MAINTAINER field selection options:
   --status => print status if any
   --subsystem => print subsystem name if any
   --web => print website(s) if any
+  --checkpatch => print checkpatch configuration if any
 
 Output type options:
   --separator [, ] => separator for multiple entries on 1 line
@@ -1060,6 +1071,8 @@ sub add_categories {
 		push(@web, $pvalue);
 	    } elsif ($ptype eq "S") {
 		push(@status, $pvalue);
+	    } elsif ($ptype eq "C") {
+		push(@checkpatch, $pvalue);
 	    }
 	}
     }


