Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYFLBtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:45 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 13/29] iwlwifi: fix resume SW RF-kill
Date: Thu, 12 Jun 2008 09:47:03 +0800
Message-Id: <1213235239-2954-14-git-send-email-yi.zhu@intel.com> (sfid-20080612_041917_280399_99888ACC)
In-Reply-To: <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch fixes SW RF-kill. If we resumed from S3 state with SW RF-kill
set, the driver wouldn't be able to remove SW RF-kill. This patch fixes
this.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   31 +++++++++++++--------------
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a86e08b..b4c9d5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -129,7 +129,7 @@ struct iwl_lib_ops {
 	/* 1st ucode load */
 	int (*load_ucode)(struct iwl_priv *priv);
 	/* rfkill */
-	void (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
+	int (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
 	 /* power management */
 	struct {
 		int (*init)(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ac68cce..54e6ac8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -725,7 +725,7 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 
 struct iwl_priv;
 
-extern void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
+extern int iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index de40e89..7a9567c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1260,12 +1260,12 @@ static void iwl4965_set_rate(struct iwl_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
+int iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 {
 	unsigned long flags;
 
 	if (!!disable_radio == test_bit(STATUS_RF_KILL_SW, &priv->status))
-		return;
+		return 0;
 
 	IWL_DEBUG_RF_KILL("Manual SW RF KILL set to: RADIO %s\n",
 			  disable_radio ? "OFF" : "ON");
@@ -1290,7 +1290,7 @@ void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 			if (priv->mac80211_registered)
 				ieee80211_stop_queues(priv->hw);
 		}
-		return;
+		return 0;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1311,11 +1311,11 @@ void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
 		IWL_DEBUG_RF_KILL("Can not turn radio back on - "
 				  "disabled by HW switch\n");
-		return;
+		return 0;
 	}
 
 	queue_work(priv->workqueue, &priv->restart);
-	return;
+	return 1;
 }
 
 #define IWL_PACKET_RETRY_TIME HZ
@@ -3028,13 +3028,6 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		return -EIO;
 	}
 
-	if (test_bit(STATUS_RF_KILL_SW, &priv->status)) {
-		IWL_WARNING("Radio disabled by SW RF kill (module "
-			    "parameter)\n");
-		iwl_rfkill_set_hw_state(priv);
-		return -ENODEV;
-	}
-
 	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
 		IWL_ERROR("ucode not available for device bringup\n");
 		return -EIO;
@@ -3088,7 +3081,8 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	       priv->ucode_data.len);
 
 	/* We return success when we resume from suspend and rf_kill is on. */
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status))
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+	    test_bit(STATUS_RF_KILL_SW, &priv->status))
 		return 0;
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
@@ -3115,6 +3109,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	__iwl4965_down(priv);
+	clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
@@ -3860,6 +3855,13 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
+
+	if (priv->cfg->ops->lib->radio_kill_sw &&
+	    priv->cfg->ops->lib->radio_kill_sw(priv, !conf->radio_enabled)) {
+		IWL_DEBUG_MAC80211("leave - RF-KILL - waiting for uCode\n");
+		mutex_unlock(&priv->mutex);
+	}
+
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		ret = -EIO;
@@ -3912,9 +3914,6 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	}
 #endif
 
-	if (priv->cfg->ops->lib->radio_kill_sw)
-		priv->cfg->ops->lib->radio_kill_sw(priv, !conf->radio_enabled);
-
 	if (!conf->radio_enabled) {
 		IWL_DEBUG_MAC80211("leave - radio disabled\n");
 		goto out;
-- 
1.5.3.6

