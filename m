Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMBY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/16] iwlwifi: mvm: Dump FW's virtual image in the case of a NIC error
Date: Sun, 25 Oct 2015 14:01:02 +0200
Message-Id: <1445774476-24792-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130127_311773_41CAC59C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

When paging is enabled the driver stores part of the FW's
image in the DRAM.

Dump FW's virtual image in the case of a NIC error.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 16 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 27 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index af5b320..9dbe19c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -86,6 +86,8 @@
  *	Structured as &struct iwl_fw_error_dump_trigger_desc.
  * @IWL_FW_ERROR_DUMP_RB: the content of an RB structured as
  *	&struct iwl_fw_error_dump_rb
+ * @IWL_FW_ERROR_PAGING: UMAC's image memory segments which were
+ *	paged to the DRAM.
  */
 enum iwl_fw_error_dump_type {
 	/* 0 is deprecated */
@@ -100,6 +102,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_MEM = 9,
 	IWL_FW_ERROR_DUMP_ERROR_INFO = 10,
 	IWL_FW_ERROR_DUMP_RB = 11,
+	IWL_FW_ERROR_DUMP_PAGING = 12,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
@@ -240,6 +243,19 @@ struct iwl_fw_error_dump_rb {
 };
 
 /**
+ * struct iwl_fw_error_dump_paging - content of the UMAC's image page
+ *	block on DRAM
+ * @index: the index of the page block
+ * @reserved:
+ * @data: the content of the page block
+ */
+struct iwl_fw_error_dump_paging {
+	__le32 index;
+	__le32 reserved;
+	u8 data[];
+};
+
+/**
  * iwl_fw_error_next_data - advance fw error dump data pointer
  * @data: previous data block
  * Returns: next data block
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8443e14..aaffb54 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1192,6 +1192,13 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (sram2_len)
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
 
+	/* Make room for fw's virtual image pages, if it exists */
+	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size)
+		file_len += mvm->num_of_paging_blk *
+			(sizeof(*dump_data) +
+			 sizeof(struct iwl_fw_error_dump_paging) +
+			 PAGING_BLOCK_SIZE);
+
 	/* If we only want a monitor dump, reset the file length */
 	if (monitor_dump_only) {
 		file_len = sizeof(*dump_file) + sizeof(*dump_data) +
@@ -1302,6 +1309,26 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 					 dump_mem->data, IWL8260_ICCM_LEN);
 	}
 
+	/* Dump fw's virtual image */
+	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size) {
+		u32 i;
+
+		for (i = 1; i < mvm->num_of_paging_blk + 1; i++) {
+			struct iwl_fw_error_dump_paging *paging;
+			struct page *pages =
+				mvm->fw_paging_db[i].fw_paging_block;
+
+			dump_data = iwl_fw_error_next_data(dump_data);
+			dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
+			dump_data->len = cpu_to_le32(sizeof(*paging) +
+						     PAGING_BLOCK_SIZE);
+			paging = (void *)dump_data->data;
+			paging->index = cpu_to_le32(i);
+			memcpy(paging->data, page_address(pages),
+			       PAGING_BLOCK_SIZE);
+		}
+	}
+
 dump_trans_data:
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans,
 						       mvm->fw_dump_trig);
-- 
2.1.4

