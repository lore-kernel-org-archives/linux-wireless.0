Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34134 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FYIZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 04:25:51 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20456.8273.928519.179413@gargle.gargle.HOWL> (sfid-20120625_102553_961209_34628380)
Date: Mon, 25 Jun 2012 13:54:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k_htc: Fix IDLE power save
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the radio enable/disable stuff and fix the
transition to FULL_SLEEP mode when the device is idle.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |  2 -
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 92 ---------------------------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 50 ++++++---------
 3 files changed, 20 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 1ee6548..936e920 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -572,8 +572,6 @@ bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
 
 void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv);
 void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw);
-void ath9k_htc_radio_enable(struct ieee80211_hw *hw);
-void ath9k_htc_radio_disable(struct ieee80211_hw *hw);
 
 #ifdef CONFIG_MAC80211_LEDS
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 3688bba..07df279 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -310,95 +310,3 @@ void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv)
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		wiphy_rfkill_start_polling(priv->hw->wiphy);
 }
-
-void ath9k_htc_radio_enable(struct ieee80211_hw *hw)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-	struct ath_hw *ah = priv->ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	int ret;
-	u8 cmd_rsp;
-
-	if (!ah->curchan)
-		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
-
-	/* Reset the HW */
-	ret = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
-	if (ret) {
-		ath_err(common,
-			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
-			ret, ah->curchan->channel);
-	}
-
-	ath9k_cmn_update_txpow(ah, priv->curtxpow, priv->txpowlimit,
-			       &priv->curtxpow);
-
-	/* Start RX */
-	WMI_CMD(WMI_START_RECV_CMDID);
-	ath9k_host_rx_init(priv);
-
-	/* Start TX */
-	htc_start(priv->htc);
-	spin_lock_bh(&priv->tx.tx_lock);
-	priv->tx.flags &= ~ATH9K_HTC_OP_TX_QUEUES_STOP;
-	spin_unlock_bh(&priv->tx.tx_lock);
-	ieee80211_wake_queues(hw);
-
-	WMI_CMD(WMI_ENABLE_INTR_CMDID);
-
-	/* Enable LED */
-	ath9k_hw_cfg_output(ah, ah->led_pin,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
-}
-
-void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-	struct ath_hw *ah = priv->ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	int ret;
-	u8 cmd_rsp;
-
-	ath9k_htc_ps_wakeup(priv);
-
-	/* Disable LED */
-	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
-	ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
-
-	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-
-	/* Stop TX */
-	ieee80211_stop_queues(hw);
-	ath9k_htc_tx_drain(priv);
-	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
-
-	/* Stop RX */
-	WMI_CMD(WMI_STOP_RECV_CMDID);
-
-	/* Clear the WMI event queue */
-	ath9k_wmi_event_drain(priv);
-
-	/*
-	 * The MIB counters have to be disabled here,
-	 * since the target doesn't do it.
-	 */
-	ath9k_hw_disable_mib_counters(ah);
-
-	if (!ah->curchan)
-		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
-
-	/* Reset the HW */
-	ret = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
-	if (ret) {
-		ath_err(common,
-			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
-			ret, ah->curchan->channel);
-	}
-
-	/* Disable the PHY */
-	ath9k_hw_phy_disable(ah);
-
-	ath9k_htc_ps_restore(priv);
-	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
-}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e7182b6..374c32e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -75,14 +75,19 @@ unlock:
 
 void ath9k_htc_ps_restore(struct ath9k_htc_priv *priv)
 {
+	bool reset;
+
 	mutex_lock(&priv->htc_pm_lock);
 	if (--priv->ps_usecount != 0)
 		goto unlock;
 
-	if (priv->ps_idle)
+	if (priv->ps_idle) {
+		ath9k_hw_setrxabort(priv->ah, true);
+		ath9k_hw_stopdmarecv(priv->ah, &reset);
 		ath9k_hw_setpower(priv->ah, ATH9K_PM_FULL_SLEEP);
-	else if (priv->ps_enabled)
+	} else if (priv->ps_enabled) {
 		ath9k_hw_setpower(priv->ah, ATH9K_PM_NETWORK_SLEEP);
+	}
 
 unlock:
 	mutex_unlock(&priv->htc_pm_lock);
@@ -1178,24 +1183,20 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ieee80211_conf *conf = &hw->conf;
+	bool chip_reset = false;
+	int ret = 0;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-		bool enable_radio = false;
-		bool idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-
 		mutex_lock(&priv->htc_pm_lock);
-		if (!idle && priv->ps_idle)
-			enable_radio = true;
-		priv->ps_idle = idle;
-		mutex_unlock(&priv->htc_pm_lock);
 
-		if (enable_radio) {
-			ath_dbg(common, CONFIG, "not-idle: enabling radio\n");
-			ath9k_htc_setpower(priv, ATH9K_PM_AWAKE);
-			ath9k_htc_radio_enable(hw);
-		}
+		priv->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
+		if (priv->ps_idle)
+			chip_reset = true;
+
+		mutex_unlock(&priv->htc_pm_lock);
 	}
 
 	/*
@@ -1210,7 +1211,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 			ath9k_htc_remove_monitor_interface(priv);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || chip_reset) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 
@@ -1223,8 +1224,8 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 
 		if (ath9k_htc_set_channel(priv, hw, &priv->ah->channels[pos]) < 0) {
 			ath_err(common, "Unable to set channel\n");
-			mutex_unlock(&priv->mutex);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 
 	}
@@ -1246,21 +1247,10 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 				       priv->txpowlimit, &priv->curtxpow);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-		mutex_lock(&priv->htc_pm_lock);
-		if (!priv->ps_idle) {
-			mutex_unlock(&priv->htc_pm_lock);
-			goto out;
-		}
-		mutex_unlock(&priv->htc_pm_lock);
-
-		ath_dbg(common, CONFIG, "idle: disabling radio\n");
-		ath9k_htc_radio_disable(hw);
-	}
-
 out:
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
-	return 0;
+	return ret;
 }
 
 #define SUPPORTED_FILTERS			\
-- 
1.7.11

