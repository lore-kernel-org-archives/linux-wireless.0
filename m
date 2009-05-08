Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbZEHUiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/11] iwlwifi: do proper hw restart
Date: Fri,  8 May 2009 13:44:36 -0700
Message-Id: <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

When the microcode fails for any reason, ask mac80211 to
recover instead of trying ourselves and failing at it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   43 ++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    5 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   36 +++++++---------------
 4 files changed, 24 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6cdee0b..43bc8a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -190,8 +190,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 
 	priv->cfg->ops->smgmt->clear_station_table(priv);
 
-	if (!priv->error_recovering)
-		priv->start_calib = 0;
+	priv->start_calib = 0;
 
 	/* Add the broadcast address so we can send broadcast frames */
 	if (iwl_rxon_add_station(priv, iwl_bcast_addr, 0) ==
@@ -967,23 +966,6 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-static void iwl_error_recovery(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
-	       sizeof(priv->staging_rxon));
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv);
-
-	iwl_rxon_add_station(priv, priv->bssid, 1);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
-	priv->error_recovering = 0;
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
 static void iwl_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
@@ -1514,9 +1496,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
-	if (priv->error_recovering)
-		iwl_error_recovery(priv);
-
 	iwl_power_update_mode(priv, 1);
 
 	/* reassociate for ADHOC mode */
@@ -1715,9 +1694,6 @@ static int __iwl_up(struct iwl_priv *priv)
 			continue;
 		}
 
-		/* Clear out the uCode error bit if it is set */
-		clear_bit(STATUS_FW_ERROR, &priv->status);
-
 		/* start card; "initialize" will load runtime ucode */
 		iwl_nic_start(priv);
 
@@ -1812,8 +1788,17 @@ static void iwl_bg_restart(struct work_struct *data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	iwl_down(priv);
-	queue_work(priv->workqueue, &priv->up);
+	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		mutex_lock(&priv->mutex);
+		priv->vif = NULL;
+		priv->is_open = 0;
+		mutex_unlock(&priv->mutex);
+		iwl_down(priv);
+		ieee80211_restart_hw(priv->hw);
+	} else {
+		iwl_down(priv);
+		queue_work(priv->workqueue, &priv->up);
+	}
 }
 
 static void iwl_bg_rx_replenish(struct work_struct *data)
@@ -2007,10 +1992,8 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	if (!priv->is_open) {
-		IWL_DEBUG_MAC80211(priv, "leave - skip\n");
+	if (!priv->is_open)
 		return;
-	}
 
 	priv->is_open = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1366222..b50fc9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1230,11 +1230,6 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 		IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
 			  "Restarting adapter due to uCode error.\n");
 
-		if (iwl_is_associated(priv)) {
-			memcpy(&priv->recovery_rxon, &priv->active_rxon,
-			       sizeof(priv->recovery_rxon));
-			priv->error_recovering = 1;
-		}
 		if (priv->cfg->mod_params->restart_fw)
 			queue_work(priv->workqueue, &priv->restart);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5aa76a7..0f2c1b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -933,7 +933,6 @@ struct iwl_priv {
 	const struct iwl_rxon_cmd active_rxon;
 	struct iwl_rxon_cmd staging_rxon;
 
-	int error_recovering;
 	struct iwl_rxon_cmd recovery_rxon;
 
 	/* 1st responses from initialize and runtime uCode images.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f6c1489..271e5d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1837,23 +1837,6 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 }
 
-static void iwl3945_error_recovery(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
-	       sizeof(priv->staging_rxon));
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv);
-
-	priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 1, 0, NULL);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
-	priv->error_recovering = 0;
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
 static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
@@ -2683,9 +2666,6 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	/* After the ALIVE response, we can send commands to 3945 uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
-	/* Clear out the uCode error bit if it is set */
-	clear_bit(STATUS_FW_ERROR, &priv->status);
-
 	if (iwl_is_rfkill(priv))
 		return;
 
@@ -2722,9 +2702,6 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
-	if (priv->error_recovering)
-		iwl3945_error_recovery(priv);
-
 	/* reassociate for ADHOC mode */
 	if (priv->vif && (priv->iw_mode == NL80211_IFTYPE_ADHOC)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(priv->hw,
@@ -3231,8 +3208,17 @@ static void iwl3945_bg_restart(struct work_struct *data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	iwl3945_down(priv);
-	queue_work(priv->workqueue, &priv->up);
+	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		mutex_lock(&priv->mutex);
+		priv->vif = NULL;
+		priv->is_open = 0;
+		mutex_unlock(&priv->mutex);
+		iwl3945_down(priv);
+		ieee80211_restart_hw(priv->hw);
+	} else {
+		iwl3945_down(priv);
+		queue_work(priv->workqueue, &priv->up);
+	}
 }
 
 static void iwl3945_bg_rx_replenish(struct work_struct *data)
-- 
1.5.6.3

