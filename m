Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:36142 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbbGWDdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 23:33:12 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/5] wireless-regdb: Update U-NII-2c (5470 ~ 5725 MHz) rules for Taiwan (TW)
Date: Thu, 23 Jul 2015 11:32:56 +0800
Message-Id: <1437622380-4154-2-git-send-email-wens@csie.org> (sfid-20150723_053322_010649_38896669)
In-Reply-To: <1437622380-4154-1-git-send-email-wens@csie.org>
References: <1437622380-4154-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taiwan's Ministry of Transportation and Communications revised its
frequency allocation rules [1] on 2014/11/17, allowing usage of 5600 ~
5650 MHz, previously allocated to weather radars, to U-NII applications
with DFS support.

Also, the technical regulations [2] show that for 5470 ~ 5725 MHz U-NII
applications, the peak transmit power shall not exceed the lesser of
250 mW (slightly less than 24 dBm) or 11 dBm + 10log B, where B is the
26dB emission bandwidth in MHz. This is slightly more than 23 dBm for
20 MHz channels.

This patch updates both. Also add links to the two documents into the
database.

[1] http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc&filedisplay=Table+of+radio+frequency+allocation.doc
[2] http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 982db34..5114557 100644
--- a/db.txt
+++ b/db.txt
@@ -1118,11 +1118,17 @@ country TT: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Source:
+# Table of Frequency Allocations of Republic of China (Taiwan) / Nov 2014:
+#   http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc& \
+#      filedisplay=Table+of+radio+frequency+allocation.doc
+# LP0002 Low-power Radio-frequency Devices Technical Regulations / 28 Jun 2011:
+#   http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
+#   (section 3.10.1, 4.7)
 country TW: DFS-JP
 	(2402 - 2472 @ 40), (30)
 	(5270 - 5330 @ 40), (17), DFS
-	(5490 - 5590 @ 80), (30), DFS
-	(5650 - 5710 @ 40), (30), DFS
+	(5470 - 5725 @ 160), (23), DFS
 	(5735 - 5835 @ 80), (30)
  
 country TZ:
-- 
2.1.4

