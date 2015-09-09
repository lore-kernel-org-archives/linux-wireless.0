Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62188 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbbIIR2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 13:28:52 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath: fix incorrect PPB on JAPAN chirp radar
Date: Wed, 9 Sep 2015 10:28:44 -0700
Message-ID: <1441819724-25344-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150909_192859_121165_A583F872)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of pulses per burst on Japan chirp radar is
between 1 and 3. The previous value, 20, is representing
number of bursts, but since current DFS detector is using
pulse detection other than bursts, use the pulse number
for correct radar detection.
Also using the highest number helps to avoid false detection.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 656ce42..5aa053a 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -121,7 +121,7 @@ static const struct radar_detector_specs jp_radar_ref_types[] = {
 	JP_PATTERN(4, 0, 5, 150, 230, 1, 23, 50, false),
 	JP_PATTERN(5, 6, 10, 200, 500, 1, 16, 50, false),
 	JP_PATTERN(6, 11, 20, 200, 500, 1, 12, 50, false),
-	JP_PATTERN(7, 50, 100, 1000, 2000, 1, 20, 50, false),
+	JP_PATTERN(7, 50, 100, 1000, 2000, 1, 3, 50, false),
 	JP_PATTERN(5, 0, 1, 333, 333, 1, 9, 50, false),
 };
 
-- 
1.9.1

