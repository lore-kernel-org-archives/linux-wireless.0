Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55321 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaLOS4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 13:56:14 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath: fix incorrect PPB on FCC radar type 5
Date: Mon, 15 Dec 2014 10:55:34 -0800
Message-ID: <1418669734-12921-1-git-send-email-poh@qca.qualcomm.com> (sfid-20141215_195630_235661_A5B4111B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The minimum number of pulses per burst on FCC radar type 5 is 1.
Use this number for correct radar detection.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index cfd0554..3d57f87 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -86,7 +86,7 @@ static const struct radar_detector_specs fcc_radar_ref_types[] = {
 	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23),
 	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16),
 	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12),
-	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 20),
+	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 1),
 	FCC_PATTERN(5, 0, 1, 333, 333, 1, 9),
 };
 
-- 
1.9.1

