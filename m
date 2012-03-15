Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161455Ab2COU2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/26] iwlwifi: move ucode error log reporting to op_mode
Date: Thu, 15 Mar 2012 13:26:56 -0700
Message-Id: <1331843226-29860-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212851_287522_0A0D1FFA)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Error log reporting does not belong to the
transport layer, but to the op_mode loading
the ucode, as it is the entity which knows
about the ucode loaded, and what the error
information means.

Move device logging pointers from the
transport layer to op_mode.

With this change, transport layer only
reports an error to the op_mode, which will
figure out what to do with the error. This
causes the driver to now dump out error logs
when the command queue is stuck as well.

Also, move the debugfs entry for event logs
out of the transport layer and into op_mode.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  381 ++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   41 +++
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    6 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    6 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |  378 --------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   40 ---
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    4 +-
 10 files changed, 432 insertions(+), 430 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 37060aa..ce41437 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -379,7 +379,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 	u32 num_wraps;  /* # times uCode wrapped to top of log */
 	u32 next_entry; /* index of next entry to be written by uCode */
 
-	base = priv->shrd->device_pointers.log_event_table;
+	base = priv->device_pointers.log_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		iwl_read_targ_mem_words(trans(priv), base, &read, sizeof(read));
 
@@ -1556,10 +1556,389 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	ieee80211_free_hw(priv->hw);
 }
 
+static const char * const desc_lookup_text[] = {
+	"OK",
+	"FAIL",
+	"BAD_PARAM",
+	"BAD_CHECKSUM",
+	"NMI_INTERRUPT_WDG",
+	"SYSASSERT",
+	"FATAL_ERROR",
+	"BAD_COMMAND",
+	"HW_ERROR_TUNE_LOCK",
+	"HW_ERROR_TEMPERATURE",
+	"ILLEGAL_CHAN_FREQ",
+	"VCC_NOT_STABLE",
+	"FH_ERROR",
+	"NMI_INTERRUPT_HOST",
+	"NMI_INTERRUPT_ACTION_PT",
+	"NMI_INTERRUPT_UNKNOWN",
+	"UCODE_VERSION_MISMATCH",
+	"HW_ERROR_ABS_LOCK",
+	"HW_ERROR_CAL_LOCK_FAIL",
+	"NMI_INTERRUPT_INST_ACTION_PT",
+	"NMI_INTERRUPT_DATA_ACTION_PT",
+	"NMI_TRM_HW_ER",
+	"NMI_INTERRUPT_TRM",
+	"NMI_INTERRUPT_BREAK_POINT",
+	"DEBUG_0",
+	"DEBUG_1",
+	"DEBUG_2",
+	"DEBUG_3",
+};
+
+static struct { char *name; u8 num; } advanced_lookup[] = {
+	{ "NMI_INTERRUPT_WDG", 0x34 },
+	{ "SYSASSERT", 0x35 },
+	{ "UCODE_VERSION_MISMATCH", 0x37 },
+	{ "BAD_COMMAND", 0x38 },
+	{ "NMI_INTERRUPT_DATA_ACTION_PT", 0x3C },
+	{ "FATAL_ERROR", 0x3D },
+	{ "NMI_TRM_HW_ERR", 0x46 },
+	{ "NMI_INTERRUPT_TRM", 0x4C },
+	{ "NMI_INTERRUPT_BREAK_POINT", 0x54 },
+	{ "NMI_INTERRUPT_WDG_RXF_FULL", 0x5C },
+	{ "NMI_INTERRUPT_WDG_NO_RBD_RXF_FULL", 0x64 },
+	{ "NMI_INTERRUPT_HOST", 0x66 },
+	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
+	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
+	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
+	{ "ADVANCED_SYSASSERT", 0 },
+};
+
+static const char *desc_lookup(u32 num)
+{
+	int i;
+	int max = ARRAY_SIZE(desc_lookup_text);
+
+	if (num < max)
+		return desc_lookup_text[num];
+
+	max = ARRAY_SIZE(advanced_lookup) - 1;
+	for (i = 0; i < max; i++) {
+		if (advanced_lookup[i].num == num)
+			break;
+	}
+	return advanced_lookup[i].name;
+}
+
+#define ERROR_START_OFFSET  (1 * sizeof(u32))
+#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
+
+static void iwl_dump_nic_error_log(struct iwl_priv *priv)
+{
+	struct iwl_trans *trans = trans(priv);
+	u32 base;
+	struct iwl_error_event_table table;
+
+	base = priv->device_pointers.error_event_table;
+	if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
+		if (!base)
+			base = priv->shrd->fw->init_errlog_ptr;
+	} else {
+		if (!base)
+			base = priv->shrd->fw->inst_errlog_ptr;
+	}
+
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
+		IWL_ERR(priv,
+			"Not valid error log pointer 0x%08X for %s uCode\n",
+			base,
+			(priv->shrd->ucode_type == IWL_UCODE_INIT)
+					? "Init" : "RT");
+		return;
+	}
+
+	/*TODO: Update dbgfs with ISR error stats obtained below */
+	iwl_read_targ_mem_words(trans, base, &table, sizeof(table));
+
+	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
+		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
+		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
+			priv->shrd->status, table.valid);
+	}
+
+	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
+				      table.data1, table.data2, table.line,
+				      table.blink1, table.blink2, table.ilink1,
+				      table.ilink2, table.bcon_time, table.gp1,
+				      table.gp2, table.gp3, table.ucode_ver,
+				      table.hw_ver, table.brd_ver);
+	IWL_ERR(priv, "0x%08X | %-28s\n", table.error_id,
+		desc_lookup(table.error_id));
+	IWL_ERR(priv, "0x%08X | uPc\n", table.pc);
+	IWL_ERR(priv, "0x%08X | branchlink1\n", table.blink1);
+	IWL_ERR(priv, "0x%08X | branchlink2\n", table.blink2);
+	IWL_ERR(priv, "0x%08X | interruptlink1\n", table.ilink1);
+	IWL_ERR(priv, "0x%08X | interruptlink2\n", table.ilink2);
+	IWL_ERR(priv, "0x%08X | data1\n", table.data1);
+	IWL_ERR(priv, "0x%08X | data2\n", table.data2);
+	IWL_ERR(priv, "0x%08X | line\n", table.line);
+	IWL_ERR(priv, "0x%08X | beacon time\n", table.bcon_time);
+	IWL_ERR(priv, "0x%08X | tsf low\n", table.tsf_low);
+	IWL_ERR(priv, "0x%08X | tsf hi\n", table.tsf_hi);
+	IWL_ERR(priv, "0x%08X | time gp1\n", table.gp1);
+	IWL_ERR(priv, "0x%08X | time gp2\n", table.gp2);
+	IWL_ERR(priv, "0x%08X | time gp3\n", table.gp3);
+	IWL_ERR(priv, "0x%08X | uCode version\n", table.ucode_ver);
+	IWL_ERR(priv, "0x%08X | hw version\n", table.hw_ver);
+	IWL_ERR(priv, "0x%08X | board version\n", table.brd_ver);
+	IWL_ERR(priv, "0x%08X | hcmd\n", table.hcmd);
+	IWL_ERR(priv, "0x%08X | isr0\n", table.isr0);
+	IWL_ERR(priv, "0x%08X | isr1\n", table.isr1);
+	IWL_ERR(priv, "0x%08X | isr2\n", table.isr2);
+	IWL_ERR(priv, "0x%08X | isr3\n", table.isr3);
+	IWL_ERR(priv, "0x%08X | isr4\n", table.isr4);
+	IWL_ERR(priv, "0x%08X | isr_pref\n", table.isr_pref);
+	IWL_ERR(priv, "0x%08X | wait_event\n", table.wait_event);
+	IWL_ERR(priv, "0x%08X | l2p_control\n", table.l2p_control);
+	IWL_ERR(priv, "0x%08X | l2p_duration\n", table.l2p_duration);
+	IWL_ERR(priv, "0x%08X | l2p_mhvalid\n", table.l2p_mhvalid);
+	IWL_ERR(priv, "0x%08X | l2p_addr_match\n", table.l2p_addr_match);
+	IWL_ERR(priv, "0x%08X | lmpm_pmg_sel\n", table.lmpm_pmg_sel);
+	IWL_ERR(priv, "0x%08X | timestamp\n", table.u_timestamp);
+	IWL_ERR(priv, "0x%08X | flow_handler\n", table.flow_handler);
+}
+
+#define EVENT_START_OFFSET  (4 * sizeof(u32))
+
+/**
+ * iwl_print_event_log - Dump error event log to syslog
+ *
+ */
+static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
+			       u32 num_events, u32 mode,
+			       int pos, char **buf, size_t bufsz)
+{
+	u32 i;
+	u32 base;       /* SRAM byte address of event log header */
+	u32 event_size; /* 2 u32s, or 3 u32s if timestamp recorded */
+	u32 ptr;        /* SRAM byte address of log data */
+	u32 ev, time, data; /* event log data */
+	unsigned long reg_flags;
+
+	struct iwl_trans *trans = trans(priv);
+
+	if (num_events == 0)
+		return pos;
+
+	base = priv->device_pointers.log_event_table;
+	if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
+		if (!base)
+			base = priv->shrd->fw->init_evtlog_ptr;
+	} else {
+		if (!base)
+			base = priv->shrd->fw->inst_evtlog_ptr;
+	}
+
+	if (mode == 0)
+		event_size = 2 * sizeof(u32);
+	else
+		event_size = 3 * sizeof(u32);
+
+	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
+
+	/* Make sure device is powered up for SRAM reads */
+	spin_lock_irqsave(&trans->reg_lock, reg_flags);
+	if (unlikely(!iwl_grab_nic_access(trans)))
+		goto out_unlock;
+
+	/* Set starting address; reads will auto-increment */
+	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
+
+	/* "time" is actually "data" for mode 0 (no timestamp).
+	* place event id # at far right for easier visual parsing. */
+	for (i = 0; i < num_events; i++) {
+		ev = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		if (mode == 0) {
+			/* data, ev */
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"EVT_LOG:0x%08x:%04u\n",
+						time, ev);
+			} else {
+				trace_iwlwifi_dev_ucode_event(trans->dev, 0,
+					time, ev);
+				IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n",
+					time, ev);
+			}
+		} else {
+			data = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"EVT_LOGT:%010u:0x%08x:%04u\n",
+						 time, data, ev);
+			} else {
+				IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
+					time, data, ev);
+				trace_iwlwifi_dev_ucode_event(trans->dev, time,
+					data, ev);
+			}
+		}
+	}
+
+	/* Allow device to power down */
+	iwl_release_nic_access(trans);
+out_unlock:
+	spin_unlock_irqrestore(&trans->reg_lock, reg_flags);
+	return pos;
+}
+
+/**
+ * iwl_print_last_event_logs - Dump the newest # of event log to syslog
+ */
+static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
+				    u32 num_wraps, u32 next_entry,
+				    u32 size, u32 mode,
+				    int pos, char **buf, size_t bufsz)
+{
+	/*
+	 * display the newest DEFAULT_LOG_ENTRIES entries
+	 * i.e the entries just before the next ont that uCode would fill.
+	 */
+	if (num_wraps) {
+		if (next_entry < size) {
+			pos = iwl_print_event_log(priv,
+						capacity - (size - next_entry),
+						size - next_entry, mode,
+						pos, buf, bufsz);
+			pos = iwl_print_event_log(priv, 0,
+						  next_entry, mode,
+						  pos, buf, bufsz);
+		} else
+			pos = iwl_print_event_log(priv, next_entry - size,
+						  size, mode, pos, buf, bufsz);
+	} else {
+		if (next_entry < size) {
+			pos = iwl_print_event_log(priv, 0, next_entry,
+						  mode, pos, buf, bufsz);
+		} else {
+			pos = iwl_print_event_log(priv, next_entry - size,
+						  size, mode, pos, buf, bufsz);
+		}
+	}
+	return pos;
+}
+
+#define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
+
+int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
+			    char **buf, bool display)
+{
+	u32 base;       /* SRAM byte address of event log header */
+	u32 capacity;   /* event log capacity in # entries */
+	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
+	u32 num_wraps;  /* # times uCode wrapped to top of log */
+	u32 next_entry; /* index of next entry to be written by uCode */
+	u32 size;       /* # entries that we'll print */
+	u32 logsize;
+	int pos = 0;
+	size_t bufsz = 0;
+	struct iwl_trans *trans = trans(priv);
+
+	base = priv->device_pointers.log_event_table;
+	if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
+		logsize = priv->shrd->fw->init_evtlog_size;
+		if (!base)
+			base = priv->shrd->fw->init_evtlog_ptr;
+	} else {
+		logsize = priv->shrd->fw->inst_evtlog_size;
+		if (!base)
+			base = priv->shrd->fw->inst_evtlog_ptr;
+	}
+
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
+		IWL_ERR(priv,
+			"Invalid event log pointer 0x%08X for %s uCode\n",
+			base,
+			(priv->shrd->ucode_type == IWL_UCODE_INIT)
+					? "Init" : "RT");
+		return -EINVAL;
+	}
+
+	/* event log header */
+	capacity = iwl_read_targ_mem(trans, base);
+	mode = iwl_read_targ_mem(trans, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(trans, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(trans, base + (3 * sizeof(u32)));
+
+	if (capacity > logsize) {
+		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d "
+			"entries\n", capacity, logsize);
+		capacity = logsize;
+	}
+
+	if (next_entry > logsize) {
+		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
+			next_entry, logsize);
+		next_entry = logsize;
+	}
+
+	size = num_wraps ? capacity : next_entry;
+
+	/* bail out if nothing in log */
+	if (size == 0) {
+		IWL_ERR(trans, "Start IWL Event Log Dump: nothing in log\n");
+		return pos;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (!(iwl_have_debug_level(IWL_DL_FW_ERRORS)) && !full_log)
+		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
+			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
+#else
+	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
+		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
+#endif
+	IWL_ERR(priv, "Start IWL Event Log Dump: display last %u entries\n",
+		size);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (display) {
+		if (full_log)
+			bufsz = capacity * 48;
+		else
+			bufsz = size * 48;
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+	}
+	if (iwl_have_debug_level(IWL_DL_FW_ERRORS) || full_log) {
+		/*
+		 * if uCode has wrapped back to top of log,
+		 * start at the oldest entry,
+		 * i.e the next one that uCode would fill.
+		 */
+		if (num_wraps)
+			pos = iwl_print_event_log(priv, next_entry,
+						capacity - next_entry, mode,
+						pos, buf, bufsz);
+		/* (then/else) start at top of log */
+		pos = iwl_print_event_log(priv, 0,
+					  next_entry, mode, pos, buf, bufsz);
+	} else
+		pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
+						next_entry, size, mode,
+						pos, buf, bufsz);
+#else
+	pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
+					next_entry, size, mode,
+					pos, buf, bufsz);
+#endif
+	return pos;
+}
+
 static void iwl_nic_error(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
+	IWL_ERR(priv, "Loaded firmware version: %s\n",
+		priv->shrd->fw->fw_version);
+
+	iwl_dump_nic_error_log(priv);
+	iwl_dump_nic_event_log(priv, false, NULL, false);
+
 	iwlagn_fw_error(priv, false);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 882261b..cddd9ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -132,6 +132,8 @@ int iwl_calib_set(struct iwl_priv *priv,
 		  const struct iwl_calib_hdr *cmd, int len);
 void iwl_calib_free_results(struct iwl_priv *priv);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
+int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
+			    char **buf, bool display);
 
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index bc0bed8..d4b51a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2484,6 +2484,44 @@ static ssize_t iwl_dbgfs_echo_test_write(struct file *file,
 	return count;
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
+	ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
+	if (buf) {
+		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+		kfree(buf);
+	}
+	return ret;
+}
+
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
+		iwl_dump_nic_event_log(priv, true, NULL, false);
+
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2508,6 +2546,7 @@ DEBUGFS_READ_FILE_OPS(bt_traffic);
 DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
 DEBUGFS_WRITE_FILE_OPS(echo_test);
+DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 
 /*
  * Create the debugfs files and directories
@@ -2571,6 +2610,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(echo_test, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(log_event, dir_debug, S_IWUSR | S_IRUSR);
+
 	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6178b99..2f54c9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -991,6 +991,12 @@ struct iwl_priv {
 	__le64 replay_ctr;
 	__le16 last_seq_ctl;
 	bool have_rekey_data;
+
+	/* device_pointers: pointers to ucode event tables */
+	struct {
+		u32 error_event_table;
+		u32 log_event_table;
+	} device_pointers;
 }; /*iwl_priv */
 
 extern struct kmem_cache *iwl_tx_cmd_pool;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b0c40c8..551db9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -446,7 +446,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
-	base = priv->shrd->device_pointers.error_event_table;
+	base = priv->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		spin_lock_irqsave(&trans(priv)->reg_lock, flags);
 		ret = iwl_grab_nic_access_silent(trans(priv));
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index c19c096..ef3f0b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -347,7 +347,6 @@ struct iwl_cfg {
  * @lock: protect general shared data
  * @eeprom: pointer to the eeprom/OTP image
  * @ucode_type: indicator of loaded ucode image
- * @device_pointers: pointers to ucode event tables
  */
 struct iwl_shared {
 	unsigned long status;
@@ -364,11 +363,6 @@ struct iwl_shared {
 	/* ucode related variables */
 	enum iwl_ucode_type ucode_type;
 
-	struct {
-		u32 error_event_table;
-		u32 log_event_table;
-	} device_pointers;
-
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 5325ff7..32adee3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -320,8 +320,6 @@ int iwl_queue_space(const struct iwl_queue *q);
 /*****************************************************
 * Error handling
 ******************************************************/
-int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
-			    char **buf, bool display);
 int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
 void iwl_dump_csr(struct iwl_trans *trans);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index bab5114..a070f51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -533,153 +533,6 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		iwlagn_rx_queue_restock(trans);
 }
 
-static const char * const desc_lookup_text[] = {
-	"OK",
-	"FAIL",
-	"BAD_PARAM",
-	"BAD_CHECKSUM",
-	"NMI_INTERRUPT_WDG",
-	"SYSASSERT",
-	"FATAL_ERROR",
-	"BAD_COMMAND",
-	"HW_ERROR_TUNE_LOCK",
-	"HW_ERROR_TEMPERATURE",
-	"ILLEGAL_CHAN_FREQ",
-	"VCC_NOT_STABLE",
-	"FH_ERROR",
-	"NMI_INTERRUPT_HOST",
-	"NMI_INTERRUPT_ACTION_PT",
-	"NMI_INTERRUPT_UNKNOWN",
-	"UCODE_VERSION_MISMATCH",
-	"HW_ERROR_ABS_LOCK",
-	"HW_ERROR_CAL_LOCK_FAIL",
-	"NMI_INTERRUPT_INST_ACTION_PT",
-	"NMI_INTERRUPT_DATA_ACTION_PT",
-	"NMI_TRM_HW_ER",
-	"NMI_INTERRUPT_TRM",
-	"NMI_INTERRUPT_BREAK_POINT",
-	"DEBUG_0",
-	"DEBUG_1",
-	"DEBUG_2",
-	"DEBUG_3",
-};
-
-static struct { char *name; u8 num; } advanced_lookup[] = {
-	{ "NMI_INTERRUPT_WDG", 0x34 },
-	{ "SYSASSERT", 0x35 },
-	{ "UCODE_VERSION_MISMATCH", 0x37 },
-	{ "BAD_COMMAND", 0x38 },
-	{ "NMI_INTERRUPT_DATA_ACTION_PT", 0x3C },
-	{ "FATAL_ERROR", 0x3D },
-	{ "NMI_TRM_HW_ERR", 0x46 },
-	{ "NMI_INTERRUPT_TRM", 0x4C },
-	{ "NMI_INTERRUPT_BREAK_POINT", 0x54 },
-	{ "NMI_INTERRUPT_WDG_RXF_FULL", 0x5C },
-	{ "NMI_INTERRUPT_WDG_NO_RBD_RXF_FULL", 0x64 },
-	{ "NMI_INTERRUPT_HOST", 0x66 },
-	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
-	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
-	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
-	{ "ADVANCED_SYSASSERT", 0 },
-};
-
-static const char *desc_lookup(u32 num)
-{
-	int i;
-	int max = ARRAY_SIZE(desc_lookup_text);
-
-	if (num < max)
-		return desc_lookup_text[num];
-
-	max = ARRAY_SIZE(advanced_lookup) - 1;
-	for (i = 0; i < max; i++) {
-		if (advanced_lookup[i].num == num)
-			break;
-	}
-	return advanced_lookup[i].name;
-}
-
-#define ERROR_START_OFFSET  (1 * sizeof(u32))
-#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
-
-static void iwl_dump_nic_error_log(struct iwl_trans *trans)
-{
-	u32 base;
-	struct iwl_error_event_table table;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	base = trans->shrd->device_pointers.error_event_table;
-	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
-		if (!base)
-			base = trans->shrd->fw->init_errlog_ptr;
-	} else {
-		if (!base)
-			base = trans->shrd->fw->inst_errlog_ptr;
-	}
-
-	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(trans,
-			"Not valid error log pointer 0x%08X for %s uCode\n",
-			base,
-			(trans->shrd->ucode_type == IWL_UCODE_INIT)
-					? "Init" : "RT");
-		return;
-	}
-
-	iwl_read_targ_mem_words(trans, base, &table, sizeof(table));
-
-	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
-		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
-		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
-			trans->shrd->status, table.valid);
-	}
-
-	trans_pcie->isr_stats.err_code = table.error_id;
-
-	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
-				      table.data1, table.data2, table.line,
-				      table.blink1, table.blink2, table.ilink1,
-				      table.ilink2, table.bcon_time, table.gp1,
-				      table.gp2, table.gp3, table.ucode_ver,
-				      table.hw_ver, table.brd_ver);
-	IWL_ERR(trans, "0x%08X | %-28s\n", table.error_id,
-		desc_lookup(table.error_id));
-	IWL_ERR(trans, "0x%08X | uPc\n", table.pc);
-	IWL_ERR(trans, "0x%08X | branchlink1\n", table.blink1);
-	IWL_ERR(trans, "0x%08X | branchlink2\n", table.blink2);
-	IWL_ERR(trans, "0x%08X | interruptlink1\n", table.ilink1);
-	IWL_ERR(trans, "0x%08X | interruptlink2\n", table.ilink2);
-	IWL_ERR(trans, "0x%08X | data1\n", table.data1);
-	IWL_ERR(trans, "0x%08X | data2\n", table.data2);
-	IWL_ERR(trans, "0x%08X | line\n", table.line);
-	IWL_ERR(trans, "0x%08X | beacon time\n", table.bcon_time);
-	IWL_ERR(trans, "0x%08X | tsf low\n", table.tsf_low);
-	IWL_ERR(trans, "0x%08X | tsf hi\n", table.tsf_hi);
-	IWL_ERR(trans, "0x%08X | time gp1\n", table.gp1);
-	IWL_ERR(trans, "0x%08X | time gp2\n", table.gp2);
-	IWL_ERR(trans, "0x%08X | time gp3\n", table.gp3);
-	IWL_ERR(trans, "0x%08X | uCode version\n", table.ucode_ver);
-	IWL_ERR(trans, "0x%08X | hw version\n", table.hw_ver);
-	IWL_ERR(trans, "0x%08X | board version\n", table.brd_ver);
-	IWL_ERR(trans, "0x%08X | hcmd\n", table.hcmd);
-
-	IWL_ERR(trans, "0x%08X | isr0\n", table.isr0);
-	IWL_ERR(trans, "0x%08X | isr1\n", table.isr1);
-	IWL_ERR(trans, "0x%08X | isr2\n", table.isr2);
-	IWL_ERR(trans, "0x%08X | isr3\n", table.isr3);
-	IWL_ERR(trans, "0x%08X | isr4\n", table.isr4);
-	IWL_ERR(trans, "0x%08X | isr_pref\n", table.isr_pref);
-	IWL_ERR(trans, "0x%08X | wait_event\n", table.wait_event);
-	IWL_ERR(trans, "0x%08X | l2p_control\n", table.l2p_control);
-	IWL_ERR(trans, "0x%08X | l2p_duration\n", table.l2p_duration);
-	IWL_ERR(trans, "0x%08X | l2p_mhvalid\n", table.l2p_mhvalid);
-	IWL_ERR(trans, "0x%08X | l2p_addr_match\n", table.l2p_addr_match);
-	IWL_ERR(trans, "0x%08X | lmpm_pmg_sel\n", table.lmpm_pmg_sel);
-	IWL_ERR(trans, "0x%08X | timestamp\n", table.u_timestamp);
-	IWL_ERR(trans, "0x%08X | flow_handler\n", table.flow_handler);
-}
-
 /**
  * iwl_irq_handle_error - called for HW or SW error interrupt from card
  */
@@ -702,243 +555,12 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 		return;
 	}
 
-	IWL_ERR(trans, "Loaded firmware version: %s\n",
-		trans->shrd->fw->fw_version);
-
-	iwl_dump_nic_error_log(trans);
 	iwl_dump_csr(trans);
 	iwl_dump_fh(trans, NULL, false);
-	iwl_dump_nic_event_log(trans, false, NULL, false);
 
 	iwl_op_mode_nic_error(trans->op_mode);
 }
 
-#define EVENT_START_OFFSET  (4 * sizeof(u32))
-
-/**
- * iwl_print_event_log - Dump error event log to syslog
- *
- */
-static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
-			       u32 num_events, u32 mode,
-			       int pos, char **buf, size_t bufsz)
-{
-	u32 i;
-	u32 base;       /* SRAM byte address of event log header */
-	u32 event_size; /* 2 u32s, or 3 u32s if timestamp recorded */
-	u32 ptr;        /* SRAM byte address of log data */
-	u32 ev, time, data; /* event log data */
-	unsigned long reg_flags;
-
-	if (num_events == 0)
-		return pos;
-
-	base = trans->shrd->device_pointers.log_event_table;
-	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
-		if (!base)
-			base = trans->shrd->fw->init_evtlog_ptr;
-	} else {
-		if (!base)
-			base = trans->shrd->fw->inst_evtlog_ptr;
-	}
-
-	if (mode == 0)
-		event_size = 2 * sizeof(u32);
-	else
-		event_size = 3 * sizeof(u32);
-
-	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
-
-	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&trans->reg_lock, reg_flags);
-	if (unlikely(!iwl_grab_nic_access(trans)))
-		goto out_unlock;
-
-	/* Set starting address; reads will auto-increment */
-	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
-
-	/* "time" is actually "data" for mode 0 (no timestamp).
-	* place event id # at far right for easier visual parsing. */
-	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-		if (mode == 0) {
-			/* data, ev */
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOG:0x%08x:%04u\n",
-						time, ev);
-			} else {
-				trace_iwlwifi_dev_ucode_event(trans->dev, 0,
-					time, ev);
-				IWL_ERR(trans, "EVT_LOG:0x%08x:%04u\n",
-					time, ev);
-			}
-		} else {
-			data = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOGT:%010u:0x%08x:%04u\n",
-						 time, data, ev);
-			} else {
-				IWL_ERR(trans, "EVT_LOGT:%010u:0x%08x:%04u\n",
-					time, data, ev);
-				trace_iwlwifi_dev_ucode_event(trans->dev, time,
-					data, ev);
-			}
-		}
-	}
-
-	/* Allow device to power down */
-	iwl_release_nic_access(trans);
-out_unlock:
-	spin_unlock_irqrestore(&trans->reg_lock, reg_flags);
-	return pos;
-}
-
-/**
- * iwl_print_last_event_logs - Dump the newest # of event log to syslog
- */
-static int iwl_print_last_event_logs(struct iwl_trans *trans, u32 capacity,
-				    u32 num_wraps, u32 next_entry,
-				    u32 size, u32 mode,
-				    int pos, char **buf, size_t bufsz)
-{
-	/*
-	 * display the newest DEFAULT_LOG_ENTRIES entries
-	 * i.e the entries just before the next ont that uCode would fill.
-	 */
-	if (num_wraps) {
-		if (next_entry < size) {
-			pos = iwl_print_event_log(trans,
-						capacity - (size - next_entry),
-						size - next_entry, mode,
-						pos, buf, bufsz);
-			pos = iwl_print_event_log(trans, 0,
-						  next_entry, mode,
-						  pos, buf, bufsz);
-		} else
-			pos = iwl_print_event_log(trans, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-	} else {
-		if (next_entry < size) {
-			pos = iwl_print_event_log(trans, 0, next_entry,
-						  mode, pos, buf, bufsz);
-		} else {
-			pos = iwl_print_event_log(trans, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-		}
-	}
-	return pos;
-}
-
-#define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
-
-int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
-			    char **buf, bool display)
-{
-	u32 base;       /* SRAM byte address of event log header */
-	u32 capacity;   /* event log capacity in # entries */
-	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
-	u32 num_wraps;  /* # times uCode wrapped to top of log */
-	u32 next_entry; /* index of next entry to be written by uCode */
-	u32 size;       /* # entries that we'll print */
-	u32 logsize;
-	int pos = 0;
-	size_t bufsz = 0;
-
-	base = trans->shrd->device_pointers.log_event_table;
-	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
-		logsize = trans->shrd->fw->init_evtlog_size;
-		if (!base)
-			base = trans->shrd->fw->init_evtlog_ptr;
-	} else {
-		logsize = trans->shrd->fw->inst_evtlog_size;
-		if (!base)
-			base = trans->shrd->fw->inst_evtlog_ptr;
-	}
-
-	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(trans,
-			"Invalid event log pointer 0x%08X for %s uCode\n",
-			base,
-			(trans->shrd->ucode_type == IWL_UCODE_INIT)
-					? "Init" : "RT");
-		return -EINVAL;
-	}
-
-	/* event log header */
-	capacity = iwl_read_targ_mem(trans, base);
-	mode = iwl_read_targ_mem(trans, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(trans, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(trans, base + (3 * sizeof(u32)));
-
-	if (capacity > logsize) {
-		IWL_ERR(trans, "Log capacity %d is bogus, limit to %d "
-			"entries\n", capacity, logsize);
-		capacity = logsize;
-	}
-
-	if (next_entry > logsize) {
-		IWL_ERR(trans, "Log write index %d is bogus, limit to %d\n",
-			next_entry, logsize);
-		next_entry = logsize;
-	}
-
-	size = num_wraps ? capacity : next_entry;
-
-	/* bail out if nothing in log */
-	if (size == 0) {
-		IWL_ERR(trans, "Start IWL Event Log Dump: nothing in log\n");
-		return pos;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_have_debug_level(IWL_DL_FW_ERRORS)) && !full_log)
-		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#else
-	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#endif
-	IWL_ERR(trans, "Start IWL Event Log Dump: display last %u entries\n",
-		size);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
-		if (full_log)
-			bufsz = capacity * 48;
-		else
-			bufsz = size * 48;
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-	}
-	if (iwl_have_debug_level(IWL_DL_FW_ERRORS) || full_log) {
-		/*
-		 * if uCode has wrapped back to top of log,
-		 * start at the oldest entry,
-		 * i.e the next one that uCode would fill.
-		 */
-		if (num_wraps)
-			pos = iwl_print_event_log(trans, next_entry,
-						capacity - next_entry, mode,
-						pos, buf, bufsz);
-		/* (then/else) start at top of log */
-		pos = iwl_print_event_log(trans, 0,
-					  next_entry, mode, pos, buf, bufsz);
-	} else
-		pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
-						next_entry, size, mode,
-						pos, buf, bufsz);
-#else
-	pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
-					next_entry, size, mode,
-					pos, buf, bufsz);
-#endif
-	return pos;
-}
-
 /* tasklet for iwlagn interrupt */
 void iwl_irq_tasklet(struct iwl_trans *trans)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 0a23372..b0b7107 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1853,44 +1853,6 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_log_event_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
-
-	ret = pos = iwl_dump_nic_event_log(trans, true, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		kfree(buf);
-	}
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_log_event_write(struct file *file,
-					const char __user *user_buf,
-					size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	u32 event_log_flag;
-	char buf[8];
-	int buf_size;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &event_log_flag) != 1)
-		return -EFAULT;
-	if (event_log_flag == 1)
-		iwl_dump_nic_event_log(trans, true, NULL, false);
-
-	return count;
-}
-
 static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos) {
@@ -2017,7 +1979,6 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 	return ret;
 }
 
-DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
@@ -2033,7 +1994,6 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 {
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
-	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index f23b283..993f1a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -367,9 +367,9 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
-	priv->shrd->device_pointers.error_event_table =
+	priv->device_pointers.error_event_table =
 		le32_to_cpu(palive->error_event_table_ptr);
-	priv->shrd->device_pointers.log_event_table =
+	priv->device_pointers.log_event_table =
 		le32_to_cpu(palive->log_event_table_ptr);
 
 	alive_data->subtype = palive->ver_subtype;
-- 
1.7.0.4

