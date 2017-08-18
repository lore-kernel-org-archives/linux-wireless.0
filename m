Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44442 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751537AbdHRPtc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:49:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:00 +0300
Message-Id: <20170818154922.2904-3-luca@coelho.fi> (sfid-20170818_174952_650119_EC2BCA75)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 02/24] iwlwifi: mvm: consider RFKILL during INIT as success
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There's no need to differentiate an INIT that ended early because of
RFKILL from one that succeded.  Additionally, if INIT fails later,
during calibration, due to RFKILL, we can just return success and
continue as if we were already in RFKILL to start with.

Remove this unnecessary differentiation and do some other small
clean-ups while at it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 38 +++++++++++++---------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c |  1 -
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0099050f6e2b..ed18479a7b8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -475,13 +475,13 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_INIT);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to start INIT ucode: %d\n", ret);
-		goto error;
+		goto remove_notif;
 	}
 
 	if (mvm->cfg->device_family < IWL_DEVICE_FAMILY_8000) {
 		ret = iwl_mvm_send_bt_init_conf(mvm);
 		if (ret)
-			goto error;
+			goto remove_notif;
 	}
 
 	/* Read the NVM only at driver load time, no need to do this twice */
@@ -490,7 +490,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		ret = iwl_nvm_init(mvm, true);
 		if (ret) {
 			IWL_ERR(mvm, "Failed to read NVM: %d\n", ret);
-			goto error;
+			goto remove_notif;
 		}
 	}
 
@@ -498,8 +498,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	if (mvm->nvm_file_name)
 		iwl_mvm_load_nvm_to_nic(mvm);
 
-	ret = iwl_nvm_check_version(mvm->nvm_data, mvm->trans);
-	WARN_ON(ret);
+	WARN_ON(iwl_nvm_check_version(mvm->nvm_data, mvm->trans));
 
 	/*
 	 * abort after reading the nvm in case RF Kill is on, we will complete
@@ -508,9 +507,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	if (iwl_mvm_is_radio_hw_killed(mvm)) {
 		IWL_DEBUG_RF_KILL(mvm,
 				  "jump over all phy activities due to RF kill\n");
-		iwl_remove_notification(&mvm->notif_wait, &calib_wait);
-		ret = 1;
-		goto out;
+		goto remove_notif;
 	}
 
 	mvm->calibrating = true;
@@ -518,17 +515,13 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	/* Send TX valid antennas before triggering calibrations */
 	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	if (ret)
-		goto error;
+		goto remove_notif;
 
-	/*
-	 * Send phy configurations command to init uCode
-	 * to start the 16.0 uCode init image internal calibrations.
-	 */
 	ret = iwl_send_phy_cfg_cmd(mvm);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to run INIT calibrations: %d\n",
 			ret);
-		goto error;
+		goto remove_notif;
 	}
 
 	/*
@@ -536,15 +529,21 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	 * just wait for the calibration complete notification.
 	 */
 	ret = iwl_wait_notification(&mvm->notif_wait, &calib_wait,
-			MVM_UCODE_CALIB_TIMEOUT);
+				    MVM_UCODE_CALIB_TIMEOUT);
+	if (!ret)
+		goto out;
 
-	if (ret && iwl_mvm_is_radio_hw_killed(mvm)) {
+	if (iwl_mvm_is_radio_hw_killed(mvm)) {
 		IWL_DEBUG_RF_KILL(mvm, "RFKILL while calibrating.\n");
-		ret = 1;
+		ret = 0;
+	} else {
+		IWL_ERR(mvm, "Failed to run INIT calibrations: %d\n",
+			ret);
 	}
+
 	goto out;
 
-error:
+remove_notif:
 	iwl_remove_notification(&mvm->notif_wait, &calib_wait);
 out:
 	mvm->calibrating = false;
@@ -1043,9 +1042,6 @@ static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
 
 	if (ret) {
 		IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", ret);
-		/* this can't happen */
-		if (WARN_ON(ret > 0))
-			ret = -ERFKILL;
 		return ret;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 640881c8d703..76d256a9ad71 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -751,7 +751,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
 	mutex_unlock(&mvm->mutex);
-	/* returns 0 if successful, 1 if success but in rfkill */
 	if (err < 0) {
 		IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", err);
 		goto out_free;
-- 
2.14.1
