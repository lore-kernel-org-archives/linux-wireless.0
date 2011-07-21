Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1GUP0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/25] iwlagn: transport layer receives struct iwl_trans*
Date: Thu, 21 Jul 2011 07:50:14 -0700
Message-Id: <1311259828-8415-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172659_789938_E8B7A840)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It still holds a pointer to iwl_priv. But hopefully this will disappear at some point.
Also add the multiple inclusion protection to iwl-trans.h that was forgotten.
Move iwl-trans structures to iwl-trans.h

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   29 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   62 +------------
 drivers/net/wireless/iwlwifi/iwl-led.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |  133 ++++++++++++++++++++------
 18 files changed, 168 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8c6fbd7..3eeb12e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -315,7 +315,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return trans_send_cmd(priv, &hcmd);
+	return trans_send_cmd(&priv->trans, &hcmd);
 }
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ea48246..973d197 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -253,7 +253,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return trans_send_cmd(priv, &hcmd);
+	return trans_send_cmd(&priv->trans, &hcmd);
 }
 
 static struct iwl_lib_ops iwl6000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 540e66f..204f0ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -98,7 +98,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 			hcmd.len[0] = priv->calib_results[i].buf_len;
 			hcmd.data[0] = priv->calib_results[i].buf;
 			hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-			ret = trans_send_cmd(priv, &hcmd);
+			ret = trans_send_cmd(&priv->trans, &hcmd);
 			if (ret) {
 				IWL_ERR(priv, "Error %d iteration %d\n",
 					ret, i);
@@ -484,7 +484,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
 	       sizeof(u16)*HD_TABLE_SIZE);
 
-	return trans_send_cmd(priv, &cmd_out);
+	return trans_send_cmd(&priv->trans, &cmd_out);
 }
 
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
@@ -548,7 +548,7 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 	       &(cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX]),
 	       sizeof(u16)*ENHANCE_HD_TABLE_ENTRIES);
 
-	return trans_send_cmd(priv, &cmd_out);
+	return trans_send_cmd(&priv->trans, &cmd_out);
 }
 
 void iwl_init_sensitivity(struct iwl_priv *priv)
@@ -892,7 +892,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			priv->_agn.phy_calib_chain_noise_gain_cmd);
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
-		trans_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+		trans_send_cmd_pdu(&priv->trans, REPLY_PHY_CALIBRATION_CMD,
 			CMD_ASYNC, sizeof(cmd), &cmd);
 
 		data->radio_write = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 6ed0eae..67b55c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -519,7 +519,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return trans_send_cmd_pdu(priv, tx_ant_cfg_cmd, CMD_SYNC,
+	return trans_send_cmd_pdu(&priv->trans, tx_ant_cfg_cmd, CMD_SYNC,
 			sizeof(tx_power_cmd), &tx_power_cmd);
 }
 
@@ -1061,7 +1061,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (ret)
 		return ret;
 
-	ret = trans_send_cmd(priv, &cmd);
+	ret = trans_send_cmd(&priv->trans, &cmd);
 	if (ret) {
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 		iwlagn_set_pan_params(priv);
@@ -1167,7 +1167,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		       flush_cmd.fifo_control);
 	flush_cmd.flush_control = cpu_to_le16(flush_control);
 
-	return trans_send_cmd(priv, &cmd);
+	return trans_send_cmd(&priv->trans, &cmd);
 }
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
@@ -1361,12 +1361,12 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	if (priv->cfg->bt_params->bt_session_2) {
 		memcpy(&bt_cmd_2000.basic, &basic,
 			sizeof(basic));
-		ret = trans_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+		ret = trans_send_cmd_pdu(&priv->trans, REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_2000), &bt_cmd_2000);
 	} else {
 		memcpy(&bt_cmd_6000.basic, &basic,
 			sizeof(basic));
-		ret = trans_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+		ret = trans_send_cmd_pdu(&priv->trans, REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_6000), &bt_cmd_6000);
 	}
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 53e7475..581534a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -40,7 +40,7 @@ static int iwlagn_disable_bss(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd,
+	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -66,7 +66,7 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
-	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd,
+	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -92,7 +92,7 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
+	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd, CMD_SYNC,
 				sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -121,7 +121,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
-	ret = trans_send_cmd_pdu(priv, ctx->qos_cmd, CMD_SYNC,
+	ret = trans_send_cmd_pdu(&priv->trans, ctx->qos_cmd, CMD_SYNC,
 			       sizeof(struct iwl_qosparam_cmd),
 			       &ctx->qos_data.def_qos_parm);
 	if (ret)
@@ -180,7 +180,7 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
 	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
 
-	ret = trans_send_cmd_pdu(priv, ctx->rxon_assoc_cmd,
+	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_assoc_cmd,
 				CMD_ASYNC, sizeof(rxon_assoc), &rxon_assoc);
 	return ret;
 }
@@ -266,7 +266,7 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	 * Associated RXON doesn't clear the station table in uCode,
 	 * so we don't need to restore stations etc. after this.
 	 */
-	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
+	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd, CMD_SYNC,
 		      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 	if (ret) {
 		IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
@@ -388,7 +388,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].width = cpu_to_le16(slot0);
 	cmd.slots[1].width = cpu_to_le16(slot1);
 
-	ret = trans_send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, CMD_SYNC,
+	ret = trans_send_cmd_pdu(&priv->trans, REPLY_WIPAN_PARAMS, CMD_SYNC,
 			sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(priv, "Error setting PAN parameters (%d)\n", ret);
@@ -788,7 +788,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 		memset(&cmd, 0, sizeof(cmd));
 		iwl_set_calib_hdr(&cmd.hdr,
 			priv->_agn.phy_calib_chain_noise_reset_cmd);
-		ret = trans_send_cmd_pdu(priv,
+		ret = trans_send_cmd_pdu(&priv->trans,
 					REPLY_PHY_CALIBRATION_CMD,
 					CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 001622c..67b9c2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -181,7 +181,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 	cmd.len[0] = cmd_size;
 
 	if (not_empty || send_if_empty)
-		return trans_send_cmd(priv, &cmd);
+		return trans_send_cmd(&priv->trans, &cmd);
 	else
 		return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 932425d..a5295c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -433,7 +433,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		}
 	}
 
-	tx_cmd = trans_get_tx_cmd(priv, txq_id);
+	tx_cmd = trans_get_tx_cmd(&priv->trans, txq_id);
 	if (unlikely(!tx_cmd))
 		goto drop_unlock_sta;
 
@@ -455,7 +455,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	iwl_update_stats(priv, true, fc, len);
 
-	if (trans_tx(priv, skb, tx_cmd, txq_id, fc, is_agg, ctx))
+	if (trans_tx(&priv->trans, skb, tx_cmd, txq_id, fc, is_agg, ctx))
 		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc)) {
@@ -633,7 +633,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	 * to deactivate the uCode queue, just return "success" to allow
 	 *  mac80211 to clean up it own data.
 	 */
-	trans_txq_agg_disable(priv, txq_id, ssn, tx_fifo_id);
+	trans_txq_agg_disable(&priv->trans, txq_id, ssn, tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -662,7 +662,8 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = get_fifo_from_tid(ctx, tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			trans_txq_agg_disable(priv, txq_id, ssn, tx_fifo);
+			trans_txq_agg_disable(&priv->trans, txq_id,
+				ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index e4b2f78..946d3a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -193,7 +193,7 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	calib_cfg_cmd.ucd_calib_cfg.flags =
 		IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK;
 
-	return trans_send_cmd(priv, &cmd);
+	return trans_send_cmd(&priv->trans, &cmd);
 }
 
 void iwlagn_rx_calib_result(struct iwl_priv *priv,
@@ -291,7 +291,7 @@ static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
 		/* coexistence is disabled */
 		memset(&coex_cmd, 0, sizeof(coex_cmd));
 	}
-	return trans_send_cmd_pdu(priv,
+	return trans_send_cmd_pdu(&priv->trans,
 				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
 }
@@ -324,7 +324,7 @@ void iwlagn_send_prio_tbl(struct iwl_priv *priv)
 
 	memcpy(prio_tbl_cmd.prio_tbl, iwlagn_bt_prio_tbl,
 		sizeof(iwlagn_bt_prio_tbl));
-	if (trans_send_cmd_pdu(priv,
+	if (trans_send_cmd_pdu(&priv->trans,
 				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
@@ -337,7 +337,7 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	ret = trans_send_cmd_pdu(priv,
+	ret = trans_send_cmd_pdu(&priv->trans,
 			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
@@ -350,7 +350,7 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 {
 	int ret;
 
-	trans_tx_start(priv);
+	trans_tx_start(&priv->trans);
 
 	ret = iwlagn_send_wimax_coex(priv);
 	if (ret)
@@ -478,7 +478,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	int ret;
 	enum iwlagn_ucode_type old_type;
 
-	ret = trans_start_device(priv);
+	ret = trans_start_device(&priv->trans);
 	if (ret)
 		return ret;
 
@@ -495,7 +495,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 	}
 
-	trans_kick_nic(priv);
+	trans_kick_nic(&priv->trans);
 
 	/*
 	 * Some things may run in the background now, but we
@@ -573,6 +573,6 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	iwlagn_remove_notification(priv, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
-	trans_stop_device(priv);
+	trans_stop_device(&priv->trans);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 703c106..d3163d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -206,7 +206,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	cmd.data[1] = priv->beacon_skb->data;
 	cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
 
-	return trans_send_cmd(priv, &cmd);
+	return trans_send_cmd(&priv->trans, &cmd);
 }
 
 static void iwl_bg_beacon_update(struct work_struct *work)
@@ -1568,7 +1568,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		adv_cmd.critical_temperature_exit =
 			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
 
-		ret = trans_send_cmd_pdu(priv,
+		ret = trans_send_cmd_pdu(&priv->trans,
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(adv_cmd), &adv_cmd);
 		if (ret)
@@ -1584,7 +1584,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		cmd.critical_temperature_R =
 			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 
-		ret = trans_send_cmd_pdu(priv,
+		ret = trans_send_cmd_pdu(&priv->trans,
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
@@ -1610,7 +1610,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.start = cpu_to_le32(cfg);
 
-	return trans_send_cmd(priv, &cmd);
+	return trans_send_cmd(&priv->trans, &cmd);
 }
 
 
@@ -1622,7 +1622,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 
 	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
-		return trans_send_cmd_pdu(priv,
+		return trans_send_cmd_pdu(&priv->trans,
 					TX_ANT_CONFIGURATION_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_tx_ant_config_cmd),
@@ -1783,7 +1783,7 @@ static void __iwl_down(struct iwl_priv *priv)
 		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
 
-	trans_stop_device(priv);
+	trans_stop_device(&priv->trans);
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
@@ -2412,7 +2412,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
-		trans_txq_agg_setup(priv, iwl_sta_id(sta), tid, buf_size);
+		trans_txq_agg_setup(&priv->trans, iwl_sta_id(sta), tid,
+				buf_size);
 
 		/*
 		 * If the limit is 0, then it wasn't initialised yet,
@@ -3136,7 +3137,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	priv->cfg = cfg;
 	priv->inta_mask = CSR_INI_SET_MASK;
 
-	err = iwl_trans_register(priv);
+	err = iwl_trans_register(&priv->trans, priv);
 	if (err)
 		goto out_free_priv;
 
@@ -3174,7 +3175,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		priv->cfg->name, hw_rev);
 
-	if (trans_prepare_card_hw(priv)) {
+	if (trans_prepare_card_hw(&priv->trans)) {
 		err = -EIO;
 		IWL_WARN(priv, "Failed, HW not ready\n");
 		goto out_free_traffic_mem;
@@ -3272,7 +3273,7 @@ out_free_eeprom:
 	iwl_eeprom_free(priv);
 out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
-	trans_free(priv);
+	trans_free(&priv->trans);
 out_free_priv:
 	ieee80211_free_hw(priv->hw);
 out:
@@ -3317,12 +3318,12 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	trans_sync_irq(priv);
+	trans_sync_irq(&priv->trans);
 
 	iwl_dealloc_ucode(priv);
 
-	trans_rx_free(priv);
-	trans_tx_free(priv);
+	trans_rx_free(&priv->trans);
+	trans_tx_free(&priv->trans);
 
 	iwl_eeprom_free(priv);
 
@@ -3336,7 +3337,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	priv->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
-	trans_free(priv);
+	trans_free(&priv->trans);
 
 	priv->bus.ops->set_drv_data(&priv->bus, NULL);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fa3d5ba..a2a95ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -376,7 +376,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			le32_to_cpu(ctx->timing.beacon_init_val),
 			le16_to_cpu(ctx->timing.atim_window));
 
-	return trans_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
+	return trans_send_cmd_pdu(&priv->trans, ctx->rxon_timing_cmd,
 				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
 }
 
@@ -1132,7 +1132,7 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
-	if (trans_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+	if (trans_send_cmd_pdu(&priv->trans, REPLY_BT_CONFIG,
 			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
@@ -1145,12 +1145,12 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 	};
 
 	if (flags & CMD_ASYNC)
-		return trans_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+		return trans_send_cmd_pdu(&priv->trans, REPLY_STATISTICS_CMD,
 					      CMD_ASYNC,
 					       sizeof(struct iwl_statistics_cmd),
 					       &statistics_cmd);
 	else
-		return trans_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+		return trans_send_cmd_pdu(&priv->trans, REPLY_STATISTICS_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_statistics_cmd),
 					&statistics_cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9a39836..a89b40a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -47,6 +47,7 @@
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
 #include "iwl-agn-tt.h"
+#include "iwl-trans.h"
 
 #define DRV_NAME        "iwlagn"
 
@@ -1230,67 +1231,6 @@ struct iwl_bus {
 	unsigned int irq;
 };
 
-struct iwl_trans;
-
-/**
- * struct iwl_trans_ops - transport specific operations
- * @start_device: allocates and inits all the resources for the transport
- *                layer.
- * @prepare_card_hw: claim the ownership on the HW. Will be called during
- *                   probe.
- * @tx_start: starts and configures all the Tx fifo - usually done once the fw
- *           is alive.
- * @stop_device:stops the whole device (embedded CPU put to reset)
- * @rx_free: frees the rx memory
- * @tx_free: frees the tx memory
- * @send_cmd:send a host command
- * @send_cmd_pdu:send a host command: flags can be CMD_*
- * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
- * @tx: send an skb
- * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
- *                 ready and a successful ADDBA response has been received.
- * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
- * @kick_nic: remove the RESET from the embedded CPU and let it run
- * @sync_irq: the upper layer will typically disable interrupt and call this
- *            handler. After this handler returns, it is guaranteed that all
- *            the ISR / tasklet etc... have finished running and the transport
- *            layer shall not pass any Rx.
- * @free: release all the ressource for the transport layer itself such as
- *        irq, tasklet etc...
- */
-struct iwl_trans_ops {
-
-	int (*start_device)(struct iwl_priv *priv);
-	int (*prepare_card_hw)(struct iwl_priv *priv);
-	void (*stop_device)(struct iwl_priv *priv);
-	void (*tx_start)(struct iwl_priv *priv);
-	void (*tx_free)(struct iwl_priv *priv);
-	void (*rx_free)(struct iwl_priv *priv);
-
-	int (*send_cmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
-
-	int (*send_cmd_pdu)(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
-		     const void *data);
-	struct iwl_tx_cmd * (*get_tx_cmd)(struct iwl_priv *priv, int txq_id);
-	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
-		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
-		struct iwl_rxon_context *ctx);
-
-	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id,
-				  u16 ssn_idx, u8 tx_fifo);
-	void (*txq_agg_setup)(struct iwl_priv *priv, int sta_id, int tid,
-						int frame_limit);
-
-	void (*kick_nic)(struct iwl_priv *priv);
-
-	void (*sync_irq)(struct iwl_priv *priv);
-	void (*free)(struct iwl_priv *priv);
-};
-
-struct iwl_trans {
-	const struct iwl_trans_ops *ops;
-};
-
 /* uCode ownership */
 #define IWL_OWNERSHIP_DRIVER	0
 #define IWL_OWNERSHIP_TM	1
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 60e4169..75663c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -112,7 +112,7 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
 		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
 
-	return trans_send_cmd(priv, &cmd);
+	return trans_send_cmd(&priv->trans, &cmd);
 }
 
 /* Set led pattern command */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 64ff40a..7c99f43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -335,7 +335,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return trans_send_cmd_pdu(priv, POWER_TABLE_CMD, CMD_SYNC,
+	return trans_send_cmd_pdu(&priv->trans, POWER_TABLE_CMD, CMD_SYNC,
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index f6ebe29..0505b1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -75,7 +75,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	    test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EIO;
 
-	ret = trans_send_cmd(priv, &cmd);
+	ret = trans_send_cmd(&priv->trans, &cmd);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 65386e5..58dba0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -168,7 +168,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	}
 
 	cmd.len[0] = iwlagn_build_addsta_hcmd(sta, data);
-	ret = trans_send_cmd(priv, &cmd);
+	ret = trans_send_cmd(&priv->trans, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
@@ -424,7 +424,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 
 	cmd.flags |= CMD_WANT_SKB;
 
-	ret = trans_send_cmd(priv, &cmd);
+	ret = trans_send_cmd(&priv->trans, &cmd);
 
 	if (ret)
 		return ret;
@@ -793,7 +793,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		return -EINVAL;
 
 	if (is_lq_table_valid(priv, ctx, lq))
-		ret = trans_send_cmd(priv, &cmd);
+		ret = trans_send_cmd(&priv->trans, &cmd);
 	else
 		ret = -EINVAL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index d736a9d..d474835 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -241,7 +241,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
 				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
 	/* ok, let's submit the command to ucode */
-	return trans_send_cmd(priv, &cmd);
+	return trans_send_cmd(&priv->trans, &cmd);
 }
 
 
@@ -407,7 +407,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
 		iwl_testmode_cfg_init_calib(priv);
-		trans_stop_device(priv);
+		trans_stop_device(&priv->trans);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 88ab20a..edd28f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -526,7 +526,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 	return 0;
 
 error:
-	trans_tx_free(priv);
+	trans_tx_free(&priv->trans);
 
 	return ret;
 }
@@ -570,7 +570,7 @@ static int iwl_tx_init(struct iwl_priv *priv)
 error:
 	/*Upon error, free only if we allocated something */
 	if (alloc)
-		trans_tx_free(priv);
+		trans_tx_free(&priv->trans);
 	return ret;
 }
 
@@ -920,7 +920,7 @@ static void iwl_trans_stop_device(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
-	trans_sync_irq(priv);
+	trans_sync_irq(&priv->trans);
 
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(priv);
@@ -1146,11 +1146,12 @@ static const struct iwl_trans_ops trans_ops = {
 	.free = iwl_trans_free,
 };
 
-int iwl_trans_register(struct iwl_priv *priv)
+int iwl_trans_register(struct iwl_trans *trans, struct iwl_priv *priv)
 {
 	int err;
 
 	priv->trans.ops = &trans_ops;
+	priv->trans.priv = priv;
 
 	iwl_alloc_isr_ict(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index fca0181..7993aa7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -60,95 +60,166 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+#ifndef __iwl_trans_h__
+#define __iwl_trans_h__
 
  /*This file includes the declaration that are exported from the transport
  * layer */
 
-static inline int trans_start_device(struct iwl_priv *priv)
+struct iwl_priv;
+struct iwl_rxon_context;
+struct iwl_host_cmd;
+
+/**
+ * struct iwl_trans_ops - transport specific operations
+ * @start_device: allocates and inits all the resources for the transport
+ *                layer.
+ * @prepare_card_hw: claim the ownership on the HW. Will be called during
+ *                   probe.
+ * @tx_start: starts and configures all the Tx fifo - usually done once the fw
+ *           is alive.
+ * @stop_device:stops the whole device (embedded CPU put to reset)
+ * @rx_free: frees the rx memory
+ * @tx_free: frees the tx memory
+ * @send_cmd:send a host command
+ * @send_cmd_pdu:send a host command: flags can be CMD_*
+ * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
+ * @tx: send an skb
+ * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
+ *                 ready and a successful ADDBA response has been received.
+ * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
+ * @kick_nic: remove the RESET from the embedded CPU and let it run
+ * @sync_irq: the upper layer will typically disable interrupt and call this
+ *            handler. After this handler returns, it is guaranteed that all
+ *            the ISR / tasklet etc... have finished running and the transport
+ *            layer shall not pass any Rx.
+ * @free: release all the ressource for the transport layer itself such as
+ *        irq, tasklet etc...
+ */
+struct iwl_trans_ops {
+
+	int (*start_device)(struct iwl_priv *priv);
+	int (*prepare_card_hw)(struct iwl_priv *priv);
+	void (*stop_device)(struct iwl_priv *priv);
+	void (*tx_start)(struct iwl_priv *priv);
+	void (*tx_free)(struct iwl_priv *priv);
+	void (*rx_free)(struct iwl_priv *priv);
+
+	int (*send_cmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+
+	int (*send_cmd_pdu)(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
+		     const void *data);
+	struct iwl_tx_cmd * (*get_tx_cmd)(struct iwl_priv *priv, int txq_id);
+	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
+		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
+		struct iwl_rxon_context *ctx);
+
+	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id,
+				  u16 ssn_idx, u8 tx_fifo);
+	void (*txq_agg_setup)(struct iwl_priv *priv, int sta_id, int tid,
+						int frame_limit);
+
+	void (*kick_nic)(struct iwl_priv *priv);
+
+	void (*sync_irq)(struct iwl_priv *priv);
+	void (*free)(struct iwl_priv *priv);
+};
+
+struct iwl_trans {
+	const struct iwl_trans_ops *ops;
+	struct iwl_priv *priv;
+};
+
+static inline int trans_start_device(struct iwl_trans *trans)
 {
-	return priv->trans.ops->start_device(priv);
+	return trans->ops->start_device(trans->priv);
 }
 
-static inline int trans_prepare_card_hw(struct iwl_priv *priv)
+static inline int trans_prepare_card_hw(struct iwl_trans *trans)
 {
-	return priv->trans.ops->prepare_card_hw(priv);
+	return trans->ops->prepare_card_hw(trans->priv);
 }
 
-static inline void trans_stop_device(struct iwl_priv *priv)
+static inline void trans_stop_device(struct iwl_trans *trans)
 {
-	priv->trans.ops->stop_device(priv);
+	trans->ops->stop_device(trans->priv);
 }
 
-static inline void trans_tx_start(struct iwl_priv *priv)
+static inline void trans_tx_start(struct iwl_trans *trans)
 {
-	priv->trans.ops->tx_start(priv);
+	trans->ops->tx_start(trans->priv);
 }
 
-static inline void trans_rx_free(struct iwl_priv *priv)
+static inline void trans_rx_free(struct iwl_trans *trans)
 {
-	priv->trans.ops->rx_free(priv);
+	trans->ops->rx_free(trans->priv);
 }
 
-static inline void trans_tx_free(struct iwl_priv *priv)
+static inline void trans_tx_free(struct iwl_trans *trans)
 {
-	priv->trans.ops->tx_free(priv);
+	trans->ops->tx_free(trans->priv);
 }
 
-static inline int trans_send_cmd(struct iwl_priv *priv,
+static inline int trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
-	return priv->trans.ops->send_cmd(priv, cmd);
+	return trans->ops->send_cmd(trans->priv, cmd);
 }
 
-static inline int trans_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
+static inline int trans_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
 					u16 len, const void *data)
 {
-	return priv->trans.ops->send_cmd_pdu(priv, id, flags, len, data);
+	return trans->ops->send_cmd_pdu(trans->priv, id, flags, len, data);
 }
 
-static inline struct iwl_tx_cmd *trans_get_tx_cmd(struct iwl_priv *priv,
+static inline struct iwl_tx_cmd *trans_get_tx_cmd(struct iwl_trans *trans,
 					int txq_id)
 {
-	return priv->trans.ops->get_tx_cmd(priv, txq_id);
+	return trans->ops->get_tx_cmd(trans->priv, txq_id);
 }
 
-static inline int trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
+static inline int trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx)
 {
-	return priv->trans.ops->tx(priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
+	return trans->ops->tx(trans->priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
 }
 
-static inline int trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+static inline int trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id,
 			  u16 ssn_idx, u8 tx_fifo)
 {
-	return priv->trans.ops->txq_agg_disable(priv, txq_id, ssn_idx, tx_fifo);
+	return trans->ops->txq_agg_disable(trans->priv, txq_id,
+					   ssn_idx, tx_fifo);
 }
 
-static inline void trans_txq_agg_setup(struct iwl_priv *priv, int sta_id,
+static inline void trans_txq_agg_setup(struct iwl_trans *trans, int sta_id,
 						int tid, int frame_limit)
 {
-	priv->trans.ops->txq_agg_setup(priv, sta_id, tid, frame_limit);
+	trans->ops->txq_agg_setup(trans->priv, sta_id, tid, frame_limit);
 }
 
-static inline void trans_kick_nic(struct iwl_priv *priv)
+static inline void trans_kick_nic(struct iwl_trans *trans)
 {
-	priv->trans.ops->kick_nic(priv);
+	trans->ops->kick_nic(trans->priv);
 }
 
-static inline void trans_sync_irq(struct iwl_priv *priv)
+static inline void trans_sync_irq(struct iwl_trans *trans)
 {
-	priv->trans.ops->sync_irq(priv);
+	trans->ops->sync_irq(trans->priv);
 }
 
-static inline void trans_free(struct iwl_priv *priv)
+static inline void trans_free(struct iwl_trans *trans)
 {
-	priv->trans.ops->free(priv);
+	trans->ops->free(trans->priv);
 }
 
-int iwl_trans_register(struct iwl_priv *priv);
+int iwl_trans_register(struct iwl_trans *trans, struct iwl_priv *priv);
 
 /*TODO: this functions should NOT be exported from trans module - export it
  * until the reclaim flow will be brought to the transport module too */
+
+struct iwl_tx_queue;
 void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq);
+
+#endif /* __iwl_trans_h__ */
-- 
1.7.0.4

