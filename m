Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39848 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaKQH2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 02:28:24 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Block radar events when requested
Date: Mon, 17 Nov 2014 12:59:53 +0530
Message-Id: <1416209393-24736-1-git-send-email-sujith@msujith.org> (sfid-20141117_082833_652047_BC570B01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch ensures that reporting of a radar in simulation
is not done when detection is disabled explicitly by
using the debugfs knob 'dfs_block_radar_events'.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 9147dd3..fa1accd 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1437,7 +1437,8 @@ static ssize_t ath10k_write_simulate_radar(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 
-	ieee80211_radar_detected(ar->hw);
+	if (!ar->dfs_block_radar_events)
+		ieee80211_radar_detected(ar->hw);
 
 	return count;
 }
-- 
2.1.3

