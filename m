Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:34626 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3KXUHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:10 -0500
Received: by mail-we0-f172.google.com with SMTP id t60so3065056wes.31
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:09 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/29] iwlwifi: mvm: refactor debugfs copy_from_user()
Date: Sun, 24 Nov 2013 22:06:32 +0200
Message-Id: <1385323606-3603-15-git-send-email-egrumbach@gmail.com> (sfid-20131124_210809_575797_5440C5C6)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Abstract the copy_from_user() pattern into the macros defining
debugfs files, reducing the code and making adding new files
safer by avoiding having deal with copy_from_user() directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   87 +++++++---------------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.h |   25 ++++++--
 2 files changed, 43 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f0811b1..a9b2d0a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -66,22 +66,15 @@
 #include "iwl-prph.h"
 #include "debugfs.h"
 
-static ssize_t iwl_dbgfs_tx_flush_write(struct file *file,
-					const char __user *user_buf,
+static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 					size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
-	char buf[16] = {};
-	size_t buf_size = min(count, sizeof(buf) - 1);
 	int ret;
 	u32 scd_q_msk;
 
 	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
 	if (sscanf(buf, "%x", &scd_q_msk) != 1)
 		return -EINVAL;
 
@@ -94,22 +87,15 @@ static ssize_t iwl_dbgfs_tx_flush_write(struct file *file,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_sta_drain_write(struct file *file,
-					 const char __user *user_buf,
+static ssize_t iwl_dbgfs_sta_drain_write(struct iwl_mvm *mvm, char *buf,
 					 size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
 	struct ieee80211_sta *sta;
-	char buf[8] = {};
-	size_t buf_size = min(count, sizeof(buf) - 1);
 	int sta_id, drain, ret;
 
 	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
 	if (sscanf(buf, "%d %d", &sta_id, &drain) != 2)
 		return -EINVAL;
 
@@ -183,18 +169,11 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_sram_write(struct file *file,
-				    const char __user *user_buf, size_t count,
-				    loff_t *ppos)
+static ssize_t iwl_dbgfs_sram_write(struct iwl_mvm *mvm, char *buf,
+				    size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
-	char buf[64] = {};
-	size_t buf_size = min(count, sizeof(buf) -  1);
 	u32 offset, len;
 
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
 	if (sscanf(buf, "%x,%x", &offset, &len) == 2) {
 		if ((offset & 0x3) || (len & 0x3))
 			return -EINVAL;
@@ -254,22 +233,14 @@ static ssize_t iwl_dbgfs_disable_power_off_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_disable_power_off_write(struct file *file,
-						 const char __user *user_buf,
+static ssize_t iwl_dbgfs_disable_power_off_write(struct iwl_mvm *mvm, char *buf,
 						 size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
-	char buf[64] = {};
-	size_t buf_size = min(count, sizeof(buf) - 1);
-	int ret;
-	int val;
+	int ret, val;
 
 	if (!mvm->ucode_loaded)
 		return -EIO;
 
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
 	if (!strncmp("disable_power_off_d0=", buf, 21)) {
 		if (sscanf(buf + 21, "%d", &val) != 1)
 			return -EINVAL;
@@ -564,11 +535,9 @@ static ssize_t iwl_dbgfs_fw_rx_stats_read(struct file *file,
 }
 #undef PRINT_STAT_LE32
 
-static ssize_t iwl_dbgfs_fw_restart_write(struct file *file,
-					  const char __user *user_buf,
+static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 					  size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
 	int ret;
 
 	mutex_lock(&mvm->mutex);
@@ -585,12 +554,9 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_dbgfs_fw_nmi_write(struct file *file,
-				      const char __user *user_buf,
+static ssize_t iwl_dbgfs_fw_nmi_write(struct iwl_mvm *mvm, char *buf,
 				      size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
-
 	iwl_write_prph(mvm->trans, DEVICE_SET_NMI_REG, 1);
 
 	return count;
@@ -620,17 +586,11 @@ iwl_dbgfs_scan_ant_rxchain_read(struct file *file,
 }
 
 static ssize_t
-iwl_dbgfs_scan_ant_rxchain_write(struct file *file,
-				 const char __user *user_buf,
+iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 				 size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
-	char buf[8] = {};
-	size_t buf_size = min(count, sizeof(buf) - 1);
 	u8 scan_rx_ant;
 
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
 	if (sscanf(buf, "%hhx", &scan_rx_ant) != 1)
 		return -EINVAL;
 	if (scan_rx_ant > ANT_ABC)
@@ -644,18 +604,11 @@ iwl_dbgfs_scan_ant_rxchain_write(struct file *file,
 }
 
 #ifdef CONFIG_PM_SLEEP
-static ssize_t iwl_dbgfs_d3_sram_write(struct file *file,
-				       const char __user *user_buf,
+static ssize_t iwl_dbgfs_d3_sram_write(struct iwl_mvm *mvm, char *buf,
 				       size_t count, loff_t *ppos)
 {
-	struct iwl_mvm *mvm = file->private_data;
-	char buf[8] = {};
-	size_t buf_size = min(count, sizeof(buf) - 1);
 	int store;
 
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
 	if (sscanf(buf, "%d", &store) != 1)
 		return -EINVAL;
 
@@ -708,6 +661,10 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 }
 #endif
 
+#define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
+	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
+#define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
+	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
 #define MVM_DEBUGFS_ADD_FILE(name, parent, mode) do {			\
 		if (!debugfs_create_file(#name, mode, parent, mvm,	\
 					 &iwl_dbgfs_##name##_ops))	\
@@ -715,20 +672,20 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 	} while (0)
 
 /* Device wide debugfs entries */
-MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush);
-MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(sram);
+MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
+MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain, 8);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(sram, 64);
 MVM_DEBUGFS_READ_FILE_OPS(stations);
 MVM_DEBUGFS_READ_FILE_OPS(bt_notif);
 MVM_DEBUGFS_READ_FILE_OPS(bt_cmd);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(disable_power_off);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(disable_power_off, 64);
 MVM_DEBUGFS_READ_FILE_OPS(fw_rx_stats);
-MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart);
-MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain);
+MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
+MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 
 #ifdef CONFIG_PM_SLEEP
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
 #endif
 
 int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.h b/drivers/net/wireless/iwlwifi/mvm/debugfs.h
index faa73b8..85f9f95 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.h
@@ -68,17 +68,34 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.llseek = generic_file_llseek,					\
 }
 
-#define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name)				\
+#define MVM_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)		\
+static ssize_t _iwl_dbgfs_##name##_write(struct file *file,		\
+					 const char __user *user_buf,	\
+					 size_t count, loff_t *ppos)	\
+{									\
+	argtype *arg = file->private_data;				\
+	char buf[buflen] = {};						\
+	size_t buf_size = min(count, sizeof(buf) -  1);			\
+									\
+	if (copy_from_user(buf, user_buf, buf_size))			\
+		return -EFAULT;						\
+									\
+	return iwl_dbgfs_##name##_write(arg, buf, buf_size, ppos);	\
+}									\
+
+#define _MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, buflen, argtype)		\
+MVM_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)			\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
-	.write = iwl_dbgfs_##name##_write,				\
+	.write = _iwl_dbgfs_##name##_write,				\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
-#define MVM_DEBUGFS_WRITE_FILE_OPS(name)				\
+#define _MVM_DEBUGFS_WRITE_FILE_OPS(name, buflen, argtype)		\
+MVM_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)			\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
-	.write = iwl_dbgfs_##name##_write,				\
+	.write = _iwl_dbgfs_##name##_write,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
-- 
1.7.9.5

