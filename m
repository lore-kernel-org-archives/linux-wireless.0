Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58242 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750997AbeBINMp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 08:12:45 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  9 Feb 2018 15:12:33 +0200
Message-Id: <20180209131234.8504-5-luca@coelho.fi> (sfid-20180209_141251_273176_5AF8131C)
In-Reply-To: <20180209131234.8504-1-luca@coelho.fi>
References: <20180209131234.8504-1-luca@coelho.fi>
Subject: [PATCH 4/5] iwlwifi: align timestamp cancel with timestamp start
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Canceling the periodic timestamp work should be
done in the opposite flow to where it was started.
This also prevents from sending the MARKER command
during the mac_stop flow - causing a false queue hang
(FW is no longer there to send a response).

Fixes: 93b167c13a3a ("iwlwifi: runtime: sync FW and host clocks for logs")
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/init.c | 6 ------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 --
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index c39fe84bb4c4..45f21acbd842 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -76,9 +76,3 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 	iwl_fwrt_dbgfs_register(fwrt, dbgfs_dir);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_runtime_init);
-
-void iwl_fw_runtime_exit(struct iwl_fw_runtime *fwrt)
-{
-	iwl_fw_cancel_timestamp(fwrt);
-}
-IWL_EXPORT_SYMBOL(iwl_fw_runtime_exit);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2d28e0804218..1a6faa48a3b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1783,6 +1783,7 @@ static inline u32 iwl_mvm_flushable_queues(struct iwl_mvm *mvm)
 
 static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
+	iwl_fw_cancel_timestamp(&mvm->fwrt);
 	iwl_free_fw_paging(&mvm->fwrt);
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 	iwl_fw_dump_conf_clear(&mvm->fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5d525a0023dc..6bb347bf0d6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -802,7 +802,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_mvm_leds_exit(mvm);
 	iwl_mvm_thermal_exit(mvm);
  out_free:
-	iwl_fw_runtime_exit(&mvm->fwrt);
 	iwl_fw_flush_dump(&mvm->fwrt);
 
 	if (iwlmvm_mod_params.init_dbg)
@@ -843,7 +842,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_IWLWIFI_DEBUGFS)
 	kfree(mvm->d3_resume_sram);
 #endif
-	iwl_fw_runtime_exit(&mvm->fwrt);
 	iwl_trans_op_mode_leave(mvm->trans);
 
 	iwl_phy_db_free(mvm->phy_db);
-- 
2.15.1
