Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaCJNun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 09:50:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: mvm: create a firmware error dump format
Date: Mon, 10 Mar 2014 15:48:23 +0200
Message-Id: <1394459303-11074-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140310_145046_705051_8B54D997)
In-Reply-To: <1394459303-11074-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1394459303-11074-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow to put more data in the dump file -not only
the SRAM of the device.

Change-Id: I5641dab6b538ea8d58a935bcd8590210d0102760
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  11 ++-
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h | 106 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |   2 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |   3 +
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  33 ++++++-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  22 +++--
 intc-scripts/publishable-files                   |   1 +
 7 files changed, 160 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 7c6dff8..feafe86 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -65,6 +65,7 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 #include "debugfs.h"
+#include "fw-error-dump.h"
 
 #ifdef CONFIG_IWLWIFI_SUPPORT_DEBUG_CMD
 static ssize_t iwl_dbgfs_fw_dbg_write(struct iwl_mvm *mvm, char *buf,
@@ -211,6 +212,8 @@ static int iwl_dbgfs_fw_error_dump_open(struct inode *inode, struct file *file)
 
 	file->private_data = mvm->fw_error_dump;
 	mvm->fw_error_dump = NULL;
+	mvm->fw_error_sram = NULL;
+	mvm->fw_error_sram_len = 0;
 	ret = 0;
 
 out:
@@ -222,16 +225,16 @@ static ssize_t iwl_dbgfs_fw_error_dump_read(struct file *file,
 					    char __user *user_buf,
 					    size_t count, loff_t *ppos)
 {
-	u8 *data = file->private_data;
-	u32 len = *(u32 *)data;
+	struct iwl_fw_error_dump_file *dump_file = file->private_data;
 
 	return simple_read_from_buffer(user_buf, count, ppos,
-				       data + sizeof(len), len);
+				       dump_file,
+				       le32_to_cpu(dump_file->file_len));
 }
 
 static int iwl_dbgfs_fw_error_dump_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	vfree(file->private_data);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h b/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
new file mode 100644
index 0000000..58c8941
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
@@ -0,0 +1,106 @@
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
+ */
+enum iwl_fw_error_dump_type {
+	IWL_FW_ERROR_DUMP_SRAM = 0,
+	IWL_FW_ERROR_DUMP_REG = 1,
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
+} __packed __aligned(4);
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
+} __packed __aligned(4);
+
+#endif /* __fw_error_dump_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b810334..61d603c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -564,6 +564,8 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
 	static char *env[] = { "DRIVER=iwlwifi", "EVENT=error_dump", NULL };
 
+	iwl_mvm_fw_error_dump(mvm);
+
 	/* notify the userspace about the error we had */
 	kobject_uevent_env(&mvm->hw->wiphy->dev.kobj, KOBJ_CHANGE, env);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ce8373e..29cecbf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -581,6 +581,8 @@ struct iwl_mvm {
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
 	void *fw_error_dump;
+	void *fw_error_sram;
+	u32 fw_error_sram_len;
 
 	struct led_classdev led;
 
@@ -703,6 +705,7 @@ void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
 u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx);
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
+void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm);
 u8 first_antenna(u8 mask);
 u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 6cffcc1..d006405 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -80,6 +80,7 @@
 #include "fw-api-scan.h"
 #include "iwl-tm-gnl.h"
 #include "time-event.h"
+#include "fw-error-dump.h"
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 #include "iwl-dnt-cfg.h"
 #include "iwl-dnt-dispatch.h"
@@ -578,7 +579,8 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 #endif
 
 	kfree(mvm->scan_cmd);
-	kfree(mvm->fw_error_dump);
+	vfree(mvm->fw_error_dump);
+	kfree(mvm->fw_error_sram);
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
 
@@ -866,6 +868,33 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 	}
 }
 
+void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
+{
+	struct iwl_fw_error_dump_file *dump_file;
+	struct iwl_fw_error_dump_data *dump_data;
+	u32 file_len;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	file_len = mvm->fw_error_sram_len +
+		   sizeof(*dump_file) +
+		   sizeof(*dump_data);
+
+	dump_file = vmalloc(file_len);
+	if (!dump_file)
+		return;
+
+	mvm->fw_error_dump = dump_file;
+
+	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
+	dump_file->file_len = cpu_to_le32(file_len);
+	dump_data = (void *)dump_file->data;
+	dump_data->type = IWL_FW_ERROR_DUMP_SRAM;
+	dump_data->len = cpu_to_le32(mvm->fw_error_sram_len);
+
+	memcpy(dump_data->data, mvm->fw_error_sram, mvm->fw_error_sram_len);
+}
+
 static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
@@ -873,7 +902,7 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 	iwl_mvm_dump_nic_error_log(mvm);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	iwl_mvm_fw_error_dump(mvm);
+	iwl_mvm_fw_error_sram_dump(mvm);
 #endif
 
 	iwl_mvm_nic_restart(mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index f6beadb..da26871 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -516,28 +516,26 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 		iwl_mvm_dump_umac_error_log(mvm);
 }
 
-void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
+void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm)
 {
 	const struct fw_img *img;
-	u32 ofs, len = 0;
-	u8 *buf;
+	u32 ofs, sram_len;
+	void *sram;
 
-	if (!mvm->ucode_loaded || mvm->fw_error_dump)
+	if (!mvm->ucode_loaded || mvm->fw_error_sram)
 		return;
 
 	img = &mvm->fw->img[mvm->cur_ucode];
 	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
-	len = img->sec[IWL_UCODE_SECTION_DATA].len;
+	sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
 
-	/* Will be freed when the debugfs reader will close the file */
-	buf = kzalloc(len + sizeof(u32), GFP_ATOMIC);
-	if (!buf)
+	sram = kzalloc(sram_len, GFP_ATOMIC);
+	if (!sram)
 		return;
 
-	*((u32 *)buf) = len;
-	iwl_trans_read_mem_bytes(mvm->trans, ofs, buf + sizeof(len), len);
-
-	mvm->fw_error_dump = buf;
+	iwl_trans_read_mem_bytes(mvm->trans, ofs, sram, sram_len);
+	mvm->fw_error_sram = sram;
+	mvm->fw_error_sram_len = sram_len;
 }
 
 /**
diff --git a/intc-scripts/publishable-files b/intc-scripts/publishable-files
index 562ab29..315bf16 100644
--- a/intc-scripts/publishable-files
+++ b/intc-scripts/publishable-files
@@ -103,6 +103,7 @@ drivers/net/wireless/iwlwifi/mvm/tx.c
 drivers/net/wireless/iwlwifi/mvm/utils.c
 drivers/net/wireless/iwlwifi/mvm/vendor-cmd.c
 drivers/net/wireless/iwlwifi/mvm/vendor-cmd.h
+drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
 drivers/net/wireless/iwlwifi/pcie
 drivers/net/wireless/iwlwifi/pcie/drv.c
 drivers/net/wireless/iwlwifi/pcie/internal.h
-- 
1.8.3.2

