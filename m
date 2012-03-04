Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab2CDUnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 037/101] iwlwifi: add wrappers for command sending
Date: Sun,  4 Mar 2012 11:28:51 -0800
Message-Id: <1330889395-533-38-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214420_231665_F79F41DA)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add wrappers to send commands from the DVM
op-mode (which essentially consists of the
current driver). This will allow us to move
specific sanity checks there.

Also, this removes iwl_trans_send_cmd_pdu()
since that can now be taken care of in the
DVM-specific wrapper.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile        |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   38 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   16 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    5 ++
 drivers/net/wireless/iwlwifi/iwl-core.c      |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-led.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |   77 --------------------------
 drivers/net/wireless/iwlwifi/iwl-trans.h     |    3 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c     |    8 +-
 17 files changed, 70 insertions(+), 128 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index afa0bb8..f2a903d 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -14,7 +14,6 @@ iwlwifi-objs		+= iwl-1000.o
 iwlwifi-objs		+= iwl-2000.o
 iwlwifi-objs		+= iwl-pci.o
 iwlwifi-objs		+= iwl-drv.o
-iwlwifi-objs		+= iwl-trans.o
 iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 iwlwifi-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index dff75a0..aebdfd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -281,7 +281,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return iwl_trans_send_cmd(trans(priv), &hcmd);
+	return iwl_dvm_send_cmd(priv, &hcmd);
 }
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ef89663..150bef0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -232,7 +232,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return iwl_trans_send_cmd(trans(priv), &hcmd);
+	return iwl_dvm_send_cmd(priv, &hcmd);
 }
 
 static struct iwl_lib_ops iwl6000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 588d107..579679e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -104,7 +104,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 		hcmd.len[0] = res->cmd_len;
 		hcmd.data[0] = &res->hdr;
 		hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-		ret = iwl_trans_send_cmd(trans(priv), &hcmd);
+		ret = iwl_dvm_send_cmd(priv, &hcmd);
 		if (ret) {
 			IWL_ERR(priv, "Error %d on calib cmd %d\n",
 				ret, res->hdr.op_code);
@@ -500,7 +500,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
 	       sizeof(u16)*HD_TABLE_SIZE);
 
-	return iwl_trans_send_cmd(trans(priv), &cmd_out);
+	return iwl_dvm_send_cmd(priv, &cmd_out);
 }
 
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
@@ -589,7 +589,7 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 	       &(cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX]),
 	       sizeof(u16)*ENHANCE_HD_TABLE_ENTRIES);
 
-	return iwl_trans_send_cmd(trans(priv), &cmd_out);
+	return iwl_dvm_send_cmd(priv, &cmd_out);
 }
 
 void iwl_init_sensitivity(struct iwl_priv *priv)
@@ -930,7 +930,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			priv->phy_calib_chain_noise_gain_cmd);
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
-		iwl_trans_send_cmd_pdu(trans(priv), REPLY_PHY_CALIBRATION_CMD,
+		iwl_dvm_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 			CMD_ASYNC, sizeof(cmd), &cmd);
 
 		data->radio_write = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b062832..4c777df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -81,7 +81,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return iwl_trans_send_cmd_pdu(trans(priv), tx_ant_cfg_cmd, CMD_SYNC,
+	return iwl_dvm_send_cmd_pdu(priv, tx_ant_cfg_cmd, CMD_SYNC,
 			sizeof(tx_power_cmd), &tx_power_cmd);
 }
 
@@ -241,7 +241,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		       flush_cmd.fifo_control);
 	flush_cmd.flush_control = cpu_to_le16(flush_control);
 
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+	return iwl_dvm_send_cmd(priv, &cmd);
 }
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
@@ -435,12 +435,12 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	if (cfg(priv)->bt_params->bt_session_2) {
 		memcpy(&bt_cmd_2000.basic, &basic,
 			sizeof(basic));
-		ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_BT_CONFIG,
+		ret = iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_2000), &bt_cmd_2000);
 	} else {
 		memcpy(&bt_cmd_6000.basic, &basic,
 			sizeof(basic));
-		ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_BT_CONFIG,
+		ret = iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_6000), &bt_cmd_6000);
 	}
 	if (ret)
@@ -1115,7 +1115,7 @@ int iwlagn_send_patterns(struct iwl_priv *priv,
 	}
 
 	cmd.data[0] = pattern_cmd;
-	err = iwl_trans_send_cmd(trans(priv), &cmd);
+	err = iwl_dvm_send_cmd(priv, &cmd);
 	kfree(pattern_cmd);
 	return err;
 }
@@ -1241,13 +1241,13 @@ int iwlagn_suspend(struct iwl_priv *priv,
 				.len[0] = sizeof(key_data.rsc_tsc),
 			};
 
-			ret = iwl_trans_send_cmd(trans(priv), &rsc_tsc_cmd);
+			ret = iwl_dvm_send_cmd(priv, &rsc_tsc_cmd);
 			if (ret)
 				goto out;
 		}
 
 		if (key_data.use_tkip) {
-			ret = iwl_trans_send_cmd_pdu(trans(priv),
+			ret = iwl_dvm_send_cmd_pdu(priv,
 						 REPLY_WOWLAN_TKIP_PARAMS,
 						 CMD_SYNC, sizeof(tkip_cmd),
 						 &tkip_cmd);
@@ -1263,7 +1263,7 @@ int iwlagn_suspend(struct iwl_priv *priv,
 			kek_kck_cmd.kek_len = cpu_to_le16(NL80211_KEK_LEN);
 			kek_kck_cmd.replay_ctr = priv->replay_ctr;
 
-			ret = iwl_trans_send_cmd_pdu(trans(priv),
+			ret = iwl_dvm_send_cmd_pdu(priv,
 						 REPLY_WOWLAN_KEK_KCK_MATERIAL,
 						 CMD_SYNC, sizeof(kek_kck_cmd),
 						 &kek_kck_cmd);
@@ -1272,12 +1272,12 @@ int iwlagn_suspend(struct iwl_priv *priv,
 		}
 	}
 
-	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_D3_CONFIG, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_D3_CONFIG, CMD_SYNC,
 				     sizeof(d3_cfg_cmd), &d3_cfg_cmd);
 	if (ret)
 		goto out;
 
-	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WOWLAN_WAKEUP_FILTER,
+	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_WOWLAN_WAKEUP_FILTER,
 				 CMD_SYNC, sizeof(wakeup_filter_cmd),
 				 &wakeup_filter_cmd);
 	if (ret)
@@ -1289,3 +1289,21 @@ int iwlagn_suspend(struct iwl_priv *priv,
 	return ret;
 }
 #endif
+
+int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+{
+	return iwl_trans_send_cmd(trans(priv), cmd);
+}
+
+int iwl_dvm_send_cmd_pdu(struct iwl_priv *priv, u8 id,
+			 u32 flags, u16 len, const void *data)
+{
+	struct iwl_host_cmd cmd = {
+		.id = id,
+		.len = { len, },
+		.data = { data, },
+		.flags = flags,
+	};
+
+	return iwl_dvm_send_cmd(priv, &cmd);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index e806ad8..53114db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -39,7 +39,7 @@ static int iwlagn_disable_bss(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -66,7 +66,7 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
-	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -92,7 +92,7 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
 				sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -121,7 +121,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
-	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->qos_cmd, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->qos_cmd, CMD_SYNC,
 			       sizeof(struct iwl_qosparam_cmd),
 			       &ctx->qos_data.def_qos_parm);
 	if (ret)
@@ -180,7 +180,7 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
 	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
 
-	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_assoc_cmd,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_assoc_cmd,
 				CMD_ASYNC, sizeof(rxon_assoc), &rxon_assoc);
 	return ret;
 }
@@ -266,7 +266,7 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	 * Associated RXON doesn't clear the station table in uCode,
 	 * so we don't need to restore stations etc. after this.
 	 */
-	ret = iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_cmd, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
 		      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 	if (ret) {
 		IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
@@ -385,7 +385,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].width = cpu_to_le16(slot0);
 	cmd.slots[1].width = cpu_to_le16(slot1);
 
-	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WIPAN_PARAMS, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, CMD_SYNC,
 			sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(priv, "Error setting PAN parameters (%d)\n", ret);
@@ -771,7 +771,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 		memset(&cmd, 0, sizeof(cmd));
 		iwl_set_calib_hdr(&cmd.hdr,
 			priv->phy_calib_chain_noise_reset_cmd);
-		ret = iwl_trans_send_cmd_pdu(trans(priv),
+		ret = iwl_dvm_send_cmd_pdu(priv,
 					REPLY_PHY_CALIBRATION_CMD,
 					CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index ca08026..73a25f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -153,7 +153,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		might_sleep();
 	}
 
-	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	ret = iwl_dvm_send_cmd(priv, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
@@ -447,7 +447,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 
 	cmd.flags |= CMD_WANT_SKB;
 
-	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	ret = iwl_dvm_send_cmd(priv, &cmd);
 
 	if (ret)
 		return ret;
@@ -785,7 +785,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		return -EINVAL;
 
 	if (is_lq_table_valid(priv, ctx, lq))
-		ret = iwl_trans_send_cmd(trans(priv), &cmd);
+		ret = iwl_dvm_send_cmd(priv, &cmd);
 	else
 		ret = -EINVAL;
 
@@ -970,7 +970,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 	cmd.len[0] = cmd_size;
 
 	if (not_empty || send_if_empty)
-		return iwl_trans_send_cmd(trans(priv), &cmd);
+		return iwl_dvm_send_cmd(priv, &cmd);
 	else
 		return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cdfe761..3f59a77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -197,7 +197,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	cmd.data[1] = priv->beacon_skb->data;
 	cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
 
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+	return iwl_dvm_send_cmd(priv, &cmd);
 }
 
 static void iwl_bg_beacon_update(struct work_struct *work)
@@ -563,7 +563,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		adv_cmd.critical_temperature_exit =
 			cpu_to_le32(hw_params(priv).ct_kill_exit_threshold);
 
-		ret = iwl_trans_send_cmd_pdu(trans(priv),
+		ret = iwl_dvm_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(adv_cmd), &adv_cmd);
 		if (ret)
@@ -578,7 +578,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		cmd.critical_temperature_R =
 			cpu_to_le32(hw_params(priv).ct_kill_threshold);
 
-		ret = iwl_trans_send_cmd_pdu(trans(priv),
+		ret = iwl_dvm_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
@@ -604,7 +604,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_RT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.start = cpu_to_le32(cfg);
 
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+	return iwl_dvm_send_cmd(priv, &cmd);
 }
 
 
@@ -616,7 +616,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 
 	if (IWL_UCODE_API(priv->fw->ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
-		return iwl_trans_send_cmd_pdu(trans(priv),
+		return iwl_dvm_send_cmd_pdu(priv,
 					TX_ANT_CONFIGURATION_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_tx_ant_config_cmd),
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index f552438..dfd86f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -96,6 +96,11 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			      const struct iwl_ucode_capabilities *capa);
 void iwlagn_mac_unregister(struct iwl_priv *priv);
 
+/* commands */
+int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+int iwl_dvm_send_cmd_pdu(struct iwl_priv *priv, u8 id,
+			 u32 flags, u16 len, const void *data);
+
 /* RXON */
 int iwlagn_set_pan_params(struct iwl_priv *priv);
 int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9a5ebec..26b7c68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -369,7 +369,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			le32_to_cpu(ctx->timing.beacon_init_val),
 			le16_to_cpu(ctx->timing.atim_window));
 
-	return iwl_trans_send_cmd_pdu(trans(priv), ctx->rxon_timing_cmd,
+	return iwl_dvm_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
 				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
 }
 
@@ -958,7 +958,7 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
-	if (iwl_trans_send_cmd_pdu(trans(priv), REPLY_BT_CONFIG,
+	if (iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
@@ -971,12 +971,12 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 	};
 
 	if (flags & CMD_ASYNC)
-		return iwl_trans_send_cmd_pdu(trans(priv), REPLY_STATISTICS_CMD,
+		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
 					      CMD_ASYNC,
 					       sizeof(struct iwl_statistics_cmd),
 					       &statistics_cmd);
 	else
-		return iwl_trans_send_cmd_pdu(trans(priv), REPLY_STATISTICS_CMD,
+		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_statistics_cmd),
 					&statistics_cmd);
@@ -1300,7 +1300,7 @@ int iwl_cmd_echo_test(struct iwl_priv *priv)
 		.flags = CMD_SYNC,
 	};
 
-	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	ret = iwl_dvm_send_cmd(priv, &cmd);
 	if (ret)
 		IWL_ERR(priv, "echo testing fail: 0X%x\n", ret);
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 5c7741f..f2f706f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -112,7 +112,7 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 		iwl_write32(trans(priv), CSR_LED_REG,
 			    reg & CSR_LED_BSM_CTRL_MSK);
 
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+	return iwl_dvm_send_cmd(priv, &cmd);
 }
 
 /* Set led pattern command */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 1ef3c4d..46ca820 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -336,7 +336,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return iwl_trans_send_cmd_pdu(trans(priv), POWER_TABLE_CMD, CMD_SYNC,
+	return iwl_dvm_send_cmd_pdu(priv, POWER_TABLE_CMD, CMD_SYNC,
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 28899da..dcba748 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -72,7 +72,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	    test_bit(STATUS_FW_ERROR, &priv->shrd->status))
 		return -EIO;
 
-	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	ret = iwl_dvm_send_cmd(priv, &cmd);
 	if (ret)
 		return ret;
 
@@ -887,7 +887,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (ret)
 		return ret;
 
-	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	ret = iwl_dvm_send_cmd(priv, &cmd);
 	if (ret) {
 		clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
 		iwlagn_set_pan_params(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index c1ecf0f..f26765b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -282,7 +282,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	IWL_DEBUG_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
 				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
 
-	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	ret = iwl_dvm_send_cmd(priv, &cmd);
 	if (ret) {
 		IWL_ERR(priv, "Failed to send hcmd\n");
 		return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
deleted file mode 100644
index 506c062..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ /dev/null
@@ -1,77 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-
-#include "iwl-trans.h"
-
-int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
-			   u32 flags, u16 len, const void *data)
-{
-	struct iwl_host_cmd cmd = {
-		.id = id,
-		.len = { len, },
-		.data = { data, },
-		.flags = flags,
-	};
-
-	return iwl_trans_send_cmd(trans, &cmd);
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ec5249c..a8d476a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -443,9 +443,6 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 	return trans->ops->send_cmd(trans, cmd);
 }
 
-int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
-			   u32 flags, u16 len, const void *data);
-
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
 		u8 sta_id, u8 tid)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 3747edb..1cbe8e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -179,7 +179,7 @@ static int iwl_send_calib_cfg(struct iwl_priv *priv)
 	calib_cfg_cmd.ucd_calib_cfg.flags =
 		IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK;
 
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+	return iwl_dvm_send_cmd(priv, &cmd);
 }
 
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
@@ -260,7 +260,7 @@ static int iwl_send_wimax_coex(struct iwl_priv *priv)
 		/* coexistence is disabled */
 		memset(&coex_cmd, 0, sizeof(coex_cmd));
 	}
-	return iwl_trans_send_cmd_pdu(trans(priv),
+	return iwl_dvm_send_cmd_pdu(priv,
 				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
 }
@@ -293,7 +293,7 @@ void iwl_send_prio_tbl(struct iwl_priv *priv)
 
 	memcpy(prio_tbl_cmd.prio_tbl, iwl_bt_prio_tbl,
 		sizeof(iwl_bt_prio_tbl));
-	if (iwl_trans_send_cmd_pdu(trans(priv),
+	if (iwl_dvm_send_cmd_pdu(priv,
 				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
@@ -306,7 +306,7 @@ int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	ret = iwl_trans_send_cmd_pdu(trans(priv),
+	ret = iwl_dvm_send_cmd_pdu(priv,
 			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
-- 
1.7.0.4

