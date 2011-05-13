Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab1EMTio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/13] iwlagn: more ucode error log info
Date: Fri, 13 May 2011 12:13:22 -0700
Message-Id: <1305314010-18073-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213855_597463_6B136A71)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes, just logging more information when uCode crash, also
change change the format.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   62 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   41 ++++++++++++++----
 2 files changed, 63 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 675b9a6..a7054a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1622,10 +1622,7 @@ static const char *desc_lookup(u32 num)
 
 void iwl_dump_nic_error_log(struct iwl_priv *priv)
 {
-	u32 data2, line;
-	u32 desc, time, count, base, data1;
-	u32 blink1, blink2, ilink1, ilink2;
-	u32 pc, hcmd;
+	u32 base;
 	struct iwl_error_event_table table;
 
 	base = priv->device_pointers.error_event_table;
@@ -1648,37 +1645,40 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 
 	iwl_read_targ_mem_words(priv, base, &table, sizeof(table));
 
-	count = table.valid;
-
-	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
+	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
 		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
-			priv->status, count);
-	}
-
-	desc = table.error_id;
-	priv->isr_stats.err_code = desc;
-	pc = table.pc;
-	blink1 = table.blink1;
-	blink2 = table.blink2;
-	ilink1 = table.ilink1;
-	ilink2 = table.ilink2;
-	data1 = table.data1;
-	data2 = table.data2;
-	line = table.line;
-	time = table.tsf_low;
-	hcmd = table.hcmd;
-
-	trace_iwlwifi_dev_ucode_error(priv, desc, time, data1, data2, line,
-				      blink1, blink2, ilink1, ilink2);
-
-	IWL_ERR(priv, "Desc                                  Time       "
-		"data1      data2      line\n");
-	IWL_ERR(priv, "%-28s (0x%04X) %010u 0x%08X 0x%08X %u\n",
-		desc_lookup(desc), desc, time, data1, data2, line);
-	IWL_ERR(priv, "pc      blink1  blink2  ilink1  ilink2  hcmd\n");
-	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X 0x%05X 0x%05X\n",
-		pc, blink1, blink2, ilink1, ilink2, hcmd);
+			priv->status, table.valid);
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
 }
 
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index fc13186..2c84ba9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -209,15 +209,18 @@ TRACE_EVENT(iwlwifi_dev_tx,
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_error,
-	TP_PROTO(struct iwl_priv *priv, u32 desc, u32 time,
+	TP_PROTO(struct iwl_priv *priv, u32 desc, u32 tsf_low,
 		 u32 data1, u32 data2, u32 line, u32 blink1,
-		 u32 blink2, u32 ilink1, u32 ilink2),
-	TP_ARGS(priv, desc, time, data1, data2, line,
-		blink1, blink2, ilink1, ilink2),
+		 u32 blink2, u32 ilink1, u32 ilink2, u32 bcon_time,
+		 u32 gp1, u32 gp2, u32 gp3, u32 ucode_ver, u32 hw_ver,
+		 u32 brd_ver),
+	TP_ARGS(priv, desc, tsf_low, data1, data2, line,
+		blink1, blink2, ilink1, ilink2, bcon_time, gp1, gp2,
+		gp3, ucode_ver, hw_ver, brd_ver),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
 		__field(u32, desc)
-		__field(u32, time)
+		__field(u32, tsf_low)
 		__field(u32, data1)
 		__field(u32, data2)
 		__field(u32, line)
@@ -225,11 +228,18 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 		__field(u32, blink2)
 		__field(u32, ilink1)
 		__field(u32, ilink2)
+		__field(u32, bcon_time)
+		__field(u32, gp1)
+		__field(u32, gp2)
+		__field(u32, gp3)
+		__field(u32, ucode_ver)
+		__field(u32, hw_ver)
+		__field(u32, brd_ver)
 	),
 	TP_fast_assign(
 		PRIV_ASSIGN;
 		__entry->desc = desc;
-		__entry->time = time;
+		__entry->tsf_low = tsf_low;
 		__entry->data1 = data1;
 		__entry->data2 = data2;
 		__entry->line = line;
@@ -237,12 +247,25 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 		__entry->blink2 = blink2;
 		__entry->ilink1 = ilink1;
 		__entry->ilink2 = ilink2;
+		__entry->bcon_time = bcon_time;
+		__entry->gp1 = gp1;
+		__entry->gp2 = gp2;
+		__entry->gp3 = gp3;
+		__entry->ucode_ver = ucode_ver;
+		__entry->hw_ver = hw_ver;
+		__entry->brd_ver = brd_ver;
 	),
 	TP_printk("[%p] #%02d %010u data 0x%08X 0x%08X line %u, "
-		  "blink 0x%05X 0x%05X ilink 0x%05X 0x%05X",
-		  __entry->priv, __entry->desc, __entry->time, __entry->data1,
+		  "blink 0x%05X 0x%05X ilink 0x%05X 0x%05X "
+		  "bcon_tm %010u gp 0x%08X 0x%08X 0x%08X uCode 0x%08X "
+		  "hw 0x%08X brd 0x%08X",
+		  __entry->priv, __entry->desc, __entry->tsf_low,
+		  __entry->data1,
 		  __entry->data2, __entry->line, __entry->blink1,
-		  __entry->blink2, __entry->ilink1, __entry->ilink2)
+		  __entry->blink2, __entry->ilink1, __entry->ilink2,
+		  __entry->bcon_time, __entry->gp1, __entry->gp2,
+		  __entry->gp3, __entry->ucode_ver, __entry->hw_ver,
+		  __entry->brd_ver)
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_event,
-- 
1.7.0.4

