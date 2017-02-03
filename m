Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37862 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753429AbdBCOia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:49 +0200
Message-Id: <20170203143812.7525-3-luca@coelho.fi> (sfid-20170203_153844_456440_BF7B5933)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: mvm: support unification of INIT and RT images
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For a000 devices the INIT and RT images are unified to one
image.
The changes in the flow are the following:
* Driver load only RT firmware - meaning that the nvm access
  command will be done in the RT image load flow.
* A new command (NVM_ACCESS_COMPLETE) now signals to the FW that
  the driver is done accessing the NVM and FW can proceed with phy
  calibrations.
* Phy DB is no longer sent from INIT FW to be restored by driver
  for the RT FW - all the phy DB is now internal to the FW.
  INIT complete will now follow the NVM access command, without
  phy DB calls before.
* Paging command is sent earlier in the flow before NVM access
  to enable a complete load of FW.
* caution must be care when restart is called since we may have
  not completed init flow even though we are in RT firmware.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |  12 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 208 ++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  24 ++-
 5 files changed, 188 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 567597c26115..563b17796017 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -341,6 +341,10 @@ enum iwl_prot_offload_subcmd_ids {
 	STORED_BEACON_NTF = 0xFF,
 };
 
+enum iwl_regulatory_and_nvm_subcmd_ids {
+	NVM_ACCESS_COMPLETE = 0x0,
+};
+
 enum iwl_fmac_debug_cmds {
 	LMAC_RD_WR = 0x0,
 	UMAC_RD_WR = 0x1,
@@ -355,6 +359,7 @@ enum {
 	PHY_OPS_GROUP = 0x4,
 	DATA_PATH_GROUP = 0x5,
 	PROT_OFFLOAD_GROUP = 0xb,
+	REGULATORY_AND_NVM_GROUP = 0xc,
 	DEBUG_GROUP = 0xf,
 };
 
@@ -2200,4 +2205,11 @@ struct iwl_dbg_mem_access_rsp {
 	__le32 data[];
 } __packed; /* DEBUG_(U|L)MAC_RD_WR_RSP_API_S_VER_1 */
 
+/**
+ * struct iwl_nvm_access_complete_cmd - NVM_ACCESS commands are completed
+ */
+struct iwl_nvm_access_complete_cmd {
+	__le32 reserved;
+} __packed; /* NVM_ACCESS_COMPLETE_CMD_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index b278e44e97ad..dd8c8d8e9f18 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -522,6 +522,14 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	return true;
 }
 
+static bool iwl_wait_init_complete(struct iwl_notif_wait_data *notif_wait,
+				   struct iwl_rx_packet *pkt, void *data)
+{
+	WARN_ON(pkt->hdr.cmd != INIT_COMPLETE_NOTIF);
+
+	return true;
+}
+
 static bool iwl_wait_phy_db_entry(struct iwl_notif_wait_data *notif_wait,
 				  struct iwl_rx_packet *pkt, void *data)
 {
@@ -537,6 +545,48 @@ static bool iwl_wait_phy_db_entry(struct iwl_notif_wait_data *notif_wait,
 	return false;
 }
 
+static int iwl_mvm_init_paging(struct iwl_mvm *mvm)
+{
+	const struct fw_img *fw = &mvm->fw->img[mvm->cur_ucode];
+	int ret;
+
+	/*
+	 * Configure and operate fw paging mechanism.
+	 * The driver configures the paging flow only once.
+	 * The CPU2 paging image is included in the IWL_UCODE_INIT image.
+	 */
+	if (!fw->paging_mem_size)
+		return 0;
+
+	/*
+	 * When dma is not enabled, the driver needs to copy / write
+	 * the downloaded / uploaded page to / from the smem.
+	 * This gets the location of the place were the pages are
+	 * stored.
+	 */
+	if (!is_device_dma_capable(mvm->trans->dev)) {
+		ret = iwl_trans_get_paging_item(mvm);
+		if (ret) {
+			IWL_ERR(mvm, "failed to get FW paging item\n");
+			return ret;
+		}
+	}
+
+	ret = iwl_save_fw_paging(mvm, fw);
+	if (ret) {
+		IWL_ERR(mvm, "failed to save the FW paging image\n");
+		return ret;
+	}
+
+	ret = iwl_send_paging_cmd(mvm, fw);
+	if (ret) {
+		IWL_ERR(mvm, "failed to send the paging cmd\n");
+		iwl_free_fw_paging(mvm);
+		return ret;
+	}
+
+	return 0;
+}
 static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 					 enum iwl_ucode_type ucode_type)
 {
@@ -608,40 +658,6 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	iwl_trans_fw_alive(mvm->trans, alive_data.scd_base_addr);
 
 	/*
-	 * configure and operate fw paging mechanism.
-	 * driver configures the paging flow only once, CPU2 paging image
-	 * included in the IWL_UCODE_INIT image.
-	 */
-	if (fw->paging_mem_size) {
-		/*
-		 * When dma is not enabled, the driver needs to copy / write
-		 * the downloaded / uploaded page to / from the smem.
-		 * This gets the location of the place were the pages are
-		 * stored.
-		 */
-		if (!is_device_dma_capable(mvm->trans->dev)) {
-			ret = iwl_trans_get_paging_item(mvm);
-			if (ret) {
-				IWL_ERR(mvm, "failed to get FW paging item\n");
-				return ret;
-			}
-		}
-
-		ret = iwl_save_fw_paging(mvm, fw);
-		if (ret) {
-			IWL_ERR(mvm, "failed to save the FW paging image\n");
-			return ret;
-		}
-
-		ret = iwl_send_paging_cmd(mvm, fw);
-		if (ret) {
-			IWL_ERR(mvm, "failed to send the paging cmd\n");
-			iwl_free_fw_paging(mvm);
-			return ret;
-		}
-	}
-
-	/*
 	 * Note: all the queues are enabled as part of the interface
 	 * initialization, but in firmware restart scenarios they
 	 * could be stopped, so wake them up. In firmware restart,
@@ -798,6 +814,75 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	return ret;
 }
 
+int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
+{
+	struct iwl_notification_wait init_wait;
+	struct iwl_nvm_access_complete_cmd nvm_complete = {};
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
+	/* TODO: remove when integrating context info */
+	ret = iwl_mvm_init_paging(mvm);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to init paging: %d\n",
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
 static void iwl_mvm_parse_shared_mem_a000(struct iwl_mvm *mvm,
 					  struct iwl_rx_packet *pkt)
 {
@@ -1058,23 +1143,13 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 	return ret;
 }
 
-int iwl_mvm_up(struct iwl_mvm *mvm)
+static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
 {
-	int ret, i;
-	struct ieee80211_channel *chan;
-	struct cfg80211_chan_def chandef;
-
-	lockdep_assert_held(&mvm->mutex);
+	int ret;
 
-	ret = iwl_trans_start_hw(mvm->trans);
-	if (ret)
-		return ret;
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return iwl_run_unified_mvm_ucode(mvm, false);
 
-	/*
-	 * If we haven't completed the run of the init ucode during
-	 * module loading, load init ucode now
-	 * (for example, if we were in RFKILL)
-	 */
 	ret = iwl_run_init_mvm_ucode(mvm, false);
 
 	if (iwlmvm_mod_params.init_dbg)
@@ -1085,7 +1160,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		/* this can't happen */
 		if (WARN_ON(ret > 0))
 			ret = -ERFKILL;
-		goto error;
+		return ret;
 	}
 
 	/*
@@ -1096,9 +1171,28 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	_iwl_trans_stop_device(mvm->trans, false);
 	ret = _iwl_trans_start_hw(mvm->trans, false);
 	if (ret)
-		goto error;
+		return ret;
 
 	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
+	if (ret)
+		return ret;
+
+	return iwl_mvm_init_paging(mvm);
+}
+
+int iwl_mvm_up(struct iwl_mvm *mvm)
+{
+	int ret, i;
+	struct ieee80211_channel *chan;
+	struct cfg80211_chan_def chandef;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ret = iwl_trans_start_hw(mvm->trans);
+	if (ret)
+		return ret;
+
+	ret = iwl_mvm_load_rt_fw(mvm);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
 		goto error;
@@ -1125,13 +1219,15 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		goto error;
 
 	/* Send phy db control command and then phy db calibration*/
-	ret = iwl_send_phy_db_data(mvm->phy_db);
-	if (ret)
-		goto error;
+	if (!iwl_mvm_has_new_tx_api(mvm)) {
+		ret = iwl_send_phy_db_data(mvm->phy_db);
+		if (ret)
+			goto error;
 
-	ret = iwl_send_phy_cfg_cmd(mvm);
-	if (ret)
-		goto error;
+		ret = iwl_send_phy_cfg_cmd(mvm);
+		if (ret)
+			goto error;
+	}
 
 	/* Init RSS configuration */
 	if (iwl_mvm_has_new_rx_api(mvm)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 71f9aa9f7c7d..8d519c3f45bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1210,8 +1210,6 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	/* the fw is stopped, the aux sta is dead: clean up driver state */
 	iwl_mvm_del_aux_sta(mvm);
 
-	iwl_free_fw_paging(mvm);
-
 	/*
 	 * Clear IN_HW_RESTART flag when stopping the hw (as restart_complete()
 	 * won't be called in this case).
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index a672aa71c656..74156b24da16 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -739,6 +739,7 @@ struct iwl_mvm {
 
 	enum iwl_ucode_type cur_ucode;
 	bool ucode_loaded;
+	bool hw_registered;
 	bool calibrating;
 	u32 error_event_table;
 	u32 log_event_table;
@@ -1257,6 +1258,7 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm);
  ******************/
 /* uCode */
 int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm);
+int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm);
 
 /* Utils */
 int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
@@ -1686,6 +1688,7 @@ void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
+	iwl_free_fw_paging(mvm);
 	mvm->ucode_loaded = false;
 	iwl_trans_stop_device(mvm->trans);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f14aada390c5..4cd72d4cdc47 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -466,6 +466,13 @@ static const struct iwl_hcmd_names iwl_mvm_prot_offload_names[] = {
 	HCMD_NAME(STORED_BEACON_NTF),
 };
 
+/* Please keep this array *SORTED* by hex value.
+ * Access is done through binary search
+ */
+static const struct iwl_hcmd_names iwl_mvm_regulatory_and_nvm_names[] = {
+	HCMD_NAME(NVM_ACCESS_COMPLETE),
+};
+
 static const struct iwl_hcmd_arr iwl_mvm_groups[] = {
 	[LEGACY_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
 	[LONG_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
@@ -474,6 +481,8 @@ static const struct iwl_hcmd_arr iwl_mvm_groups[] = {
 	[PHY_OPS_GROUP] = HCMD_ARR(iwl_mvm_phy_names),
 	[DATA_PATH_GROUP] = HCMD_ARR(iwl_mvm_data_path_names),
 	[PROT_OFFLOAD_GROUP] = HCMD_ARR(iwl_mvm_prot_offload_names),
+	[REGULATORY_AND_NVM_GROUP] =
+		HCMD_ARR(iwl_mvm_regulatory_and_nvm_names),
 };
 
 /* this forward declaration can avoid to export the function */
@@ -597,7 +606,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		mvm->last_agg_queue = IWL_MVM_DQA_MAX_DATA_QUEUE;
 	}
 	mvm->sf_state = SF_UNINIT;
-	mvm->cur_ucode = IWL_UCODE_INIT;
+	if (iwl_mvm_has_new_tx_api(mvm))
+		mvm->cur_ucode = IWL_UCODE_REGULAR;
+	else
+		mvm->cur_ucode = IWL_UCODE_INIT;
 	mvm->drop_bcn_ap_mode = true;
 
 	mutex_init(&mvm->mutex);
@@ -720,7 +732,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
-	err = iwl_run_init_mvm_ucode(mvm, true);
+	if (iwl_mvm_has_new_tx_api(mvm))
+		err = iwl_run_unified_mvm_ucode(mvm, true);
+	else
+		err = iwl_run_init_mvm_ucode(mvm, true);
 	if (!err || !iwlmvm_mod_params.init_dbg)
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
@@ -743,6 +758,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	err = iwl_mvm_mac_setup_register(mvm);
 	if (err)
 		goto out_free;
+	mvm->hw_registered = true;
 
 	min_backoff = calc_min_backoff(trans, cfg);
 	iwl_mvm_thermal_initialize(mvm, min_backoff);
@@ -764,6 +780,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
  out_unregister:
 	ieee80211_unregister_hw(mvm->hw);
+	mvm->hw_registered = false;
 	iwl_mvm_leds_exit(mvm);
 	iwl_mvm_thermal_exit(mvm);
  out_free:
@@ -1192,7 +1209,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 		reprobe->dev = mvm->trans->dev;
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
-	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR) {
+	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR &&
+		   mvm->hw_registered) {
 		/* don't let the transport/FW power down */
 		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
-- 
2.11.0
