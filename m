Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27377 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbZLNWMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:25 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwlwifi: on-screen event log dump
Date: Mon, 14 Dec 2009 14:12:20 -0800
Message-Id: <1260828741-22749-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260828741-22749-1-git-send-email-reinette.chatre@intel.com>
References: <1260828741-22749-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This feature enables the on-screen uCode event log dump. The original
method will append the event log to syslog; with this capability,
we also enable the user to write script to capture the
events which provide additional flexibility to help uCode debugging

Method
1) change to debugfs directory (sys/kernel/debug/phyX/iwlagn/data)
2) #cat log_event

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  104 ++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   24 ++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  101 ++++++++++++++++++--------
 6 files changed, 171 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ecc23ec..28f6eb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -227,7 +227,8 @@ extern void iwl3945_rx_replenish(void *data);
 extern void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
-extern void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log);
+extern int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
+				       char **buf, bool display);
 extern void iwl3945_dump_nic_error_log(struct iwl_priv *priv);
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bacd4fe..904b5d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1832,8 +1832,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
  * iwl_print_event_log - Dump error event log to syslog
  *
  */
-static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
-				u32 num_events, u32 mode)
+static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
+			       u32 num_events, u32 mode,
+			       int pos, char **buf, size_t bufsz)
 {
 	u32 i;
 	u32 base;       /* SRAM byte address of event log header */
@@ -1843,7 +1844,7 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	unsigned long reg_flags;
 
 	if (num_events == 0)
-		return;
+		return pos;
 	if (priv->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
 	else
@@ -1871,27 +1872,44 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		time = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
-			trace_iwlwifi_dev_ucode_event(priv, 0, time, ev);
-			IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n", time, ev);
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"EVT_LOG:0x%08x:%04u\n",
+						time, ev);
+			} else {
+				trace_iwlwifi_dev_ucode_event(priv, 0,
+					time, ev);
+				IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n",
+					time, ev);
+			}
 		} else {
 			data = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-			IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"EVT_LOGT:%010u:0x%08x:%04u\n",
+						 time, data, ev);
+			} else {
+				IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
 					time, data, ev);
-			trace_iwlwifi_dev_ucode_event(priv, time, data, ev);
+				trace_iwlwifi_dev_ucode_event(priv, time,
+					data, ev);
+			}
 		}
 	}
 
 	/* Allow device to power down */
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	return pos;
 }
 
 /**
  * iwl_print_last_event_logs - Dump the newest # of event log to syslog
  */
-static void iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
-				      u32 num_wraps, u32 next_entry,
-				      u32 size, u32 mode)
+static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
+				    u32 num_wraps, u32 next_entry,
+				    u32 size, u32 mode,
+				    int pos, char **buf, size_t bufsz)
 {
 	/*
 	 * display the newest DEFAULT_LOG_ENTRIES entries
@@ -1899,21 +1917,26 @@ static void iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 	 */
 	if (num_wraps) {
 		if (next_entry < size) {
-			iwl_print_event_log(priv,
-					capacity - (size - next_entry),
-					size - next_entry, mode);
-			iwl_print_event_log(priv, 0,
-				    next_entry, mode);
+			pos = iwl_print_event_log(priv,
+						capacity - (size - next_entry),
+						size - next_entry, mode,
+						pos, buf, bufsz);
+			pos = iwl_print_event_log(priv, 0,
+						  next_entry, mode,
+						  pos, buf, bufsz);
 		} else
-			iwl_print_event_log(priv, next_entry - size,
-				    size, mode);
+			pos = iwl_print_event_log(priv, next_entry - size,
+						  size, mode, pos, buf, bufsz);
 	} else {
-		if (next_entry < size)
-			iwl_print_event_log(priv, 0, next_entry, mode);
-		else
-			iwl_print_event_log(priv, next_entry - size,
-					    size, mode);
+		if (next_entry < size) {
+			pos = iwl_print_event_log(priv, 0, next_entry,
+						  mode, pos, buf, bufsz);
+		} else {
+			pos = iwl_print_event_log(priv, next_entry - size,
+						  size, mode, pos, buf, bufsz);
+		}
 	}
+	return pos;
 }
 
 /* For sanity check only.  Actual size is determined by uCode, typ. 512 */
@@ -1921,7 +1944,8 @@ static void iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 
 #define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
 
-void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
+int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
+			    char **buf, bool display)
 {
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
@@ -1929,6 +1953,8 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 	u32 num_wraps;  /* # times uCode wrapped to top of log */
 	u32 next_entry; /* index of next entry to be written by uCode */
 	u32 size;       /* # entries that we'll print */
+	int pos = 0;
+	size_t bufsz = 0;
 
 	if (priv->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
@@ -1939,7 +1965,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 		IWL_ERR(priv,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base, (priv->ucode_type == UCODE_INIT) ? "Init" : "RT");
-		return;
+		return pos;
 	}
 
 	/* event log header */
@@ -1965,7 +1991,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
-		return;
+		return pos;
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -1980,6 +2006,15 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 		size);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
+	if (display) {
+		if (full_log)
+			bufsz = capacity * 48;
+		else
+			bufsz = size * 48;
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return pos;
+	}
 	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
 		/*
 		 * if uCode has wrapped back to top of log,
@@ -1987,17 +2022,22 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 		 * i.e the next one that uCode would fill.
 		 */
 		if (num_wraps)
-			iwl_print_event_log(priv, next_entry,
-					    capacity - next_entry, mode);
+			pos = iwl_print_event_log(priv, next_entry,
+						capacity - next_entry, mode,
+						pos, buf, bufsz);
 		/* (then/else) start at top of log */
-		iwl_print_event_log(priv, 0, next_entry, mode);
+		pos = iwl_print_event_log(priv, 0,
+					  next_entry, mode, pos, buf, bufsz);
 	} else
-		iwl_print_last_event_logs(priv, capacity, num_wraps,
-					next_entry, size, mode);
+		pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
+						next_entry, size, mode,
+						pos, buf, bufsz);
 #else
-	iwl_print_last_event_logs(priv, capacity, num_wraps,
-				next_entry, size, mode);
+	pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
+					next_entry, size, mode,
+					pos, buf, bufsz);
 #endif
+	return pos;
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b5d7c6f..e3b96b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1353,7 +1353,7 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	priv->cfg->ops->lib->dump_nic_error_log(priv);
 	if (priv->cfg->ops->lib->dump_csr)
 		priv->cfg->ops->lib->dump_csr(priv);
-	priv->cfg->ops->lib->dump_nic_event_log(priv, false);
+	priv->cfg->ops->lib->dump_nic_event_log(priv, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS)
 		iwl_print_rx_config_cmd(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 068bcc8..f7acbb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -169,7 +169,8 @@ struct iwl_lib_ops {
 	int (*is_valid_rtc_data_addr)(u32 addr);
 	/* 1st ucode load */
 	int (*load_ucode)(struct iwl_priv *priv);
-	void (*dump_nic_event_log)(struct iwl_priv *priv, bool full_log);
+	int (*dump_nic_event_log)(struct iwl_priv *priv,
+				  bool full_log, char **buf, bool display);
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
 	void (*dump_csr)(struct iwl_priv *priv);
 	int (*set_channel_switch)(struct iwl_priv *priv, u16 channel);
@@ -580,7 +581,8 @@ int iwl_pci_resume(struct pci_dev *pdev);
 *  Error Handling Debugging
 ******************************************************/
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
-void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log);
+int iwl_dump_nic_event_log(struct iwl_priv *priv,
+			   bool full_log, char **buf, bool display);
 void iwl_dump_csr(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 822de46..ee5aed1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -420,6 +420,23 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_log_event_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char *buf;
+	int pos = 0;
+	ssize_t ret = -ENOMEM;
+
+	pos = priv->cfg->ops->lib->dump_nic_event_log(priv, true, &buf, true);
+	if (pos && buf) {
+		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+		kfree(buf);
+	}
+	return ret;
+}
+
 static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
@@ -436,7 +453,8 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	if (sscanf(buf, "%d", &event_log_flag) != 1)
 		return -EFAULT;
 	if (event_log_flag == 1)
-		priv->cfg->ops->lib->dump_nic_event_log(priv, true);
+		priv->cfg->ops->lib->dump_nic_event_log(priv, true,
+							NULL, false);
 
 	return count;
 }
@@ -859,7 +877,7 @@ static ssize_t iwl_dbgfs_current_sleep_command_read(struct file *file,
 }
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
-DEBUGFS_WRITE_FILE_OPS(log_event);
+DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(channels);
@@ -1965,7 +1983,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_DIR(debug, dbgfs->dir_drv);
 	DEBUGFS_ADD_FILE(nvm, data, S_IRUSR);
 	DEBUGFS_ADD_FILE(sram, data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(log_event, data, S_IWUSR);
+	DEBUGFS_ADD_FILE(log_event, data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(stations, data, S_IRUSR);
 	DEBUGFS_ADD_FILE(channels, data, S_IRUSR);
 	DEBUGFS_ADD_FILE(status, data, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2a28a1f..f7c7ff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1560,8 +1560,9 @@ void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
  * iwl3945_print_event_log - Dump error event log to syslog
  *
  */
-static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
-				u32 num_events, u32 mode)
+static int iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
+				  u32 num_events, u32 mode,
+				  int pos, char **buf, size_t bufsz)
 {
 	u32 i;
 	u32 base;       /* SRAM byte address of event log header */
@@ -1571,7 +1572,7 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	unsigned long reg_flags;
 
 	if (num_events == 0)
-		return;
+		return pos;
 
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 
@@ -1597,26 +1598,43 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		time = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
-			IWL_ERR(priv, "0x%08x\t%04u\n", time, ev);
-			trace_iwlwifi_dev_ucode_event(priv, 0, time, ev);
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"0x%08x:%04u\n",
+						time, ev);
+			} else {
+				IWL_ERR(priv, "0x%08x\t%04u\n", time, ev);
+				trace_iwlwifi_dev_ucode_event(priv, 0,
+							      time, ev);
+			}
 		} else {
 			data = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-			IWL_ERR(priv, "%010u\t0x%08x\t%04u\n", time, data, ev);
-			trace_iwlwifi_dev_ucode_event(priv, time, data, ev);
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"%010u:0x%08x:%04u\n",
+						 time, data, ev);
+			} else {
+				IWL_ERR(priv, "%010u\t0x%08x\t%04u\n",
+					time, data, ev);
+				trace_iwlwifi_dev_ucode_event(priv, time,
+							      data, ev);
+			}
 		}
 	}
 
 	/* Allow device to power down */
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	return pos;
 }
 
 /**
  * iwl3945_print_last_event_logs - Dump the newest # of event log to syslog
  */
-static void iwl3945_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
+static int iwl3945_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 				      u32 num_wraps, u32 next_entry,
-				      u32 size, u32 mode)
+				      u32 size, u32 mode,
+				      int pos, char **buf, size_t bufsz)
 {
 	/*
 	 * display the newest DEFAULT_LOG_ENTRIES entries
@@ -1624,21 +1642,28 @@ static void iwl3945_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 	 */
 	if (num_wraps) {
 		if (next_entry < size) {
-			iwl3945_print_event_log(priv,
-					capacity - (size - next_entry),
-					size - next_entry, mode);
-			iwl3945_print_event_log(priv, 0,
-				    next_entry, mode);
+			pos = iwl3945_print_event_log(priv,
+					     capacity - (size - next_entry),
+					     size - next_entry, mode,
+					     pos, buf, bufsz);
+			pos = iwl3945_print_event_log(priv, 0,
+						      next_entry, mode,
+						      pos, buf, bufsz);
 		} else
-			iwl3945_print_event_log(priv, next_entry - size,
-				    size, mode);
+			pos = iwl3945_print_event_log(priv, next_entry - size,
+						      size, mode,
+						      pos, buf, bufsz);
 	} else {
 		if (next_entry < size)
-			iwl3945_print_event_log(priv, 0, next_entry, mode);
+			pos = iwl3945_print_event_log(priv, 0,
+						      next_entry, mode,
+						      pos, buf, bufsz);
 		else
-			iwl3945_print_event_log(priv, next_entry - size,
-					    size, mode);
+			pos = iwl3945_print_event_log(priv, next_entry - size,
+						      size, mode,
+						      pos, buf, bufsz);
 	}
+	return pos;
 }
 
 /* For sanity check only.  Actual size is determined by uCode, typ. 512 */
@@ -1646,7 +1671,8 @@ static void iwl3945_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 
 #define DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES (20)
 
-void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
+int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
+			    char **buf, bool display)
 {
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
@@ -1654,11 +1680,13 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 	u32 num_wraps;  /* # times uCode wrapped to top of log */
 	u32 next_entry; /* index of next entry to be written by uCode */
 	u32 size;       /* # entries that we'll print */
+	int pos = 0;
+	size_t bufsz = 0;
 
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
-		return;
+		return pos;
 	}
 
 	/* event log header */
@@ -1684,7 +1712,7 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
-		return;
+		return pos;
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -1700,25 +1728,38 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 		  size);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
+	if (display) {
+		if (full_log)
+			bufsz = capacity * 48;
+		else
+			bufsz = size * 48;
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return pos;
+	}
 	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
 		/* if uCode has wrapped back to top of log,
 		 * start at the oldest entry,
 		 * i.e the next one that uCode would fill.
 		 */
 		if (num_wraps)
-			iwl3945_print_event_log(priv, next_entry,
-				    capacity - next_entry, mode);
+			pos = iwl3945_print_event_log(priv, next_entry,
+						capacity - next_entry, mode,
+						pos, buf, bufsz);
 
 		/* (then/else) start at top of log */
-		iwl3945_print_event_log(priv, 0, next_entry, mode);
+		pos = iwl3945_print_event_log(priv, 0, next_entry, mode,
+					      pos, buf, bufsz);
 	} else
-		iwl3945_print_last_event_logs(priv, capacity, num_wraps,
-					next_entry, size, mode);
+		pos = iwl3945_print_last_event_logs(priv, capacity, num_wraps,
+						    next_entry, size, mode,
+						    pos, buf, bufsz);
 #else
-	iwl3945_print_last_event_logs(priv, capacity, num_wraps,
-				next_entry, size, mode);
+	pos = iwl3945_print_last_event_logs(priv, capacity, num_wraps,
+					    next_entry, size, mode,
+					    pos, buf, bufsz);
 #endif
-
+	return pos;
 }
 
 static void iwl3945_irq_tasklet(struct iwl_priv *priv)
-- 
1.5.6.3

