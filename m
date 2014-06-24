Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:51107 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaFXTwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:38 -0400
Received: by mail-wi0-f177.google.com with SMTP id r20so1255261wiv.16
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/27] iwlwifi: rename iwl_mvm_fw_error_next_data
Date: Tue, 24 Jun 2014 22:52:01 +0300
Message-Id: <1403639541-4621-7-git-send-email-egrumbach@gmail.com> (sfid-20140624_215244_507885_48D12B04)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

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
index 3ab33e2..7bb763f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -870,12 +870,12 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
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
 
@@ -895,7 +895,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	mvm->fw_error_sram_len = 0;
 
 	if (trans_len) {
-		void *buf = iwl_mvm_fw_error_next_data(dump_data);
+		void *buf = iwl_fw_error_next_data(dump_data);
 		u32 real_trans_len = iwl_trans_dump_data(mvm->trans, buf,
 							 trans_len);
 		dump_data = (void *)((u8 *)buf + real_trans_len);
-- 
1.8.3.2

