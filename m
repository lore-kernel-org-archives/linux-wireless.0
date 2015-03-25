Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32375 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbbCYRh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 13:37:56 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath: support new FCC DFS Radar Type 1
Date: Wed, 25 Mar 2015 10:37:16 -0700
Message-ID: <1427305036-20326-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150325_184637_427617_8293FD48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for new FCC DFS rules released on August 14, 2014.
FCC has added a new radar type named Radar Type 1 and original
Radar Type 1 is renamed to Radar Type 0 in consequence.

During the certificate test, Type 1 PRI values are randomly selected
within the range of 518 and 3066 and we divide it to 3 groups based on
practical test result data collected for more than a year.

For about Radar type ID, it does nothing to functionalities.
In other words, even if we re-order the IDs, DFS detection will
work as well, but we give the ID with matching to FCC doc.

By adding this support, the drivers using this DFS function are
able to support both of old and new FCC DFS rules simultaneously
without any other changes.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index b1de8c6..ac0df38 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -81,13 +81,22 @@ static const struct radar_types etsi_radar_types_v15 = {
 	PPB_THRESH(PPB), PRI_TOLERANCE,	CHIRP			\
 }
 
+/* radar types released on August 14, 2014
+ * type 1 PRI values randomly selected within the range of 518 and 3066.
+ * divide it to 3 groups is good enough for both of radar detection and
+ * avoiding false detection based on practical test results
+ * collected for more than a year.
+ */
 static const struct radar_detector_specs fcc_radar_ref_types[] = {
 	FCC_PATTERN(0, 0, 1, 1428, 1428, 1, 18, false),
-	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23, false),
-	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16, false),
-	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12, false),
-	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 1, true),
-	FCC_PATTERN(5, 0, 1, 333, 333, 1, 9, false),
+	FCC_PATTERN(101, 0, 1, 518, 938, 1, 57, false),
+	FCC_PATTERN(102, 0, 1, 938, 2000, 1, 27, false),
+	FCC_PATTERN(103, 0, 1, 2000, 3066, 1, 18, false),
+	FCC_PATTERN(2, 0, 5, 150, 230, 1, 23, false),
+	FCC_PATTERN(3, 6, 10, 200, 500, 1, 16, false),
+	FCC_PATTERN(4, 11, 20, 200, 500, 1, 12, false),
+	FCC_PATTERN(5, 50, 100, 1000, 2000, 1, 1, true),
+	FCC_PATTERN(6, 0, 1, 333, 333, 1, 9, false),
 };
 
 static const struct radar_types fcc_radar_types = {
-- 
1.9.1

