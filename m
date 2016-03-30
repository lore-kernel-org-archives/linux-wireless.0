Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:31955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbcC3OGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/43] iwlwifi: store fw memory segments length and addresses in run-time
Date: Wed, 30 Mar 2016 17:05:12 +0300
Message-Id: <1459346715-7954-40-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160643_923574_8609BE1F)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Currently reading the fw memory segments is done according to
addresses and data length that are hard-coded.
Lately a new tlv was appended to the ucode, that contains
the data type, length and address.
Parse this tlv, and in run-time store the memory segments length
and addresses that would be dumped upon a fw error.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 45 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 32 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h      |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c  | 61 ++++++++++++++++++------
 4 files changed, 125 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 605910f..48e8737 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -179,6 +179,8 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 		kfree(drv->fw.dbg_conf_tlv[i]);
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++)
 		kfree(drv->fw.dbg_trigger_tlv[i]);
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_mem_tlv); i++)
+		kfree(drv->fw.dbg_mem_tlv[i]);
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
@@ -297,6 +299,7 @@ struct iwl_firmware_pieces {
 	size_t dbg_conf_tlv_len[FW_DBG_CONF_MAX];
 	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
 	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
+	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv[FW_DBG_MEM_MAX];
 };
 
 /*
@@ -1041,6 +1044,37 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			iwl_store_gscan_capa(&drv->fw, tlv_data, tlv_len);
 			gscan_capa = true;
 			break;
+		case IWL_UCODE_TLV_FW_MEM_SEG: {
+			struct iwl_fw_dbg_mem_seg_tlv *dbg_mem =
+				(void *)tlv_data;
+			u32 type;
+
+			if (tlv_len != (sizeof(*dbg_mem)))
+				goto invalid_tlv_len;
+
+			type = le32_to_cpu(dbg_mem->data_type);
+			drv->fw.dbg_dynamic_mem = true;
+
+			if (type >= ARRAY_SIZE(drv->fw.dbg_mem_tlv)) {
+				IWL_ERR(drv,
+					"Skip unknown dbg mem segment: %u\n",
+					dbg_mem->data_type);
+				break;
+			}
+
+			if (pieces->dbg_mem_tlv[type]) {
+				IWL_ERR(drv,
+					"Ignore duplicate mem segment: %u\n",
+					dbg_mem->data_type);
+				break;
+			}
+
+			IWL_DEBUG_INFO(drv, "Found debug memory segment: %u\n",
+				       dbg_mem->data_type);
+
+			pieces->dbg_mem_tlv[type] = dbg_mem;
+			break;
+			}
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -1350,6 +1384,17 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		}
 	}
 
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_mem_tlv); i++) {
+		if (pieces->dbg_mem_tlv[i]) {
+			drv->fw.dbg_mem_tlv[i] =
+				kmemdup(pieces->dbg_mem_tlv[i],
+					sizeof(*drv->fw.dbg_mem_tlv[i]),
+					GFP_KERNEL);
+			if (!drv->fw.dbg_mem_tlv[i])
+				goto out_free_fw;
+		}
+	}
+
 	/* Now that we can no longer fail, copy information */
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index a6e8826..843232b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -142,6 +142,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
 	IWL_UCODE_TLV_FW_DBG_TRIGGER	= 40,
 	IWL_UCODE_TLV_FW_GSCAN_CAPA	= 50,
+	IWL_UCODE_TLV_FW_MEM_SEG	= 51,
 };
 
 struct iwl_ucode_tlv {
@@ -492,6 +493,37 @@ enum iwl_fw_dbg_monitor_mode {
 };
 
 /**
+ * enum iwl_fw_mem_seg_type - data types for dumping on error
+ *
+ * @FW_DBG_MEM_SMEM: the data type is SMEM
+ * @FW_DBG_MEM_DCCM_LMAC: the data type is DCCM_LMAC
+ * @FW_DBG_MEM_DCCM_UMAC: the data type is DCCM_UMAC
+ */
+enum iwl_fw_dbg_mem_seg_type {
+	FW_DBG_MEM_DCCM_LMAC = 0,
+	FW_DBG_MEM_DCCM_UMAC,
+	FW_DBG_MEM_SMEM,
+
+	/* Must be last */
+	FW_DBG_MEM_MAX,
+};
+
+/**
+ * struct iwl_fw_dbg_mem_seg_tlv - configures the debug data memory segments
+ *
+ * @data_type: enum %iwl_fw_mem_seg_type
+ * @ofs: the memory segment offset
+ * @len: the memory segment length, in bytes
+ *
+ * This parses IWL_UCODE_TLV_FW_MEM_SEG
+ */
+struct iwl_fw_dbg_mem_seg_tlv {
+	__le32 data_type;
+	__le32 ofs;
+	__le32 len;
+} __packed;
+
+/**
  * struct iwl_fw_dbg_dest_tlv - configures the destination of the debug data
  *
  * @version: version of the TLV - currently 0
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 2942571..e461d63 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -286,6 +286,8 @@ struct iwl_fw {
 	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
 	size_t dbg_conf_tlv_len[FW_DBG_CONF_MAX];
 	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
+	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv[FW_DBG_MEM_MAX];
+	bool dbg_dynamic_mem;
 	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
 	u8 dbg_dest_reg_num;
 	struct iwl_gscan_capabilities gscan_capa;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 6ef706c..cbb5947 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -488,9 +488,11 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_trigger_desc *dump_trig;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	u32 sram_len, sram_ofs;
+	struct iwl_fw_dbg_mem_seg_tlv * const *fw_dbg_mem =
+		mvm->fw->dbg_mem_tlv;
 	u32 file_len, fifo_data_len = 0, prph_len = 0, radio_len = 0;
-	u32 smem_len = mvm->cfg->smem_len;
-	u32 sram2_len = mvm->cfg->dccm2_len;
+	u32 smem_len = mvm->fw->dbg_dynamic_mem ? 0 : mvm->cfg->smem_len;
+	u32 sram2_len = mvm->fw->dbg_dynamic_mem ? 0 : mvm->cfg->dccm2_len;
 	bool monitor_dump_only = false;
 	int i;
 
@@ -586,7 +588,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	file_len = sizeof(*dump_file) +
 		   sizeof(*dump_data) * 2 +
-		   sram_len + sizeof(*dump_mem) +
 		   fifo_data_len +
 		   prph_len +
 		   radio_len +
@@ -600,6 +601,13 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (sram2_len)
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
 
+	/* Make room for MEM segments */
+	for (i = 0; i < ARRAY_SIZE(mvm->fw->dbg_mem_tlv); i++) {
+		if (fw_dbg_mem[i])
+			file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
+				le32_to_cpu(fw_dbg_mem[i]->len);
+	}
+
 	/* Make room for fw's virtual image pages, if it exists */
 	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size)
 		file_len += mvm->num_of_paging_blk *
@@ -625,6 +633,9 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    mvm->fw_dump_desc->len;
 
+	if (!mvm->fw->dbg_dynamic_mem)
+		file_len += sram_len + sizeof(*dump_mem);
+
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
 		kfree(fw_error_dump);
@@ -674,16 +685,36 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (monitor_dump_only)
 		goto dump_trans_data;
 
-	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-	dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
-	dump_mem = (void *)dump_data->data;
-	dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
-	dump_mem->offset = cpu_to_le32(sram_ofs);
-	iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_mem->data,
-				 sram_len);
+	if (!mvm->fw->dbg_dynamic_mem) {
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
+		dump_mem = (void *)dump_data->data;
+		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
+		dump_mem->offset = cpu_to_le32(sram_ofs);
+		iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_mem->data,
+					 sram_len);
+		dump_data = iwl_fw_error_next_data(dump_data);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mvm->fw->dbg_mem_tlv); i++) {
+		if (fw_dbg_mem[i]) {
+			u32 len = le32_to_cpu(fw_dbg_mem[i]->len);
+			u32 ofs = le32_to_cpu(fw_dbg_mem[i]->ofs);
+
+			dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+			dump_data->len = cpu_to_le32(len +
+					sizeof(*dump_mem));
+			dump_mem = (void *)dump_data->data;
+			dump_mem->type = fw_dbg_mem[i]->data_type;
+			dump_mem->offset = cpu_to_le32(ofs);
+			iwl_trans_read_mem_bytes(mvm->trans, ofs,
+						 dump_mem->data,
+						 len);
+			dump_data = iwl_fw_error_next_data(dump_data);
+		}
+	}
 
 	if (smem_len) {
-		dump_data = iwl_fw_error_next_data(dump_data);
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
@@ -691,10 +722,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_mem->offset = cpu_to_le32(mvm->cfg->smem_offset);
 		iwl_trans_read_mem_bytes(mvm->trans, mvm->cfg->smem_offset,
 					 dump_mem->data, smem_len);
+		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
 	if (sram2_len) {
-		dump_data = iwl_fw_error_next_data(dump_data);
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(sram2_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
@@ -702,11 +733,11 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_mem->offset = cpu_to_le32(mvm->cfg->dccm2_offset);
 		iwl_trans_read_mem_bytes(mvm->trans, mvm->cfg->dccm2_offset,
 					 dump_mem->data, sram2_len);
+		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
 	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_B_STEP) {
-		dump_data = iwl_fw_error_next_data(dump_data);
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(IWL8260_ICCM_LEN +
 					     sizeof(*dump_mem));
@@ -715,6 +746,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_mem->offset = cpu_to_le32(IWL8260_ICCM_OFFSET);
 		iwl_trans_read_mem_bytes(mvm->trans, IWL8260_ICCM_OFFSET,
 					 dump_mem->data, IWL8260_ICCM_LEN);
+		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
 	/* Dump fw's virtual image */
@@ -724,7 +756,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			struct page *pages =
 				mvm->fw_paging_db[i].fw_paging_block;
 
-			dump_data = iwl_fw_error_next_data(dump_data);
 			dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
 			dump_data->len = cpu_to_le32(sizeof(*paging) +
 						     PAGING_BLOCK_SIZE);
@@ -732,10 +763,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			paging->index = cpu_to_le32(i);
 			memcpy(paging->data, page_address(pages),
 			       PAGING_BLOCK_SIZE);
+			dump_data = iwl_fw_error_next_data(dump_data);
 		}
 	}
 
-	dump_data = iwl_fw_error_next_data(dump_data);
 	if (prph_len)
 		iwl_dump_prph(mvm->trans, &dump_data);
 
-- 
2.5.0

