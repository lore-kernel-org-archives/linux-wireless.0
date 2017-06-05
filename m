Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFEUng (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:08 +0300
Message-Id: <20170605204218.30151-16-luca@coelho.fi> (sfid-20170605_224339_430353_C990F7C4)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: mvm: convert ucode_loaded to a status bit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Convert ucode_loaded to a status bit called FIRMWARE_RUNNING.
This will make it easier to clear this earlier, to avoid any
spurious accesses while shutting down, for example through
debugfs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 26ccfbc34cfd..24cc406d87ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -622,7 +622,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	if (WARN_ON(!fw))
 		return -EINVAL;
 	mvm->cur_ucode = ucode_type;
-	mvm->ucode_loaded = false;
+	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 
 	iwl_init_notification_wait(&mvm->notif_wait, &alive_wait,
 				   alive_cmd, ARRAY_SIZE(alive_cmd),
@@ -696,7 +696,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
 		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
 
-	mvm->ucode_loaded = true;
+	set_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b47e1f1efc8a..73bd56e06d95 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -767,7 +767,6 @@ struct iwl_mvm {
 	struct iwl_mvm_vif *bf_allowed_vif;
 
 	enum iwl_ucode_type cur_ucode;
-	bool ucode_loaded;
 	bool hw_registered;
 	bool calibrating;
 	u32 error_event_table[2];
@@ -1088,6 +1087,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_ROC_AUX_RUNNING,
 	IWL_MVM_STATUS_D3_RECONFIG,
 	IWL_MVM_STATUS_DUMPING_FW_LOG,
+	IWL_MVM_STATUS_FIRMWARE_RUNNING,
 };
 
 /* Keep track of completed init configuration */
@@ -1111,7 +1111,7 @@ static inline bool iwl_mvm_is_radio_hw_killed(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_firmware_running(struct iwl_mvm *mvm)
 {
-	return mvm->ucode_loaded;
+	return test_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 }
 
 /* Must be called with rcu_read_lock() held and it can only be
@@ -1771,7 +1771,7 @@ static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
 	if (!iwl_mvm_has_new_tx_api(mvm))
 		iwl_free_fw_paging(mvm);
-	mvm->ucode_loaded = false;
+	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 	iwl_trans_stop_device(mvm->trans);
 }
 
-- 
2.11.0
