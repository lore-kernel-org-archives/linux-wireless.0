Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab1GHQUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/21] iwlagn: provide heplers to access the transport ops
Date: Fri,  8 Jul 2011 08:46:16 -0700
Message-Id: <1310139989-27661-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182044_708955_3394E65F)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This removes the for priv->trans.ops->...

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    7 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |    9 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   19 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   13 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    9 +++--
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   14 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.c      |    9 +++--
 drivers/net/wireless/iwlwifi/iwl-led.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-power.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |    7 ++--
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   41 ++++++++++++++++++++++++++
 17 files changed, 104 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0c5105f..835ed7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -46,6 +46,7 @@
 #include "iwl-agn.h"
 #include "iwl-agn-hw.h"
 #include "iwl-5000-hw.h"
+#include "iwl-trans.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
@@ -314,7 +315,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return priv->trans.ops->send_cmd(priv, &hcmd);
+	return trans_send_cmd(priv, &hcmd);
 }
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ced3bbe..f03448f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -45,6 +45,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
+#include "iwl-trans.h"
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
@@ -254,7 +255,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 		return -EFAULT;
 	}
 
-	return priv->trans.ops->send_cmd(priv, &hcmd);
+	return trans_send_cmd(priv, &hcmd);
 }
 
 static struct iwl_lib_ops iwl6000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index e7c74fc..2ec3863 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -66,6 +66,7 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-agn-calib.h"
+#include "iwl-trans.h"
 
 /*****************************************************************************
  * INIT calibrations framework
@@ -96,7 +97,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 			hcmd.len[0] = priv->calib_results[i].buf_len;
 			hcmd.data[0] = priv->calib_results[i].buf;
 			hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-			ret = priv->trans.ops->send_cmd(priv, &hcmd);
+			ret = trans_send_cmd(priv, &hcmd);
 			if (ret) {
 				IWL_ERR(priv, "Error %d iteration %d\n",
 					ret, i);
@@ -482,7 +483,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
 	       sizeof(u16)*HD_TABLE_SIZE);
 
-	return priv->trans.ops->send_cmd(priv, &cmd_out);
+	return trans_send_cmd(priv, &cmd_out);
 }
 
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
@@ -546,7 +547,7 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 	       &(cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX]),
 	       sizeof(u16)*ENHANCE_HD_TABLE_ENTRIES);
 
-	return priv->trans.ops->send_cmd(priv, &cmd_out);
+	return trans_send_cmd(priv, &cmd_out);
 }
 
 void iwl_init_sensitivity(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 406bf59..4d7674c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -36,6 +36,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
+#include "iwl-trans.h"
 
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 {
@@ -45,7 +46,7 @@ int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 
 	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
-		return priv->trans.ops->send_cmd_pdu(priv,
+		return trans_send_cmd_pdu(priv,
 					TX_ANT_CONFIGURATION_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_tx_ant_config_cmd),
@@ -117,7 +118,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			priv->_agn.phy_calib_chain_noise_gain_cmd);
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
-		priv->trans.ops->send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+		trans_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 			CMD_ASYNC, sizeof(cmd), &cmd);
 
 		data->radio_write = 1;
@@ -146,7 +147,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 		memset(&cmd, 0, sizeof(cmd));
 		iwl_set_calib_hdr(&cmd.hdr,
 			priv->_agn.phy_calib_chain_noise_reset_cmd);
-		ret = priv->trans.ops->send_cmd_pdu(priv,
+		ret = trans_send_cmd_pdu(priv,
 					REPLY_PHY_CALIBRATION_CMD,
 					CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
@@ -293,7 +294,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].width = cpu_to_le16(slot0);
 	cmd.slots[1].width = cpu_to_le16(slot1);
 
-	ret = priv->trans.ops->send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, CMD_SYNC,
+	ret = trans_send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, CMD_SYNC,
 			sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(priv, "Error setting PAN parameters (%d)\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 39664c9..cfe945c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -39,6 +39,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
 #include "iwl-sta.h"
+#include "iwl-trans.h"
 
 static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
 {
@@ -540,7 +541,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return priv->trans.ops->send_cmd_pdu(priv, tx_ant_cfg_cmd, CMD_SYNC,
+	return trans_send_cmd_pdu(priv, tx_ant_cfg_cmd, CMD_SYNC,
 			sizeof(tx_power_cmd), &tx_power_cmd);
 }
 
@@ -714,7 +715,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	priv->cfg->ops->lib->apm_ops.config(priv);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
-	priv->trans.ops->rx_init(priv);
+	trans_rx_init(priv);
 
 	iwlagn_rx_replenish(priv);
 
@@ -728,7 +729,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Allocate or reset and init all Tx and Command queues */
-	if (priv->trans.ops->tx_init(priv))
+	if (trans_tx_init(priv))
 		return -ENOMEM;
 
 	if (priv->cfg->base_params->shadow_reg_enable) {
@@ -1360,7 +1361,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (ret)
 		return ret;
 
-	ret = priv->trans.ops->send_cmd(priv, &cmd);
+	ret = trans_send_cmd(priv, &cmd);
 	if (ret) {
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 		iwlagn_set_pan_params(priv);
@@ -1466,7 +1467,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		       flush_cmd.fifo_control);
 	flush_cmd.flush_control = cpu_to_le16(flush_control);
 
-	return priv->trans.ops->send_cmd(priv, &cmd);
+	return trans_send_cmd(priv, &cmd);
 }
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
@@ -1658,12 +1659,12 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	if (priv->cfg->bt_params->bt_session_2) {
 		memcpy(&bt_cmd_2000.basic, &basic,
 			sizeof(basic));
-		ret = priv->trans.ops->send_cmd_pdu(priv, REPLY_BT_CONFIG,
+		ret = trans_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_2000), &bt_cmd_2000);
 	} else {
 		memcpy(&bt_cmd_6000.basic, &basic,
 			sizeof(basic));
-		ret = priv->trans.ops->send_cmd_pdu(priv, REPLY_BT_CONFIG,
+		ret = trans_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 			CMD_SYNC, sizeof(bt_cmd_6000), &bt_cmd_6000);
 	}
 	if (ret)
@@ -2311,8 +2312,8 @@ void iwlagn_stop_device(struct iwl_priv *priv)
 	 * already dead.
 	 */
 	if (test_bit(STATUS_DEVICE_ENABLED, &priv->status)) {
-		priv->trans.ops->tx_stop(priv);
-		priv->trans.ops->rx_stop(priv);
+		trans_tx_stop(priv);
+		trans_rx_stop(priv);
 
 		/* Power-down device's busmaster DMA clocks */
 		iwl_write_prph(priv, APMG_CLK_DIS_REG,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index c365295..d32cee1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -30,6 +30,7 @@
 #include "iwl-core.h"
 #include "iwl-agn-calib.h"
 #include "iwl-helpers.h"
+#include "iwl-trans.h"
 
 static int iwlagn_disable_bss(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx,
@@ -39,7 +40,7 @@ static int iwlagn_disable_bss(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd,
+	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -65,7 +66,7 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
-	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd,
+	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd,
 				CMD_SYNC, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -91,7 +92,7 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
+	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
 				sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -120,7 +121,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
-	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->qos_cmd, CMD_SYNC,
+	ret = trans_send_cmd_pdu(priv, ctx->qos_cmd, CMD_SYNC,
 			       sizeof(struct iwl_qosparam_cmd),
 			       &ctx->qos_data.def_qos_parm);
 	if (ret)
@@ -179,7 +180,7 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
 	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
 
-	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_assoc_cmd,
+	ret = trans_send_cmd_pdu(priv, ctx->rxon_assoc_cmd,
 				CMD_ASYNC, sizeof(rxon_assoc), &rxon_assoc);
 	return ret;
 }
@@ -265,7 +266,7 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	 * Associated RXON doesn't clear the station table in uCode,
 	 * so we don't need to restore stations etc. after this.
 	 */
-	ret = priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
+	ret = trans_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
 		      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 	if (ret) {
 		IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index b0e54c9..001622c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -33,6 +33,7 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 #include "iwl-agn.h"
+#include "iwl-trans.h"
 
 static struct iwl_link_quality_cmd *
 iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx, u8 sta_id)
@@ -180,7 +181,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 	cmd.len[0] = cmd_size;
 
 	if (not_empty || send_if_empty)
-		return priv->trans.ops->send_cmd(priv, &cmd);
+		return trans_send_cmd(priv, &cmd);
 	else
 		return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index d31b826..06304a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -39,6 +39,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
 #include "iwl-agn-calib.h"
+#include "iwl-trans.h"
 
 #define IWL_AC_UNSET -1
 
@@ -223,7 +224,7 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	calib_cfg_cmd.ucd_calib_cfg.once.send_res = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.flags = IWL_CALIB_INIT_CFG_ALL;
 
-	return priv->trans.ops->send_cmd(priv, &cmd);
+	return trans_send_cmd(priv, &cmd);
 }
 
 void iwlagn_rx_calib_result(struct iwl_priv *priv,
@@ -321,7 +322,7 @@ static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
 		/* coexistence is disabled */
 		memset(&coex_cmd, 0, sizeof(coex_cmd));
 	}
-	return priv->trans.ops->send_cmd_pdu(priv,
+	return trans_send_cmd_pdu(priv,
 				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
 }
@@ -354,7 +355,7 @@ void iwlagn_send_prio_tbl(struct iwl_priv *priv)
 
 	memcpy(prio_tbl_cmd.prio_tbl, iwlagn_bt_prio_tbl,
 		sizeof(iwlagn_bt_prio_tbl));
-	if (priv->trans.ops->send_cmd_pdu(priv,
+	if (trans_send_cmd_pdu(priv,
 				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
@@ -367,7 +368,7 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	ret = priv->trans.ops->send_cmd_pdu(priv,
+	ret = trans_send_cmd_pdu(priv,
 			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d56d17c..3a4fca1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -206,7 +206,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	cmd.data[1] = priv->beacon_skb->data;
 	cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
 
-	return priv->trans.ops->send_cmd(priv, &cmd);
+	return trans_send_cmd(priv, &cmd);
 }
 
 static void iwl_bg_beacon_update(struct work_struct *work)
@@ -580,7 +580,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the buffer to caller,
 			 * and fire off the (possibly) blocking
-			 * priv->trans.ops->send_cmd()
+			 * trans_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
 				iwl_tx_cmd_complete(priv, rxb);
@@ -1942,7 +1942,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		adv_cmd.critical_temperature_exit =
 			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
 
-		ret = priv->trans.ops->send_cmd_pdu(priv,
+		ret = trans_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(adv_cmd), &adv_cmd);
 		if (ret)
@@ -1958,7 +1958,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		cmd.critical_temperature_R =
 			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 
-		ret = priv->trans.ops->send_cmd_pdu(priv,
+		ret = trans_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
 				       CMD_SYNC, sizeof(cmd), &cmd);
 		if (ret)
@@ -1984,7 +1984,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.start = cpu_to_le32(cfg);
 
-	return priv->trans.ops->send_cmd(priv, &cmd);
+	return trans_send_cmd(priv, &cmd);
 }
 
 
@@ -3713,8 +3713,8 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	iwl_dealloc_ucode(priv);
 
-	priv->trans.ops->rx_free(priv);
-	priv->trans.ops->tx_free(priv);
+	trans_rx_free(priv);
+	trans_tx_free(priv);
 
 	iwl_eeprom_free(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 78e031e..fa3d5ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -42,6 +42,7 @@
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-agn.h"
+#include "iwl-trans.h"
 
 u32 iwl_debug_level;
 
@@ -375,7 +376,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			le32_to_cpu(ctx->timing.beacon_init_val),
 			le16_to_cpu(ctx->timing.atim_window));
 
-	return priv->trans.ops->send_cmd_pdu(priv, ctx->rxon_timing_cmd,
+	return trans_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
 				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
 }
 
@@ -1131,7 +1132,7 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
-	if (priv->trans.ops->send_cmd_pdu(priv, REPLY_BT_CONFIG,
+	if (trans_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
@@ -1144,12 +1145,12 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 	};
 
 	if (flags & CMD_ASYNC)
-		return priv->trans.ops->send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+		return trans_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
 					      CMD_ASYNC,
 					       sizeof(struct iwl_statistics_cmd),
 					       &statistics_cmd);
 	else
-		return priv->trans.ops->send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+		return trans_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
 					CMD_SYNC,
 					sizeof(struct iwl_statistics_cmd),
 					&statistics_cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index d5bc3e0..60e4169 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -40,6 +40,7 @@
 #include "iwl-core.h"
 #include "iwl-agn.h"
 #include "iwl-io.h"
+#include "iwl-trans.h"
 
 /* Throughput		OFF time(ms)	ON time (ms)
  *	>300			25		25
@@ -111,7 +112,7 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
 		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
 
-	return priv->trans.ops->send_cmd(priv, &cmd);
+	return trans_send_cmd(priv, &cmd);
 }
 
 /* Set led pattern command */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 0c08dfd..9c10462 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -42,6 +42,7 @@
 #include "iwl-commands.h"
 #include "iwl-debug.h"
 #include "iwl-power.h"
+#include "iwl-trans.h"
 
 /*
  * Setting power level allows the card to go to sleep when not busy.
@@ -334,7 +335,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return priv->trans.ops->send_cmd_pdu(priv, POWER_TABLE_CMD, CMD_SYNC,
+	return trans_send_cmd_pdu(priv, POWER_TABLE_CMD, CMD_SYNC,
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 4c809bf..077d023 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -37,6 +37,7 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-agn.h"
+#include "iwl-trans.h"
 
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
@@ -74,7 +75,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	    test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EIO;
 
-	ret = priv->trans.ops->send_cmd(priv, &cmd);
+	ret = trans_send_cmd(priv, &cmd);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 06faa1e..78cf107 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -35,6 +35,7 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-sta.h"
+#include "iwl-trans.h"
 
 /* priv->sta_lock must be held */
 static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
@@ -156,7 +157,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	}
 
 	cmd.len[0] = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
-	ret = priv->trans.ops->send_cmd(priv, &cmd);
+	ret = trans_send_cmd(priv, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
@@ -412,7 +413,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 
 	cmd.flags |= CMD_WANT_SKB;
 
-	ret = priv->trans.ops->send_cmd(priv, &cmd);
+	ret = trans_send_cmd(priv, &cmd);
 
 	if (ret)
 		return ret;
@@ -781,7 +782,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		return -EINVAL;
 
 	if (is_lq_table_valid(priv, ctx, lq))
-		ret = priv->trans.ops->send_cmd(priv, &cmd);
+		ret = trans_send_cmd(priv, &cmd);
 	else
 		ret = -EINVAL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 6f92d22..81108be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -76,7 +76,7 @@
 #include "iwl-io.h"
 #include "iwl-agn.h"
 #include "iwl-testmode.h"
-
+#include "iwl-trans.h"
 
 /* The TLVs used in the gnl message policy between the kernel module and
  * user space application. iwl_testmode_gnl_msg_policy is to be carried
@@ -239,7 +239,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
 				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
 	/* ok, let's submit the command to ucode */
-	return priv->trans.ops->send_cmd(priv, &cmd);
+	return trans_send_cmd(priv, &cmd);
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 0c92456..d760857 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -467,7 +467,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 	return 0;
 
 error:
-	priv->trans.ops->tx_free(priv);
+	trans_tx_free(priv);
 
 	return ret;
 }
@@ -511,7 +511,7 @@ static int iwl_trans_tx_init(struct iwl_priv *priv)
 error:
 	/*Upon error, free only if we allocated something */
 	if (alloc)
-		priv->trans.ops->tx_free(priv);
+		trans_tx_free(priv);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index bec494c..111acca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -60,5 +60,46 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+static inline int trans_rx_init(struct iwl_priv *priv)
+{
+	return priv->trans.ops->rx_init(priv);
+}
+
+static inline int trans_rx_stop(struct iwl_priv *priv)
+{
+	return priv->trans.ops->rx_stop(priv);
+}
+
+static inline void trans_rx_free(struct iwl_priv *priv)
+{
+	priv->trans.ops->rx_free(priv);
+}
+
+static inline int trans_tx_init(struct iwl_priv *priv)
+{
+	return priv->trans.ops->tx_init(priv);
+}
+
+static inline int trans_tx_stop(struct iwl_priv *priv)
+{
+	return priv->trans.ops->tx_stop(priv);
+}
+
+static inline void trans_tx_free(struct iwl_priv *priv)
+{
+	priv->trans.ops->tx_free(priv);
+}
+
+static inline int trans_send_cmd(struct iwl_priv *priv,
+				struct iwl_host_cmd *cmd)
+{
+	return priv->trans.ops->send_cmd(priv, cmd);
+}
+
+static inline int trans_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
+					u16 len, const void *data)
+{
+	return priv->trans.ops->send_cmd_pdu(priv, id, flags, len, data);
+}
 
 void iwl_trans_register(struct iwl_trans *trans);
-- 
1.7.0.4

