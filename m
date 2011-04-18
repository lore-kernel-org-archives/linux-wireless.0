Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab1DRRFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlagn: temperature should be measure for all _agn devices
Date: Mon, 18 Apr 2011 09:44:13 -0700
Message-Id: <1303145057-6545-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thermal throttling functions are available for all _agn devices, call the
functions directly.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c  |    5 -----
 drivers/net/wireless/iwlwifi/iwl-2000.c  |    5 -----
 drivers/net/wireless/iwlwifi/iwl-5000.c  |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-6000.c  |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-core.h  |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-power.c |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-tx.c    |    5 +----
 7 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e784456..946c7dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -214,11 +214,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	},
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
-	.tt_ops = {
-		.lower_power_detection = iwl_tt_is_low_power_state,
-		.tt_power_mode = iwl_tt_current_power_mode,
-		.ct_kill_check = iwl_check_for_ct_kill,
-	}
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index dcd6608..c8bb4a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -298,11 +298,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	},
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
-	.tt_ops = {
-		.lower_power_detection = iwl_tt_is_low_power_state,
-		.tt_power_mode = iwl_tt_current_power_mode,
-		.ct_kill_check = iwl_check_for_ct_kill,
-	}
 };
 
 static const struct iwl_ops iwl2000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 14b75f1..ced89f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -383,11 +383,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	},
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
-	.tt_ops = {
-		.lower_power_detection = iwl_tt_is_low_power_state,
-		.tt_power_mode = iwl_tt_current_power_mode,
-		.ct_kill_check = iwl_check_for_ct_kill,
-	}
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -435,11 +430,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	},
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
-	.tt_ops = {
-		.lower_power_detection = iwl_tt_is_low_power_state,
-		.tt_power_mode = iwl_tt_current_power_mode,
-		.ct_kill_check = iwl_check_for_ct_kill,
-	}
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 81881aa..ed6a0ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -323,11 +323,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	},
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
-	.tt_ops = {
-		.lower_power_detection = iwl_tt_is_low_power_state,
-		.tt_power_mode = iwl_tt_current_power_mode,
-		.ct_kill_check = iwl_check_for_ct_kill,
-	}
 };
 
 static struct iwl_lib_ops iwl6030_lib = {
@@ -377,11 +372,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	},
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
-	.tt_ops = {
-		.lower_power_detection = iwl_tt_is_low_power_state,
-		.tt_power_mode = iwl_tt_current_power_mode,
-		.ct_kill_check = iwl_check_for_ct_kill,
-	}
 };
 
 static struct iwl_nic_ops iwl6050_nic_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2e8c936..abee507 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -139,12 +139,6 @@ struct iwl_temp_ops {
 	void (*temperature)(struct iwl_priv *priv);
 };
 
-struct iwl_tt_ops {
-	bool (*lower_power_detection)(struct iwl_priv *priv);
-	u8 (*tt_power_mode)(struct iwl_priv *priv);
-	bool (*ct_kill_check)(struct iwl_priv *priv);
-};
-
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
@@ -190,9 +184,6 @@ struct iwl_lib_ops {
 	void (*dev_txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
 
 	struct iwl_debugfs_ops debugfs_ops;
-
-	/* thermal throttling */
-	struct iwl_tt_ops tt_ops;
 };
 
 struct iwl_led_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index b7cd958..595c930 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -357,12 +357,10 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
-	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
-		 priv->cfg->ops->lib->tt_ops.tt_power_mode &&
-		 priv->cfg->ops->lib->tt_ops.lower_power_detection(priv)) {
+	else if (iwl_tt_is_low_power_state(priv)) {
 		/* in thermal throttling low power state */
 		iwl_static_sleep_cmd(priv, cmd,
-		    priv->cfg->ops->lib->tt_ops.tt_power_mode(priv), dtimper);
+		    iwl_tt_current_power_mode(priv), dtimper);
 	} else if (!enabled)
 		iwl_power_sleep_cam_cmd(priv, cmd);
 	else if (priv->power_data.debug_sleep_level_override >= 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1b69507..80c3565 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -484,10 +484,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 
 		IWL_ERR(priv, "No space in command queue\n");
-		if (priv->cfg->ops->lib->tt_ops.ct_kill_check) {
-			is_ct_kill =
-				priv->cfg->ops->lib->tt_ops.ct_kill_check(priv);
-		}
+		is_ct_kill = iwl_check_for_ct_kill(priv);
 		if (!is_ct_kill) {
 			IWL_ERR(priv, "Restarting adapter due to queue full\n");
 			iwlagn_fw_error(priv, false);
-- 
1.7.0.4

