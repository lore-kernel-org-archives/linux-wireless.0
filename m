Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48856 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaKXJjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 04:39:39 -0500
From: Vivek Natarajan <nataraja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath: Fix a false radar detection pattern
Date: Mon, 24 Nov 2014 15:08:50 +0530
Message-ID: <1416821930-3003-2-git-send-email-nataraja@qti.qualcomm.com> (sfid-20141124_104000_294646_12A818B1)
In-Reply-To: <1416821930-3003-1-git-send-email-nataraja@qti.qualcomm.com>
References: <1416821930-3003-1-git-send-email-nataraja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For FCC and JP, in one of the radar patterns, PPB and PRF seems to be
interchanged leading to frequent incorrect radar detections.

Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 7a16686..0e383ef 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -86,7 +86,7 @@ static const struct radar_detector_specs fcc_radar_ref_types[] = {
 	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23),
 	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16),
 	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12),
-	FCC_PATTERN(4, 50, 100, 1000, 2000, 20, 1),
+	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 20),
 	FCC_PATTERN(5, 0, 1, 333, 333, 1, 9),
 };
 
@@ -105,7 +105,7 @@ static const struct radar_detector_specs jp_radar_ref_types[] = {
 	JP_PATTERN(4, 0, 5, 150, 230, 1, 23),
 	JP_PATTERN(5, 6, 10, 200, 500, 1, 16),
 	JP_PATTERN(6, 11, 20, 200, 500, 1, 12),
-	JP_PATTERN(7, 50, 100, 1000, 2000, 20, 1),
+	JP_PATTERN(7, 50, 100, 1000, 2000, 1, 20),
 	JP_PATTERN(5, 0, 1, 333, 333, 1, 9),
 };
 
-- 
1.7.9.5

