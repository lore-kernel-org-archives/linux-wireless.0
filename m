Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab0CJFWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/24] iwlagn: move sysfs flags and filter_flags files to debugfs
Date: Tue,  9 Mar 2010 21:21:44 -0800
Message-Id: <1268198512-6572-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These files are incompatible with some changes
I'm making, and don't really belong into sysfs
anyway as they can only be used for debugging.
Since writing them will probably crash the
firmware, keep only the reading part and move
them into debugfs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   83 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   29 ++++++++++
 2 files changed, 29 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6c816d9..bc84fd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3109,87 +3109,6 @@ static ssize_t store_tx_power(struct device *d,
 
 static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
 
-static ssize_t show_flags(struct device *d,
-			  struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	return sprintf(buf, "0x%04X\n", priv->active_rxon.flags);
-}
-
-static ssize_t store_flags(struct device *d,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
-	u32 flags;
-	int ret = strict_strtoul(buf, 0, &val);
-	if (ret)
-		return ret;
-	flags = (u32)val;
-
-	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
-		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel_timeout(priv, 100))
-			IWL_WARN(priv, "Could not cancel scan.\n");
-		else {
-			IWL_DEBUG_INFO(priv, "Commit rxon.flags = 0x%04X\n", flags);
-			priv->staging_rxon.flags = cpu_to_le32(flags);
-			iwlcore_commit_rxon(priv);
-		}
-	}
-	mutex_unlock(&priv->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(flags, S_IWUSR | S_IRUGO, show_flags, store_flags);
-
-static ssize_t show_filter_flags(struct device *d,
-				 struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	return sprintf(buf, "0x%04X\n",
-		le32_to_cpu(priv->active_rxon.filter_flags));
-}
-
-static ssize_t store_filter_flags(struct device *d,
-				  struct device_attribute *attr,
-				  const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
-	u32 filter_flags;
-	int ret = strict_strtoul(buf, 0, &val);
-	if (ret)
-		return ret;
-	filter_flags = (u32)val;
-
-	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
-		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel_timeout(priv, 100))
-			IWL_WARN(priv, "Could not cancel scan.\n");
-		else {
-			IWL_DEBUG_INFO(priv, "Committing rxon.filter_flags = "
-				       "0x%04X\n", filter_flags);
-			priv->staging_rxon.filter_flags =
-				cpu_to_le32(filter_flags);
-			iwlcore_commit_rxon(priv);
-		}
-	}
-	mutex_unlock(&priv->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
-		   store_filter_flags);
-
-
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
@@ -3414,8 +3333,6 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 }
 
 static struct attribute *iwl_sysfs_entries[] = {
-	&dev_attr_flags.attr,
-	&dev_attr_filter_flags.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index fc084dd..50d0ee9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2093,6 +2093,31 @@ static ssize_t iwl_dbgfs_ucode_tracing_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_rxon_flags_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int len = 0;
+	char buf[20];
+
+	len = sprintf(buf, "0x%04X\n", le32_to_cpu(priv->active_rxon.flags));
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t iwl_dbgfs_rxon_filter_flags_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int len = 0;
+	char buf[20];
+
+	len = sprintf(buf, "0x%04X\n",
+		      le32_to_cpu(priv->active_rxon.filter_flags));
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
 static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
@@ -2296,6 +2321,8 @@ DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_WRITE_FILE_OPS(internal_scan);
 DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
+DEBUGFS_READ_FILE_OPS(rxon_flags);
+DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
 
 /*
  * Create the debugfs files and directories
@@ -2358,6 +2385,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	}
+	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 			 &priv->disable_chain_noise_cal);
-- 
1.6.3.3

