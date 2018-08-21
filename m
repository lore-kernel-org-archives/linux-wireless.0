Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42630 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbeHUI2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:42 +0300
Message-Id: <20180821050952.31603-8-luca@coelho.fi> (sfid-20180821_071016_357796_D4DA0768)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 07/17] iwlwifi: mvm: protect D0i3 code behind CONFIG_PM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Runtime PM can only be used if CONFIG_PM is set.  Move all the d0i3
code (which is essentially runtime PM) behind the CONFIG_PM flag.

This prevents undefined usage of some functions when CONFIG_PM is not
defined.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

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
