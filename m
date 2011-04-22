Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab1DVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/10] iwlagn: implement synchronous firmware load
Date: Fri, 22 Apr 2011 10:33:16 -0700
Message-Id: <1303493598-10979-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current firmware loading mechanism in
iwlwifi is very hard to follow, and thus
hard to maintain. To make it easier, make
the firmware loading synchronous.

For now, as a side effect, this removes a
number of retry possibilities we had. It
isn't typical for this to fail, but if it
does happen we restart from scratch which
this also makes easier to do should it be
necessary.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |  240 ++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  190 ++++++---------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   13 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   13 ++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   50 ------
 8 files changed, 246 insertions(+), 274 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a29e2e2..8216e5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -483,8 +483,6 @@ void iwlagn_rx_handler_setup(struct iwl_priv *priv)
 	/* init calibration handlers */
 	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
 					iwlagn_rx_calib_result;
-	priv->rx_handlers[CALIBRATION_COMPLETE_NOTIFICATION] =
-					iwlagn_rx_calib_complete;
 	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
 
 	/* set up notification wait support */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 5c30f6b..56dc771 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -161,8 +161,8 @@ static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
 }
 
 static int iwlagn_load_given_ucode(struct iwl_priv *priv,
-		struct fw_desc *inst_image,
-		struct fw_desc *data_image)
+				   struct fw_desc *inst_image,
+				   struct fw_desc *data_image)
 {
 	int ret = 0;
 
@@ -175,33 +175,6 @@ static int iwlagn_load_given_ucode(struct iwl_priv *priv,
 				    IWLAGN_RTC_DATA_LOWER_BOUND);
 }
 
-int iwlagn_load_ucode(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	/* check whether init ucode should be loaded, or rather runtime ucode */
-	if (priv->ucode_init.len && (priv->ucode_type == UCODE_NONE)) {
-		IWL_DEBUG_INFO(priv, "Init ucode found. Loading init ucode...\n");
-		ret = iwlagn_load_given_ucode(priv,
-			&priv->ucode_init, &priv->ucode_init_data);
-		if (!ret) {
-			IWL_DEBUG_INFO(priv, "Init ucode load complete.\n");
-			priv->ucode_type = UCODE_INIT;
-		}
-	} else {
-		IWL_DEBUG_INFO(priv, "Init ucode not found, or already loaded. "
-			"Loading runtime ucode...\n");
-		ret = iwlagn_load_given_ucode(priv,
-			&priv->ucode_code, &priv->ucode_data);
-		if (!ret) {
-			IWL_DEBUG_INFO(priv, "Runtime ucode load complete.\n");
-			priv->ucode_type = UCODE_RT;
-		}
-	}
-
-	return ret;
-}
-
 /*
  *  Calibration
  */
@@ -297,33 +270,9 @@ void iwlagn_rx_calib_result(struct iwl_priv *priv,
 	iwl_calib_set(&priv->calib_results[index], pkt->u.raw, len);
 }
 
-void iwlagn_rx_calib_complete(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb)
+static int iwlagn_init_alive_start(struct iwl_priv *priv)
 {
-	IWL_DEBUG_INFO(priv, "Init. calibration is completed, restarting fw.\n");
-	queue_work(priv->workqueue, &priv->restart);
-}
-
-void iwlagn_init_alive_start(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	/* initialize uCode was loaded... verify inst image.
-	 * This is a paranoid check, because we would not have gotten the
-	 * "initialize" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv, &priv->ucode_init)) {
-		/* Runtime instruction load was bad;
-		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO(priv, "Bad \"initialize\" uCode load.\n");
-		goto restart;
-	}
-
-	ret = iwlagn_alive_notify(priv);
-	if (ret) {
-		IWL_WARN(priv,
-			"Could not complete ALIVE transition: %d\n", ret);
-		goto restart;
-	}
+	int ret;
 
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist) {
@@ -333,24 +282,25 @@ void iwlagn_init_alive_start(struct iwl_priv *priv)
 		 * no need to close the envlope since we are going
 		 * to load the runtime uCode later.
 		 */
-		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
+		ret = iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
 			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+		if (ret)
+			return ret;
 
 	}
-	iwlagn_send_calib_cfg(priv);
+
+	ret = iwlagn_send_calib_cfg(priv);
+	if (ret)
+		return ret;
 
 	/**
 	 * temperature offset calibration is only needed for runtime ucode,
 	 * so prepare the value now.
 	 */
 	if (priv->cfg->need_temp_offset_calib)
-		iwlagn_set_temperature_offset_calib(priv);
-
-	return;
+		return iwlagn_set_temperature_offset_calib(priv);
 
-restart:
-	/* real restart (first load init_ucode) */
-	queue_work(priv->workqueue, &priv->restart);
+	return 0;
 }
 
 static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
@@ -413,19 +363,22 @@ void iwlagn_send_prio_tbl(struct iwl_priv *priv)
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
 }
 
-void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
+int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 {
 	struct iwl_bt_coex_prot_env_cmd env_cmd;
+	int ret;
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_PROT_ENV,
-			     sizeof(env_cmd), &env_cmd))
+	ret = iwl_send_cmd_pdu(priv, REPLY_BT_COEX_PROT_ENV,
+			       sizeof(env_cmd), &env_cmd);
+	if (ret)
 		IWL_ERR(priv, "failed to send BT env command\n");
+	return ret;
 }
 
 
-int iwlagn_alive_notify(struct iwl_priv *priv)
+static int iwlagn_alive_notify(struct iwl_priv *priv)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
 	struct iwl_rxon_context *ctx;
@@ -604,7 +557,7 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-int iwl_verify_ucode(struct iwl_priv *priv, struct fw_desc *fw_desc)
+static int iwl_verify_ucode(struct iwl_priv *priv, struct fw_desc *fw_desc)
 {
 	if (!iwlcore_verify_inst_sparse(priv, fw_desc)) {
 		IWL_DEBUG_INFO(priv, "uCode is good in inst SRAM\n");
@@ -616,3 +569,154 @@ int iwl_verify_ucode(struct iwl_priv *priv, struct fw_desc *fw_desc)
 	iwl_print_mismatch_inst(priv, fw_desc);
 	return -EIO;
 }
+
+struct iwlagn_alive_data {
+	bool valid;
+	u8 subtype;
+};
+
+static void iwlagn_alive_fn(struct iwl_priv *priv,
+			    struct iwl_rx_packet *pkt,
+			    void *data)
+{
+	struct iwlagn_alive_data *alive_data = data;
+	struct iwl_alive_resp *palive;
+
+	palive = &pkt->u.alive_frame;
+
+	IWL_DEBUG_INFO(priv, "Alive ucode status 0x%08X revision "
+		       "0x%01X 0x%01X\n",
+		       palive->is_valid, palive->ver_type,
+		       palive->ver_subtype);
+
+	priv->device_pointers.error_event_table =
+		le32_to_cpu(palive->error_event_table_ptr);
+	priv->device_pointers.log_event_table =
+		le32_to_cpu(palive->log_event_table_ptr);
+
+	alive_data->subtype = palive->ver_subtype;
+	alive_data->valid = palive->is_valid == UCODE_VALID_OK;
+}
+
+#define UCODE_ALIVE_TIMEOUT	HZ
+#define UCODE_CALIB_TIMEOUT	(2*HZ)
+
+int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
+				 struct fw_desc *inst_image,
+				 struct fw_desc *data_image,
+				 int subtype, int alternate_subtype)
+{
+	struct iwl_notification_wait alive_wait;
+	struct iwlagn_alive_data alive_data;
+	int ret;
+	enum iwlagn_ucode_subtype old_type;
+
+	ret = iwlagn_start_device(priv);
+	if (ret)
+		return ret;
+
+	iwlagn_init_notification_wait(priv, &alive_wait, REPLY_ALIVE,
+				      iwlagn_alive_fn, &alive_data);
+
+	old_type = priv->ucode_type;
+	priv->ucode_type = subtype;
+
+	ret = iwlagn_load_given_ucode(priv, inst_image, data_image);
+	if (ret) {
+		priv->ucode_type = old_type;
+		iwlagn_remove_notification(priv, &alive_wait);
+		return ret;
+	}
+
+	/* Remove all resets to allow NIC to operate */
+	iwl_write32(priv, CSR_RESET, 0);
+
+	/*
+	 * Some things may run in the background now, but we
+	 * just wait for the ALIVE notification here.
+	 */
+	ret = iwlagn_wait_notification(priv, &alive_wait, UCODE_ALIVE_TIMEOUT);
+	if (ret) {
+		priv->ucode_type = old_type;
+		return ret;
+	}
+
+	if (!alive_data.valid) {
+		IWL_ERR(priv, "Loaded ucode is not valid!\n");
+		priv->ucode_type = old_type;
+		return -EIO;
+	}
+
+	if (alive_data.subtype != subtype &&
+	    alive_data.subtype != alternate_subtype) {
+		IWL_ERR(priv,
+			"Loaded ucode is not expected type (got %d, expected %d)!\n",
+			alive_data.subtype, subtype);
+		priv->ucode_type = old_type;
+		return -EIO;
+	}
+
+	ret = iwl_verify_ucode(priv, inst_image);
+	if (ret) {
+		priv->ucode_type = old_type;
+		return ret;
+	}
+
+	/* delay a bit to give rfkill time to run */
+	msleep(5);
+
+	ret = iwlagn_alive_notify(priv);
+	if (ret) {
+		IWL_WARN(priv,
+			"Could not complete ALIVE transition: %d\n", ret);
+		priv->ucode_type = old_type;
+		return ret;
+	}
+
+	return 0;
+}
+
+int iwlagn_run_init_ucode(struct iwl_priv *priv)
+{
+	struct iwl_notification_wait calib_wait;
+	int ret;
+
+	lockdep_assert_held(&priv->mutex);
+
+	/* No init ucode required? Curious, but maybe ok */
+	if (!priv->ucode_init.len)
+		return 0;
+
+	if (priv->ucode_type != UCODE_SUBTYPE_NONE_LOADED)
+		return 0;
+
+	iwlagn_init_notification_wait(priv, &calib_wait,
+				      CALIBRATION_COMPLETE_NOTIFICATION,
+				      NULL, NULL);
+
+	/* Will also start the device */
+	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_init,
+					   &priv->ucode_init_data,
+					   UCODE_SUBTYPE_INIT, -1);
+	if (ret)
+		goto error;
+
+	ret = iwlagn_init_alive_start(priv);
+	if (ret)
+		goto error;
+
+	/*
+	 * Some things may run in the background now, but we
+	 * just wait for the calibration complete notification.
+	 */
+	ret = iwlagn_wait_notification(priv, &calib_wait, UCODE_CALIB_TIMEOUT);
+
+	goto out;
+
+ error:
+	iwlagn_remove_notification(priv, &calib_wait);
+ out:
+	/* Whatever happened, stop the device */
+	iwlagn_stop_device(priv);
+	return ret;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a9204db..12cd5e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1181,12 +1181,6 @@ static void iwl_dealloc_ucode_pci(struct iwl_priv *priv)
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init_data);
 }
 
-static void iwl_nic_start(struct iwl_priv *priv)
-{
-	/* Remove all resets to allow NIC to operate */
-	iwl_write32(priv, CSR_RESET, 0);
-}
-
 struct iwlagn_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
@@ -1873,7 +1867,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	struct iwl_error_event_table table;
 
 	base = priv->device_pointers.error_event_table;
-	if (priv->ucode_type == UCODE_INIT) {
+	if (priv->ucode_type == UCODE_SUBTYPE_INIT) {
 		if (!base)
 			base = priv->_agn.init_errlog_ptr;
 	} else {
@@ -1884,7 +1878,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
-			base, (priv->ucode_type == UCODE_INIT) ? "Init" : "RT");
+			base,
+			(priv->ucode_type == UCODE_SUBTYPE_INIT)
+					? "Init" : "RT");
 		return;
 	}
 
@@ -1944,7 +1940,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		return pos;
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == UCODE_INIT) {
+	if (priv->ucode_type == UCODE_SUBTYPE_INIT) {
 		if (!base)
 			base = priv->_agn.init_evtlog_ptr;
 	} else {
@@ -2057,7 +2053,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	size_t bufsz = 0;
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == UCODE_INIT) {
+	if (priv->ucode_type == UCODE_SUBTYPE_INIT) {
 		logsize = priv->_agn.init_evtlog_size;
 		if (!base)
 			base = priv->_agn.init_evtlog_ptr;
@@ -2070,7 +2066,9 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
-			base, (priv->ucode_type == UCODE_INIT) ? "Init" : "RT");
+			base,
+			(priv->ucode_type == UCODE_SUBTYPE_INIT)
+					? "Init" : "RT");
 		return -EINVAL;
 	}
 
@@ -2217,30 +2215,14 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by iwl_init_alive_start()).
  */
-static void iwl_alive_start(struct iwl_priv *priv)
+static int iwl_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
-
-	/* Initialize uCode has loaded Runtime uCode ... verify inst image.
-	 * This is a paranoid check, because we would not have gotten the
-	 * "runtime" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv, &priv->ucode_code)) {
-		/* Runtime instruction load was bad;
-		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO(priv, "Bad runtime uCode load.\n");
-		goto restart;
-	}
-
-	ret = iwlagn_alive_notify(priv);
-	if (ret) {
-		IWL_WARN(priv,
-			"Could not complete ALIVE transition [ntf]: %d\n", ret);
-		goto restart;
-	}
+	iwl_reset_ict(priv);
 
+	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
 	/* After the ALIVE response, we can send host commands to the uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
@@ -2249,7 +2231,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	iwl_setup_watchdog(priv);
 
 	if (iwl_is_rfkill(priv))
-		return;
+		return -ERFKILL;
 
 	/* download priority table before any calibration request */
 	if (priv->cfg->bt_params &&
@@ -2263,10 +2245,14 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		iwlagn_send_prio_tbl(priv);
 
 		/* FIXME: w/a to force change uCode BT state machine */
-		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
-			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
-		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
-			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+		ret = iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
+					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+		if (ret)
+			return ret;
+		ret = iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
+					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+		if (ret)
+			return ret;
 	}
 	if (priv->hw_params.calib_rt_cfg)
 		iwlagn_send_calib_cfg_rt(priv, priv->hw_params.calib_rt_cfg);
@@ -2308,22 +2294,16 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 
 	/* Configure the adapter for unassociated operation */
-	iwlcore_commit_rxon(priv, ctx);
+	ret = iwlcore_commit_rxon(priv, ctx);
+	if (ret)
+		return ret;
 
 	/* At this point, the NIC is initialized and operational */
 	iwl_rf_kill_ct_config(priv);
 
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
-	wake_up_interruptible(&priv->wait_command_queue);
-
-	iwl_power_update_mode(priv, true);
-	IWL_DEBUG_INFO(priv, "Updated power mode\n");
-
 
-	return;
-
- restart:
-	queue_work(priv->workqueue, &priv->restart);
+	return iwl_power_update_mode(priv, true);
 }
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv);
@@ -2446,9 +2426,10 @@ int iwl_prepare_card_hw(struct iwl_priv *priv)
 static int __iwl_up(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
-	int i;
 	int ret;
 
+	lockdep_assert_held(&priv->mutex);
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
 		return -EIO;
@@ -2462,39 +2443,34 @@ static int __iwl_up(struct iwl_priv *priv)
 		}
 	}
 
-	ret = iwlagn_start_device(priv);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < MAX_HW_RESTARTS; i++) {
-
-		/* load bootstrap state machine,
-		 * load bootstrap program into processor's memory,
-		 * prepare to load the "initialize" uCode */
-		ret = iwlagn_load_ucode(priv);
-
-		if (ret) {
-			IWL_ERR(priv, "Unable to set up bootstrap uCode: %d\n",
-				ret);
-			continue;
-		}
-
-		/* start card; "initialize" will load runtime ucode */
-		iwl_nic_start(priv);
-
-		IWL_DEBUG_INFO(priv, DRV_NAME " is coming up\n");
+	ret = iwlagn_run_init_ucode(priv);
+	if (ret) {
+		IWL_ERR(priv, "Failed to run INIT ucode: %d\n", ret);
+		goto error;
+	}
 
-		return 0;
+	ret = iwlagn_load_ucode_wait_alive(priv,
+					   &priv->ucode_code,
+					   &priv->ucode_data,
+					   UCODE_SUBTYPE_REGULAR,
+					   UCODE_SUBTYPE_REGULAR_NEW);
+	if (ret) {
+		IWL_ERR(priv, "Failed to start RT ucode: %d\n", ret);
+		goto error;
 	}
 
+	ret = iwl_alive_start(priv);
+	if (ret)
+		goto error;
+	return 0;
+
+ error:
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	__iwl_down(priv);
 	clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	/* tried to restart and config the device for as long as our
-	 * patience could withstand */
-	IWL_ERR(priv, "Unable to initialize device after %d attempts.\n", i);
-	return -EIO;
+	IWL_ERR(priv, "Unable to initialize device.\n");
+	return ret;
 }
 
 
@@ -2504,39 +2480,6 @@ static int __iwl_up(struct iwl_priv *priv)
  *
  *****************************************************************************/
 
-static void iwl_bg_init_alive_start(struct work_struct *data)
-{
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, init_alive_start.work);
-
-	mutex_lock(&priv->mutex);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
-	iwlagn_init_alive_start(priv);
-	mutex_unlock(&priv->mutex);
-}
-
-static void iwl_bg_alive_start(struct work_struct *data)
-{
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, alive_start.work);
-
-	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		goto unlock;
-
-	/* enable dram interrupt */
-	iwl_reset_ict(priv);
-
-	iwl_alive_start(priv);
-unlock:
-	mutex_unlock(&priv->mutex);
-}
-
 static void iwl_bg_run_time_calib_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
@@ -2602,14 +2545,7 @@ static void iwl_bg_restart(struct work_struct *data)
 		iwl_cancel_deferred_work(priv);
 		ieee80211_restart_hw(priv->hw);
 	} else {
-		iwl_down(priv);
-
-		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-			return;
-
-		mutex_lock(&priv->mutex);
-		__iwl_up(priv);
-		mutex_unlock(&priv->mutex);
+		WARN_ON(1);
 	}
 }
 
@@ -2720,8 +2656,6 @@ unlock:
  *
  *****************************************************************************/
 
-#define UCODE_READY_TIMEOUT	(4 * HZ)
-
 /*
  * Not a mac80211 entry point function, but it fits in with all the
  * other mac80211 functions grouped here.
@@ -2814,31 +2748,17 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 	mutex_lock(&priv->mutex);
 	ret = __iwl_up(priv);
 	mutex_unlock(&priv->mutex);
-
 	if (ret)
 		return ret;
 
-	if (iwl_is_rfkill(priv))
-		goto out;
-
 	IWL_DEBUG_INFO(priv, "Start UP work done.\n");
 
-	/* Wait for START_ALIVE from Run Time ucode. Otherwise callbacks from
-	 * mac80211 will not be run successfully. */
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-			test_bit(STATUS_READY, &priv->status),
-			UCODE_READY_TIMEOUT);
-	if (!ret) {
-		if (!test_bit(STATUS_READY, &priv->status)) {
-			IWL_ERR(priv, "START_ALIVE timeout after %dms.\n",
-				jiffies_to_msecs(UCODE_READY_TIMEOUT));
-			return -ETIMEDOUT;
-		}
-	}
+	/* Now we should be done, and the READY bit should be set. */
+	if (WARN_ON(!test_bit(STATUS_READY, &priv->status)))
+		ret = -EIO;
 
 	iwlagn_led_enable(priv);
 
-out:
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
@@ -3425,8 +3345,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
 	INIT_WORK(&priv->bt_full_concurrency, iwl_bg_bt_full_concurrency);
 	INIT_WORK(&priv->bt_runtime_config, iwl_bg_bt_runtime_config);
-	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
-	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->_agn.hw_roc_work, iwlagn_bg_roc_done);
 
 	iwl_setup_scan_deferred_work(priv);
@@ -3455,8 +3373,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	if (priv->cfg->ops->lib->cancel_deferred_work)
 		priv->cfg->ops->lib->cancel_deferred_work(priv);
 
-	cancel_delayed_work_sync(&priv->init_alive_start);
-	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
 
@@ -3691,6 +3607,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv = hw->priv;
 	/* At this point both hw and priv are allocated. */
 
+	priv->ucode_type = UCODE_SUBTYPE_NONE_LOADED;
+
 	/*
 	 * The default context is always valid,
 	 * more may be discovered when firmware
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ba90aa4..cf05f87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -158,16 +158,15 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			     u32 changes);
 
 /* uCode */
-int iwlagn_load_ucode(struct iwl_priv *priv);
 void iwlagn_rx_calib_result(struct iwl_priv *priv,
 			 struct iwl_rx_mem_buffer *rxb);
-void iwlagn_rx_calib_complete(struct iwl_priv *priv,
-			   struct iwl_rx_mem_buffer *rxb);
-void iwlagn_init_alive_start(struct iwl_priv *priv);
-int iwlagn_alive_notify(struct iwl_priv *priv);
-int iwl_verify_ucode(struct iwl_priv *priv, struct fw_desc *fw_desc);
-void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
+int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwlagn_send_prio_tbl(struct iwl_priv *priv);
+int iwlagn_run_init_ucode(struct iwl_priv *priv);
+int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
+				 struct fw_desc *inst_image,
+				 struct fw_desc *data_image,
+				 int subtype, int alternate_subtype);
 
 /* lib */
 void iwl_check_abort_status(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 7aea7b3..e125896 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -386,7 +386,18 @@ struct iwl_tx_ant_config_cmd {
  *****************************************************************************/
 
 #define UCODE_VALID_OK	cpu_to_le32(0x1)
-#define INITIALIZE_SUBTYPE    (9)
+
+enum iwlagn_ucode_subtype {
+	UCODE_SUBTYPE_REGULAR	= 0,
+	UCODE_SUBTYPE_REGULAR_NEW = 1,
+	UCODE_SUBTYPE_INIT	= 9,
+
+	/*
+	 * Not a valid subtype, the ucode has just a u8, so
+	 * we can use something > 0xff for this value.
+	 */
+	UCODE_SUBTYPE_NONE_LOADED = 0x100,
+};
 
 /**
  * REPLY_ALIVE = 0x1 (response only, not a command)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index c272204..2b60688 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -226,7 +226,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;
-		if (priv->ucode_type == UCODE_INIT)
+		if (priv->ucode_type == UCODE_SUBTYPE_INIT)
 			priv->dbgfs_sram_len = priv->ucode_init_data.len;
 		else
 			priv->dbgfs_sram_len = priv->ucode_data.len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0345292..414968c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -794,12 +794,6 @@ struct iwl_calib_result {
 	size_t buf_len;
 };
 
-enum ucode_type {
-	UCODE_NONE = 0,
-	UCODE_INIT,
-	UCODE_RT
-};
-
 /* Sensitivity calib data */
 struct iwl_sensitivity_data {
 	u32 auto_corr_ofdm;
@@ -1276,7 +1270,7 @@ struct iwl_priv {
 	struct fw_desc ucode_data;	/* runtime data original */
 	struct fw_desc ucode_init;	/* initialization inst */
 	struct fw_desc ucode_init_data;	/* initialization data */
-	enum ucode_type ucode_type;
+	enum iwlagn_ucode_subtype ucode_type;
 	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
 
@@ -1474,8 +1468,6 @@ struct iwl_priv {
 
 	struct tasklet_struct irq_tasklet;
 
-	struct delayed_work init_alive_start;
-	struct delayed_work alive_start;
 	struct delayed_work scan_check;
 
 	/* TX Power */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b49819c..aca9a1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -225,55 +225,6 @@ err_bd:
  *
  ******************************************************************************/
 
-static void iwl_rx_reply_alive(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_alive_resp *palive;
-	struct delayed_work *pwork;
-
-	palive = &pkt->u.alive_frame;
-
-	IWL_DEBUG_INFO(priv, "Alive ucode status 0x%08X revision "
-		       "0x%01X 0x%01X\n",
-		       palive->is_valid, palive->ver_type,
-		       palive->ver_subtype);
-
-	priv->device_pointers.log_event_table =
-		le32_to_cpu(palive->log_event_table_ptr);
-	priv->device_pointers.error_event_table =
-		le32_to_cpu(palive->error_event_table_ptr);
-
-	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
-		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
-		pwork = &priv->init_alive_start;
-	} else {
-		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
-		pwork = &priv->alive_start;
-	}
-
-	/* We delay the ALIVE response by 5ms to
-	 * give the HW RF Kill time to activate... */
-	if (palive->is_valid == UCODE_VALID_OK)
-		queue_delayed_work(priv->workqueue, pwork,
-				   msecs_to_jiffies(5));
-	else {
-		IWL_WARN(priv, "%s uCode did not respond OK.\n",
-			(palive->ver_subtype == INITIALIZE_SUBTYPE) ?
-			"init" : "runtime");
-		/*
-		 * If fail to load init uCode,
-		 * let's try to load the init uCode again.
-		 * We should not get into this situation, but if it
-		 * does happen, we should not move on and loading "runtime"
-		 * without proper calibrate the device.
-		 */
-		if (palive->ver_subtype == INITIALIZE_SUBTYPE)
-			priv->ucode_type = UCODE_NONE;
-		queue_work(priv->workqueue, &priv->restart);
-	}
-}
-
 static void iwl_rx_reply_error(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb)
 {
@@ -1125,7 +1076,6 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 
 	handlers = priv->rx_handlers;
 
-	handlers[REPLY_ALIVE]			= iwl_rx_reply_alive;
 	handlers[REPLY_ERROR]			= iwl_rx_reply_error;
 	handlers[CHANNEL_SWITCH_NOTIFICATION]	= iwl_rx_csa;
 	handlers[SPECTRUM_MEASURE_NOTIFICATION]	= iwl_rx_spectrum_measure_notif;
-- 
1.7.0.4

