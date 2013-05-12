Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20912 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3ELLoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 07:44:12 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/7] wil6210: trace support
Date: Sun, 12 May 2013 14:43:35 +0300
Message-ID: <1368359018-20870-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130512_134422_399879_C897AD39)
In-Reply-To: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trace the following:
- WMI cmd/event
- log events
- interrupts
- Tx/Rx

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Kconfig     |  12 ++
 drivers/net/wireless/ath/wil6210/Makefile    |  21 ++-
 drivers/net/wireless/ath/wil6210/debug.c     |  70 ++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |   6 +
 drivers/net/wireless/ath/wil6210/trace.c     |  20 +++
 drivers/net/wireless/ath/wil6210/trace.h     | 235 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  10 +-
 drivers/net/wireless/ath/wil6210/wil6210.h   |  10 +-
 drivers/net/wireless/ath/wil6210/wmi.c       |   8 +-
 9 files changed, 377 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/debug.c
 create mode 100644 drivers/net/wireless/ath/wil6210/trace.c
 create mode 100644 drivers/net/wireless/ath/wil6210/trace.h

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index bac3d98..5644ac5 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -27,3 +27,15 @@ config WIL6210_ISR_COR
 	  self-clear when accessed for debug purposes, it makes
 	  such monitoring impossible.
 	  Say y unless you debug interrupts
+
+config ATH6KL_TRACING
+	bool "wil6210 tracing support"
+	depends on WIL6210
+	depends on EVENT_TRACING
+	default y
+	---help---
+	  Say Y here to enable tracepoints for the wil6210 driver
+	  using the kernel tracing infrastructure.  Select this
+	  option if you are interested in debugging the driver.
+
+	  If unsure, say Y to make it easier to debug problems.
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index d288eea..f891d51 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -1,15 +1,20 @@
 obj-$(CONFIG_WIL6210) += wil6210.o
 
-wil6210-objs := main.o
-wil6210-objs += netdev.o
-wil6210-objs += cfg80211.o
-wil6210-objs += pcie_bus.o
-wil6210-objs += debugfs.o
-wil6210-objs += wmi.o
-wil6210-objs += interrupt.o
-wil6210-objs += txrx.o
+wil6210-y := main.o
+wil6210-y += netdev.o
+wil6210-y += cfg80211.o
+wil6210-y += pcie_bus.o
+wil6210-y += debugfs.o
+wil6210-y += wmi.o
+wil6210-y += interrupt.o
+wil6210-y += txrx.o
+wil6210-y += debug.o
+wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 
 ifeq (, $(findstring -W,$(EXTRA_CFLAGS)))
 	subdir-ccflags-y += -Werror
 endif
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)
+
 subdir-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
new file mode 100644
index 0000000..5f20b4a
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/debug.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "wil6210.h"
+#include "trace.h"
+
+int wil_err(struct wil6210_priv *wil, const char *fmt, ...)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	ret = netdev_err(ndev, "%pV", &vaf);
+	trace_wil6210_log_err(&vaf);
+	va_end(args);
+
+	return ret;
+}
+
+int wil_info(struct wil6210_priv *wil, const char *fmt, ...)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	ret = netdev_info(ndev, "%pV", &vaf);
+	trace_wil6210_log_info(&vaf);
+	va_end(args);
+
+	return ret;
+}
+
+int wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	trace_wil6210_log_dbg(&vaf);
+	va_end(args);
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index e3c1e76..5fe985c 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 
 #include "wil6210.h"
+#include "trace.h"
 
 /**
  * Theory of operation:
@@ -168,6 +169,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 					 HOSTADDR(RGF_DMA_EP_RX_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
 
+	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (!isr) {
@@ -198,6 +200,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 					 HOSTADDR(RGF_DMA_EP_TX_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
 
+	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (!isr) {
@@ -256,6 +259,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 					 HOSTADDR(RGF_DMA_EP_MISC_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
 
+	trace_wil6210_irq_misc(isr);
 	wil_dbg_irq(wil, "ISR MISC 0x%08x\n", isr);
 
 	if (!isr) {
@@ -301,6 +305,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	struct wil6210_priv *wil = cookie;
 	u32 isr = wil->isr_misc;
 
+	trace_wil6210_irq_misc_thread(isr);
 	wil_dbg_irq(wil, "Thread ISR MISC 0x%08x\n", isr);
 
 	if (isr & ISR_MISC_FW_ERROR) {
@@ -408,6 +413,7 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 	if (wil6210_debug_irq_mask(wil, pseudo_cause))
 		return IRQ_NONE;
 
+	trace_wil6210_irq_pseudo(pseudo_cause);
 	wil_dbg_irq(wil, "Pseudo IRQ 0x%08x\n", pseudo_cause);
 
 	wil6210_mask_irq_pseudo(wil);
diff --git a/drivers/net/wireless/ath/wil6210/trace.c b/drivers/net/wireless/ath/wil6210/trace.c
new file mode 100644
index 0000000..cd2534b
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/trace.c
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/drivers/net/wireless/ath/wil6210/trace.h b/drivers/net/wireless/ath/wil6210/trace.h
new file mode 100644
index 0000000..eff1239
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/trace.h
@@ -0,0 +1,235 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM wil6210
+#if !defined(WIL6210_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define WIL6210_TRACE_H
+
+#include <linux/tracepoint.h>
+#include "wil6210.h"
+#include "txrx.h"
+
+/* create empty functions when tracing is disabled */
+#if !defined(CONFIG_WIL6210_TRACING) || defined(__CHECKER__)
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif /* !CONFIG_WIL6210_TRACING || defined(__CHECKER__) */
+
+DECLARE_EVENT_CLASS(wil6210_wmi,
+	TP_PROTO(u16 id, void *buf, u16 buf_len),
+
+	TP_ARGS(id, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(u16, id)
+		__field(u16, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"id 0x%04x len %d",
+		__entry->id, __entry->buf_len
+	)
+);
+
+DEFINE_EVENT(wil6210_wmi, wil6210_wmi_cmd,
+	TP_PROTO(u16 id, void *buf, u16 buf_len),
+	TP_ARGS(id, buf, buf_len)
+);
+
+DEFINE_EVENT(wil6210_wmi, wil6210_wmi_event,
+	TP_PROTO(u16 id, void *buf, u16 buf_len),
+	TP_ARGS(id, buf, buf_len)
+);
+
+#define WIL6210_MSG_MAX (200)
+
+DECLARE_EVENT_CLASS(wil6210_log_event,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf),
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg, WIL6210_MSG_MAX)
+	),
+	TP_fast_assign(
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       WIL6210_MSG_MAX,
+				       vaf->fmt,
+				       *vaf->va) >= WIL6210_MSG_MAX);
+	),
+	TP_printk("%s", __get_str(msg))
+);
+
+DEFINE_EVENT(wil6210_log_event, wil6210_log_err,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(wil6210_log_event, wil6210_log_info,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(wil6210_log_event, wil6210_log_dbg,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+#define wil_pseudo_irq_cause(x) __print_flags(x, "|",	\
+	{BIT_DMA_PSEUDO_CAUSE_RX,	"Rx" },		\
+	{BIT_DMA_PSEUDO_CAUSE_TX,	"Tx" },		\
+	{BIT_DMA_PSEUDO_CAUSE_MISC,	"Misc" })
+
+TRACE_EVENT(wil6210_irq_pseudo,
+	TP_PROTO(u32 x),
+	TP_ARGS(x),
+	TP_STRUCT__entry(
+		__field(u32, x)
+	),
+	TP_fast_assign(
+		__entry->x = x;
+	),
+	TP_printk("cause 0x%08x : %s", __entry->x,
+		  wil_pseudo_irq_cause(__entry->x))
+);
+
+DECLARE_EVENT_CLASS(wil6210_irq,
+	TP_PROTO(u32 x),
+	TP_ARGS(x),
+	TP_STRUCT__entry(
+		__field(u32, x)
+	),
+	TP_fast_assign(
+		__entry->x = x;
+	),
+	TP_printk("cause 0x%08x", __entry->x)
+);
+
+DEFINE_EVENT(wil6210_irq, wil6210_irq_rx,
+	TP_PROTO(u32 x),
+	TP_ARGS(x)
+);
+
+DEFINE_EVENT(wil6210_irq, wil6210_irq_tx,
+	TP_PROTO(u32 x),
+	TP_ARGS(x)
+);
+
+DEFINE_EVENT(wil6210_irq, wil6210_irq_misc,
+	TP_PROTO(u32 x),
+	TP_ARGS(x)
+);
+
+DEFINE_EVENT(wil6210_irq, wil6210_irq_misc_thread,
+	TP_PROTO(u32 x),
+	TP_ARGS(x)
+);
+
+TRACE_EVENT(wil6210_rx,
+	TP_PROTO(u16 index, struct vring_rx_desc *d),
+	TP_ARGS(index, d),
+	TP_STRUCT__entry(
+		__field(u16, index)
+		__field(unsigned int, len)
+		__field(u8, mid)
+		__field(u8, cid)
+		__field(u8, tid)
+		__field(u8, type)
+		__field(u8, subtype)
+		__field(u16, seq)
+		__field(u8, mcs)
+	),
+	TP_fast_assign(
+		__entry->index = index;
+		__entry->len = d->dma.length;
+		__entry->mid = wil_rxdesc_mid(d);
+		__entry->cid = wil_rxdesc_cid(d);
+		__entry->tid = wil_rxdesc_tid(d);
+		__entry->type = wil_rxdesc_ftype(d);
+		__entry->subtype = wil_rxdesc_subtype(d);
+		__entry->seq = wil_rxdesc_seq(d);
+		__entry->mcs = wil_rxdesc_mcs(d);
+	),
+	TP_printk("index %d len %d mid %d cid %d tid %d mcs %d seq 0x%03x"
+		  " type 0x%1x subtype 0x%1x", __entry->index, __entry->len,
+		  __entry->mid, __entry->cid, __entry->tid, __entry->mcs,
+		  __entry->seq, __entry->type, __entry->subtype)
+);
+
+TRACE_EVENT(wil6210_tx,
+	TP_PROTO(u8 vring, u16 index, unsigned int len, u8 frags),
+	TP_ARGS(vring, index, len, frags),
+	TP_STRUCT__entry(
+		__field(u8, vring)
+		__field(u8, frags)
+		__field(u16, index)
+		__field(unsigned int, len)
+	),
+	TP_fast_assign(
+		__entry->vring = vring;
+		__entry->frags = frags;
+		__entry->index = index;
+		__entry->len = len;
+	),
+	TP_printk("vring %d index %d len %d frags %d",
+		  __entry->vring, __entry->index, __entry->len, __entry->frags)
+);
+
+TRACE_EVENT(wil6210_tx_done,
+	TP_PROTO(u8 vring, u16 index, unsigned int len, u8 err),
+	TP_ARGS(vring, index, len, err),
+	TP_STRUCT__entry(
+		__field(u8, vring)
+		__field(u8, err)
+		__field(u16, index)
+		__field(unsigned int, len)
+	),
+	TP_fast_assign(
+		__entry->vring = vring;
+		__entry->index = index;
+		__entry->len = len;
+		__entry->err = err;
+	),
+	TP_printk("vring %d index %d len %d err 0x%02x",
+		  __entry->vring, __entry->index, __entry->len,
+		  __entry->err)
+);
+
+#endif /* WIL6210_TRACE_H || TRACE_HEADER_MULTI_READ*/
+
+#if defined(CONFIG_WIL6210_TRACING) && !defined(__CHECKER__)
+/* we don't want to use include/trace/events */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+#endif /* defined(CONFIG_WIL6210_TRACING) && !defined(__CHECKER__) */
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index d060511..dfd9848 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -22,6 +22,7 @@
 #include "wil6210.h"
 #include "wmi.h"
 #include "txrx.h"
+#include "trace.h"
 
 static bool rtap_include_phy_info;
 module_param(rtap_include_phy_info, bool, S_IRUGO);
@@ -370,9 +371,11 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
 		wil_rx_add_radiotap_header(wil, skb);
 
-	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", vring->swhead, d->dma.length);
+	trace_wil6210_rx(vring->swhead, d1);
+	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", vring->swhead,
+		     d1->dma.length);
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
-			  (const void *)d, sizeof(*d), false);
+			  (const void *)d1, sizeof(*d1), false);
 
 	/* no extra checks if in sniffer mode */
 	if (ndev->type != ARPHRD_ETHER)
@@ -705,6 +708,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	/* advance swhead */
 	wil_vring_advance_head(vring, nr_frags + 1);
 	wil_dbg_txrx(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
+	trace_wil6210_tx(vring_index, swhead, skb->len, nr_frags);
 	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
 	/* hold reference to skb
 	 * to prevent skb release before accounting
@@ -815,6 +819,8 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 			break;
 
 		dmalen = le16_to_cpu(d->dma.length);
+		trace_wil6210_tx_done(ringid, vring->swtail, dmalen,
+				      d->dma.error);
 		wil_dbg_txrx(wil,
 			     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
 			     vring->swtail, dmalen, d->dma.status,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 8f76ecd..484446e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -267,9 +267,13 @@ struct wil6210_priv {
 #define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
 #define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
 
-#define wil_dbg(wil, fmt, arg...) netdev_dbg(wil_to_ndev(wil), fmt, ##arg)
-#define wil_info(wil, fmt, arg...) netdev_info(wil_to_ndev(wil), fmt, ##arg)
-#define wil_err(wil, fmt, arg...) netdev_err(wil_to_ndev(wil), fmt, ##arg)
+int wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
+int wil_err(struct wil6210_priv *wil, const char *fmt, ...);
+int wil_info(struct wil6210_priv *wil, const char *fmt, ...);
+#define wil_dbg(wil, fmt, arg...) do { \
+	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
+	wil_dbg_trace(wil, fmt, ##arg); \
+} while (0)
 
 #define wil_dbg_irq(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
 #define wil_dbg_txrx(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 45b04e3..5e01f4e 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -20,6 +20,7 @@
 #include "wil6210.h"
 #include "txrx.h"
 #include "wmi.h"
+#include "trace.h"
 
 /**
  * WMI event receiving - theory of operations
@@ -246,6 +247,8 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	iowrite32(r->head = next_head, wil->csr + HOST_MBOX +
 		  offsetof(struct wil6210_mbox_ctl, tx.head));
 
+	trace_wil6210_wmi_cmd(cmdid, buf, len);
+
 	/* interrupt to FW */
 	iowrite32(SW_INT_MBOX, wil->csr + HOST_SW_INT);
 
@@ -635,8 +638,9 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 			    hdr.flags);
 		if ((hdr.type == WIL_MBOX_HDR_TYPE_WMI) &&
 		    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
-			wil_dbg_wmi(wil, "WMI event 0x%04x\n",
-				    evt->event.wmi.id);
+			u16 id = le16_to_cpu(evt->event.wmi.id);
+			wil_dbg_wmi(wil, "WMI event 0x%04x\n", id);
+			trace_wil6210_wmi_event(id, &evt->event.wmi, len);
 		}
 		wil_hex_dump_wmi("evt ", DUMP_PREFIX_OFFSET, 16, 1,
 				 &evt->event.hdr, sizeof(hdr) + len, true);
-- 
1.8.1.2

