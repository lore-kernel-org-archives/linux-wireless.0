Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48670 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751989AbdLBQ3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:40 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:57 +0200
Message-Id: <20171202162858.4167-15-luca@coelho.fi> (sfid-20171202_172947_148512_11B28CA5)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 14/15] iwlwifi: mvm: make init_dbg effective only on failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

If FW loads without a problem, leaving init_dbg on can
cause a confusion, since the user won't necessarily
remember it is still turned on, and there are flows in
which everything continues as usual, only without
stopping the device after INIT, even if there is no FW
assert. On 22000 HW, for instance, this causes a
warning, since the paging is getting initialized twice.

Solve the issue by making this module param effective
only if the FW indeed asserts during INIT.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 3019ed9bccd2..0920be637b57 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -923,11 +923,11 @@ static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
 
 	ret = iwl_run_init_mvm_ucode(mvm, false);
 
-	if (iwlmvm_mod_params.init_dbg)
-		return 0;
-
 	if (ret) {
 		IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", ret);
+
+		if (iwlmvm_mod_params.init_dbg)
+			return 0;
 		return ret;
 	}
 
@@ -1111,7 +1111,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	IWL_DEBUG_INFO(mvm, "RT uCode started.\n");
 	return 0;
  error:
-	if (!iwlmvm_mod_params.init_dbg)
+	if (!iwlmvm_mod_params.init_dbg || !ret)
 		iwl_mvm_stop_device(mvm);
 	return ret;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 477395059877..f32edc1709d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -746,7 +746,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 	err = iwl_run_init_mvm_ucode(mvm, true);
-	if (!iwlmvm_mod_params.init_dbg)
+	if (!iwlmvm_mod_params.init_dbg || !err)
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
 	mutex_unlock(&mvm->mutex);
-- 
2.15.0
