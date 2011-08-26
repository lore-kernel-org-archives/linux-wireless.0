Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab1HZGxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/60] iwlagn: move the NIC error flow to the transport layer
Date: Thu, 25 Aug 2011 23:10:54 -0700
Message-Id: <1314339092-20797-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085456_696328_DAB9D2A2)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is transport dependent, move to the PCIe transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  358 -------------------
 drivers/net/wireless/iwlwifi/iwl-core.c           |   38 --
 drivers/net/wireless/iwlwifi/iwl-core.h           |    4 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   42 ---
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    6 +
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  396 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   40 ++
 7 files changed, 442 insertions(+), 442 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ca6bb7b..f6884a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1308,364 +1308,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
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
-void iwl_dump_nic_error_log(struct iwl_priv *priv)
-{
-	u32 base;
-	struct iwl_error_event_table table;
-
-	base = priv->device_pointers.error_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
-		if (!base)
-			base = priv->init_errlog_ptr;
-	} else {
-		if (!base)
-			base = priv->inst_errlog_ptr;
-	}
-
-	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv,
-			"Not valid error log pointer 0x%08X for %s uCode\n",
-			base,
-			(priv->ucode_type == IWL_UCODE_INIT)
-					? "Init" : "RT");
-		return;
-	}
-
-	iwl_read_targ_mem_words(priv, base, &table, sizeof(table));
-
-	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
-		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
-		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
-			priv->shrd->status, table.valid);
-	}
-
-	priv->isr_stats.err_code = table.error_id;
-
-	trace_iwlwifi_dev_ucode_error(priv, table.error_id, table.tsf_low,
-				      table.data1, table.data2, table.line,
-				      table.blink1, table.blink2, table.ilink1,
-				      table.ilink2, table.bcon_time, table.gp1,
-				      table.gp2, table.gp3, table.ucode_ver,
-				      table.hw_ver, table.brd_ver);
-	IWL_ERR(priv, "0x%08X | %-28s\n", table.error_id,
-		desc_lookup(table.error_id));
-	IWL_ERR(priv, "0x%08X | uPc\n", table.pc);
-	IWL_ERR(priv, "0x%08X | branchlink1\n", table.blink1);
-	IWL_ERR(priv, "0x%08X | branchlink2\n", table.blink2);
-	IWL_ERR(priv, "0x%08X | interruptlink1\n", table.ilink1);
-	IWL_ERR(priv, "0x%08X | interruptlink2\n", table.ilink2);
-	IWL_ERR(priv, "0x%08X | data1\n", table.data1);
-	IWL_ERR(priv, "0x%08X | data2\n", table.data2);
-	IWL_ERR(priv, "0x%08X | line\n", table.line);
-	IWL_ERR(priv, "0x%08X | beacon time\n", table.bcon_time);
-	IWL_ERR(priv, "0x%08X | tsf low\n", table.tsf_low);
-	IWL_ERR(priv, "0x%08X | tsf hi\n", table.tsf_hi);
-	IWL_ERR(priv, "0x%08X | time gp1\n", table.gp1);
-	IWL_ERR(priv, "0x%08X | time gp2\n", table.gp2);
-	IWL_ERR(priv, "0x%08X | time gp3\n", table.gp3);
-	IWL_ERR(priv, "0x%08X | uCode version\n", table.ucode_ver);
-	IWL_ERR(priv, "0x%08X | hw version\n", table.hw_ver);
-	IWL_ERR(priv, "0x%08X | board version\n", table.brd_ver);
-	IWL_ERR(priv, "0x%08X | hcmd\n", table.hcmd);
-}
-
-#define EVENT_START_OFFSET  (4 * sizeof(u32))
-
-/**
- * iwl_print_event_log - Dump error event log to syslog
- *
- */
-static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
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
-	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
-		if (!base)
-			base = priv->init_evtlog_ptr;
-	} else {
-		if (!base)
-			base = priv->inst_evtlog_ptr;
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
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-
-	/* Set starting address; reads will auto-increment */
-	iwl_write32(priv, HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
-
-	/* "time" is actually "data" for mode 0 (no timestamp).
-	* place event id # at far right for easier visual parsing. */
-	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
-		if (mode == 0) {
-			/* data, ev */
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOG:0x%08x:%04u\n",
-						time, ev);
-			} else {
-				trace_iwlwifi_dev_ucode_event(priv, 0,
-					time, ev);
-				IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n",
-					time, ev);
-			}
-		} else {
-			data = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOGT:%010u:0x%08x:%04u\n",
-						 time, data, ev);
-			} else {
-				IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
-					time, data, ev);
-				trace_iwlwifi_dev_ucode_event(priv, time,
-					data, ev);
-			}
-		}
-	}
-
-	/* Allow device to power down */
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-	return pos;
-}
-
-/**
- * iwl_print_last_event_logs - Dump the newest # of event log to syslog
- */
-static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
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
-			pos = iwl_print_event_log(priv,
-						capacity - (size - next_entry),
-						size - next_entry, mode,
-						pos, buf, bufsz);
-			pos = iwl_print_event_log(priv, 0,
-						  next_entry, mode,
-						  pos, buf, bufsz);
-		} else
-			pos = iwl_print_event_log(priv, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-	} else {
-		if (next_entry < size) {
-			pos = iwl_print_event_log(priv, 0, next_entry,
-						  mode, pos, buf, bufsz);
-		} else {
-			pos = iwl_print_event_log(priv, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-		}
-	}
-	return pos;
-}
-
-#define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
-
-int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
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
-	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
-		logsize = priv->init_evtlog_size;
-		if (!base)
-			base = priv->init_evtlog_ptr;
-	} else {
-		logsize = priv->inst_evtlog_size;
-		if (!base)
-			base = priv->inst_evtlog_ptr;
-	}
-
-	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv,
-			"Invalid event log pointer 0x%08X for %s uCode\n",
-			base,
-			(priv->ucode_type == IWL_UCODE_INIT)
-					? "Init" : "RT");
-		return -EINVAL;
-	}
-
-	/* event log header */
-	capacity = iwl_read_targ_mem(priv, base);
-	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
-
-	if (capacity > logsize) {
-		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
-			capacity, logsize);
-		capacity = logsize;
-	}
-
-	if (next_entry > logsize) {
-		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
-			next_entry, logsize);
-		next_entry = logsize;
-	}
-
-	size = num_wraps ? capacity : next_entry;
-
-	/* bail out if nothing in log */
-	if (size == 0) {
-		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
-		return pos;
-	}
-
-	/* enable/disable bt channel inhibition */
-	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) && !full_log)
-		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#else
-	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#endif
-	IWL_ERR(priv, "Start IWL Event Log Dump: display last %u entries\n",
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
-	if ((iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) || full_log) {
-		/*
-		 * if uCode has wrapped back to top of log,
-		 * start at the oldest entry,
-		 * i.e the next one that uCode would fill.
-		 */
-		if (num_wraps)
-			pos = iwl_print_event_log(priv, next_entry,
-						capacity - next_entry, mode,
-						pos, buf, bufsz);
-		/* (then/else) start at top of log */
-		pos = iwl_print_event_log(priv, 0,
-					  next_entry, mode, pos, buf, bufsz);
-	} else
-		pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
-						next_entry, size, mode,
-						pos, buf, bufsz);
-#else
-	pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
-					next_entry, size, mode,
-					pos, buf, bufsz);
-#endif
-	return pos;
-}
-
 static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d77af69..88fc396 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -902,44 +902,6 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	}
 }
 
-/**
- * iwl_irq_handle_error - called for HW or SW error interrupt from card
- */
-void iwl_irq_handle_error(struct iwl_priv *priv)
-{
-	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
-	if (priv->cfg->internal_wimax_coex &&
-	    (!(iwl_read_prph(priv, APMG_CLK_CTRL_REG) &
-			APMS_CLK_VAL_MRB_FUNC_MODE) ||
-	     (iwl_read_prph(priv, APMG_PS_CTRL_REG) &
-			APMG_PS_CTRL_VAL_RESET_REQ))) {
-		/*
-		 * Keep the restart process from trying to send host
-		 * commands by clearing the ready bit.
-		 */
-		clear_bit(STATUS_READY, &priv->shrd->status);
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
-		wake_up_interruptible(&priv->wait_command_queue);
-		IWL_ERR(priv, "RF is used by WiMAX\n");
-		return;
-	}
-
-	IWL_ERR(priv, "Loaded firmware version: %s\n",
-		priv->hw->wiphy->fw_version);
-
-	iwl_dump_nic_error_log(priv);
-	iwl_dump_csr(priv);
-	iwl_dump_fh(priv, NULL, false);
-	iwl_dump_nic_event_log(priv, false, NULL, false);
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS)
-		iwl_print_rx_config_cmd(priv,
-					&priv->contexts[IWL_RXON_CTX_BSS]);
-#endif
-
-	iwlagn_fw_error(priv, false);
-}
-
 static int iwl_apm_stop_master(struct iwl_priv *priv)
 {
 	int ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 797fefa..aa62118 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -266,7 +266,6 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
-void iwl_irq_handle_error(struct iwl_priv *priv);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
@@ -376,9 +375,6 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 /*****************************************************
 *  Error Handling Debugging
 ******************************************************/
-void iwl_dump_nic_error_log(struct iwl_priv *priv);
-int iwl_dump_nic_event_log(struct iwl_priv *priv,
-			   bool full_log, char **buf, bool display);
 void iwl_dump_csr(struct iwl_priv *priv);
 int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d322321..fa070de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -442,46 +442,6 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_log_event_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
-
-	ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
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
-	struct iwl_priv *priv = file->private_data;
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
-		iwl_dump_nic_event_log(priv, true, NULL, false);
-
-	return count;
-}
-
-
-
 static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
@@ -870,7 +830,6 @@ static ssize_t iwl_dbgfs_current_sleep_command_read(struct file *file,
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_READ_FILE_OPS(wowlan_sram);
-DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(channels);
@@ -2509,7 +2468,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(nvm, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(sram, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(wowlan_sram, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(log_event, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(stations, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(channels, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 7e2f954..4694c46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -141,6 +141,12 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 						int frame_limit);
 
+/*****************************************************
+* Error handling
+******************************************************/
+int iwl_dump_nic_event_log(struct iwl_priv *priv,
+			   bool full_log, char **buf, bool display);
+
 static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 {
 	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 15e2645..aa7ced4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -496,6 +496,402 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		iwlagn_rx_queue_restock(trans);
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
+	u32 base;
+	struct iwl_error_event_table table;
+
+	base = priv->device_pointers.error_event_table;
+	if (priv->ucode_type == IWL_UCODE_INIT) {
+		if (!base)
+			base = priv->init_errlog_ptr;
+	} else {
+		if (!base)
+			base = priv->inst_errlog_ptr;
+	}
+
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
+		IWL_ERR(priv,
+			"Not valid error log pointer 0x%08X for %s uCode\n",
+			base,
+			(priv->ucode_type == IWL_UCODE_INIT)
+					? "Init" : "RT");
+		return;
+	}
+
+	iwl_read_targ_mem_words(priv, base, &table, sizeof(table));
+
+	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
+		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
+		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
+			priv->shrd->status, table.valid);
+	}
+
+	priv->isr_stats.err_code = table.error_id;
+
+	trace_iwlwifi_dev_ucode_error(priv, table.error_id, table.tsf_low,
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
+}
+
+/**
+ * iwl_irq_handle_error - called for HW or SW error interrupt from card
+ */
+static void iwl_irq_handle_error(struct iwl_priv *priv)
+{
+	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
+	if (priv->cfg->internal_wimax_coex &&
+	    (!(iwl_read_prph(priv, APMG_CLK_CTRL_REG) &
+			APMS_CLK_VAL_MRB_FUNC_MODE) ||
+	     (iwl_read_prph(priv, APMG_PS_CTRL_REG) &
+			APMG_PS_CTRL_VAL_RESET_REQ))) {
+		/*
+		 * Keep the restart process from trying to send host
+		 * commands by clearing the ready bit.
+		 */
+		clear_bit(STATUS_READY, &priv->shrd->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
+		wake_up_interruptible(&priv->wait_command_queue);
+		IWL_ERR(priv, "RF is used by WiMAX\n");
+		return;
+	}
+
+	IWL_ERR(priv, "Loaded firmware version: %s\n",
+		priv->hw->wiphy->fw_version);
+
+	iwl_dump_nic_error_log(priv);
+	iwl_dump_csr(priv);
+	iwl_dump_fh(priv, NULL, false);
+	iwl_dump_nic_event_log(priv, false, NULL, false);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS)
+		iwl_print_rx_config_cmd(priv,
+					&priv->contexts[IWL_RXON_CTX_BSS]);
+#endif
+
+	iwlagn_fw_error(priv, false);
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
+	if (num_events == 0)
+		return pos;
+
+	base = priv->device_pointers.log_event_table;
+	if (priv->ucode_type == IWL_UCODE_INIT) {
+		if (!base)
+			base = priv->init_evtlog_ptr;
+	} else {
+		if (!base)
+			base = priv->inst_evtlog_ptr;
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
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+
+	/* Set starting address; reads will auto-increment */
+	iwl_write32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	rmb();
+
+	/* "time" is actually "data" for mode 0 (no timestamp).
+	* place event id # at far right for easier visual parsing. */
+	for (i = 0; i < num_events; i++) {
+		ev = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		if (mode == 0) {
+			/* data, ev */
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
+		} else {
+			data = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"EVT_LOGT:%010u:0x%08x:%04u\n",
+						 time, data, ev);
+			} else {
+				IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
+					time, data, ev);
+				trace_iwlwifi_dev_ucode_event(priv, time,
+					data, ev);
+			}
+		}
+	}
+
+	/* Allow device to power down */
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
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
+
+	base = priv->device_pointers.log_event_table;
+	if (priv->ucode_type == IWL_UCODE_INIT) {
+		logsize = priv->init_evtlog_size;
+		if (!base)
+			base = priv->init_evtlog_ptr;
+	} else {
+		logsize = priv->inst_evtlog_size;
+		if (!base)
+			base = priv->inst_evtlog_ptr;
+	}
+
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
+		IWL_ERR(priv,
+			"Invalid event log pointer 0x%08X for %s uCode\n",
+			base,
+			(priv->ucode_type == IWL_UCODE_INIT)
+					? "Init" : "RT");
+		return -EINVAL;
+	}
+
+	/* event log header */
+	capacity = iwl_read_targ_mem(priv, base);
+	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
+
+	if (capacity > logsize) {
+		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
+			capacity, logsize);
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
+		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
+		return pos;
+	}
+
+	/* enable/disable bt channel inhibition */
+	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (!(iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) && !full_log)
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
+	if ((iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) || full_log) {
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
 /* tasklet for iwlagn interrupt */
 void iwl_irq_tasklet(struct iwl_trans *trans)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 687a092..5926cac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1458,7 +1458,46 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_log_event_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	char *buf;
+	int pos = 0;
+	ssize_t ret = -ENOMEM;
+
+	ret = pos = iwl_dump_nic_event_log(priv(trans), true, &buf, true);
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
+	struct iwl_trans *trans = file->private_data;
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
+		iwl_dump_nic_event_log(priv(trans), true, NULL, false);
+
+	return count;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
+DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
 
@@ -1472,6 +1511,7 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 	DEBUGFS_ADD_FILE(traffic_log, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
+	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
 	return 0;
 }
 #else
-- 
1.7.0.4

