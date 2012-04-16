Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab2DPWBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/16] iwlwifi: remove get_cmd_string
Date: Mon, 16 Apr 2012 14:57:10 -0700
Message-Id: <1334613430-30720-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000204_787164_E92B639C)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The command strings are needed through the layers for
debug and error messages, but can differ with opmode.
As a result, we need to give the command names to the
transport layer as configuration.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |  175 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   10 ++
 drivers/net/wireless/iwlwifi/iwl-core.c           |    4 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    4 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    9 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   38 +++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    6 +
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    3 +
 12 files changed, 144 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8e83fb8..4e0c248 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1242,7 +1242,7 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
 		IWL_ERR(priv, "Command %s failed: FW Error\n",
-			get_cmd_string(cmd->id));
+			iwl_dvm_get_cmd_string(cmd->id));
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 93a6871..db6c90f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -40,89 +40,86 @@
 #include "iwl-agn.h"
 #include "iwl-shared.h"
 
-const char *get_cmd_string(u8 cmd)
-{
-	switch (cmd) {
-		IWL_CMD(REPLY_ALIVE);
-		IWL_CMD(REPLY_ERROR);
-		IWL_CMD(REPLY_ECHO);
-		IWL_CMD(REPLY_RXON);
-		IWL_CMD(REPLY_RXON_ASSOC);
-		IWL_CMD(REPLY_QOS_PARAM);
-		IWL_CMD(REPLY_RXON_TIMING);
-		IWL_CMD(REPLY_ADD_STA);
-		IWL_CMD(REPLY_REMOVE_STA);
-		IWL_CMD(REPLY_REMOVE_ALL_STA);
-		IWL_CMD(REPLY_TXFIFO_FLUSH);
-		IWL_CMD(REPLY_WEPKEY);
-		IWL_CMD(REPLY_TX);
-		IWL_CMD(REPLY_LEDS_CMD);
-		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
-		IWL_CMD(COEX_PRIORITY_TABLE_CMD);
-		IWL_CMD(COEX_MEDIUM_NOTIFICATION);
-		IWL_CMD(COEX_EVENT_CMD);
-		IWL_CMD(REPLY_QUIET_CMD);
-		IWL_CMD(REPLY_CHANNEL_SWITCH);
-		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
-		IWL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
-		IWL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
-		IWL_CMD(POWER_TABLE_CMD);
-		IWL_CMD(PM_SLEEP_NOTIFICATION);
-		IWL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
-		IWL_CMD(REPLY_SCAN_CMD);
-		IWL_CMD(REPLY_SCAN_ABORT_CMD);
-		IWL_CMD(SCAN_START_NOTIFICATION);
-		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
-		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
-		IWL_CMD(BEACON_NOTIFICATION);
-		IWL_CMD(REPLY_TX_BEACON);
-		IWL_CMD(WHO_IS_AWAKE_NOTIFICATION);
-		IWL_CMD(QUIET_NOTIFICATION);
-		IWL_CMD(REPLY_TX_PWR_TABLE_CMD);
-		IWL_CMD(MEASURE_ABORT_NOTIFICATION);
-		IWL_CMD(REPLY_BT_CONFIG);
-		IWL_CMD(REPLY_STATISTICS_CMD);
-		IWL_CMD(STATISTICS_NOTIFICATION);
-		IWL_CMD(REPLY_CARD_STATE_CMD);
-		IWL_CMD(CARD_STATE_NOTIFICATION);
-		IWL_CMD(MISSED_BEACONS_NOTIFICATION);
-		IWL_CMD(REPLY_CT_KILL_CONFIG_CMD);
-		IWL_CMD(SENSITIVITY_CMD);
-		IWL_CMD(REPLY_PHY_CALIBRATION_CMD);
-		IWL_CMD(REPLY_RX_PHY_CMD);
-		IWL_CMD(REPLY_RX_MPDU_CMD);
-		IWL_CMD(REPLY_RX);
-		IWL_CMD(REPLY_COMPRESSED_BA);
-		IWL_CMD(CALIBRATION_CFG_CMD);
-		IWL_CMD(CALIBRATION_RES_NOTIFICATION);
-		IWL_CMD(CALIBRATION_COMPLETE_NOTIFICATION);
-		IWL_CMD(REPLY_TX_POWER_DBM_CMD);
-		IWL_CMD(TEMPERATURE_NOTIFICATION);
-		IWL_CMD(TX_ANT_CONFIGURATION_CMD);
-		IWL_CMD(REPLY_BT_COEX_PROFILE_NOTIF);
-		IWL_CMD(REPLY_BT_COEX_PRIO_TABLE);
-		IWL_CMD(REPLY_BT_COEX_PROT_ENV);
-		IWL_CMD(REPLY_WIPAN_PARAMS);
-		IWL_CMD(REPLY_WIPAN_RXON);
-		IWL_CMD(REPLY_WIPAN_RXON_TIMING);
-		IWL_CMD(REPLY_WIPAN_RXON_ASSOC);
-		IWL_CMD(REPLY_WIPAN_QOS_PARAM);
-		IWL_CMD(REPLY_WIPAN_WEPKEY);
-		IWL_CMD(REPLY_WIPAN_P2P_CHANNEL_SWITCH);
-		IWL_CMD(REPLY_WIPAN_NOA_NOTIFICATION);
-		IWL_CMD(REPLY_WIPAN_DEACTIVATION_COMPLETE);
-		IWL_CMD(REPLY_WOWLAN_PATTERNS);
-		IWL_CMD(REPLY_WOWLAN_WAKEUP_FILTER);
-		IWL_CMD(REPLY_WOWLAN_TSC_RSC_PARAMS);
-		IWL_CMD(REPLY_WOWLAN_TKIP_PARAMS);
-		IWL_CMD(REPLY_WOWLAN_KEK_KCK_MATERIAL);
-		IWL_CMD(REPLY_WOWLAN_GET_STATUS);
-		IWL_CMD(REPLY_D3_CONFIG);
-	default:
-		return "UNKNOWN";
-
-	}
-}
+#define IWL_CMD_ENTRY(x) [x] = #x
+
+const char *iwl_dvm_cmd_strings[REPLY_MAX] = {
+	IWL_CMD_ENTRY(REPLY_ALIVE),
+	IWL_CMD_ENTRY(REPLY_ERROR),
+	IWL_CMD_ENTRY(REPLY_ECHO),
+	IWL_CMD_ENTRY(REPLY_RXON),
+	IWL_CMD_ENTRY(REPLY_RXON_ASSOC),
+	IWL_CMD_ENTRY(REPLY_QOS_PARAM),
+	IWL_CMD_ENTRY(REPLY_RXON_TIMING),
+	IWL_CMD_ENTRY(REPLY_ADD_STA),
+	IWL_CMD_ENTRY(REPLY_REMOVE_STA),
+	IWL_CMD_ENTRY(REPLY_REMOVE_ALL_STA),
+	IWL_CMD_ENTRY(REPLY_TXFIFO_FLUSH),
+	IWL_CMD_ENTRY(REPLY_WEPKEY),
+	IWL_CMD_ENTRY(REPLY_TX),
+	IWL_CMD_ENTRY(REPLY_LEDS_CMD),
+	IWL_CMD_ENTRY(REPLY_TX_LINK_QUALITY_CMD),
+	IWL_CMD_ENTRY(COEX_PRIORITY_TABLE_CMD),
+	IWL_CMD_ENTRY(COEX_MEDIUM_NOTIFICATION),
+	IWL_CMD_ENTRY(COEX_EVENT_CMD),
+	IWL_CMD_ENTRY(REPLY_QUIET_CMD),
+	IWL_CMD_ENTRY(REPLY_CHANNEL_SWITCH),
+	IWL_CMD_ENTRY(CHANNEL_SWITCH_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_SPECTRUM_MEASUREMENT_CMD),
+	IWL_CMD_ENTRY(SPECTRUM_MEASURE_NOTIFICATION),
+	IWL_CMD_ENTRY(POWER_TABLE_CMD),
+	IWL_CMD_ENTRY(PM_SLEEP_NOTIFICATION),
+	IWL_CMD_ENTRY(PM_DEBUG_STATISTIC_NOTIFIC),
+	IWL_CMD_ENTRY(REPLY_SCAN_CMD),
+	IWL_CMD_ENTRY(REPLY_SCAN_ABORT_CMD),
+	IWL_CMD_ENTRY(SCAN_START_NOTIFICATION),
+	IWL_CMD_ENTRY(SCAN_RESULTS_NOTIFICATION),
+	IWL_CMD_ENTRY(SCAN_COMPLETE_NOTIFICATION),
+	IWL_CMD_ENTRY(BEACON_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_TX_BEACON),
+	IWL_CMD_ENTRY(WHO_IS_AWAKE_NOTIFICATION),
+	IWL_CMD_ENTRY(QUIET_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_TX_PWR_TABLE_CMD),
+	IWL_CMD_ENTRY(MEASURE_ABORT_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_BT_CONFIG),
+	IWL_CMD_ENTRY(REPLY_STATISTICS_CMD),
+	IWL_CMD_ENTRY(STATISTICS_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_CARD_STATE_CMD),
+	IWL_CMD_ENTRY(CARD_STATE_NOTIFICATION),
+	IWL_CMD_ENTRY(MISSED_BEACONS_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_CT_KILL_CONFIG_CMD),
+	IWL_CMD_ENTRY(SENSITIVITY_CMD),
+	IWL_CMD_ENTRY(REPLY_PHY_CALIBRATION_CMD),
+	IWL_CMD_ENTRY(REPLY_RX_PHY_CMD),
+	IWL_CMD_ENTRY(REPLY_RX_MPDU_CMD),
+	IWL_CMD_ENTRY(REPLY_RX),
+	IWL_CMD_ENTRY(REPLY_COMPRESSED_BA),
+	IWL_CMD_ENTRY(CALIBRATION_CFG_CMD),
+	IWL_CMD_ENTRY(CALIBRATION_RES_NOTIFICATION),
+	IWL_CMD_ENTRY(CALIBRATION_COMPLETE_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_TX_POWER_DBM_CMD),
+	IWL_CMD_ENTRY(TEMPERATURE_NOTIFICATION),
+	IWL_CMD_ENTRY(TX_ANT_CONFIGURATION_CMD),
+	IWL_CMD_ENTRY(REPLY_BT_COEX_PROFILE_NOTIF),
+	IWL_CMD_ENTRY(REPLY_BT_COEX_PRIO_TABLE),
+	IWL_CMD_ENTRY(REPLY_BT_COEX_PROT_ENV),
+	IWL_CMD_ENTRY(REPLY_WIPAN_PARAMS),
+	IWL_CMD_ENTRY(REPLY_WIPAN_RXON),
+	IWL_CMD_ENTRY(REPLY_WIPAN_RXON_TIMING),
+	IWL_CMD_ENTRY(REPLY_WIPAN_RXON_ASSOC),
+	IWL_CMD_ENTRY(REPLY_WIPAN_QOS_PARAM),
+	IWL_CMD_ENTRY(REPLY_WIPAN_WEPKEY),
+	IWL_CMD_ENTRY(REPLY_WIPAN_P2P_CHANNEL_SWITCH),
+	IWL_CMD_ENTRY(REPLY_WIPAN_NOA_NOTIFICATION),
+	IWL_CMD_ENTRY(REPLY_WIPAN_DEACTIVATION_COMPLETE),
+	IWL_CMD_ENTRY(REPLY_WOWLAN_PATTERNS),
+	IWL_CMD_ENTRY(REPLY_WOWLAN_WAKEUP_FILTER),
+	IWL_CMD_ENTRY(REPLY_WOWLAN_TSC_RSC_PARAMS),
+	IWL_CMD_ENTRY(REPLY_WOWLAN_TKIP_PARAMS),
+	IWL_CMD_ENTRY(REPLY_WOWLAN_KEK_KCK_MATERIAL),
+	IWL_CMD_ENTRY(REPLY_WOWLAN_GET_STATUS),
+	IWL_CMD_ENTRY(REPLY_D3_CONFIG),
+};
+#undef IWL_CMD_ENTRY
 
 /******************************************************************************
  *
@@ -137,10 +134,9 @@ static int iwlagn_rx_reply_error(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_error_resp *err_resp = (void *)pkt->data;
 
-	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
+	IWL_ERR(priv, "Error Reply type 0x%08X cmd REPLY_ERROR (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
 		le32_to_cpu(err_resp->error_type),
-		get_cmd_string(err_resp->cmd_id),
 		err_resp->cmd_id,
 		le16_to_cpu(err_resp->bad_cmd_seq_num),
 		le32_to_cpu(err_resp->error_info));
@@ -216,8 +212,7 @@ static int iwlagn_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	u32 __maybe_unused len =
 		le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
-			"notification for %s:\n", len,
-			get_cmd_string(pkt->hdr.cmd));
+			"notification for PM_DEBUG_STATISTIC_NOTIFIC:\n", len);
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->data, len);
 	return 0;
 }
@@ -1152,9 +1147,9 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 			err = priv->rx_handlers[pkt->hdr.cmd] (priv, rxb, cmd);
 		} else {
 			/* No handling needed */
-			IWL_DEBUG_RX(priv,
-				"No handler needed for %s, 0x%02x\n",
-				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+			IWL_DEBUG_RX(priv, "No handler needed for %s, 0x%02x\n",
+				     iwl_dvm_get_cmd_string(pkt->hdr.cmd),
+				     pkt->hdr.cmd);
 		}
 	}
 	return err;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bc585a6..7db3986 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1560,6 +1560,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 			cfg(priv)->base_params->wd_timeout;
 	else
 		trans_cfg.queue_watchdog_timeout = IWL_WATCHHDOG_DISABLED;
+	trans_cfg.command_names = iwl_dvm_cmd_strings;
 
 	ucode_flags = fw->ucode_capa.flags;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a321b65..20100c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -495,6 +495,16 @@ do {									\
 } while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
+extern const char *iwl_dvm_cmd_strings[REPLY_MAX];
+
+static inline const char *iwl_dvm_get_cmd_string(u8 cmd)
+{
+	const char *s = iwl_dvm_cmd_strings[cmd];
+	if (s)
+		return s;
+	return "UNKNOWN";
+}
+
 /* API method exported for mvm hybrid state */
 void iwl_setup_deferred_work(struct iwl_priv *priv);
 int iwl_send_wimax_coex(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 94a4ebc..d7a8cde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -140,6 +140,7 @@ void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 
 const char *get_mgmt_string(int cmd)
 {
+#define IWL_CMD(x) case x: return #x
 	switch (cmd) {
 		IWL_CMD(MANAGEMENT_ASSOC_REQ);
 		IWL_CMD(MANAGEMENT_ASSOC_RESP);
@@ -157,10 +158,12 @@ const char *get_mgmt_string(int cmd)
 		return "UNKNOWN";
 
 	}
+#undef IWL_CMD
 }
 
 const char *get_ctrl_string(int cmd)
 {
+#define IWL_CMD(x) case x: return #x
 	switch (cmd) {
 		IWL_CMD(CONTROL_BACK_REQ);
 		IWL_CMD(CONTROL_BACK);
@@ -174,6 +177,7 @@ const char *get_ctrl_string(int cmd)
 		return "UNKNOWN";
 
 	}
+#undef IWL_CMD
 }
 
 void iwl_clear_traffic_stats(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 4d1f1dd..32834a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -575,7 +575,7 @@ static ssize_t iwl_dbgfs_rx_handlers_read(struct file *file,
 		if (priv->rx_handlers_stats[cnt] > 0)
 			pos += scnprintf(buf + pos, bufsz - pos,
 				"\tRx handler[%36s]:\t\t %u\n",
-				get_cmd_string(cnt),
+				iwl_dvm_get_cmd_string(cnt),
 				priv->rx_handlers_stats[cnt]);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 82b52da..35bd83c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -181,8 +181,4 @@ enum iwl_rxon_context_id {
 	NUM_IWL_RXON_CTX
 };
 
-const char *get_cmd_string(u8 cmd);
-
-#define IWL_CMD(x) case x: return #x
-
 #endif /* #__iwl_shared_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index f98eff3..70bdd0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -273,6 +273,7 @@ struct iwl_trans_pcie {
 	bool rx_buf_size_8k;
 	u32 rx_page_order;
 
+	const char **command_names;
 
 	/* queue watchdog */
 	unsigned long wd_timeout;
@@ -417,4 +418,12 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
 	return index & (q->n_window - 1);
 }
 
+static inline const char *
+trans_pcie_get_cmd_string(struct iwl_trans_pcie *trans_pcie, u8 cmd)
+{
+	if (!trans_pcie->command_names || !trans_pcie->command_names[cmd])
+		return "UNKNOWN";
+	return trans_pcie->command_names[cmd];
+}
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index bf83806..de78fb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -393,8 +393,9 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 			break;
 
 		IWL_DEBUG_RX(trans, "cmd at offset %d: %s (0x%.2x)\n",
-			     rxcb._offset, get_cmd_string(pkt->hdr.cmd),
-			     pkt->hdr.cmd);
+			rxcb._offset,
+			trans_pcie_get_cmd_string(trans_pcie, pkt->hdr.cmd),
+			pkt->hdr.cmd);
 
 		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 21b7ca2..9188740 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -605,12 +605,11 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		cmd_dest += cmd->len[i];
 	}
 
-	IWL_DEBUG_HC(trans, "Sending command %s (#%x), seq: 0x%04X, "
-			"%d bytes at %d[%d]:%d\n",
-			get_cmd_string(out_cmd->hdr.cmd),
-			out_cmd->hdr.cmd,
-			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
-			q->write_ptr, idx, trans_pcie->cmd_queue);
+	IWL_DEBUG_HC(trans,
+		"Sending command %s (#%x), seq: 0x%04X, %d bytes at %d[%d]:%d\n",
+		trans_pcie_get_cmd_string(trans_pcie, out_cmd->hdr.cmd),
+		out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
+		q->write_ptr, idx, trans_pcie->cmd_queue);
 
 	phys_addr = dma_map_single(trans->dev, &out_cmd->hdr, copy_size,
 				DMA_BIDIRECTIONAL);
@@ -795,11 +794,13 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 		if (!test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status)) {
 			IWL_WARN(trans,
 				 "HCMD_ACTIVE already clear for command %s\n",
-				 get_cmd_string(cmd->hdr.cmd));
+				 trans_pcie_get_cmd_string(trans_pcie,
+							   cmd->hdr.cmd));
 		}
 		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
-			       get_cmd_string(cmd->hdr.cmd));
+			       trans_pcie_get_cmd_string(trans_pcie,
+							 cmd->hdr.cmd));
 		wake_up(&trans->wait_command_queue);
 	}
 
@@ -812,6 +813,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 
 static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 
 	/* An asynchronous command can not expect an SKB to be set. */
@@ -823,7 +825,7 @@ static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	if (ret < 0) {
 		IWL_ERR(trans,
 			"Error sending %s: enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
+			trans_pcie_get_cmd_string(trans_pcie, cmd->id), ret);
 		return ret;
 	}
 	return 0;
@@ -836,17 +838,17 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	int ret;
 
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
-			get_cmd_string(cmd->id));
+		       trans_pcie_get_cmd_string(trans_pcie, cmd->id));
 
 	if (WARN_ON(test_and_set_bit(STATUS_HCMD_ACTIVE,
 				     &trans_pcie->status))) {
 		IWL_ERR(trans, "Command %s: a command is already active!\n",
-			get_cmd_string(cmd->id));
+			trans_pcie_get_cmd_string(trans_pcie, cmd->id));
 		return -EIO;
 	}
 
 	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
-			get_cmd_string(cmd->id));
+		       trans_pcie_get_cmd_string(trans_pcie, cmd->id));
 
 	cmd_idx = iwl_enqueue_hcmd(trans, cmd);
 	if (cmd_idx < 0) {
@@ -854,7 +856,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 		IWL_ERR(trans,
 			"Error sending %s: enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
+			trans_pcie_get_cmd_string(trans_pcie, cmd->id), ret);
 		return ret;
 	}
 
@@ -869,7 +871,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 			IWL_ERR(trans,
 				"Error sending %s: time out after %dms.\n",
-				get_cmd_string(cmd->id),
+				trans_pcie_get_cmd_string(trans_pcie, cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
 			IWL_ERR(trans,
@@ -877,8 +879,10 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 				q->read_ptr, q->write_ptr);
 
 			clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
-			IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command"
-				 "%s\n", get_cmd_string(cmd->id));
+			IWL_DEBUG_INFO(trans,
+				       "Clearing HCMD_ACTIVE for command %s\n",
+				       trans_pcie_get_cmd_string(trans_pcie,
+								 cmd->id));
 			ret = -ETIMEDOUT;
 			goto cancel;
 		}
@@ -886,7 +890,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 	if ((cmd->flags & CMD_WANT_SKB) && !cmd->resp_pkt) {
 		IWL_ERR(trans, "Error: Response NULL in '%s'\n",
-			  get_cmd_string(cmd->id));
+			trans_pcie_get_cmd_string(trans_pcie, cmd->id));
 		ret = -EIO;
 		goto cancel;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 333a278..14a32c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1544,6 +1544,8 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 
 	trans_pcie->wd_timeout =
 		msecs_to_jiffies(trans_cfg->queue_watchdog_timeout);
+
+	trans_pcie->command_names = trans_cfg->command_names;
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
@@ -1635,6 +1637,7 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 
 static const char *get_fh_string(int cmd)
 {
+#define IWL_CMD(x) case x: return #x
 	switch (cmd) {
 	IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
 	IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
@@ -1648,6 +1651,7 @@ static const char *get_fh_string(int cmd)
 	default:
 		return "UNKNOWN";
 	}
+#undef IWL_CMD
 }
 
 int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
@@ -1696,6 +1700,7 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
 
 static const char *get_csr_string(int cmd)
 {
+#define IWL_CMD(x) case x: return #x
 	switch (cmd) {
 	IWL_CMD(CSR_HW_IF_CONFIG_REG);
 	IWL_CMD(CSR_INT_COALESCING);
@@ -1723,6 +1728,7 @@ static const char *get_csr_string(int cmd)
 	default:
 		return "UNKNOWN";
 	}
+#undef IWL_CMD
 }
 
 void iwl_dump_csr(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index d0888cc..f3496a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -309,6 +309,8 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  *	if unset 4k will be the RX buffer size
  * @queue_watchdog_timeout: time (in ms) after which queues
  *	are considered stuck and will trigger device restart
+ * @command_names: array of command names, must be 256 entries
+ *	(one for each command); for debugging only
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
@@ -321,6 +323,7 @@ struct iwl_trans_config {
 
 	bool rx_buf_size_8k;
 	unsigned int queue_watchdog_timeout;
+	const char **command_names;
 };
 
 /**
-- 
1.7.0.4

