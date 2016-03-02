Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45446 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbcCBCFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 21:05:47 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v3 8/8] ath9k: fix BTCoex configuration for SOC chips
Date: Wed,  2 Mar 2016 10:04:22 +0800
Message-Id: <1456884262-28194-9-git-send-email-miaoqing@codeaurora.org> (sfid-20160302_030559_310135_CC1026A6)
In-Reply-To: <1456884262-28194-1-git-send-email-miaoqing@codeaurora.org>
References: <1456884262-28194-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Allow to set wl_active_time and wl_qc_time for SOC chips, also adjust
bt_time_extend and bt_first_slot_time.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 31 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/btcoex.h |  1 +
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index a754f6d..80f4f4d 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -36,6 +36,8 @@ struct ath_btcoex_config {
 	u8 bt_priority_time;
 	u8 bt_first_slot_time;
 	bool bt_hold_rx_clear;
+	u8 wl_active_time;
+	u8 wl_qc_time;
 };
 
 static const u32 ar9003_wlan_weights[ATH_BTCOEX_STOMP_MAX]
@@ -67,25 +69,42 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		.bt_priority_time = 2,
 		.bt_first_slot_time = 5,
 		.bt_hold_rx_clear = true,
+		.wl_active_time = 0x20,
+		.wl_qc_time = 0x20,
 	};
 	bool rxclear_polarity = ath_bt_config.bt_rxclear_polarity;
+	u8 time_extend = ath_bt_config.bt_time_extend;
+	u8 first_slot_time = ath_bt_config.bt_first_slot_time;
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		rxclear_polarity = !ath_bt_config.bt_rxclear_polarity;
 
+	if (AR_SREV_SOC(ah)) {
+		first_slot_time = 0x1d;
+		time_extend = 0xa;
+
+		btcoex_hw->bt_coex_mode3 =
+			SM(ath_bt_config.wl_active_time, AR_BT_WL_ACTIVE_TIME) |
+			SM(ath_bt_config.wl_qc_time, AR_BT_WL_QC_TIME);
+
+		btcoex_hw->bt_coex_mode2 =
+			AR_BT_PROTECT_BT_AFTER_WAKEUP |
+			AR_BT_PHY_ERR_BT_COLL_ENABLE;
+	}
+
 	btcoex_hw->bt_coex_mode =
 		(btcoex_hw->bt_coex_mode & AR_BT_QCU_THRESH) |
-		SM(ath_bt_config.bt_time_extend, AR_BT_TIME_EXTEND) |
+		SM(time_extend, AR_BT_TIME_EXTEND) |
 		SM(ath_bt_config.bt_txstate_extend, AR_BT_TXSTATE_EXTEND) |
 		SM(ath_bt_config.bt_txframe_extend, AR_BT_TX_FRAME_EXTEND) |
 		SM(ath_bt_config.bt_mode, AR_BT_MODE) |
 		SM(ath_bt_config.bt_quiet_collision, AR_BT_QUIET) |
 		SM(rxclear_polarity, AR_BT_RX_CLEAR_POLARITY) |
 		SM(ath_bt_config.bt_priority_time, AR_BT_PRIORITY_TIME) |
-		SM(ath_bt_config.bt_first_slot_time, AR_BT_FIRST_SLOT_TIME) |
+		SM(first_slot_time, AR_BT_FIRST_SLOT_TIME) |
 		SM(qnum, AR_BT_QCU_THRESH);
 
-	btcoex_hw->bt_coex_mode2 =
+	btcoex_hw->bt_coex_mode2 |=
 		SM(ath_bt_config.bt_hold_rx_clear, AR_BT_HOLD_RX_CLEAR) |
 		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
 		AR_BT_DISABLE_BT_ANT;
@@ -308,9 +327,15 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 	 * Program coex mode and weight registers to
 	 * enable coex 3-wire
 	 */
+	if (AR_SREV_SOC(ah))
+		REG_CLR_BIT(ah, AR_BT_COEX_MODE2, AR_BT_PHY_ERR_BT_COLL_ENABLE);
+
 	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex->bt_coex_mode);
 	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex->bt_coex_mode2);
 
+	if (AR_SREV_SOC(ah))
+		REG_WRITE(ah, AR_BT_COEX_MODE3, btcoex->bt_coex_mode3);
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS0, btcoex->wlan_weight[0]);
 		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS1, btcoex->wlan_weight[1]);
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 0f7c4e6..1bdfa84 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -115,6 +115,7 @@ struct ath_btcoex_hw {
 	u32 bt_coex_mode; 	/* Register setting for AR_BT_COEX_MODE */
 	u32 bt_coex_weights; 	/* Register setting for AR_BT_COEX_WEIGHT */
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
+	u32 bt_coex_mode3;	/* Register setting for AR_BT_COEX_MODE3 */
 	u32 bt_weight[AR9300_NUM_BT_WEIGHTS];
 	u32 wlan_weight[AR9300_NUM_WLAN_WEIGHTS];
 	u8 tx_prio[ATH_BTCOEX_STOMP_MAX];
-- 
1.9.1

