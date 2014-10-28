Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049AbaJ1GPz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 02:15:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 2/7] iwlwifi: rename iwl_mvm_fw_error_next_data
Date: Tue, 28 Oct 2014 08:11:21 +0200
Message-Id: <1414476686-3407-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141028_071610_454911_1DFE5C4D)
In-Reply-To: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 1fa1605648d15d42f350807279b6c6e8d33b6382 upstream.

This is not related to mvm. Rename to iwl_fw_error_next_data.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/ops.c           | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index aa0f85e..3584a75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -145,12 +145,12 @@ struct iwl_fw_error_dump_info {
 } __packed;
 
 /**
- * iwl_mvm_fw_error_next_data - advance fw error dump data pointer
+ * iwl_fw_error_next_data - advance fw error dump data pointer
  * @data: previous data block
  * Returns: next data block
  */
 static inline struct iwl_fw_error_dump_data *
-iwl_mvm_fw_error_next_data(struct iwl_fw_error_dump_data *data)
+iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
 {
 	return (void *)(data->data + le32_to_cpu(data->len));
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index d2fdd9f..2910f6d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -869,12 +869,12 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	strncpy(dump_info->bus_human_readable, mvm->dev->bus->name,
 		sizeof(dump_info->bus_human_readable));
 
-	dump_data = iwl_mvm_fw_error_next_data(dump_data);
+	dump_data = iwl_fw_error_next_data(dump_data);
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
 	dump_data->len = cpu_to_le32(mvm->fw_error_rxf_len);
 	memcpy(dump_data->data, mvm->fw_error_rxf, mvm->fw_error_rxf_len);
 
-	dump_data = iwl_mvm_fw_error_next_data(dump_data);
+	dump_data = iwl_fw_error_next_data(dump_data);
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_SRAM);
 	dump_data->len = cpu_to_le32(mvm->fw_error_sram_len);
 
@@ -894,7 +894,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	mvm->fw_error_sram_len = 0;
 
 	if (trans_len) {
-		void *buf = iwl_mvm_fw_error_next_data(dump_data);
+		void *buf = iwl_fw_error_next_data(dump_data);
 		u32 real_trans_len = iwl_trans_dump_data(mvm->trans, buf,
 							 trans_len);
 		dump_data = (void *)((u8 *)buf + real_trans_len);
-- 
1.9.1

