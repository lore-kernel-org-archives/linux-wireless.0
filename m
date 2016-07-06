Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33204 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753349AbcGFKlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:01 +0300
Message-Id: <1467801651-1816-6-git-send-email-luca@coelho.fi> (sfid-20160706_124127_151558_55507264)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 06/56] iwlwifi: mvm: change scan timeout to a delayed work
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Some transports may sleep when writing to registers, which is done
when calling iwl_force_nmi().  So we can't call iwl_force_nmi() in a
timer context.  To solve that, convert the scan timeout timer to a
delayed work.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  6 +-----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 18 ++++++++++--------
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e5cb7db..af1d266 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1200,6 +1200,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	flush_work(&mvm->add_stream_wk);
 	cancel_delayed_work_sync(&mvm->fw_dump_wk);
 	cancel_delayed_work_sync(&mvm->cs_tx_unblock_dwork);
+	cancel_delayed_work_sync(&mvm->scan_timeout_dwork);
 	iwl_mvm_free_fw_dump_desc(mvm);
 
 	mutex_lock(&mvm->mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index bf7d78e..3775e26 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -802,7 +802,7 @@ struct iwl_mvm {
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
 	enum iwl_mvm_scan_type scan_type;
 	enum iwl_mvm_sched_scan_pass_all_states sched_scan_pass_all;
-	struct timer_list scan_timer;
+	struct delayed_work scan_timeout_dwork;
 
 	/* max number of simultaneous scans the FW supports */
 	unsigned int max_scans;
@@ -1415,7 +1415,7 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm);
 int iwl_mvm_scan_stop(struct iwl_mvm *mvm, int type, bool notify);
 int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm);
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
-void iwl_mvm_scan_timeout(unsigned long data);
+void iwl_mvm_scan_timeout_wk(struct work_struct *work);
 
 /* Scheduled scan */
 void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 632b1dc..063ebbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -608,6 +608,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
 	INIT_DELAYED_WORK(&mvm->fw_dump_wk, iwl_mvm_fw_error_dump_wk);
 	INIT_DELAYED_WORK(&mvm->tdls_cs.dwork, iwl_mvm_tdls_ch_switch_work);
+	INIT_DELAYED_WORK(&mvm->scan_timeout_dwork, iwl_mvm_scan_timeout_wk);
 	INIT_WORK(&mvm->add_stream_wk, iwl_mvm_add_new_dqa_stream_wk);
 
 	spin_lock_init(&mvm->d0i3_tx_lock);
@@ -766,9 +767,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	iwl_mvm_tof_init(mvm);
 
-	setup_timer(&mvm->scan_timer, iwl_mvm_scan_timeout,
-		    (unsigned long)mvm);
-
 	return op_mode;
 
  out_unregister:
@@ -822,8 +820,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_mvm_tof_clean(mvm);
 
-	del_timer_sync(&mvm->scan_timer);
-
 	mutex_destroy(&mvm->mutex);
 	mutex_destroy(&mvm->d0i3_suspend_mutex);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 6f609dd..fb25d9e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -399,7 +399,7 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 		ieee80211_scan_completed(mvm->hw,
 				scan_notif->status == IWL_SCAN_OFFLOAD_ABORTED);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-		del_timer(&mvm->scan_timer);
+		cancel_delayed_work(&mvm->scan_timeout_dwork);
 	} else {
 		IWL_ERR(mvm,
 			"got scan complete notification but no scan is running\n");
@@ -1222,15 +1222,16 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 	return -EIO;
 }
 
-#define SCAN_TIMEOUT (16 * HZ)
+#define SCAN_TIMEOUT 20000
 
-void iwl_mvm_scan_timeout(unsigned long data)
+void iwl_mvm_scan_timeout_wk(struct work_struct *work)
 {
-	struct iwl_mvm *mvm = (struct iwl_mvm *)data;
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct iwl_mvm *mvm = container_of(delayed_work, struct iwl_mvm,
+					   scan_timeout_dwork);
 
 	IWL_ERR(mvm, "regular scan timed out\n");
 
-	del_timer(&mvm->scan_timer);
 	iwl_force_nmi(mvm->trans);
 }
 
@@ -1313,7 +1314,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
-	mod_timer(&mvm->scan_timer, jiffies + SCAN_TIMEOUT);
+	queue_delayed_work(system_wq, &mvm->scan_timeout_dwork,
+			   msecs_to_jiffies(SCAN_TIMEOUT));
 
 	return 0;
 }
@@ -1432,7 +1434,7 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_REGULAR) {
 		ieee80211_scan_completed(mvm->hw, aborted);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-		del_timer(&mvm->scan_timer);
+		cancel_delayed_work(&mvm->scan_timeout_dwork);
 	} else if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED) {
 		ieee80211_sched_scan_stopped(mvm->hw);
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
@@ -1628,7 +1630,7 @@ out:
 		 * to release the scan reference here.
 		 */
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-		del_timer(&mvm->scan_timer);
+		cancel_delayed_work(&mvm->scan_timeout_dwork);
 		if (notify)
 			ieee80211_scan_completed(mvm->hw, true);
 	} else if (notify) {
-- 
2.8.1

