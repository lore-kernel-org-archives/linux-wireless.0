Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbYF3J0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/33] iwlwifi: don't send REPLY_REMOVE_ALL_STA upon exit
Date: Mon, 30 Jun 2008 17:23:08 +0800
Message-Id: <1214817813-17639-9-git-send-email-yi.zhu@intel.com> (sfid-20080630_112646_842421_2218E69C)
In-Reply-To: <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch avoids sending REPLY_REMOVE_ALL_STA in down flow, this avoids a
meaningless warning from being printed
On the way this patch also renames the the function to
iwl_clear_stations_table

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 +++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   12 ++++++------
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5abfd56..104b6f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -675,7 +675,7 @@ static void iwl5000_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwlcore_clear_stations_table(priv);
+	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARNING("Could not complete ALIVE transition: %d\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1c0670b..6ca9460 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -273,26 +273,27 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_hw_nic_init);
 
 /**
- * iwlcore_clear_stations_table - Clear the driver's station table
+ * iwl_clear_stations_table - Clear the driver's station table
  *
  * NOTE:  This does not clear or otherwise alter the device's station table.
  */
-void iwlcore_clear_stations_table(struct iwl_priv *priv)
+void iwl_clear_stations_table(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->num_stations = 0;
 	if (iwl_is_alive(priv) &&
-	    iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL))
+	   !test_bit(STATUS_EXIT_PENDING, &priv->status) &&
+	   iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL))
 		IWL_ERROR("Couldn't clear the station table\n");
 
+	priv->num_stations = 0;
 	memset(priv->stations, 0, sizeof(priv->stations));
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
-EXPORT_SYMBOL(iwlcore_clear_stations_table);
+EXPORT_SYMBOL(iwl_clear_stations_table);
 
 void iwl_reset_qos(struct iwl_priv *priv)
 {
@@ -864,7 +865,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	mutex_init(&priv->mutex);
 
 	/* Clear the driver's (not device's) station table */
-	iwlcore_clear_stations_table(priv);
+	iwl_clear_stations_table(priv);
 
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 375afe1..0cff64d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -181,7 +181,7 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
 void iwl_hw_detect(struct iwl_priv *priv);
 
-void iwlcore_clear_stations_table(struct iwl_priv *priv);
+void iwl_clear_stations_table(struct iwl_priv *priv);
 void iwl_free_calib_results(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 13d53f3..a607b39 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -320,7 +320,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 	}
 
-	iwlcore_clear_stations_table(priv);
+	iwl_clear_stations_table(priv);
 
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
@@ -841,7 +841,7 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 	iwl4965_connection_init_rx_config(priv);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
-	iwlcore_clear_stations_table(priv);
+	iwl_clear_stations_table(priv);
 
 	/* dont commit rxon if rf-kill is on*/
 	if (!iwl_is_ready_rf(priv))
@@ -2150,7 +2150,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwlcore_clear_stations_table(priv);
+	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARNING("Could not complete ALIVE transition [ntf]: %d\n",
@@ -2228,7 +2228,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 
 	iwl_leds_unregister(priv);
 
-	iwlcore_clear_stations_table(priv);
+	iwl_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -2390,7 +2390,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		iwlcore_clear_stations_table(priv);
+		iwl_clear_stations_table(priv);
 
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
@@ -4530,7 +4530,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 		iwl_rx_queue_free(priv, &priv->rxq);
 	iwl_hw_txq_ctx_free(priv);
 
-	iwlcore_clear_stations_table(priv);
+	iwl_clear_stations_table(priv);
 	iwl_eeprom_free(priv);
 
 
-- 
1.5.3.6

