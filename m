Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbbAVUeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:06 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/38] iwlwifi: mvm: add rxf and txf to dump data
Date: Thu, 22 Jan 2015 22:33:07 +0200
Message-Id: <1421958809-3371-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213412_460735_7865775A)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When the FW is in error status - try to read the RXF and
TXF (all of them) and add them to the dump data.

This shouldn't happen in non-error statuses, as we don't
want to stop the RXF/TXF while they are running.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  21 +++
 drivers/net/wireless/iwlwifi/iwl-prph.h          |  18 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        |  35 +++++
 drivers/net/wireless/iwlwifi/mvm/fw.c            |  53 +++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 186 +++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  17 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c           |   1 +
 7 files changed, 304 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index ec115bd..919a254 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -134,6 +134,27 @@ struct iwl_fw_error_dump_txcmd {
 	u8 data[];
 } __packed;
 
+/**
+ * struct iwl_fw_error_dump_fifo - RX/TX FIFO data
+ * @fifo_num: number of FIFO (starting from 0)
+ * @available_bytes: num of bytes available in FIFO (may be less than FIFO size)
+ * @wr_ptr: position of write pointer
+ * @rd_ptr: position of read pointer
+ * @fence_ptr: position of fence pointer
+ * @fence_mode: the current mode of the fence (before locking) -
+ *	0=follow RD pointer ; 1 = freeze
+ * @data: all of the FIFO's data
+ */
+struct iwl_fw_error_dump_fifo {
+	__le32 fifo_num;
+	__le32 available_bytes;
+	__le32 wr_ptr;
+	__le32 rd_ptr;
+	__le32 fence_ptr;
+	__le32 fence_mode;
+	u8 data[];
+} __packed;
+
 enum iwl_fw_error_dump_family {
 	IWL_FW_ERROR_DUMP_FAMILY_7 = 7,
 	IWL_FW_ERROR_DUMP_FAMILY_8 = 8,
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 83ab423..387a5aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -359,12 +359,30 @@ enum secure_load_status_reg {
 
 /* Rx FIFO */
 #define RXF_SIZE_ADDR			(0xa00c88)
+#define RXF_RD_D_SPACE			(0xa00c40)
+#define RXF_RD_WR_PTR			(0xa00c50)
+#define RXF_RD_RD_PTR			(0xa00c54)
+#define RXF_RD_FENCE_PTR		(0xa00c4c)
+#define RXF_SET_FENCE_MODE		(0xa00c14)
+#define RXF_LD_WR2FENCE		(0xa00c1c)
+#define RXF_FIFO_RD_FENCE_INC		(0xa00c68)
 #define RXF_SIZE_BYTE_CND_POS		(7)
 #define RXF_SIZE_BYTE_CNT_MSK		(0x3ff << RXF_SIZE_BYTE_CND_POS)
+#define RXF_DIFF_FROM_PREV		(0x200)
 
 #define RXF_LD_FENCE_OFFSET_ADDR	(0xa00c10)
 #define RXF_FIFO_RD_FENCE_ADDR		(0xa00c0c)
 
+/* Tx FIFO */
+#define TXF_FIFO_ITEM_CNT		(0xa00438)
+#define TXF_WR_PTR			(0xa00414)
+#define TXF_RD_PTR			(0xa00410)
+#define TXF_FENCE_PTR			(0xa00418)
+#define TXF_LOCK_FENCE			(0xa00424)
+#define TXF_LARC_NUM			(0xa0043c)
+#define TXF_READ_MODIFY_DATA		(0xa00448)
+#define TXF_READ_MODIFY_ADDR		(0xa0044c)
+
 /* FW monitor */
 #define MON_BUFF_SAMPLE_CTL		(0xa03c00)
 #define MON_BUFF_BASE_ADDR		(0xa03c3c)
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index b1e9dac..b3badec 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -128,6 +128,9 @@ enum {
 	/* global key */
 	WEP_KEY = 0x20,
 
+	/* Memory */
+	SHARED_MEM_CFG = 0x25,
+
 	/* TDLS */
 	TDLS_CHANNEL_SWITCH_CMD = 0x27,
 	TDLS_CHANNEL_SWITCH_NOTIFICATION = 0xaa,
@@ -1821,4 +1824,36 @@ struct iwl_tdls_config_res {
 	struct iwl_tdls_config_sta_info_res sta_info[IWL_MVM_TDLS_STA_COUNT];
 } __packed; /* TDLS_CONFIG_RSP_API_S_VER_1 */
 
+#define TX_FIFO_MAX_NUM		8
+#define RX_FIFO_MAX_NUM		2
+
+/**
+ * Shared memory configuration information from the FW
+ *
+ * @shared_mem_addr: shared memory addr (pre 8000 HW set to 0x0 as MARBH is not
+ *	accessible)
+ * @shared_mem_size: shared memory size
+ * @sample_buff_addr: internal sample (mon/adc) buff addr (pre 8000 HW set to
+ *	0x0 as accessible only via DBGM RDAT)
+ * @sample_buff_size: internal sample buff size
+ * @txfifo_addr: start addr of TXF0 (excluding the context table 0.5KB), (pre
+ *	8000 HW set to 0x0 as not accessible)
+ * @txfifo_size: size of TXF0 ... TXF7
+ * @rxfifo_size: RXF1, RXF2 sizes. If there is no RXF2, it'll have a value of 0
+ * @page_buff_addr: used by UMAC and performance debug (page miss analysis),
+ *	when paging is not supported this should be 0
+ * @page_buff_size: size of %page_buff_addr
+ */
+struct iwl_shared_mem_cfg {
+	__le32 shared_mem_addr;
+	__le32 shared_mem_size;
+	__le32 sample_buff_addr;
+	__le32 sample_buff_size;
+	__le32 txfifo_addr;
+	__le32 txfifo_size[TX_FIFO_MAX_NUM];
+	__le32 rxfifo_size[RX_FIFO_MAX_NUM];
+	__le32 page_buff_addr;
+	__le32 page_buff_size;
+} __packed; /* SHARED_MEM_ALLOC_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 52338b7..2e12f41 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -400,6 +400,57 @@ out:
 	return ret;
 }
 
+static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
+{
+	struct iwl_host_cmd cmd = {
+		.id = SHARED_MEM_CFG,
+		.flags = CMD_WANT_SKB,
+		.data = { NULL, },
+		.len = { 0, },
+	};
+	struct iwl_rx_packet *pkt;
+	struct iwl_shared_mem_cfg *mem_cfg;
+	u32 i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (WARN_ON(iwl_mvm_send_cmd(mvm, &cmd)))
+		return;
+
+	pkt = cmd.resp_pkt;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERR(mvm, "Bad return from SHARED_MEM_CFG (0x%08X)\n",
+			pkt->hdr.flags);
+		goto exit;
+	}
+
+	mem_cfg = (void *)pkt->data;
+
+	mvm->shared_mem_cfg.shared_mem_addr =
+		le32_to_cpu(mem_cfg->shared_mem_addr);
+	mvm->shared_mem_cfg.shared_mem_size =
+		le32_to_cpu(mem_cfg->shared_mem_size);
+	mvm->shared_mem_cfg.sample_buff_addr =
+		le32_to_cpu(mem_cfg->sample_buff_addr);
+	mvm->shared_mem_cfg.sample_buff_size =
+		le32_to_cpu(mem_cfg->sample_buff_size);
+	mvm->shared_mem_cfg.txfifo_addr = le32_to_cpu(mem_cfg->txfifo_addr);
+	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size); i++)
+		mvm->shared_mem_cfg.txfifo_size[i] =
+			le32_to_cpu(mem_cfg->txfifo_size[i]);
+	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.rxfifo_size); i++)
+		mvm->shared_mem_cfg.rxfifo_size[i] =
+			le32_to_cpu(mem_cfg->rxfifo_size[i]);
+	mvm->shared_mem_cfg.page_buff_addr =
+		le32_to_cpu(mem_cfg->page_buff_addr);
+	mvm->shared_mem_cfg.page_buff_size =
+		le32_to_cpu(mem_cfg->page_buff_size);
+	IWL_DEBUG_INFO(mvm, "SHARED MEM CFG: got memory offsets/sizes\n");
+
+exit:
+	iwl_free_resp(&cmd);
+}
+
 void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm)
 {
 	/* stop recording */
@@ -495,6 +546,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		goto error;
 	}
 
+	iwl_mvm_get_shared_mem_conf(mvm);
+
 	ret = iwl_mvm_sf_update(mvm, NULL, false);
 	if (ret)
 		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b5f401d..0ea0f0a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -766,6 +766,132 @@ static void iwl_mvm_free_coredump(const void *data)
 	kfree(fw_error_dump);
 }
 
+static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
+			       struct iwl_fw_error_dump_data **dump_data)
+{
+	struct iwl_fw_error_dump_fifo *fifo_hdr;
+	u32 *fifo_data;
+	u32 fifo_len;
+	unsigned long flags;
+	int i, j;
+
+	if (!iwl_trans_grab_nic_access(mvm->trans, false, &flags))
+		return;
+
+	/* Pull RXF data from all RXFs */
+	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.rxfifo_size); i++) {
+		/*
+		 * Keep aside the additional offset that might be needed for
+		 * next RXF
+		 */
+		u32 offset_diff = RXF_DIFF_FROM_PREV * i;
+
+		fifo_hdr = (void *)(*dump_data)->data;
+		fifo_data = (void *)fifo_hdr->data;
+		fifo_len = mvm->shared_mem_cfg.rxfifo_size[i];
+
+		/* No need to try to read the data if the length is 0 */
+		if (fifo_len == 0)
+			continue;
+
+		/* Add a TLV for the RXF */
+		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
+		(*dump_data)->len = cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
+
+		fifo_hdr->fifo_num = cpu_to_le32(i);
+		fifo_hdr->available_bytes =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							RXF_RD_D_SPACE +
+							offset_diff));
+		fifo_hdr->wr_ptr =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							RXF_RD_WR_PTR +
+							offset_diff));
+		fifo_hdr->rd_ptr =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							RXF_RD_RD_PTR +
+							offset_diff));
+		fifo_hdr->fence_ptr =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							RXF_RD_FENCE_PTR +
+							offset_diff));
+		fifo_hdr->fence_mode =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							RXF_SET_FENCE_MODE +
+							offset_diff));
+
+		/* Lock fence */
+		iwl_trans_write_prph(mvm->trans,
+				     RXF_SET_FENCE_MODE + offset_diff, 0x1);
+		/* Set fence pointer to the same place like WR pointer */
+		iwl_trans_write_prph(mvm->trans,
+				     RXF_LD_WR2FENCE + offset_diff, 0x1);
+		/* Set fence offset */
+		iwl_trans_write_prph(mvm->trans,
+				     RXF_LD_FENCE_OFFSET_ADDR + offset_diff,
+				     0x0);
+
+		/* Read FIFO */
+		fifo_len /= sizeof(u32); /* Size in DWORDS */
+		for (j = 0; j < fifo_len; j++)
+			fifo_data[j] = iwl_trans_read_prph(mvm->trans,
+							 RXF_FIFO_RD_FENCE_INC +
+							 offset_diff);
+		*dump_data = iwl_fw_error_next_data(*dump_data);
+	}
+
+	/* Pull TXF data from all TXFs */
+	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size); i++) {
+		/* Mark the number of TXF we're pulling now */
+		iwl_trans_write_prph(mvm->trans, TXF_LARC_NUM, i);
+
+		fifo_hdr = (void *)(*dump_data)->data;
+		fifo_data = (void *)fifo_hdr->data;
+		fifo_len = mvm->shared_mem_cfg.txfifo_size[i];
+
+		/* No need to try to read the data if the length is 0 */
+		if (fifo_len == 0)
+			continue;
+
+		/* Add a TLV for the FIFO */
+		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXF);
+		(*dump_data)->len = cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
+
+		fifo_hdr->fifo_num = cpu_to_le32(i);
+		fifo_hdr->available_bytes =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							TXF_FIFO_ITEM_CNT));
+		fifo_hdr->wr_ptr =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							TXF_WR_PTR));
+		fifo_hdr->rd_ptr =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							TXF_RD_PTR));
+		fifo_hdr->fence_ptr =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							TXF_FENCE_PTR));
+		fifo_hdr->fence_mode =
+			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+							TXF_LOCK_FENCE));
+
+		/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
+		iwl_trans_write_prph(mvm->trans, TXF_READ_MODIFY_ADDR,
+				     TXF_WR_PTR);
+
+		/* Dummy-read to advance the read pointer to the head */
+		iwl_trans_read_prph(mvm->trans, TXF_READ_MODIFY_DATA);
+
+		/* Read FIFO */
+		fifo_len /= sizeof(u32); /* Size in DWORDS */
+		for (j = 0; j < fifo_len; j++)
+			fifo_data[j] = iwl_trans_read_prph(mvm->trans,
+							  TXF_READ_MODIFY_DATA);
+		*dump_data = iwl_fw_error_next_data(*dump_data);
+	}
+
+	iwl_trans_release_nic_access(mvm->trans, &flags);
+}
+
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
 	struct iwl_fw_error_dump_file *dump_file;
@@ -774,9 +900,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_mem *dump_mem;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	u32 sram_len, sram_ofs;
-	u32 file_len, rxf_len;
-	unsigned long flags;
-	int reg_val;
+	u32 file_len, fifo_data_len = 0;
 	u32 smem_len = mvm->cfg->smem_len;
 	u32 sram2_len = mvm->cfg->dccm2_len;
 
@@ -808,17 +932,39 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		sram_len = mvm->cfg->dccm_len;
 	}
 
-	/* reading buffer size */
-	reg_val = iwl_trans_read_prph(mvm->trans, RXF_SIZE_ADDR);
-	rxf_len = (reg_val & RXF_SIZE_BYTE_CNT_MSK) >> RXF_SIZE_BYTE_CND_POS;
+	/* reading RXF/TXF sizes */
+	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status)) {
+		struct iwl_mvm_shared_mem_cfg *mem_cfg = &mvm->shared_mem_cfg;
+		int i;
+
+		fifo_data_len = 0;
+
+		/* Count RXF size */
+		for (i = 0; i < ARRAY_SIZE(mem_cfg->rxfifo_size); i++) {
+			if (!mem_cfg->rxfifo_size[i])
+				continue;
+
+			/* Add header info */
+			fifo_data_len += mem_cfg->rxfifo_size[i] +
+					 sizeof(*dump_data) +
+					 sizeof(struct iwl_fw_error_dump_fifo);
+		}
+
+		for (i = 0; i < ARRAY_SIZE(mem_cfg->txfifo_size); i++) {
+			if (!mem_cfg->txfifo_size[i])
+				continue;
 
-	/* the register holds the value divided by 128 */
-	rxf_len = rxf_len << 7;
+			/* Add header info */
+			fifo_data_len += mem_cfg->txfifo_size[i] +
+					 sizeof(*dump_data) +
+					 sizeof(struct iwl_fw_error_dump_fifo);
+		}
+	}
 
 	file_len = sizeof(*dump_file) +
-		   sizeof(*dump_data) * 3 +
+		   sizeof(*dump_data) * 2 +
 		   sram_len + sizeof(*dump_mem) +
-		   rxf_len +
+		   fifo_data_len +
 		   sizeof(*dump_info);
 
 	/* Make room for the SMEM, if it exists */
@@ -856,24 +1002,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		sizeof(dump_info->bus_human_readable));
 
 	dump_data = iwl_fw_error_next_data(dump_data);
-	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
-	dump_data->len = cpu_to_le32(rxf_len);
-
-	if (iwl_trans_grab_nic_access(mvm->trans, false, &flags)) {
-		u32 *rxf = (void *)dump_data->data;
-		int i;
+	/* We only dump the FIFOs if the FW is in error state */
+	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status))
+		iwl_mvm_dump_fifos(mvm, &dump_data);
 
-		for (i = 0; i < (rxf_len / sizeof(u32)); i++) {
-			iwl_trans_write_prph(mvm->trans,
-					     RXF_LD_FENCE_OFFSET_ADDR,
-					     i * sizeof(u32));
-			rxf[i] = iwl_trans_read_prph(mvm->trans,
-						     RXF_FIFO_RD_FENCE_ADDR);
-		}
-		iwl_trans_release_nic_access(mvm->trans, &flags);
-	}
-
-	dump_data = iwl_fw_error_next_data(dump_data);
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 	dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
 	dump_mem = (void *)dump_data->data;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e9c05d7..aa93ee7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -536,6 +536,18 @@ enum iwl_mvm_tdls_cs_state {
 	IWL_MVM_TDLS_SW_ACTIVE,
 };
 
+struct iwl_mvm_shared_mem_cfg {
+	u32 shared_mem_addr;
+	u32 shared_mem_size;
+	u32 sample_buff_addr;
+	u32 sample_buff_size;
+	u32 txfifo_addr;
+	u32 txfifo_size[TX_FIFO_MAX_NUM];
+	u32 rxfifo_size[RX_FIFO_MAX_NUM];
+	u32 page_buff_addr;
+	u32 page_buff_size;
+};
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -787,6 +799,8 @@ struct iwl_mvm {
 			u32 ch_sw_tm_ie;
 		} peer;
 	} tdls_cs;
+
+	struct iwl_mvm_shared_mem_cfg shared_mem_cfg;
 };
 
 /* Extract MVM priv from op_mode and _hw */
@@ -1002,6 +1016,9 @@ int iwl_mvm_rx_radio_ver(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			 struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_shared_mem_cfg_notif(struct iwl_mvm *mvm,
+				    struct iwl_rx_cmd_buffer *rxb,
+				    struct iwl_device_cmd *cmd);
 
 /* MVM PHY */
 int iwl_mvm_phy_ctxt_add(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 90143aa..8bf8c2a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -270,6 +270,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(MGMT_MCAST_KEY),
 	CMD(TX_CMD),
 	CMD(TXPATH_FLUSH),
+	CMD(SHARED_MEM_CFG),
 	CMD(MAC_CONTEXT_CMD),
 	CMD(TIME_EVENT_CMD),
 	CMD(TIME_EVENT_NOTIFICATION),
-- 
1.9.1

