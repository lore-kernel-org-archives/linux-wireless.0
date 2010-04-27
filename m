Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11195 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0D0Hfu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 03:35:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 00:35:50 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k_htc: Handle CONF_IDLE during unassociated state to save power.
Date: Tue, 27 Apr 2010 13:05:37 +0530
Message-ID: <1272353738-17084-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   71 ++++++++++++++++++-------
 2 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b771e20..1ae18bb 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -379,6 +379,7 @@ struct ath9k_htc_priv {
 	struct mutex htc_pm_lock;
 	unsigned long ps_usecount;
 	bool ps_enabled;
+	bool ps_idle;
 
 	struct ath_led radio_led;
 	struct ath_led assoc_led;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 9c9f3e0..26d5f22 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -94,8 +94,11 @@ void ath9k_htc_ps_restore(struct ath9k_htc_priv *priv)
 	if (--priv->ps_usecount != 0)
 		goto unlock;
 
-	if (priv->ps_enabled)
+	if (priv->ps_idle)
+		ath9k_hw_setpower(priv->ah, ATH9K_PM_FULL_SLEEP);
+	else if (priv->ps_enabled)
 		ath9k_hw_setpower(priv->ah, ATH9K_PM_NETWORK_SLEEP);
+
 unlock:
 	mutex_unlock(&priv->htc_pm_lock);
 }
@@ -1097,7 +1100,7 @@ fail_tx:
 	return 0;
 }
 
-static int ath9k_htc_start(struct ieee80211_hw *hw)
+static int ath9k_htc_radio_enable(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
@@ -1113,8 +1116,6 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 		  "Starting driver with initial channel: %d MHz\n",
 		  curchan->center_freq);
 
-	mutex_lock(&priv->mutex);
-
 	/* setup initial channel */
 	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
@@ -1127,7 +1128,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d "
 			  "(freq %u MHz)\n", ret, curchan->center_freq);
-		goto mutex_unlock;
+		return ret;
 	}
 
 	ath_update_txpow(priv);
@@ -1135,16 +1136,8 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	mode = ath9k_htc_get_curmode(priv, init_channel);
 	htc_mode = cpu_to_be16(mode);
 	WMI_CMD_BUF(WMI_SET_MODE_CMDID, &htc_mode);
-	if (ret)
-		goto mutex_unlock;
-
 	WMI_CMD(WMI_ATH_INIT_CMDID);
-	if (ret)
-		goto mutex_unlock;
-
 	WMI_CMD(WMI_START_RECV_CMDID);
-	if (ret)
-		goto mutex_unlock;
 
 	ath9k_host_rx_init(priv);
 
@@ -1157,12 +1150,22 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	ieee80211_wake_queues(hw);
 
-mutex_unlock:
+	return ret;
+}
+
+static int ath9k_htc_start(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	int ret = 0;
+
+	mutex_lock(&priv->mutex);
+	ret = ath9k_htc_radio_enable(hw);
 	mutex_unlock(&priv->mutex);
+
 	return ret;
 }
 
-static void ath9k_htc_stop(struct ieee80211_hw *hw)
+static void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
@@ -1170,11 +1173,8 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	int ret = 0;
 	u8 cmd_rsp;
 
-	mutex_lock(&priv->mutex);
-
 	if (priv->op_flags & OP_INVALID) {
 		ath_print(common, ATH_DBG_ANY, "Device not present\n");
-		mutex_unlock(&priv->mutex);
 		return;
 	}
 
@@ -1209,11 +1209,20 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	}
 
 	priv->op_flags |= OP_INVALID;
-	mutex_unlock(&priv->mutex);
 
 	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
+static void ath9k_htc_stop(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+
+	mutex_lock(&priv->mutex);
+	ath9k_htc_radio_disable(hw);
+	mutex_unlock(&priv->mutex);
+}
+
+
 static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -1327,6 +1336,23 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&priv->mutex);
 
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		bool enable_radio = false;
+		bool idle = !!(conf->flags & IEEE80211_CONF_IDLE);
+
+		if (!idle && priv->ps_idle)
+			enable_radio = true;
+
+		priv->ps_idle = idle;
+
+		if (enable_radio) {
+			ath9k_htc_setpower(priv, ATH9K_PM_AWAKE);
+			ath9k_htc_radio_enable(hw);
+			ath_print(common, ATH_DBG_CONFIG,
+				  "not-idle: enabling radio\n");
+		}
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
@@ -1370,6 +1396,13 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
+	if (priv->ps_idle) {
+		ath_print(common, ATH_DBG_CONFIG,
+			  "idle: disabling radio\n");
+		ath9k_htc_radio_disable(hw);
+	}
+
+
 	mutex_unlock(&priv->mutex);
 
 	return 0;
-- 
1.7.0.5

