Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1415 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbZHGWmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:42:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/16] iwlwifi: automatically adjust sleep level
Date: Fri,  7 Aug 2009 15:41:51 -0700
Message-Id: <1249684912-22936-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Depending on required latency requested by pm_qos (via mac80211)
we can automatically adjust the sleep state. Also, mac80211 has
a user-visible dynamic sleep feature where we are supposed to
stay awake after sending/receiving frames to better receive
response frames to our packets, this can be integrated into the
sleep command.

Currently, and this patch doesn't change that yet, we default
to using sleep level 1 if PS is enabled. With a module parameter
to iwlcore, automatic adjustment to changing network latency
requirements can be enabled -- this isn't yet the default due
to requiring more testing.

The goal is to enable automatic adjustment and then go into the
deepest possible sleep state possible depending on the networking
latency requirements.

This patch does, however, enable IEEE80211_HW_SUPPORTS_DYNAMIC_PS
to avoid the double-timer (one in software and one in the device)
when transmitting -- the exact timeout may be ignored but that is
not of big concern.

Note also that we keep the hard-coded power indices around for
thermal throttling -- the specification of that calls for using
the specified power levels. Those can also be selected in debugfs
to allow easier testing of such parameters.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   46 +----
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   15 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   83 +++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c    |  317 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-power.h    |   30 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   66 +------
 10 files changed, 256 insertions(+), 313 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 319df4a..2232b17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1606,7 +1606,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
-	iwl_power_update_mode(priv, 1);
+	iwl_power_update_mode(priv, true);
 
 	/* reassociate for ADHOC mode */
 	if (priv->vif && (priv->iw_mode == NL80211_IFTYPE_ADHOC)) {
@@ -2075,7 +2075,7 @@ void iwl_post_associate(struct iwl_priv *priv)
 	 * If chain noise has already been run, then we need to enable
 	 * power management here */
 	if (priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE)
-		iwl_power_update_mode(priv, 0);
+		iwl_power_update_mode(priv, false);
 
 	/* Enable Rx differential gain and sensitivity calibrations */
 	iwl_chain_noise_reset(priv);
@@ -2565,47 +2565,6 @@ static ssize_t store_filter_flags(struct device *d,
 static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 		   store_filter_flags);
 
-static ssize_t store_power_level(struct device *d,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	int ret;
-	unsigned long mode;
-
-
-	mutex_lock(&priv->mutex);
-
-	ret = strict_strtoul(buf, 10, &mode);
-	if (ret)
-		goto out;
-
-	ret = iwl_power_set_user_mode(priv, mode);
-	if (ret) {
-		IWL_DEBUG_MAC80211(priv, "failed setting power mode.\n");
-		goto out;
-	}
-	ret = count;
-
- out:
-	mutex_unlock(&priv->mutex);
-	return ret;
-}
-
-static ssize_t show_power_level(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	int level = priv->power_data.power_mode;
-	char *p = buf;
-
-	p += sprintf(p, "%d\n", level);
-	return p - buf + 1;
-}
-
-static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
-		   store_power_level);
-
 
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
@@ -2698,7 +2657,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-	&dev_attr_power_level.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 13180d6..c4b565a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -852,7 +852,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		priv->cfg->ops->lib->update_chain_flags(priv);
 
 	data->state = IWL_CHAIN_NOISE_DONE;
-	iwl_power_update_mode(priv, 0);
+	iwl_power_update_mode(priv, false);
 }
 EXPORT_SYMBOL(iwl_chain_noise_calibration);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6188c54..68d7719 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2313,15 +2313,22 @@ struct iwl_spectrum_notification {
  * PM allow:
  *   bit 0 - '0' Driver not allow power management
  *           '1' Driver allow PM (use rest of parameters)
+ *
  * uCode send sleep notifications:
  *   bit 1 - '0' Don't send sleep notification
  *           '1' send sleep notification (SEND_PM_NOTIFICATION)
+ *
  * Sleep over DTIM
  *   bit 2 - '0' PM have to walk up every DTIM
  *           '1' PM could sleep over DTIM till listen Interval.
+ *
  * PCI power managed
  *   bit 3 - '0' (PCI_CFG_LINK_CTRL & 0x1)
  *           '1' !(PCI_CFG_LINK_CTRL & 0x1)
+ *
+ * Fast PD
+ *   bit 4 - '1' Put radio to sleep when receiving frame for others
+ *
  * Force sleep Modes
  *   bit 31/30- '00' use both mac/xtal sleeps
  *              '01' force Mac sleep
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 36c6e16..af73512 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1568,7 +1568,8 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_SUPPORTS_PS;
+		    IEEE80211_HW_SUPPORTS_PS |
+		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
@@ -1663,8 +1664,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_cap.val = 0;
 
 	priv->rates_mask = IWL_RATES_MASK;
-	/* If power management is turned on, default to CAM mode */
-	priv->power_mode = IWL_POWER_MODE_CAM;
 	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MAX;
 
 	ret = iwl_init_channel_map(priv);
@@ -2551,7 +2550,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		if (bss_conf->assoc) {
 			priv->assoc_id = bss_conf->aid;
 			priv->beacon_int = bss_conf->beacon_int;
-			priv->power_data.dtim_period = bss_conf->dtim_period;
 			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
 
@@ -2801,13 +2799,10 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwl_set_rate(priv);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_PS &&
-	    priv->iw_mode == NL80211_IFTYPE_STATION) {
-		priv->power_data.power_disabled =
-			!(conf->flags & IEEE80211_CONF_PS);
-		ret = iwl_power_update_mode(priv, 0);
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		ret = iwl_power_update_mode(priv, false);
 		if (ret)
-			IWL_DEBUG_MAC80211(priv, "Error setting power level\n");
+			IWL_DEBUG_MAC80211(priv, "Error setting sleep level\n");
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 82befb7..723f38a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -88,6 +88,8 @@ struct iwl_debugfs {
 		struct dentry *file_led;
 #endif
 		struct dentry *file_disable_ht40;
+		struct dentry *file_sleep_level_override;
+		struct dentry *file_current_sleep_command;
 	} dbgfs_data_files;
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 7b578d4..f68fb47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -776,6 +776,83 @@ static ssize_t iwl_dbgfs_disable_ht40_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
+						    const char __user *user_buf,
+						    size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int value;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	if (sscanf(buf, "%d", &value) != 1)
+		return -EINVAL;
+
+	/*
+	 * Our users expect 0 to be "CAM", but 0 isn't actually
+	 * valid here. However, let's not confuse them and present
+	 * IWL_POWER_INDEX_1 as "1", not "0".
+	 */
+	if (value > 0)
+		value -= 1;
+
+	if (value != -1 && (value < 0 || value >= IWL_POWER_NUM))
+		return -EINVAL;
+
+	priv->power_data.debug_sleep_level_override = value;
+
+	iwl_power_update_mode(priv, false);
+
+	return count;
+}
+
+static ssize_t iwl_dbgfs_sleep_level_override_read(struct file *file,
+						   char __user *user_buf,
+						   size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[10];
+	int pos, value;
+	const size_t bufsz = sizeof(buf);
+
+	/* see the write function */
+	value = priv->power_data.debug_sleep_level_override;
+	if (value >= 0)
+		value += 1;
+
+	pos = scnprintf(buf, bufsz, "%d\n", value);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t iwl_dbgfs_current_sleep_command_read(struct file *file,
+						    char __user *user_buf,
+						    size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[200];
+	int pos = 0, i;
+	const size_t bufsz = sizeof(buf);
+	struct iwl_powertable_cmd *cmd = &priv->power_data.sleep_cmd;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "flags: %#.2x\n", le16_to_cpu(cmd->flags));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "RX/TX timeout: %d/%d usec\n",
+			 le32_to_cpu(cmd->rx_data_timeout),
+			 le32_to_cpu(cmd->tx_data_timeout));
+	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "sleep_interval[%d]: %d\n", i,
+				 le32_to_cpu(cmd->sleep_interval[i]));
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
@@ -789,6 +866,8 @@ DEBUGFS_READ_FILE_OPS(led);
 #endif
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
+DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
+DEBUGFS_READ_FILE_OPS(current_sleep_command);
 
 static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 					 char __user *user_buf,
@@ -1533,6 +1612,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 #ifdef CONFIG_IWLWIFI_LEDS
 	DEBUGFS_ADD_FILE(led, data);
 #endif
+	DEBUGFS_ADD_FILE(sleep_level_override, data);
+	DEBUGFS_ADD_FILE(current_sleep_command, data);
 	DEBUGFS_ADD_FILE(thermal_throttling, data);
 	DEBUGFS_ADD_FILE(disable_ht40, data);
 	DEBUGFS_ADD_FILE(rx_statistics, debug);
@@ -1572,6 +1653,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	if (!priv->dbgfs)
 		return;
 
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sleep_level_override);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_current_sleep_command);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_nvm);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_log_event);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1aa2ae6..b96c3c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1119,7 +1119,6 @@ struct iwl_priv {
 	/* context information */
 	u16 rates_mask;
 
-	u32 power_mode;
 	u8 bssid[ETH_ALEN];
 	u16 rts_threshold;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 27ad59d..0b16841 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -42,20 +42,35 @@
 #include "iwl-power.h"
 
 /*
- * Setting power level allow the card to go to sleep when not busy.
+ * Setting power level allows the card to go to sleep when not busy.
  *
- * The power level is set to INDEX_1 (the least deep state) by
- * default, and will, in the future, be the deepest state unless
- * otherwise required by pm_qos network latency requirements.
- *
- * Using INDEX_1 without pm_qos is ok because mac80211 will disable
- * PS when even checking every beacon for the TIM bit would exceed
- * the required latency.
+ * We calculate a sleep command based on the required latency, which
+ * we get from mac80211. In order to handle thermal throttling, we can
+ * also use pre-defined power levels.
  */
 
-#define IWL_POWER_RANGE_0_MAX  (2)
-#define IWL_POWER_RANGE_1_MAX  (10)
+/*
+ * For now, keep using power level 1 instead of automatically
+ * adjusting ...
+ */
+bool no_sleep_autoadjust = true;
+module_param(no_sleep_autoadjust, bool, S_IRUGO);
+MODULE_PARM_DESC(no_sleep_autoadjust,
+		 "don't automatically adjust sleep level "
+		 "according to maximum network latency");
 
+/*
+ * This defines the old power levels. They are still used by default
+ * (level 1) and for thermal throttle (levels 3 through 5)
+ */
+
+struct iwl_power_vec_entry {
+	struct iwl_powertable_cmd cmd;
+	u8 no_dtim;
+};
+
+#define IWL_DTIM_RANGE_0_MAX	2
+#define IWL_DTIM_RANGE_1_MAX	10
 
 #define NOSLP cpu_to_le16(0), 0, 0
 #define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
@@ -67,9 +82,8 @@
 				     cpu_to_le32(X3), \
 				     cpu_to_le32(X4)}
 /* default power management (not Tx power) table values */
-/* for DTIM period 0 through IWL_POWER_RANGE_0_MAX */
+/* for DTIM period 0 through IWL_DTIM_RANGE_0_MAX */
 static const struct iwl_power_vec_entry range_0[IWL_POWER_NUM] = {
-	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 2, 2, 2, 0xFF)}, 0},
@@ -78,9 +92,8 @@ static const struct iwl_power_vec_entry range_0[IWL_POWER_NUM] = {
 };
 
 
-/* for DTIM period IWL_POWER_RANGE_0_MAX + 1 through IWL_POWER_RANGE_1_MAX */
+/* for DTIM period IWL_DTIM_RANGE_0_MAX + 1 through IWL_DTIM_RANGE_1_MAX */
 static const struct iwl_power_vec_entry range_1[IWL_POWER_NUM] = {
-	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 3, 4, 7)}, 0},
 	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 4, 6, 7, 9)}, 0},
@@ -88,9 +101,8 @@ static const struct iwl_power_vec_entry range_1[IWL_POWER_NUM] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(2, 4, 7, 10, 10)}, 2}
 };
 
-/* for DTIM period > IWL_POWER_RANGE_1_MAX */
+/* for DTIM period > IWL_DTIM_RANGE_1_MAX */
 static const struct iwl_power_vec_entry range_2[IWL_POWER_NUM] = {
-	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
@@ -98,6 +110,56 @@ static const struct iwl_power_vec_entry range_2[IWL_POWER_NUM] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
+static void iwl_static_sleep_cmd(struct iwl_priv *priv,
+				 struct iwl_powertable_cmd *cmd,
+				 enum iwl_power_level lvl, int period)
+{
+	const struct iwl_power_vec_entry *table;
+	int max_sleep, i;
+	bool skip;
+
+	table = range_2;
+	if (period < IWL_DTIM_RANGE_1_MAX)
+		table = range_1;
+	if (period < IWL_DTIM_RANGE_0_MAX)
+		table = range_0;
+
+	BUG_ON(lvl < 0 || lvl >= IWL_POWER_NUM);
+
+	*cmd = table[lvl].cmd;
+
+	if (period == 0) {
+		skip = false;
+		period = 1;
+	} else {
+		skip = !!table[lvl].no_dtim;
+	}
+
+	if (skip) {
+		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
+		max_sleep = le32_to_cpu(slp_itrvl);
+		if (max_sleep == 0xFF)
+			max_sleep = period * (skip + 1);
+		else if (max_sleep > period)
+			max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
+		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
+	} else {
+		max_sleep = period;
+		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
+	}
+
+	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
+		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
+			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
+
+	if (priv->power_data.pci_pm)
+		cmd->flags |= IWL_POWER_PCI_PM_MSK;
+	else
+		cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
+
+	IWL_DEBUG_POWER(priv, "Sleep command for index %d\n", lvl + 1);
+}
+
 /* default Thermal Throttling transaction table
  * Current state   |         Throttling Down               |  Throttling Up
  *=============================================================================
@@ -138,98 +200,44 @@ static const struct iwl_tt_restriction restriction_range[IWL_TI_STATE_MAX] = {
 	{IWL_ANT_OK_NONE, IWL_ANT_OK_NONE, false }
 };
 
-/* set card power command */
-static int iwl_set_power(struct iwl_priv *priv, void *cmd)
-{
-	return iwl_send_cmd_pdu(priv, POWER_TABLE_CMD,
-				sizeof(struct iwl_powertable_cmd), cmd);
-}
 
-/* initialize to default */
-static void iwl_power_init_handle(struct iwl_priv *priv)
+static void iwl_power_sleep_cam_cmd(struct iwl_priv *priv,
+				    struct iwl_powertable_cmd *cmd)
 {
-	struct iwl_power_mgr *pow_data;
-	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_NUM;
-	struct iwl_powertable_cmd *cmd;
-	int i;
-	u16 lctl;
-
-	IWL_DEBUG_POWER(priv, "Initialize power \n");
-
-	pow_data = &priv->power_data;
-
-	memset(pow_data, 0, sizeof(*pow_data));
-
-	memcpy(&pow_data->pwr_range_0[0], &range_0[0], size);
-	memcpy(&pow_data->pwr_range_1[0], &range_1[0], size);
-	memcpy(&pow_data->pwr_range_2[0], &range_2[0], size);
-
-	lctl = iwl_pcie_link_ctl(priv);
+	memset(cmd, 0, sizeof(*cmd));
 
-	IWL_DEBUG_POWER(priv, "adjust power command flags\n");
+	if (priv->power_data.pci_pm)
+		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
-	for (i = 0; i < IWL_POWER_NUM; i++) {
-		cmd = &pow_data->pwr_range_0[i].cmd;
-
-		if (lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN)
-			cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
-		else
-			cmd->flags |= IWL_POWER_PCI_PM_MSK;
-	}
+	IWL_DEBUG_POWER(priv, "Sleep command for CAM\n");
 }
 
-/* adjust power command according to DTIM period and power level*/
-static int iwl_update_power_cmd(struct iwl_priv *priv,
-				struct iwl_powertable_cmd *cmd, u16 mode)
+static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
+				     struct iwl_powertable_cmd *cmd,
+				     int dynps_ms, int wakeup_period)
 {
-	struct iwl_power_vec_entry *range;
-	struct iwl_power_mgr *pow_data;
 	int i;
-	u32 max_sleep = 0;
-	u8 period;
-	bool skip;
 
-	if (mode > IWL_POWER_INDEX_5) {
-		IWL_DEBUG_POWER(priv, "Error invalid power mode \n");
-		return -EINVAL;
-	}
+	memset(cmd, 0, sizeof(*cmd));
 
-	pow_data = &priv->power_data;
+	cmd->flags = IWL_POWER_DRIVER_ALLOW_SLEEP_MSK |
+		     IWL_POWER_FAST_PD; /* no use seeing frames for others */
 
-	if (pow_data->dtim_period <= IWL_POWER_RANGE_0_MAX)
-		range = &pow_data->pwr_range_0[0];
-	else if (pow_data->dtim_period <= IWL_POWER_RANGE_1_MAX)
-		range = &pow_data->pwr_range_1[0];
-	else
-		range = &pow_data->pwr_range_2[0];
+	if (priv->power_data.pci_pm)
+		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
-	period = pow_data->dtim_period;
-	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl_powertable_cmd));
-
-	if (period == 0) {
-		period = 1;
-		skip = false;
-	} else {
-		skip = !!range[mode].no_dtim;
-	}
-
-	if (skip) {
-		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
-		max_sleep = le32_to_cpu(slp_itrvl);
-		if (max_sleep == 0xFF)
-			max_sleep = period * (skip + 1);
-		else if (max_sleep >  period)
-			max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
-		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	} else {
-		max_sleep = period;
-		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	}
+	cmd->rx_data_timeout = cpu_to_le32(1000 * dynps_ms);
+	cmd->tx_data_timeout = cpu_to_le32(1000 * dynps_ms);
 
 	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
-		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
-			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
+		cmd->sleep_interval[i] = cpu_to_le32(wakeup_period);
+
+	IWL_DEBUG_POWER(priv, "Automatic sleep command\n");
+}
 
+static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
+{
+	IWL_DEBUG_POWER(priv, "Sending power/sleep command\n");
 	IWL_DEBUG_POWER(priv, "Flags value = 0x%08X\n", cmd->flags);
 	IWL_DEBUG_POWER(priv, "Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
 	IWL_DEBUG_POWER(priv, "Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
@@ -240,50 +248,54 @@ static int iwl_update_power_cmd(struct iwl_priv *priv,
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return 0;
+	return iwl_send_cmd_pdu(priv, POWER_TABLE_CMD,
+				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
 
-/*
- * compute the final power mode index
- */
 int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
-	struct iwl_power_mgr *setting = &(priv->power_data);
 	int ret = 0;
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	u16 uninitialized_var(final_mode);
+	bool enabled = (priv->iw_mode == NL80211_IFTYPE_STATION) &&
+			(priv->hw->conf.flags & IEEE80211_CONF_PS);
 	bool update_chains;
+	struct iwl_powertable_cmd cmd;
+	int dtimper;
 
 	/* Don't update the RX chain when chain noise calibration is running */
 	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
 			priv->chain_noise_data.state == IWL_CHAIN_NOISE_ALIVE;
 
-	final_mode = priv->power_data.user_power_setting;
-
-	if (setting->power_disabled)
-		final_mode = IWL_POWER_MODE_CAM;
+	if (priv->vif)
+		dtimper = priv->vif->bss_conf.dtim_period;
+	else
+		dtimper = 1;
+
+	/* TT power setting overwrites everything */
+	if (tt->state >= IWL_TI_1)
+		iwl_static_sleep_cmd(priv, &cmd, tt->tt_power_mode, dtimper);
+	else if (!enabled)
+		iwl_power_sleep_cam_cmd(priv, &cmd);
+	else if (priv->power_data.debug_sleep_level_override >= 0)
+		iwl_static_sleep_cmd(priv, &cmd,
+				     priv->power_data.debug_sleep_level_override,
+				     dtimper);
+	else if (no_sleep_autoadjust)
+		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_1, dtimper);
+	else
+		iwl_power_fill_sleep_cmd(priv, &cmd,
+					 priv->hw->conf.dynamic_ps_timeout,
+					 priv->hw->conf.max_sleep_period);
 
-	if (tt->state >= IWL_TI_1) {
-		/* TT power setting overwrite user & system power setting */
-		final_mode = tt->tt_power_mode;
-	}
 	if (iwl_is_ready_rf(priv) &&
-	    ((setting->power_mode != final_mode) || force)) {
-		struct iwl_powertable_cmd cmd;
-
-		if (final_mode != IWL_POWER_MODE_CAM)
+	    (memcmp(&priv->power_data.sleep_cmd, &cmd, sizeof(cmd)) || force)) {
+		if (cmd.flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK)
 			set_bit(STATUS_POWER_PMI, &priv->status);
 
-		iwl_update_power_cmd(priv, &cmd, final_mode);
-		cmd.keep_alive_beacons = 0;
-
-		if (final_mode == IWL_POWER_INDEX_5)
-			cmd.flags |= IWL_POWER_FAST_PD;
-
 		ret = iwl_set_power(priv, &cmd);
 		if (!ret) {
-			if (final_mode == IWL_POWER_MODE_CAM)
+			if (!(cmd.flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK))
 				clear_bit(STATUS_POWER_PMI, &priv->status);
 
 			if (priv->cfg->ops->lib->update_chain_flags &&
@@ -294,7 +306,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 					"Cannot update the power, chain noise "
 					"calibration running: %d\n",
 					priv->chain_noise_data.state);
-			setting->power_mode = final_mode;
+			memcpy(&priv->power_data.sleep_cmd, &cmd, sizeof(cmd));
 		} else
 			IWL_ERR(priv, "set power fail, ret = %d", ret);
 	}
@@ -303,18 +315,6 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 }
 EXPORT_SYMBOL(iwl_power_update_mode);
 
-/* set user_power_setting */
-int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
-{
-	if (mode >= IWL_POWER_NUM)
-		return -EINVAL;
-
-	priv->power_data.user_power_setting = mode;
-
-	return iwl_power_update_mode(priv, 0);
-}
-EXPORT_SYMBOL(iwl_power_set_user_mode);
-
 bool iwl_ht_enabled(struct iwl_priv *priv)
 {
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
@@ -349,7 +349,6 @@ enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv)
 	restriction = tt->restriction + tt->state;
 	return restriction->rx_stream;
 }
-EXPORT_SYMBOL(iwl_rx_ant_restriction);
 
 #define CT_KILL_EXIT_DURATION (5)	/* 5 seconds duration */
 
@@ -429,7 +428,6 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 {
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	enum iwl_tt_state old_state;
-	struct iwl_power_mgr *setting = &priv->power_data;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if ((tt->tt_previous_temp) &&
@@ -456,24 +454,13 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 	tt->tt_previous_temp = temp;
 #endif
 	if (tt->state != old_state) {
-		if (old_state == IWL_TI_0) {
-			tt->sys_power_mode = setting->power_mode;
-			IWL_DEBUG_POWER(priv, "current power mode: %u\n",
-				setting->power_mode);
-		}
 		switch (tt->state) {
 		case IWL_TI_0:
-			/* when system ready to go back to IWL_TI_0 state
-			 * using system power mode instead of TT power mode
-			 * revert back to the orginal power mode which was saved
-			 * before enter Thermal Throttling state
-			 * update priv->power_data.user_power_setting to the
-			 * required power mode to make sure
-			 * iwl_power_update_mode() will update power correctly.
+			/*
+			 * When the system is ready to go back to IWL_TI_0
+			 * we only have to call iwl_power_update_mode() to
+			 * do so.
 			 */
-			priv->power_data.user_power_setting =
-				tt->sys_power_mode;
-			tt->tt_power_mode = tt->sys_power_mode;
 			break;
 		case IWL_TI_1:
 			tt->tt_power_mode = IWL_POWER_INDEX_3;
@@ -576,13 +563,8 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 	}
 	if (changed) {
 		struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
-		struct iwl_power_mgr *setting = &priv->power_data;
 
 		if (tt->state >= IWL_TI_1) {
-			/* if switching from IWL_TI_0 to other TT state
-			 * save previous power setting in tt->sys_power_mode */
-			if (old_state == IWL_TI_0)
-				tt->sys_power_mode = setting->power_mode;
 			/* force PI = IWL_POWER_INDEX_5 in the case of TI > 0 */
 			tt->tt_power_mode = IWL_POWER_INDEX_5;
 			if (!iwl_ht_enabled(priv))
@@ -599,17 +581,11 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 			}
 
 		} else {
-			/* restore system power setting */
-			/* the previous power mode was saved in
-			 * tt->sys_power_mode when system move into
-			 * Thermal Throttling state
-			 * set power_data.user_power_setting to the previous
-			 * system power mode to make sure power will get
-			 * updated correctly
+			/*
+			 * restore system power setting -- it will be
+			 * recalculated automatically.
 			 */
-			priv->power_data.user_power_setting =
-				tt->sys_power_mode;
-			tt->tt_power_mode = tt->sys_power_mode;
+
 			/* check HT capability and set
 			 * according to the system HT capability
 			 * in case get disabled before */
@@ -761,7 +737,6 @@ EXPORT_SYMBOL(iwl_tt_handler);
 void iwl_tt_initialize(struct iwl_priv *priv)
 {
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	struct iwl_power_mgr *setting = &priv->power_data;
 	int size = sizeof(struct iwl_tt_trans) * (IWL_TI_STATE_MAX - 1);
 	struct iwl_tt_trans *transaction;
 
@@ -770,8 +745,6 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
 
 	tt->state = IWL_TI_0;
-	tt->sys_power_mode = setting->power_mode;
-	tt->tt_power_mode = tt->sys_power_mode;
 	init_timer(&priv->thermal_throttle.ct_kill_exit_tm);
 	priv->thermal_throttle.ct_kill_exit_tm.data = (unsigned long)priv;
 	priv->thermal_throttle.ct_kill_exit_tm.function = iwl_tt_check_exit_ct_kill;
@@ -849,9 +822,13 @@ EXPORT_SYMBOL(iwl_tt_exit);
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-	iwl_power_init_handle(priv);
-	priv->power_data.user_power_setting = IWL_POWER_INDEX_1;
-	/* default to disabled until mac80211 says otherwise */
-	priv->power_data.power_disabled = 1;
+	u16 lctl = iwl_pcie_link_ctl(priv);
+
+	priv->power_data.pci_pm = !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
+
+	priv->power_data.debug_sleep_level_override = -1;
+
+	memset(&priv->power_data.sleep_cmd, 0,
+		sizeof(priv->power_data.sleep_cmd));
 }
 EXPORT_SYMBOL(iwl_power_initialize);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 15e3eab..df6f6a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -28,11 +28,8 @@
 #ifndef __iwl_power_setting_h__
 #define __iwl_power_setting_h__
 
-#include <net/mac80211.h>
 #include "iwl-commands.h"
 
-struct iwl_priv;
-
 #define IWL_ABSOLUTE_ZERO		0
 #define IWL_ABSOLUTE_MAX		0xFFFFFFFF
 #define IWL_TT_INCREASE_MARGIN	5
@@ -93,8 +90,6 @@ struct iwl_tt_trans {
  * 		    when thermal throttling state != IWL_TI_0
  *		    the tt_power_mode should set to different
  *		    power mode based on the current tt state
- * @sys_power_mode: previous system power mode
- *                  before transition into TT state
  * @tt_previous_temperature: last measured temperature
  * @iwl_tt_restriction: ptr to restriction tbl, used by advance
  *		    thermal throttling to determine how many tx/rx streams
@@ -108,7 +103,6 @@ struct iwl_tt_mgmt {
 	enum iwl_tt_state state;
 	bool advanced_tt;
 	u8 tt_power_mode;
-	u8 sys_power_mode;
 	bool ct_kill_toggle;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	s32 tt_previous_temp;
@@ -118,8 +112,7 @@ struct iwl_tt_mgmt {
 	struct timer_list ct_kill_exit_tm;
 };
 
-enum {
-	IWL_POWER_MODE_CAM, /* Continuously Aware Mode, always on */
+enum iwl_power_level {
 	IWL_POWER_INDEX_1,
 	IWL_POWER_INDEX_2,
 	IWL_POWER_INDEX_3,
@@ -128,26 +121,13 @@ enum {
 	IWL_POWER_NUM
 };
 
-/* Power management (not Tx power) structures */
-
-struct iwl_power_vec_entry {
-	struct iwl_powertable_cmd cmd;
-	u8 no_dtim;
-};
-
 struct iwl_power_mgr {
-	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_NUM];
-	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_NUM];
-	struct iwl_power_vec_entry pwr_range_2[IWL_POWER_NUM];
-	u32 dtim_period;
-	/* final power level that used to calculate final power command */
-	u8 power_mode;
-	u8 user_power_setting; /* set by user through sysfs */
-	u8 power_disabled; /* set by mac80211's CONF_PS */
+	struct iwl_powertable_cmd sleep_cmd;
+	int debug_sleep_level_override;
+	bool pci_pm;
 };
 
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
-int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
 bool iwl_ht_enabled(struct iwl_priv *priv);
 enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv);
 enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv);
@@ -158,4 +138,6 @@ void iwl_tt_initialize(struct iwl_priv *priv);
 void iwl_tt_exit(struct iwl_priv *priv);
 void iwl_power_initialize(struct iwl_priv *priv);
 
+extern bool no_sleep_autoadjust;
+
 #endif  /* __iwl_power_setting_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e5fa672..e617411 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3554,65 +3554,6 @@ static DEVICE_ATTR(retry_rate, S_IWUSR | S_IRUSR, show_retry_rate,
 		   store_retry_rate);
 
 
-static ssize_t store_power_level(struct device *d,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	int ret;
-	unsigned long mode;
-
-
-	mutex_lock(&priv->mutex);
-
-	ret = strict_strtoul(buf, 10, &mode);
-	if (ret)
-		goto out;
-
-	ret = iwl_power_set_user_mode(priv, mode);
-	if (ret) {
-		IWL_DEBUG_MAC80211(priv, "failed setting power mode.\n");
-		goto out;
-	}
-	ret = count;
-
- out:
-	mutex_unlock(&priv->mutex);
-	return ret;
-}
-
-static ssize_t show_power_level(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	int level = priv->power_data.power_mode;
-	char *p = buf;
-
-	p += sprintf(p, "%d\n", level);
-	return p - buf + 1;
-}
-
-static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR,
-		   show_power_level, store_power_level);
-
-#define MAX_WX_STRING 80
-
-/* Values are in microsecond */
-static const s32 timeout_duration[] = {
-	350000,
-	250000,
-	75000,
-	37000,
-	25000,
-};
-static const s32 period_duration[] = {
-	400000,
-	700000,
-	1000000,
-	1000000,
-	1000000
-};
-
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
@@ -3789,7 +3730,6 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	&dev_attr_measurement.attr,
 #endif
-	&dev_attr_power_level.attr,
 	&dev_attr_retry_rate.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
@@ -3854,8 +3794,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_cap.val = 0;
 
 	priv->rates_mask = IWL_RATES_MASK;
-	/* If power management is turned on, default to CAM mode */
-	priv->power_mode = IWL_POWER_MODE_CAM;
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
@@ -3902,7 +3840,9 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
-		    IEEE80211_HW_SPECTRUM_MGMT;
+		    IEEE80211_HW_SPECTRUM_MGMT |
+		    IEEE80211_HW_SUPPORTS_PS |
+		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-- 
1.5.6.3

