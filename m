Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031446Ab2CFWne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 13/33] iwlwifi: make tracing use device as identifier
Date: Tue,  6 Mar 2012 13:30:48 -0800
Message-Id: <1331069468-11074-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234422_493728_BC51BE00)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Tracing used the priv pointer as an identifier,
which has the problem that we don't have it in
all code, and also some people say no pointers
should be "leaked" to userspace.

Use the device name instead, it is more useful
anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    9 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h      |  141 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-io.h            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    2 +-
 6 files changed, 90 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f816371..2765700 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -353,11 +353,12 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		ev = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 		time = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
-			trace_iwlwifi_dev_ucode_cont_event(priv, 0, time, ev);
+			trace_iwlwifi_dev_ucode_cont_event(
+					trans(priv)->dev, 0, time, ev);
 		} else {
 			data = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
-			trace_iwlwifi_dev_ucode_cont_event(priv, time,
-							   data, ev);
+			trace_iwlwifi_dev_ucode_cont_event(
+					trans(priv)->dev, time, data, ev);
 		}
 	}
 	/* Allow device to power down */
@@ -422,7 +423,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 		else
 			priv->event_log.wraps_once_count++;
 
-		trace_iwlwifi_dev_ucode_wrap_event(priv,
+		trace_iwlwifi_dev_ucode_wrap_event(trans(priv)->dev,
 				num_wraps - priv->event_log.num_wraps,
 				next_entry, priv->event_log.next_entry);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 96e6233..06203d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -41,130 +41,134 @@ static inline void trace_ ## name(proto) {}
 static inline void trace_ ## name(proto) {}
 #endif
 
-#define PRIV_ENTRY	__field(void *, priv)
-#define PRIV_ASSIGN	__entry->priv = priv
+#define DEV_ENTRY	__string(dev, dev_name(dev))
+#define DEV_ASSIGN	__assign_str(dev, dev_name(dev))
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_io
 
 TRACE_EVENT(iwlwifi_dev_ioread32,
-	TP_PROTO(void *priv, u32 offs, u32 val),
-	TP_ARGS(priv, offs, val),
+	TP_PROTO(const struct device *dev, u32 offs, u32 val),
+	TP_ARGS(dev, offs, val),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 		__field(u32, offs)
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->offs = offs;
 		__entry->val = val;
 	),
-	TP_printk("[%p] read io[%#x] = %#x", __entry->priv, __entry->offs, __entry->val)
+	TP_printk("[%s] read io[%#x] = %#x",
+		  __get_str(dev), __entry->offs, __entry->val)
 );
 
 TRACE_EVENT(iwlwifi_dev_iowrite8,
-	TP_PROTO(void *priv, u32 offs, u8 val),
-	TP_ARGS(priv, offs, val),
+	TP_PROTO(const struct device *dev, u32 offs, u8 val),
+	TP_ARGS(dev, offs, val),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 		__field(u32, offs)
 		__field(u8, val)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->offs = offs;
 		__entry->val = val;
 	),
-	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
+	TP_printk("[%s] write io[%#x] = %#x)",
+		  __get_str(dev), __entry->offs, __entry->val)
 );
 
 TRACE_EVENT(iwlwifi_dev_iowrite32,
-	TP_PROTO(void *priv, u32 offs, u32 val),
-	TP_ARGS(priv, offs, val),
+	TP_PROTO(const struct device *dev, u32 offs, u32 val),
+	TP_ARGS(dev, offs, val),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 		__field(u32, offs)
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->offs = offs;
 		__entry->val = val;
 	),
-	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
+	TP_printk("[%s] write io[%#x] = %#x)",
+		  __get_str(dev), __entry->offs, __entry->val)
 );
 
 TRACE_EVENT(iwlwifi_dev_irq,
-	TP_PROTO(void *priv),
-	TP_ARGS(priv),
+	TP_PROTO(const struct device *dev),
+	TP_ARGS(dev),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 	),
 	/* TP_printk("") doesn't compile */
 	TP_printk("%d", 0)
 );
 
 TRACE_EVENT(iwlwifi_dev_ict_read,
-	TP_PROTO(void *priv, u32 index, u32 value),
-	TP_ARGS(priv, index, value),
+	TP_PROTO(const struct device *dev, u32 index, u32 value),
+	TP_ARGS(dev, index, value),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 		__field(u32, index)
 		__field(u32, value)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->index = index;
 		__entry->value = value;
 	),
-	TP_printk("read ict[%d] = %#.8x", __entry->index, __entry->value)
+	TP_printk("[%s] read ict[%d] = %#.8x",
+		  __get_str(dev), __entry->index, __entry->value)
 );
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_ucode
 
 TRACE_EVENT(iwlwifi_dev_ucode_cont_event,
-	TP_PROTO(void *priv, u32 time, u32 data, u32 ev),
-	TP_ARGS(priv, time, data, ev),
+	TP_PROTO(const struct device *dev, u32 time, u32 data, u32 ev),
+	TP_ARGS(dev, time, data, ev),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 
 		__field(u32, time)
 		__field(u32, data)
 		__field(u32, ev)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->time = time;
 		__entry->data = data;
 		__entry->ev = ev;
 	),
-	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
-		  __entry->priv, __entry->time, __entry->data, __entry->ev)
+	TP_printk("[%s] EVT_LOGT:%010u:0x%08x:%04u",
+		  __get_str(dev), __entry->time, __entry->data, __entry->ev)
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
-	TP_PROTO(void *priv, u32 wraps, u32 n_entry, u32 p_entry),
-	TP_ARGS(priv, wraps, n_entry, p_entry),
+	TP_PROTO(const struct device *dev, u32 wraps, u32 n_entry, u32 p_entry),
+	TP_ARGS(dev, wraps, n_entry, p_entry),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 
 		__field(u32, wraps)
 		__field(u32, n_entry)
 		__field(u32, p_entry)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->wraps = wraps;
 		__entry->n_entry = n_entry;
 		__entry->p_entry = p_entry;
 	),
-	TP_printk("[%p] wraps=#%02d n=0x%X p=0x%X",
-		  __entry->priv, __entry->wraps, __entry->n_entry,
+	TP_printk("[%s] wraps=#%02d n=0x%X p=0x%X",
+		  __get_str(dev), __entry->wraps, __entry->n_entry,
 		  __entry->p_entry)
 );
 
@@ -232,52 +236,52 @@ TRACE_EVENT(iwlwifi_dbg,
 #define TRACE_SYSTEM iwlwifi
 
 TRACE_EVENT(iwlwifi_dev_hcmd,
-	TP_PROTO(void *priv, u32 flags,
+	TP_PROTO(const struct device *dev, u32 flags,
 		 const void *hcmd0, size_t len0,
 		 const void *hcmd1, size_t len1,
 		 const void *hcmd2, size_t len2),
-	TP_ARGS(priv, flags, hcmd0, len0, hcmd1, len1, hcmd2, len2),
+	TP_ARGS(dev, flags, hcmd0, len0, hcmd1, len1, hcmd2, len2),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 		__dynamic_array(u8, hcmd0, len0)
 		__dynamic_array(u8, hcmd1, len1)
 		__dynamic_array(u8, hcmd2, len2)
 		__field(u32, flags)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		memcpy(__get_dynamic_array(hcmd0), hcmd0, len0);
 		memcpy(__get_dynamic_array(hcmd1), hcmd1, len1);
 		memcpy(__get_dynamic_array(hcmd2), hcmd2, len2);
 		__entry->flags = flags;
 	),
-	TP_printk("[%p] hcmd %#.2x (%ssync)",
-		  __entry->priv, ((u8 *)__get_dynamic_array(hcmd0))[0],
+	TP_printk("[%s] hcmd %#.2x (%ssync)",
+		  __get_str(dev), ((u8 *)__get_dynamic_array(hcmd0))[0],
 		  __entry->flags & CMD_ASYNC ? "a" : "")
 );
 
 TRACE_EVENT(iwlwifi_dev_rx,
-	TP_PROTO(void *priv, void *rxbuf, size_t len),
-	TP_ARGS(priv, rxbuf, len),
+	TP_PROTO(const struct device *dev, void *rxbuf, size_t len),
+	TP_ARGS(dev, rxbuf, len),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 		__dynamic_array(u8, rxbuf, len)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		memcpy(__get_dynamic_array(rxbuf), rxbuf, len);
 	),
-	TP_printk("[%p] RX cmd %#.2x",
-		  __entry->priv, ((u8 *)__get_dynamic_array(rxbuf))[4])
+	TP_printk("[%s] RX cmd %#.2x",
+		  __get_str(dev), ((u8 *)__get_dynamic_array(rxbuf))[4])
 );
 
 TRACE_EVENT(iwlwifi_dev_tx,
-	TP_PROTO(void *priv, void *tfd, size_t tfdlen,
+	TP_PROTO(const struct device *dev, void *tfd, size_t tfdlen,
 		 void *buf0, size_t buf0_len,
 		 void *buf1, size_t buf1_len),
-	TP_ARGS(priv, tfd, tfdlen, buf0, buf0_len, buf1, buf1_len),
+	TP_ARGS(dev, tfd, tfdlen, buf0, buf0_len, buf1, buf1_len),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 
 		__field(size_t, framelen)
 		__dynamic_array(u8, tfd, tfdlen)
@@ -291,29 +295,28 @@ TRACE_EVENT(iwlwifi_dev_tx,
 		__dynamic_array(u8, buf1, buf1_len)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->framelen = buf0_len + buf1_len;
 		memcpy(__get_dynamic_array(tfd), tfd, tfdlen);
 		memcpy(__get_dynamic_array(buf0), buf0, buf0_len);
 		memcpy(__get_dynamic_array(buf1), buf1, buf1_len);
 	),
-	TP_printk("[%p] TX %.2x (%zu bytes)",
-		  __entry->priv,
-		  ((u8 *)__get_dynamic_array(buf0))[0],
+	TP_printk("[%s] TX %.2x (%zu bytes)",
+		  __get_str(dev), ((u8 *)__get_dynamic_array(buf0))[0],
 		  __entry->framelen)
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_error,
-	TP_PROTO(void *priv, u32 desc, u32 tsf_low,
+	TP_PROTO(const struct device *dev, u32 desc, u32 tsf_low,
 		 u32 data1, u32 data2, u32 line, u32 blink1,
 		 u32 blink2, u32 ilink1, u32 ilink2, u32 bcon_time,
 		 u32 gp1, u32 gp2, u32 gp3, u32 ucode_ver, u32 hw_ver,
 		 u32 brd_ver),
-	TP_ARGS(priv, desc, tsf_low, data1, data2, line,
+	TP_ARGS(dev, desc, tsf_low, data1, data2, line,
 		blink1, blink2, ilink1, ilink2, bcon_time, gp1, gp2,
 		gp3, ucode_ver, hw_ver, brd_ver),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 		__field(u32, desc)
 		__field(u32, tsf_low)
 		__field(u32, data1)
@@ -332,7 +335,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 		__field(u32, brd_ver)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->desc = desc;
 		__entry->tsf_low = tsf_low;
 		__entry->data1 = data1;
@@ -350,11 +353,11 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 		__entry->hw_ver = hw_ver;
 		__entry->brd_ver = brd_ver;
 	),
-	TP_printk("[%p] #%02d %010u data 0x%08X 0x%08X line %u, "
+	TP_printk("[%s] #%02d %010u data 0x%08X 0x%08X line %u, "
 		  "blink 0x%05X 0x%05X ilink 0x%05X 0x%05X "
 		  "bcon_tm %010u gp 0x%08X 0x%08X 0x%08X uCode 0x%08X "
 		  "hw 0x%08X brd 0x%08X",
-		  __entry->priv, __entry->desc, __entry->tsf_low,
+		  __get_str(dev), __entry->desc, __entry->tsf_low,
 		  __entry->data1,
 		  __entry->data2, __entry->line, __entry->blink1,
 		  __entry->blink2, __entry->ilink1, __entry->ilink2,
@@ -364,23 +367,23 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_event,
-	TP_PROTO(void *priv, u32 time, u32 data, u32 ev),
-	TP_ARGS(priv, time, data, ev),
+	TP_PROTO(const struct device *dev, u32 time, u32 data, u32 ev),
+	TP_ARGS(dev, time, data, ev),
 	TP_STRUCT__entry(
-		PRIV_ENTRY
+		DEV_ENTRY
 
 		__field(u32, time)
 		__field(u32, data)
 		__field(u32, ev)
 	),
 	TP_fast_assign(
-		PRIV_ASSIGN;
+		DEV_ASSIGN;
 		__entry->time = time;
 		__entry->data = data;
 		__entry->ev = ev;
 	),
-	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
-		  __entry->priv, __entry->time, __entry->data, __entry->ev)
+	TP_printk("[%s] EVT_LOGT:%010u:0x%08x:%04u",
+		  __get_str(dev), __entry->time, __entry->data, __entry->ev)
 );
 #endif /* __IWLWIFI_DEVICE_TRACE */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 782486f..1136dc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -35,20 +35,20 @@
 
 static inline void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
-	trace_iwlwifi_dev_iowrite8(priv(trans), ofs, val);
+	trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val);
 	iwl_trans_write8(trans, ofs, val);
 }
 
 static inline void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 {
-	trace_iwlwifi_dev_iowrite32(priv(trans), ofs, val);
+	trace_iwlwifi_dev_iowrite32(trans->dev, ofs, val);
 	iwl_trans_write32(trans, ofs, val);
 }
 
 static inline u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 {
 	u32 val = iwl_trans_read32(trans, ofs);
-	trace_iwlwifi_dev_ioread32(priv(trans), ofs, val);
+	trace_iwlwifi_dev_ioread32(trans->dev, ofs, val);
 	return val;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 911a9f1..33a933b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -388,7 +388,7 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 
 	len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	len += sizeof(u32); /* account for status word */
-	trace_iwlwifi_dev_rx(priv(trans), pkt, len);
+	trace_iwlwifi_dev_rx(trans->dev, pkt, len);
 
 	/* Reclaim a command buffer only if this packet is a response
 	 *   to a (driver-originated) command.
@@ -632,7 +632,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 
 	trans_pcie->isr_stats.err_code = table.error_id;
 
-	trace_iwlwifi_dev_ucode_error(priv(trans), table.error_id, table.tsf_low,
+	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
 				      table.data1, table.data2, table.line,
 				      table.blink1, table.blink2, table.ilink1,
 				      table.ilink2, table.bcon_time, table.gp1,
@@ -764,7 +764,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 						"EVT_LOG:0x%08x:%04u\n",
 						time, ev);
 			} else {
-				trace_iwlwifi_dev_ucode_event(priv(trans), 0,
+				trace_iwlwifi_dev_ucode_event(trans->dev, 0,
 					time, ev);
 				IWL_ERR(trans, "EVT_LOG:0x%08x:%04u\n",
 					time, ev);
@@ -778,7 +778,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 			} else {
 				IWL_ERR(trans, "EVT_LOGT:%010u:0x%08x:%04u\n",
 					time, data, ev);
-				trace_iwlwifi_dev_ucode_event(priv(trans), time,
+				trace_iwlwifi_dev_ucode_event(trans->dev, time,
 					data, ev);
 			}
 		}
@@ -1262,7 +1262,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if (!trans)
 		return IRQ_NONE;
 
-	trace_iwlwifi_dev_irq(priv(trans));
+	trace_iwlwifi_dev_irq(trans->dev);
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -1352,7 +1352,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (!trans_pcie->use_ict)
 		return iwl_isr(irq, data);
 
-	trace_iwlwifi_dev_irq(priv(trans));
+	trace_iwlwifi_dev_irq(trans->dev);
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
@@ -1369,7 +1369,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
 	read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
-	trace_iwlwifi_dev_ict_read(priv(trans), trans_pcie->ict_index, read);
+	trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index, read);
 	if (!read) {
 		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
 		goto none;
@@ -1388,7 +1388,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
 
 		read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
-		trace_iwlwifi_dev_ict_read(priv(trans), trans_pcie->ict_index,
+		trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index,
 					   read);
 	} while (read);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 2573f71..844606b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -820,7 +820,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	/* check that tracing gets all possible blocks */
 	BUILD_BUG_ON(IWL_MAX_CMD_TFDS + 1 != 3);
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	trace_iwlwifi_dev_hcmd(priv(trans), cmd->flags,
+	trace_iwlwifi_dev_hcmd(trans->dev, cmd->flags,
 			       trace_bufs[0], trace_lens[0],
 			       trace_bufs[1], trace_lens[1],
 			       trace_bufs[2], trace_lens[2]);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 44050fa..ef4e122 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1468,7 +1468,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	dma_sync_single_for_device(trans->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);
 
-	trace_iwlwifi_dev_tx(priv(trans),
+	trace_iwlwifi_dev_tx(trans->dev,
 			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
 			     sizeof(struct iwl_tfd),
 			     &dev_cmd->hdr, firstlen,
-- 
1.7.0.4

