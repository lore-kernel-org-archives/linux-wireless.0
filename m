Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0HWOxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/26] iwlwifi: add debugfs to control stuck queue timer
Date: Mon, 23 Aug 2010 07:57:07 -0700
Message-Id: <1282575437-23270-17-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In current implementation, stuck queue timer is fixed to 1 second. Add
debugfs file to modify the timer to enhance the flexibility:

Set the monitor_period as following:
   0: disable stuck queue force reset function
   1 - 60000: monitor period (1 - 60 second)

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |   14 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   30 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 13d2dce..34cba38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2697,12 +2697,14 @@ void iwl_bg_monitor_recover(unsigned long data)
 				return;
 		}
 	}
-	/*
-	 * Reschedule the timer to occur in
-	 * priv->cfg->monitor_recover_period
-	 */
-	mod_timer(&priv->monitor_recover,
-		jiffies + msecs_to_jiffies(priv->cfg->monitor_recover_period));
+	if (priv->cfg->monitor_recover_period) {
+		/*
+		 * Reschedule the timer to occur in
+		 * priv->cfg->monitor_recover_period
+		 */
+		mod_timer(&priv->monitor_recover, jiffies + msecs_to_jiffies(
+			  priv->cfg->monitor_recover_period));
+	}
 }
 EXPORT_SYMBOL(iwl_bg_monitor_recover);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d3acdae..aae9eb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1527,6 +1527,34 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 			user_buf, count, ppos);
 }
 
+static ssize_t iwl_dbgfs_monitor_period_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int period;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &period) != 1)
+		return -EINVAL;
+	if (period < 0 || period > IWL_MAX_MONITORING_PERIOD)
+		priv->cfg->monitor_recover_period = IWL_DEF_MONITORING_PERIOD;
+	else
+		priv->cfg->monitor_recover_period = period;
+
+	if (priv->cfg->monitor_recover_period)
+		mod_timer(&priv->monitor_recover, jiffies + msecs_to_jiffies(
+			  priv->cfg->monitor_recover_period));
+	else
+		del_timer_sync(&priv->monitor_recover);
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1550,6 +1578,7 @@ DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
 DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
 DEBUGFS_READ_FILE_OPS(ucode_bt_stats);
+DEBUGFS_WRITE_FILE_OPS(monitor_period);
 
 /*
  * Create the debugfs files and directories
@@ -1621,6 +1650,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(monitor_period, dir_debug, S_IWUSR);
 	if (priv->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 				 &priv->disable_sens_cal);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7a96d9d..bb92a7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1064,6 +1064,7 @@ struct iwl_event_log {
 #define IWL_DEF_MONITORING_PERIOD	(1000)
 #define IWL_LONG_MONITORING_PERIOD	(5000)
 #define IWL_ONE_HUNDRED_MSECS   (100)
+#define IWL_MAX_MONITORING_PERIOD	(60000)
 
 /* BT Antenna Coupling Threshold (dB) */
 #define IWL_BT_ANTENNA_COUPLING_THRESHOLD	(35)
-- 
1.7.0.4

