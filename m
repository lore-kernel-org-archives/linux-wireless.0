Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbZKMT4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:43 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/16] iwlwifi: update reply_statistics_cmd with 'clear' parameter
Date: Fri, 13 Nov 2009 11:56:28 -0800
Message-Id: <1258142198-3223-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When issue REPLY_STATISTICS_CMD to uCode, two possible flag
can be set in the configuration flags

bit 0: Clear statistics
       0: Do not clear Statistics counters
       1: Clear to zero Statistics counters

Allow "clear" parameter to be set from the caller.

Add debugfs file to clear the statistics counters to help monitor and
debug the uCode behavior.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   21 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 +++-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   39 +++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   18 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 10 files changed, 77 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 24baf2c..d2050d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -613,7 +613,7 @@ static void iwl_bg_statistics_periodic(unsigned long data)
 	if (!iwl_is_ready_rf(priv))
 		return;
 
-	iwl_send_statistics_request(priv, CMD_ASYNC);
+	iwl_send_statistics_request(priv, CMD_ASYNC, false);
 }
 
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
@@ -730,7 +730,7 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	 * statistics request from the host as well as for the periodic
 	 * statistics notifications (after received beacons) from the uCode.
 	 */
-	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl_rx_statistics;
+	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl_reply_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl_rx_statistics;
 
 	iwl_setup_spectrum_handlers(priv);
@@ -2893,7 +2893,7 @@ static ssize_t show_statistics(struct device *d,
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
-	rc = iwl_send_statistics_request(priv, 0);
+	rc = iwl_send_statistics_request(priv, CMD_SYNC, false);
 	mutex_unlock(&priv->mutex);
 
 	if (rc) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index d994de7..95a57b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -900,7 +900,7 @@ void iwl_reset_run_time_calib(struct iwl_priv *priv)
 
 	/* Ask for statistics now, the uCode will send notification
 	 * periodically after association */
-	iwl_send_statistics_request(priv, CMD_ASYNC);
+	iwl_send_statistics_request(priv, CMD_ASYNC, true);
 }
 EXPORT_SYMBOL(iwl_reset_run_time_calib);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 2857287..6e23a2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3071,6 +3071,10 @@ struct statistics_general {
 	__le32 reserved3;
 } __attribute__ ((packed));
 
+#define UCODE_STATISTICS_CLEAR_MSK		(0x1 << 0)
+#define UCODE_STATISTICS_FREQUENCY_MSK		(0x1 << 1)
+#define UCODE_STATISTICS_NARROW_BAND_MSK	(0x1 << 2)
+
 /*
  * REPLY_STATISTICS_CMD = 0x9c,
  * 3945 and 4965 identical.
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6b18aab..83b7f60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1991,16 +1991,21 @@ int iwl_send_bt_config(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_send_bt_config);
 
-int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
+int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 {
-	u32 stat_flags = 0;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_STATISTICS_CMD,
-		.flags = flags,
-		.len = sizeof(stat_flags),
-		.data = (u8 *) &stat_flags,
+	struct iwl_statistics_cmd statistics_cmd = {
+		.configuration_flags =
+			clear ? IWL_STATS_CONF_CLEAR_STATS : 0,
 	};
-	return iwl_send_cmd(priv, &cmd);
+
+	if (flags & CMD_ASYNC)
+		return iwl_send_cmd_pdu_async(priv, REPLY_STATISTICS_CMD,
+					       sizeof(struct iwl_statistics_cmd),
+					       &statistics_cmd, NULL);
+	else
+		return iwl_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+					sizeof(struct iwl_statistics_cmd),
+					&statistics_cmd);
 }
 EXPORT_SYMBOL(iwl_send_statistics_request);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3f97036..584a376 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -425,6 +425,8 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
+void iwl_reply_statistics(struct iwl_priv *priv,
+			  struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
 /* TX helpers */
@@ -669,7 +671,8 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 
 extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
 extern int iwl_send_bt_config(struct iwl_priv *priv);
-extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
+extern int iwl_send_statistics_request(struct iwl_priv *priv,
+				       u8 flags, bool clear);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
 extern int iwl_send_lq_cmd(struct iwl_priv *priv,
 		struct iwl_link_quality_cmd *lq, u8 flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 96c92ea..25a0e73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -107,6 +107,7 @@ struct iwl_debugfs {
 		struct dentry *file_chain_noise;
 		struct dentry *file_tx_power;
 		struct dentry *file_power_save_status;
+		struct dentry *file_clear_statistics;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 8784911..45a5edd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1042,10 +1042,6 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-#define UCODE_STATISTICS_CLEAR_MSK		(0x1 << 0)
-#define UCODE_STATISTICS_FREQUENCY_MSK		(0x1 << 1)
-#define UCODE_STATISTICS_NARROW_BAND_MSK	(0x1 << 2)
-
 static int iwl_dbgfs_statistics_flag(struct iwl_priv *priv, char *buf,
 				     int bufsz)
 {
@@ -1092,7 +1088,7 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 
 	/* make request to uCode to retrieve statistics information */
 	mutex_lock(&priv->mutex);
-	ret = iwl_send_statistics_request(priv, 0);
+	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
 	mutex_unlock(&priv->mutex);
 
 	if (ret) {
@@ -1398,7 +1394,7 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 
 	/* make request to uCode to retrieve statistics information */
 	mutex_lock(&priv->mutex);
-	ret = iwl_send_statistics_request(priv, 0);
+	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
 	mutex_unlock(&priv->mutex);
 
 	if (ret) {
@@ -1542,7 +1538,7 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 
 	/* make request to uCode to retrieve statistics information */
 	mutex_lock(&priv->mutex);
-	ret = iwl_send_statistics_request(priv, 0);
+	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
 	mutex_unlock(&priv->mutex);
 
 	if (ret) {
@@ -1770,7 +1766,7 @@ static ssize_t iwl_dbgfs_tx_power_read(struct file *file,
 	else {
 		/* make request to uCode to retrieve statistics information */
 		mutex_lock(&priv->mutex);
-		ret = iwl_send_statistics_request(priv, 0);
+		ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
 		mutex_unlock(&priv->mutex);
 
 		if (ret) {
@@ -1828,6 +1824,30 @@ static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_clear_statistics_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int clear;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &clear) != 1)
+		return -EFAULT;
+
+	/* make request to uCode to retrieve statistics information */
+	mutex_lock(&priv->mutex);
+	iwl_send_statistics_request(priv, CMD_SYNC, true);
+	mutex_unlock(&priv->mutex);
+
+	return count;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1840,6 +1860,7 @@ DEBUGFS_READ_FILE_OPS(sensitivity);
 DEBUGFS_READ_FILE_OPS(chain_noise);
 DEBUGFS_READ_FILE_OPS(tx_power);
 DEBUGFS_READ_FILE_OPS(power_save_status);
+DEBUGFS_WRITE_FILE_OPS(clear_statistics);
 
 /*
  * Create the debugfs files and directories
@@ -1888,6 +1909,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(tx_queue, debug);
 	DEBUGFS_ADD_FILE(tx_power, debug);
 	DEBUGFS_ADD_FILE(power_save_status, debug);
+	DEBUGFS_ADD_FILE(clear_statistics, debug);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug);
@@ -1941,6 +1963,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_queue);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_power);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_power_save_status);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_clear_statistics);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 9bce2c1..8ccc0bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -506,7 +506,7 @@ static void iwl_prepare_ct_kill_task(struct iwl_priv *priv)
 {
 	IWL_DEBUG_POWER(priv, "Prepare to enter IWL_TI_CT_KILL\n");
 	/* make request to retrieve statistics information */
-	iwl_send_statistics_request(priv, 0);
+	iwl_send_statistics_request(priv, CMD_SYNC, false);
 	/* Reschedule the ct_kill wait timer */
 	mod_timer(&priv->thermal_throttle.ct_kill_waiting_tm,
 		 jiffies + msecs_to_jiffies(CT_KILL_WAITING_DURATION));
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 61b3b0e..9d010a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -635,6 +635,24 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_statistics);
 
+void iwl_reply_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
+	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
+		memset(&priv->statistics, 0,
+			sizeof(struct iwl_notif_statistics));
+#ifdef CONFIG_IWLWIFI_DEBUG
+		memset(&priv->accum_statistics, 0,
+			sizeof(struct iwl_notif_statistics));
+#endif
+		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
+	}
+	iwl_rx_statistics(priv, rxb);
+}
+EXPORT_SYMBOL(iwl_reply_statistics);
+
 #define PERFECT_RSSI (-20) /* dBm */
 #define WORST_RSSI (-95)   /* dBm */
 #define RSSI_RANGE (PERFECT_RSSI - WORST_RSSI)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5d26330..1e05c91 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3650,7 +3650,7 @@ static ssize_t show_statistics(struct device *d,
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
-	rc = iwl_send_statistics_request(priv, 0);
+	rc = iwl_send_statistics_request(priv, CMD_SYNC, false);
 	mutex_unlock(&priv->mutex);
 
 	if (rc) {
-- 
1.5.6.3

