Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1GHQUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/21] iwlagn: consolidate the API that sends host commands and move to transport
Date: Fri,  8 Jul 2011 08:46:14 -0700
Message-Id: <1310139989-27661-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182114_164171_1F4B8775)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Now, there are only two functions to send a host command:
* send_cmd that receives a iwl_host_cmd
* send_cmd_pdu that builds the iwl_host_cmd itself and received flags

The flags CMD_ASYNC / CMD_SYNC / CMD_WANT_SKB are not changed by the API
functions.

Kill the unused flags CMD_SIZE_NORMAL / CMD_NO_SKB on the way.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    7 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |   16 ++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   17 +++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   17 ++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   11 +++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   18 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c      |   16 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h      |    9 +------
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   23 +++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |   32 ++++---------------------
 drivers/net/wireless/iwlwifi/iwl-led.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |    4 +++
 19 files changed, 100 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c55cec8..8209334 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -316,7 +316,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return iwl_send_cmd_sync(priv, &hcmd);
+	return priv->trans.ops->send_cmd(priv, &hcmd);
 }
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 965d010..2134514 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -255,7 +255,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return iwl_send_cmd_sync(priv, &hcmd);
+	return priv->trans.ops->send_cmd(priv, &hcmd);
 }
 
 static struct iwl_lib_ops iwl6000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index c9255de..e7c74fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -87,6 +87,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_PHY_CALIBRATION_CMD,
+		.flags = CMD_SYNC,
 	};
 
 	for (i = 0; i < IWL_CALIB_MAX; i++) {
@@ -95,7 +96,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 			hcmd.len[0] = priv->calib_results[i].buf_len;
 			hcmd.data[0] = priv->calib_results[i].buf;
 			hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-			ret = iwl_send_cmd_sync(priv, &hcmd);
+			ret = priv->trans.ops->send_cmd(priv, &hcmd);
 			if (ret) {
 				IWL_ERR(priv, "Error %d iteration %d\n",
 					ret, i);
@@ -481,7 +482,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
 	       sizeof(u16)*HD_TABLE_SIZE);
 
-	return iwl_send_cmd(priv, &cmd_out);
+	return priv->trans.ops->send_cmd(priv, &cmd_out);
 }
 
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
@@ -545,7 +546,7 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 	       &(cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX]),
 	       sizeof(u16)*ENHANCE_HD_TABLE_ENTRIES);
 
-	return iwl_send_cmd(priv, &cmd_out);
+	return priv->trans.ops->send_cmd(priv, &cmd_out);
 }
 
 void iwl_init_sensitivity(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index ce7d4b5..406bf59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -45,7 +45,9 @@ int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 
 	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
-		return iwl_send_cmd_pdu(priv, TX_ANT_CONFIGURATION_CMD,
+		return priv->trans.ops->send_cmd_pdu(priv,
+					TX_ANT_CONFIGURATION_CMD,
+					CMD_SYNC,
 					sizeof(struct iwl_tx_ant_config_cmd),
 					&tx_ant_cmd);
 	} else {
@@ -115,8 +117,8 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			priv->_agn.phy_calib_chain_noise_gain_cmd);
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
-		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
-			sizeof(cmd), &cmd, NULL);
+		priv->trans.ops->send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+			CMD_ASYNC, sizeof(cmd), &cmd);
 
 		data->radio_write = 1;
 		data->state = IWL_CHAIN_NOISE_CALIBRATED;
@@ -144,8 +146,9 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 		memset(&cmd, 0, sizeof(cmd));
 		iwl_set_calib_hdr(&cmd.hdr,
 			priv->_agn.phy_calib_chain_noise_reset_cmd);
-		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-					sizeof(cmd), &cmd);
+		ret = priv->trans.ops->send_cmd_pdu(priv,
+					REPLY_PHY_CALIBRATION_CMD,
+					CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
 			IWL_ERR(priv,
 				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
@@ -290,7 +293,8 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].width = cpu_to_le16(slot0);
 	cmd.slots[1].width = cpu_to_le16(slot1);
 
-	ret = iwl_send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, sizeof(cmd), &cmd);
+	ret = priv->trans.ops->send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, CMD_SYNC,
+			sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(priv, "Error setting PAN parameters (%d)\n", ret);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a926142..39664c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -540,8 +540,8 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return iwl_send_cmd_pdu(priv, tx_ant_cfg_cmd, sizeof(tx_power_cmd),
-				&tx_power_cmd);
+	return priv->trans.ops->send_cmd_pdu(priv, tx_ant_cfg_cmd, CMD_SYNC,
+			sizeof(tx_power_cmd), &tx_power_cmd);
 }
 
 void iwlagn_temperature(struct iwl_priv *priv)
@@ -1063,6 +1063,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = { sizeof(struct iwl_scan_cmd), },
+		.flags = CMD_SYNC,
 	};
 	struct iwl_scan_cmd *scan;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
@@ -1359,7 +1360,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (ret)
 		return ret;
 
-	ret = iwl_send_cmd_sync(priv, &cmd);
+	ret = priv->trans.ops->send_cmd(priv, &cmd);
 	if (ret) {
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 		iwlagn_set_pan_params(priv);
@@ -1465,7 +1466,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		       flush_cmd.fifo_control);
 	flush_cmd.flush_control = cpu_to_le16(flush_control);
 
-	return iwl_send_cmd(priv, &cmd);
+	return priv->trans.ops->send_cmd(priv, &cmd);
 }
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
@@ -1657,13 +1658,13 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	if (priv->cfg->bt_params->bt_session_2) {
 		memcpy(&bt_cmd_2000.basic, &basic,
 			sizeof(basic));
-		ret = iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			sizeof(bt_cmd_2000), &bt_cmd_2000);
+		ret = priv->trans.ops->send_cmd_pdu(priv, REPLY_BT_CONFIG,
+			CMD_SYNC, sizeof(bt_cmd_2000), &bt_cmd_2000);
 	} else {
 		memcpy(&bt_cmd_6000.basic, &basic,
 			sizeof(basic));
-		ret = iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			sizeof(bt_cmd_6000), &bt_cmd_6000);
+		ret = priv->trans.ops->send_cmd_pdu(priv, REPLY_BT_CONFIG,
+			CMD_SYNC, sizeof(bt_cmd_6000), &bt_cmd_6000);
 	}
 	if (ret)
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index c6bb73a..c365295 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -39,7 +39,8 @@ static int iwlagn_disable_bss(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd, sizeof(*send), send);
+	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd,
+				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
 
@@ -64,7 +65,8 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
-	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd, sizeof(*send), send);
+	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd,
+				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
 	send->dev_type = old_dev_type;
@@ -89,7 +91,8 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd, sizeof(*send), send);
+	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
+				sizeof(*send), send);
 
 	send->filter_flags = old_filter;
 
@@ -117,7 +120,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
-	ret = iwl_send_cmd_pdu(priv, ctx->qos_cmd,
+	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->qos_cmd, CMD_SYNC,
 			       sizeof(struct iwl_qosparam_cmd),
 			       &ctx->qos_data.def_qos_parm);
 	if (ret)
@@ -176,8 +179,8 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
 	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
 
-	ret = iwl_send_cmd_pdu_async(priv, ctx->rxon_assoc_cmd,
-				     sizeof(rxon_assoc), &rxon_assoc, NULL);
+	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_assoc_cmd,
+				CMD_ASYNC, sizeof(rxon_assoc), &rxon_assoc);
 	return ret;
 }
 
@@ -262,7 +265,7 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	 * Associated RXON doesn't clear the station table in uCode,
 	 * so we don't need to restore stations etc. after this.
 	 */
-	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
+	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
 		      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 	if (ret) {
 		IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 9b32f83..b0e54c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -180,7 +180,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 	cmd.len[0] = cmd_size;
 
 	if (not_empty || send_if_empty)
-		return iwl_send_cmd(priv, &cmd);
+		return priv->trans.ops->send_cmd(priv, &cmd);
 	else
 		return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 2043c8b..1976582 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -223,7 +223,7 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	calib_cfg_cmd.ucd_calib_cfg.once.send_res = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.flags = IWL_CALIB_INIT_CFG_ALL;
 
-	return iwl_send_cmd(priv, &cmd);
+	return priv->trans.ops->send_cmd(priv, &cmd);
 }
 
 void iwlagn_rx_calib_result(struct iwl_priv *priv,
@@ -321,7 +321,8 @@ static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
 		/* coexistence is disabled */
 		memset(&coex_cmd, 0, sizeof(coex_cmd));
 	}
-	return iwl_send_cmd_pdu(priv, COEX_PRIORITY_TABLE_CMD,
+	return priv->trans.ops->send_cmd_pdu(priv,
+				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
 }
 
@@ -353,7 +354,8 @@ void iwlagn_send_prio_tbl(struct iwl_priv *priv)
 
 	memcpy(prio_tbl_cmd.prio_tbl, iwlagn_bt_prio_tbl,
 		sizeof(iwlagn_bt_prio_tbl));
-	if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_PRIO_TABLE,
+	if (priv->trans.ops->send_cmd_pdu(priv,
+				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
 }
@@ -365,7 +367,8 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	ret = iwl_send_cmd_pdu(priv, REPLY_BT_COEX_PROT_ENV,
+	ret = priv->trans.ops->send_cmd_pdu(priv,
+			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
 		IWL_ERR(priv, "failed to send BT env command\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4d5b7cc..d56d17c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -129,6 +129,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_BEACON,
+		.flags = CMD_SYNC,
 	};
 	struct ieee80211_tx_info *info;
 	u32 frame_size;
@@ -205,7 +206,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	cmd.data[1] = priv->beacon_skb->data;
 	cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
 
-	return iwl_send_cmd_sync(priv, &cmd);
+	return priv->trans.ops->send_cmd(priv, &cmd);
 }
 
 static void iwl_bg_beacon_update(struct work_struct *work)
@@ -578,7 +579,8 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the buffer to caller,
-			 * and fire off the (possibly) blocking iwl_send_cmd()
+			 * and fire off the (possibly) blocking
+			 * priv->trans.ops->send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
 				iwl_tx_cmd_complete(priv, rxb);
@@ -1940,8 +1942,9 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		adv_cmd.critical_temperature_exit =
 			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
 
-		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
-				       sizeof(adv_cmd), &adv_cmd);
+		ret = priv->trans.ops->send_cmd_pdu(priv,
+				       REPLY_CT_KILL_CONFIG_CMD,
+				       CMD_SYNC, sizeof(adv_cmd), &adv_cmd);
 		if (ret)
 			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 		else
@@ -1955,8 +1958,9 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		cmd.critical_temperature_R =
 			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 
-		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
-				       sizeof(cmd), &cmd);
+		ret = priv->trans.ops->send_cmd_pdu(priv,
+				       REPLY_CT_KILL_CONFIG_CMD,
+				       CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
 			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 		else
@@ -1980,7 +1984,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.start = cpu_to_le32(cfg);
 
-	return iwl_send_cmd(priv, &cmd);
+	return priv->trans.ops->send_cmd(priv, &cmd);
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9bf4686..78e031e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -375,8 +375,8 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			le32_to_cpu(ctx->timing.beacon_init_val),
 			le16_to_cpu(ctx->timing.atim_window));
 
-	return iwl_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
-				sizeof(ctx->timing), &ctx->timing);
+	return priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_timing_cmd,
+				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
 }
 
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
@@ -1131,8 +1131,8 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
-	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			     sizeof(struct iwl_bt_cmd), &bt_cmd))
+	if (priv->trans.ops->send_cmd_pdu(priv, REPLY_BT_CONFIG,
+			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
 
@@ -1144,11 +1144,13 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 	};
 
 	if (flags & CMD_ASYNC)
-		return iwl_send_cmd_pdu_async(priv, REPLY_STATISTICS_CMD,
+		return priv->trans.ops->send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+					      CMD_ASYNC,
 					       sizeof(struct iwl_statistics_cmd),
-					       &statistics_cmd, NULL);
+					       &statistics_cmd);
 	else
-		return iwl_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+		return priv->trans.ops->send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+					CMD_SYNC,
 					sizeof(struct iwl_statistics_cmd),
 					&statistics_cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 76f6535..3f7b921 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -434,16 +434,9 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
  *****************************************************/
 
 const char *get_cmd_string(u8 cmd);
-int __must_check iwl_send_cmd_sync(struct iwl_priv *priv,
-				   struct iwl_host_cmd *cmd);
 int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
-int __must_check iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id,
+int __must_check iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
 				  u16 len, const void *data);
-int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
-			   const void *data,
-			   void (*callback)(struct iwl_priv *priv,
-					    struct iwl_device_cmd *cmd,
-					    struct iwl_rx_packet *pkt));
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 85e4fa3..975ad79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -259,10 +259,8 @@ struct iwl_channel_info {
 
 enum {
 	CMD_SYNC = 0,
-	CMD_SIZE_NORMAL = 0,
-	CMD_NO_SKB = 0,
-	CMD_ASYNC = (1 << 1),
-	CMD_WANT_SKB = (1 << 2),
+	CMD_ASYNC = BIT(0),
+	CMD_WANT_SKB = BIT(1),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
@@ -295,6 +293,16 @@ enum iwl_hcmd_dataflag {
 	IWL_HCMD_DFL_NOCOPY	= BIT(0),
 };
 
+/**
+ * struct iwl_host_cmd - Host command to the uCode
+ * @data: array of chunks that composes the data of the host command
+ * @reply_page: pointer to the page that holds the response to the host command
+ * @callback:
+ * @flags: can be CMD_* note CMD_WANT_SKB is incompatible withe CMD_ASYNC
+ * @len: array of the lenths of the chunks in data
+ * @dataflags:
+ * @id: id of the host command
+ */
 struct iwl_host_cmd {
 	const void *data[IWL_MAX_CMD_TFDS];
 	unsigned long reply_page;
@@ -1234,6 +1242,8 @@ struct iwl_trans;
  * @tx_init:inits the tx memory, allocate if needed
  * @tx_stop: stop the tx
  * @tx_free: frees the tx memory
+ * @send_cmd:send a host command
+ * @send_cmd_pdu:send a host command: flags can be CMD_*
  */
 struct iwl_trans_ops {
 	int (*rx_init)(struct iwl_priv *priv);
@@ -1243,6 +1253,11 @@ struct iwl_trans_ops {
 	int (*tx_init)(struct iwl_priv *priv);
 	int (*tx_stop)(struct iwl_priv *priv);
 	void (*tx_free)(struct iwl_priv *priv);
+
+	int (*send_cmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+
+	int (*send_cmd_pdu)(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
+		     const void *data);
 };
 
 struct iwl_trans {
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 107b38e..6cff8c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -143,9 +143,6 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int ret;
 
-	if (WARN_ON(!(cmd->flags & CMD_ASYNC)))
-		return -EINVAL;
-
 	/* An asynchronous command can not expect an SKB to be set. */
 	if (WARN_ON(cmd->flags & CMD_WANT_SKB))
 		return -EINVAL;
@@ -166,16 +163,13 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return 0;
 }
 
-int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (WARN_ON(cmd->flags & CMD_ASYNC))
-		return -EINVAL;
-
 	 /* A synchronous command can not have a callback set. */
 	if (WARN_ON(cmd->callback))
 		return -EINVAL;
@@ -263,31 +257,15 @@ int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return iwl_send_cmd_sync(priv, cmd);
 }
 
-int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
-{
-	struct iwl_host_cmd cmd = {
-		.id = id,
-		.len = { len, },
-		.data = { data, },
-	};
-
-	return iwl_send_cmd_sync(priv, &cmd);
-}
-
-int iwl_send_cmd_pdu_async(struct iwl_priv *priv,
-			   u8 id, u16 len, const void *data,
-			   void (*callback)(struct iwl_priv *priv,
-					    struct iwl_device_cmd *cmd,
-					    struct iwl_rx_packet *pkt))
+int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
+		     const void *data)
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
 		.len = { len, },
 		.data = { data, },
+		.flags = flags,
 	};
 
-	cmd.flags |= CMD_ASYNC;
-	cmd.callback = callback;
-
-	return iwl_send_cmd_async(priv, &cmd);
+	return iwl_send_cmd(priv, &cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index ff08da0..d5bc3e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -111,7 +111,7 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
 		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
 
-	return iwl_send_cmd(priv, &cmd);
+	return priv->trans.ops->send_cmd(priv, &cmd);
 }
 
 /* Set led pattern command */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 565e57e..0c08dfd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -334,7 +334,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return iwl_send_cmd_pdu(priv, POWER_TABLE_CMD,
+	return priv->trans.ops->send_cmd_pdu(priv, POWER_TABLE_CMD, CMD_SYNC,
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 438eecd..4c809bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -61,7 +61,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
-		.flags = CMD_WANT_SKB,
+		.flags = CMD_SYNC | CMD_WANT_SKB,
 	};
 
 	/* Exit instantly with error when device is not ready
@@ -74,7 +74,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	    test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EIO;
 
-	ret = iwl_send_cmd_sync(priv, &cmd);
+	ret = priv->trans.ops->send_cmd(priv, &cmd);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 7df2814..06faa1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -156,7 +156,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	}
 
 	cmd.len[0] = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
-	ret = iwl_send_cmd(priv, &cmd);
+	ret = priv->trans.ops->send_cmd(priv, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
@@ -412,7 +412,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 
 	cmd.flags |= CMD_WANT_SKB;
 
-	ret = iwl_send_cmd(priv, &cmd);
+	ret = priv->trans.ops->send_cmd(priv, &cmd);
 
 	if (ret)
 		return ret;
@@ -781,7 +781,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		return -EINVAL;
 
 	if (is_lq_table_valid(priv, ctx, lq))
-		ret = iwl_send_cmd(priv, &cmd);
+		ret = priv->trans.ops->send_cmd(priv, &cmd);
 	else
 		ret = -EINVAL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index c00aa5a..6f92d22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -239,7 +239,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
 				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
 	/* ok, let's submit the command to ucode */
-	return iwl_send_cmd(priv, &cmd);
+	return priv->trans.ops->send_cmd(priv, &cmd);
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index de627f9..5c5a489 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -66,6 +66,7 @@
 #include "iwl-helpers.h"
 /*TODO remove uneeded includes when the transport layer tx_free will be here */
 #include "iwl-agn.h"
+#include "iwl-core.h"
 
 static int iwl_trans_rx_alloc(struct iwl_priv *priv)
 {
@@ -559,6 +560,9 @@ static const struct iwl_trans_ops trans_ops = {
 	.tx_init = iwl_trans_tx_init,
 	.tx_stop = iwl_trans_tx_stop,
 	.tx_free = iwl_trans_tx_free,
+
+	.send_cmd = iwl_send_cmd,
+	.send_cmd_pdu = iwl_send_cmd_pdu,
 };
 
 void iwl_trans_register(struct iwl_trans *trans)
-- 
1.7.0.4

