Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934487Ab1IOTcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/27] iwlagn: move sysfs files to debugfs
Date: Thu, 15 Sep 2011 11:46:48 -0700
Message-Id: <1316112414-6341-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213236_392882_D34C6211)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The debug_level and temperature files should be in
debugfs, the txpower file is completely unneeded
since TX power can be set with iw/iwconfig.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |  125 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   72 ++++++++++++++--
 2 files changed, 64 insertions(+), 133 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5c85133..84ba428 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -453,122 +453,6 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 }
 
-/*****************************************************************************
- *
- * sysfs attributes
- *
- *****************************************************************************/
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-
-/*
- * The following adds a new attribute to the sysfs representation
- * of this device driver (i.e. a new file in /sys/class/net/wlan0/device/)
- * used for controlling the debug level.
- *
- * See the level definitions in iwl for details.
- *
- * The debug_level being managed using sysfs below is a per device debug
- * level that is used instead of the global debug level if it (the per
- * device debug level) is set.
- */
-static ssize_t show_debug_level(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_shared *shrd = dev_get_drvdata(d);
-	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(shrd));
-}
-static ssize_t store_debug_level(struct device *d,
-				struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct iwl_shared *shrd = dev_get_drvdata(d);
-	struct iwl_priv *priv = shrd->priv;
-	unsigned long val;
-	int ret;
-
-	ret = strict_strtoul(buf, 0, &val);
-	if (ret)
-		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
-	else {
-		shrd->dbg_level_dev = val;
-		if (iwl_alloc_traffic_mem(priv))
-			IWL_ERR(shrd->priv,
-				"Not enough memory to generate traffic log\n");
-	}
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
-			show_debug_level, store_debug_level);
-
-
-#endif /* CONFIG_IWLWIFI_DEBUG */
-
-
-static ssize_t show_temperature(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_shared *shrd = dev_get_drvdata(d);
-	struct iwl_priv *priv = shrd->priv;
-
-	if (!iwl_is_alive(priv->shrd))
-		return -EAGAIN;
-
-	return sprintf(buf, "%d\n", priv->temperature);
-}
-
-static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
-
-static ssize_t show_tx_power(struct device *d,
-			     struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	if (!iwl_is_ready_rf(priv->shrd))
-		return sprintf(buf, "off\n");
-	else
-		return sprintf(buf, "%d\n", priv->tx_power_user_lmt);
-}
-
-static ssize_t store_tx_power(struct device *d,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
-		IWL_INFO(priv, "%s is not in decimal form.\n", buf);
-	else {
-		ret = iwl_set_tx_power(priv, val, false);
-		if (ret)
-			IWL_ERR(priv, "failed setting tx power (0x%d).\n",
-				ret);
-		else
-			ret = count;
-	}
-	return ret;
-}
-
-static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
-
-static struct attribute *iwl_sysfs_entries[] = {
-	&dev_attr_temperature.attr,
-	&dev_attr_tx_power.attr,
-#ifdef CONFIG_IWLWIFI_DEBUG
-	&dev_attr_debug_level.attr,
-#endif
-	NULL
-};
-
-static struct attribute_group iwl_attribute_group = {
-	.name = NULL,		/* put in device directory */
-	.attrs = iwl_sysfs_entries,
-};
-
 /******************************************************************************
  *
  * uCode download functions
@@ -1259,13 +1143,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
 
-	err = sysfs_create_group(&(priv->bus->dev->kobj),
-					&iwl_attribute_group);
-	if (err) {
-		IWL_ERR(priv, "failed to create sysfs device attributes\n");
-		goto out_unbind;
-	}
-
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
 	complete(&priv->firmware_loading_complete);
@@ -3474,8 +3351,6 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
 	iwl_dbgfs_unregister(priv);
-	sysfs_remove_group(&priv->bus->dev->kobj,
-			   &iwl_attribute_group);
 
 	/* ieee80211_unregister_hw call wil cause iwl_mac_stop to
 	 * to be called and iwl_down since we are removing the device
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d0c63cf..bf2a678 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -64,6 +64,14 @@
 		goto err;						\
 } while (0)
 
+#define DEBUGFS_ADD_U32(name, parent, ptr, mode) do {			\
+	struct dentry *__tmp;						\
+	__tmp = debugfs_create_u32(#name, mode,				\
+				   parent, ptr);			\
+	if (IS_ERR(__tmp) || !__tmp)					\
+		goto err;						\
+} while (0)
+
 /* file operation */
 #define DEBUGFS_READ_FUNC(name)                                         \
 static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
@@ -2229,8 +2237,8 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 
 static ssize_t iwl_dbgfs_force_reset_read(struct file *file,
 					char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
+					size_t count, loff_t *ppos)
+{
 	struct iwl_priv *priv = file->private_data;
 	int i, pos = 0;
 	char buf[300];
@@ -2309,8 +2317,8 @@ static ssize_t iwl_dbgfs_txfifo_flush_write(struct file *file,
 
 static ssize_t iwl_dbgfs_wd_timeout_write(struct file *file,
 					const char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
+					size_t count, loff_t *ppos)
+{
 	struct iwl_priv *priv = file->private_data;
 	char buf[8];
 	int buf_size;
@@ -2445,6 +2453,52 @@ DEBUGFS_READ_FILE_OPS(bt_traffic);
 DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+static ssize_t iwl_dbgfs_debug_level_read(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	struct iwl_shared *shrd = priv->shrd;
+	char buf[11];
+	int len;
+
+	len = scnprintf(buf, sizeof(buf), "0x%.8x",
+			iwl_get_debug_level(shrd));
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t iwl_dbgfs_debug_level_write(struct file *file,
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	struct iwl_shared *shrd = priv->shrd;
+	char buf[11];
+	unsigned long val;
+	int ret;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	memset(buf, 0, sizeof(buf));
+	if (copy_from_user(buf, user_buf, count))
+		return -EFAULT;
+
+	ret = strict_strtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	shrd->dbg_level_dev = val;
+	if (iwl_alloc_traffic_mem(priv))
+		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
+
+	return count;
+}
+DEBUGFS_READ_WRITE_FILE_OPS(debug_level);
+#endif /* CONFIG_IWLWIFI_DEBUG */
+
 /*
  * Create the debugfs files and directories
  *
@@ -2482,6 +2536,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_U32(temperature, dir_data, &priv->temperature, S_IRUSR);
+
 	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
@@ -2496,7 +2552,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(protection_mode, dir_debug, S_IWUSR | S_IRUSR);
-
 	DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
@@ -2507,6 +2562,10 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
 	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	DEBUGFS_ADD_FILE(debug_level, dir_debug, S_IRUSR | S_IWUSR);
+#endif
+
 	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 			 &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
@@ -2534,6 +2593,3 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	debugfs_remove_recursive(priv->debugfs_dir);
 	priv->debugfs_dir = NULL;
 }
-
-
-
-- 
1.7.0.4

