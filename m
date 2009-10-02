Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191AbZJBUtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/13] iwlwifi: device tracing
Date: Fri,  2 Oct 2009 13:44:02 -0700
Message-Id: <1254516247-4085-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

In order to have an easier way to debug issues, create
trace events (using the ftrace framework) that will
allow us to follow exactly what the driver is doing
with the device.

The text format isn't all that useful, but the binary
format can also be obtained easily via debugfs and
then analysed on the fly or offline with debugging
tools.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   18 +++
 drivers/net/wireless/iwlwifi/Makefile       |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |   13 ++
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |  178 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    2 +
 drivers/net/wireless/iwlwifi/iwl-io.h       |   16 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   14 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +-
 9 files changed, 256 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index eb62c20..48d8f2c 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -49,6 +49,24 @@ config IWLWIFI_DEBUGFS
         ---help---
 	  Enable creation of debugfs files for the iwlwifi drivers.
 
+config IWLWIFI_DEVICE_TRACING
+	bool "iwlwifi device access tracing"
+	depends on IWLWIFI
+	depends on EVENT_TRACING
+	help
+	  Say Y here to trace all commands, including TX frames and IO
+	  accesses, sent to the device. If you say yes, iwlwifi will
+	  register with the ftrace framework for event tracing and dump
+	  all this information to the ringbuffer, you may need to
+	  increase the ringbuffer size. See the ftrace documentation
+	  for more information.
+
+	  When tracing is not enabled, this option still has some
+	  (though rather small) overhead.
+
+	  If unsure, say Y so we can help you better when problems
+	  occur.
+
 config IWLAGN
 	tristate "Intel Wireless WiFi Next Gen AGN (iwlagn)"
 	depends on IWLWIFI
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 1d4e0a2..3f31d86 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -5,7 +5,11 @@ iwlcore-objs 		+= iwl-scan.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
+iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
+CFLAGS_iwl-devtrace.o := -I$(src)
+
+# AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
 
@@ -14,7 +18,6 @@ iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 
+# 3945
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
-
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 26c66b4..4fb50d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -791,6 +791,9 @@ void iwl_rx_handle(struct iwl_priv *priv)
 				 PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
+		trace_iwlwifi_dev_rx(priv, pkt,
+			le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
 		 * If the packet (e.g. Rx frame) originated from uCode,
@@ -1610,6 +1613,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
 	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
 
+	trace_iwlwifi_dev_ucode_error(priv, desc, time, data1, data2, line,
+				      blink1, blink2, ilink1, ilink2);
+
 	IWL_ERR(priv, "Desc                               Time       "
 		"data1      data2      line\n");
 	IWL_ERR(priv, "%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
@@ -1658,12 +1664,14 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		ptr += sizeof(u32);
 		if (mode == 0) {
 			/* data, ev */
+			trace_iwlwifi_dev_ucode_event(priv, 0, time, ev);
 			IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n", time, ev);
 		} else {
 			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
 					time, data, ev);
+			trace_iwlwifi_dev_ucode_event(priv, time, data, ev);
 		}
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
new file mode 100644
index 0000000..4ef5aca
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -0,0 +1,13 @@
+#include <linux/module.h>
+
+/* sparse doesn't like tracepoint macros */
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "iwl-devtrace.h"
+
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ioread32);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_rx);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
new file mode 100644
index 0000000..8c71592
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -0,0 +1,178 @@
+#if !defined(__IWLWIFI_DEVICE_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+#define __IWLWIFI_DEVICE_TRACE
+
+#include <linux/tracepoint.h>
+#include "iwl-dev.h"
+
+#if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif
+
+#define PRIV_ENTRY	__field(struct iwl_priv *, priv)
+#define PRIV_ASSIGN	__entry->priv = priv
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM iwlwifi
+
+TRACE_EVENT(iwlwifi_dev_ioread32,
+	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
+	TP_ARGS(priv, offs, val),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(u32, offs)
+		__field(u32, val)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->offs = offs;
+		__entry->val = val;
+	),
+	TP_printk("[%p] read io[%#x] = %#x", __entry->priv, __entry->offs, __entry->val)
+);
+
+TRACE_EVENT(iwlwifi_dev_iowrite32,
+	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
+	TP_ARGS(priv, offs, val),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(u32, offs)
+		__field(u32, val)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->offs = offs;
+		__entry->val = val;
+	),
+	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
+);
+
+TRACE_EVENT(iwlwifi_dev_hcmd,
+	TP_PROTO(struct iwl_priv *priv, void *hcmd, size_t len, u32 flags),
+	TP_ARGS(priv, hcmd, len, flags),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__dynamic_array(u8, hcmd, len)
+		__field(u32, flags)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		memcpy(__get_dynamic_array(hcmd), hcmd, len);
+		__entry->flags = flags;
+	),
+	TP_printk("[%p] hcmd %#.2x (%ssync)",
+		  __entry->priv, ((u8 *)__get_dynamic_array(hcmd))[0],
+		  __entry->flags & CMD_ASYNC ? "a" : "")
+);
+
+TRACE_EVENT(iwlwifi_dev_rx,
+	TP_PROTO(struct iwl_priv *priv, void *rxbuf, size_t len),
+	TP_ARGS(priv, rxbuf, len),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__dynamic_array(u8, rxbuf, len)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		memcpy(__get_dynamic_array(rxbuf), rxbuf, len);
+	),
+	TP_printk("[%p] RX cmd %#.2x",
+		  __entry->priv, ((u8 *)__get_dynamic_array(rxbuf))[4])
+);
+
+TRACE_EVENT(iwlwifi_dev_tx,
+	TP_PROTO(struct iwl_priv *priv, void *tfd, size_t tfdlen,
+		 void *buf0, size_t buf0_len,
+		 void *buf1, size_t buf1_len),
+	TP_ARGS(priv, tfd, tfdlen, buf0, buf0_len, buf1, buf1_len),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+
+		__field(size_t, framelen)
+		__dynamic_array(u8, tfd, tfdlen)
+
+		/*
+		 * Do not insert between or below these items,
+		 * we want to keep the frame together (except
+		 * for the possible padding).
+		 */
+		__dynamic_array(u8, buf0, buf0_len)
+		__dynamic_array(u8, buf1, buf1_len)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->framelen = buf0_len + buf1_len;
+		memcpy(__get_dynamic_array(tfd), tfd, tfdlen);
+		memcpy(__get_dynamic_array(buf0), buf0, buf0_len);
+		memcpy(__get_dynamic_array(buf1), buf1, buf0_len);
+	),
+	TP_printk("[%p] TX %.2x (%zu bytes)",
+		  __entry->priv,
+		  ((u8 *)__get_dynamic_array(buf0))[0],
+		  __entry->framelen)
+);
+
+TRACE_EVENT(iwlwifi_dev_ucode_error,
+	TP_PROTO(struct iwl_priv *priv, u32 desc, u32 time,
+		 u32 data1, u32 data2, u32 line, u32 blink1,
+		 u32 blink2, u32 ilink1, u32 ilink2),
+	TP_ARGS(priv, desc, time, data1, data2, line,
+		blink1, blink2, ilink1, ilink2),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(u32, desc)
+		__field(u32, time)
+		__field(u32, data1)
+		__field(u32, data2)
+		__field(u32, line)
+		__field(u32, blink1)
+		__field(u32, blink2)
+		__field(u32, ilink1)
+		__field(u32, ilink2)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->desc = desc;
+		__entry->time = time;
+		__entry->data1 = data1;
+		__entry->data2 = data2;
+		__entry->line = line;
+		__entry->blink1 = blink1;
+		__entry->blink2 = blink2;
+		__entry->ilink1 = ilink1;
+		__entry->ilink2 = ilink2;
+	),
+	TP_printk("[%p] #%02d %010u data 0x%08X 0x%08X line %u, "
+		  "blink 0x%05X 0x%05X ilink 0x%05X 0x%05X",
+		  __entry->priv, __entry->desc, __entry->time, __entry->data1,
+		  __entry->data2, __entry->line, __entry->blink1,
+		  __entry->blink2, __entry->ilink1, __entry->ilink2)
+);
+
+TRACE_EVENT(iwlwifi_dev_ucode_event,
+	TP_PROTO(struct iwl_priv *priv, u32 time, u32 data, u32 ev),
+	TP_ARGS(priv, time, data, ev),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+
+		__field(u32, time)
+		__field(u32, data)
+		__field(u32, ev)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->time = time;
+		__entry->data = data;
+		__entry->ev = ev;
+	),
+	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
+		  __entry->priv, __entry->time, __entry->data, __entry->ev)
+);
+#endif /* __IWLWIFI_DEVICE_TRACE */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE iwl-devtrace
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 0eee059..b363c96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -63,6 +63,8 @@
 #ifndef __iwl_eeprom_h__
 #define __iwl_eeprom_h__
 
+#include <net/mac80211.h>
+
 struct iwl_priv;
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index d30cb02..0a078b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -32,6 +32,7 @@
 #include <linux/io.h>
 
 #include "iwl-debug.h"
+#include "iwl-devtrace.h"
 
 /*
  * IO, register, and NIC memory access functions
@@ -61,7 +62,12 @@
  *
  */
 
-#define _iwl_write32(priv, ofs, val) iowrite32((val), (priv)->hw_base + (ofs))
+static inline void _iwl_write32(struct iwl_priv *priv, u32 ofs, u32 val)
+{
+	trace_iwlwifi_dev_iowrite32(priv, ofs, val);
+	iowrite32(val, priv->hw_base + ofs);
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
 				 u32 ofs, u32 val)
@@ -75,7 +81,13 @@ static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
 #define iwl_write32(priv, ofs, val) _iwl_write32(priv, ofs, val)
 #endif
 
-#define _iwl_read32(priv, ofs) ioread32((priv)->hw_base + (ofs))
+static inline u32 _iwl_read32(struct iwl_priv *priv, u32 ofs)
+{
+	u32 val = ioread32(priv->hw_base + ofs);
+	trace_iwlwifi_dev_ioread32(priv, ofs, val);
+	return val;
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 2ba9725..c832ba0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -709,7 +709,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
-	u16 len, len_org;
+	u16 len, len_org, firstlen, secondlen;
 	u16 seq_number = 0;
 	__le16 fc;
 	u8 hdr_len;
@@ -842,7 +842,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		sizeof(struct iwl_cmd_header) + hdr_len;
 
 	len_org = len;
-	len = (len + 3) & ~3;
+	firstlen = len = (len + 3) & ~3;
 
 	if (len_org != len)
 		len_org = 1;
@@ -876,7 +876,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
-	len = skb->len - hdr_len;
+	secondlen = len = skb->len - hdr_len;
 	if (len) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
 					   len, PCI_DMA_TODEVICE);
@@ -910,6 +910,12 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
 				       len, PCI_DMA_BIDIRECTIONAL);
 
+	trace_iwlwifi_dev_tx(priv,
+			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
+			     sizeof(struct iwl_tfd),
+			     &out_cmd->hdr, firstlen,
+			     skb->data + hdr_len, secondlen);
+
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl_txq_update_write_ptr(priv, txq);
@@ -1044,6 +1050,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	pci_unmap_addr_set(out_meta, mapping, phys_addr);
 	pci_unmap_len_set(out_meta, len, fix_size);
 
+	trace_iwlwifi_dev_hcmd(priv, &out_cmd->hdr, fix_size, cmd->flags);
+
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 						   phys_addr, fix_size, 1,
 						   U32_PAD(cmd->len));
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3575e7f..d0d1b7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1404,6 +1404,9 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 				PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
+		trace_iwlwifi_dev_rx(priv, pkt,
+			le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
 		 * If the packet (e.g. Rx frame) originated from uCode,
@@ -1549,8 +1552,9 @@ void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 			"%-13s (#%d) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
 			desc_lookup(desc), desc, time, blink1, blink2,
 			ilink1, ilink2, data1);
+		trace_iwlwifi_dev_ucode_error(priv, desc, time, data1, 0,
+					0, blink1, blink2, ilink1, ilink2);
 	}
-
 }
 
 #define EVENT_START_OFFSET  (6 * sizeof(u32))
@@ -1590,10 +1594,12 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		if (mode == 0) {
 			/* data, ev */
 			IWL_ERR(priv, "0x%08x\t%04u\n", time, ev);
+			trace_iwlwifi_dev_ucode_event(priv, 0, time, ev);
 		} else {
 			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERR(priv, "%010u\t0x%08x\t%04u\n", time, data, ev);
+			trace_iwlwifi_dev_ucode_event(priv, time, data, ev);
 		}
 	}
 }
-- 
1.5.6.3

