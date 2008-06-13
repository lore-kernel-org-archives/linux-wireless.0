Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4097 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbYFMHrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 03:47:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/3] iwlwifi: unify SW rf-kill flow
Date: Fri, 13 Jun 2008 15:44:55 +0800
Message-Id: <1213343095-8133-4-git-send-email-yi.zhu@intel.com> (sfid-20080613_094715_225897_3076C04F)
In-Reply-To: <1213343095-8133-3-git-send-email-yi.zhu@intel.com>
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
 <1213343095-8133-2-git-send-email-yi.zhu@intel.com>
 <1213343095-8133-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch unifies SW rf-kill flow between 4965 and 5000. It enables SW
RF-kill for 5000. This patch also solves a bug in iwl4965_mac_config:
bad mutex locking balance.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |   87 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |   13 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.h   |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   90 ++-------------------------
 7 files changed, 103 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9662fae..df345cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3388,7 +3388,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.check_version = iwl4965_eeprom_check_version,
 		.query_addr = iwlcore_eeprom_query_addr,
 	},
-	.radio_kill_sw = iwl4965_radio_kill_sw,
 	.set_power = iwl4965_set_power,
 	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl4965_update_chain_flags,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fa17cd9..eb74a40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1319,3 +1319,90 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 			cmd.critical_temperature_R);
 }
 EXPORT_SYMBOL(iwl_rf_kill_ct_config);
+
+/*
+ * CARD_STATE_CMD
+ *
+ * Use: Sets the device's internal card state to enable, disable, or halt
+ *
+ * When in the 'enable' state the card operates as normal.
+ * When in the 'disable' state, the card enters into a low power mode.
+ * When in the 'halt' state, the card is shut down and must be fully
+ * restarted to come back on.
+ */
+static int iwl_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_CARD_STATE_CMD,
+		.len = sizeof(u32),
+		.data = &flags,
+		.meta.flags = meta_flag,
+	};
+
+	return iwl_send_cmd(priv, &cmd);
+}
+
+void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	if (test_bit(STATUS_RF_KILL_SW, &priv->status))
+		return;
+
+	IWL_DEBUG_RF_KILL("Manual SW RF KILL set to: RADIO OFF\n");
+
+	iwl_scan_cancel(priv);
+	/* FIXME: This is a workaround for AP */
+	if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+		spin_lock_irqsave(&priv->lock, flags);
+		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			    CSR_UCODE_SW_BIT_RFKILL);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		/* call the host command only if no hw rf-kill set */
+		if (!test_bit(STATUS_RF_KILL_HW, &priv->status) &&
+		    iwl_is_ready(priv))
+			iwl_send_card_state(priv,
+				CARD_STATE_CMD_DISABLE, 0);
+		set_bit(STATUS_RF_KILL_SW, &priv->status);
+			/* make sure mac80211 stop sending Tx frame */
+		if (priv->mac80211_registered)
+			ieee80211_stop_queues(priv->hw);
+	}
+}
+EXPORT_SYMBOL(iwl_radio_kill_sw_disable_radio);
+
+int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	if (!test_bit(STATUS_RF_KILL_SW, &priv->status))
+		return 0;
+
+	IWL_DEBUG_RF_KILL("Manual SW RF KILL set to: RADIO ON\n");
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+
+	clear_bit(STATUS_RF_KILL_SW, &priv->status);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* wake up ucode */
+	msleep(10);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_read32(priv, CSR_UCODE_DRV_GP1);
+	if (!iwl_grab_nic_access(priv))
+		iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
+		IWL_DEBUG_RF_KILL("Can not turn radio back on - "
+				  "disabled by HW switch\n");
+		return 0;
+	}
+
+	if (priv->is_open)
+		queue_work(priv->workqueue, &priv->restart);
+	return 1;
+}
+EXPORT_SYMBOL(iwl_radio_kill_sw_enable_radio);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6626665..2838093 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -128,8 +128,6 @@ struct iwl_lib_ops {
 	int (*is_valid_rtc_data_addr)(u32 addr);
 	/* 1st ucode load */
 	int (*load_ucode)(struct iwl_priv *priv);
-	/* rfkill */
-	int (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
 	 /* power management */
 	struct {
 		int (*init)(struct iwl_priv *priv);
@@ -243,6 +241,13 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
  ****************************************************/
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 
+/*****************************************************
+ * RF -Kill - here and not in iwl-rfkill.h to be available when
+ * RF-kill subsystem is not compiled.
+ ****************************************************/
+void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv);
+int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv);
+
 /*******************************************************************************
  * Rate
  ******************************************************************************/
@@ -359,10 +364,10 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 	return iwl_is_ready(priv);
 }
 
+extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
-extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
-int iwl_send_lq_cmd(struct iwl_priv *priv,
+extern int iwl_send_lq_cmd(struct iwl_priv *priv,
 		    struct iwl_link_quality_cmd *lq, u8 flags);
 
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c508b11..81ff4c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -653,7 +653,6 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 
 struct iwl_priv;
 
-extern int iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 59c8a71..5f09874 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -55,13 +55,13 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 
 	switch (state) {
 	case RFKILL_STATE_ON:
-		priv->cfg->ops->lib->radio_kill_sw(priv, 0);
+		iwl_radio_kill_sw_enable_radio(priv);
 		/* if HW rf-kill is set dont allow ON state */
 		if (iwl_is_rfkill(priv))
 			err = -EBUSY;
 		break;
 	case RFKILL_STATE_OFF:
-		priv->cfg->ops->lib->radio_kill_sw(priv, 1);
+		iwl_radio_kill_sw_disable_radio(priv);
 		if (!iwl_is_rfkill(priv))
 			err = -EBUSY;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.h b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
index a7f04b8..b3c04db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.h
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
@@ -33,7 +33,6 @@ struct iwl_priv;
 #include <linux/rfkill.h>
 #include <linux/input.h>
 
-
 #ifdef CONFIG_IWLWIFI_RFKILL
 struct iwl_rfkill_mngr {
 	struct rfkill *rfkill;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a9da17c..f591168 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -379,28 +379,6 @@ static int iwl4965_send_bt_config(struct iwl_priv *priv)
 				sizeof(struct iwl4965_bt_cmd), &bt_cmd);
 }
 
-/*
- * CARD_STATE_CMD
- *
- * Use: Sets the device's internal card state to enable, disable, or halt
- *
- * When in the 'enable' state the card operates as normal.
- * When in the 'disable' state, the card enters into a low power mode.
- * When in the 'halt' state, the card is shut down and must be fully
- * restarted to come back on.
- */
-static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
-{
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_CARD_STATE_CMD,
-		.len = sizeof(u32),
-		.data = &flags,
-		.meta.flags = meta_flag,
-	};
-
-	return iwl_send_cmd(priv, &cmd);
-}
-
 static void iwl_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
@@ -916,65 +894,6 @@ static void iwl4965_set_rate(struct iwl_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-int iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
-{
-	unsigned long flags;
-
-	if (!!disable_radio == test_bit(STATUS_RF_KILL_SW, &priv->status))
-		return 0;
-
-	IWL_DEBUG_RF_KILL("Manual SW RF KILL set to: RADIO %s\n",
-			  disable_radio ? "OFF" : "ON");
-
-	if (disable_radio) {
-		iwl_scan_cancel(priv);
-		/* FIXME: This is a workaround for AP */
-		if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
-			spin_lock_irqsave(&priv->lock, flags);
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
-				    CSR_UCODE_SW_BIT_RFKILL);
-			spin_unlock_irqrestore(&priv->lock, flags);
-			/* call the host command only if no hw rf-kill set */
-			if (!test_bit(STATUS_RF_KILL_HW, &priv->status) &&
-			    iwl_is_ready(priv))
-				iwl4965_send_card_state(priv,
-							CARD_STATE_CMD_DISABLE,
-							0);
-			set_bit(STATUS_RF_KILL_SW, &priv->status);
-
-			/* make sure mac80211 stop sending Tx frame */
-			if (priv->mac80211_registered)
-				ieee80211_stop_queues(priv->hw);
-		}
-		return 0;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-
-	clear_bit(STATUS_RF_KILL_SW, &priv->status);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* wake up ucode */
-	msleep(10);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_read32(priv, CSR_UCODE_DRV_GP1);
-	if (!iwl_grab_nic_access(priv))
-		iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_RF_KILL("Can not turn radio back on - "
-				  "disabled by HW switch\n");
-		return 0;
-	}
-
-	if (priv->is_open)
-		queue_work(priv->workqueue, &priv->restart);
-	return 1;
-}
-
 #define IWL_PACKET_RETRY_TIME HZ
 
 int iwl4965_is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
@@ -2982,13 +2901,14 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
-
-	if (priv->cfg->ops->lib->radio_kill_sw &&
-	    priv->cfg->ops->lib->radio_kill_sw(priv, !conf->radio_enabled)) {
+	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF-KILL - waiting for uCode\n");
-		mutex_unlock(&priv->mutex);
+		goto out;
 	}
 
+	if (!conf->radio_enabled)
+		iwl_radio_kill_sw_disable_radio(priv);
+
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		ret = -EIO;
-- 
1.5.3.6

