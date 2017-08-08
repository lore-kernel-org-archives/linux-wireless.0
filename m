Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:45586 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751891AbdHHDiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 23:38:15 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wireless-regdb: Update regulatory document references for Taiwan (TW)
Date: Tue,  8 Aug 2017 11:38:03 +0800
Message-Id: <20170808033804.6053-1-wens@csie.org> (sfid-20170808_054016_933604_C5B57E3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taiwan's Ministry of Transportation and Communications updated its
frequency allocation rules again on 2017/02/22. The amended articles
are not related to this database, but the link should be kept up to
date, as the old one is no longer accessible.

Taiwan's regulatory body, NCC, published its updated technical
regulatory standard for low-power radio frequency devices, LP0002.
The URL has not changed. The new standard opens up more bandwidth
for 5g U-NII WiFi and 60g WiGig devices. Transmission power for
5.25 ~ 5.35 GHz is also increased, but this was already covered
in commit 9a618d9b5fb2 ("wireless-regdb: Update 5 GHz rules for
Taiwan (TW) to follow US").

This patch updates the link and comments for the rules and standards,
and also adds inline comments referencing the governing section of the
LP0002 standard for each band.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/db.txt b/db.txt
index 0bc068e..d96f00e 100644
--- a/db.txt
+++ b/db.txt
@@ -1174,15 +1174,16 @@ country TT: DFS-FCC
 	(5735 - 5835 @ 80), (30)
 
 # Source:
-# Table of Frequency Allocations of Republic of China (Taiwan) / Nov 2014:
-#   http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc& \
-#      filedisplay=Table+of+radio+frequency+allocation.doc
-# LP0002 Low-power Radio-frequency Devices Technical Regulations / 28 Jun 2011:
+# Table of Frequency Allocations of Republic of China (Taiwan) / Feb 2017:
+#   https://www.motc.gov.tw/websitedowndoc?file=post/201702221012200.doc& \
+#	filedisplay=Table%2Bof%2Bradio%2Bfrequency%2Ballocation.doc
+# LP0002 Low-power Radio-frequency Devices Technical Regulations / 23 Aug 2016:
 #   http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
-#   (section 3.10.1, 4.7)
 country TW: DFS-FCC
+	# 2.4g band, LP0002 section 3.10.1
 	(2400 - 2483.5 @ 40), (30)
-	# Follow US 5.15 ~ 5.25 GHz: 30 dBm for master mode, 23 dBm for clients
+	# 5g U-NII band, LP0002 section 4.7
+	# 5.15 ~ 5.25 GHz: 30 dBm for master mode, 23 dBm for clients
 	(5150 - 5250 @ 80), (23), AUTO-BW
 	(5250 - 5350 @ 80), (23), DFS, AUTO-BW
 	(5470 - 5725 @ 160), (23), DFS
-- 
2.13.3
