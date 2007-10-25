Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbXJYJWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 15/30] iwlwifi: rename restricted_mem to targ_mem
Date: Thu, 25 Oct 2007 17:15:36 +0800
Message-Id: <1193303773185-git-send-email-yi.zhu@intel.com> (sfid-20071025_104102_645692_543CCCF1)
In-Reply-To: <11933037721573-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames restricted_mem suffix with more proper
name targ_mem for function accessing memory on the nic in target mode

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   19 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   18 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-io.h       |    9 +++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   30 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   34 +++++++++++++-------------
 5 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d761531..08b6917 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -94,7 +94,7 @@ const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
  *   ... and set IWL_EVT_DISABLE to 1. */
 void iwl_disable_events(struct iwl_priv *priv)
 {
-	int rc;
+	int ret;
 	int i;
 	u32 base;		/* SRAM address of event log header */
 	u32 disable_ptr;	/* SRAM address of event-disable bitmap array */
@@ -155,25 +155,24 @@ void iwl_disable_events(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
-	if (rc) {
+	ret = iwl_grab_restricted_access(priv);
+	if (ret) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
-	disable_ptr = iwl_read_restricted_mem(priv, base + (4 * sizeof(u32)));
-	array_size = iwl_read_restricted_mem(priv, base + (5 * sizeof(u32)));
+	disable_ptr = iwl_read_targ_mem(priv, base + (4 * sizeof(u32)));
+	array_size = iwl_read_targ_mem(priv, base + (5 * sizeof(u32)));
 	iwl_release_restricted_access(priv);
 
 	if (IWL_EVT_DISABLE && (array_size == IWL_EVT_DISABLE_SIZE)) {
 		IWL_DEBUG_INFO("Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
-		rc = iwl_grab_restricted_access(priv);
+		ret = iwl_grab_restricted_access(priv);
 		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++)
-			iwl_write_restricted_mem(priv,
-						 disable_ptr +
-						 (i * sizeof(u32)),
-						 evt_disable[i]);
+			iwl_write_targ_mem(priv,
+					   disable_ptr + (i * sizeof(u32)),
+					   evt_disable[i]);
 
 		iwl_release_restricted_access(priv);
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2d6fe6f..4d76102 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1656,11 +1656,11 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	priv->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + SCD_CONTEXT_DATA_OFFSET;
 	for (; a < priv->scd_base_addr + SCD_TX_STTS_BITMAP_OFFSET; a += 4)
-		iwl_write_restricted_mem(priv, a, 0);
+		iwl_write_targ_mem(priv, a, 0);
 	for (; a < priv->scd_base_addr + SCD_TRANSLATE_TBL_OFFSET; a += 4)
-		iwl_write_restricted_mem(priv, a, 0);
+		iwl_write_targ_mem(priv, a, 0);
 	for (; a < sizeof(u16) * priv->hw_setting.max_txq_num; a += 4)
-		iwl_write_restricted_mem(priv, a, 0);
+		iwl_write_targ_mem(priv, a, 0);
 
 	iwl_write_prph(priv, SCD_DRAM_BASE_ADDR,
 		(priv->hw_setting.shared_phys +
@@ -1671,12 +1671,12 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
 		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_restricted(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
-		iwl_write_restricted_mem(priv, priv->scd_base_addr +
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i),
 					(SCD_WIN_SIZE <<
 					SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
 					SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
-		iwl_write_restricted_mem(priv, priv->scd_base_addr +
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i) +
 					sizeof(u32),
 					(SCD_FRAME_LIMIT <<
@@ -4146,14 +4146,14 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	tbl_dw_addr = priv->scd_base_addr +
 			SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
 
-	tbl_dw = iwl_read_restricted_mem(priv, tbl_dw_addr);
+	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
 
 	if (txq_id & 0x1)
 		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
 	else
 		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
 
-	iwl_write_restricted_mem(priv, tbl_dw_addr, tbl_dw);
+	iwl_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
 
 	return 0;
 }
@@ -4197,12 +4197,12 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl_write_restricted_mem(priv,
+	iwl_write_targ_mem(priv,
 			priv->scd_base_addr + SCD_CONTEXT_QUEUE_OFFSET(txq_id),
 			(SCD_WIN_SIZE << SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
 			SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
-	iwl_write_restricted_mem(priv, priv->scd_base_addr +
+	iwl_write_targ_mem(priv, priv->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
 			(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
 			& SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index b78afed..5cdcfc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -411,21 +411,20 @@ static inline void iwl_clear_bits_prph(struct iwl_priv
 	_iwl_write_prph(priv, reg, (val & ~mask));
 }
 
-static inline u32 iwl_read_restricted_mem(struct iwl_priv *priv, u32 addr)
+static inline u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
 {
 	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, addr);
 	return iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
 }
 
-static inline void iwl_write_restricted_mem(struct iwl_priv *priv, u32 addr,
-					    u32 val)
+static inline void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
 {
 	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
 	iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
-static inline void iwl_write_restricted_mems(struct iwl_priv *priv, u32 addr,
-					     u32 len, u32 *values)
+static inline void iwl_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
+					  u32 len, u32 *values)
 {
 	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
 	for (; 0 < len; len -= sizeof(u32), values++)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 79e5417..28fe9cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4445,7 +4445,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	count = iwl_read_restricted_mem(priv, base);
+	count = iwl_read_targ_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERROR("Start IWL Error Log Dump:\n");
@@ -4458,19 +4458,19 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	for (i = ERROR_START_OFFSET;
 	     i < (count * ERROR_ELEM_SIZE) + ERROR_START_OFFSET;
 	     i += ERROR_ELEM_SIZE) {
-		desc = iwl_read_restricted_mem(priv, base + i);
+		desc = iwl_read_targ_mem(priv, base + i);
 		time =
-		    iwl_read_restricted_mem(priv, base + i + 1 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 1 * sizeof(u32));
 		blink1 =
-		    iwl_read_restricted_mem(priv, base + i + 2 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 2 * sizeof(u32));
 		blink2 =
-		    iwl_read_restricted_mem(priv, base + i + 3 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 3 * sizeof(u32));
 		ilink1 =
-		    iwl_read_restricted_mem(priv, base + i + 4 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 4 * sizeof(u32));
 		ilink2 =
-		    iwl_read_restricted_mem(priv, base + i + 5 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 5 * sizeof(u32));
 		data1 =
-		    iwl_read_restricted_mem(priv, base + i + 6 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 6 * sizeof(u32));
 
 		IWL_ERROR
 		    ("%-13s (#%d) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
@@ -4513,14 +4513,14 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	 * place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read_restricted_mem(priv, ptr);
+		ev = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
-		time = iwl_read_restricted_mem(priv, ptr);
+		time = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
 		if (mode == 0)
 			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
 		else {
-			data = iwl_read_restricted_mem(priv, ptr);
+			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
 		}
@@ -4550,10 +4550,10 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	}
 
 	/* event log header */
-	capacity = iwl_read_restricted_mem(priv, base);
-	mode = iwl_read_restricted_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_restricted_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_restricted_mem(priv, base + (3 * sizeof(u32)));
+	capacity = iwl_read_targ_mem(priv, base);
+	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
 	size = num_wraps ? capacity : next_entry;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index b702dd4..0541f71 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4774,7 +4774,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	count = iwl_read_restricted_mem(priv, base);
+	count = iwl_read_targ_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERROR("Start IWL Error Log Dump:\n");
@@ -4782,15 +4782,15 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 			  priv->status, priv->config, count);
 	}
 
-	desc = iwl_read_restricted_mem(priv, base + 1 * sizeof(u32));
-	blink1 = iwl_read_restricted_mem(priv, base + 3 * sizeof(u32));
-	blink2 = iwl_read_restricted_mem(priv, base + 4 * sizeof(u32));
-	ilink1 = iwl_read_restricted_mem(priv, base + 5 * sizeof(u32));
-	ilink2 = iwl_read_restricted_mem(priv, base + 6 * sizeof(u32));
-	data1 = iwl_read_restricted_mem(priv, base + 7 * sizeof(u32));
-	data2 = iwl_read_restricted_mem(priv, base + 8 * sizeof(u32));
-	line = iwl_read_restricted_mem(priv, base + 9 * sizeof(u32));
-	time = iwl_read_restricted_mem(priv, base + 11 * sizeof(u32));
+	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
+	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
+	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
+	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
+	ilink2 = iwl_read_targ_mem(priv, base + 6 * sizeof(u32));
+	data1 = iwl_read_targ_mem(priv, base + 7 * sizeof(u32));
+	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
+	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
+	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
 
 	IWL_ERROR("Desc               Time       "
 		  "data1      data2      line\n");
@@ -4834,14 +4834,14 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	 * place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read_restricted_mem(priv, ptr);
+		ev = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
-		time = iwl_read_restricted_mem(priv, ptr);
+		time = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
 		if (mode == 0)
 			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
 		else {
-			data = iwl_read_restricted_mem(priv, ptr);
+			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
 		}
@@ -4871,10 +4871,10 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	}
 
 	/* event log header */
-	capacity = iwl_read_restricted_mem(priv, base);
-	mode = iwl_read_restricted_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_restricted_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_restricted_mem(priv, base + (3 * sizeof(u32)));
+	capacity = iwl_read_targ_mem(priv, base);
+	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
 	size = num_wraps ? capacity : next_entry;
 
-- 
1.5.2
