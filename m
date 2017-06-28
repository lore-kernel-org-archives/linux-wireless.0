Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35898 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751840AbdF1UOW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:14:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:24 +0300
Message-Id: <20170628201330.9432-26-luca@coelho.fi> (sfid-20170628_221451_950551_FABFC913)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 25/31] iwlwifi: mvm: unconditionally stop device after init
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In commit b93b1fe3b532 ("iwlwifi: mvm: fix init_dbg flow to work
as expected"), the code was changed to make the stop conditional
on not having failed (and on not having init_dbg), which doesn't
make sense - we should stop the device regardless of failures.

Failure to do so is leading to the device being enabled when it
shouldn't be, and - if it gets re-enabled later - the new context
info code gets confused as paging data wasn't freed.

Remove the invalid error condition again.

Fixes: b93b1fe3b532 ("iwlwifi: mvm: fix init_dbg flow to work as expected")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index a0907762b0bf..c1ce92f5306d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -741,7 +741,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 	err = iwl_run_init_mvm_ucode(mvm, true);
-	if (!err || !iwlmvm_mod_params.init_dbg)
+	if (!iwlmvm_mod_params.init_dbg)
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
 	mutex_unlock(&mvm->mutex);
-- 
2.11.0
