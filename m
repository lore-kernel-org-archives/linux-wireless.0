Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42265 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0FAKNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 06:13:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 03:13:49 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.56739.241097.251251@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:44:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/13] ath9k_htc: Revamp CONF_IDLE handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch revamps IDLE power save handling in the driver.
Two separate functions (radio enable/disable) are introduced,
because the semantics of radio handling is just not the same
as the start()/stop() callbacks. For example, the HW must not
be disabled, instead, the PHY has to be disabled in radio_disable().
Also, the HW has to be reset properly in radio enable/disable and
certain registers have to be programmed only once, in the
start() callback.

The radio_enable() routine doesn't need the PS wrappers since
we set the HW power mode to AWAKE anyway before calling it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  129 ++++++++++++++++++-------
 1 files changed, 93 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 340d281..08afd6e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1052,6 +1052,89 @@ void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv)
 		wiphy_rfkill_start_polling(priv->hw->wiphy);
 }
 
+static void ath9k_htc_radio_enable(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int ret;
+	u8 cmd_rsp;
+
+	if (!ah->curchan)
+		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
+
+	/* Reset the HW */
+	ret = ath9k_hw_reset(ah, ah->curchan, false);
+	if (ret) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to reset hardware; reset status %d "
+			  "(freq %u MHz)\n", ret, ah->curchan->channel);
+	}
+
+	ath_update_txpow(priv);
+
+	/* Start RX */
+	WMI_CMD(WMI_START_RECV_CMDID);
+	ath9k_host_rx_init(priv);
+
+	/* Start TX */
+	htc_start(priv->htc);
+	spin_lock_bh(&priv->tx_lock);
+	priv->tx_queues_stop = false;
+	spin_unlock_bh(&priv->tx_lock);
+	ieee80211_wake_queues(hw);
+
+	WMI_CMD(WMI_ENABLE_INTR_CMDID);
+
+	/* Enable LED */
+	ath9k_hw_cfg_output(ah, ah->led_pin,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
+}
+
+static void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int ret;
+	u8 cmd_rsp;
+
+	ath9k_htc_ps_wakeup(priv);
+
+	/* Disable LED */
+	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
+	ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
+
+	WMI_CMD(WMI_DISABLE_INTR_CMDID);
+
+	/* Stop TX */
+	ieee80211_stop_queues(hw);
+	htc_stop(priv->htc);
+	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
+	skb_queue_purge(&priv->tx_queue);
+
+	/* Stop RX */
+	WMI_CMD(WMI_STOP_RECV_CMDID);
+
+	if (!ah->curchan)
+		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
+
+	/* Reset the HW */
+	ret = ath9k_hw_reset(ah, ah->curchan, false);
+	if (ret) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to reset hardware; reset status %d "
+			  "(freq %u MHz)\n", ret, ah->curchan->channel);
+	}
+
+	/* Disable the PHY */
+	ath9k_hw_phy_disable(ah);
+
+	ath9k_htc_ps_restore(priv);
+	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
+}
+
 /**********************/
 /* mac80211 Callbacks */
 /**********************/
@@ -1097,7 +1180,7 @@ fail_tx:
 	return 0;
 }
 
-static int ath9k_htc_radio_enable(struct ieee80211_hw *hw, bool led)
+static int ath9k_htc_start(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
@@ -1109,6 +1192,8 @@ static int ath9k_htc_radio_enable(struct ieee80211_hw *hw, bool led)
 	__be16 htc_mode;
 	u8 cmd_rsp;
 
+	mutex_lock(&priv->mutex);
+
 	ath_print(common, ATH_DBG_CONFIG,
 		  "Starting driver with initial channel: %d MHz\n",
 		  curchan->center_freq);
@@ -1125,6 +1210,7 @@ static int ath9k_htc_radio_enable(struct ieee80211_hw *hw, bool led)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d "
 			  "(freq %u MHz)\n", ret, curchan->center_freq);
+		mutex_unlock(&priv->mutex);
 		return ret;
 	}
 
@@ -1145,31 +1231,14 @@ static int ath9k_htc_radio_enable(struct ieee80211_hw *hw, bool led)
 	priv->tx_queues_stop = false;
 	spin_unlock_bh(&priv->tx_lock);
 
-	if (led) {
-		/* Enable LED */
-		ath9k_hw_cfg_output(ah, ah->led_pin,
-				    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-		ath9k_hw_set_gpio(ah, ah->led_pin, 0);
-	}
-
 	ieee80211_wake_queues(hw);
 
-	return ret;
-}
-
-static int ath9k_htc_start(struct ieee80211_hw *hw)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-	int ret = 0;
-
-	mutex_lock(&priv->mutex);
-	ret = ath9k_htc_radio_enable(hw, false);
 	mutex_unlock(&priv->mutex);
 
 	return ret;
 }
 
-static void ath9k_htc_radio_disable(struct ieee80211_hw *hw, bool led)
+static void ath9k_htc_stop(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
@@ -1177,17 +1246,14 @@ static void ath9k_htc_radio_disable(struct ieee80211_hw *hw, bool led)
 	int ret = 0;
 	u8 cmd_rsp;
 
+	mutex_lock(&priv->mutex);
+
 	if (priv->op_flags & OP_INVALID) {
 		ath_print(common, ATH_DBG_ANY, "Device not present\n");
+		mutex_unlock(&priv->mutex);
 		return;
 	}
 
-	if (led) {
-		/* Disable LED */
-		ath9k_hw_set_gpio(ah, ah->led_pin, 1);
-		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
-	}
-
 	/* Cancel all the running timers/work .. */
 	cancel_work_sync(&priv->ps_work);
 	cancel_delayed_work_sync(&priv->ath9k_ani_work);
@@ -1221,18 +1287,9 @@ static void ath9k_htc_radio_disable(struct ieee80211_hw *hw, bool led)
 	priv->op_flags |= OP_INVALID;
 
 	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");
-}
-
-static void ath9k_htc_stop(struct ieee80211_hw *hw)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-
-	mutex_lock(&priv->mutex);
-	ath9k_htc_radio_disable(hw, false);
 	mutex_unlock(&priv->mutex);
 }
 
-
 static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -1348,7 +1405,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 
 		if (enable_radio) {
 			ath9k_htc_setpower(priv, ATH9K_PM_AWAKE);
-			ath9k_htc_radio_enable(hw, true);
+			ath9k_htc_radio_enable(hw);
 			ath_print(common, ATH_DBG_CONFIG,
 				  "not-idle: enabling radio\n");
 		}
@@ -1396,7 +1453,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 	if (priv->ps_idle) {
 		ath_print(common, ATH_DBG_CONFIG,
 			  "idle: disabling radio\n");
-		ath9k_htc_radio_disable(hw, true);
+		ath9k_htc_radio_disable(hw);
 	}
 
 	mutex_unlock(&priv->mutex);
-- 
1.7.1

