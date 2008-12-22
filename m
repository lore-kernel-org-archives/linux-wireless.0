Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYLVDis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:48 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/10] iwlwifi: move sysfs status entry to debugfs
Date: Mon, 22 Dec 2008 11:31:20 +0800
Message-Id: <1229916683-9772-8-git-send-email-yi.zhu@intel.com> (sfid-20081222_043856_071280_9D50B798)
In-Reply-To: <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-4-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves priv->status sysfs entry to debugfs. It is for
debugging only anyway.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   11 -----------
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   10 +++++++++-
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 05cd04c..ecf8141 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3667,16 +3667,6 @@ static ssize_t show_statistics(struct device *d,
 
 static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
 
-static ssize_t show_status(struct device *d,
-			   struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-	return sprintf(buf, "0x%08x\n", (int)priv->status);
-}
-
-static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
 
 /*****************************************************************************
  *
@@ -3732,7 +3722,6 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_power_level.attr,
 	&dev_attr_retry_rate.attr,
 	&dev_attr_statistics.attr,
-	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 798f946..057781c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -72,6 +72,7 @@ struct iwl_debugfs {
 		struct dentry *file_tx_statistics;
 		struct dentry *file_log_event;
 		struct dentry *file_channels;
+		struct dentry *file_status;
 	} dbgfs_data_files;
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ecb3900..61949c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -63,6 +63,14 @@
 		goto err;                                               \
 } while (0)
 
+#define DEBUGFS_ADD_X32(name, parent, ptr) do {                        \
+	dbgfs->dbgfs_##parent##_files.file_##name =                     \
+	debugfs_create_x32(#name, 0444, dbgfs->dir_##parent, ptr);     \
+	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name)		\
+			|| !dbgfs->dbgfs_##parent##_files.file_##name)	\
+		goto err;                                               \
+} while (0)
+
 #define DEBUGFS_REMOVE(name)  do {              \
 	debugfs_remove(name);                   \
 	name = NULL;                            \
@@ -419,7 +427,6 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(eeprom);
@@ -461,6 +468,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rx_statistics, data);
 	DEBUGFS_ADD_FILE(tx_statistics, data);
 	DEBUGFS_ADD_FILE(channels, data);
+	DEBUGFS_ADD_X32(status, data, (u32 *)&priv->status);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
-- 
1.5.3.6

