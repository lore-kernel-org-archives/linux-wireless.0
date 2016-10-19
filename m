Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50214 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S942566AbcJSPSa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Aviya Erenfeld <aviya.erenfeld@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:55 +0300
Message-Id: <20161019100755.23874-11-luca@coelho.fi> (sfid-20161019_171834_075034_345D0F62)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 10/10] iwlwifi: mvm: use dev_coredumpsg()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

iwlmvm currently uses dev_coredumpm() to collect multiple
buffers, but this has the downside of pinning the module
until the coredump expires, if the data isn't read by any
userspace.

Avoid this by using the new dev_coredumpsg() method. We
still copy the data from the old way of generating it, but
neither hold on to vmalloc'ed data for a long time, nor do
we pin the module now.

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
[rewrite commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 100 +++++++++++++-----------
 1 file changed, 55 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index d89d0a1..2e8e3e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -70,49 +70,6 @@
 #include "iwl-prph.h"
 #include "iwl-csr.h"
 
-static ssize_t iwl_mvm_read_coredump(char *buffer, loff_t offset, size_t count,
-				     void *data, size_t datalen)
-{
-	const struct iwl_mvm_dump_ptrs *dump_ptrs = data;
-	ssize_t bytes_read;
-	ssize_t bytes_read_trans;
-
-	if (offset < dump_ptrs->op_mode_len) {
-		bytes_read = min_t(ssize_t, count,
-				   dump_ptrs->op_mode_len - offset);
-		memcpy(buffer, (u8 *)dump_ptrs->op_mode_ptr + offset,
-		       bytes_read);
-		offset += bytes_read;
-		count -= bytes_read;
-
-		if (count == 0)
-			return bytes_read;
-	} else {
-		bytes_read = 0;
-	}
-
-	if (!dump_ptrs->trans_ptr)
-		return bytes_read;
-
-	offset -= dump_ptrs->op_mode_len;
-	bytes_read_trans = min_t(ssize_t, count,
-				 dump_ptrs->trans_ptr->len - offset);
-	memcpy(buffer + bytes_read,
-	       (u8 *)dump_ptrs->trans_ptr->data + offset,
-	       bytes_read_trans);
-
-	return bytes_read + bytes_read_trans;
-}
-
-static void iwl_mvm_free_coredump(void *data)
-{
-	const struct iwl_mvm_dump_ptrs *fw_error_dump = data;
-
-	vfree(fw_error_dump->op_mode_ptr);
-	vfree(fw_error_dump->trans_ptr);
-	kfree(fw_error_dump);
-}
-
 #define RADIO_REG_MAX_READ 0x2ad
 static void iwl_mvm_read_radio_reg(struct iwl_mvm *mvm,
 				   struct iwl_fw_error_dump_data **dump_data)
@@ -491,6 +448,43 @@ static u32 iwl_dump_prph(struct iwl_trans *trans,
 	return prph_len;
 }
 
+/*
+ * alloc_sgtable - allocates scallerlist table in the given size,
+ * fills it with pages and returns it
+ * @size: the size (in bytes) of the table
+*/
+static struct scatterlist *alloc_sgtable(int size)
+{
+	int alloc_size, nents, i;
+	struct page *new_page;
+	struct scatterlist *iter;
+	struct scatterlist *table;
+
+	nents = DIV_ROUND_UP(size, PAGE_SIZE);
+	table = kcalloc(nents, sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return NULL;
+	sg_init_table(table, nents);
+	iter = table;
+	for_each_sg(table, iter, sg_nents(table), i) {
+		new_page = alloc_page(GFP_KERNEL);
+		if (!new_page) {
+			/* release all previous allocated pages in the table */
+			iter = table;
+			for_each_sg(table, iter, sg_nents(table), i) {
+				new_page = sg_page(iter);
+				if (new_page)
+					__free_page(new_page);
+			}
+			return NULL;
+		}
+		alloc_size = min_t(int, size, PAGE_SIZE);
+		size -= PAGE_SIZE;
+		sg_set_page(iter, new_page, alloc_size, 0);
+	}
+	return table;
+}
+
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
 	struct iwl_fw_error_dump_file *dump_file;
@@ -499,6 +493,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_mem *dump_mem;
 	struct iwl_fw_error_dump_trigger_desc *dump_trig;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
+	struct scatterlist *sg_dump_data;
 	u32 sram_len, sram_ofs;
 	struct iwl_fw_dbg_mem_seg_tlv * const *fw_dbg_mem =
 		mvm->fw->dbg_mem_tlv;
@@ -815,8 +810,23 @@ dump_trans_data:
 		file_len += fw_error_dump->trans_ptr->len;
 	dump_file->file_len = cpu_to_le32(file_len);
 
-	dev_coredumpm(mvm->trans->dev, THIS_MODULE, fw_error_dump, 0,
-		      GFP_KERNEL, iwl_mvm_read_coredump, iwl_mvm_free_coredump);
+	sg_dump_data = alloc_sgtable(file_len);
+	if (sg_dump_data) {
+		sg_pcopy_from_buffer(sg_dump_data,
+				     sg_nents(sg_dump_data),
+				     fw_error_dump->op_mode_ptr,
+				     fw_error_dump->op_mode_len, 0);
+		sg_pcopy_from_buffer(sg_dump_data,
+				     sg_nents(sg_dump_data),
+				     fw_error_dump->trans_ptr->data,
+				     fw_error_dump->trans_ptr->len,
+				     fw_error_dump->op_mode_len);
+		dev_coredumpsg(mvm->trans->dev, sg_dump_data, file_len,
+			       GFP_KERNEL);
+	}
+	vfree(fw_error_dump->op_mode_ptr);
+	vfree(fw_error_dump->trans_ptr);
+	kfree(fw_error_dump);
 
 out:
 	iwl_mvm_free_fw_dump_desc(mvm);
-- 
2.9.3
