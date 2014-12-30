Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaL3OTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/33] iwlwifi: mvm: convert the SRAM dump to the generic memory dump
Date: Tue, 30 Dec 2014 16:18:49 +0200
Message-Id: <1419949148-24046-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154350_813299_D8BDAFC6)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to add the offset. The type of the generic
memory dump will let the parser know that this is SRAM.

Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  3 +--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 17 +++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index c0fe82c..ec115bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -71,7 +71,6 @@
 
 /**
  * enum iwl_fw_error_dump_type - types of data in the dump file
- * @IWL_FW_ERROR_DUMP_SRAM:
  * @IWL_FW_ERROR_DUMP_CSR: Control Status Registers - from offset 0
  * @IWL_FW_ERROR_DUMP_RXF:
  * @IWL_FW_ERROR_DUMP_TXCMD: last TX command data, structured as
@@ -85,7 +84,7 @@
  * @IWL_FW_ERROR_DUMP_MEM: chunk of memory
  */
 enum iwl_fw_error_dump_type {
-	IWL_FW_ERROR_DUMP_SRAM = 0,
+	/* 0 is deprecated */
 	IWL_FW_ERROR_DUMP_CSR = 1,
 	IWL_FW_ERROR_DUMP_RXF = 2,
 	IWL_FW_ERROR_DUMP_TXCMD = 3,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e24de97..b2f4ea5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -769,6 +769,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
+	struct iwl_fw_error_dump_mem *dump_mem;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	u32 sram_len, sram_ofs;
 	u32 file_len, rxf_len;
@@ -809,14 +810,13 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	file_len = sizeof(*dump_file) +
 		   sizeof(*dump_data) * 3 +
-		   sram_len +
+		   sram_len + sizeof(*dump_mem) +
 		   rxf_len +
 		   sizeof(*dump_info);
 
 	/* Make room for the SMEM, if it exists */
 	if (smem_len)
-		file_len += sizeof(*dump_data) +
-			sizeof(struct iwl_fw_error_dump_mem) + smem_len;
+		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + smem_len;
 
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
@@ -863,14 +863,15 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	}
 
 	dump_data = iwl_fw_error_next_data(dump_data);
-	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_SRAM);
-	dump_data->len = cpu_to_le32(sram_len);
-	iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_data->data,
+	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+	dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
+	dump_mem = (void *)dump_data->data;
+	dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
+	dump_mem->offset = cpu_to_le32(sram_ofs);
+	iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_mem->data,
 				 sram_len);
 
 	if (smem_len) {
-		struct iwl_fw_error_dump_mem *dump_mem;
-
 		dump_data = iwl_fw_error_next_data(dump_data);
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
-- 
1.9.1

