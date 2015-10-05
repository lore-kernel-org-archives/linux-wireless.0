Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:44556 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbJEQPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 12:15:21 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 4/5] wireless-regdb: Add U-NII-1 (5150 ~ 5250 MHz) band for Taiwan (TW)
Date: Tue,  6 Oct 2015 00:14:57 +0800
Message-Id: <1444061698-16384-5-git-send-email-wens@csie.org> (sfid-20151005_181525_959430_FB09E7AD)
In-Reply-To: <1444061698-16384-1-git-send-email-wens@csie.org>
References: <1444061698-16384-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taiwan's Ministry of Transportation and Communications revised its
frequency allocation rules [1] on 2014/11/17, opening up 5150 ~ 5250
MHz to U-NII applications.

Taiwan's regulatory body, NCC, officially stated [3][4] that until
the technical regulatory standard [2] are updated to cover this part
of the spectrum, FCC rules (part 15E, 15.407, effective 2014/06/02)
shall serve in its place.

Also add AUTO-BW to this and the next (5250 ~ 5350 MHz) rule, so the
system can actually use VHT160 channels spanning these two rules.

[1] http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc&filedisplay=Table+of+radio+frequency+allocation.doc
[2] http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
[3] http://www.rheintech.com/our-blog/item/585-taiwan-ncc-opens-5150-5250-mhz-for-wireless-devices
[4] Proposal #10312260 (p.6, Chinese),
    http://www.etc.org.tw/_library/K00/%E9%9B%BB%E4%BF%A1%E7%B5%82%E7%AB%AF%E8%A8%AD%E5%82%99%E5%AF%A9%E9%A9%97/1031223_nccqa56.pdf

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index ee6eaad..cea78d8 100644
--- a/db.txt
+++ b/db.txt
@@ -1127,7 +1127,9 @@ country TT: DFS-FCC
 #   (section 3.10.1, 4.7)
 country TW: DFS-JP
 	(2400 - 2483.5 @ 40), (30)
-	(5250 - 5350 @ 80), (17), DFS
+	# Follow US 5.15 ~ 5.25 GHz: 30 dBm for master mode, 23 dBm for clients
+	(5150 - 5250 @ 80), (23), AUTO-BW
+	(5250 - 5350 @ 80), (17), DFS, AUTO-BW
 	(5470 - 5725 @ 160), (23), DFS
 	(5725 - 5850 @ 80), (30)
  
-- 
2.5.3

