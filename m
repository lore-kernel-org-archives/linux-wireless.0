Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZGNNss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 09:48:48 -0400
Subject: [PATCH] iwlwifi: make some logging functions static/unexport
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 15:48:11 +0200
Message-Id: <1247579291.7178.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_dump_nic_error_log can be static and iwl_dump_nic_event_log
doesn't need to be exported.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Good and easy janitors task would be to find all these possibilities,
I'm convinced there are many especially after seeing people export
functions that are linked into the same modules :)

 drivers/net/wireless/iwlwifi/iwl-core.c |  367 +++++++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 
 2 files changed, 182 insertions(+), 186 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-07-14 15:43:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-07-14 15:43:13.000000000 +0200
@@ -1290,6 +1290,188 @@ static void iwl_print_rx_config_cmd(stru
 }
 #endif
 
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
+static void iwl_dump_nic_error_log(struct iwl_priv *priv)
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
 /**
  * iwl_irq_handle_error - called for HW or SW error interrupt from card
  */
@@ -2040,191 +2222,6 @@ int iwl_verify_ucode(struct iwl_priv *pr
 EXPORT_SYMBOL(iwl_verify_ucode);
 
 
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
-void iwl_dump_nic_error_log(struct iwl_priv *priv)
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
-EXPORT_SYMBOL(iwl_dump_nic_error_log);
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
-EXPORT_SYMBOL(iwl_dump_nic_event_log);
-
 void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2009-07-14 15:47:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2009-07-14 15:47:15.000000000 +0200
@@ -472,7 +472,6 @@ int iwl_pci_resume(struct pci_dev *pdev)
 /*****************************************************
 *  Error Handling Debugging
 ******************************************************/
-void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
 void iwl_clear_isr_stats(struct iwl_priv *priv);
 


