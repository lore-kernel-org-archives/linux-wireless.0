Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYKLVNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwlwifi: configure_filter rewrite
Date: Wed, 12 Nov 2008 13:14:09 -0800
Message-Id: <1226524451-3417-7-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221358_151433_8EE50884)
In-Reply-To: <1226524451-3417-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-3-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-4-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-5-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

The patch rewrites the mac80211 configure_filter handler to better mapping
mac80211 filter flags to iwlwifi hardware filter flags. We now can support
5 mac80211 filter flags: FIF_OTHER_BSS, FIF_ALLMULTI, FIF_PROMISC_IN_BSS,
FIF_BCN_PRBRESP_PROMISC and FIF_CONTROL. This patch also avoids reconnecting
if the filter flags are changed when the STA is associated. Because rx_assoc
is used when full rxon is not necessary.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   66 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   63 ++++++++++++++-----------
 4 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 7187925..2a924c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -886,7 +886,6 @@ struct iwl3945_priv {
 	struct work_struct report_work;
 	struct work_struct request_scan;
 	struct work_struct beacon_update;
-	struct work_struct set_monitor;
 
 	struct tasklet_struct irq_tasklet;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index af1dff6..6fed4c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2229,28 +2229,6 @@ static void iwl_bg_rf_kill(struct work_struct *work)
 	iwl_rfkill_set_hw_state(priv);
 }
 
-static void iwl_bg_set_monitor(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work,
-				struct iwl_priv, set_monitor);
-	int ret;
-
-	IWL_DEBUG(IWL_DL_STATE, "setting monitor mode\n");
-
-	mutex_lock(&priv->mutex);
-
-	ret = iwl_set_mode(priv, NL80211_IFTYPE_MONITOR);
-	if (ret) {
-		if (ret == -EAGAIN)
-			IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
-		else
-			IWL_ERROR("iwl_set_mode() failed ret = %d\n", ret);
-	}
-
-	mutex_unlock(&priv->mutex);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
-}
-
 static void iwl_bg_run_time_calib_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
@@ -2901,16 +2879,43 @@ static void iwl_configure_filter(struct ieee80211_hw *hw,
 				 int mc_count, struct dev_addr_list *mc_list)
 {
 	struct iwl_priv *priv = hw->priv;
+	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
+
+	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
+			changed_flags, *total_flags);
 
-	if (changed_flags & (*total_flags) & FIF_OTHER_BSS) {
-		IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
-				   NL80211_IFTYPE_MONITOR,
-				   changed_flags, *total_flags);
-		/* queue work 'cuz mac80211 is holding a lock which
-		 * prevents us from issuing (synchronous) f/w cmds */
-		queue_work(priv->workqueue, &priv->set_monitor);
+	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
+		if (*total_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))
+			*filter_flags |= RXON_FILTER_PROMISC_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_PROMISC_MSK;
+	}
+	if (changed_flags & FIF_ALLMULTI) {
+		if (*total_flags & FIF_ALLMULTI)
+			*filter_flags |= RXON_FILTER_ACCEPT_GRP_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_ACCEPT_GRP_MSK;
+	}
+	if (changed_flags & FIF_CONTROL) {
+		if (*total_flags & FIF_CONTROL)
+			*filter_flags |= RXON_FILTER_CTL2HOST_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_CTL2HOST_MSK;
+	}
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+			*filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_BCON_AWARE_MSK;
 	}
-	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI |
+
+	/* We avoid iwl_commit_rxon here to commit the new filter flags
+	 * since mac80211 will call ieee80211_hw_config immediately.
+	 * (mc_list is not supported at this time). Otherwise, we need to
+	 * queue a background iwl_commit_rxon work.
+	 */
+
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
@@ -3809,7 +3814,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
 	INIT_WORK(&priv->rf_kill, iwl_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
-	INIT_WORK(&priv->set_monitor, iwl_bg_set_monitor);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7c58d21..49faf8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -984,7 +984,6 @@ struct iwl_priv {
 	struct work_struct report_work;
 	struct work_struct request_scan;
 	struct work_struct beacon_update;
-	struct work_struct set_monitor;
 
 	struct tasklet_struct irq_tasklet;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c8b85cc..bfc15ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6007,25 +6007,6 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 	iwl3945_rfkill_set_hw_state(priv);
 }
 
-static void iwl3945_bg_set_monitor(struct work_struct *work)
-{
-	struct iwl3945_priv *priv = container_of(work,
-				struct iwl3945_priv, set_monitor);
-
-	IWL_DEBUG(IWL_DL_STATE, "setting monitor mode\n");
-
-	mutex_lock(&priv->mutex);
-
-	if (!iwl3945_is_ready(priv))
-		IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
-	else
-		if (iwl3945_set_mode(priv, NL80211_IFTYPE_MONITOR) != 0)
-			IWL_ERROR("iwl3945_set_mode() failed\n");
-
-	mutex_unlock(&priv->mutex);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
-}
-
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
 static void iwl3945_bg_scan_check(struct work_struct *data)
@@ -6847,16 +6828,43 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 				 int mc_count, struct dev_addr_list *mc_list)
 {
 	struct iwl3945_priv *priv = hw->priv;
+	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
 
-	if (changed_flags & (*total_flags) & FIF_OTHER_BSS) {
-		IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
-				   NL80211_IFTYPE_MONITOR,
-				   changed_flags, *total_flags);
-		/* queue work 'cuz mac80211 is holding a lock which
-		 * prevents us from issuing (synchronous) f/w cmds */
-		queue_work(priv->workqueue, &priv->set_monitor);
+	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
+			changed_flags, *total_flags);
+
+	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
+		if (*total_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))
+			*filter_flags |= RXON_FILTER_PROMISC_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_PROMISC_MSK;
+	}
+	if (changed_flags & FIF_ALLMULTI) {
+		if (*total_flags & FIF_ALLMULTI)
+			*filter_flags |= RXON_FILTER_ACCEPT_GRP_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_ACCEPT_GRP_MSK;
+	}
+	if (changed_flags & FIF_CONTROL) {
+		if (*total_flags & FIF_CONTROL)
+			*filter_flags |= RXON_FILTER_CTL2HOST_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_CTL2HOST_MSK;
 	}
-	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI |
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+			*filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_BCON_AWARE_MSK;
+	}
+
+	/* We avoid iwl_commit_rxon here to commit the new filter flags
+	 * since mac80211 will call ieee80211_hw_config immediately.
+	 * (mc_list is not supported at this time). Otherwise, we need to
+	 * queue a background iwl_commit_rxon work.
+	 */
+
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
@@ -7734,7 +7742,6 @@ static void iwl3945_setup_deferred_work(struct iwl3945_priv *priv)
 	INIT_WORK(&priv->abort_scan, iwl3945_bg_abort_scan);
 	INIT_WORK(&priv->rf_kill, iwl3945_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
-	INIT_WORK(&priv->set_monitor, iwl3945_bg_set_monitor);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl3945_bg_scan_check);
-- 
1.5.4.3

