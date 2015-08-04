Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbbHDU7H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Aviya Erenfeld <aviya.erenfeld@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/37] iwlwifi: add wide firmware command infrastructure for TX
Date: Tue,  4 Aug 2015 23:43:10 +0300
Message-Id: <1438721007-23283-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225924_809220_3D375DFC)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

As the firmware is slowly running out of command IDs and grouping of
commands is desirable anyway, the firmware is extending the command
header from 4 bytes to 8 bytes to introduce a group (in place of the
former flags field, since that's always 0 on commands and thus can
be easily used to distinguish between the two.

In order to support this most easily in the driver widen the command
command ID used in the command sending functions and encode the new
values (group and version) in the ID. That way existing code doesn't
have to be changed (since the higher bits are 0 automatically) and
newer code can easily use the new ID generation function to create a
value to use in place of just the command ID.

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 .../net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h    | 14 +++--
 drivers/net/wireless/iwlwifi/iwl-fw-file.h         |  2 +
 drivers/net/wireless/iwlwifi/iwl-trans.h           | 66 ++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |  4 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c             |  2 +
 drivers/net/wireless/iwlwifi/mvm/utils.c           |  4 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h       |  2 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  1 +
 drivers/net/wireless/iwlwifi/pcie/tx.c             | 53 ++++++++++++-----
 9 files changed, 121 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h b/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
index 948ce08..eb4b99a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
@@ -36,7 +36,7 @@
 TRACE_EVENT(iwlwifi_dev_hcmd,
 	TP_PROTO(const struct device *dev,
 		 struct iwl_host_cmd *cmd, u16 total_size,
-		 struct iwl_cmd_header *hdr),
+		 struct iwl_cmd_header_wide *hdr),
 	TP_ARGS(dev, cmd, total_size, hdr),
 	TP_STRUCT__entry(
 		DEV_ENTRY
@@ -44,11 +44,14 @@ TRACE_EVENT(iwlwifi_dev_hcmd,
 		__field(u32, flags)
 	),
 	TP_fast_assign(
-		int i, offset = sizeof(*hdr);
+		int i, offset = sizeof(struct iwl_cmd_header);
+
+		if (hdr->group_id)
+			offset = sizeof(struct iwl_cmd_header_wide);
 
 		DEV_ASSIGN;
 		__entry->flags = cmd->flags;
-		memcpy(__get_dynamic_array(hcmd), hdr, sizeof(*hdr));
+		memcpy(__get_dynamic_array(hcmd), hdr, offset);
 
 		for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
 			if (!cmd->len[i])
@@ -58,8 +61,9 @@ TRACE_EVENT(iwlwifi_dev_hcmd,
 			offset += cmd->len[i];
 		}
 	),
-	TP_printk("[%s] hcmd %#.2x (%ssync)",
-		  __get_str(dev), ((u8 *)__get_dynamic_array(hcmd))[0],
+	TP_printk("[%s] hcmd %#.2x.%#.2x (%ssync)",
+		  __get_str(dev), ((u8 *)__get_dynamic_array(hcmd))[1],
+		  ((u8 *)__get_dynamic_array(hcmd))[0],
 		  __entry->flags & CMD_ASYNC ? "a" : "")
 );
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index c31cf82..f99ec4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -247,6 +247,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * IWL_UCODE_TLV_API_HDC_PHASE_0: ucode supports finer configuration of LTR
  * @IWL_UCODE_TLV_API_TX_POWER_DEV: new API for tx power.
+ * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
  * @IWL_UCODE_TLV_API_SCD_CFG: This firmware can configure the scheduler
  *	through the dedicated host command.
  * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
@@ -263,6 +264,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
 	IWL_UCODE_TLV_API_HDC_PHASE_0		= (__force iwl_ucode_tlv_api_t)10,
 	IWL_UCODE_TLV_API_TX_POWER_DEV		= (__force iwl_ucode_tlv_api_t)11,
+	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
 	IWL_UCODE_TLV_API_SCD_CFG		= (__force iwl_ucode_tlv_api_t)15,
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= (__force iwl_ucode_tlv_api_t)16,
 	IWL_UCODE_TLV_API_ASYNC_DTM		= (__force iwl_ucode_tlv_api_t)17,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 64769e4..df71aa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -122,6 +122,32 @@
 #define INDEX_TO_SEQ(i)	((i) & 0xff)
 #define SEQ_RX_FRAME	cpu_to_le16(0x8000)
 
+/*
+ * those functions retrieve specific information from
+ * the id field in the iwl_host_cmd struct which contains
+ * the command id, the group id and the version of the command
+ * and vice versa
+*/
+static inline u8 iwl_cmd_opcode(u32 cmdid)
+{
+	return cmdid & 0xFF;
+}
+
+static inline u8 iwl_cmd_groupid(u32 cmdid)
+{
+	return ((cmdid & 0xFF00) >> 8);
+}
+
+static inline u8 iwl_cmd_version(u32 cmdid)
+{
+	return ((cmdid & 0xFF0000) >> 16);
+}
+
+static inline u32 iwl_cmd_id(u8 opcode, u8 groupid, u8 version)
+{
+	return opcode + (groupid << 8) + (version << 16);
+}
+
 /**
  * struct iwl_cmd_header
  *
@@ -130,7 +156,7 @@
  */
 struct iwl_cmd_header {
 	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
-	u8 reserved;
+	u8 group_id;
 	/*
 	 * The driver sets up the sequence number to values of its choosing.
 	 * uCode does not use this value, but passes it back to the driver
@@ -154,6 +180,23 @@ struct iwl_cmd_header {
 	__le16 sequence;
 } __packed;
 
+/**
+ * struct iwl_cmd_header_wide
+ *
+ * This header format appears in the beginning of each command sent from the
+ * driver, and each response/notification received from uCode.
+ * this is the wide version that contains more information about the command
+ * like length, version and command type
+ */
+struct iwl_cmd_header_wide {
+	u8 cmd;
+	u8 group_id;
+	__le16 sequence;
+	__le16 length;
+	u8 reserved;
+	u8 version;
+} __packed;
+
 #define FH_RSCSR_FRAME_SIZE_MSK		0x00003FFF	/* bits 0-13 */
 #define FH_RSCSR_FRAME_INVALID		0x55550000
 #define FH_RSCSR_FRAME_ALIGN		0x40
@@ -218,8 +261,18 @@ enum CMD_MODE {
  * aren't fully copied and use other TFD space.
  */
 struct iwl_device_cmd {
-	struct iwl_cmd_header hdr;	/* uCode API */
-	u8 payload[DEF_CMD_PAYLOAD_SIZE];
+	union {
+		struct {
+			struct iwl_cmd_header hdr;	/* uCode API */
+			u8 payload[DEF_CMD_PAYLOAD_SIZE];
+		};
+		struct {
+			struct iwl_cmd_header_wide hdr_wide;
+			u8 payload_wide[DEF_CMD_PAYLOAD_SIZE -
+					sizeof(struct iwl_cmd_header_wide) +
+					sizeof(struct iwl_cmd_header)];
+		};
+	};
 } __packed;
 
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
@@ -260,7 +313,8 @@ enum iwl_hcmd_dataflag {
  * @flags: can be CMD_*
  * @len: array of the lengths of the chunks in data
  * @dataflags: IWL_HCMD_DFL_*
- * @id: id of the host command
+ * @id: command id of the host command, for wide commands encoding the
+ *	version and group as well
  */
 struct iwl_host_cmd {
 	const void *data[IWL_MAX_CMD_TBS_PER_TFD];
@@ -269,9 +323,9 @@ struct iwl_host_cmd {
 	u32 _rx_page_order;
 
 	u32 flags;
+	u32 id;
 	u16 len[IWL_MAX_CMD_TBS_PER_TFD];
 	u8 dataflags[IWL_MAX_CMD_TBS_PER_TFD];
-	u8 id;
 };
 
 static inline void iwl_free_resp(struct iwl_host_cmd *cmd)
@@ -372,6 +426,7 @@ enum iwl_trans_status {
  * @bc_table_dword: set to true if the BC table expects the byte count to be
  *	in DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
+ * @wide_cmd_header: firmware supports wide host command header
  * @command_names: array of command names, must be 256 entries
  *	(one for each command); for debugging only
  * @sdio_adma_addr: the default address to set for the ADMA in SDIO mode until
@@ -389,6 +444,7 @@ struct iwl_trans_config {
 	bool rx_buf_size_8k;
 	bool bc_table_dword;
 	bool scd_set_active;
+	bool wide_cmd_header;
 	const char *const *command_names;
 
 	u32 sdio_adma_addr;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c980e8d..d78af9f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -977,12 +977,12 @@ u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
 /* Tx / Host Commands */
 int __must_check iwl_mvm_send_cmd(struct iwl_mvm *mvm,
 				  struct iwl_host_cmd *cmd);
-int __must_check iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u8 id,
+int __must_check iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u32 id,
 				      u32 flags, u16 len, const void *data);
 int __must_check iwl_mvm_send_cmd_status(struct iwl_mvm *mvm,
 					 struct iwl_host_cmd *cmd,
 					 u32 *status);
-int __must_check iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u8 id,
+int __must_check iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id,
 					     u16 len, const void *data,
 					     u32 *status);
 int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 76b5557..c9b9c98 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -469,6 +469,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 	trans_cfg.rx_buf_size_8k = iwlwifi_mod_params.amsdu_size_8K;
+	trans_cfg.wide_cmd_header = fw_has_api(&mvm->fw->ucode_capa,
+					       IWL_UCODE_TLV_API_WIDE_CMD_HDR);
 
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DW_BC_TABLE)
 		trans_cfg.bc_table_dword = true;
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index f50ef82..a7d4342 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -108,7 +108,7 @@ int iwl_mvm_send_cmd(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd)
 	return ret;
 }
 
-int iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u8 id,
+int iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u32 id,
 			 u32 flags, u16 len, const void *data)
 {
 	struct iwl_host_cmd cmd = {
@@ -182,7 +182,7 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 /*
  * We assume that the caller set the status to the sucess value
  */
-int iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u8 id, u16 len,
+int iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id, u16 len,
 				const void *data, u32 *status)
 {
 	struct iwl_host_cmd cmd = {
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index e27d5a3..17f65dc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -299,6 +299,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @rx_buf_size_8k: 8 kB RX buffer size
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
+ * @wide_cmd_header: true when ucode supports wide command header format
  * @rx_page_order: page order for receive buffer size
  * @reg_lock: protect hw register access
  * @mutex: to protect stop_device / start_fw / start_hw
@@ -352,6 +353,7 @@ struct iwl_trans_pcie {
 	bool rx_buf_size_8k;
 	bool bc_table_dword;
 	bool scd_set_active;
+	bool wide_cmd_header;
 	u32 rx_page_order;
 
 	const char *const *command_names;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 4cdfb2f..88ab79f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1394,6 +1394,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	else
 		trans_pcie->rx_page_order = get_order(4 * 1024);
 
+	trans_pcie->wide_cmd_header = trans_cfg->wide_cmd_header;
 	trans_pcie->command_names = trans_cfg->command_names;
 	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
 	trans_pcie->scd_set_active = trans_cfg->scd_set_active;
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 553ae13..3a5d54e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1322,13 +1322,23 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	int idx;
 	u16 copy_size, cmd_size, scratch_size;
 	bool had_nocopy = false;
+	u8 group_id = iwl_cmd_groupid(cmd->id);
 	int i, ret;
 	u32 cmd_pos;
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 
-	copy_size = sizeof(out_cmd->hdr);
-	cmd_size = sizeof(out_cmd->hdr);
+	if (WARN(!trans_pcie->wide_cmd_header && group_id != 0,
+		 "unsupported wide command %#x\n", cmd->id))
+		return -EINVAL;
+
+	if (group_id != 0) {
+		copy_size = sizeof(struct iwl_cmd_header_wide);
+		cmd_size = sizeof(struct iwl_cmd_header_wide);
+	} else {
+		copy_size = sizeof(struct iwl_cmd_header);
+		cmd_size = sizeof(struct iwl_cmd_header);
+	}
 
 	/* need one for the header if the first is NOCOPY */
 	BUILD_BUG_ON(IWL_MAX_CMD_TBS_PER_TFD > IWL_NUM_OF_TBS - 1);
@@ -1418,16 +1428,32 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		out_meta->source = cmd;
 
 	/* set up the header */
-
-	out_cmd->hdr.cmd = cmd->id;
-	out_cmd->hdr.reserved = 0;
-	out_cmd->hdr.sequence =
-		cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
-					 INDEX_TO_SEQ(q->write_ptr));
+	if (group_id != 0) {
+		out_cmd->hdr_wide.cmd = iwl_cmd_opcode(cmd->id);
+		out_cmd->hdr_wide.group_id = group_id;
+		out_cmd->hdr_wide.version = iwl_cmd_version(cmd->id);
+		out_cmd->hdr_wide.length =
+			cpu_to_le16(cmd_size -
+				    sizeof(struct iwl_cmd_header_wide));
+		out_cmd->hdr_wide.reserved = 0;
+		out_cmd->hdr_wide.sequence =
+			cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
+						 INDEX_TO_SEQ(q->write_ptr));
+
+		cmd_pos = sizeof(struct iwl_cmd_header_wide);
+		copy_size = sizeof(struct iwl_cmd_header_wide);
+	} else {
+		out_cmd->hdr.cmd = iwl_cmd_opcode(cmd->id);
+		out_cmd->hdr.sequence =
+			cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
+						 INDEX_TO_SEQ(q->write_ptr));
+		out_cmd->hdr.group_id = 0;
+
+		cmd_pos = sizeof(struct iwl_cmd_header);
+		copy_size = sizeof(struct iwl_cmd_header);
+	}
 
 	/* and copy the data that needs to be copied */
-	cmd_pos = offsetof(struct iwl_device_cmd, payload);
-	copy_size = sizeof(out_cmd->hdr);
 	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
 		int copy;
 
@@ -1466,9 +1492,10 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	}
 
 	IWL_DEBUG_HC(trans,
-		     "Sending command %s (#%x), seq: 0x%04X, %d bytes at %d[%d]:%d\n",
+		     "Sending command %s (%.2x.%.2x), seq: 0x%04X, %d bytes at %d[%d]:%d\n",
 		     get_cmd_string(trans_pcie, out_cmd->hdr.cmd),
-		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
+		     group_id, out_cmd->hdr.cmd,
+		     le16_to_cpu(out_cmd->hdr.sequence),
 		     cmd_size, q->write_ptr, idx, trans_pcie->cmd_queue);
 
 	/* start the TFD with the scratchbuf */
@@ -1523,7 +1550,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		kzfree(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf = dup_buf;
 
-	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr);
+	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr_wide);
 
 	/* start timer if queue currently empty */
 	if (q->read_ptr == q->write_ptr && txq->wd_timeout)
-- 
2.1.4

