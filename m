Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaKDJs0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 04:48:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: replace restart_complete() with reconfig_complete()
Date: Tue,  4 Nov 2014 11:43:54 +0200
Message-Id: <1415094234-22006-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141104_104833_022686_31401085)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Drivers might want to know also when mac80211 has
completed reconfiguring after resume (e.g. in order
to know when frames can be passed to mac80211).

Rename restart_complete() to a more-generic reconfig_complete(),
and add a new enum to indicate the reconfiguration type.

Update the current users with the new prototype.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/ath/ath10k/core.h      |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c       |  8 ++++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 +++++++++++++++++---
 include/net/mac80211.h                      | 29 +++++++++++++++++++++++------
 net/mac80211/driver-ops.h                   | 10 ++++++----
 net/mac80211/trace.h                        | 23 ++++++++++++++++++++---
 net/mac80211/util.c                         |  5 ++++-
 7 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1e3fd10..4ca6dc9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -338,7 +338,7 @@ enum ath10k_state {
 	 * stopped in ath10k_core_restart() work holding conf_mutex. The state
 	 * RESTARTED means that the device is up and mac80211 has started hw
 	 * reconfiguration. Once mac80211 is done with the reconfiguration we
-	 * set the state to STATE_ON in restart_complete(). */
+	 * set the state to STATE_ON in reconfig_complete(). */
 	ATH10K_STATE_RESTARTING,
 	ATH10K_STATE_RESTARTED,
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f6d2fd0..61b006f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3994,10 +3994,14 @@ exit:
 }
 #endif
 
-static void ath10k_restart_complete(struct ieee80211_hw *hw)
+static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
+				     enum ieee80211_reconfig_type reconfig_type)
 {
 	struct ath10k *ar = hw->priv;
 
+	if (reconfig_type != IEEE80211_RECONFIG_TYPE_RESTART)
+		return;
+
 	mutex_lock(&ar->conf_mutex);
 
 	/* If device failed to restart it will be in a different state, e.g.
@@ -4515,7 +4519,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.tx_last_beacon			= ath10k_tx_last_beacon,
 	.set_antenna			= ath10k_set_antenna,
 	.get_antenna			= ath10k_get_antenna,
-	.restart_complete		= ath10k_restart_complete,
+	.reconfig_complete		= ath10k_reconfig_complete,
 	.get_survey			= ath10k_get_survey,
 	.set_bitrate_mask		= ath10k_set_bitrate_mask,
 	.sta_rc_update			= ath10k_sta_rc_update,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3276b31..f308e52 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -895,9 +895,8 @@ static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 	return ret;
 }
 
-static void iwl_mvm_mac_restart_complete(struct ieee80211_hw *hw)
+static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
 	mutex_lock(&mvm->mutex);
@@ -915,6 +914,21 @@ static void iwl_mvm_mac_restart_complete(struct ieee80211_hw *hw)
 	mutex_unlock(&mvm->mutex);
 }
 
+static void
+iwl_mvm_mac_reconfig_complete(struct ieee80211_hw *hw,
+			      enum ieee80211_reconfig_type reconfig_type)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	switch (reconfig_type) {
+	case IEEE80211_RECONFIG_TYPE_RESTART:
+		iwl_mvm_restart_complete(mvm);
+		break;
+	case IEEE80211_RECONFIG_TYPE_SUSPEND:
+		break;
+	}
+}
+
 void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 {
 	lockdep_assert_held(&mvm->mutex);
@@ -3058,7 +3072,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
 	.start = iwl_mvm_mac_start,
-	.restart_complete = iwl_mvm_mac_restart_complete,
+	.reconfig_complete = iwl_mvm_mac_reconfig_complete,
 	.stop = iwl_mvm_mac_stop,
 	.add_interface = iwl_mvm_mac_add_interface,
 	.remove_interface = iwl_mvm_mac_remove_interface,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ad1f47..940c67c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2375,6 +2375,22 @@ enum ieee80211_roc_type {
 };
 
 /**
+ * enum ieee80211_reconfig_complete_type - reconfig type
+ *
+ * This enum is used by the reconfig_complete() callback to indicate what
+ * reconfiguration type was completed.
+ *
+ * @IEEE80211_RECONFIG_COMPLETE_RESTART: hw restart type
+ *	(also due to resume() callback returning 1)
+ * @IEEE80211_RECONFIG_COMPLETE_SUSPEND: suspend type (regardless
+ *	of wowlan configuration)
+ */
+enum ieee80211_reconfig_type {
+	IEEE80211_RECONFIG_TYPE_RESTART,
+	IEEE80211_RECONFIG_TYPE_SUSPEND,
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -2809,11 +2825,11 @@ enum ieee80211_roc_type {
  *	disabled/enabled via @bss_info_changed.
  * @stop_ap: Stop operation on the AP interface.
  *
- * @restart_complete: Called after a call to ieee80211_restart_hw(), when the
- *	reconfiguration has completed. This can help the driver implement the
- *	reconfiguration step. Also called when reconfiguring because the
- *	driver's resume function returned 1, as this is just like an "inline"
- *	hardware restart. This callback may sleep.
+ * @reconfig_complete: Called after a call to ieee80211_restart_hw() and
+ *	during resume, when the reconfiguration has completed.
+ *	This can help the driver implement the reconfiguration step (and
+ *	indicate mac80211 is ready to receive frames).
+ *	This callback may sleep.
  *
  * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
  *	Currently, this is only called for managed or P2P client interfaces.
@@ -3025,7 +3041,8 @@ struct ieee80211_ops {
 				  int n_vifs,
 				  enum ieee80211_chanctx_switch_mode mode);
 
-	void (*restart_complete)(struct ieee80211_hw *hw);
+	void (*reconfig_complete)(struct ieee80211_hw *hw,
+				  enum ieee80211_reconfig_type reconfig_type);
 
 #if IS_ENABLED(CONFIG_IPV6)
 	void (*ipv6_addr_change)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 196d48c..2e01f93 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1144,13 +1144,15 @@ static inline void drv_stop_ap(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline void drv_restart_complete(struct ieee80211_local *local)
+static inline void
+drv_reconfig_complete(struct ieee80211_local *local,
+		      enum ieee80211_reconfig_type reconfig_type)
 {
 	might_sleep();
 
-	trace_drv_restart_complete(local);
-	if (local->ops->restart_complete)
-		local->ops->restart_complete(&local->hw);
+	trace_drv_reconfig_complete(local, reconfig_type);
+	if (local->ops->reconfig_complete)
+		local->ops->reconfig_complete(&local->hw, reconfig_type);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 38fae7e..2b411e0 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1557,9 +1557,26 @@ DEFINE_EVENT(local_sdata_evt, drv_stop_ap,
 	TP_ARGS(local, sdata)
 );
 
-DEFINE_EVENT(local_only_evt, drv_restart_complete,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
+TRACE_EVENT(drv_reconfig_complete,
+	TP_PROTO(struct ieee80211_local *local,
+		 enum ieee80211_reconfig_type reconfig_type),
+	TP_ARGS(local, reconfig_type),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u8, reconfig_type)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->reconfig_type = reconfig_type;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  " reconfig_type:%d",
+		LOCAL_PR_ARG, __entry->reconfig_type
+	)
+
 );
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c61060..84e9fbd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1949,7 +1949,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * We may want to change that later, however.
 	 */
 	if (!local->suspended || reconfig_due_to_wowlan)
-		drv_restart_complete(local);
+		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_RESTART);
 
 	if (!local->suspended)
 		return 0;
@@ -1960,6 +1960,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mb();
 	local->resuming = false;
 
+	if (!reconfig_due_to_wowlan)
+		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_SUSPEND);
+
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
-- 
1.9.1

