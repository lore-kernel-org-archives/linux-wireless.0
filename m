Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36134 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751445AbdAWWEF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue, 24 Jan 2017 00:03:30 +0200
Message-Id: <20170123220350.25305-6-luca@coelho.fi> (sfid-20170123_230419_911598_3D48B492)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: allow memory debug TLV to specify the memory type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to some new features and changes, the firmware file will now
specify what type of memory to dump, in upper 8 bits of the type
field of the TLV. Parse it (types we don't understand are errors)
and teach the code to dump periphery memory.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 12 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 15 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c  | 65 +++++++++++++++++++-----
 3 files changed, 79 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 431581229948..a6719d67ac00 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1020,6 +1020,18 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			IWL_DEBUG_INFO(drv, "Found debug memory segment: %u\n",
 				       dbg_mem->data_type);
 
+			switch (type & FW_DBG_MEM_TYPE_MASK) {
+			case FW_DBG_MEM_TYPE_REGULAR:
+			case FW_DBG_MEM_TYPE_PRPH:
+				/* we know how to handle these */
+				break;
+			default:
+				IWL_ERR(drv,
+					"Found debug memory segment with invalid type: 0x%x\n",
+					type);
+				return -EINVAL;
+			}
+
 			size = sizeof(*pieces->dbg_mem_tlv) *
 			       (pieces->n_dbg_mem_tlv + 1);
 			n = krealloc(pieces->dbg_mem_tlv, size, GFP_KERNEL);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 11245b9117c7..c84207576587 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -489,9 +489,22 @@ enum iwl_fw_dbg_monitor_mode {
 };
 
 /**
+ * enum iwl_fw_mem_seg_type - memory segment type
+ * @FW_DBG_MEM_TYPE_MASK: mask for the type indication
+ * @FW_DBG_MEM_TYPE_REGULAR: regular memory
+ * @FW_DBG_MEM_TYPE_PRPH: periphery memory (requires special reading)
+ */
+enum iwl_fw_mem_seg_type {
+	FW_DBG_MEM_TYPE_MASK	= 0xff000000,
+	FW_DBG_MEM_TYPE_REGULAR	= 0x00000000,
+	FW_DBG_MEM_TYPE_PRPH	= 0x01000000,
+};
+
+/**
  * struct iwl_fw_dbg_mem_seg_tlv - configures the debug data memory segments
  *
- * @data_type: the memory segment type to record
+ * @data_type: the memory segment type to record, see &enum iwl_fw_mem_seg_type
+ *	for what we care about
  * @ofs: the memory segment offset
  * @len: the memory segment length, in bytes
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 7df3c3f4749e..10f2c6e4056a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -406,6 +406,30 @@ static const struct iwl_prph_range iwl_prph_dump_addr_9000[] = {
 	{ .start = 0x00a02400, .end = 0x00a02758 },
 };
 
+static void _iwl_read_prph_block(struct iwl_trans *trans, u32 start,
+				 u32 len_bytes, __le32 *data)
+{
+	u32 i;
+
+	for (i = 0; i < len_bytes / 4; i++)
+		*data++ = cpu_to_le32(iwl_read_prph_no_grab(trans, start + i));
+}
+
+static bool iwl_read_prph_block(struct iwl_trans *trans, u32 start,
+				u32 len_bytes, __le32 *data)
+{
+	unsigned long flags;
+	bool success = false;
+
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
+		success = true;
+		_iwl_read_prph_block(trans, start, len_bytes, data);
+		iwl_trans_release_nic_access(trans, &flags);
+	}
+
+	return success;
+}
+
 static void iwl_dump_prph(struct iwl_trans *trans,
 			  struct iwl_fw_error_dump_data **data,
 			  const struct iwl_prph_range *iwl_prph_dump_addr,
@@ -422,21 +446,18 @@ static void iwl_dump_prph(struct iwl_trans *trans,
 		/* The range includes both boundaries */
 		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
 			 iwl_prph_dump_addr[i].start + 4;
-		int reg;
-		__le32 *val;
 
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
 		(*data)->len = cpu_to_le32(sizeof(*prph) +
 					num_bytes_in_chunk);
 		prph = (void *)(*data)->data;
 		prph->prph_start = cpu_to_le32(iwl_prph_dump_addr[i].start);
-		val = (void *)prph->data;
 
-		for (reg = iwl_prph_dump_addr[i].start;
-		     reg <= iwl_prph_dump_addr[i].end;
-		     reg += 4)
-			*val++ = cpu_to_le32(iwl_read_prph_no_grab(trans,
-								   reg));
+		_iwl_read_prph_block(trans, iwl_prph_dump_addr[i].start,
+				     /* our range is inclusive, hence + 4 */
+				     iwl_prph_dump_addr[i].end -
+				     iwl_prph_dump_addr[i].start + 4,
+				     (void *)prph->data);
 
 		*data = iwl_fw_error_next_data(*data);
 	}
@@ -716,16 +737,36 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	for (i = 0; i < mvm->fw->n_dbg_mem_tlv; i++) {
 		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
 		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
+		bool success;
 
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
 		dump_mem->type = fw_dbg_mem[i].data_type;
 		dump_mem->offset = cpu_to_le32(ofs);
-		iwl_trans_read_mem_bytes(mvm->trans, ofs,
-					 dump_mem->data,
-					 len);
-		dump_data = iwl_fw_error_next_data(dump_data);
+
+		switch (dump_mem->type & cpu_to_le32(FW_DBG_MEM_TYPE_MASK)) {
+		case cpu_to_le32(FW_DBG_MEM_TYPE_REGULAR):
+			iwl_trans_read_mem_bytes(mvm->trans, ofs,
+						 dump_mem->data,
+						 len);
+			success = true;
+			break;
+		case cpu_to_le32(FW_DBG_MEM_TYPE_PRPH):
+			success = iwl_read_prph_block(mvm->trans, ofs, len,
+						      (void *)dump_mem->data);
+			break;
+		default:
+			/*
+			 * shouldn't get here, we ignored this kind
+			 * of TLV earlier during the TLV parsing?!
+			 */
+			WARN_ON(1);
+			success = false;
+		}
+
+		if (success)
+			dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
 	if (smem_len) {
-- 
2.11.0
