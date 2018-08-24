Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43966 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOFD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:05:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:18 +0300
Message-Id: <20180824103018.15011-17-luca@coelho.fi> (sfid-20180824_123107_489935_B40C4D0B)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 16/16] Revert "iwlwifi: allow memory debug TLV to specify the memory type"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts the addition of memory type in the memory debug TLV
as the firmware never ended up implementing it, and now the PRPH
dump is added as a different TLV.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c  | 55 ++++----------------
 drivers/net/wireless/intel/iwlwifi/fw/file.h | 15 +-----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 15 ------
 3 files changed, 12 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 3435a83e4d18..9963d6c84908 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -455,8 +455,8 @@ static const struct iwl_prph_range iwl_prph_dump_addr_9000[] = {
 	{ .start = 0x00a02400, .end = 0x00a02758 },
 };
 
-static void _iwl_read_prph_block(struct iwl_trans *trans, u32 start,
-				 u32 len_bytes, __le32 *data)
+static void iwl_read_prph_block(struct iwl_trans *trans, u32 start,
+				u32 len_bytes, __le32 *data)
 {
 	u32 i;
 
@@ -464,21 +464,6 @@ static void _iwl_read_prph_block(struct iwl_trans *trans, u32 start,
 		*data++ = cpu_to_le32(iwl_read_prph_no_grab(trans, start + i));
 }
 
-static bool iwl_read_prph_block(struct iwl_trans *trans, u32 start,
-				u32 len_bytes, __le32 *data)
-{
-	unsigned long flags;
-	bool success = false;
-
-	if (iwl_trans_grab_nic_access(trans, &flags)) {
-		success = true;
-		_iwl_read_prph_block(trans, start, len_bytes, data);
-		iwl_trans_release_nic_access(trans, &flags);
-	}
-
-	return success;
-}
-
 static void iwl_dump_prph(struct iwl_trans *trans,
 			  struct iwl_fw_error_dump_data **data,
 			  const struct iwl_prph_range *iwl_prph_dump_addr,
@@ -504,11 +489,11 @@ static void iwl_dump_prph(struct iwl_trans *trans,
 		prph = (void *)(*data)->data;
 		prph->prph_start = cpu_to_le32(iwl_prph_dump_addr[i].start);
 
-		_iwl_read_prph_block(trans, iwl_prph_dump_addr[i].start,
-				     /* our range is inclusive, hence + 4 */
-				     iwl_prph_dump_addr[i].end -
-				     iwl_prph_dump_addr[i].start + 4,
-				     (void *)prph->data);
+		iwl_read_prph_block(trans, iwl_prph_dump_addr[i].start,
+				    /* our range is inclusive, hence + 4 */
+				    iwl_prph_dump_addr[i].end -
+				    iwl_prph_dump_addr[i].start + 4,
+				    (void *)prph->data);
 
 		*data = iwl_fw_error_next_data(*data);
 	}
@@ -883,7 +868,6 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
 		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
 		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
-		bool success;
 
 		if (!(fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)))
 			break;
@@ -897,28 +881,11 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n",
 			       dump_mem->type);
 
-		switch (dump_mem->type & cpu_to_le32(FW_DBG_MEM_TYPE_MASK)) {
-		case cpu_to_le32(FW_DBG_MEM_TYPE_REGULAR):
-			iwl_trans_read_mem_bytes(fwrt->trans, ofs,
-						 dump_mem->data,
-						 len);
-			success = true;
-			break;
-		case cpu_to_le32(FW_DBG_MEM_TYPE_PRPH):
-			success = iwl_read_prph_block(fwrt->trans, ofs, len,
-						      (void *)dump_mem->data);
-			break;
-		default:
-			/*
-			 * shouldn't get here, we ignored this kind
-			 * of TLV earlier during the TLV parsing?!
-			 */
-			WARN_ON(1);
-			success = false;
-		}
+		iwl_trans_read_mem_bytes(fwrt->trans, ofs,
+					 dump_mem->data,
+					 len);
 
-		if (success)
-			dump_data = iwl_fw_error_next_data(dump_data);
+		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
 	if (smem_len && fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 858af103e6fd..335b8bde3dcd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -532,23 +532,10 @@ enum iwl_fw_dbg_monitor_mode {
 	MIPI_MODE = 3,
 };
 
-/**
- * enum iwl_fw_mem_seg_type - memory segment type
- * @FW_DBG_MEM_TYPE_MASK: mask for the type indication
- * @FW_DBG_MEM_TYPE_REGULAR: regular memory
- * @FW_DBG_MEM_TYPE_PRPH: periphery memory (requires special reading)
- */
-enum iwl_fw_mem_seg_type {
-	FW_DBG_MEM_TYPE_MASK	= 0xff000000,
-	FW_DBG_MEM_TYPE_REGULAR	= 0x00000000,
-	FW_DBG_MEM_TYPE_PRPH	= 0x01000000,
-};
-
 /**
  * struct iwl_fw_dbg_mem_seg_tlv - configures the debug data memory segments
  *
- * @data_type: the memory segment type to record, see &enum iwl_fw_mem_seg_type
- *	for what we care about
+ * @data_type: the memory segment type to record
  * @ofs: the memory segment offset
  * @len: the memory segment length, in bytes
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 76f50b99af2a..d3a60d1aacb5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1060,30 +1060,15 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		case IWL_UCODE_TLV_FW_MEM_SEG: {
 			struct iwl_fw_dbg_mem_seg_tlv *dbg_mem =
 				(void *)tlv_data;
-			u32 type;
 			size_t size;
 			struct iwl_fw_dbg_mem_seg_tlv *n;
 
 			if (tlv_len != (sizeof(*dbg_mem)))
 				goto invalid_tlv_len;
 
-			type = le32_to_cpu(dbg_mem->data_type);
-
 			IWL_DEBUG_INFO(drv, "Found debug memory segment: %u\n",
 				       dbg_mem->data_type);
 
-			switch (type & FW_DBG_MEM_TYPE_MASK) {
-			case FW_DBG_MEM_TYPE_REGULAR:
-			case FW_DBG_MEM_TYPE_PRPH:
-				/* we know how to handle these */
-				break;
-			default:
-				IWL_ERR(drv,
-					"Found debug memory segment with invalid type: 0x%x\n",
-					type);
-				return -EINVAL;
-			}
-
 			size = sizeof(*pieces->dbg_mem_tlv) *
 			       (pieces->n_dbg_mem_tlv + 1);
 			n = krealloc(pieces->dbg_mem_tlv, size, GFP_KERNEL);
-- 
2.18.0
