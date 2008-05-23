Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759581AbYEWCLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: trigger event log from debugfs
Date: Fri, 23 May 2008 10:09:04 +0800
Message-Id: <1211508569-3163-27-git-send-email-yi.zhu@intel.com> (sfid-20080523_042834_446158_3B096972)
In-Reply-To: <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch adds a trigger for event log printing to debugfs.
It removes the triger from sysfs.

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |  101 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 ++
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   32 ++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  114 +--------------------------
 5 files changed, 143 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 21f481e..7e25ca4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1055,3 +1055,104 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_verify_ucode);
 
+
+#define EVENT_START_OFFSET  (4 * sizeof(u32))
+
+/**
+ * iwl_print_event_log - Dump error event log to syslog
+ *
+ * NOTE: Must be called with iwl4965_grab_nic_access() already obtained!
+ */
+void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
+				u32 num_events, u32 mode)
+{
+	u32 i;
+	u32 base;       /* SRAM byte address of event log header */
+	u32 event_size; /* 2 u32s, or 3 u32s if timestamp recorded */
+	u32 ptr;        /* SRAM byte address of log data */
+	u32 ev, time, data; /* event log data */
+
+	if (num_events == 0)
+		return;
+
+	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+
+	if (mode == 0)
+		event_size = 2 * sizeof(u32);
+	else
+		event_size = 3 * sizeof(u32);
+
+	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
+
+	/* "time" is actually "data" for mode 0 (no timestamp).
+	* place event id # at far right for easier visual parsing. */
+	for (i = 0; i < num_events; i++) {
+		ev = iwl_read_targ_mem(priv, ptr);
+		ptr += sizeof(u32);
+		time = iwl_read_targ_mem(priv, ptr);
+		ptr += sizeof(u32);
+		if (mode == 0)
+			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
+		else {
+			data = iwl_read_targ_mem(priv, ptr);
+			ptr += sizeof(u32);
+			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
+		}
+	}
+}
+EXPORT_SYMBOL(iwl_print_event_log);
+
+
+void iwl_dump_nic_event_log(struct iwl_priv *priv)
+{
+	int rc;
+	u32 base;       /* SRAM byte address of event log header */
+	u32 capacity;   /* event log capacity in # entries */
+	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
+	u32 num_wraps;  /* # times uCode wrapped to top of log */
+	u32 next_entry; /* index of next entry to be written by uCode */
+	u32 size;       /* # entries that we'll print */
+
+	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
+		return;
+	}
+
+	rc = iwl_grab_nic_access(priv);
+	if (rc) {
+		IWL_WARNING("Can not read from adapter at this time.\n");
+		return;
+	}
+
+	/* event log header */
+	capacity = iwl_read_targ_mem(priv, base);
+	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
+
+	size = num_wraps ? capacity : next_entry;
+
+	/* bail out if nothing in log */
+	if (size == 0) {
+		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
+		iwl_release_nic_access(priv);
+		return;
+	}
+
+	IWL_ERROR("Start IWL Event Log Dump: display count %d, wraps %d\n",
+			size, num_wraps);
+
+	/* if uCode has wrapped back to top of log, start at the oldest entry,
+	 * i.e the next one that uCode would fill. */
+	if (num_wraps)
+		iwl_print_event_log(priv, next_entry,
+					capacity - next_entry, mode);
+	/* (then/else) start at top of log */
+	iwl_print_event_log(priv, 0, next_entry, mode);
+
+	iwl_release_nic_access(priv);
+}
+EXPORT_SYMBOL(iwl_dump_nic_event_log);
+
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 774aa7c..a8d062f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -232,6 +232,14 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 					   struct sk_buff *skb));
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+
+/*****************************************************
+*  Error Handling Debugging
+******************************************************/
+void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
+			 u32 num_events, u32 mode);
+void iwl_dump_nic_event_log(struct iwl_priv *priv);
+
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
 #define STATUS_HCMD_ACTIVE	0	/* host command in progress */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index c3f8e90..11de561 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -52,6 +52,7 @@ struct iwl_debugfs {
 		struct dentry *file_stations;
 		struct dentry *file_rx_statistics;
 		struct dentry *file_tx_statistics;
+		struct dentry *file_log_event;
 	} dbgfs_data_files;
 	struct dir_rf_files {
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index f7ec200..c64e602 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -92,6 +92,14 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.open = iwl_dbgfs_open_file_generic,                    	\
 };
 
+#define DEBUGFS_WRITE_FILE_OPS(name)                                    \
+	DEBUGFS_WRITE_FUNC(name);                                       \
+static const struct file_operations iwl_dbgfs_##name##_ops = {          \
+	.write = iwl_dbgfs_##name##_write,                              \
+	.open = iwl_dbgfs_open_file_generic,                    	\
+};
+
+
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)                               \
 	DEBUGFS_READ_FUNC(name);                                        \
 	DEBUGFS_WRITE_FUNC(name);                                       \
@@ -324,7 +332,29 @@ static ssize_t iwl_dbgfs_eeprom_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_log_event_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	u32 event_log_flag;
+	char buf[8];
+	int buf_size;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &event_log_flag) != 1)
+		return -EFAULT;
+	if (event_log_flag == 1)
+		iwl_dump_nic_event_log(priv);
+
+	return count;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
+DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(eeprom);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(rx_statistics);
@@ -354,6 +384,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_DIR(rf, dbgfs->dir_drv);
 	DEBUGFS_ADD_FILE(eeprom, data);
 	DEBUGFS_ADD_FILE(sram, data);
+	DEBUGFS_ADD_FILE(log_event, data);
 	DEBUGFS_ADD_FILE(stations, data);
 	DEBUGFS_ADD_FILE(rx_statistics, data);
 	DEBUGFS_ADD_FILE(tx_statistics, data);
@@ -384,6 +415,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_rx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_tx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_log_event);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 05edde1..48c59cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2692,103 +2692,6 @@ static void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 }
 
-#define EVENT_START_OFFSET  (4 * sizeof(u32))
-
-/**
- * iwl4965_print_event_log - Dump error event log to syslog
- *
- * NOTE: Must be called with iwl_grab_nic_access() already obtained!
- */
-static void iwl4965_print_event_log(struct iwl_priv *priv, u32 start_idx,
-				u32 num_events, u32 mode)
-{
-	u32 i;
-	u32 base;       /* SRAM byte address of event log header */
-	u32 event_size;	/* 2 u32s, or 3 u32s if timestamp recorded */
-	u32 ptr;        /* SRAM byte address of log data */
-	u32 ev, time, data; /* event log data */
-
-	if (num_events == 0)
-		return;
-
-	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-
-	if (mode == 0)
-		event_size = 2 * sizeof(u32);
-	else
-		event_size = 3 * sizeof(u32);
-
-	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
-
-	/* "time" is actually "data" for mode 0 (no timestamp).
-	 * place event id # at far right for easier visual parsing. */
-	for (i = 0; i < num_events; i++) {
-		ev = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
-		time = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
-		if (mode == 0)
-			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
-		else {
-			data = iwl_read_targ_mem(priv, ptr);
-			ptr += sizeof(u32);
-			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
-		}
-	}
-}
-
-static void iwl4965_dump_nic_event_log(struct iwl_priv *priv)
-{
-	int rc;
-	u32 base;       /* SRAM byte address of event log header */
-	u32 capacity;   /* event log capacity in # entries */
-	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
-	u32 num_wraps;  /* # times uCode wrapped to top of log */
-	u32 next_entry; /* index of next entry to be written by uCode */
-	u32 size;       /* # entries that we'll print */
-
-	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
-		return;
-	}
-
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		IWL_WARNING("Can not read from adapter at this time.\n");
-		return;
-	}
-
-	/* event log header */
-	capacity = iwl_read_targ_mem(priv, base);
-	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
-
-	size = num_wraps ? capacity : next_entry;
-
-	/* bail out if nothing in log */
-	if (size == 0) {
-		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
-		iwl_release_nic_access(priv);
-		return;
-	}
-
-	IWL_ERROR("Start IWL Event Log Dump: display count %d, wraps %d\n",
-		  size, num_wraps);
-
-	/* if uCode has wrapped back to top of log, start at the oldest entry,
-	 * i.e the next one that uCode would fill. */
-	if (num_wraps)
-		iwl4965_print_event_log(priv, next_entry,
-				    capacity - next_entry, mode);
-
-	/* (then/else) start at top of log */
-	iwl4965_print_event_log(priv, 0, next_entry, mode);
-
-	iwl_release_nic_access(priv);
-}
-
 /**
  * iwl4965_irq_handle_error - called for HW or SW error interrupt from card
  */
@@ -2803,7 +2706,7 @@ static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & IWL_DL_FW_ERRORS) {
 		iwl4965_dump_nic_error_log(priv);
-		iwl4965_dump_nic_event_log(priv);
+		iwl_dump_nic_event_log(priv);
 		iwl4965_print_rx_config_cmd(priv);
 	}
 #endif
@@ -5640,20 +5543,6 @@ static ssize_t dump_error_log(struct device *d,
 
 static DEVICE_ATTR(dump_errors, S_IWUSR, NULL, dump_error_log);
 
-static ssize_t dump_event_log(struct device *d,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	char *p = (char *)buf;
-
-	if (p[0] == '1')
-		iwl4965_dump_nic_event_log((struct iwl_priv *)d->driver_data);
-
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(dump_events, S_IWUSR, NULL, dump_event_log);
-
 /*****************************************************************************
  *
  * driver setup and teardown
@@ -5700,7 +5589,6 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 static struct attribute *iwl4965_sysfs_entries[] = {
 	&dev_attr_channels.attr,
 	&dev_attr_dump_errors.attr,
-	&dev_attr_dump_events.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
-- 
1.5.3.6

