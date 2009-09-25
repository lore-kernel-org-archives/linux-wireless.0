Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbZIYVYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8 v2.6.32 and w-t] iwlwifi: fix 3945 ucode info retrieval after failure
Date: Fri, 25 Sep 2009 14:24:23 -0700
Message-Id: <1253913868-8400-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
References: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When hardware or uCode problem occurs driver captures significant
information from device to enable debugging. The format of this information
is different between 3945 and 4965 and later devices, yet currently the
3945 uses the 4965 and later format. Fix this by adding a new library call
that is initialized to the correct formatting routine based on device.

This moves the iwlagn event and error log handling back to iwl-agn.c to
make it part of iwlagn module.

Also remove the 3945 sysfs file that triggers dump of event log - there is
already a debugfs file that can do it for all drivers.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 +
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  185 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |  187 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   14 ++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   31 ++---
 11 files changed, 229 insertions(+), 204 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 4abfc84..3b3e6bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -102,6 +102,8 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
 	.load_ucode = iwl5000_load_ucode,
+	.dump_nic_event_log = iwl_dump_nic_event_log,
+	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 63dfa57..33e40c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2839,6 +2839,8 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.txq_free_tfd = iwl3945_hw_txq_free_tfd,
 	.txq_init = iwl3945_hw_tx_queue_init,
 	.load_ucode = iwl3945_load_bsm,
+	.dump_nic_event_log = iwl3945_dump_nic_event_log,
+	.dump_nic_error_log = iwl3945_dump_nic_error_log,
 	.apm_ops = {
 		.init = iwl3945_apm_init,
 		.reset = iwl3945_apm_reset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index f240369..21679bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -209,6 +209,8 @@ extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
 					 struct iwl_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
+extern void iwl3945_dump_nic_event_log(struct iwl_priv *priv);
+extern void iwl3945_dump_nic_error_log(struct iwl_priv *priv);
 
 /*
  * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 021e855..9ad5bca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2292,6 +2292,8 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.alive_notify = iwl4965_alive_notify,
 	.init_alive_start = iwl4965_init_alive_start,
 	.load_ucode = iwl4965_load_bsm,
+	.dump_nic_event_log = iwl_dump_nic_event_log,
+	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.apm_ops = {
 		.init = iwl4965_apm_init,
 		.reset = iwl4965_apm_reset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2bb282e..e5b0fab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1540,6 +1540,8 @@ struct iwl_lib_ops iwl5000_lib = {
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.dump_nic_event_log = iwl_dump_nic_event_log,
+	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
@@ -1590,6 +1592,8 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.dump_nic_event_log = iwl_dump_nic_event_log,
+	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 73ca012..01a1f81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -183,6 +183,8 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
 	.load_ucode = iwl5000_load_ucode,
+	.dump_nic_event_log = iwl_dump_nic_event_log,
+	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d39467f..26c66b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1530,6 +1530,191 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+static const char *desc_lookup_text[] = {
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
+	"NMI_INTERRUPT_BREAK_POINT"
+	"DEBUG_0",
+	"DEBUG_1",
+	"DEBUG_2",
+	"DEBUG_3",
+	"UNKNOWN"
+};
+
+static const char *desc_lookup(int i)
+{
+	int max = ARRAY_SIZE(desc_lookup_text) - 1;
+
+	if (i < 0 || i > max)
+		i = max;
+
+	return desc_lookup_text[i];
+}
+
+#define ERROR_START_OFFSET  (1 * sizeof(u32))
+#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
+
+void iwl_dump_nic_error_log(struct iwl_priv *priv)
+{
+	u32 data2, line;
+	u32 desc, time, count, base, data1;
+	u32 blink1, blink2, ilink1, ilink2;
+
+	if (priv->ucode_type == UCODE_INIT)
+		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
+	else
+		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
+
+	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+		IWL_ERR(priv, "Not valid error log pointer 0x%08X\n", base);
+		return;
+	}
+
+	count = iwl_read_targ_mem(priv, base);
+
+	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
+		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
+		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
+			priv->status, count);
+	}
+
+	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
+	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
+	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
+	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
+	ilink2 = iwl_read_targ_mem(priv, base + 6 * sizeof(u32));
+	data1 = iwl_read_targ_mem(priv, base + 7 * sizeof(u32));
+	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
+	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
+	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
+
+	IWL_ERR(priv, "Desc                               Time       "
+		"data1      data2      line\n");
+	IWL_ERR(priv, "%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
+		desc_lookup(desc), desc, time, data1, data2, line);
+	IWL_ERR(priv, "blink1  blink2  ilink1  ilink2\n");
+	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
+		ilink1, ilink2);
+
+}
+
+#define EVENT_START_OFFSET  (4 * sizeof(u32))
+
+/**
+ * iwl_print_event_log - Dump error event log to syslog
+ *
+ */
+static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
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
+	if (priv->ucode_type == UCODE_INIT)
+		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
+	else
+		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
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
+		if (mode == 0) {
+			/* data, ev */
+			IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n", time, ev);
+		} else {
+			data = iwl_read_targ_mem(priv, ptr);
+			ptr += sizeof(u32);
+			IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
+					time, data, ev);
+		}
+	}
+}
+
+void iwl_dump_nic_event_log(struct iwl_priv *priv)
+{
+	u32 base;       /* SRAM byte address of event log header */
+	u32 capacity;   /* event log capacity in # entries */
+	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
+	u32 num_wraps;  /* # times uCode wrapped to top of log */
+	u32 next_entry; /* index of next entry to be written by uCode */
+	u32 size;       /* # entries that we'll print */
+
+	if (priv->ucode_type == UCODE_INIT)
+		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
+	else
+		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+
+	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
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
+		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
+		return;
+	}
+
+	IWL_ERR(priv, "Start IWL Event Log Dump: display count %d, wraps %d\n",
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
+}
+#endif
+
 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e447c1a..2908bff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1289,189 +1289,6 @@ static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 	IWL_DEBUG_RADIO(priv, "u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
 	IWL_DEBUG_RADIO(priv, "u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
-
-static const char *desc_lookup_text[] = {
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
-	"NMI_INTERRUPT_BREAK_POINT"
-	"DEBUG_0",
-	"DEBUG_1",
-	"DEBUG_2",
-	"DEBUG_3",
-	"UNKNOWN"
-};
-
-static const char *desc_lookup(int i)
-{
-	int max = ARRAY_SIZE(desc_lookup_text) - 1;
-
-	if (i < 0 || i > max)
-		i = max;
-
-	return desc_lookup_text[i];
-}
-
-#define ERROR_START_OFFSET  (1 * sizeof(u32))
-#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
-
-static void iwl_dump_nic_error_log(struct iwl_priv *priv)
-{
-	u32 data2, line;
-	u32 desc, time, count, base, data1;
-	u32 blink1, blink2, ilink1, ilink2;
-
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
-	else
-		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
-
-	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv, "Not valid error log pointer 0x%08X\n", base);
-		return;
-	}
-
-	count = iwl_read_targ_mem(priv, base);
-
-	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
-		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
-		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
-			priv->status, count);
-	}
-
-	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
-	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
-	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
-	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
-	ilink2 = iwl_read_targ_mem(priv, base + 6 * sizeof(u32));
-	data1 = iwl_read_targ_mem(priv, base + 7 * sizeof(u32));
-	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
-	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
-	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
-
-	IWL_ERR(priv, "Desc                               Time       "
-		"data1      data2      line\n");
-	IWL_ERR(priv, "%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
-		desc_lookup(desc), desc, time, data1, data2, line);
-	IWL_ERR(priv, "blink1  blink2  ilink1  ilink2\n");
-	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
-		ilink1, ilink2);
-
-}
-
-#define EVENT_START_OFFSET  (4 * sizeof(u32))
-
-/**
- * iwl_print_event_log - Dump error event log to syslog
- *
- */
-static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
-				u32 num_events, u32 mode)
-{
-	u32 i;
-	u32 base;       /* SRAM byte address of event log header */
-	u32 event_size; /* 2 u32s, or 3 u32s if timestamp recorded */
-	u32 ptr;        /* SRAM byte address of log data */
-	u32 ev, time, data; /* event log data */
-
-	if (num_events == 0)
-		return;
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	else
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-
-	if (mode == 0)
-		event_size = 2 * sizeof(u32);
-	else
-		event_size = 3 * sizeof(u32);
-
-	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
-
-	/* "time" is actually "data" for mode 0 (no timestamp).
-	* place event id # at far right for easier visual parsing. */
-	for (i = 0; i < num_events; i++) {
-		ev = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
-		time = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
-		if (mode == 0) {
-			/* data, ev */
-			IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n", time, ev);
-		} else {
-			data = iwl_read_targ_mem(priv, ptr);
-			ptr += sizeof(u32);
-			IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
-					time, data, ev);
-		}
-	}
-}
-
-void iwl_dump_nic_event_log(struct iwl_priv *priv)
-{
-	u32 base;       /* SRAM byte address of event log header */
-	u32 capacity;   /* event log capacity in # entries */
-	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
-	u32 num_wraps;  /* # times uCode wrapped to top of log */
-	u32 next_entry; /* index of next entry to be written by uCode */
-	u32 size;       /* # entries that we'll print */
-
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	else
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-
-	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
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
-		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
-		return;
-	}
-
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
-
-}
 #endif
 /**
  * iwl_irq_handle_error - called for HW or SW error interrupt from card
@@ -1486,8 +1303,8 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) {
-		iwl_dump_nic_error_log(priv);
-		iwl_dump_nic_event_log(priv);
+		priv->cfg->ops->lib->dump_nic_error_log(priv);
+		priv->cfg->ops->lib->dump_nic_event_log(priv);
 		iwl_print_rx_config_cmd(priv);
 	}
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3791c87..f094cd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -167,6 +167,8 @@ struct iwl_lib_ops {
 	int (*is_valid_rtc_data_addr)(u32 addr);
 	/* 1st ucode load */
 	int (*load_ucode)(struct iwl_priv *priv);
+	void (*dump_nic_event_log)(struct iwl_priv *priv);
+	void (*dump_nic_error_log)(struct iwl_priv *priv);
 	/* power management */
 	struct iwl_apm_ops apm_ops;
 
@@ -547,7 +549,19 @@ int iwl_pci_resume(struct pci_dev *pdev);
 /*****************************************************
 *  Error Handling Debugging
 ******************************************************/
+#ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
+void iwl_dump_nic_error_log(struct iwl_priv *priv);
+#else
+static inline void iwl_dump_nic_event_log(struct iwl_priv *priv)
+{
+}
+
+static inline void iwl_dump_nic_error_log(struct iwl_priv *priv)
+{
+}
+#endif
+
 void iwl_clear_isr_stats(struct iwl_priv *priv);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index f2b38d9..037b75c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -439,7 +439,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	if (sscanf(buf, "%d", &event_log_flag) != 1)
 		return -EFAULT;
 	if (event_log_flag == 1)
-		iwl_dump_nic_event_log(priv);
+		priv->cfg->ops->lib->dump_nic_event_log(priv);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c92db01..4a4af0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1481,6 +1481,7 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 static const char *desc_lookup(int i)
 {
 	switch (i) {
@@ -1504,7 +1505,7 @@ static const char *desc_lookup(int i)
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
 #define ERROR_ELEM_SIZE     (7 * sizeof(u32))
 
-static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
+void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 {
 	u32 i;
 	u32 desc, time, count, base, data1;
@@ -1598,7 +1599,7 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	}
 }
 
-static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
+void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 {
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
@@ -1640,6 +1641,16 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	iwl3945_print_event_log(priv, 0, next_entry, mode);
 
 }
+#else
+void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
+{
+}
+
+void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
+{
+}
+
+#endif
 
 static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 {
@@ -3683,21 +3694,6 @@ static ssize_t dump_error_log(struct device *d,
 
 static DEVICE_ATTR(dump_errors, S_IWUSR, NULL, dump_error_log);
 
-static ssize_t dump_event_log(struct device *d,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	char *p = (char *)buf;
-
-	if (p[0] == '1')
-		iwl3945_dump_nic_event_log(priv);
-
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(dump_events, S_IWUSR, NULL, dump_event_log);
-
 /*****************************************************************************
  *
  * driver setup and tear down
@@ -3742,7 +3738,6 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 	&dev_attr_antenna.attr,
 	&dev_attr_channels.attr,
 	&dev_attr_dump_errors.attr,
-	&dev_attr_dump_events.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-- 
1.5.6.3

