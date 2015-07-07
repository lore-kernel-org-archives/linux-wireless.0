Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35700 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbbGGIHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 04:07:32 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Update regulatory rules for Taiwan (TW)
Date: Tue,  7 Jul 2015 16:07:15 +0800
Message-Id: <1436256435-25048-1-git-send-email-wens@csie.org> (sfid-20150707_100743_638367_7E353868)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taiwan's Ministry of Transportation and Communications revised its
frequency allocation rules [1], specifically opening up 5.15 GHz ~
5.25 GHz and 5.6 GHz ~ 5.65 GHz for U-NII applications, as well as
explicitly mentioning U-NII applications and DFS requirements for
the related frequency ranges.

LP0002 [2], the technical standard for low power radio devices, hasn't
been updated,though work is under way. The NCC, Taiwan's equivalent of
the US FCC, has explicitly [3][4] allowed certification under the newest
FCC Part 15E limitations, though unwanted emissions must still conform
to LP0002 sections 2.7 ~ 2.8:

  - 5150 MHz ~ 5250 MHz is not restricted to indoor usage.

  - 5250 MHz ~ 5350 MHz and 5470 MHz ~ 5725 MHz devices should have DFS
    capabilities, and conform to latest FCC radar standards.

  - 5250 MHz ~ 5350 MHz without DFS capabilities are limited to indoor
    usage, under current LP0002 restrictions.

In addition, large channels across multiple U-NII bands are allowed
under the same rules as FCC KDB 644545 [5].

This patch updates the regulatory rules for Taiwan (TW) to reflect the
changes noted above, and corrects transmit power limits for 5470 MHz ~
5725 MHz. In addition, the format of the rules has been modified:

  - List band boundaries, instead of channel boundaries, and add AUTO-BW
    for adjacent bands.

  - List maximum transmit power using mW instead of dBm. This is easier
    to find from the related documents.

[1] http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc&filedisplay=Table+of+radio+frequency+allocation.doc
[2] http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
[3] http://www.rheintech.com/our-blog/item/585-taiwan-ncc-opens-5150-5250-mhz-for-wireless-devices
[4] Proposal #10312260 (p.6, Chinese),
    http://www.etc.org.tw/_library/K00/%E9%9B%BB%E4%BF%A1%E7%B5%82%E7%AB%AF%E8%A8%AD%E5%82%99%E5%AF%A9%E9%A9%97/1031223_nccqa56.pdf
[5] Proposal #10202205 (p.3, Chinese),
    http://www.etc.org.tw/_library/K00/%E4%BD%8E%E5%8A%9F%E7%8E%87%E8%A8%AD%E5%82%99%E5%AF%A9%E9%A9%97/1020221_nccqa50.pdf

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---

Hi everyone,

First of all, I am _not_ a regulatory or wireless expert, nor is my
field of work related, unless you count deploying access points as
related.

Last week I bought and deployed a new "Tri-band" 802.11ac wireless
router, and it was using channels 36~44, which previously was not
available in Taiwan. After asking around, a friend at the vendor
said that Taiwan recently opened up that part of the spectrum.

Unfortunately, [4][5] are Q&As transcripts with the regulatory body.
I cound only find them in Chinese. Suffice to say, Taiwan's NCC
follows the FCC closely whenever possible when it comes to wireless
stuff.

As such, I also looked at the US rules. It seems they are using
"peak power spectral density" instead of "peak power output".
I believe this is wrong. My crude understanding is the former
is the amount of power in a single chunk of the complete channel,
while the latter is the actual power put out by the transmitter.
The former would be used to enforce a more uniform power distribution
over the wireless channel, while the later actually limits transmission
power, and thus range.


Regards
ChenYu

---
 db.txt | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/db.txt b/db.txt
index 809cd3c..f1c110d 100644
--- a/db.txt
+++ b/db.txt
@@ -1117,12 +1117,20 @@ country TT: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country TW: DFS-JP
-	(2402 - 2472 @ 40), (30)
-	(5270 - 5330 @ 40), (17), DFS
-	(5490 - 5590 @ 80), (30), DFS
-	(5650 - 5710 @ 40), (30), DFS
-	(5735 - 5835 @ 80), (30)
+# Source:
+# Table of Frequency Allocations of Republic of China (Taiwan) / Nov 2014:
+#   http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc& \
+#	filedisplay=Table+of+radio+frequency+allocation.doc
+# LP0002 / 28 Jun 2011:
+#   http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
+#   (section 3.10.1, 4.7)
+#
+country TW: DFS-FCC
+	(2400 - 2483.5 @ 40), (1000 mW)
+	(5150 - 5250 @ 80), (1000 mW), AUTO-BW
+	(5250 - 5350 @ 80), (250 mW), DFS, AUTO-BW
+	(5470 - 5725 @ 160), (250 mW), DFS, AUTO-BW
+	(5725 - 5850 @ 80), (1000 mW), AUTO-BW
  
 country TZ:
 	(2402 - 2482 @ 40), (20)
-- 
2.1.4

