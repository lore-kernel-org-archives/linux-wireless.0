Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S938928AbcIVUwU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:01 +0300
Message-Id: <20160922205210.1778-2-luca@coelho.fi> (sfid-20160922_225244_868705_61AB478A)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 01/10] iwlwifi: mvm: cleanup redundant no_power_up_nic_in_init config
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This is never really used anymore.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 46 ++++++++-----------------
 2 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 6cecb1a..2660cc4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -359,7 +359,6 @@ struct iwl_cfg {
 	    high_temp:1,
 	    mac_addr_from_csr:1,
 	    lp_xtal_workaround:1,
-	    no_power_up_nic_in_init:1,
 	    disable_dummy_notification:1,
 	    apmg_not_supported:1,
 	    mq_rx_supported:1,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 75f3ca0..6c08aa3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -712,37 +712,21 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		IWL_DEBUG_EEPROM(mvm->trans->dev,
 				 "working without external nvm file\n");
 
-	if (WARN(cfg->no_power_up_nic_in_init && !mvm->nvm_file_name,
-		 "not allowing power-up and not having nvm_file\n"))
+	err = iwl_trans_start_hw(mvm->trans);
+	if (err)
 		goto out_free;
 
-	/*
-	 * Even if nvm exists in the nvm_file driver should read again the nvm
-	 * from the nic because there might be entries that exist in the OTP
-	 * and not in the file.
-	 * for nics with no_power_up_nic_in_init: rely completley on nvm_file
-	 */
-	if (cfg->no_power_up_nic_in_init && mvm->nvm_file_name) {
-		err = iwl_nvm_init(mvm, false);
-		if (err)
-			goto out_free;
-	} else {
-		err = iwl_trans_start_hw(mvm->trans);
-		if (err)
-			goto out_free;
-
-		mutex_lock(&mvm->mutex);
-		iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
-		err = iwl_run_init_mvm_ucode(mvm, true);
-		if (!err || !iwlmvm_mod_params.init_dbg)
-			iwl_mvm_stop_device(mvm);
-		iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
-		mutex_unlock(&mvm->mutex);
-		/* returns 0 if successful, 1 if success but in rfkill */
-		if (err < 0 && !iwlmvm_mod_params.init_dbg) {
-			IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", err);
-			goto out_free;
-		}
+	mutex_lock(&mvm->mutex);
+	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
+	err = iwl_run_init_mvm_ucode(mvm, true);
+	if (!err || !iwlmvm_mod_params.init_dbg)
+		iwl_mvm_stop_device(mvm);
+	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
+	mutex_unlock(&mvm->mutex);
+	/* returns 0 if successful, 1 if success but in rfkill */
+	if (err < 0 && !iwlmvm_mod_params.init_dbg) {
+		IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", err);
+		goto out_free;
 	}
 
 	scan_size = iwl_mvm_scan_size(mvm);
@@ -784,8 +768,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	flush_delayed_work(&mvm->fw_dump_wk);
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);
-	if (!cfg->no_power_up_nic_in_init || !mvm->nvm_file_name)
-		iwl_trans_op_mode_leave(trans);
+	iwl_trans_op_mode_leave(trans);
+
 	ieee80211_free_hw(mvm->hw);
 	return NULL;
 }
-- 
2.9.3
