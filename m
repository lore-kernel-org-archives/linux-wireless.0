Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45646 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728077AbeHaODM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:03 +0300
Message-Id: <20180831095614.14099-6-luca@coelho.fi> (sfid-20180831_115636_647222_1A5F51F4)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 05/16] iwlwifi: debug flow cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Cleanup of the debug flow by moving several flows to separate
functions to increase readability.  Three functions were created:

1. iwl_fw_get_prph_len - returns the size needed for periphery dump.
2. iwl_fw_dump_mem for - executes the memory dumping flow.
3. iwl_trans_get_fw_monitor_len - returns the size needed for monitor dump.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 212 ++++++++++--------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  67 +++---
 2 files changed, 151 insertions(+), 128 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index cebc9e99961e..5029fd91f0bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -538,12 +538,108 @@ static struct scatterlist *alloc_sgtable(int size)
 	return table;
 }
 
+static int iwl_fw_get_prph_len(struct iwl_fw_runtime *fwrt)
+{
+	u32 prph_len = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr_comm);
+	     i++) {
+		/* The range includes both boundaries */
+		int num_bytes_in_chunk =
+			iwl_prph_dump_addr_comm[i].end -
+			iwl_prph_dump_addr_comm[i].start + 4;
+
+		prph_len += sizeof(struct iwl_fw_error_dump_data) +
+			sizeof(struct iwl_fw_error_dump_prph) +
+			num_bytes_in_chunk;
+	}
+
+	if (fwrt->trans->cfg->mq_rx_supported) {
+		for (i = 0; i <
+			ARRAY_SIZE(iwl_prph_dump_addr_9000); i++) {
+			/* The range includes both boundaries */
+			int num_bytes_in_chunk =
+				iwl_prph_dump_addr_9000[i].end -
+				iwl_prph_dump_addr_9000[i].start + 4;
+
+			prph_len += sizeof(struct iwl_fw_error_dump_data) +
+				sizeof(struct iwl_fw_error_dump_prph) +
+				num_bytes_in_chunk;
+		}
+	}
+	return prph_len;
+}
+
+static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
+			    struct iwl_fw_error_dump_data **dump_data,
+			    u32 sram_len, u32 sram_ofs, u32 smem_len,
+			    u32 sram2_len)
+{
+	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg_mem_tlv;
+	struct iwl_fw_error_dump_mem *dump_mem;
+	int i;
+
+	if (!fwrt->fw->n_dbg_mem_tlv) {
+		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		(*dump_data)->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
+		dump_mem = (void *)(*dump_data)->data;
+		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
+		dump_mem->offset = cpu_to_le32(sram_ofs);
+		iwl_trans_read_mem_bytes(fwrt->trans, sram_ofs, dump_mem->data,
+					 sram_len);
+		*dump_data = iwl_fw_error_next_data(*dump_data);
+	}
+
+	for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
+		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
+		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
+
+		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		(*dump_data)->len = cpu_to_le32(len + sizeof(*dump_mem));
+		dump_mem = (void *)(*dump_data)->data;
+		dump_mem->type = fw_dbg_mem[i].data_type;
+		dump_mem->offset = cpu_to_le32(ofs);
+
+		IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n",
+			       dump_mem->type);
+
+		iwl_trans_read_mem_bytes(fwrt->trans, ofs, dump_mem->data, len);
+		*dump_data = iwl_fw_error_next_data(*dump_data);
+	}
+
+	if (smem_len) {
+		IWL_DEBUG_INFO(fwrt, "WRT SMEM dump\n");
+		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		(*dump_data)->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
+		dump_mem = (void *)(*dump_data)->data;
+		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SMEM);
+		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->smem_offset);
+		iwl_trans_read_mem_bytes(fwrt->trans,
+					 fwrt->trans->cfg->smem_offset,
+					 dump_mem->data, smem_len);
+		*dump_data = iwl_fw_error_next_data(*dump_data);
+	}
+
+	if (sram2_len) {
+		IWL_DEBUG_INFO(fwrt, "WRT SRAM dump\n");
+		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		(*dump_data)->len = cpu_to_le32(sram2_len + sizeof(*dump_mem));
+		dump_mem = (void *)(*dump_data)->data;
+		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
+		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->dccm2_offset);
+		iwl_trans_read_mem_bytes(fwrt->trans,
+					 fwrt->trans->cfg->dccm2_offset,
+					 dump_mem->data, sram2_len);
+		*dump_data = iwl_fw_error_next_data(*dump_data);
+	}
+}
+
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
-	struct iwl_fw_error_dump_mem *dump_mem;
 	struct iwl_fw_error_dump_smem_cfg *dump_smem_cfg;
 	struct iwl_fw_error_dump_trigger_desc *dump_trig;
 	struct iwl_fw_dump_ptrs *fw_error_dump;
@@ -655,35 +751,8 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 
 		/* Make room for PRPH registers */
 		if (!fwrt->trans->cfg->gen2 &&
-		    fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PRPH)) {
-			for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr_comm);
-			     i++) {
-				/* The range includes both boundaries */
-				int num_bytes_in_chunk =
-					iwl_prph_dump_addr_comm[i].end -
-					iwl_prph_dump_addr_comm[i].start + 4;
-
-				prph_len += sizeof(*dump_data) +
-					sizeof(struct iwl_fw_error_dump_prph) +
-					num_bytes_in_chunk;
-			}
-		}
-
-		if (!fwrt->trans->cfg->gen2 &&
-		    fwrt->trans->cfg->mq_rx_supported &&
-		    fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PRPH)) {
-			for (i = 0; i <
-				ARRAY_SIZE(iwl_prph_dump_addr_9000); i++) {
-				/* The range includes both boundaries */
-				int num_bytes_in_chunk =
-					iwl_prph_dump_addr_9000[i].end -
-					iwl_prph_dump_addr_9000[i].start + 4;
-
-				prph_len += sizeof(*dump_data) +
-					sizeof(struct iwl_fw_error_dump_prph) +
-					num_bytes_in_chunk;
-			}
-		}
+		    fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PRPH))
+			prph_len += iwl_fw_get_prph_len(fwrt);
 
 		if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000 &&
 		    fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_RADIO_REG))
@@ -703,18 +772,19 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
 		/* Make room for the SMEM, if it exists */
 		if (smem_len)
-			file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
-				smem_len;
+			file_len += sizeof(*dump_data) + smem_len +
+				sizeof(struct iwl_fw_error_dump_mem);
 
 		/* Make room for the secondary SRAM, if it exists */
 		if (sram2_len)
-			file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
-				sram2_len;
+			file_len += sizeof(*dump_data) + sram2_len +
+				sizeof(struct iwl_fw_error_dump_mem);
 
 		/* Make room for MEM segments */
 		for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
-			file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
-				    le32_to_cpu(fw_dbg_mem[i].len);
+			file_len += sizeof(*dump_data) +
+				le32_to_cpu(fw_dbg_mem[i].len) +
+				sizeof(struct iwl_fw_error_dump_mem);
 		}
 	}
 
@@ -746,7 +816,8 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 
 	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM) &&
 	    !fwrt->fw->n_dbg_mem_tlv)
-		file_len += sizeof(*dump_data) + sram_len + sizeof(*dump_mem);
+		file_len += sizeof(*dump_data) + sram_len +
+			sizeof(struct iwl_fw_error_dump_mem);
 
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
@@ -833,17 +904,10 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (monitor_dump_only)
 		goto dump_trans_data;
 
-	if (!fwrt->fw->n_dbg_mem_tlv &&
-	    fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
-		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
-		dump_mem = (void *)dump_data->data;
-		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
-		dump_mem->offset = cpu_to_le32(sram_ofs);
-		iwl_trans_read_mem_bytes(fwrt->trans, sram_ofs, dump_mem->data,
-					 sram_len);
-		dump_data = iwl_fw_error_next_data(dump_data);
-	}
+	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM))
+		iwl_fw_dump_mem(fwrt, &dump_data, sram_len, sram_ofs, smem_len,
+				sram2_len);
+
 
 	if (iwl_fw_dbg_is_d3_debug_enabled(fwrt) && fwrt->dump.d3_debug_data) {
 		u32 addr = fwrt->trans->cfg->d3_debug_data_base_addr;
@@ -852,8 +916,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
 		dump_data->len = cpu_to_le32(data_size * 2);
 
-		memcpy(dump_data->data, fwrt->dump.d3_debug_data,
-		       data_size);
+		memcpy(dump_data->data, fwrt->dump.d3_debug_data, data_size);
 
 		kfree(fwrt->dump.d3_debug_data);
 		fwrt->dump.d3_debug_data = NULL;
@@ -865,55 +928,6 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
-	for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
-		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
-		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
-
-		if (!(fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)))
-			break;
-
-		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		dump_data->len = cpu_to_le32(len + sizeof(*dump_mem));
-		dump_mem = (void *)dump_data->data;
-		dump_mem->type = fw_dbg_mem[i].data_type;
-		dump_mem->offset = cpu_to_le32(ofs);
-
-		IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n",
-			       dump_mem->type);
-
-		iwl_trans_read_mem_bytes(fwrt->trans, ofs,
-					 dump_mem->data,
-					 len);
-
-		dump_data = iwl_fw_error_next_data(dump_data);
-	}
-
-	if (smem_len && fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
-		IWL_DEBUG_INFO(fwrt, "WRT SMEM dump\n");
-		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		dump_data->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
-		dump_mem = (void *)dump_data->data;
-		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SMEM);
-		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->smem_offset);
-		iwl_trans_read_mem_bytes(fwrt->trans,
-					 fwrt->trans->cfg->smem_offset,
-					 dump_mem->data, smem_len);
-		dump_data = iwl_fw_error_next_data(dump_data);
-	}
-
-	if (sram2_len && fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
-		IWL_DEBUG_INFO(fwrt, "WRT SRAM dump\n");
-		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		dump_data->len = cpu_to_le32(sram2_len + sizeof(*dump_mem));
-		dump_mem = (void *)dump_data->data;
-		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
-		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->dccm2_offset);
-		iwl_trans_read_mem_bytes(fwrt->trans,
-					 fwrt->trans->cfg->dccm2_offset,
-					 dump_mem->data, sram2_len);
-		dump_data = iwl_fw_error_next_data(dump_data);
-	}
-
 	/* Dump fw's virtual image */
 	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING) &&
 	    !fwrt->trans->cfg->gen2 &&
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 1012d71bad6f..93c336ebfa40 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2912,36 +2912,17 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 	return len;
 }
 
-static struct iwl_trans_dump_data
-*iwl_trans_pcie_dump_data(struct iwl_trans *trans,
-			  const struct iwl_fw_dbg_trigger_tlv *trigger)
+static int iwl_trans_get_fw_monitor_len(struct iwl_trans *trans, int *len)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_fw_error_dump_data *data;
-	struct iwl_txq *cmdq = trans_pcie->txq[trans_pcie->cmd_queue];
-	struct iwl_fw_error_dump_txcmd *txcmd;
-	struct iwl_trans_dump_data *dump_data;
-	u32 len, num_rbs = 0;
-	u32 monitor_len;
-	int i, ptr;
-	bool dump_rbs = test_bit(STATUS_FW_ERROR, &trans->status) &&
-			!trans->cfg->mq_rx_supported &&
-			trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_RB);
 
-	/* transport dump header */
-	len = sizeof(*dump_data);
-
-	/* host commands */
-	len += sizeof(*data) +
-		cmdq->n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
-
-	/* FW monitor */
 	if (trans_pcie->fw_mon_cpu_addr) {
-		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
-		       trans_pcie->fw_mon_size;
-		monitor_len = trans_pcie->fw_mon_size;
+		*len += sizeof(struct iwl_fw_error_dump_data) +
+			sizeof(struct iwl_fw_error_dump_fw_mon) +
+			trans_pcie->fw_mon_size;
+		return trans_pcie->fw_mon_size;
 	} else if (trans->dbg_dest_tlv) {
-		u32 base, end, cfg_reg;
+		u32 base, end, cfg_reg, monitor_len;
 
 		if (trans->dbg_dest_tlv->version == 1) {
 			cfg_reg = le32_to_cpu(trans->dbg_dest_tlv->base_reg);
@@ -2971,11 +2952,39 @@ static struct iwl_trans_dump_data
 				end += (1 << trans->dbg_dest_tlv->end_shift);
 			monitor_len = end - base;
 		}
-		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
-		       monitor_len;
-	} else {
-		monitor_len = 0;
+		*len += sizeof(struct iwl_fw_error_dump_data) +
+			sizeof(struct iwl_fw_error_dump_fw_mon) +
+			monitor_len;
+		return monitor_len;
 	}
+	return 0;
+}
+
+static struct iwl_trans_dump_data
+*iwl_trans_pcie_dump_data(struct iwl_trans *trans,
+			  const struct iwl_fw_dbg_trigger_tlv *trigger)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_fw_error_dump_data *data;
+	struct iwl_txq *cmdq = trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_fw_error_dump_txcmd *txcmd;
+	struct iwl_trans_dump_data *dump_data;
+	u32 len, num_rbs = 0;
+	u32 monitor_len;
+	int i, ptr;
+	bool dump_rbs = test_bit(STATUS_FW_ERROR, &trans->status) &&
+			!trans->cfg->mq_rx_supported &&
+			trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_RB);
+
+	/* transport dump header */
+	len = sizeof(*dump_data);
+
+	/* host commands */
+	len += sizeof(*data) +
+		cmdq->n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
+
+	/* FW monitor */
+	monitor_len = iwl_trans_get_fw_monitor_len(trans, &len);
 
 	if (trigger && (trigger->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)) {
 		if (!(trans->dbg_dump_mask &
-- 
2.18.0
