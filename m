Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZKTUFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/19] iwlwifi: print limited number of event log when uCode error
Date: Fri, 20 Nov 2009 12:05:07 -0800
Message-Id: <1258747510-21233-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

To help iwlagn uCode debugging, event log will dump to syslog when driver
detect uCode error occurred, but this only happen when compile with
CONFIG_IWLWIFI_DEBUG and debug flag is enabled; which is not always
the case. Also, there is another problem, if the flag is set, the entire
event log buffer will be dump to syslog, it can flood the syslog and
make it very difficult to debug the problem.

Change the default to only dump last 20 entries of event log to syslog
unless the following condition meets:
1. both compile with CONFIG_IWLWIFI_DEBUG and debug flag
is enabled, and then dump the entire event buffer to syslog.
2. dump event log request from debugfs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Acked-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   76 ++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 +--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 ++++++++++++++++++++++----
 6 files changed, 130 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a41f0e0..ecc23ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -227,7 +227,7 @@ extern void iwl3945_rx_replenish(void *data);
 extern void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
-extern void iwl3945_dump_nic_event_log(struct iwl_priv *priv);
+extern void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log);
 extern void iwl3945_dump_nic_error_log(struct iwl_priv *priv);
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 463e31a..c96513b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1697,8 +1697,6 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
 
 /**
@@ -1759,10 +1757,42 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
 
+/**
+ * iwl_print_last_event_logs - Dump the newest # of event log to syslog
+ */
+static void iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
+				      u32 num_wraps, u32 next_entry,
+				      u32 size, u32 mode)
+{
+	/*
+	 * display the newest DEFAULT_LOG_ENTRIES entries
+	 * i.e the entries just before the next ont that uCode would fill.
+	 */
+	if (num_wraps) {
+		if (next_entry < size) {
+			iwl_print_event_log(priv,
+					capacity - (size - next_entry),
+					size - next_entry, mode);
+			iwl_print_event_log(priv, 0,
+				    next_entry, mode);
+		} else
+			iwl_print_event_log(priv, next_entry - size,
+				    size, mode);
+	} else {
+		if (next_entry < size)
+			iwl_print_event_log(priv, 0, next_entry, mode);
+		else
+			iwl_print_event_log(priv, next_entry - size,
+					    size, mode);
+	}
+}
+
 /* For sanity check only.  Actual size is determined by uCode, typ. 512 */
 #define MAX_EVENT_LOG_SIZE (512)
 
-void iwl_dump_nic_event_log(struct iwl_priv *priv)
+#define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
+
+void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 {
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
@@ -1807,19 +1837,37 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	IWL_ERR(priv, "Start IWL Event Log Dump: display count %d, wraps %d\n",
-			size, num_wraps);
-
-	/* if uCode has wrapped back to top of log, start at the oldest entry,
-	 * i.e the next one that uCode would fill. */
-	if (num_wraps)
-		iwl_print_event_log(priv, next_entry,
-					capacity - next_entry, mode);
-	/* (then/else) start at top of log */
-	iwl_print_event_log(priv, 0, next_entry, mode);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS))
+		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
+			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
+#else
+	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
+		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
+#endif
+	IWL_ERR(priv, "Start IWL Event Log Dump: display last %u entries\n",
+		size);
 
-}
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
+		/*
+		 * if uCode has wrapped back to top of log,
+		 * start at the oldest entry,
+		 * i.e the next one that uCode would fill.
+		 */
+		if (num_wraps)
+			iwl_print_event_log(priv, next_entry,
+					    capacity - next_entry, mode);
+		/* (then/else) start at top of log */
+		iwl_print_event_log(priv, 0, next_entry, mode);
+	} else
+		iwl_print_last_event_logs(priv, capacity, num_wraps,
+					next_entry, size, mode);
+#else
+	iwl_print_last_event_logs(priv, capacity, num_wraps,
+				next_entry, size, mode);
 #endif
+}
 
 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 159d555..574d366 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1363,11 +1363,10 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 	priv->cfg->ops->lib->dump_nic_error_log(priv);
+	priv->cfg->ops->lib->dump_nic_event_log(priv, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) {
-		priv->cfg->ops->lib->dump_nic_event_log(priv);
+	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS)
 		iwl_print_rx_config_cmd(priv);
-	}
 #endif
 
 	wake_up_interruptible(&priv->wait_command_queue);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1f99a5b..f1d6fdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -167,7 +167,7 @@ struct iwl_lib_ops {
 	int (*is_valid_rtc_data_addr)(u32 addr);
 	/* 1st ucode load */
 	int (*load_ucode)(struct iwl_priv *priv);
-	void (*dump_nic_event_log)(struct iwl_priv *priv);
+	void (*dump_nic_event_log)(struct iwl_priv *priv, bool full_log);
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
 	int (*set_channel_switch)(struct iwl_priv *priv, u16 channel);
 	/* power management */
@@ -579,14 +579,10 @@ int iwl_pci_resume(struct pci_dev *pdev);
 *  Error Handling Debugging
 ******************************************************/
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
+void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log);
 #ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_dump_nic_event_log(struct iwl_priv *priv);
 void iwl_print_rx_config_cmd(struct iwl_priv *priv);
 #else
-static inline void iwl_dump_nic_event_log(struct iwl_priv *priv)
-{
-}
-
 static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 {
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 5adf0b6..21e0f66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -436,7 +436,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	if (sscanf(buf, "%d", &event_log_flag) != 1)
 		return -EFAULT;
 	if (event_log_flag == 1)
-		priv->cfg->ops->lib->dump_nic_event_log(priv);
+		priv->cfg->ops->lib->dump_nic_event_log(priv, true);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8dc7f77..0db9b79 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1483,7 +1483,6 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
 static const char *desc_lookup(int i)
 {
 	switch (i) {
@@ -1614,10 +1613,42 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
 
+/**
+ * iwl3945_print_last_event_logs - Dump the newest # of event log to syslog
+ */
+static void iwl3945_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
+				      u32 num_wraps, u32 next_entry,
+				      u32 size, u32 mode)
+{
+	/*
+	 * display the newest DEFAULT_LOG_ENTRIES entries
+	 * i.e the entries just before the next ont that uCode would fill.
+	 */
+	if (num_wraps) {
+		if (next_entry < size) {
+			iwl3945_print_event_log(priv,
+					capacity - (size - next_entry),
+					size - next_entry, mode);
+			iwl3945_print_event_log(priv, 0,
+				    next_entry, mode);
+		} else
+			iwl3945_print_event_log(priv, next_entry - size,
+				    size, mode);
+	} else {
+		if (next_entry < size)
+			iwl3945_print_event_log(priv, 0, next_entry, mode);
+		else
+			iwl3945_print_event_log(priv, next_entry - size,
+					    size, mode);
+	}
+}
+
 /* For sanity check only.  Actual size is determined by uCode, typ. 512 */
 #define IWL3945_MAX_EVENT_LOG_SIZE (512)
 
-void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
+#define DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES (20)
+
+void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 {
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
@@ -1658,8 +1689,17 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	IWL_ERR(priv, "Start IWL Event Log Dump: display count %d, wraps %d\n",
-		  size, num_wraps);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS))
+		size = (size > DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES)
+			? DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES : size;
+#else
+	size = (size > DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES)
+		? DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES : size;
+#endif
+
+	IWL_ERR(priv, "Start IWL Event Log Dump: display last %d count\n",
+		  size);
 
 	/* if uCode has wrapped back to top of log, start at the oldest entry,
 	 * i.e the next one that uCode would fill. */
@@ -1670,18 +1710,28 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	/* (then/else) start at top of log */
 	iwl3945_print_event_log(priv, 0, next_entry, mode);
 
-}
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
+		/* if uCode has wrapped back to top of log,
+		 * start at the oldest entry,
+		 * i.e the next one that uCode would fill.
+		 */
+		if (num_wraps)
+			iwl3945_print_event_log(priv, next_entry,
+				    capacity - next_entry, mode);
+
+		/* (then/else) start at top of log */
+		iwl3945_print_event_log(priv, 0, next_entry, mode);
+	} else
+		iwl3945_print_last_event_logs(priv, capacity, num_wraps,
+					next_entry, size, mode);
 #else
-void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
-{
-}
+	iwl3945_print_last_event_logs(priv, capacity, num_wraps,
+				next_entry, size, mode);
+#endif
 
-void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
-{
 }
 
-#endif
-
 static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
-- 
1.5.6.3

