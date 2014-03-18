Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63592 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaCROqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:36 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so5498253eek.10
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:35 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/35] iwlwifi: mvm: send udev event upon firmware error to dump logs
Date: Tue, 18 Mar 2014 16:45:31 +0200
Message-Id: <1395153939-23897-27-git-send-email-egrumbach@gmail.com> (sfid-20140318_154658_314543_2C624E12)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the firmware asserts, the driver will dump the firmware
state to an internal buffer. This buffer is kept aside until
it is dumped through debugfs. Once an external application
fetched the data, the buffer is freed and a new buffer can
be allocated in case another assert occurs.

A udev event is sent to trigger an external application.

A simple rule like:
DRIVER=="iwlwifi", ACTION=="change", RUN+="/sbin/dump_sram.sh"

can fetch the data from debugfs.

Here is my dump_sram.sh:

phyname=$(basename ${DEVPATH})
date=$(date +%F_%H_%M)
filename=/var/log/iwl-sram-${phyname}-${date}.bin
cat /sys/kernel/debug/ieee80211/${phyname}/iwlwifi/iwlmvm/fw_error_dump > ${filename}

The current SRAM size is 80KB so, currently:
$ ls -lh iwl-sram-phy0-2014-03-16_13_14.bin
-rw-r--r-- 1 emmanuel emmanuel 81K Mar 16 13:15 iwl-sram-phy0-2014-03-16_13_14.bin

and after compression:
$ ls -lh iwl-sram-phy0-2014-03-16_13_14.bin.xz
-rw-r--r-- 1 emmanuel emmanuel 13K Mar 16 13:15 iwl-sram-phy0-2014-03-16_13_14.bin.xz

Change-Id: I1bc6c2aae35bcbf9b339cc23291e7c45cc6fae49
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  52 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h | 106 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |   9 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |   8 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  44 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  27 +++---
 6 files changed, 226 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 21ef8da..e33ffd1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -65,6 +65,7 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 #include "debugfs.h"
+#include "fw-error-dump.h"
 
 static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 					size_t count, loff_t *ppos)
@@ -117,6 +118,50 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct iwl_mvm *mvm, char *buf,
 	return ret;
 }
 
+static int iwl_dbgfs_fw_error_dump_open(struct inode *inode, struct file *file)
+{
+	struct iwl_mvm *mvm = inode->i_private;
+	int ret;
+
+	if (!mvm)
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+	if (!mvm->fw_error_dump) {
+		ret = -ENODATA;
+		goto out;
+	}
+
+	file->private_data = mvm->fw_error_dump;
+	mvm->fw_error_dump = NULL;
+	mvm->fw_error_sram = NULL;
+	mvm->fw_error_sram_len = 0;
+	ret = 0;
+
+out:
+	mutex_unlock(&mvm->mutex);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_fw_error_dump_read(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct iwl_fw_error_dump_file *dump_file = file->private_data;
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       dump_file,
+				       le32_to_cpu(dump_file->file_len));
+}
+
+static int iwl_dbgfs_fw_error_dump_release(struct inode *inode,
+					   struct file *file)
+{
+	vfree(file->private_data);
+
+	return 0;
+}
+
 static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -1042,6 +1087,12 @@ MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 
+static const struct file_operations iwl_dbgfs_fw_error_dump_ops = {
+        .open = iwl_dbgfs_fw_error_dump_open,
+        .read = iwl_dbgfs_fw_error_dump_read,
+        .release = iwl_dbgfs_fw_error_dump_release,
+};
+
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
@@ -1064,6 +1115,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(sta_drain, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(sram, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(fw_error_dump, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD)
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
index 48a8e67..8414c03 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -607,6 +607,15 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	static char *env[] = { "DRIVER=iwlwifi", "EVENT=error_dump", NULL };
+
+	iwl_mvm_fw_error_dump(mvm);
+
+	/* notify the userspace about the error we had */
+	kobject_uevent_env(&mvm->hw->wiphy->dev.kobj, KOBJ_CHANGE, env);
+#endif
+
 	iwl_trans_stop_device(mvm->trans);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 46fe817..cb6dbb1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -575,6 +575,9 @@ struct iwl_mvm {
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
+	void *fw_error_dump;
+	void *fw_error_sram;
+	u32 fw_error_sram_len;
 
 	struct led_classdev led;
 
@@ -698,7 +701,10 @@ void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
 			       struct ieee80211_tx_rate *r);
 u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx);
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
-void iwl_mvm_dump_sram(struct iwl_mvm *mvm);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
+void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm);
+#endif
 u8 first_antenna(u8 mask);
 u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 10846b6..a23d533 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -61,6 +61,7 @@
  *
  *****************************************************************************/
 #include <linux/module.h>
+#include <linux/vmalloc.h>
 #include <net/mac80211.h>
 
 #include "iwl-notif-wait.h"
@@ -78,6 +79,7 @@
 #include "iwl-prph.h"
 #include "rs.h"
 #include "fw-api-scan.h"
+#include "fw-error-dump.h"
 #include "time-event.h"
 
 /*
@@ -534,6 +536,8 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	ieee80211_unregister_hw(mvm->hw);
 
 	kfree(mvm->scan_cmd);
+	vfree(mvm->fw_error_dump);
+	kfree(mvm->fw_error_sram);
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
 
@@ -804,13 +808,49 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 	}
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
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
+	/*
+	 * No need for lock since at the stage the FW isn't loaded. So it
+	 * can't assert - we are the only one who can possibly be accessing
+	 * mvm->fw_error_sram right now.
+	 */
+	memcpy(dump_data->data, mvm->fw_error_sram, mvm->fw_error_sram_len);
+}
+#endif
+
 static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
 	iwl_mvm_dump_nic_error_log(mvm);
-	if (!mvm->restart_fw)
-		iwl_mvm_dump_sram(mvm);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	iwl_mvm_fw_error_sram_dump(mvm);
+#endif
 
 	iwl_mvm_nic_restart(mvm);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index bbfe529..e9de033d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -516,33 +516,26 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 		iwl_mvm_dump_umac_error_log(mvm);
 }
 
-void iwl_mvm_dump_sram(struct iwl_mvm *mvm)
+void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm)
 {
 	const struct fw_img *img;
-	int ofs, len = 0;
-	int i;
-	__le32 *buf;
+	u32 ofs, sram_len;
+	void *sram;
 
-	if (!mvm->ucode_loaded)
+	if (!mvm->ucode_loaded || mvm->fw_error_sram)
 		return;
 
 	img = &mvm->fw->img[mvm->cur_ucode];
 	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
-	len = img->sec[IWL_UCODE_SECTION_DATA].len;
+	sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
 
-	buf = kzalloc(len, GFP_ATOMIC);
-	if (!buf)
+	sram = kzalloc(sram_len, GFP_ATOMIC);
+	if (!sram)
 		return;
 
-	iwl_trans_read_mem_bytes(mvm->trans, ofs, buf, len);
-	len = len >> 2;
-	for (i = 0; i < len; i++) {
-		IWL_ERR(mvm, "0x%08X\n", le32_to_cpu(buf[i]));
-		/* Add a small delay to let syslog catch up */
-		udelay(10);
-	}
-
-	kfree(buf);
+	iwl_trans_read_mem_bytes(mvm->trans, ofs, sram, sram_len);
+	mvm->fw_error_sram = sram;
+	mvm->fw_error_sram_len = sram_len;
 }
 
 /**
-- 
1.8.3.2

