Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2A1Rhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 12:37:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/4] iwlwifi: fix uCode event tracing
Date: Sat, 28 Jan 2012 08:30:50 -0800
Message-Id: <1327768252-22742-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120128_183742_940524_64D0C92A)
In-Reply-To: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix multiple bugs in event tracing:

1) If you enable uCode tracing with the device down,
   it will still attempt to access the device and
   continuously log "MAC is in deep sleep!" errors.
   Fix this by only starting logging when the device
   is actually alive.

2) Now you can set the flag when the device is down,
   but logging doesn't happen when you bring it up.
   To fix that, start logging when the device comes
   alive. This means we don't log before -- we could
   do that but I don't need it right now.

3) For some reason we read the error instead of the
   event log -- use the right pointer.

4) Optimise SRAM reading of event log header.

5) Fix reading write pointer == capacity, which can
   happen due to racy SRAM access

6) Most importantly: fix an error where we would try
   to read WAY too many events (like 2^32-300) when
   we read the wrap counter before it is updated by
   the uCode -- this does happen in practice and will
   cause the driver to hang the machine.

7) Finally, change the timer to 10ms instead of 100ms
   as 100ms is too slow to capture all data with a
   normal event log and with 100ms the log will wrap
   multiple times before we have a chance to read it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   99 ++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 +-
 3 files changed, 76 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7321e7d..3e429a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -315,7 +315,7 @@ static void iwl_bg_statistics_periodic(unsigned long data)
 
 static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 					u32 start_idx, u32 num_events,
-					u32 mode)
+					u32 capacity, u32 mode)
 {
 	u32 i;
 	u32 ptr;        /* SRAM byte address of log data */
@@ -339,6 +339,15 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 	rmb();
 
 	/*
+	 * Refuse to read more than would have fit into the log from
+	 * the current start_idx. This used to happen due to the race
+	 * described below, but now WARN because the code below should
+	 * prevent it from happening here.
+	 */
+	if (WARN_ON(num_events > capacity - start_idx))
+		num_events = capacity - start_idx;
+
+	/*
 	 * "time" is actually "data" for mode 0 (no timestamp).
 	 * place event id # at far right for easier visual parsing.
 	 */
@@ -346,12 +355,11 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		ev = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 		time = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
-			trace_iwlwifi_dev_ucode_cont_event(priv,
-							0, time, ev);
+			trace_iwlwifi_dev_ucode_cont_event(priv, 0, time, ev);
 		} else {
 			data = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
-			trace_iwlwifi_dev_ucode_cont_event(priv,
-						time, data, ev);
+			trace_iwlwifi_dev_ucode_cont_event(priv, time,
+							   data, ev);
 		}
 	}
 	/* Allow device to power down */
@@ -362,53 +370,83 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 static void iwl_continuous_event_trace(struct iwl_priv *priv)
 {
 	u32 capacity;   /* event log capacity in # entries */
+	struct {
+		u32 capacity;
+		u32 mode;
+		u32 wrap_counter;
+		u32 write_counter;
+	} __packed read;
 	u32 base;       /* SRAM byte address of event log header */
 	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
 	u32 num_wraps;  /* # times uCode wrapped to top of log */
 	u32 next_entry; /* index of next entry to be written by uCode */
 
-	base = priv->shrd->device_pointers.error_event_table;
+	base = priv->shrd->device_pointers.log_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		capacity = iwl_read_targ_mem(bus(priv), base);
-		num_wraps = iwl_read_targ_mem(bus(priv),
-						base + (2 * sizeof(u32)));
-		mode = iwl_read_targ_mem(bus(priv), base + (1 * sizeof(u32)));
-		next_entry = iwl_read_targ_mem(bus(priv),
-						base + (3 * sizeof(u32)));
+		iwl_read_targ_mem_words(bus(priv), base, &read, sizeof(read));
+
+		capacity = read.capacity;
+		mode = read.mode;
+		num_wraps = read.wrap_counter;
+		next_entry = read.write_counter;
 	} else
 		return;
 
+	/*
+	 * Unfortunately, the uCode doesn't use temporary variables.
+	 * Therefore, it can happen that we read next_entry == capacity,
+	 * which really means next_entry == 0.
+	 */
+	if (unlikely(next_entry == capacity))
+		next_entry = 0;
+	/*
+	 * Additionally, the uCode increases the write pointer before
+	 * the wraps counter, so if the write pointer is smaller than
+	 * the old write pointer (wrap occurred) but we read that no
+	 * wrap occurred, we actually read between the next_entry and
+	 * num_wraps update (this does happen in practice!!) -- take
+	 * that into account by increasing num_wraps.
+	 */
+	if (unlikely(next_entry < priv->event_log.next_entry &&
+		     num_wraps == priv->event_log.num_wraps))
+		num_wraps++;
+
 	if (num_wraps == priv->event_log.num_wraps) {
-		iwl_print_cont_event_trace(priv,
-				       base, priv->event_log.next_entry,
-				       next_entry - priv->event_log.next_entry,
-				       mode);
+		iwl_print_cont_event_trace(
+			priv, base, priv->event_log.next_entry,
+			next_entry - priv->event_log.next_entry,
+			capacity, mode);
+
 		priv->event_log.non_wraps_count++;
 	} else {
-		if ((num_wraps - priv->event_log.num_wraps) > 1)
+		if (num_wraps - priv->event_log.num_wraps > 1)
 			priv->event_log.wraps_more_count++;
 		else
 			priv->event_log.wraps_once_count++;
+
 		trace_iwlwifi_dev_ucode_wrap_event(priv,
 				num_wraps - priv->event_log.num_wraps,
 				next_entry, priv->event_log.next_entry);
+
 		if (next_entry < priv->event_log.next_entry) {
-			iwl_print_cont_event_trace(priv, base,
-			       priv->event_log.next_entry,
-			       capacity - priv->event_log.next_entry,
-			       mode);
+			iwl_print_cont_event_trace(
+				priv, base, priv->event_log.next_entry,
+				capacity - priv->event_log.next_entry,
+				capacity, mode);
 
-			iwl_print_cont_event_trace(priv, base, 0,
-				next_entry, mode);
+			iwl_print_cont_event_trace(
+				priv, base, 0, next_entry, capacity, mode);
 		} else {
-			iwl_print_cont_event_trace(priv, base,
-			       next_entry, capacity - next_entry,
-			       mode);
+			iwl_print_cont_event_trace(
+				priv, base, next_entry,
+				capacity - next_entry,
+				capacity, mode);
 
-			iwl_print_cont_event_trace(priv, base, 0,
-				next_entry, mode);
+			iwl_print_cont_event_trace(
+				priv, base, 0, next_entry, capacity, mode);
 		}
 	}
+
 	priv->event_log.num_wraps = num_wraps;
 	priv->event_log.next_entry = next_entry;
 }
@@ -1219,6 +1257,11 @@ int iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_is_rfkill(priv->shrd))
 		return -ERFKILL;
 
+	if (priv->event_log.ucode_trace) {
+		/* start collecting data now */
+		mod_timer(&priv->ucode_trace, jiffies);
+	}
+
 	/* download priority table before any calibration request */
 	if (cfg(priv)->bt_params &&
 	    cfg(priv)->bt_params->advanced_bt_coexist) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index f837f32..978a1d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2131,9 +2131,10 @@ static ssize_t iwl_dbgfs_ucode_tracing_write(struct file *file,
 
 	if (trace) {
 		priv->event_log.ucode_trace = true;
-		/* schedule the ucode timer to occur in UCODE_TRACE_PERIOD */
-		mod_timer(&priv->ucode_trace,
-			jiffies + msecs_to_jiffies(UCODE_TRACE_PERIOD));
+		if (iwl_is_alive(priv->shrd)) {
+			/* start collecting data now */
+			mod_timer(&priv->ucode_trace, jiffies);
+		}
 	} else {
 		priv->event_log.ucode_trace = false;
 		del_timer_sync(&priv->ucode_trace);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4579d61..af84600 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -661,7 +661,7 @@ struct traffic_stats {
  * schedule the timer to wake up every UCODE_TRACE_PERIOD milliseconds
  * to perform continuous uCode event logging operation if enabled
  */
-#define UCODE_TRACE_PERIOD (100)
+#define UCODE_TRACE_PERIOD (10)
 
 /*
  * iwl_event_log: current uCode event log position
-- 
1.7.0.4

