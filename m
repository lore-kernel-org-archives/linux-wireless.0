Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755878AbcKXGxg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 01:53:36 -0500
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 2/3] ath9k: export configurable parameters of PTA
Date: Thu, 24 Nov 2016 14:53:21 +0800
Message-Id: <1479970402-13796-2-git-send-email-miaoqing@codeaurora.org> (sfid-20161124_075339_340257_70AD7B9E)
In-Reply-To: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org>
References: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Export time_extend, pritority_time, first_slot_time, wl_active_time
and wl_qc_time those PTA(aka slotted mode) configurable parameters,
allow user to change/debug the timing easily.

Also set wl_active_time and wl_qc_time default value to 0, as in this
period WLAN chip may send out ACK, and it will corrupt the BT(or other)
received packet in the PTA cycle.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 62 ++++++++-------------------------
 drivers/net/wireless/ath/ath9k/btcoex.h |  9 +++++
 drivers/net/wireless/ath/ath9k/init.c   | 26 ++++++++++++++
 3 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 618c9df..6d15dd3 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -26,20 +26,6 @@ enum ath_bt_mode {
 	ATH_BT_COEX_MODE_DISABLED,      /* coexistence disabled */
 };
 
-struct ath_btcoex_config {
-	u8 bt_time_extend;
-	bool bt_txstate_extend;
-	bool bt_txframe_extend;
-	enum ath_bt_mode bt_mode; /* coexistence mode */
-	bool bt_quiet_collision;
-	bool bt_rxclear_polarity; /* invert rx_clear as WLAN_ACTIVE*/
-	u8 bt_priority_time;
-	u8 bt_first_slot_time;
-	bool bt_hold_rx_clear;
-	u8 wl_active_time;
-	u8 wl_qc_time;
-};
-
 static const u32 ar9003_wlan_weights[ATH_BTCOEX_STOMP_MAX]
 				    [AR9300_NUM_WLAN_WEIGHTS] = {
 	{ 0xfffffff0, 0xfffffff0, 0xfffffff0, 0xfffffff0 }, /* STOMP_ALL */
@@ -59,33 +45,16 @@ struct ath_btcoex_config {
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-	const struct ath_btcoex_config ath_bt_config = {
-		.bt_time_extend = 0,
-		.bt_txstate_extend = true,
-		.bt_txframe_extend = true,
-		.bt_mode = ATH_BT_COEX_MODE_SLOTTED,
-		.bt_quiet_collision = true,
-		.bt_rxclear_polarity = true,
-		.bt_priority_time = 2,
-		.bt_first_slot_time = 5,
-		.bt_hold_rx_clear = true,
-		.wl_active_time = 0x20,
-		.wl_qc_time = 0x20,
-	};
-	bool rxclear_polarity = ath_bt_config.bt_rxclear_polarity;
-	u8 time_extend = ath_bt_config.bt_time_extend;
-	u8 first_slot_time = ath_bt_config.bt_first_slot_time;
+	struct ath_btcoex_config *config = &btcoex_hw->config;
+	bool rxclear_polarity = true;
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
-		rxclear_polarity = !ath_bt_config.bt_rxclear_polarity;
+		rxclear_polarity = false;
 
 	if (AR_SREV_SOC(ah)) {
-		first_slot_time = 0x1d;
-		time_extend = 0xa;
-
 		btcoex_hw->bt_coex_mode3 =
-			SM(ath_bt_config.wl_active_time, AR_BT_WL_ACTIVE_TIME) |
-			SM(ath_bt_config.wl_qc_time, AR_BT_WL_QC_TIME);
+			SM(config->wl_active_time, AR_BT_WL_ACTIVE_TIME) |
+			SM(config->wl_qc_time, AR_BT_WL_QC_TIME);
 
 		btcoex_hw->bt_coex_mode2 =
 			AR_BT_PROTECT_BT_AFTER_WAKEUP |
@@ -93,21 +62,20 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 	}
 
 	btcoex_hw->bt_coex_mode =
-		(btcoex_hw->bt_coex_mode & AR_BT_QCU_THRESH) |
-		SM(time_extend, AR_BT_TIME_EXTEND) |
-		SM(ath_bt_config.bt_txstate_extend, AR_BT_TXSTATE_EXTEND) |
-		SM(ath_bt_config.bt_txframe_extend, AR_BT_TX_FRAME_EXTEND) |
-		SM(ath_bt_config.bt_mode, AR_BT_MODE) |
-		SM(ath_bt_config.bt_quiet_collision, AR_BT_QUIET) |
+		AR_BT_TXSTATE_EXTEND |
+		AR_BT_TX_FRAME_EXTEND |
+		AR_BT_QUIET |
+		SM(ATH_BT_COEX_MODE_SLOTTED, AR_BT_MODE) |
 		SM(rxclear_polarity, AR_BT_RX_CLEAR_POLARITY) |
-		SM(ath_bt_config.bt_priority_time, AR_BT_PRIORITY_TIME) |
-		SM(first_slot_time, AR_BT_FIRST_SLOT_TIME) |
+		SM(config->bt_time_extend, AR_BT_TIME_EXTEND) |
+		SM(config->bt_priority_time, AR_BT_PRIORITY_TIME) |
+		SM(config->bt_first_slot_time, AR_BT_FIRST_SLOT_TIME) |
 		SM(qnum, AR_BT_QCU_THRESH);
 
 	btcoex_hw->bt_coex_mode2 |=
-		SM(ath_bt_config.bt_hold_rx_clear, AR_BT_HOLD_RX_CLEAR) |
-		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
-		AR_BT_DISABLE_BT_ANT;
+		AR_BT_HOLD_RX_CLEAR |
+		AR_BT_DISABLE_BT_ANT |
+		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH);
 }
 EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 1bdfa84..fb1ef04 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -104,6 +104,14 @@ struct ath9k_hw_aic {
 	u32 aic_cal_start_time;
 };
 
+struct ath_btcoex_config {
+	u8 bt_time_extend;
+	u8 bt_priority_time;
+	u8 bt_first_slot_time;
+	u8 wl_active_time;
+	u8 wl_qc_time;
+};
+
 struct ath_btcoex_hw {
 	enum ath_btcoex_scheme scheme;
 	struct ath9k_hw_mci mci;
@@ -119,6 +127,7 @@ struct ath_btcoex_hw {
 	u32 bt_weight[AR9300_NUM_BT_WEIGHTS];
 	u32 wlan_weight[AR9300_NUM_WLAN_WEIGHTS];
 	u8 tx_prio[ATH_BTCOEX_STOMP_MAX];
+	struct ath_btcoex_config config;
 };
 
 void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 8edd78b..74d2b7b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -77,6 +77,26 @@ struct ath9k_eeprom_ctx {
 static int ath9k_btcoex_duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
 module_param_named(btcoex_duty_cycle, ath9k_btcoex_duty_cycle, int, 0444);
 MODULE_PARM_DESC(btcoex_duty_cycle, "BT coexistence duty cycle");
+
+static int ath9k_btcoex_time_extend;
+module_param_named(btcoex_time_extend, ath9k_btcoex_time_extend, int, 0444);
+MODULE_PARM_DESC(btcoex_time_extend, "BT coexistence time extend");
+
+static int ath9k_btcoex_priority_time = 2;
+module_param_named(btcoex_priority_time, ath9k_btcoex_priority_time, int, 0444);
+MODULE_PARM_DESC(btcoex_priority_time, "BT coexistence priority time");
+
+static int ath9k_btcoex_first_slot_time = 5;
+module_param_named(btcoex_first_slot_time, ath9k_btcoex_first_slot_time, int, 0444);
+MODULE_PARM_DESC(btcoex_first_slot_time, "BT coexistence first slot time");
+
+static int ath9k_btcoex_wl_active_time;
+module_param_named(btcoex_wl_active_time, ath9k_btcoex_wl_active_time, int, 0444);
+MODULE_PARM_DESC(btcoex_wl_active_time, "BT coexistence wlan active time");
+
+static int ath9k_btcoex_wl_qc_time;
+module_param_named(btcoex_wl_qc_time, ath9k_btcoex_wl_qc_time, int, 0444);
+MODULE_PARM_DESC(btcoex_wl_qc_time, "BT coexistence wlan quiet collision time");
 #endif
 
 bool is_ath9k_unloaded;
@@ -611,7 +631,13 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	sc->btcoex.duty_cycle = ath9k_btcoex_duty_cycle;
+	ah->btcoex_hw.config.bt_time_extend = ath9k_btcoex_time_extend;
+	ah->btcoex_hw.config.bt_priority_time = ath9k_btcoex_priority_time;
+	ah->btcoex_hw.config.bt_first_slot_time = ath9k_btcoex_first_slot_time;
+	ah->btcoex_hw.config.wl_active_time = ath9k_btcoex_wl_active_time;
+	ah->btcoex_hw.config.wl_qc_time = ath9k_btcoex_wl_qc_time;
 #endif
+
 	/*
 	 * Platform quirks.
 	 */
-- 
1.9.1
