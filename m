Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43756 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726519AbeHXJGC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 05:06:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 08:32:52 +0300
Message-Id: <20180824053252.31831-1-luca@coelho.fi> (sfid-20180824_073305_023325_E9D5EE94)
In-Reply-To: <20180823145128.28803-1-luca@coelho.fi>
References: <20180823145128.28803-1-luca@coelho.fi>
Subject: [PATCH v4 07/17] iwlwifi: mvm: protect D0i3 code behind CONFIG_PM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Runtime PM can only be used if CONFIG_PM is set.  Move all the d0i3
code (which is essentially runtime PM) behind the CONFIG_PM flag.

This prevents undefined usage of some functions when CONFIG_PM is not
defined.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
In v4: fixed #endif in mvm.h

drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 15 +++++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b15b0d84bb7e..0426cc614bfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1124,7 +1124,9 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
 		 * would do.
 		 */
 		clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+#ifdef CONFIG_PM
 		iwl_mvm_d0i3_enable_tx(mvm, NULL);
+#endif
 	}
 
 	return ret;
@@ -1162,7 +1164,9 @@ static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 	mutex_lock(&mvm->mutex);
 
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+#ifdef CONFIG_PM
 	iwl_mvm_d0i3_enable_tx(mvm, NULL);
+#endif
 	ret = iwl_mvm_update_quotas(mvm, true, NULL);
 	if (ret)
 		IWL_ERR(mvm, "Failed to update quotas after restart (%d)\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b3987a0a7018..d73fb0ab9960 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1776,10 +1776,13 @@ void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 bool iwl_mvm_ref_taken(struct iwl_mvm *mvm);
+
+#ifdef CONFIG_PM
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq);
 int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode);
 int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode);
 int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm);
+#endif CONFIG_PM
 
 /* BT Coex */
 int iwl_mvm_send_bt_init_conf(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index bce5d150eb58..421509c63f23 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -495,7 +495,9 @@ static const struct iwl_hcmd_arr iwl_mvm_groups[] = {
 
 /* this forward declaration can avoid to export the function */
 static void iwl_mvm_async_handlers_wk(struct work_struct *wk);
+#ifdef CONFIG_PM
 static void iwl_mvm_d0i3_exit_work(struct work_struct *wk);
+#endif
 
 static u32 iwl_mvm_min_backoff(struct iwl_mvm *mvm)
 {
@@ -665,7 +667,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	INIT_WORK(&mvm->async_handlers_wk, iwl_mvm_async_handlers_wk);
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
+#ifdef CONFIG_PM
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
+#endif
 	INIT_DELAYED_WORK(&mvm->tdls_cs.dwork, iwl_mvm_tdls_ch_switch_work);
 	INIT_DELAYED_WORK(&mvm->scan_timeout_dwork, iwl_mvm_scan_timeout_wk);
 	INIT_WORK(&mvm->add_stream_wk, iwl_mvm_add_new_dqa_stream_wk);
@@ -1278,6 +1282,7 @@ static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 	iwl_mvm_nic_restart(mvm, true);
 }
 
+#ifdef CONFIG_PM
 struct iwl_d0i3_iter_data {
 	struct iwl_mvm *mvm;
 	struct ieee80211_vif *connected_vif;
@@ -1689,6 +1694,13 @@ int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 	return _iwl_mvm_exit_d0i3(mvm);
 }
 
+#define IWL_MVM_D0I3_OPS					\
+	.enter_d0i3 = iwl_mvm_enter_d0i3,			\
+	.exit_d0i3 = iwl_mvm_exit_d0i3,
+#else /* CONFIG_PM */
+#define IWL_MVM_D0I3_OPS
+#endif /* CONFIG_PM */
+
 #define IWL_MVM_COMMON_OPS					\
 	/* these could be differentiated */			\
 	.async_cb = iwl_mvm_async_cb,				\
@@ -1699,8 +1711,7 @@ int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 	.nic_error = iwl_mvm_nic_error,				\
 	.cmd_queue_full = iwl_mvm_cmd_queue_full,		\
 	.nic_config = iwl_mvm_nic_config,			\
-	.enter_d0i3 = iwl_mvm_enter_d0i3,			\
-	.exit_d0i3 = iwl_mvm_exit_d0i3,				\
+	IWL_MVM_D0I3_OPS					\
 	/* as we only register one, these MUST be common! */	\
 	.start = iwl_op_mode_mvm_start,				\
 	.stop = iwl_op_mode_mvm_stop
-- 
2.18.0
