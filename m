Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaCJNul (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 09:50:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: mvm: send udev event when ASSERT occur for SRAM dump
Date: Mon, 10 Mar 2014 15:48:22 +0200
Message-Id: <1394459303-11074-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140310_145044_966216_789B4312)
In-Reply-To: <1394459303-11074-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1394459303-11074-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the firmware asserts, the driver will dump the SRAM to
an internal buffer. This buffer is kept aside until it is
dumped through debugfs. Once an external application fetched
the data, the buffer is freed and a new buffer can be
allocated in case another assert occurs.

A udev event is sent to trigger an external application.

A simple rule like:
DRIVER=="iwlwifi", ACTION=="change", RUN+="/sbin/dump_sram.sh"

can fetch the data from debugfs.

Here is my dump_sram.sh:

phyname=$(basename ${DEVPATH})
date=$(date +%F_%H_%M)
filename=/var/log/iwl-sram-${phyname}-${date}.bin
cat /sys/kernel/debug/ieee80211/${phyname}/iwlwifi/iwlmvm/fw_error_dump > ${filename}

---
Somehow if I add a filter ERROR==error_dump to my rules, it stops working...

Change-Id: I1bc6c2aae35bcbf9b339cc23291e7c45cc6fae49
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  | 48 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  5 +++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  3 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  7 +++--
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 23 ++++++--------
 5 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 4581c03..7c6dff8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -195,6 +195,47 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct iwl_mvm *mvm, char *buf,
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
+	u8 *data = file->private_data;
+	u32 len = *(u32 *)data;
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       data + sizeof(len), len);
+}
+
+static int iwl_dbgfs_fw_error_dump_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+
+	return 0;
+}
+
 static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -1166,6 +1207,12 @@ MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 
+static const struct file_operations iwl_dbgfs_fw_error_dump_ops = {
+	.open = iwl_dbgfs_fw_error_dump_open,
+	.read = iwl_dbgfs_fw_error_dump_read,
+	.release = iwl_dbgfs_fw_error_dump_release,
+};
+
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
@@ -1189,6 +1236,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(sta_drain, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(sram, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(fw_error_dump, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3329e8e..b810334 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -562,6 +562,11 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
+	static char *env[] = { "DRIVER=iwlwifi", "EVENT=error_dump", NULL };
+
+	/* notify the userspace about the error we had */
+	kobject_uevent_env(&mvm->hw->wiphy->dev.kobj, KOBJ_CHANGE, env);
+
 	iwl_trans_stop_device(mvm->trans);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6cb2018..ce8373e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -580,6 +580,7 @@ struct iwl_mvm {
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
+	void *fw_error_dump;
 
 	struct led_classdev led;
 
@@ -701,7 +702,7 @@ void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
 			       struct ieee80211_tx_rate *r);
 u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx);
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
-void iwl_mvm_dump_sram(struct iwl_mvm *mvm);
+void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
 u8 first_antenna(u8 mask);
 u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 01b65fa..6cffcc1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -578,6 +578,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 #endif
 
 	kfree(mvm->scan_cmd);
+	kfree(mvm->fw_error_dump);
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
 
@@ -870,8 +871,10 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
 	iwl_mvm_dump_nic_error_log(mvm);
-	if (!mvm->restart_fw)
-		iwl_mvm_dump_sram(mvm);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	iwl_mvm_fw_error_dump(mvm);
+#endif
 
 	iwl_mvm_nic_restart(mvm);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index aae4b43..f6beadb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -516,33 +516,28 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 		iwl_mvm_dump_umac_error_log(mvm);
 }
 
-void iwl_mvm_dump_sram(struct iwl_mvm *mvm)
+void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
 	const struct fw_img *img;
-	int ofs, len = 0;
-	int i;
-	__le32 *buf;
+	u32 ofs, len = 0;
+	u8 *buf;
 
-	if (!mvm->ucode_loaded)
+	if (!mvm->ucode_loaded || mvm->fw_error_dump)
 		return;
 
 	img = &mvm->fw->img[mvm->cur_ucode];
 	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
 	len = img->sec[IWL_UCODE_SECTION_DATA].len;
 
-	buf = kzalloc(len, GFP_ATOMIC);
+	/* Will be freed when the debugfs reader will close the file */
+	buf = kzalloc(len + sizeof(u32), GFP_ATOMIC);
 	if (!buf)
 		return;
 
-	iwl_trans_read_mem_bytes(mvm->trans, ofs, buf, len);
-	len = len >> 2;
-	for (i = 0; i < len; i++) {
-		IWL_ERR(mvm, "0x%08X\n", le32_to_cpu(buf[i]));
-		/* Add a small delay to let syslog catch up */
-		udelay(10);
-	}
+	*((u32 *)buf) = len;
+	iwl_trans_read_mem_bytes(mvm->trans, ofs, buf + sizeof(len), len);
 
-	kfree(buf);
+	mvm->fw_error_dump = buf;
 }
 
 /**
-- 
1.8.3.2

