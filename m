Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbbLUUvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:23 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/45] iwlwifi: avoid d0i3 commands when no/init ucode is loaded
Date: Mon, 21 Dec 2015 22:50:18 +0200
Message-Id: <1450731046-2796-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215144_524774_D4BB33FD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

d0i3 commands are not supported in the init image, so take
a reference to ensure we don't enter d0i3 during init image,
and additional checks to prevent d0i3 commands when no
fw image is loaded.

Add a few WARN_ON_ONCE to the d0i3 enter/exit commands
to ensure we send d0i3 commands only when the normal
ucode is loaded.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 7e2a814..9ce7587 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1316,6 +1316,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_EXIT_WORK);
 	PRINT_MVM_REF(IWL_MVM_REF_PROTECT_CSA);
 	PRINT_MVM_REF(IWL_MVM_REF_FW_DBG_COLLECT);
+	PRINT_MVM_REF(IWL_MVM_REF_INIT_UCODE);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 612799a..3f0db29 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -294,6 +294,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_EXIT_WORK,
 	IWL_MVM_REF_PROTECT_CSA,
 	IWL_MVM_REF_FW_DBG_COLLECT,
+	IWL_MVM_REF_INIT_UCODE,
 
 	/* update debugfs.c when changing this */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 958984c..31c16a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -603,9 +603,11 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 			goto out_free;
 
 		mutex_lock(&mvm->mutex);
+		iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 		err = iwl_run_init_mvm_ucode(mvm, true);
 		if (!err || !iwlmvm_mod_params.init_dbg)
 			iwl_trans_stop_device(trans);
+		iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
 		mutex_unlock(&mvm->mutex);
 		/* returns 0 if successful, 1 if success but in rfkill */
 		if (err < 0 && !iwlmvm_mod_params.init_dbg) {
@@ -1213,6 +1215,9 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 
 	IWL_DEBUG_RPM(mvm, "MVM entering D0i3\n");
 
+	if (WARN_ON_ONCE(mvm->cur_ucode != IWL_UCODE_REGULAR))
+		return -EINVAL;
+
 	set_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
 
 	/*
@@ -1420,6 +1425,9 @@ int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm)
 
 	IWL_DEBUG_RPM(mvm, "MVM exiting D0i3\n");
 
+	if (WARN_ON_ONCE(mvm->cur_ucode != IWL_UCODE_REGULAR))
+		return -EINVAL;
+
 	mutex_lock(&mvm->d0i3_suspend_mutex);
 	if (test_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags)) {
 		IWL_DEBUG_RPM(mvm, "Deferring d0i3 exit until resume\n");
-- 
2.5.0

