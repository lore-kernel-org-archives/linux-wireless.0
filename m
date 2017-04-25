Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54116 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954149AbdDYUXE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:20 +0300
Message-Id: <20170425202243.7844-3-luca@coelho.fi> (sfid-20170425_222322_764127_806E8980)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: mvm: make iwl_run_unified_mvm_ucode() static
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have iwl_run_unified_mvm_ucode() be exposed
to other parts of the code since the logic to pick it over the
normal code in iwl_run_init_mvm_ucode() can just be done in
that function itself.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 155 ++++++++++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c |   5 +-
 3 files changed, 80 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 900f1e25b9da..b5c7dffafdc1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -698,6 +698,82 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	return 0;
 }
 
+static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
+{
+	struct iwl_notification_wait init_wait;
+	struct iwl_nvm_access_complete_cmd nvm_complete = {};
+	struct iwl_init_extended_cfg_cmd init_cfg = {
+		.init_flags = cpu_to_le32(BIT(IWL_INIT_NVM)),
+	};
+	static const u16 init_complete[] = {
+		INIT_COMPLETE_NOTIF,
+	};
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	iwl_init_notification_wait(&mvm->notif_wait,
+				   &init_wait,
+				   init_complete,
+				   ARRAY_SIZE(init_complete),
+				   iwl_wait_init_complete,
+				   NULL);
+
+	/* Will also start the device */
+	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
+		goto error;
+	}
+
+	/* Send init config command to mark that we are sending NVM access
+	 * commands
+	 */
+	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(SYSTEM_GROUP,
+						INIT_EXTENDED_CFG_CMD), 0,
+				   sizeof(init_cfg), &init_cfg);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to run init config command: %d\n",
+			ret);
+		goto error;
+	}
+
+	/* Read the NVM only at driver load time, no need to do this twice */
+	if (read_nvm) {
+		/* Read nvm */
+		ret = iwl_nvm_init(mvm, true);
+		if (ret) {
+			IWL_ERR(mvm, "Failed to read NVM: %d\n", ret);
+			goto error;
+		}
+	}
+
+	/* In case we read the NVM from external file, load it to the NIC */
+	if (mvm->nvm_file_name)
+		iwl_mvm_load_nvm_to_nic(mvm);
+
+	ret = iwl_nvm_check_version(mvm->nvm_data, mvm->trans);
+	if (WARN_ON(ret))
+		goto error;
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(REGULATORY_AND_NVM_GROUP,
+						NVM_ACCESS_COMPLETE), 0,
+				   sizeof(nvm_complete), &nvm_complete);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to run complete NVM access: %d\n",
+			ret);
+		goto error;
+	}
+
+	/* We wait for the INIT complete notification */
+	return iwl_wait_notification(&mvm->notif_wait, &init_wait,
+				     MVM_UCODE_ALIVE_TIMEOUT);
+
+error:
+	iwl_remove_notification(&mvm->notif_wait, &init_wait);
+	return ret;
+}
+
 static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 {
 	struct iwl_phy_cfg_cmd phy_cfg_cmd;
@@ -726,6 +802,9 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	};
 	int ret;
 
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return iwl_run_unified_mvm_ucode(mvm, true);
+
 	lockdep_assert_held(&mvm->mutex);
 
 	if (WARN_ON_ONCE(mvm->calibrating))
@@ -832,82 +911,6 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	return ret;
 }
 
-int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
-{
-	struct iwl_notification_wait init_wait;
-	struct iwl_nvm_access_complete_cmd nvm_complete = {};
-	struct iwl_init_extended_cfg_cmd init_cfg = {
-		.init_flags = cpu_to_le32(BIT(IWL_INIT_NVM)),
-	};
-	static const u16 init_complete[] = {
-		INIT_COMPLETE_NOTIF,
-	};
-	int ret;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	iwl_init_notification_wait(&mvm->notif_wait,
-				   &init_wait,
-				   init_complete,
-				   ARRAY_SIZE(init_complete),
-				   iwl_wait_init_complete,
-				   NULL);
-
-	/* Will also start the device */
-	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
-	if (ret) {
-		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
-		goto error;
-	}
-
-	/* Send init config command to mark that we are sending NVM access
-	 * commands
-	 */
-	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(SYSTEM_GROUP,
-						INIT_EXTENDED_CFG_CMD), 0,
-				   sizeof(init_cfg), &init_cfg);
-	if (ret) {
-		IWL_ERR(mvm, "Failed to run init config command: %d\n",
-			ret);
-		goto error;
-	}
-
-	/* Read the NVM only at driver load time, no need to do this twice */
-	if (read_nvm) {
-		/* Read nvm */
-		ret = iwl_nvm_init(mvm, true);
-		if (ret) {
-			IWL_ERR(mvm, "Failed to read NVM: %d\n", ret);
-			goto error;
-		}
-	}
-
-	/* In case we read the NVM from external file, load it to the NIC */
-	if (mvm->nvm_file_name)
-		iwl_mvm_load_nvm_to_nic(mvm);
-
-	ret = iwl_nvm_check_version(mvm->nvm_data, mvm->trans);
-	if (WARN_ON(ret))
-		goto error;
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(REGULATORY_AND_NVM_GROUP,
-						NVM_ACCESS_COMPLETE), 0,
-				   sizeof(nvm_complete), &nvm_complete);
-	if (ret) {
-		IWL_ERR(mvm, "Failed to run complete NVM access: %d\n",
-			ret);
-		goto error;
-	}
-
-	/* We wait for the INIT complete notification */
-	return iwl_wait_notification(&mvm->notif_wait, &init_wait,
-				     MVM_UCODE_ALIVE_TIMEOUT);
-
-error:
-	iwl_remove_notification(&mvm->notif_wait, &init_wait);
-	return ret;
-}
-
 static void iwl_mvm_parse_shared_mem_a000(struct iwl_mvm *mvm,
 					  struct iwl_rx_packet *pkt)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1938dfb44152..ab87c0203b6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1312,7 +1312,6 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm);
  ******************/
 /* uCode */
 int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm);
-int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm);
 
 /* Utils */
 int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 888053323c92..363930510a6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -746,10 +746,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
-	if (iwl_mvm_has_new_tx_api(mvm))
-		err = iwl_run_unified_mvm_ucode(mvm, true);
-	else
-		err = iwl_run_init_mvm_ucode(mvm, true);
+	err = iwl_run_init_mvm_ucode(mvm, true);
 	if (!err || !iwlmvm_mod_params.init_dbg)
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
-- 
2.11.0
