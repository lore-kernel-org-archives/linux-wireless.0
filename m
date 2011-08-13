Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab1HMSSl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/60] iwlagn: bus layer chooses its transport layer
Date: Sat, 13 Aug 2011 10:37:52 -0700
Message-Id: <1313257116-2697-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201951_979161_AA1E829C)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Remove iwl_transport_register which was a W/A. The bus layer knows what
transport to use. So now, the bus layer gives the upper layer a pointer to the
iwl_trans_ops struct that it wants to use. The upper layer then, allocates the
desired transport layer using iwl_trans_ops->alloc function.

As a result of this, priv->trans, no longer exists, priv holds a pointer to
iwl_shared, which holds a pointer to iwl_trans. This required to change all the
calls to the transport layer from upper layer. While we were at it, trans_X
inlines have been renamed to iwl_trans_X to avoid confusions, which of course
required to rename the functions inside the transport layer because of
conflicts in names. So the static API functions inside the transport layer
implementation have been renamed to iwl_trans_pcie_X.

Until now, the IRQ / Tasklet were initialized in iwl_transport_layer. This is
confusing since the registration doesn't mean to request IRQ, so I added a
handler for that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   51 +++++----
 drivers/net/wireless/iwlwifi/iwl-bus.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    7 +-
 drivers/net/wireless/iwlwifi/iwl-power.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   16 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   12 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  125 ++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   83 ++++++++------
 24 files changed, 226 insertions(+), 170 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2171ce9..1049aed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -316,7 +316,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return trans_send_cmd(&priv->trans, &hcmd);
+	return iwl_trans_send_cmd(trans(priv), &hcmd);
 }
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0f6539a..c0dca8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -257,7 +257,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return trans_send_cmd(&priv->trans, &hcmd);
+	return iwl_trans_send_cmd(trans(priv), &hcmd);
 }
 
 static struct iwl_lib_ops iwl6000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index fb6da14..b725f69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -98,7 +98,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 			hcmd.len[0] = priv->calib_results[i].buf_len;
 			hcmd.data[0] = priv->calib_results[i].buf;
 			hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-			ret = trans_send_cmd(&priv->trans, &hcmd);
+			ret = iwl_trans_send_cmd(trans(priv), &hcmd);
 			if (ret) {
 				IWL_ERR(priv, "Error %d iteration %d\n",
 					ret, i);
@@ -484,7 +484,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
 	       sizeof(u16)*HD_TABLE_SIZE);
 
-	return trans_send_cmd(&priv->trans, &cmd_out);
+	return iwl_trans_send_cmd(trans(priv), &cmd_out);
 }
 
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
@@ -573,7 +573,7 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 	       &(cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX]),
 	       sizeof(u16)*ENHANCE_HD_TABLE_ENTRIES);
 
-	return trans_send_cmd(&priv->trans, &cmd_out);
+	return iwl_trans_send_cmd(trans(priv), &cmd_out);
 }
 
 void iwl_init_sensitivity(struct iwl_priv *priv)
@@ -918,7 +918,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			priv->phy_calib_chain_noise_gain_cmd);
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
-		trans_send_cmd_pdu(&priv->trans, REPLY_PHY_CALIBRATION_CMD,
+		iwl_trans_send_cmd_pdu(trans(priv), REPLY_PHY_CALIBRATION_CMD,
 			CMD_ASYNC, sizeof(cmd), &cmd);
 
 		data->radio_write = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index bf2ba98..82fb55b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -526,7 +526,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return trans_send_cmd_pdu(&priv->trans, tx_ant_cfg_cmd, CMD_SYNC,
+	return iwl_trans_send_cmd_pdu(trans(priv), tx_ant_cfg_cmd, CMD_SYNC,
 			sizeof(tx_power_cmd), &tx_power_cmd);
 }
 
@@ -1054,7 +1054,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (ret)
 		return ret;
 
-	ret = trans_send_cmd(&priv->trans, &cmd);
+	ret = iwl_trans_send_cmd(trans(priv), &cmd);
 	if (ret) {
 		clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
 		iwlagn_set_pan_params(priv);
@@ -1160,7 +1160,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		       flush_cmd.fifo_control);
 	flush_cmd.flush_control = cpu_to_le16(flush_control);
 
-	return trans_send_cmd(&priv->trans, &cmd);
+	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
@@ -1354,12 +1354,12 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	if (priv->cfg->bt_params->bt_session_2) {
 		memcpy(&bt_cmd_2000.basic, &basic,
 			sizeof(basic));
-		ret = trans_send_cmd_pdu(&priv->trans, REPLY_BT_CONFIG,
+		ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_2000), &bt_cmd_2000);
 	} else {
 		memcpy(&bt_cmd_6000.basic, &basic,
 			sizeof(basic));
-		ret = trans_send_cmd_pdu(&priv->trans, REPLY_BT_CONFIG,
+		ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_6000), &bt_cmd_6000);
 	}
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index c31dfbf..61abb1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -41,7 +41,7 @@ static int iwlagn_disable_bss(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -67,7 +67,7 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
-	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -93,7 +93,7 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd, CMD_SYNC,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd, CMD_SYNC,
 				sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -122,7 +122,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
-	ret = trans_send_cmd_pdu(&priv->trans, ctx->qos_cmd, CMD_SYNC,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->qos_cmd, CMD_SYNC,
 			       sizeof(struct iwl_qosparam_cmd),
 			       &ctx->qos_data.def_qos_parm);
 	if (ret)
@@ -181,7 +181,7 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
 	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
 
-	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_assoc_cmd,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_assoc_cmd,
 				CMD_ASYNC, sizeof(rxon_assoc), &rxon_assoc);
 	return ret;
 }
@@ -267,7 +267,7 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	 * Associated RXON doesn't clear the station table in uCode,
 	 * so we don't need to restore stations etc. after this.
 	 */
-	ret = trans_send_cmd_pdu(&priv->trans, ctx->rxon_cmd, CMD_SYNC,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd, CMD_SYNC,
 		      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 	if (ret) {
 		IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
@@ -388,7 +388,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].width = cpu_to_le16(slot0);
 	cmd.slots[1].width = cpu_to_le16(slot1);
 
-	ret = trans_send_cmd_pdu(&priv->trans, REPLY_WIPAN_PARAMS, CMD_SYNC,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WIPAN_PARAMS, CMD_SYNC,
 			sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(priv, "Error setting PAN parameters (%d)\n", ret);
@@ -775,7 +775,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 		memset(&cmd, 0, sizeof(cmd));
 		iwl_set_calib_hdr(&cmd.hdr,
 			priv->phy_calib_chain_noise_reset_cmd);
-		ret = trans_send_cmd_pdu(&priv->trans,
+		ret = iwl_trans_send_cmd_pdu(trans(priv),
 					REPLY_PHY_CALIBRATION_CMD,
 					CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 4b13bb9..4d02c32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -189,7 +189,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 	cmd.len[0] = cmd_size;
 
 	if (not_empty || send_if_empty)
-		return trans_send_cmd(&priv->trans, &cmd);
+		return iwl_trans_send_cmd(trans(priv), &cmd);
 	else
 		return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index d0d7710..0e9deb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -429,7 +429,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		}
 	}
 
-	tx_cmd = trans_get_tx_cmd(&priv->trans, txq_id);
+	tx_cmd = iwl_trans_get_tx_cmd(trans(priv), txq_id);
 	if (unlikely(!tx_cmd))
 		goto drop_unlock_sta;
 
@@ -451,7 +451,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	iwl_update_stats(priv, true, fc, len);
 
-	if (trans_tx(&priv->trans, skb, tx_cmd, txq_id, fc, is_agg, ctx))
+	if (iwl_trans_tx(trans(priv), skb, tx_cmd, txq_id, fc, is_agg, ctx))
 		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc)) {
@@ -629,7 +629,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	 * to deactivate the uCode queue, just return "success" to allow
 	 *  mac80211 to clean up it own data.
 	 */
-	trans_txq_agg_disable(&priv->trans, txq_id, ssn, tx_fifo_id);
+	iwl_trans_txq_agg_disable(trans(priv), txq_id, ssn, tx_fifo_id);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -658,7 +658,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = get_fifo_from_tid(ctx, tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			trans_txq_agg_disable(&priv->trans, txq_id,
+			iwl_trans_txq_agg_disable(trans(priv), txq_id,
 				ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 3717a88..a094b66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -193,7 +193,7 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	calib_cfg_cmd.ucd_calib_cfg.flags =
 		IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK;
 
-	return trans_send_cmd(&priv->trans, &cmd);
+	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
 void iwlagn_rx_calib_result(struct iwl_priv *priv,
@@ -291,7 +291,7 @@ static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
 		/* coexistence is disabled */
 		memset(&coex_cmd, 0, sizeof(coex_cmd));
 	}
-	return trans_send_cmd_pdu(&priv->trans,
+	return iwl_trans_send_cmd_pdu(trans(priv),
 				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
 }
@@ -324,7 +324,7 @@ void iwlagn_send_prio_tbl(struct iwl_priv *priv)
 
 	memcpy(prio_tbl_cmd.prio_tbl, iwlagn_bt_prio_tbl,
 		sizeof(iwlagn_bt_prio_tbl));
-	if (trans_send_cmd_pdu(&priv->trans,
+	if (iwl_trans_send_cmd_pdu(trans(priv),
 				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
@@ -337,7 +337,7 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	ret = trans_send_cmd_pdu(&priv->trans,
+	ret = iwl_trans_send_cmd_pdu(trans(priv),
 			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
@@ -350,7 +350,7 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 {
 	int ret;
 
-	trans_tx_start(&priv->trans);
+	iwl_trans_tx_start(trans(priv));
 
 	ret = iwlagn_send_wimax_coex(priv);
 	if (ret)
@@ -478,7 +478,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	int ret;
 	enum iwlagn_ucode_type old_type;
 
-	ret = trans_start_device(&priv->trans);
+	ret = iwl_trans_start_device(trans(priv));
 	if (ret)
 		return ret;
 
@@ -495,7 +495,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 	}
 
-	trans_kick_nic(&priv->trans);
+	iwl_trans_kick_nic(trans(priv));
 
 	/*
 	 * Some things may run in the background now, but we
@@ -580,6 +580,6 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	iwlagn_remove_notification(priv, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
-	trans_stop_device(&priv->trans);
+	iwl_trans_stop_device(trans(priv));
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1911ac6..3d224d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -201,7 +201,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	cmd.data[1] = priv->beacon_skb->data;
 	cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
 
-	return trans_send_cmd(&priv->trans, &cmd);
+	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
 static void iwl_bg_beacon_update(struct work_struct *work)
@@ -1686,7 +1686,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		adv_cmd.critical_temperature_exit =
 			cpu_to_le32(hw_params(priv).ct_kill_exit_threshold);
 
-		ret = trans_send_cmd_pdu(&priv->trans,
+		ret = iwl_trans_send_cmd_pdu(trans(priv),
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(adv_cmd), &adv_cmd);
 		if (ret)
@@ -1701,7 +1701,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		cmd.critical_temperature_R =
 			cpu_to_le32(hw_params(priv).ct_kill_threshold);
 
-		ret = trans_send_cmd_pdu(&priv->trans,
+		ret = iwl_trans_send_cmd_pdu(trans(priv),
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
@@ -1727,7 +1727,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.start = cpu_to_le32(cfg);
 
-	return trans_send_cmd(&priv->trans, &cmd);
+	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
 
@@ -1739,7 +1739,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 
 	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
-		return trans_send_cmd_pdu(&priv->trans,
+		return iwl_trans_send_cmd_pdu(trans(priv),
 					TX_ANT_CONFIGURATION_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_tx_ant_config_cmd),
@@ -1913,7 +1913,7 @@ static void __iwl_down(struct iwl_priv *priv)
 			test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) <<
 				STATUS_EXIT_PENDING;
 
-	trans_stop_device(&priv->trans);
+	iwl_trans_stop_device(trans(priv));
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
@@ -2336,7 +2336,7 @@ static int iwlagn_send_patterns(struct iwl_priv *priv,
 	}
 
 	cmd.data[0] = pattern_cmd;
-	err = trans_send_cmd(&priv->trans, &cmd);
+	err = iwl_trans_send_cmd(trans(priv), &cmd);
 	kfree(pattern_cmd);
 	return err;
 }
@@ -2589,7 +2589,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 
 	memcpy(&rxon, &ctx->active, sizeof(rxon));
 
-	trans_stop_device(&priv->trans);
+	iwl_trans_stop_device(trans(priv));
 
 	priv->wowlan = true;
 
@@ -2641,13 +2641,13 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 				.len[0] = sizeof(*key_data.rsc_tsc),
 			};
 
-			ret = trans_send_cmd(&priv->trans, &rsc_tsc_cmd);
+			ret = iwl_trans_send_cmd(trans(priv), &rsc_tsc_cmd);
 			if (ret)
 				goto error;
 		}
 
 		if (key_data.use_tkip) {
-			ret = trans_send_cmd_pdu(&priv->trans,
+			ret = iwl_trans_send_cmd_pdu(trans(priv),
 						 REPLY_WOWLAN_TKIP_PARAMS,
 						 CMD_SYNC, sizeof(tkip_cmd),
 						 &tkip_cmd);
@@ -2663,7 +2663,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 			kek_kck_cmd.kek_len = cpu_to_le16(NL80211_KEK_LEN);
 			kek_kck_cmd.replay_ctr = priv->replay_ctr;
 
-			ret = trans_send_cmd_pdu(&priv->trans,
+			ret = iwl_trans_send_cmd_pdu(trans(priv),
 						 REPLY_WOWLAN_KEK_KCK_MATERIAL,
 						 CMD_SYNC, sizeof(kek_kck_cmd),
 						 &kek_kck_cmd);
@@ -2672,7 +2672,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		}
 	}
 
-	ret = trans_send_cmd_pdu(&priv->trans, REPLY_WOWLAN_WAKEUP_FILTER,
+	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WOWLAN_WAKEUP_FILTER,
 				 CMD_SYNC, sizeof(wakeup_filter_cmd),
 				 &wakeup_filter_cmd);
 	if (ret)
@@ -2940,7 +2940,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
-		trans_txq_agg_setup(&priv->trans, iwl_sta_id(sta), tid,
+		iwl_trans_txq_agg_setup(trans(priv), iwl_sta_id(sta), tid,
 				buf_size);
 
 		/*
@@ -3654,7 +3654,8 @@ out:
 	return hw;
 }
 
-int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
+int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
+		struct iwl_cfg *cfg)
 {
 	int err = 0;
 	struct iwl_priv *priv;
@@ -3678,6 +3679,12 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	priv->shrd->priv = priv;
 	bus_set_drv_data(priv->bus, priv->shrd);
 
+	priv->shrd->trans = trans_ops->alloc(priv->shrd);
+	if (priv->shrd->trans == NULL) {
+		err = -ENOMEM;
+		goto out_free_traffic_mem;
+	}
+
 	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(hw, priv->bus->dev);
@@ -3720,11 +3727,11 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		priv->cfg->name, hw_rev);
 
-	err = iwl_trans_register(&priv->trans, priv);
+	err = iwl_trans_request_irq(trans(priv));
 	if (err)
-		goto out_free_traffic_mem;
+		goto out_free_trans;
 
-	if (trans_prepare_card_hw(&priv->trans)) {
+	if (iwl_trans_prepare_card_hw(trans(priv))) {
 		err = -EIO;
 		IWL_WARN(priv, "Failed, HW not ready\n");
 		goto out_free_trans;
@@ -3818,7 +3825,7 @@ out_destroy_workqueue:
 out_free_eeprom:
 	iwl_eeprom_free(priv);
 out_free_trans:
-	trans_free(&priv->trans);
+	iwl_trans_free(trans(priv));
 out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
 	ieee80211_free_hw(priv->hw);
@@ -3864,12 +3871,12 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
-	trans_sync_irq(&priv->trans);
+	iwl_trans_sync_irq(trans(priv));
 
 	iwl_dealloc_ucode(priv);
 
-	trans_rx_free(&priv->trans);
-	trans_tx_free(&priv->trans);
+	iwl_trans_rx_free(trans(priv));
+	iwl_trans_tx_free(trans(priv));
 
 	iwl_eeprom_free(priv);
 
@@ -3883,7 +3890,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	priv->shrd->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
-	trans_free(&priv->trans);
+	iwl_trans_free(trans(priv));
 
 	bus_set_drv_data(priv->bus, NULL);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index a698004..5d0e155 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -89,7 +89,7 @@ struct iwl_bus_ops {
 struct iwl_bus {
 	/* Common data to all buses */
 	struct device *dev;
-	struct iwl_bus_ops *ops;
+	const struct iwl_bus_ops *ops;
 	struct iwl_shared *shrd;
 
 	unsigned int irq;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9857136..b5e99a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -378,7 +378,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			le32_to_cpu(ctx->timing.beacon_init_val),
 			le16_to_cpu(ctx->timing.atim_window));
 
-	return trans_send_cmd_pdu(&priv->trans, ctx->rxon_timing_cmd,
+	return iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_timing_cmd,
 				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
 }
 
@@ -1135,7 +1135,7 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
-	if (trans_send_cmd_pdu(&priv->trans, REPLY_BT_CONFIG,
+	if (iwl_trans_send_cmd_pdu(trans(priv), REPLY_BT_CONFIG,
 			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
@@ -1148,12 +1148,12 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 	};
 
 	if (flags & CMD_ASYNC)
-		return trans_send_cmd_pdu(&priv->trans, REPLY_STATISTICS_CMD,
+		return iwl_trans_send_cmd_pdu(trans(priv), REPLY_STATISTICS_CMD,
 					      CMD_ASYNC,
 					       sizeof(struct iwl_statistics_cmd),
 					       &statistics_cmd);
 	else
-		return trans_send_cmd_pdu(&priv->trans, REPLY_STATISTICS_CMD,
+		return iwl_trans_send_cmd_pdu(trans(priv), REPLY_STATISTICS_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_statistics_cmd),
 					&statistics_cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 22e87b2..6e28602 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1233,7 +1233,6 @@ struct iwl_priv {
 
 	/*TODO: remove these pointers - use bus(priv) instead */
 	struct iwl_bus *bus;	/* bus specific data */
-	struct iwl_trans trans;
 
 	/* microcode/device supports multiple contexts */
 	u8 valid_contexts;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 2261fff..76ee2d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -113,7 +113,7 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
 		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
 
-	return trans_send_cmd(&priv->trans, &cmd);
+	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
 /* Set led pattern command */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 3b7efd7..521d7e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -66,6 +66,7 @@
 #include "iwl-bus.h"
 #include "iwl-shared.h"
 #include "iwl-agn.h"
+#include "iwl-trans.h"
 
 /* TODO: iwl_set_bit and friends should be implemented in bus layer
  * this would allow us not to include iwl-io.h here */
@@ -165,7 +166,7 @@ static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
 	return val;
 }
 
-static struct iwl_bus_ops pci_ops = {
+static const struct iwl_bus_ops bus_ops_pci = {
 	.get_pm_support = iwl_pci_is_pm_supported,
 	.apm_config = iwl_pci_apm_config,
 	.set_drv_data = iwl_pci_set_drv_data,
@@ -460,9 +461,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bus->dev = &pdev->dev;
 	bus->irq = pdev->irq;
-	bus->ops = &pci_ops;
+	bus->ops = &bus_ops_pci;
 
-	err = iwl_probe(bus, cfg);
+	err = iwl_probe(bus, &trans_ops_pcie, cfg);
 	if (err)
 		goto out_disable_msi;
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 2ffb1f8..f912c31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -336,7 +336,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return trans_send_cmd_pdu(&priv->trans, POWER_TABLE_CMD, CMD_SYNC,
+	return iwl_trans_send_cmd_pdu(trans(priv), POWER_TABLE_CMD, CMD_SYNC,
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index fa100c5..1a0cb66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -75,7 +75,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	    test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return -EIO;
 
-	ret = trans_send_cmd(&priv->trans, &cmd);
+	ret = iwl_trans_send_cmd(trans(priv), &cmd);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 71496bf..467cfaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -63,10 +63,14 @@
 #ifndef __iwl_shared_h__
 #define __iwl_shared_h__
 
+/*This files includes all the types / functions that are exported by the
+ * upper layer to the bus and transport layer */
+
 struct iwl_cfg;
 struct iwl_bus;
 struct iwl_priv;
 struct iwl_sensitivity_ranges;
+struct iwl_trans_ops;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 
@@ -164,6 +168,7 @@ struct iwl_shared {
 
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
+	struct iwl_trans *trans;
 	struct iwl_hw_params hw_params;
 
 	struct workqueue_struct *workqueue;
@@ -175,6 +180,7 @@ struct iwl_shared {
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
 #define priv(_m)	((_m)->shrd->priv)
 #define bus(_m)		((_m)->shrd->bus)
+#define trans(_m)	((_m)->shrd->trans)
 #define hw_params(_m)	((_m)->shrd->hw_params)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -204,7 +210,8 @@ int iwl_suspend(struct iwl_priv *priv);
 int iwl_resume(struct iwl_priv *priv);
 #endif /* !CONFIG_PM */
 
-int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg);
+int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
+		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
 
 #endif /* #__iwl_shared_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 9424d79..d4c625c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -168,7 +168,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	}
 
 	cmd.len[0] = iwlagn_build_addsta_hcmd(sta, data);
-	ret = trans_send_cmd(&priv->trans, &cmd);
+	ret = iwl_trans_send_cmd(trans(priv), &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
@@ -425,7 +425,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 
 	cmd.flags |= CMD_WANT_SKB;
 
-	ret = trans_send_cmd(&priv->trans, &cmd);
+	ret = iwl_trans_send_cmd(trans(priv), &cmd);
 
 	if (ret)
 		return ret;
@@ -799,7 +799,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		return -EINVAL;
 
 	if (is_lq_table_valid(priv, ctx, lq))
-		ret = trans_send_cmd(&priv->trans, &cmd);
+		ret = iwl_trans_send_cmd(trans(priv), &cmd);
 	else
 		ret = -EINVAL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index ac751fa..4d4358a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -239,7 +239,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
 				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
 	/* ok, let's submit the command to ucode */
-	return trans_send_cmd(&priv->trans, &cmd);
+	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
 
@@ -405,7 +405,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
 		iwl_testmode_cfg_init_calib(priv);
-		trans_stop_device(&priv->trans);
+		iwl_trans_stop_device(trans(priv));
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index b79330d..2bc421b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -32,6 +32,12 @@
 /*This file includes the declaration that are internal to the
  * trans_pcie layer */
 
+/**
+ * struct iwl_trans_pcie - PCIe transport specific data
+ */
+struct iwl_trans_pcie {
+};
+
 /*****************************************************
 * RX
 ******************************************************/
@@ -62,21 +68,21 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 dma_addr_t addr, u16 len, u8 reset);
 int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id);
-int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
-int __must_check iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
-			u16 len, const void *data);
+int iwl_trans_pcie_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_priv *priv, u8 id,
+			u32 flags, u16 len, const void *data);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
-int iwl_trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				  u16 ssn_idx, u8 tx_fifo);
 void iwl_trans_set_wr_ptrs(struct iwl_priv *priv,
 		     int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
-void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
+void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 						int frame_limit);
 
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 9c4bf8c..6f5edf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -443,7 +443,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the buffer to caller,
 			 * and fire off the (possibly) blocking
-			 * trans_send_cmd()
+			 * iwl_trans_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
 				iwl_tx_cmd_complete(priv, rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index b0ad127..9d7287e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -422,7 +422,7 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
 
-void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
+void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 						int frame_limit)
 {
 	int tx_fifo, txq_id, ssn_idx;
@@ -483,7 +483,7 @@ void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
-int iwl_trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				  u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
@@ -1015,7 +1015,7 @@ fail:
 	return ret;
 }
 
-int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+int iwl_trans_pcie_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	if (cmd->flags & CMD_ASYNC)
 		return iwl_send_cmd_async(priv, cmd);
@@ -1023,8 +1023,8 @@ int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return iwl_send_cmd_sync(priv, cmd);
 }
 
-int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
-		     const void *data)
+int iwl_trans_pcie_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
+		u16 len, const void *data)
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
@@ -1033,5 +1033,5 @@ int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
 		.flags = flags,
 	};
 
-	return iwl_send_cmd(priv, &cmd);
+	return iwl_trans_pcie_send_cmd(priv, &cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index cc3fc23..739087f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -60,6 +60,8 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+#include <linux/interrupt.h>
+
 #include "iwl-dev.h"
 #include "iwl-trans.h"
 #include "iwl-core.h"
@@ -218,7 +220,7 @@ static int iwl_rx_init(struct iwl_priv *priv)
 	return 0;
 }
 
-static void iwl_trans_rx_free(struct iwl_priv *priv)
+static void iwl_trans_pcie_rx_free(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	unsigned long flags;
@@ -453,7 +455,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
  *
  * Destroy all TX DMA queues and structures
  */
-static void iwl_trans_tx_free(struct iwl_priv *priv)
+static void iwl_trans_pcie_tx_free(struct iwl_priv *priv)
 {
 	int txq_id;
 
@@ -528,7 +530,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 	return 0;
 
 error:
-	trans_tx_free(&priv->trans);
+	iwl_trans_tx_free(trans(priv));
 
 	return ret;
 }
@@ -572,7 +574,7 @@ static int iwl_tx_init(struct iwl_priv *priv)
 error:
 	/*Upon error, free only if we allocated something */
 	if (alloc)
-		trans_tx_free(&priv->trans);
+		iwl_trans_tx_free(trans(priv));
 	return ret;
 }
 
@@ -649,7 +651,7 @@ static int iwl_set_hw_ready(struct iwl_priv *priv)
 }
 
 /* Note: returns standard 0/-ERROR code */
-static int iwl_trans_prepare_card_hw(struct iwl_priv *priv)
+static int iwl_trans_pcie_prepare_card_hw(struct iwl_priv *priv)
 {
 	int ret;
 
@@ -677,14 +679,14 @@ static int iwl_trans_prepare_card_hw(struct iwl_priv *priv)
 	return ret;
 }
 
-static int iwl_trans_start_device(struct iwl_priv *priv)
+static int iwl_trans_pcie_start_device(struct iwl_priv *priv)
 {
 	int ret;
 
 	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
 
 	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
-	     iwl_trans_prepare_card_hw(priv)) {
+	     iwl_trans_pcie_prepare_card_hw(priv)) {
 		IWL_WARN(priv, "Exit HW not ready\n");
 		return -EIO;
 	}
@@ -768,7 +770,7 @@ static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
 	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
 	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
 };
-static void iwl_trans_tx_start(struct iwl_priv *priv)
+static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
 	struct iwl_rxon_context *ctx;
@@ -916,7 +918,7 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 	return 0;
 }
 
-static void iwl_trans_stop_device(struct iwl_priv *priv)
+static void iwl_trans_pcie_stop_device(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
@@ -927,7 +929,7 @@ static void iwl_trans_stop_device(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
-	trans_sync_irq(&priv->trans);
+	iwl_trans_sync_irq(trans(priv));
 
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(priv);
@@ -956,7 +958,7 @@ static void iwl_trans_stop_device(struct iwl_priv *priv)
 	iwl_apm_stop(priv);
 }
 
-static struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_priv *priv,
+static struct iwl_tx_cmd *iwl_trans_pcie_get_tx_cmd(struct iwl_priv *priv,
 						int txq_id)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
@@ -980,7 +982,7 @@ static struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_priv *priv,
 	return &dev_cmd->cmd.tx;
 }
 
-static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
+static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx)
 {
@@ -1109,71 +1111,88 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return 0;
 }
 
-static void iwl_trans_kick_nic(struct iwl_priv *priv)
+static void iwl_trans_pcie_kick_nic(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
 	iwl_write32(priv, CSR_RESET, 0);
 }
 
-static void iwl_trans_sync_irq(struct iwl_priv *priv)
+static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
+{
+	struct iwl_priv *priv = priv(trans);
+	int err;
+
+	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+		iwl_irq_tasklet, (unsigned long)priv);
+
+	iwl_alloc_isr_ict(priv);
+
+	err = request_irq(bus(trans)->irq, iwl_isr_ict, IRQF_SHARED,
+		DRV_NAME, priv);
+	if (err) {
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus->irq);
+		iwl_free_isr_ict(priv);
+		return err;
+	}
+
+	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
+	return 0;
+}
+
+static void iwl_trans_pcie_sync_irq(struct iwl_priv *priv)
 {
 	/* wait to make sure we flush pending tasklet*/
 	synchronize_irq(priv->bus->irq);
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-static void iwl_trans_free(struct iwl_priv *priv)
+static void iwl_trans_pcie_free(struct iwl_priv *priv)
 {
 	free_irq(priv->bus->irq, priv);
 	iwl_free_isr_ict(priv);
+	kfree(trans(priv));
+	trans(priv) = NULL;
 }
 
-static const struct iwl_trans_ops trans_ops = {
-	.start_device = iwl_trans_start_device,
-	.prepare_card_hw = iwl_trans_prepare_card_hw,
-	.stop_device = iwl_trans_stop_device,
-
-	.tx_start = iwl_trans_tx_start,
+const struct iwl_trans_ops trans_ops_pcie;
 
-	.rx_free = iwl_trans_rx_free,
-	.tx_free = iwl_trans_tx_free,
+static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
+{
+	struct iwl_trans *iwl_trans = kzalloc(sizeof(struct iwl_trans) +
+					      sizeof(struct iwl_trans_pcie),
+					      GFP_KERNEL);
+	if (iwl_trans) {
+		iwl_trans->ops = &trans_ops_pcie;
+		iwl_trans->shrd = shrd;
+	}
 
-	.send_cmd = iwl_send_cmd,
-	.send_cmd_pdu = iwl_send_cmd_pdu,
+	return iwl_trans;
+}
 
-	.get_tx_cmd = iwl_trans_get_tx_cmd,
-	.tx = iwl_trans_tx,
+const struct iwl_trans_ops trans_ops_pcie = {
+	.alloc = iwl_trans_pcie_alloc,
+	.request_irq = iwl_trans_pcie_request_irq,
+	.start_device = iwl_trans_pcie_start_device,
+	.prepare_card_hw = iwl_trans_pcie_prepare_card_hw,
+	.stop_device = iwl_trans_pcie_stop_device,
 
-	.txq_agg_disable = iwl_trans_txq_agg_disable,
-	.txq_agg_setup = iwl_trans_txq_agg_setup,
+	.tx_start = iwl_trans_pcie_tx_start,
 
-	.kick_nic = iwl_trans_kick_nic,
+	.rx_free = iwl_trans_pcie_rx_free,
+	.tx_free = iwl_trans_pcie_tx_free,
 
-	.sync_irq = iwl_trans_sync_irq,
-	.free = iwl_trans_free,
-};
+	.send_cmd = iwl_trans_pcie_send_cmd,
+	.send_cmd_pdu = iwl_trans_pcie_send_cmd_pdu,
 
-int iwl_trans_register(struct iwl_trans *trans, struct iwl_priv *priv)
-{
-	int err;
+	.get_tx_cmd = iwl_trans_pcie_get_tx_cmd,
+	.tx = iwl_trans_pcie_tx,
 
-	priv->trans.ops = &trans_ops;
-	priv->trans.priv = priv;
+	.txq_agg_disable = iwl_trans_pcie_txq_agg_disable,
+	.txq_agg_setup = iwl_trans_pcie_txq_agg_setup,
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		iwl_irq_tasklet, (unsigned long)priv);
+	.kick_nic = iwl_trans_pcie_kick_nic,
 
-	iwl_alloc_isr_ict(priv);
-
-	err = request_irq(priv->bus->irq, iwl_isr_ict, IRQF_SHARED,
-		DRV_NAME, priv);
-	if (err) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus->irq);
-		iwl_free_isr_ict(priv);
-		return err;
-	}
-
-	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
+	.sync_irq = iwl_trans_pcie_sync_irq,
+	.free = iwl_trans_pcie_free,
+};
 
-	return 0;
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7993aa7..eec25b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -69,9 +69,12 @@
 struct iwl_priv;
 struct iwl_rxon_context;
 struct iwl_host_cmd;
+struct iwl_shared;
 
 /**
  * struct iwl_trans_ops - transport specific operations
+ * @alloc: allocates the meta data (not the queues themselves)
+ * @request_irq: requests IRQ - will be called before the FW load in probe flow
  * @start_device: allocates and inits all the resources for the transport
  *                layer.
  * @prepare_card_hw: claim the ownership on the HW. Will be called during
@@ -98,6 +101,8 @@ struct iwl_host_cmd;
  */
 struct iwl_trans_ops {
 
+	struct iwl_trans *(*alloc)(struct iwl_shared *shrd);
+	int (*request_irq)(struct iwl_trans *iwl_trans);
 	int (*start_device)(struct iwl_priv *priv);
 	int (*prepare_card_hw)(struct iwl_priv *priv);
 	void (*stop_device)(struct iwl_priv *priv);
@@ -127,93 +132,105 @@ struct iwl_trans_ops {
 
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
-	struct iwl_priv *priv;
+	struct iwl_shared *shrd;
+
+	/* pointer to trans specific struct */
+	/*Ensure that this pointer will always be aligned to sizeof pointer */
+	char trans_specific[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
-static inline int trans_start_device(struct iwl_trans *trans)
+static inline int iwl_trans_request_irq(struct iwl_trans *trans)
+{
+	return trans->ops->request_irq(trans);
+}
+
+static inline int iwl_trans_start_device(struct iwl_trans *trans)
 {
-	return trans->ops->start_device(trans->priv);
+	return trans->ops->start_device(priv(trans));
 }
 
-static inline int trans_prepare_card_hw(struct iwl_trans *trans)
+static inline int iwl_trans_prepare_card_hw(struct iwl_trans *trans)
 {
-	return trans->ops->prepare_card_hw(trans->priv);
+	return trans->ops->prepare_card_hw(priv(trans));
 }
 
-static inline void trans_stop_device(struct iwl_trans *trans)
+static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 {
-	trans->ops->stop_device(trans->priv);
+	trans->ops->stop_device(priv(trans));
 }
 
-static inline void trans_tx_start(struct iwl_trans *trans)
+static inline void iwl_trans_tx_start(struct iwl_trans *trans)
 {
-	trans->ops->tx_start(trans->priv);
+	trans->ops->tx_start(priv(trans));
 }
 
-static inline void trans_rx_free(struct iwl_trans *trans)
+static inline void iwl_trans_rx_free(struct iwl_trans *trans)
 {
-	trans->ops->rx_free(trans->priv);
+	trans->ops->rx_free(priv(trans));
 }
 
-static inline void trans_tx_free(struct iwl_trans *trans)
+static inline void iwl_trans_tx_free(struct iwl_trans *trans)
 {
-	trans->ops->tx_free(trans->priv);
+	trans->ops->tx_free(priv(trans));
 }
 
-static inline int trans_send_cmd(struct iwl_trans *trans,
+static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
-	return trans->ops->send_cmd(trans->priv, cmd);
+	return trans->ops->send_cmd(priv(trans), cmd);
 }
 
-static inline int trans_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
-					u16 len, const void *data)
+static inline int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
+					u32 flags, u16 len, const void *data)
 {
-	return trans->ops->send_cmd_pdu(trans->priv, id, flags, len, data);
+	return trans->ops->send_cmd_pdu(priv(trans), id, flags, len, data);
 }
 
-static inline struct iwl_tx_cmd *trans_get_tx_cmd(struct iwl_trans *trans,
+static inline struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_trans *trans,
 					int txq_id)
 {
-	return trans->ops->get_tx_cmd(trans->priv, txq_id);
+	return trans->ops->get_tx_cmd(priv(trans), txq_id);
 }
 
-static inline int trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
+static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx)
 {
-	return trans->ops->tx(trans->priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
+	return trans->ops->tx(priv(trans), skb, tx_cmd, txq_id, fc, ampdu, ctx);
 }
 
-static inline int trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id,
+static inline int iwl_trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id,
 			  u16 ssn_idx, u8 tx_fifo)
 {
-	return trans->ops->txq_agg_disable(trans->priv, txq_id,
+	return trans->ops->txq_agg_disable(priv(trans), txq_id,
 					   ssn_idx, tx_fifo);
 }
 
-static inline void trans_txq_agg_setup(struct iwl_trans *trans, int sta_id,
+static inline void iwl_trans_txq_agg_setup(struct iwl_trans *trans, int sta_id,
 						int tid, int frame_limit)
 {
-	trans->ops->txq_agg_setup(trans->priv, sta_id, tid, frame_limit);
+	trans->ops->txq_agg_setup(priv(trans), sta_id, tid, frame_limit);
 }
 
-static inline void trans_kick_nic(struct iwl_trans *trans)
+static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
 {
-	trans->ops->kick_nic(trans->priv);
+	trans->ops->kick_nic(priv(trans));
 }
 
-static inline void trans_sync_irq(struct iwl_trans *trans)
+static inline void iwl_trans_sync_irq(struct iwl_trans *trans)
 {
-	trans->ops->sync_irq(trans->priv);
+	trans->ops->sync_irq(priv(trans));
 }
 
-static inline void trans_free(struct iwl_trans *trans)
+static inline void iwl_trans_free(struct iwl_trans *trans)
 {
-	trans->ops->free(trans->priv);
+	trans->ops->free(priv(trans));
 }
 
-int iwl_trans_register(struct iwl_trans *trans, struct iwl_priv *priv);
+/*****************************************************
+* Transport layers implementations
+******************************************************/
+extern const struct iwl_trans_ops trans_ops_pcie;
 
 /*TODO: this functions should NOT be exported from trans module - export it
  * until the reclaim flow will be brought to the transport module too */
-- 
1.7.0.4

