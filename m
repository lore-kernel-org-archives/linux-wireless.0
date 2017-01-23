Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36124 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751183AbdAWWEF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue, 24 Jan 2017 00:03:28 +0200
Message-Id: <20170123220350.25305-4-luca@coelho.fi> (sfid-20170123_230415_022909_32A5A2E5)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: mvm: accept arbitrary memory dump TLVs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to be validating the memory dump types, or
checking them for duplication, or anything, since we really
just pass them through from the TLV to the dump.

Thus, change the way we handle memory dump TLVs to let the
driver just blindly use anything specified there, dumping it
into the memory dump output file.

This makes the system extensible without driver changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 57 +++++++++---------------
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 18 +-------
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h      |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c  | 47 +++++++++----------
 4 files changed, 46 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 45b2f679e4d8..431581229948 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -179,8 +179,7 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 		kfree(drv->fw.dbg_conf_tlv[i]);
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++)
 		kfree(drv->fw.dbg_trigger_tlv[i]);
-	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_mem_tlv); i++)
-		kfree(drv->fw.dbg_mem_tlv[i]);
+	kfree(drv->fw.dbg_mem_tlv);
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
@@ -276,7 +275,8 @@ struct iwl_firmware_pieces {
 	size_t dbg_conf_tlv_len[FW_DBG_CONF_MAX];
 	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
 	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
-	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv[FW_DBG_MEM_MAX];
+	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv;
+	size_t n_dbg_mem_tlv;
 };
 
 /*
@@ -1009,31 +1009,25 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			struct iwl_fw_dbg_mem_seg_tlv *dbg_mem =
 				(void *)tlv_data;
 			u32 type;
+			size_t size;
+			struct iwl_fw_dbg_mem_seg_tlv *n;
 
 			if (tlv_len != (sizeof(*dbg_mem)))
 				goto invalid_tlv_len;
 
 			type = le32_to_cpu(dbg_mem->data_type);
-			drv->fw.dbg_dynamic_mem = true;
-
-			if (type >= ARRAY_SIZE(drv->fw.dbg_mem_tlv)) {
-				IWL_ERR(drv,
-					"Skip unknown dbg mem segment: %u\n",
-					dbg_mem->data_type);
-				break;
-			}
-
-			if (pieces->dbg_mem_tlv[type]) {
-				IWL_ERR(drv,
-					"Ignore duplicate mem segment: %u\n",
-					dbg_mem->data_type);
-				break;
-			}
 
 			IWL_DEBUG_INFO(drv, "Found debug memory segment: %u\n",
 				       dbg_mem->data_type);
 
-			pieces->dbg_mem_tlv[type] = dbg_mem;
+			size = sizeof(*pieces->dbg_mem_tlv) *
+			       (pieces->n_dbg_mem_tlv + 1);
+			n = krealloc(pieces->dbg_mem_tlv, size, GFP_KERNEL);
+			if (!n)
+				return -ENOMEM;
+			pieces->dbg_mem_tlv = n;
+			pieces->dbg_mem_tlv[pieces->n_dbg_mem_tlv] = *dbg_mem;
+			pieces->n_dbg_mem_tlv++;
 			break;
 			}
 		default:
@@ -1345,19 +1339,12 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_mem_tlv); i++) {
-		if (pieces->dbg_mem_tlv[i]) {
-			drv->fw.dbg_mem_tlv[i] =
-				kmemdup(pieces->dbg_mem_tlv[i],
-					sizeof(*drv->fw.dbg_mem_tlv[i]),
-					GFP_KERNEL);
-			if (!drv->fw.dbg_mem_tlv[i])
-				goto out_free_fw;
-		}
-	}
-
 	/* Now that we can no longer fail, copy information */
 
+	drv->fw.dbg_mem_tlv = pieces->dbg_mem_tlv;
+	pieces->dbg_mem_tlv = NULL;
+	drv->fw.n_dbg_mem_tlv = pieces->n_dbg_mem_tlv;
+
 	/*
 	 * The (size - 16) / 12 formula is based on the information recorded
 	 * for each event, which is of mode 1 (including timestamp) for all
@@ -1441,25 +1428,25 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
-	kfree(pieces);
-	return;
+	goto free;
 
  try_again:
 	/* try next, if any */
 	release_firmware(ucode_raw);
 	if (iwl_request_firmware(drv, false))
 		goto out_unbind;
-	kfree(pieces);
-	return;
+	goto free;
 
  out_free_fw:
 	IWL_ERR(drv, "failed to allocate pci memory\n");
 	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
-	kfree(pieces);
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
+ free:
+	kfree(pieces->dbg_mem_tlv);
+	kfree(pieces);
 }
 
 struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 84813b550ef1..11245b9117c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -489,25 +489,9 @@ enum iwl_fw_dbg_monitor_mode {
 };
 
 /**
- * enum iwl_fw_mem_seg_type - data types for dumping on error
- *
- * @FW_DBG_MEM_SMEM: the data type is SMEM
- * @FW_DBG_MEM_DCCM_LMAC: the data type is DCCM_LMAC
- * @FW_DBG_MEM_DCCM_UMAC: the data type is DCCM_UMAC
- */
-enum iwl_fw_dbg_mem_seg_type {
-	FW_DBG_MEM_DCCM_LMAC = 0,
-	FW_DBG_MEM_DCCM_UMAC,
-	FW_DBG_MEM_SMEM,
-
-	/* Must be last */
-	FW_DBG_MEM_MAX,
-};
-
-/**
  * struct iwl_fw_dbg_mem_seg_tlv - configures the debug data memory segments
  *
- * @data_type: enum %iwl_fw_mem_seg_type
+ * @data_type: the memory segment type to record
  * @ofs: the memory segment offset
  * @len: the memory segment length, in bytes
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 5f229556339a..710ecb490bfc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -295,8 +295,8 @@ struct iwl_fw {
 	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
 	size_t dbg_conf_tlv_len[FW_DBG_CONF_MAX];
 	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
-	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv[FW_DBG_MEM_MAX];
-	bool dbg_dynamic_mem;
+	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv;
+	size_t n_dbg_mem_tlv;
 	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
 	u8 dbg_dest_reg_num;
 	struct iwl_gscan_capabilities gscan_capa;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 2e8e3e8e30a3..46ab6b9f680b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -495,11 +495,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	struct scatterlist *sg_dump_data;
 	u32 sram_len, sram_ofs;
-	struct iwl_fw_dbg_mem_seg_tlv * const *fw_dbg_mem =
-		mvm->fw->dbg_mem_tlv;
+	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = mvm->fw->dbg_mem_tlv;
 	u32 file_len, fifo_data_len = 0, prph_len = 0, radio_len = 0;
-	u32 smem_len = mvm->fw->dbg_dynamic_mem ? 0 : mvm->cfg->smem_len;
-	u32 sram2_len = mvm->fw->dbg_dynamic_mem ? 0 : mvm->cfg->dccm2_len;
+	u32 smem_len = mvm->fw->n_dbg_mem_tlv ? 0 : mvm->cfg->smem_len;
+	u32 sram2_len = mvm->fw->n_dbg_mem_tlv ? 0 : mvm->cfg->dccm2_len;
 	bool monitor_dump_only = false;
 	int i;
 
@@ -624,10 +623,9 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
 
 	/* Make room for MEM segments */
-	for (i = 0; i < ARRAY_SIZE(mvm->fw->dbg_mem_tlv); i++) {
-		if (fw_dbg_mem[i])
-			file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
-				le32_to_cpu(fw_dbg_mem[i]->len);
+	for (i = 0; i < mvm->fw->n_dbg_mem_tlv; i++) {
+		file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
+			    le32_to_cpu(fw_dbg_mem[i].len);
 	}
 
 	/* Make room for fw's virtual image pages, if it exists */
@@ -656,7 +654,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    mvm->fw_dump_desc->len;
 
-	if (!mvm->fw->dbg_dynamic_mem)
+	if (!mvm->fw->n_dbg_mem_tlv)
 		file_len += sram_len + sizeof(*dump_mem);
 
 	dump_file = vzalloc(file_len);
@@ -708,7 +706,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (monitor_dump_only)
 		goto dump_trans_data;
 
-	if (!mvm->fw->dbg_dynamic_mem) {
+	if (!mvm->fw->n_dbg_mem_tlv) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
@@ -719,22 +717,19 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(mvm->fw->dbg_mem_tlv); i++) {
-		if (fw_dbg_mem[i]) {
-			u32 len = le32_to_cpu(fw_dbg_mem[i]->len);
-			u32 ofs = le32_to_cpu(fw_dbg_mem[i]->ofs);
-
-			dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-			dump_data->len = cpu_to_le32(len +
-					sizeof(*dump_mem));
-			dump_mem = (void *)dump_data->data;
-			dump_mem->type = fw_dbg_mem[i]->data_type;
-			dump_mem->offset = cpu_to_le32(ofs);
-			iwl_trans_read_mem_bytes(mvm->trans, ofs,
-						 dump_mem->data,
-						 len);
-			dump_data = iwl_fw_error_next_data(dump_data);
-		}
+	for (i = 0; i < mvm->fw->n_dbg_mem_tlv; i++) {
+		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
+		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
+
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		dump_data->len = cpu_to_le32(len + sizeof(*dump_mem));
+		dump_mem = (void *)dump_data->data;
+		dump_mem->type = fw_dbg_mem[i].data_type;
+		dump_mem->offset = cpu_to_le32(ofs);
+		iwl_trans_read_mem_bytes(mvm->trans, ofs,
+					 dump_mem->data,
+					 len);
+		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
 	if (smem_len) {
-- 
2.11.0
