Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:43750 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaEGTyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:54:04 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so1484990wes.6
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:54:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/23] iwlwifi: mvm/pcie: capture last commands on firmware error
Date: Wed,  7 May 2014 22:52:55 +0300
Message-Id: <1399492380-12050-18-git-send-email-egrumbach@gmail.com> (sfid-20140507_215430_699411_C0AAA8E5)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a firmware error occurs, capture the last 32 commands
(which are still in memory) in the error dump debugfs file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 134 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |  19 ++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h | 108 ------------------
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  18 ++-
 drivers/net/wireless/iwlwifi/pcie/internal.h     |   7 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c        |  60 ++++++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c           |  40 ++++---
 8 files changed, 259 insertions(+), 129 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
 delete mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
new file mode 100644
index 0000000..2953ffc
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -0,0 +1,134 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+
+#ifndef __fw_error_dump_h__
+#define __fw_error_dump_h__
+
+#include <linux/types.h>
+
+#define IWL_FW_ERROR_DUMP_BARKER	0x14789632
+
+/**
+ * enum iwl_fw_error_dump_type - types of data in the dump file
+ * @IWL_FW_ERROR_DUMP_SRAM:
+ * @IWL_FW_ERROR_DUMP_REG:
+ * @IWL_FW_ERROR_DUMP_RXF:
+ * @IWL_FW_ERROR_DUMP_TXCMD: last TX command data, structured as
+ *	&struct iwl_fw_error_dump_txcmd packets
+ */
+enum iwl_fw_error_dump_type {
+	IWL_FW_ERROR_DUMP_SRAM = 0,
+	IWL_FW_ERROR_DUMP_REG = 1,
+	IWL_FW_ERROR_DUMP_RXF = 2,
+	IWL_FW_ERROR_DUMP_TXCMD = 3,
+
+	IWL_FW_ERROR_DUMP_MAX,
+};
+
+/**
+ * struct iwl_fw_error_dump_data - data for one type
+ * @type: %enum iwl_fw_error_dump_type
+ * @len: the length starting from %data - must be a multiplier of 4.
+ * @data: the data itself padded to be a multiplier of 4.
+ */
+struct iwl_fw_error_dump_data {
+	__le32 type;
+	__le32 len;
+	__u8 data[];
+} __packed;
+
+/**
+ * struct iwl_fw_error_dump_file - the layout of the header of the file
+ * @barker: must be %IWL_FW_ERROR_DUMP_BARKER
+ * @file_len: the length of all the file starting from %barker
+ * @data: array of %struct iwl_fw_error_dump_data
+ */
+struct iwl_fw_error_dump_file {
+	__le32 barker;
+	__le32 file_len;
+	u8 data[0];
+} __packed;
+
+/**
+ * struct iwl_fw_error_dump_txcmd - TX command data
+ * @cmdlen: original length of command
+ * @caplen: captured length of command (may be less)
+ * @data: captured command data, @caplen bytes
+ */
+struct iwl_fw_error_dump_txcmd {
+	__le32 cmdlen;
+	__le32 caplen;
+	u8 data[];
+} __packed;
+
+/**
+ * iwl_mvm_fw_error_next_data - advance fw error dump data pointer
+ * @data: previous data block
+ * Returns: next data block
+ */
+static inline struct iwl_fw_error_dump_data *
+iwl_mvm_fw_error_next_data(struct iwl_fw_error_dump_data *data)
+{
+	return (void *)(data->data + le32_to_cpu(data->len));
+}
+
+#endif /* __fw_error_dump_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 22fd94e..84ad48d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -463,6 +463,11 @@ struct iwl_trans;
  * @unref: release a reference previously taken with @ref. Note that
  *	initially the reference count is 1, making an initial @unref
  *	necessary to allow low power states.
+ * @dump_data: fill a data dump with debug data, maybe containing last
+ *	TX'ed commands and similar. When called with a NULL buffer and
+ *	zero buffer length, provide only the (estimated) required buffer
+ *	length. Return the used buffer length.
+ *	Note that the transport must fill in the proper file headers.
  */
 struct iwl_trans_ops {
 
@@ -511,6 +516,10 @@ struct iwl_trans_ops {
 			      u32 value);
 	void (*ref)(struct iwl_trans *trans);
 	void (*unref)(struct iwl_trans *trans);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	u32 (*dump_data)(struct iwl_trans *trans, void *buf, u32 buflen);
+#endif
 };
 
 /**
@@ -664,6 +673,16 @@ static inline void iwl_trans_unref(struct iwl_trans *trans)
 		trans->ops->unref(trans);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+static inline u32 iwl_trans_dump_data(struct iwl_trans *trans,
+				      void *buf, u32 buflen)
+{
+	if (!trans->ops->dump_data)
+		return 0;
+	return trans->ops->dump_data(trans, buf, buflen);
+}
+#endif
+
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				     struct iwl_host_cmd *cmd)
 {
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f462c9b..bef487b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -67,7 +67,7 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 #include "debugfs.h"
-#include "fw-error-dump.h"
+#include "iwl-fw-error-dump.h"
 
 static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 					size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h b/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
deleted file mode 100644
index f381908..0000000
--- a/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
+++ /dev/null
@@ -1,108 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2014 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called COPYING.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2014 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *****************************************************************************/
-
-#ifndef __fw_error_dump_h__
-#define __fw_error_dump_h__
-
-#include <linux/types.h>
-
-#define IWL_FW_ERROR_DUMP_BARKER	0x14789632
-
-/**
- * enum iwl_fw_error_dump_type - types of data in the dump file
- * @IWL_FW_ERROR_DUMP_SRAM:
- * @IWL_FW_ERROR_DUMP_REG:
- * @IWL_FW_ERROR_DUMP_RXF:
- */
-enum iwl_fw_error_dump_type {
-	IWL_FW_ERROR_DUMP_SRAM = 0,
-	IWL_FW_ERROR_DUMP_REG = 1,
-	IWL_FW_ERROR_DUMP_RXF = 2,
-
-	IWL_FW_ERROR_DUMP_MAX,
-};
-
-/**
- * struct iwl_fw_error_dump_data - data for one type
- * @type: %enum iwl_fw_error_dump_type
- * @len: the length starting from %data - must be a multiplier of 4.
- * @data: the data itself padded to be a multiplier of 4.
- */
-struct iwl_fw_error_dump_data {
-	__le32 type;
-	__le32 len;
-	__u8 data[];
-} __packed;
-
-/**
- * struct iwl_fw_error_dump_file - the layout of the header of the file
- * @barker: must be %IWL_FW_ERROR_DUMP_BARKER
- * @file_len: the length of all the file starting from %barker
- * @data: array of %struct iwl_fw_error_dump_data
- */
-struct iwl_fw_error_dump_file {
-	__le32 barker;
-	__le32 file_len;
-	u8 data[0];
-} __packed;
-
-#endif /* __fw_error_dump_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 3c14ea1..cd526e1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -79,8 +79,8 @@
 #include "iwl-prph.h"
 #include "rs.h"
 #include "fw-api-scan.h"
-#include "fw-error-dump.h"
 #include "time-event.h"
+#include "iwl-fw-error-dump.h"
 
 /*
  * module name, copyright, version, etc.
@@ -822,6 +822,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	u32 file_len;
+	u32 trans_len;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -833,6 +834,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		   sizeof(*dump_file) +
 		   sizeof(*dump_data) * 2;
 
+	trans_len = iwl_trans_dump_data(mvm->trans, NULL, 0);
+	if (trans_len)
+		file_len += trans_len;
+
 	dump_file = vmalloc(file_len);
 	if (!dump_file)
 		return;
@@ -846,7 +851,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	dump_data->len = cpu_to_le32(mvm->fw_error_rxf_len);
 	memcpy(dump_data->data, mvm->fw_error_rxf, mvm->fw_error_rxf_len);
 
-	dump_data = (void *)((u8 *)dump_data->data + mvm->fw_error_rxf_len);
+	dump_data = iwl_mvm_fw_error_next_data(dump_data);
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_SRAM);
 	dump_data->len = cpu_to_le32(mvm->fw_error_sram_len);
 
@@ -864,6 +869,15 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	kfree(mvm->fw_error_sram);
 	mvm->fw_error_sram = NULL;
 	mvm->fw_error_sram_len = 0;
+
+	if (trans_len) {
+		void *buf = iwl_mvm_fw_error_next_data(dump_data);
+		u32 real_trans_len = iwl_trans_dump_data(mvm->trans, buf,
+							 trans_len);
+		dump_data = (void *)((u8 *)buf + real_trans_len);
+		dump_file->file_len =
+			cpu_to_le32(file_len - trans_len + real_trans_len);
+	}
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index ab21aee..6c22b23 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -370,6 +370,13 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
 
+static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+
+	return le16_to_cpu(tb->hi_n_len) >> 4;
+}
+
 /*****************************************************
 * Error handling
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index a6f8622..f41f9b7 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -73,6 +73,7 @@
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-agn-hw.h"
+#include "iwl-fw-error-dump.h"
 #include "internal.h"
 
 static u32 iwl_trans_pcie_read_shr(struct iwl_trans *trans, u32 reg)
@@ -1669,6 +1670,61 @@ err:
 	IWL_ERR(trans, "failed to create the trans debugfs entry\n");
 	return -ENOMEM;
 }
+
+static u32 iwl_trans_pcie_get_cmdlen(struct iwl_tfd *tfd)
+{
+	u32 cmdlen = 0;
+	int i;
+
+	for (i = 0; i < IWL_NUM_OF_TBS; i++)
+		cmdlen += iwl_pcie_tfd_tb_get_len(tfd, i);
+
+	return cmdlen;
+}
+
+static u32 iwl_trans_pcie_dump_data(struct iwl_trans *trans,
+				    void *buf, u32 buflen)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_fw_error_dump_data *data;
+	struct iwl_txq *cmdq = &trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_fw_error_dump_txcmd *txcmd;
+	u32 len;
+	int i, ptr;
+
+	if (!buf)
+		return sizeof(*data) +
+		       cmdq->q.n_window * (sizeof(*txcmd) +
+					   TFD_MAX_PAYLOAD_SIZE);
+
+	len = 0;
+	data = buf;
+	data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXCMD);
+	txcmd = (void *)data->data;
+	spin_lock_bh(&cmdq->lock);
+	ptr = cmdq->q.write_ptr;
+	for (i = 0; i < cmdq->q.n_window; i++) {
+		u8 idx = get_cmd_index(&cmdq->q, ptr);
+		u32 caplen, cmdlen;
+
+		cmdlen = iwl_trans_pcie_get_cmdlen(&cmdq->tfds[ptr]);
+		caplen = min_t(u32, TFD_MAX_PAYLOAD_SIZE, cmdlen);
+
+		if (cmdlen) {
+			len += sizeof(*txcmd) + caplen;
+			txcmd->cmdlen = cpu_to_le32(cmdlen);
+			txcmd->caplen = cpu_to_le32(caplen);
+			memcpy(txcmd->data, cmdq->entries[idx].cmd, caplen);
+			txcmd = (void *)((u8 *)txcmd->data + caplen);
+		}
+
+		ptr = iwl_queue_dec_wrap(ptr);
+	}
+	spin_unlock_bh(&cmdq->lock);
+
+	data->len = cpu_to_le32(len);
+	return sizeof(*data) + len;
+}
 #else
 static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 					 struct dentry *dir)
@@ -1711,6 +1767,10 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.grab_nic_access = iwl_trans_pcie_grab_nic_access,
 	.release_nic_access = iwl_trans_pcie_release_nic_access,
 	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	.dump_data = iwl_trans_pcie_dump_data,
+#endif
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 93709fe..77a512a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -353,13 +353,6 @@ static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
 	return addr;
 }
 
-static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-
-	return le16_to_cpu(tb->hi_n_len) >> 4;
-}
-
 static inline void iwl_pcie_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
 				       dma_addr_t addr, u16 len)
 {
@@ -1322,28 +1315,39 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	cmd_pos = offsetof(struct iwl_device_cmd, payload);
 	copy_size = sizeof(out_cmd->hdr);
 	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
-		int copy = 0;
+		int copy;
 
 		if (!cmd->len[i])
 			continue;
 
-		/* need at least IWL_HCMD_SCRATCHBUF_SIZE copied */
-		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
-			copy = IWL_HCMD_SCRATCHBUF_SIZE - copy_size;
-
-			if (copy > cmd->len[i])
-				copy = cmd->len[i];
-		}
-
 		/* copy everything if not nocopy/dup */
 		if (!(cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
-					   IWL_HCMD_DFL_DUP)))
+					   IWL_HCMD_DFL_DUP))) {
 			copy = cmd->len[i];
 
-		if (copy) {
 			memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], copy);
 			cmd_pos += copy;
 			copy_size += copy;
+			continue;
+		}
+
+		/*
+		 * Otherwise we need at least IWL_HCMD_SCRATCHBUF_SIZE copied
+		 * in total (for the scratchbuf handling), but copy up to what
+		 * we can fit into the payload for debug dump purposes.
+		 */
+		copy = min_t(int, TFD_MAX_PAYLOAD_SIZE - cmd_pos, cmd->len[i]);
+
+		memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], copy);
+		cmd_pos += copy;
+
+		/* However, treat copy_size the proper way, we need it below */
+		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
+			copy = IWL_HCMD_SCRATCHBUF_SIZE - copy_size;
+
+			if (copy > cmd->len[i])
+				copy = cmd->len[i];
+			copy_size += copy;
 		}
 	}
 
-- 
1.8.3.2

