Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYE2IhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:23 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 09/43] iwlwifi: clean up alive_start routine
Date: Thu, 29 May 2008 16:34:54 +0800
Message-Id: <1212050128-17132-10-git-send-email-yi.zhu@intel.com> (sfid-20080529_110547_485960_528B139C)
In-Reply-To: <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch cleans up alive_start routine. It removes 4965 from the common
code and moves the run time calibration reset into a common code.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   12 ------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 ----
 drivers/net/wireless/iwlwifi/iwl-calib.c    |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-calib.h    |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   19 ++++++++++---------
 5 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 063ba2e..d548bda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -921,15 +921,6 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-	memset(&(priv->sensitivity_data), 0,
-	       sizeof(struct iwl_sensitivity_data));
-	memset(&(priv->chain_noise_data), 0,
-	       sizeof(struct iwl_chain_noise_data));
-	for (i = 0; i < NUM_RX_CHAINS; i++)
-		priv->chain_noise_data.delta_gain_code[i] =
-				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
-#endif /* CONFIG_IWL4965_RUN_TIME_CALIB*/
 	ret = iwl_grab_nic_access(priv);
 	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -996,9 +987,6 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Ask for statistics now, the uCode will send statistics notification
-	 * periodically after association */
-	iwl_send_statistics_request(priv, CMD_ASYNC);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d6ffdee..0355ccd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -580,10 +580,6 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 
 	iwl5000_send_wimax_coex(priv);
 
-	/* Ask for statistics now, the uCode will send notification
-	 * periodically after association */
-	iwl_send_statistics_request(priv, CMD_ASYNC);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index beb9716..a6c7f0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -786,3 +786,21 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_chain_noise_calibration);
 
+
+void iwl_reset_run_time_calib(struct iwl_priv *priv)
+{
+	int i;
+	memset(&(priv->sensitivity_data), 0,
+	       sizeof(struct iwl_sensitivity_data));
+	memset(&(priv->chain_noise_data), 0,
+	       sizeof(struct iwl_chain_noise_data));
+	for (i = 0; i < NUM_RX_CHAINS; i++)
+		priv->chain_noise_data.delta_gain_code[i] =
+				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
+
+	/* Ask for statistics now, the uCode will send notification
+	 * periodically after association */
+	iwl_send_statistics_request(priv, CMD_ASYNC);
+}
+EXPORT_SYMBOL(iwl_reset_run_time_calib);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index e690668..b8e57c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -78,7 +78,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 				struct iwl4965_notif_statistics *resp);
 
 void iwl_init_sensitivity(struct iwl_priv *priv);
-
+void iwl_reset_run_time_calib(struct iwl_priv *priv);
 static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
 {
 
@@ -101,6 +101,9 @@ static inline void iwl_init_sensitivity(struct iwl_priv *priv)
 static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
 {
 }
+static inline void iwl_reset_run_time_calib(struct iwl_priv *priv)
+{
+}
 #endif
 
 #endif /* __iwl_calib_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6785200..5a5306d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3244,11 +3244,11 @@ static int iwl4965_read_ucode(struct iwl_priv *priv)
 }
 
 /**
- * iwl4965_alive_start - called after REPLY_ALIVE notification received
+ * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
- *                   Alive gets handled by iwl4965_init_alive_start()).
+ *                   Alive gets handled by iwl_init_alive_start()).
  */
-static void iwl4965_alive_start(struct iwl_priv *priv)
+static void iwl_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
 
@@ -3272,7 +3272,6 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	}
 
 	iwlcore_clear_stations_table(priv);
-
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARNING("Could not complete ALIVE transition [ntf]: %d\n",
@@ -3310,6 +3309,8 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	/* Configure Bluetooth device coexistence support */
 	iwl4965_send_bt_config(priv);
 
+	iwl_reset_run_time_calib(priv);
+
 	/* Configure the adapter for unassociated operation */
 	iwl4965_commit_rxon(priv);
 
@@ -3554,7 +3555,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
  *
  *****************************************************************************/
 
-static void iwl4965_bg_init_alive_start(struct work_struct *data)
+static void iwl_bg_init_alive_start(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, init_alive_start.work);
@@ -3567,7 +3568,7 @@ static void iwl4965_bg_init_alive_start(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl4965_bg_alive_start(struct work_struct *data)
+static void iwl_bg_alive_start(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, alive_start.work);
@@ -3576,7 +3577,7 @@ static void iwl4965_bg_alive_start(struct work_struct *data)
 		return;
 
 	mutex_lock(&priv->mutex);
-	iwl4965_alive_start(priv);
+	iwl_alive_start(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -5466,8 +5467,8 @@ static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->beacon_update, iwl4965_bg_beacon_update);
 	INIT_WORK(&priv->set_monitor, iwl4965_bg_set_monitor);
 	INIT_DELAYED_WORK(&priv->post_associate, iwl4965_bg_post_associate);
-	INIT_DELAYED_WORK(&priv->init_alive_start, iwl4965_bg_init_alive_start);
-	INIT_DELAYED_WORK(&priv->alive_start, iwl4965_bg_alive_start);
+	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
+	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl4965_bg_scan_check);
 
 	iwl4965_hw_setup_deferred_work(priv);
-- 
1.5.3.6

