Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab0CYUoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/22] iwlwifi: move ucode alive related code to separate file
Date: Thu, 25 Mar 2010 13:44:36 -0700
Message-Id: <1269549890-19195-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

uCode alive for iwlagn based devices share the same functions.
Move those functions from iwl-5000.c to iwl-agn-ucode.c.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |  239 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |  230 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   12 +-
 5 files changed, 251 insertions(+), 242 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index f866410..9d21160 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -178,8 +178,8 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwl5000_init_alive_start,
-	.alive_notify = iwl5000_alive_notify,
+	.init_alive_start = iwlagn_init_alive_start,
+	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a41af47..9128ccd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -65,19 +65,6 @@
 #define _IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE #api ".ucode"
 #define IWL5150_MODULE_FIRMWARE(api) _IWL5150_MODULE_FIRMWARE(api)
 
-static const s8 iwl5000_default_queue_to_tx_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-	IWLAGN_CMD_FIFO_NUM,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
-};
-
 /* NIC configuration for 5000 series */
 void iwl5000_nic_config(struct iwl_priv *priv)
 {
@@ -240,220 +227,6 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
 }
 
-/*
- *  Calibration
- */
-static int iwl5000_set_Xtal_calib(struct iwl_priv *priv)
-{
-	struct iwl_calib_xtal_freq_cmd cmd;
-	__le16 *xtal_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
-
-	cmd.hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
-	cmd.hdr.first_group = 0;
-	cmd.hdr.groups_num = 1;
-	cmd.hdr.data_valid = 1;
-	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
-	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
-	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
-			     (u8 *)&cmd, sizeof(cmd));
-}
-
-static int iwl5000_send_calib_cfg(struct iwl_priv *priv)
-{
-	struct iwl_calib_cfg_cmd calib_cfg_cmd;
-	struct iwl_host_cmd cmd = {
-		.id = CALIBRATION_CFG_CMD,
-		.len = sizeof(struct iwl_calib_cfg_cmd),
-		.data = &calib_cfg_cmd,
-	};
-
-	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
-	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
-	calib_cfg_cmd.ucd_calib_cfg.once.start = IWL_CALIB_INIT_CFG_ALL;
-	calib_cfg_cmd.ucd_calib_cfg.once.send_res = IWL_CALIB_INIT_CFG_ALL;
-	calib_cfg_cmd.ucd_calib_cfg.flags = IWL_CALIB_INIT_CFG_ALL;
-
-	return iwl_send_cmd(priv, &cmd);
-}
-
-static void iwl5000_rx_calib_result(struct iwl_priv *priv,
-			     struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
-	int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	int index;
-
-	/* reduce the size of the length field itself */
-	len -= 4;
-
-	/* Define the order in which the results will be sent to the runtime
-	 * uCode. iwl_send_calib_results sends them in a row according to their
-	 * index. We sort them here */
-	switch (hdr->op_code) {
-	case IWL_PHY_CALIBRATE_DC_CMD:
-		index = IWL_CALIB_DC;
-		break;
-	case IWL_PHY_CALIBRATE_LO_CMD:
-		index = IWL_CALIB_LO;
-		break;
-	case IWL_PHY_CALIBRATE_TX_IQ_CMD:
-		index = IWL_CALIB_TX_IQ;
-		break;
-	case IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD:
-		index = IWL_CALIB_TX_IQ_PERD;
-		break;
-	case IWL_PHY_CALIBRATE_BASE_BAND_CMD:
-		index = IWL_CALIB_BASE_BAND;
-		break;
-	default:
-		IWL_ERR(priv, "Unknown calibration notification %d\n",
-			  hdr->op_code);
-		return;
-	}
-	iwl_calib_set(&priv->calib_results[index], pkt->u.raw, len);
-}
-
-static void iwl5000_rx_calib_complete(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb)
-{
-	IWL_DEBUG_INFO(priv, "Init. calibration is completed, restarting fw.\n");
-	queue_work(priv->workqueue, &priv->restart);
-}
-
-void iwl5000_init_alive_start(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	/* Check alive response for "valid" sign from uCode */
-	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
-		/* We had an error bringing up the hardware, so take it
-		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO(priv, "Initialize Alive failed.\n");
-		goto restart;
-	}
-
-	/* initialize uCode was loaded... verify inst image.
-	 * This is a paranoid check, because we would not have gotten the
-	 * "initialize" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv)) {
-		/* Runtime instruction load was bad;
-		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO(priv, "Bad \"initialize\" uCode load.\n");
-		goto restart;
-	}
-
-	ret = priv->cfg->ops->lib->alive_notify(priv);
-	if (ret) {
-		IWL_WARN(priv,
-			"Could not complete ALIVE transition: %d\n", ret);
-		goto restart;
-	}
-
-	iwl5000_send_calib_cfg(priv);
-	return;
-
-restart:
-	/* real restart (first load init_ucode) */
-	queue_work(priv->workqueue, &priv->restart);
-}
-
-int iwl5000_alive_notify(struct iwl_priv *priv)
-{
-	u32 a;
-	unsigned long flags;
-	int i, chan;
-	u32 reg_val;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	priv->scd_base_addr = iwl_read_prph(priv, IWL50_SCD_SRAM_BASE_ADDR);
-	a = priv->scd_base_addr + IWL50_SCD_CONTEXT_DATA_OFFSET;
-	for (; a < priv->scd_base_addr + IWL50_SCD_TX_STTS_BITMAP_OFFSET;
-		a += 4)
-		iwl_write_targ_mem(priv, a, 0);
-	for (; a < priv->scd_base_addr + IWL50_SCD_TRANSLATE_TBL_OFFSET;
-		a += 4)
-		iwl_write_targ_mem(priv, a, 0);
-	for (; a < priv->scd_base_addr +
-	       IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
-		iwl_write_targ_mem(priv, a, 0);
-
-	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
-		       priv->scd_bc_tbls.dma >> 10);
-
-	/* Enable DMA channel */
-	for (chan = 0; chan < FH50_TCSR_CHNL_NUM ; chan++)
-		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
-
-	/* Update FH chicken bits */
-	reg_val = iwl_read_direct32(priv, FH_TX_CHICKEN_BITS_REG);
-	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
-			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
-
-	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
-		IWL50_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
-	iwl_write_prph(priv, IWL50_SCD_AGGR_SEL, 0);
-
-	/* initiate the queues */
-	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
-		iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(i), 0);
-		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
-		iwl_write_targ_mem(priv, priv->scd_base_addr +
-				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i), 0);
-		iwl_write_targ_mem(priv, priv->scd_base_addr +
-				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i) +
-				sizeof(u32),
-				((SCD_WIN_SIZE <<
-				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-				((SCD_FRAME_LIMIT <<
-				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-	}
-
-	iwl_write_prph(priv, IWL50_SCD_INTERRUPT_MASK,
-			IWL_MASK(0, priv->hw_params.max_txq_num));
-
-	/* Activate all Tx DMA/FIFO channels */
-	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
-
-	iwlagn_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
-
-	/* make sure all queue are not stopped */
-	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
-	for (i = 0; i < 4; i++)
-		atomic_set(&priv->queue_stop_count[i], 0);
-
-	/* reset to 0 to enable all the queue first */
-	priv->txq_ctx_active_msk = 0;
-	/* map qos queues to fifos one-to-one */
-	BUILD_BUG_ON(ARRAY_SIZE(iwl5000_default_queue_to_tx_fifo) != 10);
-
-	for (i = 0; i < ARRAY_SIZE(iwl5000_default_queue_to_tx_fifo); i++) {
-		int ac = iwl5000_default_queue_to_tx_fifo[i];
-
-		iwl_txq_ctx_activate(priv, i);
-
-		if (ac == IWL_TX_FIFO_UNUSED)
-			continue;
-
-		iwlagn_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
-	}
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	iwl_send_wimax_coex(priv);
-
-	iwl5000_set_Xtal_calib(priv);
-	iwl_send_calib_results(priv);
-
-	return 0;
-}
-
 int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
@@ -733,9 +506,9 @@ void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* init calibration handlers */
 	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
-					iwl5000_rx_calib_result;
+					iwlagn_rx_calib_result;
 	priv->rx_handlers[CALIBRATION_COMPLETE_NOTIFICATION] =
-					iwl5000_rx_calib_complete;
+					iwlagn_rx_calib_complete;
 	priv->rx_handlers[REPLY_TX] = iwl5000_rx_reply_tx;
 }
 
@@ -851,8 +624,8 @@ struct iwl_lib_ops iwl5000_lib = {
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
 	.load_ucode = iwlagn_load_ucode,
-	.init_alive_start = iwl5000_init_alive_start,
-	.alive_notify = iwl5000_alive_notify,
+	.init_alive_start = iwlagn_init_alive_start,
+	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
@@ -908,8 +681,8 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.load_ucode = iwlagn_load_ucode,
-	.init_alive_start = iwl5000_init_alive_start,
-	.alive_notify = iwl5000_alive_notify,
+	.init_alive_start = iwlagn_init_alive_start,
+	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 2bbff18..96f4fa6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -242,8 +242,8 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwl5000_init_alive_start,
-	.alive_notify = iwl5000_alive_notify,
+	.init_alive_start = iwlagn_init_alive_start,
+	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
@@ -309,8 +309,8 @@ static struct iwl_lib_ops iwl6050_lib = {
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwl5000_init_alive_start,
-	.alive_notify = iwl5000_alive_notify,
+	.init_alive_start = iwlagn_init_alive_start,
+	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index f0af388..52ae157 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -35,7 +35,22 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
+#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
+#include "iwl-agn.h"
+
+static const s8 iwlagn_default_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+	IWLAGN_CMD_FIFO_NUM,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
+};
 
 /*
  * ucode
@@ -184,3 +199,218 @@ struct iwl_ucode_ops iwlagn_ucode = {
 	.get_boot_size = iwlagn_ucode_get_boot_size,
 	.get_data = iwlagn_ucode_get_data,
 };
+
+/*
+ *  Calibration
+ */
+static int iwlagn_set_Xtal_calib(struct iwl_priv *priv)
+{
+	struct iwl_calib_xtal_freq_cmd cmd;
+	__le16 *xtal_calib =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
+
+	cmd.hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
+	cmd.hdr.first_group = 0;
+	cmd.hdr.groups_num = 1;
+	cmd.hdr.data_valid = 1;
+	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
+	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
+	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
+			     (u8 *)&cmd, sizeof(cmd));
+}
+
+static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
+{
+	struct iwl_calib_cfg_cmd calib_cfg_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = CALIBRATION_CFG_CMD,
+		.len = sizeof(struct iwl_calib_cfg_cmd),
+		.data = &calib_cfg_cmd,
+	};
+
+	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
+	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.once.start = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.once.send_res = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.flags = IWL_CALIB_INIT_CFG_ALL;
+
+	return iwl_send_cmd(priv, &cmd);
+}
+
+void iwlagn_rx_calib_result(struct iwl_priv *priv,
+			     struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
+	int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	int index;
+
+	/* reduce the size of the length field itself */
+	len -= 4;
+
+	/* Define the order in which the results will be sent to the runtime
+	 * uCode. iwl_send_calib_results sends them in a row according to
+	 * their index. We sort them here
+	 */
+	switch (hdr->op_code) {
+	case IWL_PHY_CALIBRATE_DC_CMD:
+		index = IWL_CALIB_DC;
+		break;
+	case IWL_PHY_CALIBRATE_LO_CMD:
+		index = IWL_CALIB_LO;
+		break;
+	case IWL_PHY_CALIBRATE_TX_IQ_CMD:
+		index = IWL_CALIB_TX_IQ;
+		break;
+	case IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD:
+		index = IWL_CALIB_TX_IQ_PERD;
+		break;
+	case IWL_PHY_CALIBRATE_BASE_BAND_CMD:
+		index = IWL_CALIB_BASE_BAND;
+		break;
+	default:
+		IWL_ERR(priv, "Unknown calibration notification %d\n",
+			  hdr->op_code);
+		return;
+	}
+	iwl_calib_set(&priv->calib_results[index], pkt->u.raw, len);
+}
+
+void iwlagn_rx_calib_complete(struct iwl_priv *priv,
+			       struct iwl_rx_mem_buffer *rxb)
+{
+	IWL_DEBUG_INFO(priv, "Init. calibration is completed, restarting fw.\n");
+	queue_work(priv->workqueue, &priv->restart);
+}
+
+void iwlagn_init_alive_start(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	/* Check alive response for "valid" sign from uCode */
+	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
+		/* We had an error bringing up the hardware, so take it
+		 * all the way back down so we can try again */
+		IWL_DEBUG_INFO(priv, "Initialize Alive failed.\n");
+		goto restart;
+	}
+
+	/* initialize uCode was loaded... verify inst image.
+	 * This is a paranoid check, because we would not have gotten the
+	 * "initialize" alive if code weren't properly loaded.  */
+	if (iwl_verify_ucode(priv)) {
+		/* Runtime instruction load was bad;
+		 * take it all the way back down so we can try again */
+		IWL_DEBUG_INFO(priv, "Bad \"initialize\" uCode load.\n");
+		goto restart;
+	}
+
+	ret = priv->cfg->ops->lib->alive_notify(priv);
+	if (ret) {
+		IWL_WARN(priv,
+			"Could not complete ALIVE transition: %d\n", ret);
+		goto restart;
+	}
+
+	iwlagn_send_calib_cfg(priv);
+	return;
+
+restart:
+	/* real restart (first load init_ucode) */
+	queue_work(priv->workqueue, &priv->restart);
+}
+
+int iwlagn_alive_notify(struct iwl_priv *priv)
+{
+	u32 a;
+	unsigned long flags;
+	int i, chan;
+	u32 reg_val;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	priv->scd_base_addr = iwl_read_prph(priv, IWL50_SCD_SRAM_BASE_ADDR);
+	a = priv->scd_base_addr + IWL50_SCD_CONTEXT_DATA_OFFSET;
+	for (; a < priv->scd_base_addr + IWL50_SCD_TX_STTS_BITMAP_OFFSET;
+		a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+	for (; a < priv->scd_base_addr + IWL50_SCD_TRANSLATE_TBL_OFFSET;
+		a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+	for (; a < priv->scd_base_addr +
+	       IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+
+	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
+		       priv->scd_bc_tbls.dma >> 10);
+
+	/* Enable DMA channel */
+	for (chan = 0; chan < FH50_TCSR_CHNL_NUM ; chan++)
+		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+
+	/* Update FH chicken bits */
+	reg_val = iwl_read_direct32(priv, FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
+			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+
+	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
+		IWL50_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
+	iwl_write_prph(priv, IWL50_SCD_AGGR_SEL, 0);
+
+	/* initiate the queues */
+	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
+		iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
+				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i), 0);
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
+				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i) +
+				sizeof(u32),
+				((SCD_WIN_SIZE <<
+				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+				((SCD_FRAME_LIMIT <<
+				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+	}
+
+	iwl_write_prph(priv, IWL50_SCD_INTERRUPT_MASK,
+			IWL_MASK(0, priv->hw_params.max_txq_num));
+
+	/* Activate all Tx DMA/FIFO channels */
+	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
+
+	iwlagn_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
+
+	/* make sure all queue are not stopped */
+	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
+	for (i = 0; i < 4; i++)
+		atomic_set(&priv->queue_stop_count[i], 0);
+
+	/* reset to 0 to enable all the queue first */
+	priv->txq_ctx_active_msk = 0;
+	/* map qos queues to fifos one-to-one */
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) != 10);
+
+	for (i = 0; i < ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo); i++) {
+		int ac = iwlagn_default_queue_to_tx_fifo[i];
+
+		iwl_txq_ctx_activate(priv, i);
+
+		if (ac == IWL_TX_FIFO_UNUSED)
+			continue;
+
+		iwlagn_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_send_wimax_coex(priv);
+
+	iwlagn_set_Xtal_calib(priv);
+	iwl_send_calib_results(priv);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2ff7b8f..9b66765 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -77,9 +77,6 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 bool iwl_good_ack_health(struct iwl_priv *priv,
 			 struct iwl_rx_packet *pkt);
 
-/* uCode */
-int iwlagn_load_ucode(struct iwl_priv *priv);
-
 /* tx queue */
 void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
 		     int txq_id, u32 index);
@@ -97,4 +94,13 @@ int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 			   u16 ssn_idx, u8 tx_fifo);
 void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
 
+/* uCode */
+int iwlagn_load_ucode(struct iwl_priv *priv);
+void iwlagn_rx_calib_result(struct iwl_priv *priv,
+			 struct iwl_rx_mem_buffer *rxb);
+void iwlagn_rx_calib_complete(struct iwl_priv *priv,
+			   struct iwl_rx_mem_buffer *rxb);
+void iwlagn_init_alive_start(struct iwl_priv *priv);
+int iwlagn_alive_notify(struct iwl_priv *priv);
+
 #endif /* __iwl_agn_h__ */
-- 
1.6.3.3

