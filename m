Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 38/42] mt76: initial separation of mmio part
Date: Thu,  6 Sep 2018 11:18:54 +0200
Message-Id: <1536225538-16454-39-git-send-email-sgruszka@redhat.com> (sfid-20180906_112049_944044_925284C5)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create mt76_mmio module to contain generic mt76 PCEe/SOC code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig      |  8 ++-
 drivers/net/wireless/mediatek/mt76/Makefile     |  8 +--
 drivers/net/wireless/mediatek/mt76/dma.c        | 68 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mac80211.c   |  1 -
 drivers/net/wireless/mediatek/mt76/mmio.c       | 17 ++++--
 drivers/net/wireless/mediatek/mt76/mmio_trace.c | 23 ++++++++
 drivers/net/wireless/mediatek/mt76/mmio_trace.h | 71 +++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h       | 16 ++++--
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c |  4 +-
 drivers/net/wireless/mediatek/mt76/trace.c      | 23 --------
 drivers/net/wireless/mediatek/mt76/trace.h      | 71 -------------------------
 drivers/net/wireless/mediatek/mt76/tx.c         | 66 -----------------------
 12 files changed, 198 insertions(+), 178 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio_trace.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/trace.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/trace.h

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index e460a3a5e763..0fe581ed8693 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -3,7 +3,11 @@ config MT76_CORE
 
 config MT76_USB
 	tristate
-	depends on MT76_CORE
+	select MT76_CORE
+
+config MT76_MMIO
+	tristate
+	select MT76_CORE
 
 config MT76x02_LIB
 	tristate
@@ -29,6 +33,7 @@ config MT76x0U
 config MT76x0E
 	tristate "MediaTek MT76x0E (PCIe) support"
 	select MT76x0_COMMON
+	select MT76_MMIO
 	depends on MAC80211
 	depends on PCI
 	help
@@ -37,6 +42,7 @@ config MT76x0E
 config MT76x2E
 	tristate "MediaTek MT76x2E (PCIe) support"
 	select MT76x2_COMMON
+	select MT76_MMIO
 	depends on MAC80211
 	depends on PCI
 	---help---
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 129ac71446d6..1d366348f799 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,17 +1,17 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76_USB) += mt76-usb.o
+obj-$(CONFIG_MT76_MMIO) += mt76-mmio.o
 obj-$(CONFIG_MT76x0_COMMON) += mt76x0/
 obj-$(CONFIG_MT76x02_LIB) += mt76x02-lib.o
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 obj-$(CONFIG_MT76x2U) += mt76x2u.o
 
-mt76-y := \
-	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
-
+mt76-y := util.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
+mt76-mmio-y := dma.o mmio_trace.o mmio.o
 mt76-usb-y := usb.o usb_trace.o usb_mcu.o
 
-CFLAGS_trace.o := -I$(src)
+CFLAGS_mmio_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index c51da2205b93..138f3faa6138 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -20,6 +20,72 @@
 
 #define DMA_DUMMY_TXWI	((void *) ~0)
 
+static struct mt76_txwi_cache *
+mt76_alloc_txwi(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t;
+	dma_addr_t addr;
+	int size;
+
+	size = (sizeof(*t) + L1_CACHE_BYTES - 1) & ~(L1_CACHE_BYTES - 1);
+	t = devm_kzalloc(dev->dev, size, GFP_ATOMIC);
+	if (!t)
+		return NULL;
+
+	addr = dma_map_single(dev->dev, &t->txwi, sizeof(t->txwi),
+			      DMA_TO_DEVICE);
+	t->dma_addr = addr;
+
+	return t;
+}
+
+static struct mt76_txwi_cache *
+__mt76_get_txwi(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t = NULL;
+
+	spin_lock_bh(&dev->lock);
+	if (!list_empty(&dev->txwi_cache)) {
+		t = list_first_entry(&dev->txwi_cache, struct mt76_txwi_cache,
+				     list);
+		list_del(&t->list);
+	}
+	spin_unlock_bh(&dev->lock);
+
+	return t;
+}
+
+struct mt76_txwi_cache *
+mt76_get_txwi(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t = __mt76_get_txwi(dev);
+
+	if (t)
+		return t;
+
+	return mt76_alloc_txwi(dev);
+}
+
+static void
+mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t)
+{
+	if (!t)
+		return;
+
+	spin_lock_bh(&dev->lock);
+	list_add(&t->list, &dev->txwi_cache);
+	spin_unlock_bh(&dev->lock);
+}
+
+static void mt76_tx_free(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t;
+
+	while ((t = __mt76_get_txwi(dev)) != NULL)
+		dma_unmap_single(dev->dev, t->dma_addr, sizeof(t->txwi),
+				 DMA_TO_DEVICE);
+}
+
 static int
 mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
@@ -534,5 +600,7 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 		netif_napi_del(&dev->napi[i]);
 		mt76_dma_rx_cleanup(dev, &dev->q_rx[i]);
 	}
+
+	mt76_tx_free(dev);
 }
 EXPORT_SYMBOL_GPL(mt76_dma_cleanup);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 639cbafc1d50..4615040e782e 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -358,7 +358,6 @@ void mt76_unregister_device(struct mt76_dev *dev)
 	struct ieee80211_hw *hw = dev->hw;
 
 	ieee80211_unregister_hw(hw);
-	mt76_tx_free(dev);
 }
 EXPORT_SYMBOL_GPL(mt76_unregister_device);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 09a14dead6e3..c836a2a8986a 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -15,13 +15,14 @@
  */
 
 #include "mt76.h"
-#include "trace.h"
+#include "mmio_trace.h"
 
 static u32 mt76_mmio_rr(struct mt76_dev *dev, u32 offset)
 {
+	struct mt76_mmio *mmio = &dev->mmio;
 	u32 val;
 
-	val = ioread32(dev->regs + offset);
+	val = ioread32(mmio->regs + offset);
 	trace_reg_rr(dev, offset, val);
 
 	return val;
@@ -29,8 +30,10 @@ static u32 mt76_mmio_rr(struct mt76_dev *dev, u32 offset)
 
 static void mt76_mmio_wr(struct mt76_dev *dev, u32 offset, u32 val)
 {
+	struct mt76_mmio *mmio = &dev->mmio;
+
 	trace_reg_wr(dev, offset, val);
-	iowrite32(val, dev->regs + offset);
+	iowrite32(val, mmio->regs + offset);
 }
 
 static u32 mt76_mmio_rmw(struct mt76_dev *dev, u32 offset, u32 mask, u32 val)
@@ -43,7 +46,9 @@ static u32 mt76_mmio_rmw(struct mt76_dev *dev, u32 offset, u32 mask, u32 val)
 static void mt76_mmio_copy(struct mt76_dev *dev, u32 offset, const void *data,
 			   int len)
 {
-	__iowrite32_copy(dev->regs + offset, data, len >> 2);
+	struct mt76_mmio *mmio = &dev->mmio;
+
+	__iowrite32_copy(mmio->regs + offset, data, len >> 2);
 }
 
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
@@ -56,6 +61,8 @@ void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 	};
 
 	dev->bus = &mt76_mmio_ops;
-	dev->regs = regs;
+	dev->mmio.regs = regs;
 }
 EXPORT_SYMBOL_GPL(mt76_mmio_init);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mmio_trace.c b/drivers/net/wireless/mediatek/mt76/mmio_trace.c
new file mode 100644
index 000000000000..13945ec18cfa
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mmio_trace.c
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "mmio_trace.h"
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mmio_trace.h b/drivers/net/wireless/mediatek/mt76/mmio_trace.h
new file mode 100644
index 000000000000..f0de0b094dea
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mmio_trace.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#if !defined(__MT76_MMIO_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __MT76_MMIO_TRACE_H
+
+#include <linux/tracepoint.h>
+#include "mt76.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mt76_mmio
+
+#define MAXNAME		32
+#define DEV_ENTRY   __array(char, wiphy_name, 32)
+#define DEV_ASSIGN  strlcpy(__entry->wiphy_name, wiphy_name(dev->hw->wiphy), MAXNAME)
+#define DEV_PR_FMT  "%s"
+#define DEV_PR_ARG  __entry->wiphy_name
+
+#define REG_ENTRY	__field(u32, reg) __field(u32, val)
+#define REG_ASSIGN	__entry->reg = reg; __entry->val = val
+#define REG_PR_FMT	" %04x=%08x"
+#define REG_PR_ARG	__entry->reg, __entry->val
+
+DECLARE_EVENT_CLASS(dev_reg_evt,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		REG_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		REG_ASSIGN;
+	),
+	TP_printk(
+		DEV_PR_FMT REG_PR_FMT,
+		DEV_PR_ARG, REG_PR_ARG
+	)
+);
+
+DEFINE_EVENT(dev_reg_evt, reg_rr,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+DEFINE_EVENT(dev_reg_evt, reg_wr,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE mmio_trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 80390be041cb..2987ade3cb1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -323,6 +323,10 @@ struct mt76_usb {
 	} mcu;
 };
 
+struct mt76_mmio {
+	void __iomem *regs;
+};
+
 struct mt76_dev {
 	struct ieee80211_hw *hw;
 	struct cfg80211_chan_def chandef;
@@ -335,7 +339,6 @@ struct mt76_dev {
 
 	const struct mt76_bus_ops *bus;
 	const struct mt76_driver_ops *drv;
-	void __iomem *regs;
 	struct device *dev;
 
 	struct net_device napi_dev;
@@ -376,9 +379,15 @@ struct mt76_dev {
 
 	u32 rxfilter;
 
-	struct mt76_usb usb;
+	union {
+		struct mt76_usb usb;
+		struct mt76_mmio mmio;
+	};
 };
 
+#define mt76_usb(dev) (&((dev)->mt76.usb))
+#define mt76_mmio(dev) (&((dev)->mt76.mmio))
+
 enum mt76_phy_type {
 	MT_PHY_TYPE_CCK,
 	MT_PHY_TYPE_OFDM,
@@ -574,9 +583,6 @@ void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
 /* internal */
-void mt76_tx_free(struct mt76_dev *dev);
-struct mt76_txwi_cache *mt76_get_txwi(struct mt76_dev *dev);
-void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 		      struct napi_struct *napi);
 void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 44ca660775fd..8d9a599aa4ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -53,7 +53,7 @@ mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 {
 	int ret;
 
-	q->regs = dev->mt76.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
+	q->regs = mt76_mmio(dev)->regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
 	q->ndesc = n_desc;
 
 	ret = mt76_queue_alloc(dev, q);
@@ -71,7 +71,7 @@ mt76x2_init_rx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 {
 	int ret;
 
-	q->regs = dev->mt76.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
+	q->regs = mt76_mmio(dev)->regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
 	q->ndesc = n_desc;
 	q->buf_size = bufsize;
 
diff --git a/drivers/net/wireless/mediatek/mt76/trace.c b/drivers/net/wireless/mediatek/mt76/trace.c
deleted file mode 100644
index ea4ab8729ae4..000000000000
--- a/drivers/net/wireless/mediatek/mt76/trace.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/module.h>
-
-#ifndef __CHECKER__
-#define CREATE_TRACE_POINTS
-#include "trace.h"
-
-#endif
diff --git a/drivers/net/wireless/mediatek/mt76/trace.h b/drivers/net/wireless/mediatek/mt76/trace.h
deleted file mode 100644
index ea30895933c5..000000000000
--- a/drivers/net/wireless/mediatek/mt76/trace.h
+++ /dev/null
@@ -1,71 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#if !defined(__MT76_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define __MT76_TRACE_H
-
-#include <linux/tracepoint.h>
-#include "mt76.h"
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM mt76
-
-#define MAXNAME		32
-#define DEV_ENTRY   __array(char, wiphy_name, 32)
-#define DEV_ASSIGN  strlcpy(__entry->wiphy_name, wiphy_name(dev->hw->wiphy), MAXNAME)
-#define DEV_PR_FMT  "%s"
-#define DEV_PR_ARG  __entry->wiphy_name
-
-#define REG_ENTRY	__field(u32, reg) __field(u32, val)
-#define REG_ASSIGN	__entry->reg = reg; __entry->val = val
-#define REG_PR_FMT	" %04x=%08x"
-#define REG_PR_ARG	__entry->reg, __entry->val
-
-DECLARE_EVENT_CLASS(dev_reg_evt,
-	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
-	TP_ARGS(dev, reg, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		REG_ENTRY
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		REG_ASSIGN;
-	),
-	TP_printk(
-		DEV_PR_FMT REG_PR_FMT,
-		DEV_PR_ARG, REG_PR_ARG
-	)
-);
-
-DEFINE_EVENT(dev_reg_evt, reg_rr,
-	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
-	TP_ARGS(dev, reg, val)
-);
-
-DEFINE_EVENT(dev_reg_evt, reg_wr,
-	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
-	TP_ARGS(dev, reg, val)
-);
-
-#endif
-
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH .
-#undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE trace
-
-#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index cf79b8c67b52..984ea2db2696 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -16,72 +16,6 @@
 
 #include "mt76.h"
 
-static struct mt76_txwi_cache *
-mt76_alloc_txwi(struct mt76_dev *dev)
-{
-	struct mt76_txwi_cache *t;
-	dma_addr_t addr;
-	int size;
-
-	size = (sizeof(*t) + L1_CACHE_BYTES - 1) & ~(L1_CACHE_BYTES - 1);
-	t = devm_kzalloc(dev->dev, size, GFP_ATOMIC);
-	if (!t)
-		return NULL;
-
-	addr = dma_map_single(dev->dev, &t->txwi, sizeof(t->txwi),
-			      DMA_TO_DEVICE);
-	t->dma_addr = addr;
-
-	return t;
-}
-
-static struct mt76_txwi_cache *
-__mt76_get_txwi(struct mt76_dev *dev)
-{
-	struct mt76_txwi_cache *t = NULL;
-
-	spin_lock_bh(&dev->lock);
-	if (!list_empty(&dev->txwi_cache)) {
-		t = list_first_entry(&dev->txwi_cache, struct mt76_txwi_cache,
-				     list);
-		list_del(&t->list);
-	}
-	spin_unlock_bh(&dev->lock);
-
-	return t;
-}
-
-struct mt76_txwi_cache *
-mt76_get_txwi(struct mt76_dev *dev)
-{
-	struct mt76_txwi_cache *t = __mt76_get_txwi(dev);
-
-	if (t)
-		return t;
-
-	return mt76_alloc_txwi(dev);
-}
-
-void
-mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t)
-{
-	if (!t)
-		return;
-
-	spin_lock_bh(&dev->lock);
-	list_add(&t->list, &dev->txwi_cache);
-	spin_unlock_bh(&dev->lock);
-}
-
-void mt76_tx_free(struct mt76_dev *dev)
-{
-	struct mt76_txwi_cache *t;
-
-	while ((t = __mt76_get_txwi(dev)) != NULL)
-		dma_unmap_single(dev->dev, t->dma_addr, sizeof(t->txwi),
-				 DMA_TO_DEVICE);
-}
-
 static int
 mt76_txq_get_qid(struct ieee80211_txq *txq)
 {
-- 
2.7.5
