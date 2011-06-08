Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab1FHN2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:28:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/6] iwlegacy: remove firmware event log
Date: Wed,  8 Jun 2011 15:28:27 +0200
Message-Id: <1307539709-11320-4-git-send-email-sgruszka@redhat.com> (sfid-20110608_152856_167274_7D33BACB)
In-Reply-To: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
References: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Messages like that

iwl4965 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
iwl4965 0000:03:00.0: EVT_LOGT:1821445332:0x00000000:1352
iwl4965 0000:03:00.0: EVT_LOGT:1821445332:0x00000001:1353
iwl4965 0000:03:00.0: EVT_LOGT:1821445336:0x0000000c:0357
iwl4965 0000:03:00.0: EVT_LOGT:1821445533:0x00000107:0106
iwl4965 0000:03:00.0: EVT_LOGT:1821445534:0x00000000:0302
iwl4965 0000:03:00.0: EVT_LOGT:1821445574:0x000000d4:0321
iwl4965 0000:03:00.0: EVT_LOGT:1821445575:0x00000000:1350
iwl4965 0000:03:00.0: EVT_LOGT:1821445576:0x00000000:1351
iwl4965 0000:03:00.0: EVT_LOGT:1821445576:0x00000000:1352
iwl4965 0000:03:00.0: EVT_LOGT:1821445577:0x00000001:1353
iwl4965 0000:03:00.0: EVT_LOGT:1821445581:0x0000000d:0357
iwl4965 0000:03:00.0: EVT_LOGT:1821446327:0x00000107:0106
iwl4965 0000:03:00.0: EVT_LOGT:1821446328:0x00000000:0302
iwl4965 0000:03:00.0: EVT_LOGT:1821446368:0x000000d4:0321
iwl4965 0000:03:00.0: EVT_LOGT:1821446369:0x00000000:1350
iwl4965 0000:03:00.0: EVT_LOGT:1821446370:0x00000000:1351
iwl4965 0000:03:00.0: EVT_LOGT:1821446370:0x00000000:1352
iwl4965 0000:03:00.0: EVT_LOGT:1821446371:0x00000001:1353
iwl4965 0000:03:00.0: EVT_LOGT:1821446375:0x0000000e:0357
iwl4965 0000:03:00.0: EVT_LOGT:1821446383:0x00000000:0125

are completely useless for me. Remove bunch of code that generate them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    2 -
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    2 -
 drivers/net/wireless/iwlegacy/iwl-core.c     |    1 -
 drivers/net/wireless/iwlegacy/iwl-core.h     |    7 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c  |   97 --------
 drivers/net/wireless/iwlegacy/iwl-dev.h      |   29 ---
 drivers/net/wireless/iwlegacy/iwl-devtrace.c |    3 -
 drivers/net/wireless/iwlegacy/iwl-devtrace.h |   60 -----
 drivers/net/wireless/iwlegacy/iwl3945-base.c |  206 ----------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |  336 --------------------------
 10 files changed, 1 insertions(+), 742 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 8aa018d..dab67a1 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -2639,7 +2639,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.txq_free_tfd = iwl3945_hw_txq_free_tfd,
 	.txq_init = iwl3945_hw_tx_queue_init,
 	.load_ucode = iwl3945_load_bsm,
-	.dump_nic_event_log = iwl3945_dump_nic_event_log,
 	.dump_nic_error_log = iwl3945_dump_nic_error_log,
 	.apm_ops = {
 		.init = iwl3945_apm_init,
@@ -2698,7 +2697,6 @@ static struct iwl_base_params iwl3945_base_params = {
 	.use_bsm = true,
 	.led_compensation = 64,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
-	.max_event_log_size = 512,
 };
 
 static struct iwl_cfg iwl3945_bg_cfg = {
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 59a4b53..bd4b000 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -2069,7 +2069,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.init_alive_start = iwl4965_init_alive_start,
 	.load_ucode = iwl4965_load_bsm,
-	.dump_nic_event_log = iwl4965_dump_nic_event_log,
 	.dump_nic_error_log = iwl4965_dump_nic_error_log,
 	.dump_fh = iwl4965_dump_fh,
 	.set_channel_switch = iwl4965_hw_channel_switch,
@@ -2151,7 +2150,6 @@ static struct iwl_base_params iwl4965_base_params = {
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.temperature_kelvin = true,
-	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 240d3a8..35cd253 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -931,7 +931,6 @@ void iwl_legacy_irq_handle_error(struct iwl_priv *priv)
 	priv->cfg->ops->lib->dump_nic_error_log(priv);
 	if (priv->cfg->ops->lib->dump_fh)
 		priv->cfg->ops->lib->dump_fh(priv, NULL, false);
-	priv->cfg->ops->lib->dump_nic_event_log(priv, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (iwl_legacy_get_debug_level(priv) & IWL_DL_FW_ERRORS)
 		iwl_legacy_print_rx_config_cmd(priv,
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 8f766e9..a2de7e9 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -143,8 +143,7 @@ struct iwl_lib_ops {
 	int (*is_valid_rtc_data_addr)(u32 addr);
 	/* 1st ucode load */
 	int (*load_ucode)(struct iwl_priv *priv);
-	int (*dump_nic_event_log)(struct iwl_priv *priv,
-				  bool full_log, char **buf, bool display);
+
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
 	int (*dump_fh)(struct iwl_priv *priv, char **buf, bool display);
 	int (*set_channel_switch)(struct iwl_priv *priv,
@@ -206,7 +205,6 @@ struct iwl_mod_params {
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @wd_timeout: TX queues watchdog timeout
  * @temperature_kelvin: temperature report by uCode in kelvin
- * @max_event_log_size: size of event log buffer size for ucode event logging
  * @ucode_tracing: support ucode continuous tracing
  * @sensitivity_calib_by_driver: driver has the capability to perform
  *	sensitivity calibration operation
@@ -226,7 +224,6 @@ struct iwl_base_params {
 	int chain_noise_num_beacons;
 	unsigned int wd_timeout;
 	bool temperature_kelvin;
-	u32 max_event_log_size;
 	const bool ucode_tracing;
 	const bool sensitivity_calib_by_driver;
 	const bool chain_noise_calib_by_driver;
@@ -515,8 +512,6 @@ extern const struct dev_pm_ops iwl_legacy_pm_ops;
 *  Error Handling Debugging
 ******************************************************/
 void iwl4965_dump_nic_error_log(struct iwl_priv *priv);
-int iwl4965_dump_nic_event_log(struct iwl_priv *priv,
-			   bool full_log, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 void iwl_legacy_print_rx_config_cmd(struct iwl_priv *priv,
 			     struct iwl_rxon_context *ctx);
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 88ffc92..996996a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -391,48 +391,6 @@ static ssize_t iwl_legacy_dbgfs_nvm_read(struct file *file,
 	return ret;
 }
 
-static ssize_t iwl_legacy_dbgfs_log_event_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
-
-	ret = pos = priv->cfg->ops->lib->dump_nic_event_log(
-					priv, true, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		kfree(buf);
-	}
-	return ret;
-}
-
-static ssize_t iwl_legacy_dbgfs_log_event_write(struct file *file,
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
-		priv->cfg->ops->lib->dump_nic_event_log(priv, true,
-							NULL, false);
-
-	return count;
-}
-
-
-
 static ssize_t
 iwl_legacy_dbgfs_channels_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
@@ -706,7 +664,6 @@ static ssize_t iwl_legacy_dbgfs_disable_ht40_read(struct file *file,
 }
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
-DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(channels);
@@ -1098,56 +1055,6 @@ static ssize_t iwl_legacy_dbgfs_clear_ucode_statistics_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_legacy_dbgfs_ucode_tracing_read(struct file *file,
-					char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	int pos = 0;
-	char buf[128];
-	const size_t bufsz = sizeof(buf);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "ucode trace timer is %s\n",
-			priv->event_log.ucode_trace ? "On" : "Off");
-	pos += scnprintf(buf + pos, bufsz - pos, "non_wraps_count:\t\t %u\n",
-			priv->event_log.non_wraps_count);
-	pos += scnprintf(buf + pos, bufsz - pos, "wraps_once_count:\t\t %u\n",
-			priv->event_log.wraps_once_count);
-	pos += scnprintf(buf + pos, bufsz - pos, "wraps_more_count:\t\t %u\n",
-			priv->event_log.wraps_more_count);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_legacy_dbgfs_ucode_tracing_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int trace;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &trace) != 1)
-		return -EFAULT;
-
-	if (trace) {
-		priv->event_log.ucode_trace = true;
-		/* schedule the ucode timer to occur in UCODE_TRACE_PERIOD */
-		mod_timer(&priv->ucode_trace,
-			jiffies + msecs_to_jiffies(UCODE_TRACE_PERIOD));
-	} else {
-		priv->event_log.ucode_trace = false;
-		del_timer_sync(&priv->ucode_trace);
-	}
-
-	return count;
-}
-
 static ssize_t iwl_legacy_dbgfs_rxon_flags_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos) {
@@ -1312,7 +1219,6 @@ DEBUGFS_READ_FILE_OPS(chain_noise);
 DEBUGFS_READ_FILE_OPS(power_save_status);
 DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
 DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
-DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
@@ -1347,7 +1253,6 @@ int iwl_legacy_dbgfs_register(struct iwl_priv *priv, const char *name)
 
 	DEBUGFS_ADD_FILE(nvm, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(sram, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(log_event, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(stations, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(channels, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
@@ -1373,8 +1278,6 @@ int iwl_legacy_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
 	if (priv->cfg->base_params->chain_noise_calib_by_driver)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
-	if (priv->cfg->base_params->ucode_tracing)
-		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index c5a135a..fd792e1 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -855,32 +855,6 @@ struct traffic_stats {
 };
 
 /*
- * schedule the timer to wake up every UCODE_TRACE_PERIOD milliseconds
- * to perform continuous uCode event logging operation if enabled
- */
-#define UCODE_TRACE_PERIOD (100)
-
-/*
- * iwl_event_log: current uCode event log position
- *
- * @ucode_trace: enable/disable ucode continuous trace timer
- * @num_wraps: how many times the event buffer wraps
- * @next_entry:  the entry just before the next one that uCode would fill
- * @non_wraps_count: counter for no wrap detected when dump ucode events
- * @wraps_once_count: counter for wrap once detected when dump ucode events
- * @wraps_more_count: counter for wrap more than once detected
- *		      when dump ucode events
- */
-struct iwl_event_log {
-	bool ucode_trace;
-	u32 num_wraps;
-	u32 next_entry;
-	int non_wraps_count;
-	int wraps_once_count;
-	int wraps_more_count;
-};
-
-/*
  * host interrupt timeout value
  * used with setting interrupt coalescing timer
  * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
@@ -1270,12 +1244,9 @@ struct iwl_priv {
 	u32 disable_tx_power_cal;
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
-	struct timer_list ucode_trace;
 	struct timer_list watchdog;
 	bool hw_ready;
 
-	struct iwl_event_log event_log;
-
 	struct led_classdev led;
 	unsigned long blink_on, blink_off;
 	bool led_registered;
diff --git a/drivers/net/wireless/iwlegacy/iwl-devtrace.c b/drivers/net/wireless/iwlegacy/iwl-devtrace.c
index 080b852..acec991 100644
--- a/drivers/net/wireless/iwlegacy/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlegacy/iwl-devtrace.c
@@ -38,8 +38,5 @@ EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_ioread32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_iowrite32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_rx);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_tx);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_ucode_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_ucode_error);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_ucode_cont_event);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_ucode_wrap_event);
 #endif
diff --git a/drivers/net/wireless/iwlegacy/iwl-devtrace.h b/drivers/net/wireless/iwlegacy/iwl-devtrace.h
index 9612aa0..a443725 100644
--- a/drivers/net/wireless/iwlegacy/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlegacy/iwl-devtrace.h
@@ -96,47 +96,6 @@ TRACE_EVENT(iwlwifi_legacy_dev_iowrite32,
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_legacy_ucode
 
-TRACE_EVENT(iwlwifi_legacy_dev_ucode_cont_event,
-	TP_PROTO(struct iwl_priv *priv, u32 time, u32 data, u32 ev),
-	TP_ARGS(priv, time, data, ev),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-
-		__field(u32, time)
-		__field(u32, data)
-		__field(u32, ev)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->time = time;
-		__entry->data = data;
-		__entry->ev = ev;
-	),
-	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
-		  __entry->priv, __entry->time, __entry->data, __entry->ev)
-);
-
-TRACE_EVENT(iwlwifi_legacy_dev_ucode_wrap_event,
-	TP_PROTO(struct iwl_priv *priv, u32 wraps, u32 n_entry, u32 p_entry),
-	TP_ARGS(priv, wraps, n_entry, p_entry),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-
-		__field(u32, wraps)
-		__field(u32, n_entry)
-		__field(u32, p_entry)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->wraps = wraps;
-		__entry->n_entry = n_entry;
-		__entry->p_entry = p_entry;
-	),
-	TP_printk("[%p] wraps=#%02d n=0x%X p=0x%X",
-		  __entry->priv, __entry->wraps, __entry->n_entry,
-		  __entry->p_entry)
-);
-
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi
 
@@ -242,25 +201,6 @@ TRACE_EVENT(iwlwifi_legacy_dev_ucode_error,
 		  __entry->blink2, __entry->ilink1, __entry->ilink2)
 );
 
-TRACE_EVENT(iwlwifi_legacy_dev_ucode_event,
-	TP_PROTO(struct iwl_priv *priv, u32 time, u32 data, u32 ev),
-	TP_ARGS(priv, time, data, ev),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-
-		__field(u32, time)
-		__field(u32, data)
-		__field(u32, ev)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->time = time;
-		__entry->data = data;
-		__entry->ev = ev;
-	),
-	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
-		  __entry->priv, __entry->time, __entry->data, __entry->ev)
-);
 #endif /* __IWLWIFI_DEVICE_TRACE */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index da42442..795826a 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -1409,212 +1409,6 @@ void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 	}
 }
 
-#define EVENT_START_OFFSET  (6 * sizeof(u32))
-
-/**
- * iwl3945_print_event_log - Dump error event log to syslog
- *
- */
-static int iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
-				  u32 num_events, u32 mode,
-				  int pos, char **buf, size_t bufsz)
-{
-	u32 i;
-	u32 base;       /* SRAM byte address of event log header */
-	u32 event_size;	/* 2 u32s, or 3 u32s if timestamp recorded */
-	u32 ptr;        /* SRAM byte address of log data */
-	u32 ev, time, data; /* event log data */
-	unsigned long reg_flags;
-
-	if (num_events == 0)
-		return pos;
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
-	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-
-	/* Set starting address; reads will auto-increment */
-	_iwl_legacy_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
-
-	/* "time" is actually "data" for mode 0 (no timestamp).
-	 * place event id # at far right for easier visual parsing. */
-	for (i = 0; i < num_events; i++) {
-		ev = _iwl_legacy_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		time = _iwl_legacy_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (mode == 0) {
-			/* data, ev */
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"0x%08x:%04u\n",
-						time, ev);
-			} else {
-				IWL_ERR(priv, "0x%08x\t%04u\n", time, ev);
-				trace_iwlwifi_legacy_dev_ucode_event(priv, 0,
-							      time, ev);
-			}
-		} else {
-			data = _iwl_legacy_read_direct32(priv,
-							HBUS_TARG_MEM_RDAT);
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"%010u:0x%08x:%04u\n",
-						 time, data, ev);
-			} else {
-				IWL_ERR(priv, "%010u\t0x%08x\t%04u\n",
-					time, data, ev);
-				trace_iwlwifi_legacy_dev_ucode_event(priv, time,
-							      data, ev);
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
- * iwl3945_print_last_event_logs - Dump the newest # of event log to syslog
- */
-static int iwl3945_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
-				      u32 num_wraps, u32 next_entry,
-				      u32 size, u32 mode,
-				      int pos, char **buf, size_t bufsz)
-{
-	/*
-	 * display the newest DEFAULT_LOG_ENTRIES entries
-	 * i.e the entries just before the next ont that uCode would fill.
-	 */
-	if (num_wraps) {
-		if (next_entry < size) {
-			pos = iwl3945_print_event_log(priv,
-					     capacity - (size - next_entry),
-					     size - next_entry, mode,
-					     pos, buf, bufsz);
-			pos = iwl3945_print_event_log(priv, 0,
-						      next_entry, mode,
-						      pos, buf, bufsz);
-		} else
-			pos = iwl3945_print_event_log(priv, next_entry - size,
-						      size, mode,
-						      pos, buf, bufsz);
-	} else {
-		if (next_entry < size)
-			pos = iwl3945_print_event_log(priv, 0,
-						      next_entry, mode,
-						      pos, buf, bufsz);
-		else
-			pos = iwl3945_print_event_log(priv, next_entry - size,
-						      size, mode,
-						      pos, buf, bufsz);
-	}
-	return pos;
-}
-
-#define DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES (20)
-
-int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
-			    char **buf, bool display)
-{
-	u32 base;       /* SRAM byte address of event log header */
-	u32 capacity;   /* event log capacity in # entries */
-	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
-	u32 num_wraps;  /* # times uCode wrapped to top of log */
-	u32 next_entry; /* index of next entry to be written by uCode */
-	u32 size;       /* # entries that we'll print */
-	int pos = 0;
-	size_t bufsz = 0;
-
-	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
-		return  -EINVAL;
-	}
-
-	/* event log header */
-	capacity = iwl_legacy_read_targ_mem(priv, base);
-	mode = iwl_legacy_read_targ_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_legacy_read_targ_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_legacy_read_targ_mem(priv, base + (3 * sizeof(u32)));
-
-	if (capacity > priv->cfg->base_params->max_event_log_size) {
-		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
-			capacity, priv->cfg->base_params->max_event_log_size);
-		capacity = priv->cfg->base_params->max_event_log_size;
-	}
-
-	if (next_entry > priv->cfg->base_params->max_event_log_size) {
-		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
-			next_entry, priv->cfg->base_params->max_event_log_size);
-		next_entry = priv->cfg->base_params->max_event_log_size;
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
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-	if (!(iwl_legacy_get_debug_level(priv) & IWL_DL_FW_ERRORS) && !full_log)
-		size = (size > DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES)
-			? DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES : size;
-#else
-	size = (size > DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES)
-		? DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES : size;
-#endif
-
-	IWL_ERR(priv, "Start IWL Event Log Dump: display last %d count\n",
-		  size);
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-	if (display) {
-		if (full_log)
-			bufsz = capacity * 48;
-		else
-			bufsz = size * 48;
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-	}
-	if ((iwl_legacy_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
-		/* if uCode has wrapped back to top of log,
-		 * start at the oldest entry,
-		 * i.e the next one that uCode would fill.
-		 */
-		if (num_wraps)
-			pos = iwl3945_print_event_log(priv, next_entry,
-						capacity - next_entry, mode,
-						pos, buf, bufsz);
-
-		/* (then/else) start at top of log */
-		pos = iwl3945_print_event_log(priv, 0, next_entry, mode,
-					      pos, buf, bufsz);
-	} else
-		pos = iwl3945_print_last_event_logs(priv, capacity, num_wraps,
-						    next_entry, size, mode,
-						    pos, buf, bufsz);
-#else
-	pos = iwl3945_print_last_event_logs(priv, capacity, num_wraps,
-					    next_entry, size, mode,
-					    pos, buf, bufsz);
-#endif
-	return pos;
-}
-
 static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index ed86b22..98e42a1 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -488,134 +488,6 @@ static void iwl4965_bg_statistics_periodic(unsigned long data)
 	iwl_legacy_send_statistics_request(priv, CMD_ASYNC, false);
 }
 
-
-static void iwl4965_print_cont_event_trace(struct iwl_priv *priv, u32 base,
-					u32 start_idx, u32 num_events,
-					u32 mode)
-{
-	u32 i;
-	u32 ptr;        /* SRAM byte address of log data */
-	u32 ev, time, data; /* event log data */
-	unsigned long reg_flags;
-
-	if (mode == 0)
-		ptr = base + (4 * sizeof(u32)) + (start_idx * 2 * sizeof(u32));
-	else
-		ptr = base + (4 * sizeof(u32)) + (start_idx * 3 * sizeof(u32));
-
-	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	if (iwl_grab_nic_access(priv)) {
-		spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-		return;
-	}
-
-	/* Set starting address; reads will auto-increment */
-	_iwl_legacy_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
-
-	/*
-	 * "time" is actually "data" for mode 0 (no timestamp).
-	 * place event id # at far right for easier visual parsing.
-	 */
-	for (i = 0; i < num_events; i++) {
-		ev = _iwl_legacy_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		time = _iwl_legacy_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (mode == 0) {
-			trace_iwlwifi_legacy_dev_ucode_cont_event(priv,
-							0, time, ev);
-		} else {
-			data = _iwl_legacy_read_direct32(priv,
-						HBUS_TARG_MEM_RDAT);
-			trace_iwlwifi_legacy_dev_ucode_cont_event(priv,
-						time, data, ev);
-		}
-	}
-	/* Allow device to power down */
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
-
-static void iwl4965_continuous_event_trace(struct iwl_priv *priv)
-{
-	u32 capacity;   /* event log capacity in # entries */
-	u32 base;       /* SRAM byte address of event log header */
-	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
-	u32 num_wraps;  /* # times uCode wrapped to top of log */
-	u32 next_entry; /* index of next entry to be written by uCode */
-
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
-	else
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-	if (priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		capacity = iwl_legacy_read_targ_mem(priv, base);
-		num_wraps = iwl_legacy_read_targ_mem(priv,
-						base + (2 * sizeof(u32)));
-		mode = iwl_legacy_read_targ_mem(priv, base + (1 * sizeof(u32)));
-		next_entry = iwl_legacy_read_targ_mem(priv,
-						base + (3 * sizeof(u32)));
-	} else
-		return;
-
-	if (num_wraps == priv->event_log.num_wraps) {
-		iwl4965_print_cont_event_trace(priv,
-				       base, priv->event_log.next_entry,
-				       next_entry - priv->event_log.next_entry,
-				       mode);
-		priv->event_log.non_wraps_count++;
-	} else {
-		if ((num_wraps - priv->event_log.num_wraps) > 1)
-			priv->event_log.wraps_more_count++;
-		else
-			priv->event_log.wraps_once_count++;
-		trace_iwlwifi_legacy_dev_ucode_wrap_event(priv,
-				num_wraps - priv->event_log.num_wraps,
-				next_entry, priv->event_log.next_entry);
-		if (next_entry < priv->event_log.next_entry) {
-			iwl4965_print_cont_event_trace(priv, base,
-			       priv->event_log.next_entry,
-			       capacity - priv->event_log.next_entry,
-			       mode);
-
-			iwl4965_print_cont_event_trace(priv, base, 0,
-				next_entry, mode);
-		} else {
-			iwl4965_print_cont_event_trace(priv, base,
-			       next_entry, capacity - next_entry,
-			       mode);
-
-			iwl4965_print_cont_event_trace(priv, base, 0,
-				next_entry, mode);
-		}
-	}
-	priv->event_log.num_wraps = num_wraps;
-	priv->event_log.next_entry = next_entry;
-}
-
-/**
- * iwl4965_bg_ucode_trace - Timer callback to log ucode event
- *
- * The timer is continually set to execute every
- * UCODE_TRACE_PERIOD milliseconds after the last timer expired
- * this function is to perform continuous uCode event logging operation
- * if enabled
- */
-static void iwl4965_bg_ucode_trace(unsigned long data)
-{
-	struct iwl_priv *priv = (struct iwl_priv *)data;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (priv->event_log.ucode_trace) {
-		iwl4965_continuous_event_trace(priv);
-		/* Reschedule the timer to occur in UCODE_TRACE_PERIOD */
-		mod_timer(&priv->ucode_trace,
-			 jiffies + msecs_to_jiffies(UCODE_TRACE_PERIOD));
-	}
-}
-
 static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
@@ -1711,209 +1583,6 @@ void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 		pc, blink1, blink2, ilink1, ilink2, hcmd);
 }
 
-#define EVENT_START_OFFSET  (4 * sizeof(u32))
-
-/**
- * iwl4965_print_event_log - Dump error event log to syslog
- *
- */
-static int iwl4965_print_event_log(struct iwl_priv *priv, u32 start_idx,
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
-	if (priv->ucode_type == UCODE_INIT) {
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	} else {
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
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
-	_iwl_legacy_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
-
-	/* "time" is actually "data" for mode 0 (no timestamp).
-	* place event id # at far right for easier visual parsing. */
-	for (i = 0; i < num_events; i++) {
-		ev = _iwl_legacy_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		time = _iwl_legacy_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (mode == 0) {
-			/* data, ev */
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOG:0x%08x:%04u\n",
-						time, ev);
-			} else {
-				trace_iwlwifi_legacy_dev_ucode_event(priv, 0,
-					time, ev);
-				IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n",
-					time, ev);
-			}
-		} else {
-			data = _iwl_legacy_read_direct32(priv,
-						HBUS_TARG_MEM_RDAT);
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOGT:%010u:0x%08x:%04u\n",
-						 time, data, ev);
-			} else {
-				IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
-					time, data, ev);
-				trace_iwlwifi_legacy_dev_ucode_event(priv, time,
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
- * iwl4965_print_last_event_logs - Dump the newest # of event log to syslog
- */
-static int iwl4965_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
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
-			pos = iwl4965_print_event_log(priv,
-						capacity - (size - next_entry),
-						size - next_entry, mode,
-						pos, buf, bufsz);
-			pos = iwl4965_print_event_log(priv, 0,
-						  next_entry, mode,
-						  pos, buf, bufsz);
-		} else
-			pos = iwl4965_print_event_log(priv, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-	} else {
-		if (next_entry < size) {
-			pos = iwl4965_print_event_log(priv, 0, next_entry,
-						  mode, pos, buf, bufsz);
-		} else {
-			pos = iwl4965_print_event_log(priv, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-		}
-	}
-	return pos;
-}
-
-#define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
-
-int iwl4965_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
-			    char **buf, bool display)
-{
-	u32 base;       /* SRAM byte address of event log header */
-	u32 capacity;   /* event log capacity in # entries */
-	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
-	u32 num_wraps;  /* # times uCode wrapped to top of log */
-	u32 next_entry; /* index of next entry to be written by uCode */
-	u32 size;       /* # entries that we'll print */
-	int pos = 0;
-	size_t bufsz = 0;
-
-	if (priv->ucode_type == UCODE_INIT) {
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	} else {
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-	}
-
-	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv,
-			"Invalid event log pointer 0x%08X for %s uCode\n",
-			base, (priv->ucode_type == UCODE_INIT) ? "Init" : "RT");
-		return -EINVAL;
-	}
-
-	/* event log header */
-	capacity = iwl_legacy_read_targ_mem(priv, base);
-	mode = iwl_legacy_read_targ_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_legacy_read_targ_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_legacy_read_targ_mem(priv, base + (3 * sizeof(u32)));
-
-	size = num_wraps ? capacity : next_entry;
-
-	/* bail out if nothing in log */
-	if (size == 0) {
-		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
-		return pos;
-	}
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-	if (!(iwl_legacy_get_debug_level(priv) & IWL_DL_FW_ERRORS) && !full_log)
-		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#else
-	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#endif
-	IWL_ERR(priv, "Start IWL Event Log Dump: display last %u entries\n",
-		size);
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-	if (display) {
-		if (full_log)
-			bufsz = capacity * 48;
-		else
-			bufsz = size * 48;
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-	}
-	if ((iwl_legacy_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
-		/*
-		 * if uCode has wrapped back to top of log,
-		 * start at the oldest entry,
-		 * i.e the next one that uCode would fill.
-		 */
-		if (num_wraps)
-			pos = iwl4965_print_event_log(priv, next_entry,
-						capacity - next_entry, mode,
-						pos, buf, bufsz);
-		/* (then/else) start at top of log */
-		pos = iwl4965_print_event_log(priv, 0,
-					  next_entry, mode, pos, buf, bufsz);
-	} else
-		pos = iwl4965_print_last_event_logs(priv, capacity, num_wraps,
-						next_entry, size, mode,
-						pos, buf, bufsz);
-#else
-	pos = iwl4965_print_last_event_logs(priv, capacity, num_wraps,
-					next_entry, size, mode,
-					pos, buf, bufsz);
-#endif
-	return pos;
-}
-
 static void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
@@ -3034,10 +2703,6 @@ static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
 	priv->statistics_periodic.data = (unsigned long)priv;
 	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
 
-	init_timer(&priv->ucode_trace);
-	priv->ucode_trace.data = (unsigned long)priv;
-	priv->ucode_trace.function = iwl4965_bg_ucode_trace;
-
 	init_timer(&priv->watchdog);
 	priv->watchdog.data = (unsigned long)priv;
 	priv->watchdog.function = iwl_legacy_bg_watchdog;
@@ -3056,7 +2721,6 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 	iwl_legacy_cancel_scan_deferred_work(priv);
 
 	del_timer_sync(&priv->statistics_periodic);
-	del_timer_sync(&priv->ucode_trace);
 }
 
 static void iwl4965_init_hw_rates(struct iwl_priv *priv,
-- 
1.7.1

