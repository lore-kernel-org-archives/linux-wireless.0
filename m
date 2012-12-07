Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:42408
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755131Ab2LGO4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 09:56:07 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: [PATCH] ath9k: Fix regression in 'xmit' debugfs file
Date: Fri,  7 Dec 2012 20:25:30 +0530
Message-Id: <1354892130-11965-1-git-send-email-sujith@msujith.org> (sfid-20121207_155611_676621_4F7CBFE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Commit "ath9k: Fix the 'xmit' debugfs file" changed the
the array size of ath_stats.txstats to IEEE80211_NUM_ACS,
which is wrong because the HW queue number is used to
update the statistics. Revert back to using ATH9K_NUM_TX_QUEUES.

Reported-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 72d4893..375c3b4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -242,7 +242,7 @@ struct ath_rx_stats {
 
 struct ath_stats {
 	struct ath_interrupt_stats istats;
-	struct ath_tx_stats txstats[IEEE80211_NUM_ACS];
+	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
 	struct ath_rx_stats rxstats;
 	struct ath_dfs_stats dfs_stats;
 	u32 reset[__RESET_TYPE_MAX];
-- 
1.8.0.1

