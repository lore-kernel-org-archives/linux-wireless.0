Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaL3OTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/33] iwlwifi: mvm: change SMEM dump to general purpose memory dump
Date: Tue, 30 Dec 2014 16:18:48 +0200
Message-Id: <1419949148-24046-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154350_661081_39FEE3A4)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of adding a dump type for each type of memory, change
the SMEM type to be a general purpose memory dump. Add the
type of the memory and its offset in the device in the dump
itself. This will allow an external parser to know where
this memory came from.

Note that since this type isn't really in use yet, this is
not a real problem.

Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 21 +++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 14 ++++++++++----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index c6a81a7..c0fe82c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -82,7 +82,7 @@
  * @IWL_FW_ERROR_DUMP_PRPH: range of periphery registers - there can be several
  *	sections like this in a single file.
  * @IWL_FW_ERROR_DUMP_FH_REGS: range of FH registers
- * @IWL_FW_ERROR_DUMP_SMEM:
+ * @IWL_FW_ERROR_DUMP_MEM: chunk of memory
  */
 enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_SRAM = 0,
@@ -94,7 +94,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_PRPH = 6,
 	IWL_FW_ERROR_DUMP_TXF = 7,
 	IWL_FW_ERROR_DUMP_FH_REGS = 8,
-	IWL_FW_ERROR_DUMP_SMEM = 9,
+	IWL_FW_ERROR_DUMP_MEM = 9,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
@@ -182,6 +182,23 @@ struct iwl_fw_error_dump_prph {
 	__le32 data[];
 };
 
+enum iwl_fw_error_dump_mem_type {
+	IWL_FW_ERROR_DUMP_MEM_SRAM,
+	IWL_FW_ERROR_DUMP_MEM_SMEM,
+};
+
+/**
+ * struct iwl_fw_error_dump_mem - chunk of memory
+ * @type: %enum iwl_fw_error_dump_mem_type
+ * @offset: the offset from which the memory was read
+ * @data: the content of the memory
+ */
+struct iwl_fw_error_dump_mem {
+	__le32 type;
+	__le32 offset;
+	u8 data[];
+};
+
 /**
  * iwl_fw_error_next_data - advance fw error dump data pointer
  * @data: previous data block
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index d5d1cda..e24de97 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -815,7 +815,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	/* Make room for the SMEM, if it exists */
 	if (smem_len)
-		file_len += sizeof(*dump_data) + smem_len;
+		file_len += sizeof(*dump_data) +
+			sizeof(struct iwl_fw_error_dump_mem) + smem_len;
 
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
@@ -868,11 +869,16 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 				 sram_len);
 
 	if (smem_len) {
+		struct iwl_fw_error_dump_mem *dump_mem;
+
 		dump_data = iwl_fw_error_next_data(dump_data);
-		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_SMEM);
-		dump_data->len = cpu_to_le32(smem_len);
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		dump_data->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
+		dump_mem = (void *)dump_data->data;
+		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SMEM);
+		dump_mem->offset = cpu_to_le32(mvm->cfg->smem_offset);
 		iwl_trans_read_mem_bytes(mvm->trans, mvm->cfg->smem_offset,
-					 dump_data->data, smem_len);
+					 dump_mem->data, smem_len);
 	}
 
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans);
-- 
1.9.1

