Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61697 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbbCaSRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 14:17:45 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath: lower JP W53 band DFS detection threshold around 30%
Date: Tue, 31 Mar 2015 11:16:25 -0700
Message-ID: <1427825785-21389-2-git-send-email-poh@qca.qualcomm.com> (sfid-20150331_201808_806522_B147E3EB)
In-Reply-To: <1427825785-21389-1-git-send-email-poh@qca.qualcomm.com>
References: <1427825785-21389-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Japan's W53 band requires 50% data traffic during its DFS test,
but WLAN baseband used by ath9k and ath10k is not able to achieve
current threshold rate, 50%, under the data traffic rate.
In other words, HW occasionally fails detecting radar pulses,
so that SW cannot get enough radar reports to achieve the rate.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 8d1e082..7ad1932 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -105,8 +105,8 @@ static const struct radar_types fcc_radar_types = {
 	PPB_THRESH_JP(PPB, RATE), PRI_TOLERANCE, CHIRP	\
 }
 static const struct radar_detector_specs jp_radar_ref_types[] = {
-	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, 50, false),
-	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, 50, false),
+	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, 29, false),
+	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, 29, false),
 	JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18, 50, false),
 	JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18, 50, false),
 	JP_PATTERN(4, 0, 5, 150, 230, 1, 23, 50, false),
-- 
1.9.1

