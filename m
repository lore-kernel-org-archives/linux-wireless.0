Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab2BQUXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/26] iwlwifi: move event and err pointers to iwl_nic
Date: Fri, 17 Feb 2012 11:13:48 -0800
Message-Id: <1329506034-1394-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212401_801874_2A0C1719)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the ucode offset pointers to the iwl_nic as they are nic related.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    3 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   31 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |   16 +++++-----
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8a72940..494c696 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -863,9 +863,6 @@ struct iwl_priv {
 	struct iwl_rx_phy_res last_phy_res;
 	bool last_phy_res_valid;
 
-	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
-	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
-
 	/*
 	 * chain noise reset and gain commands are the
 	 * two extra calibration commands follows the standard
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index e063426..6715d04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -34,6 +34,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-trans-pcie-int.h"
+#include "iwl-wifi.h"
 
 #ifdef CONFIG_IWLWIFI_IDI
 #include "iwl-amfh.h"
@@ -589,17 +590,17 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 {
 	u32 base;
 	struct iwl_error_event_table table;
-	struct iwl_priv *priv = priv(trans);
+	struct iwl_nic *nic = nic(trans);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	base = trans->shrd->device_pointers.error_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
-			base = priv->init_errlog_ptr;
+			base = nic->init_errlog_ptr;
 	} else {
 		if (!base)
-			base = priv->inst_errlog_ptr;
+			base = nic->inst_errlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
@@ -611,7 +612,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 		return;
 	}
 
-	iwl_read_targ_mem_words(trans(priv), base, &table, sizeof(table));
+	iwl_read_targ_mem_words(trans, base, &table, sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
@@ -621,7 +622,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 
 	trans_pcie->isr_stats.err_code = table.error_id;
 
-	trace_iwlwifi_dev_ucode_error(priv, table.error_id, table.tsf_low,
+	trace_iwlwifi_dev_ucode_error(priv(nic), table.error_id, table.tsf_low,
 				      table.data1, table.data2, table.line,
 				      table.blink1, table.blink2, table.ilink1,
 				      table.ilink2, table.bcon_time, table.gp1,
@@ -718,7 +719,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	u32 ptr;        /* SRAM byte address of log data */
 	u32 ev, time, data; /* event log data */
 	unsigned long reg_flags;
-	struct iwl_priv *priv = priv(trans);
+	struct iwl_nic *nic = nic(trans);
 
 	if (num_events == 0)
 		return pos;
@@ -726,10 +727,10 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	base = trans->shrd->device_pointers.log_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
-			base = priv->init_evtlog_ptr;
+			base = nic->init_evtlog_ptr;
 	} else {
 		if (!base)
-			base = priv->inst_evtlog_ptr;
+			base = nic->inst_evtlog_ptr;
 	}
 
 	if (mode == 0)
@@ -759,7 +760,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 						"EVT_LOG:0x%08x:%04u\n",
 						time, ev);
 			} else {
-				trace_iwlwifi_dev_ucode_event(priv, 0,
+				trace_iwlwifi_dev_ucode_event(priv(trans), 0,
 					time, ev);
 				IWL_ERR(trans, "EVT_LOG:0x%08x:%04u\n",
 					time, ev);
@@ -773,7 +774,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 			} else {
 				IWL_ERR(trans, "EVT_LOGT:%010u:0x%08x:%04u\n",
 					time, data, ev);
-				trace_iwlwifi_dev_ucode_event(priv, time,
+				trace_iwlwifi_dev_ucode_event(priv(trans), time,
 					data, ev);
 			}
 		}
@@ -835,17 +836,17 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	u32 logsize;
 	int pos = 0;
 	size_t bufsz = 0;
-	struct iwl_priv *priv = priv(trans);
+	struct iwl_nic *nic = nic(trans);
 
 	base = trans->shrd->device_pointers.log_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
-		logsize = priv->init_evtlog_size;
+		logsize = nic->init_evtlog_size;
 		if (!base)
-			base = priv->init_evtlog_ptr;
+			base = nic->init_evtlog_ptr;
 	} else {
-		logsize = priv->inst_evtlog_size;
+		logsize = nic->inst_evtlog_size;
 		if (!base)
-			base = priv->inst_evtlog_ptr;
+			base = nic->inst_evtlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index a2695c2..0d04a4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -1205,20 +1205,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * for each event, which is of mode 1 (including timestamp) for all
 	 * new microcodes that include this information.
 	 */
-	priv->init_evtlog_ptr = pieces.init_evtlog_ptr;
+	nic->init_evtlog_ptr = pieces.init_evtlog_ptr;
 	if (pieces.init_evtlog_size)
-		priv->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
+		nic->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
 	else
-		priv->init_evtlog_size =
+		nic->init_evtlog_size =
 			cfg(priv)->base_params->max_event_log_size;
-	priv->init_errlog_ptr = pieces.init_errlog_ptr;
-	priv->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
+	nic->init_errlog_ptr = pieces.init_errlog_ptr;
+	nic->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
 	if (pieces.inst_evtlog_size)
-		priv->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
+		nic->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
 	else
-		priv->inst_evtlog_size =
+		nic->inst_evtlog_size =
 			cfg(priv)->base_params->max_event_log_size;
-	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
+	nic->inst_errlog_ptr = pieces.inst_errlog_ptr;
 #ifndef CONFIG_IWLWIFI_P2P
 	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 #endif
-- 
1.7.0.4

