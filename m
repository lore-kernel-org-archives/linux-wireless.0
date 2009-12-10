Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761920AbZLJWhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/7] iwlwifi: add continuous uCode event log capability
Date: Thu, 10 Dec 2009 14:37:26 -0800
Message-Id: <1260484647-5114-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In order to help uCode debugging, adding the capability to provide
continuous uCode event logging function.

uCode events is located in round-robin event queue and filled by uCode,
by enable continuous event logging, driver check the write pointer
and log the newly added events in iwl_bg_ucode_trace() timer function.

There is still possibility of missing events if event queue being
wrapped before next event dump; but with this capability, we can have
much better understanding of the uCode behavior during runtime; it can
help to debug the uCode related issues.

Methods to enable/disable the continuous event log:
step 1: enable ucode trace timer
     "echo 1 >
/sys/kernel/debug/ieee80211/phyX/iwlagn/debug/ucode_tracing"
step 2: start ftrace
     sudo ./trace-cmd record -e iwlwifi_ucode:* sleep 1d
step 3: stop ftrace
     sudo ./trace-cmd report trace.dat
step 4: disable ucode trace timer
     "echo 0 >
/sys/kernel/debug/ieee80211/phyX/iwlagn/debug/ucode_tracing"

use "ucode_tracing" debugfs file to display number of event
queue wrapped when driver attempt the continuous event logging. If event
queue being wrapped more than once when driver has opportunity to log
the event; it indicated there are events missing in the event log trace.

This continuous event log function only available for 4965 and newer
NICs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  130 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   56 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   29 ++++++
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   44 +++++++++
 6 files changed, 262 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 36704b2..906b516 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -657,6 +657,131 @@ static void iwl_bg_statistics_periodic(unsigned long data)
 	iwl_send_statistics_request(priv, CMD_ASYNC, false);
 }
 
+
+static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
+					u32 start_idx, u32 num_events,
+					u32 mode)
+{
+	u32 i;
+	u32 ptr;        /* SRAM byte address of log data */
+	u32 ev, time, data; /* event log data */
+	unsigned long reg_flags;
+
+	if (mode == 0)
+		ptr = base + (4 * sizeof(u32)) + (start_idx * 2 * sizeof(u32));
+	else
+		ptr = base + (4 * sizeof(u32)) + (start_idx * 3 * sizeof(u32));
+
+	/* Make sure device is powered up for SRAM reads */
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	if (iwl_grab_nic_access(priv)) {
+		spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+		return;
+	}
+
+	/* Set starting address; reads will auto-increment */
+	_iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	rmb();
+
+	/*
+	 * "time" is actually "data" for mode 0 (no timestamp).
+	 * place event id # at far right for easier visual parsing.
+	 */
+	for (i = 0; i < num_events; i++) {
+		ev = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		time = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		if (mode == 0) {
+			trace_iwlwifi_dev_ucode_cont_event(priv,
+							0, time, ev);
+		} else {
+			data = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+			trace_iwlwifi_dev_ucode_cont_event(priv,
+						time, data, ev);
+		}
+	}
+	/* Allow device to power down */
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+}
+
+void iwl_continuous_event_trace(struct iwl_priv *priv)
+{
+	u32 capacity;   /* event log capacity in # entries */
+	u32 base;       /* SRAM byte address of event log header */
+	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
+	u32 num_wraps;  /* # times uCode wrapped to top of log */
+	u32 next_entry; /* index of next entry to be written by uCode */
+
+	if (priv->ucode_type == UCODE_INIT)
+		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
+	else
+		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+	if (priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+		capacity = iwl_read_targ_mem(priv, base);
+		num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
+		mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
+		next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
+	} else
+		return;
+
+	if (num_wraps == priv->event_log.num_wraps) {
+		iwl_print_cont_event_trace(priv,
+				       base, priv->event_log.next_entry,
+				       next_entry - priv->event_log.next_entry,
+				       mode);
+		priv->event_log.non_wraps_count++;
+	} else {
+		if ((num_wraps - priv->event_log.num_wraps) > 1)
+			priv->event_log.wraps_more_count++;
+		else
+			priv->event_log.wraps_once_count++;
+		trace_iwlwifi_dev_ucode_wrap_event(priv,
+				num_wraps - priv->event_log.num_wraps,
+				next_entry, priv->event_log.next_entry);
+		if (next_entry < priv->event_log.next_entry) {
+			iwl_print_cont_event_trace(priv, base,
+			       priv->event_log.next_entry,
+			       capacity - priv->event_log.next_entry,
+			       mode);
+
+			iwl_print_cont_event_trace(priv, base, 0,
+				next_entry, mode);
+		} else {
+			iwl_print_cont_event_trace(priv, base,
+			       next_entry, capacity - next_entry,
+			       mode);
+
+			iwl_print_cont_event_trace(priv, base, 0,
+				next_entry, mode);
+		}
+	}
+	priv->event_log.num_wraps = num_wraps;
+	priv->event_log.next_entry = next_entry;
+}
+
+/**
+ * iwl_bg_ucode_trace - Timer callback to log ucode event
+ *
+ * The timer is continually set to execute every
+ * UCODE_TRACE_PERIOD milliseconds after the last timer expired
+ * this function is to perform continuous uCode event logging operation
+ * if enabled
+ */
+static void iwl_bg_ucode_trace(unsigned long data)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)data;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (priv->event_log.ucode_trace) {
+		iwl_continuous_event_trace(priv);
+		/* Reschedule the timer to occur in UCODE_TRACE_PERIOD */
+		mod_timer(&priv->ucode_trace,
+			 jiffies + msecs_to_jiffies(UCODE_TRACE_PERIOD));
+	}
+}
+
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
@@ -3128,6 +3253,10 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	priv->statistics_periodic.data = (unsigned long)priv;
 	priv->statistics_periodic.function = iwl_bg_statistics_periodic;
 
+	init_timer(&priv->ucode_trace);
+	priv->ucode_trace.data = (unsigned long)priv;
+	priv->ucode_trace.function = iwl_bg_ucode_trace;
+
 	if (!priv->cfg->use_isr_legacy)
 		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 			iwl_irq_tasklet, (unsigned long)priv);
@@ -3146,6 +3275,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->beacon_update);
 	del_timer_sync(&priv->statistics_periodic);
+	del_timer_sync(&priv->ucode_trace);
 }
 
 static void iwl_init_hw_rates(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 86a6767..58e0462 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -110,6 +110,7 @@ struct iwl_debugfs {
 		struct dentry *file_clear_ucode_statistics;
 		struct dentry *file_clear_traffic_statistics;
 		struct dentry *file_csr;
+		struct dentry *file_ucode_tracing;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 2be3549..822de46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1867,6 +1867,58 @@ static ssize_t iwl_dbgfs_csr_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_ucode_tracing_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char buf[128];
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "ucode trace timer is %s\n",
+			priv->event_log.ucode_trace ? "On" : "Off");
+	pos += scnprintf(buf + pos, bufsz - pos, "non_wraps_count:\t\t %u\n",
+			priv->event_log.non_wraps_count);
+	pos += scnprintf(buf + pos, bufsz - pos, "wraps_once_count:\t\t %u\n",
+			priv->event_log.wraps_once_count);
+	pos += scnprintf(buf + pos, bufsz - pos, "wraps_more_count:\t\t %u\n",
+			priv->event_log.wraps_more_count);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_ucode_tracing_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int trace;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &trace) != 1)
+		return -EFAULT;
+
+	if (trace) {
+		priv->event_log.ucode_trace = true;
+		/* schedule the ucode timer to occur in UCODE_TRACE_PERIOD */
+		mod_timer(&priv->ucode_trace,
+			jiffies + msecs_to_jiffies(UCODE_TRACE_PERIOD));
+	} else {
+		priv->event_log.ucode_trace = false;
+		del_timer_sync(&priv->ucode_trace);
+	}
+
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1882,6 +1934,7 @@ DEBUGFS_READ_FILE_OPS(power_save_status);
 DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
 DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
 DEBUGFS_WRITE_FILE_OPS(csr);
+DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 
 /*
  * Create the debugfs files and directories
@@ -1939,6 +1992,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(ucode_general_stats, debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(sensitivity, debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(chain_noise, debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(ucode_tracing, debug, S_IWUSR | S_IRUSR);
 	}
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
@@ -2002,6 +2056,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 			file_sensitivity);
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_chain_noise);
+		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_ucode_tracing);
 	}
 	DEBUGFS_REMOVE(priv->dbgfs->dir_debug);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e1032f2..3c5b27c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -984,6 +984,32 @@ struct iwl_switch_rxon {
 	__le16 channel;
 };
 
+/*
+ * schedule the timer to wake up every UCODE_TRACE_PERIOD milliseconds
+ * to perform continuous uCode event logging operation if enabled
+ */
+#define UCODE_TRACE_PERIOD (100)
+
+/*
+ * iwl_event_log: current uCode event log position
+ *
+ * @ucode_trace: enable/disable ucode continuous trace timer
+ * @num_wraps: how many times the event buffer wraps
+ * @next_entry:  the entry just before the next one that uCode would fill
+ * @non_wraps_count: counter for no wrap detected when dump ucode events
+ * @wraps_once_count: counter for wrap once detected when dump ucode events
+ * @wraps_more_count: counter for wrap more than once detected
+ *		      when dump ucode events
+ */
+struct iwl_event_log {
+	bool ucode_trace;
+	u32 num_wraps;
+	u32 next_entry;
+	int non_wraps_count;
+	int wraps_once_count;
+	int wraps_more_count;
+};
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1261,6 +1287,7 @@ struct iwl_priv {
 	u32 disable_tx_power_cal;
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
+	struct timer_list ucode_trace;
 	bool hw_ready;
 	/*For 3945*/
 #define IWL_DEFAULT_TX_POWER 0x0F
@@ -1268,6 +1295,8 @@ struct iwl_priv {
 	struct iwl3945_notif_statistics statistics_39;
 
 	u32 sta_supp_rates;
+
+	struct iwl_event_log event_log;
 }; /*iwl_priv */
 
 static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index e7d88d1..bf46308 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -11,4 +11,6 @@ EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_rx);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_cont_event);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_wrap_event);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 2136196..0819f99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -65,6 +65,50 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 );
 
 #undef TRACE_SYSTEM
+#define TRACE_SYSTEM iwlwifi_ucode
+
+TRACE_EVENT(iwlwifi_dev_ucode_cont_event,
+	TP_PROTO(struct iwl_priv *priv, u32 time, u32 data, u32 ev),
+	TP_ARGS(priv, time, data, ev),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+
+		__field(u32, time)
+		__field(u32, data)
+		__field(u32, ev)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->time = time;
+		__entry->data = data;
+		__entry->ev = ev;
+	),
+	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
+		  __entry->priv, __entry->time, __entry->data, __entry->ev)
+);
+
+TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
+	TP_PROTO(struct iwl_priv *priv, u32 wraps, u32 n_entry, u32 p_entry),
+	TP_ARGS(priv, wraps, n_entry, p_entry),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+
+		__field(u32, wraps)
+		__field(u32, n_entry)
+		__field(u32, p_entry)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->wraps = wraps;
+		__entry->n_entry = n_entry;
+		__entry->p_entry = p_entry;
+	),
+	TP_printk("[%p] wraps=#%02d n=0x%X p=0x%X",
+		  __entry->priv, __entry->wraps, __entry->n_entry,
+		  __entry->p_entry)
+);
+
+#undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi
 
 TRACE_EVENT(iwlwifi_dev_hcmd,
-- 
1.5.6.3

