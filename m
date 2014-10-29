Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34559 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780AbaJ2Lvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:35 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so1314392wiv.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:34 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/25] iwlwifi: mvm: port to devcoredump framework
Date: Wed, 29 Oct 2014 13:50:43 +0200
Message-Id: <1414583446-11032-22-git-send-email-egrumbach@gmail.com> (sfid-20141029_125150_992065_85061F85)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwlwifi features a debug mechanism that allows to dump
binary data which is helpful to debug the firmware.
Until now, this data was made available for the userspace
through debugfs. For this exact purpose, devcoredump was
created. Move to the new infrastructure.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |  1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h    |  4 --
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  | 79 -----------------------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 57 +++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 -
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  5 --
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  2 -
 7 files changed, 48 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 267e48a..139de90 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -59,6 +59,7 @@ config IWLDVM
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
+	select BACKPORT_WANT_DEV_COREDUMP
 	help
 	  This is the driver that supports the MVM firmware which is
 	  currently only available for 7260 and 3160 devices.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index d8fc548..0768f83e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -535,9 +535,7 @@ struct iwl_trans_ops {
 	void (*ref)(struct iwl_trans *trans);
 	void (*unref)(struct iwl_trans *trans);
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans);
-#endif
 };
 
 /**
@@ -704,7 +702,6 @@ static inline void iwl_trans_unref(struct iwl_trans *trans)
 		trans->ops->unref(trans);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
 static inline struct iwl_trans_dump_data *
 iwl_trans_dump_data(struct iwl_trans *trans)
 {
@@ -712,7 +709,6 @@ iwl_trans_dump_data(struct iwl_trans *trans)
 		return NULL;
 	return trans->ops->dump_data(trans);
 }
-#endif
 
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				     struct iwl_host_cmd *cmd)
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 2a61bac..51b7116 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -121,78 +121,6 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct iwl_mvm *mvm, char *buf,
 	return ret;
 }
 
-static int iwl_dbgfs_fw_error_dump_open(struct inode *inode, struct file *file)
-{
-	struct iwl_mvm *mvm = inode->i_private;
-	int ret;
-
-	if (!mvm)
-		return -EINVAL;
-
-	mutex_lock(&mvm->mutex);
-	if (!mvm->fw_error_dump) {
-		ret = -ENODATA;
-		goto out;
-	}
-
-	file->private_data = mvm->fw_error_dump;
-	mvm->fw_error_dump = NULL;
-	ret = 0;
-
-out:
-	mutex_unlock(&mvm->mutex);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_fw_error_dump_read(struct file *file,
-					    char __user *user_buf,
-					    size_t count, loff_t *ppos)
-{
-	struct iwl_mvm_dump_ptrs *dump_ptrs = (void *)file->private_data;
-	ssize_t bytes_read = 0;
-	ssize_t bytes_read_trans = 0;
-
-	if (*ppos < dump_ptrs->op_mode_len)
-		bytes_read +=
-			simple_read_from_buffer(user_buf, count, ppos,
-						dump_ptrs->op_mode_ptr,
-						dump_ptrs->op_mode_len);
-
-	if (bytes_read < 0 || *ppos < dump_ptrs->op_mode_len)
-		return bytes_read;
-
-	if (dump_ptrs->trans_ptr) {
-		*ppos -= dump_ptrs->op_mode_len;
-		bytes_read_trans =
-			simple_read_from_buffer(user_buf + bytes_read,
-						count - bytes_read, ppos,
-						dump_ptrs->trans_ptr->data,
-						dump_ptrs->trans_ptr->len);
-		*ppos += dump_ptrs->op_mode_len;
-
-		if (bytes_read_trans >= 0)
-			bytes_read += bytes_read_trans;
-		else if (!bytes_read)
-			/* propagate the failure */
-			return bytes_read_trans;
-	}
-
-	return bytes_read;
-
-}
-
-static int iwl_dbgfs_fw_error_dump_release(struct inode *inode,
-					   struct file *file)
-{
-	struct iwl_mvm_dump_ptrs *dump_ptrs = (void *)file->private_data;
-
-	vfree(dump_ptrs->op_mode_ptr);
-	vfree(dump_ptrs->trans_ptr);
-	kfree(dump_ptrs);
-
-	return 0;
-}
-
 static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -1535,12 +1463,6 @@ MVM_DEBUGFS_WRITE_FILE_OPS(bt_force_ant, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 
-static const struct file_operations iwl_dbgfs_fw_error_dump_ops = {
-	.open = iwl_dbgfs_fw_error_dump_open,
-	.read = iwl_dbgfs_fw_error_dump_read,
-	.release = iwl_dbgfs_fw_error_dump_release,
-};
-
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
@@ -1567,7 +1489,6 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 			     S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(nic_temp, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(fw_error_dump, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(disable_power_off, mvm->debugfs_dir,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 14be108..3276b31 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -69,6 +69,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/if_arp.h>
+#include <linux/devcoredump.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/tcp.h>
@@ -679,10 +680,51 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	memset(&mvmvif->bf_data, 0, sizeof(mvmvif->bf_data));
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
+static ssize_t iwl_mvm_read_coredump(char *buffer, loff_t offset, size_t count,
+				     const void *data, size_t datalen)
+{
+	const struct iwl_mvm_dump_ptrs *dump_ptrs = data;
+	ssize_t bytes_read;
+	ssize_t bytes_read_trans;
+
+	if (offset < dump_ptrs->op_mode_len) {
+		bytes_read = min_t(ssize_t, count,
+				   dump_ptrs->op_mode_len - offset);
+		memcpy(buffer, (u8 *)dump_ptrs->op_mode_ptr + offset,
+		       bytes_read);
+		offset += bytes_read;
+		count -= bytes_read;
+
+		if (count == 0)
+			return bytes_read;
+	} else {
+		bytes_read = 0;
+	}
+
+	if (!dump_ptrs->trans_ptr)
+		return bytes_read;
+
+	offset -= dump_ptrs->op_mode_len;
+	bytes_read_trans = min_t(ssize_t, count,
+				 dump_ptrs->trans_ptr->len - offset);
+	memcpy(buffer + bytes_read,
+	       (u8 *)dump_ptrs->trans_ptr->data + offset,
+	       bytes_read_trans);
+
+	return bytes_read + bytes_read_trans;
+}
+
+static void iwl_mvm_free_coredump(const void *data)
+{
+	const struct iwl_mvm_dump_ptrs *fw_error_dump = data;
+
+	vfree(fw_error_dump->op_mode_ptr);
+	vfree(fw_error_dump->trans_ptr);
+	kfree(fw_error_dump);
+}
+
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
-	static char *env[] = { "DRIVER=iwlwifi", "EVENT=error_dump", NULL };
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
@@ -695,10 +737,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (mvm->fw_error_dump)
-		return;
-
-	fw_error_dump = kzalloc(sizeof(*mvm->fw_error_dump), GFP_KERNEL);
+	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
 	if (!fw_error_dump)
 		return;
 
@@ -773,12 +812,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (fw_error_dump->trans_ptr)
 		file_len += fw_error_dump->trans_ptr->len;
 	dump_file->file_len = cpu_to_le32(file_len);
-	mvm->fw_error_dump = fw_error_dump;
 
-	/* notify the userspace about the error we had */
-	kobject_uevent_env(&mvm->hw->wiphy->dev.kobj, KOBJ_CHANGE, env);
+	dev_coredumpm(mvm->trans->dev, THIS_MODULE, fw_error_dump, 0,
+		      GFP_KERNEL, iwl_mvm_read_coredump, iwl_mvm_free_coredump);
 }
-#endif
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d14dc06..c2a2bba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -648,7 +648,6 @@ struct iwl_mvm {
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
 	struct work_struct fw_error_dump_wk;
-	struct iwl_mvm_dump_ptrs *fw_error_dump;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 91b28e8..bd52ecfa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -587,11 +587,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	ieee80211_unregister_hw(mvm->hw);
 
 	kfree(mvm->scan_cmd);
-	if (mvm->fw_error_dump) {
-		vfree(mvm->fw_error_dump->op_mode_ptr);
-		vfree(mvm->fw_error_dump->trans_ptr);
-		kfree(mvm->fw_error_dump);
-	}
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 8027138..0cc1140 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2085,9 +2085,7 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.release_nic_access = iwl_trans_pcie_release_nic_access,
 	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
 	.dump_data = iwl_trans_pcie_dump_data,
-#endif
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
-- 
1.9.1

