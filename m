Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab1HMSSz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 37/60] iwlagn: remove references to priv from the transport layer
Date: Sat, 13 Aug 2011 10:38:13 -0700
Message-Id: <1313257116-2697-38-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201900_389421_7EDBB932)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Continue to the clean up of the priv dereferencing from the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    7 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  124 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |    4 +-
 5 files changed, 70 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 65117e6..14f72dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1403,7 +1403,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	/*TODO: this should go to the transport layer */
-	iwl_reset_ict(priv);
+	iwl_reset_ict(trans(priv));
 
 	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index c30299d..3508c12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -111,7 +111,7 @@ extern struct iwl_cfg iwl135_bgn_cfg;
 
 extern struct ieee80211_ops iwlagn_hw_ops;
 
-int iwl_reset_ict(struct iwl_priv *priv);
+int iwl_reset_ict(struct iwl_trans *trans);
 
 static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 0e4efb0..59c6b3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -130,7 +130,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 /*****************************************************
 * ICT
 ******************************************************/
-int iwl_reset_ict(struct iwl_priv *priv);
+int iwl_reset_ict(struct iwl_trans *trans);
 void iwl_disable_ict(struct iwl_trans *trans);
 int iwl_alloc_isr_ict(struct iwl_trans *trans);
 void iwl_free_isr_ict(struct iwl_trans *trans);
@@ -167,12 +167,11 @@ void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 /*****************************************************
 * Error handling
 ******************************************************/
-int iwl_dump_nic_event_log(struct iwl_priv *priv,
-			   bool full_log, char **buf, bool display);
+int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
+			    char **buf, bool display);
 int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
 void iwl_dump_csr(struct iwl_trans *trans);
 
-
 static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 {
 	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 0b6c527..7f8ac2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -565,11 +565,11 @@ static const char *desc_lookup(u32 num)
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
 #define ERROR_ELEM_SIZE     (7 * sizeof(u32))
 
-static void iwl_dump_nic_error_log(struct iwl_priv *priv)
+static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 {
 	u32 base;
 	struct iwl_error_event_table table;
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -583,7 +583,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv,
+		IWL_ERR(trans,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
 			(priv->ucode_type == IWL_UCODE_INIT)
@@ -594,9 +594,9 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	iwl_read_targ_mem_words(priv, base, &table, sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
-		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
-		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
-			priv->shrd->status, table.valid);
+		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
+		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
+			trans->shrd->status, table.valid);
 	}
 
 	trans_pcie->isr_stats.err_code = table.error_id;
@@ -607,33 +607,34 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 				      table.ilink2, table.bcon_time, table.gp1,
 				      table.gp2, table.gp3, table.ucode_ver,
 				      table.hw_ver, table.brd_ver);
-	IWL_ERR(priv, "0x%08X | %-28s\n", table.error_id,
+	IWL_ERR(trans, "0x%08X | %-28s\n", table.error_id,
 		desc_lookup(table.error_id));
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
+	IWL_ERR(trans, "0x%08X | uPc\n", table.pc);
+	IWL_ERR(trans, "0x%08X | branchlink1\n", table.blink1);
+	IWL_ERR(trans, "0x%08X | branchlink2\n", table.blink2);
+	IWL_ERR(trans, "0x%08X | interruptlink1\n", table.ilink1);
+	IWL_ERR(trans, "0x%08X | interruptlink2\n", table.ilink2);
+	IWL_ERR(trans, "0x%08X | data1\n", table.data1);
+	IWL_ERR(trans, "0x%08X | data2\n", table.data2);
+	IWL_ERR(trans, "0x%08X | line\n", table.line);
+	IWL_ERR(trans, "0x%08X | beacon time\n", table.bcon_time);
+	IWL_ERR(trans, "0x%08X | tsf low\n", table.tsf_low);
+	IWL_ERR(trans, "0x%08X | tsf hi\n", table.tsf_hi);
+	IWL_ERR(trans, "0x%08X | time gp1\n", table.gp1);
+	IWL_ERR(trans, "0x%08X | time gp2\n", table.gp2);
+	IWL_ERR(trans, "0x%08X | time gp3\n", table.gp3);
+	IWL_ERR(trans, "0x%08X | uCode version\n", table.ucode_ver);
+	IWL_ERR(trans, "0x%08X | hw version\n", table.hw_ver);
+	IWL_ERR(trans, "0x%08X | board version\n", table.brd_ver);
+	IWL_ERR(trans, "0x%08X | hcmd\n", table.hcmd);
 }
 
 /**
  * iwl_irq_handle_error - called for HW or SW error interrupt from card
  */
-static void iwl_irq_handle_error(struct iwl_priv *priv)
+static void iwl_irq_handle_error(struct iwl_trans *trans)
 {
+	struct iwl_priv *priv = priv(trans);
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (priv->cfg->internal_wimax_coex &&
 	    (!(iwl_read_prph(priv, APMG_CLK_CTRL_REG) &
@@ -644,22 +645,22 @@ static void iwl_irq_handle_error(struct iwl_priv *priv)
 		 * Keep the restart process from trying to send host
 		 * commands by clearing the ready bit.
 		 */
-		clear_bit(STATUS_READY, &priv->shrd->status);
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
+		clear_bit(STATUS_READY, &trans->shrd->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 		wake_up_interruptible(&priv->wait_command_queue);
-		IWL_ERR(priv, "RF is used by WiMAX\n");
+		IWL_ERR(trans, "RF is used by WiMAX\n");
 		return;
 	}
 
-	IWL_ERR(priv, "Loaded firmware version: %s\n",
+	IWL_ERR(trans, "Loaded firmware version: %s\n",
 		priv->hw->wiphy->fw_version);
 
-	iwl_dump_nic_error_log(priv);
-	iwl_dump_csr(trans(priv));
-	iwl_dump_fh(trans(priv), NULL, false);
-	iwl_dump_nic_event_log(priv, false, NULL, false);
+	iwl_dump_nic_error_log(trans);
+	iwl_dump_csr(trans);
+	iwl_dump_fh(trans, NULL, false);
+	iwl_dump_nic_event_log(trans, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS)
+	if (iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS)
 		iwl_print_rx_config_cmd(priv,
 					&priv->contexts[IWL_RXON_CTX_BSS]);
 #endif
@@ -673,7 +674,7 @@ static void iwl_irq_handle_error(struct iwl_priv *priv)
  * iwl_print_event_log - Dump error event log to syslog
  *
  */
-static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
+static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 			       u32 num_events, u32 mode,
 			       int pos, char **buf, size_t bufsz)
 {
@@ -683,6 +684,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	u32 ptr;        /* SRAM byte address of log data */
 	u32 ev, time, data; /* event log data */
 	unsigned long reg_flags;
+	struct iwl_priv *priv = priv(trans);
 
 	if (num_events == 0)
 		return pos;
@@ -725,7 +727,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 			} else {
 				trace_iwlwifi_dev_ucode_event(priv, 0,
 					time, ev);
-				IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n",
+				IWL_ERR(trans, "EVT_LOG:0x%08x:%04u\n",
 					time, ev);
 			}
 		} else {
@@ -735,7 +737,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 						"EVT_LOGT:%010u:0x%08x:%04u\n",
 						 time, data, ev);
 			} else {
-				IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
+				IWL_ERR(trans, "EVT_LOGT:%010u:0x%08x:%04u\n",
 					time, data, ev);
 				trace_iwlwifi_dev_ucode_event(priv, time,
 					data, ev);
@@ -752,7 +754,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 /**
  * iwl_print_last_event_logs - Dump the newest # of event log to syslog
  */
-static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
+static int iwl_print_last_event_logs(struct iwl_trans *trans, u32 capacity,
 				    u32 num_wraps, u32 next_entry,
 				    u32 size, u32 mode,
 				    int pos, char **buf, size_t bufsz)
@@ -763,22 +765,22 @@ static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 	 */
 	if (num_wraps) {
 		if (next_entry < size) {
-			pos = iwl_print_event_log(priv,
+			pos = iwl_print_event_log(trans,
 						capacity - (size - next_entry),
 						size - next_entry, mode,
 						pos, buf, bufsz);
-			pos = iwl_print_event_log(priv, 0,
+			pos = iwl_print_event_log(trans, 0,
 						  next_entry, mode,
 						  pos, buf, bufsz);
 		} else
-			pos = iwl_print_event_log(priv, next_entry - size,
+			pos = iwl_print_event_log(trans, next_entry - size,
 						  size, mode, pos, buf, bufsz);
 	} else {
 		if (next_entry < size) {
-			pos = iwl_print_event_log(priv, 0, next_entry,
+			pos = iwl_print_event_log(trans, 0, next_entry,
 						  mode, pos, buf, bufsz);
 		} else {
-			pos = iwl_print_event_log(priv, next_entry - size,
+			pos = iwl_print_event_log(trans, next_entry - size,
 						  size, mode, pos, buf, bufsz);
 		}
 	}
@@ -787,7 +789,7 @@ static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 
 #define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
 
-int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
+int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 			    char **buf, bool display)
 {
 	u32 base;       /* SRAM byte address of event log header */
@@ -799,6 +801,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	u32 logsize;
 	int pos = 0;
 	size_t bufsz = 0;
+	struct iwl_priv *priv = priv(trans);
 
 	base = priv->device_pointers.log_event_table;
 	if (priv->ucode_type == IWL_UCODE_INIT) {
@@ -812,7 +815,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv,
+		IWL_ERR(trans,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base,
 			(priv->ucode_type == IWL_UCODE_INIT)
@@ -827,13 +830,13 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
 	if (capacity > logsize) {
-		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
-			capacity, logsize);
+		IWL_ERR(trans, "Log capacity %d is bogus, limit to %d "
+			"entries\n", capacity, logsize);
 		capacity = logsize;
 	}
 
 	if (next_entry > logsize) {
-		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
+		IWL_ERR(trans, "Log write index %d is bogus, limit to %d\n",
 			next_entry, logsize);
 		next_entry = logsize;
 	}
@@ -842,7 +845,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 
 	/* bail out if nothing in log */
 	if (size == 0) {
-		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
+		IWL_ERR(trans, "Start IWL Event Log Dump: nothing in log\n");
 		return pos;
 	}
 
@@ -850,14 +853,14 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) && !full_log)
+	if (!(iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) && !full_log)
 		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
 			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
 #else
 	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
 		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
 #endif
-	IWL_ERR(priv, "Start IWL Event Log Dump: display last %u entries\n",
+	IWL_ERR(trans, "Start IWL Event Log Dump: display last %u entries\n",
 		size);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -870,25 +873,25 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		if (!*buf)
 			return -ENOMEM;
 	}
-	if ((iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) || full_log) {
+	if ((iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) || full_log) {
 		/*
 		 * if uCode has wrapped back to top of log,
 		 * start at the oldest entry,
 		 * i.e the next one that uCode would fill.
 		 */
 		if (num_wraps)
-			pos = iwl_print_event_log(priv, next_entry,
+			pos = iwl_print_event_log(trans, next_entry,
 						capacity - next_entry, mode,
 						pos, buf, bufsz);
 		/* (then/else) start at top of log */
-		pos = iwl_print_event_log(priv, 0,
+		pos = iwl_print_event_log(trans, 0,
 					  next_entry, mode, pos, buf, bufsz);
 	} else
-		pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
+		pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
 						next_entry, size, mode,
 						pos, buf, bufsz);
 #else
-	pos = iwl_print_last_event_logs(priv, capacity, num_wraps,
+	pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
 					next_entry, size, mode,
 					pos, buf, bufsz);
 #endif
@@ -951,7 +954,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		iwl_disable_interrupts(trans);
 
 		isr_stats->hw++;
-		iwl_irq_handle_error(priv(trans));
+		iwl_irq_handle_error(trans);
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
@@ -1020,7 +1023,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		IWL_ERR(trans, "Microcode SW error detected. "
 			" Restarting 0x%X.\n", inta);
 		isr_stats->sw++;
-		iwl_irq_handle_error(priv(trans));
+		iwl_irq_handle_error(trans);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
 
@@ -1188,11 +1191,10 @@ int iwl_alloc_isr_ict(struct iwl_trans *trans)
 /* Device is going up inform it about using ICT interrupt table,
  * also we need to tell the driver to start using ICT interrupt.
  */
-int iwl_reset_ict(struct iwl_priv *priv)
+int iwl_reset_ict(struct iwl_trans *trans)
 {
 	u32 val;
 	unsigned long flags;
-	struct iwl_trans *trans = trans(priv);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index e55636e..2ffacb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1528,7 +1528,7 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 	int pos = 0;
 	ssize_t ret = -ENOMEM;
 
-	ret = pos = iwl_dump_nic_event_log(priv(trans), true, &buf, true);
+	ret = pos = iwl_dump_nic_event_log(trans, true, &buf, true);
 	if (buf) {
 		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 		kfree(buf);
@@ -1552,7 +1552,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	if (sscanf(buf, "%d", &event_log_flag) != 1)
 		return -EFAULT;
 	if (event_log_flag == 1)
-		iwl_dump_nic_event_log(priv(trans), true, NULL, false);
+		iwl_dump_nic_event_log(trans, true, NULL, false);
 
 	return count;
 }
-- 
1.7.0.4

