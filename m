Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45288 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaGVT1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:42 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so116420wgg.24
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:41 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/20] iwlwifi: split fw-error-dump between transport and mvm
Date: Tue, 22 Jul 2014 22:26:46 +0300
Message-Id: <1406057211-31752-15-git-send-email-egrumbach@gmail.com> (sfid-20140722_212748_769672_994C6E4C)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The mvm op_mode won't allocate the buffer for the transport
any more. The transport allocates its own buffer and mvm
is in charge of splicing the buffers in the debugfs hook.

This makes the repartition easier to handle.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h    | 21 ++++++++-------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  | 40 +++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 31 +++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 17 +++++++++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  6 ++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c   | 19 +++++++++-----
 6 files changed, 95 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 34d49e1..656371a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -394,6 +394,11 @@ struct iwl_trans_config {
 	const char *const *command_names;
 };
 
+struct iwl_trans_dump_data {
+	u32 len;
+	u8 data[];
+};
+
 struct iwl_trans;
 
 /**
@@ -461,10 +466,8 @@ struct iwl_trans;
  * @unref: release a reference previously taken with @ref. Note that
  *	initially the reference count is 1, making an initial @unref
  *	necessary to allow low power states.
- * @dump_data: fill a data dump with debug data, maybe containing last
- *	TX'ed commands and similar. When called with a NULL buffer and
- *	zero buffer length, provide only the (estimated) required buffer
- *	length. Return the used buffer length.
+ * @dump_data: return a vmalloc'ed buffer with debug data, maybe containing last
+ *	TX'ed commands and similar. The buffer will be vfree'd by the caller.
  *	Note that the transport must fill in the proper file headers.
  */
 struct iwl_trans_ops {
@@ -518,7 +521,7 @@ struct iwl_trans_ops {
 	void (*unref)(struct iwl_trans *trans);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	u32 (*dump_data)(struct iwl_trans *trans, void *buf, u32 buflen);
+	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans);
 #endif
 };
 
@@ -685,12 +688,12 @@ static inline void iwl_trans_unref(struct iwl_trans *trans)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-static inline u32 iwl_trans_dump_data(struct iwl_trans *trans,
-				      void *buf, u32 buflen)
+static inline struct iwl_trans_dump_data *
+iwl_trans_dump_data(struct iwl_trans *trans)
 {
 	if (!trans->ops->dump_data)
-		return 0;
-	return trans->ops->dump_data(trans, buf, buflen);
+		return NULL;
+	return trans->ops->dump_data(trans);
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index b268259..7d18f46 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -146,17 +146,47 @@ static ssize_t iwl_dbgfs_fw_error_dump_read(struct file *file,
 					    char __user *user_buf,
 					    size_t count, loff_t *ppos)
 {
-	struct iwl_fw_error_dump_file *dump_file = file->private_data;
+	struct iwl_mvm_dump_ptrs *dump_ptrs = (void *)file->private_data;
+	ssize_t bytes_read = 0;
+	ssize_t bytes_read_trans = 0;
+
+	if (*ppos < dump_ptrs->op_mode_len)
+		bytes_read +=
+			simple_read_from_buffer(user_buf, count, ppos,
+						dump_ptrs->op_mode_ptr,
+						dump_ptrs->op_mode_len);
+
+	if (bytes_read < 0 || *ppos < dump_ptrs->op_mode_len)
+		return bytes_read;
+
+	if (dump_ptrs->trans_ptr) {
+		*ppos -= dump_ptrs->op_mode_len;
+		bytes_read_trans =
+			simple_read_from_buffer(user_buf + bytes_read,
+						count - bytes_read, ppos,
+						dump_ptrs->trans_ptr->data,
+						dump_ptrs->trans_ptr->len);
+		*ppos += dump_ptrs->op_mode_len;
+
+		if (bytes_read_trans >= 0)
+			bytes_read += bytes_read_trans;
+		else if (!bytes_read)
+			/* propagate the failure */
+			return bytes_read_trans;
+	}
+
+	return bytes_read;
 
-	return simple_read_from_buffer(user_buf, count, ppos,
-				       dump_file,
-				       le32_to_cpu(dump_file->file_len));
 }
 
 static int iwl_dbgfs_fw_error_dump_release(struct inode *inode,
 					   struct file *file)
 {
-	vfree(file->private_data);
+	struct iwl_mvm_dump_ptrs *dump_ptrs = (void *)file->private_data;
+
+	vfree(dump_ptrs->op_mode_ptr);
+	vfree(dump_ptrs->trans_ptr);
+	kfree(dump_ptrs);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 46ff7cd..bd924a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -676,11 +676,11 @@ static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
+	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	const struct fw_img *img;
 	u32 sram_len, sram_ofs;
 	u32 file_len, rxf_len;
 	unsigned long flags;
-	u32 trans_len;
 	int reg_val;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -688,6 +688,10 @@ static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (mvm->fw_error_dump)
 		return;
 
+	fw_error_dump = kzalloc(sizeof(*mvm->fw_error_dump), GFP_KERNEL);
+	if (!fw_error_dump)
+		return;
+
 	img = &mvm->fw->img[mvm->cur_ucode];
 	sram_ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
 	sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
@@ -705,18 +709,15 @@ static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		   rxf_len +
 		   sizeof(*dump_info);
 
-	trans_len = iwl_trans_dump_data(mvm->trans, NULL, 0);
-	if (trans_len)
-		file_len += trans_len;
-
 	dump_file = vzalloc(file_len);
-	if (!dump_file)
+	if (!dump_file) {
+		kfree(fw_error_dump);
 		return;
+	}
 
-	mvm->fw_error_dump = dump_file;
+	fw_error_dump->op_mode_ptr = dump_file;
 
 	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
-	dump_file->file_len = cpu_to_le32(file_len);
 	dump_data = (void *)dump_file->data;
 
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_DEV_FW_INFO);
@@ -757,14 +758,12 @@ static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_data->data,
 				 sram_len);
 
-	if (trans_len) {
-		void *buf = iwl_fw_error_next_data(dump_data);
-		u32 real_trans_len = iwl_trans_dump_data(mvm->trans, buf,
-							 trans_len);
-		dump_data = (void *)((u8 *)buf + real_trans_len);
-		dump_file->file_len =
-			cpu_to_le32(file_len - trans_len + real_trans_len);
-	}
+	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans);
+	fw_error_dump->op_mode_len = file_len;
+	if (fw_error_dump->trans_ptr)
+		file_len += fw_error_dump->trans_ptr->len;
+	dump_file->file_len = cpu_to_le32(file_len);
+	mvm->fw_error_dump = fw_error_dump;
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5b17fdf..2e73d3b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -128,6 +128,21 @@ struct iwl_mvm_mod_params {
 };
 extern struct iwl_mvm_mod_params iwlmvm_mod_params;
 
+/**
+ * struct iwl_mvm_dump_ptrs - set of pointers needed for the fw-error-dump
+ *
+ * @op_mode_ptr: pointer to the buffer coming from the mvm op_mode
+ * @trans_ptr: pointer to struct %iwl_trans_dump_data which contains the
+ *	transport's data.
+ * @trans_len: length of the valid data in trans_ptr
+ * @op_mode_len: length of the valid data in op_mode_ptr
+ */
+struct iwl_mvm_dump_ptrs {
+	struct iwl_trans_dump_data *trans_ptr;
+	void *op_mode_ptr;
+	u32 op_mode_len;
+};
+
 struct iwl_mvm_phy_ctxt {
 	u16 id;
 	u16 color;
@@ -626,7 +641,7 @@ struct iwl_mvm {
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
-	void *fw_error_dump;
+	struct iwl_mvm_dump_ptrs *fw_error_dump;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 904228a..610dbcb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -573,7 +573,11 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	ieee80211_unregister_hw(mvm->hw);
 
 	kfree(mvm->scan_cmd);
-	vfree(mvm->fw_error_dump);
+	if (mvm->fw_error_dump) {
+		vfree(mvm->fw_error_dump->op_mode_ptr);
+		vfree(mvm->fw_error_dump->trans_ptr);
+		kfree(mvm->fw_error_dump);
+	}
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 5b5b0d8..a90292c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -67,6 +67,7 @@
 #include <linux/sched.h>
 #include <linux/bitops.h>
 #include <linux/gfp.h>
+#include <linux/vmalloc.h>
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
@@ -1773,28 +1774,30 @@ static u32 iwl_trans_pcie_get_cmdlen(struct iwl_tfd *tfd)
 	return cmdlen;
 }
 
-static u32 iwl_trans_pcie_dump_data(struct iwl_trans *trans,
-				    void *buf, u32 buflen)
+static
+struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_fw_error_dump_data *data;
 	struct iwl_txq *cmdq = &trans_pcie->txq[trans_pcie->cmd_queue];
 	struct iwl_fw_error_dump_txcmd *txcmd;
+	struct iwl_trans_dump_data *dump_data;
 	u32 len;
 	int i, ptr;
 
-	len = sizeof(*data) +
+	len = sizeof(*dump_data) + sizeof(*data) +
 		cmdq->q.n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
 
 	if (trans_pcie->fw_mon_page)
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
 			trans_pcie->fw_mon_size;
 
-	if (!buf)
-		return len;
+	dump_data = vzalloc(len);
+	if (!dump_data)
+		return NULL;
 
 	len = 0;
-	data = buf;
+	data = (void *)dump_data->data;
 	data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXCMD);
 	txcmd = (void *)data->data;
 	spin_lock_bh(&cmdq->lock);
@@ -1852,7 +1855,9 @@ static u32 iwl_trans_pcie_dump_data(struct iwl_trans *trans,
 			trans_pcie->fw_mon_size;
 	}
 
-	return len;
+	dump_data->len = len;
+
+	return dump_data;
 }
 #else
 static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-- 
1.8.3.2

