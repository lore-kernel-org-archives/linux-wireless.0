Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728533AbeIFNzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 39/42] mt76: move some irq code to common mmio module
Date: Thu,  6 Sep 2018 11:18:55 +0200
Message-Id: <1536225538-16454-40-git-send-email-sgruszka@redhat.com> (sfid-20180906_112050_520470_65F112A5)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move some irq handling code to generic mmio module.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mmio.c        | 15 +++++++++++
 drivers/net/wireless/mediatek/mt76/mmio.h        | 34 ++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h        |  3 +++
 drivers/net/wireless/mediatek/mt76/mt76x2.h      | 15 -----------
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c | 26 ++++++------------
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c  |  7 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c  |  7 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  6 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  |  9 ++++---
 9 files changed, 76 insertions(+), 46 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio.h

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index c836a2a8986a..e29d3ed3a6ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -51,6 +51,20 @@ static void mt76_mmio_copy(struct mt76_dev *dev, u32 offset, const void *data,
 	__iowrite32_copy(mmio->regs + offset, data, len >> 2);
 }
 
+void mt76e_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set)
+{
+	struct mt76_mmio *mmio = &dev->mmio;
+	const int MT_INT_MASK_CSR = 0x0204;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mmio->irq_lock, flags);
+	mmio->irqmask &= ~clear;
+	mmio->irqmask |= set;
+	__mt76_wr(dev, MT_INT_MASK_CSR, mmio->irqmask);
+	spin_unlock_irqrestore(&mmio->irq_lock, flags);
+}
+EXPORT_SYMBOL_GPL(mt76e_set_irq_mask);
+
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 {
 	static const struct mt76_bus_ops mt76_mmio_ops = {
@@ -62,6 +76,7 @@ void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 
 	dev->bus = &mt76_mmio_ops;
 	dev->mmio.regs = regs;
+	spin_lock_init(&dev->mmio.irq_lock);
 }
 EXPORT_SYMBOL_GPL(mt76_mmio_init);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mmio.h b/drivers/net/wireless/mediatek/mt76/mmio.h
new file mode 100644
index 000000000000..7f01ba31b3e1
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mmio.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
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
+#ifndef __MT76_MMIO_H
+#define __MT76_MMIO_H
+
+#include "mt76.h"
+
+void mt76e_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set);
+
+static inline void mt76e_irq_enable(struct mt76_dev *dev, u32 mask)
+{
+	mt76e_set_irq_mask(dev, 0, mask);
+}
+
+static inline void mt76e_irq_disable(struct mt76_dev *dev, u32 mask)
+{
+	mt76e_set_irq_mask(dev, mask, 0);
+}
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2987ade3cb1a..064897439a29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -324,6 +324,9 @@ struct mt76_usb {
 };
 
 struct mt76_mmio {
+	spinlock_t irq_lock;
+	u32 irqmask;
+
 	void __iomem *regs;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 87b805637ff8..b71e4247d42a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -108,9 +108,6 @@ struct mt76x2_dev {
 
 	u32 aggr_stats[32];
 
-	spinlock_t irq_lock;
-	u32 irqmask;
-
 	struct sk_buff *beacons[8];
 	u8 beacon_mask;
 	u8 beacon_data_mask;
@@ -138,8 +135,6 @@ static inline bool is_mt7612(struct mt76x2_dev *dev)
 	return mt76_chip(&dev->mt76) == 0x7612;
 }
 
-void mt76x2_set_irq_mask(struct mt76x2_dev *dev, u32 clear, u32 set);
-
 static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
@@ -148,16 +143,6 @@ static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
 		chan->dfs_state != NL80211_DFS_AVAILABLE);
 }
 
-static inline void mt76x2_irq_enable(struct mt76x2_dev *dev, u32 mask)
-{
-	mt76x2_set_irq_mask(dev, 0, mask);
-}
-
-static inline void mt76x2_irq_disable(struct mt76x2_dev *dev, u32 mask)
-{
-	mt76x2_set_irq_mask(dev, mask, 0);
-}
-
 static inline bool mt76x2_wait_for_bbp(struct mt76x2_dev *dev)
 {
 	return mt76_poll_msec(dev, MT_MAC_STATUS,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
index 2629779e8d3e..aa1946fe6703 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
@@ -15,25 +15,15 @@
  */
 
 #include <linux/delay.h>
+#include "mmio.h"
 #include "mt76x2.h"
 #include "mt76x2_trace.h"
 
-void mt76x2_set_irq_mask(struct mt76x2_dev *dev, u32 clear, u32 set)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->irq_lock, flags);
-	dev->irqmask &= ~clear;
-	dev->irqmask |= set;
-	mt76_wr(dev, MT_INT_MASK_CSR, dev->irqmask);
-	spin_unlock_irqrestore(&dev->irq_lock, flags);
-}
-
 void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 {
 	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
 
-	mt76x2_irq_enable(dev, MT_INT_RX_DONE(q));
+	mt76e_irq_enable(&dev->mt76, MT_INT_RX_DONE(q));
 }
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
@@ -47,22 +37,22 @@ irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
 		return IRQ_NONE;
 
-	trace_dev_irq(dev, intr, dev->irqmask);
+	trace_dev_irq(dev, intr, dev->mt76.mmio.irqmask);
 
-	intr &= dev->irqmask;
+	intr &= dev->mt76.mmio.irqmask;
 
 	if (intr & MT_INT_TX_DONE_ALL) {
-		mt76x2_irq_disable(dev, MT_INT_TX_DONE_ALL);
+		mt76e_irq_disable(&dev->mt76, MT_INT_TX_DONE_ALL);
 		tasklet_schedule(&dev->tx_tasklet);
 	}
 
 	if (intr & MT_INT_RX_DONE(0)) {
-		mt76x2_irq_disable(dev, MT_INT_RX_DONE(0));
+		mt76e_irq_disable(&dev->mt76, MT_INT_RX_DONE(0));
 		napi_schedule(&dev->mt76.napi[0]);
 	}
 
 	if (intr & MT_INT_RX_DONE(1)) {
-		mt76x2_irq_disable(dev, MT_INT_RX_DONE(1));
+		mt76e_irq_disable(&dev->mt76, MT_INT_RX_DONE(1));
 		napi_schedule(&dev->mt76.napi[1]);
 	}
 
@@ -79,7 +69,7 @@ irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 	}
 
 	if (intr & MT_INT_GPTIMER) {
-		mt76x2_irq_disable(dev, MT_INT_GPTIMER);
+		mt76e_irq_disable(&dev->mt76, MT_INT_GPTIMER);
 		tasklet_schedule(&dev->dfs_pd.dfs_tasklet);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index 374cc655c11d..621946834102 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -15,6 +15,7 @@
  */
 
 #include "mt76x2.h"
+#include "mmio.h"
 
 #define RADAR_SPEC(m, len, el, eh, wl, wh,		\
 		   w_tolerance, tl, th, t_tolerance,	\
@@ -678,7 +679,7 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 	mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
 
 out:
-	mt76x2_irq_enable(dev, MT_INT_GPTIMER);
+	mt76e_irq_enable(&dev->mt76, MT_INT_GPTIMER);
 }
 
 static void mt76x2_dfs_init_sw_detector(struct mt76x2_dev *dev)
@@ -834,7 +835,7 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 		/* enable debug mode */
 		mt76x2_dfs_set_capture_mode_ctrl(dev, true);
 
-		mt76x2_irq_enable(dev, MT_INT_GPTIMER);
+		mt76e_irq_enable(&dev->mt76, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
 			       MT_INT_TIMER_EN_GP_TIMER_EN, 1);
 	} else {
@@ -844,7 +845,7 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 		mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
 		mt76_wr(dev, 0x212c, 0);
 
-		mt76x2_irq_disable(dev, MT_INT_GPTIMER);
+		mt76e_irq_disable(&dev->mt76, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
 			       MT_INT_TIMER_EN_GP_TIMER_EN, 0);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 8d9a599aa4ad..a85db9cb0163 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -16,6 +16,7 @@
 
 #include "mt76x2.h"
 #include "dma.h"
+#include "mmio.h"
 
 int
 mt76x2_tx_queue_mcu(struct mt76x2_dev *dev, enum mt76_txq_id qid,
@@ -60,7 +61,7 @@ mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 	if (ret)
 		return ret;
 
-	mt76x2_irq_enable(dev, MT_INT_TX_DONE(idx));
+	mt76e_irq_enable(&dev->mt76, MT_INT_TX_DONE(idx));
 
 	return 0;
 }
@@ -79,7 +80,7 @@ mt76x2_init_rx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 	if (ret)
 		return ret;
 
-	mt76x2_irq_enable(dev, MT_INT_RX_DONE(idx));
+	mt76e_irq_enable(&dev->mt76, MT_INT_RX_DONE(idx));
 
 	return 0;
 }
@@ -96,7 +97,7 @@ mt76x2_tx_tasklet(unsigned long data)
 		mt76_queue_tx_cleanup(dev, i, false);
 
 	mt76x2_mac_poll_tx_status(dev, false);
-	mt76x2_irq_enable(dev, MT_INT_TX_DONE_ALL);
+	mt76e_irq_enable(&dev->mt76, MT_INT_TX_DONE_ALL);
 }
 
 int mt76x2_dma_init(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 56a4b86bb665..65fdebd2eeff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -19,6 +19,7 @@
 #include "mt76x2_eeprom.h"
 #include "mt76x2_mcu.h"
 #include "mt76x02_util.h"
+#include "mmio.h"
 
 static void
 mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
@@ -221,8 +222,8 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 		MT_MAC_SYS_CTRL_ENABLE_TX |
 		MT_MAC_SYS_CTRL_ENABLE_RX);
 
-	mt76x2_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
-			       MT_INT_TX_STAT);
+	mt76e_irq_enable(&dev->mt76, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+				     MT_INT_TX_STAT);
 
 	return 0;
 }
@@ -437,7 +438,6 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 	dev = container_of(mdev, struct mt76x2_dev, mt76);
 	mdev->dev = pdev;
 	mdev->drv = &drv_ops;
-	spin_lock_init(&dev->irq_lock);
 
 	return dev;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 241ede98e6d3..dc5012202b41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -20,6 +20,7 @@
 #include "mt76x2_eeprom.h"
 #include "mt76x2_trace.h"
 #include "mt76x02_util.h"
+#include "mmio.h"
 
 void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 {
@@ -42,9 +43,9 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 	trace_mac_txstat_poll(dev);
 
 	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
-		spin_lock_irqsave(&dev->irq_lock, flags);
+		spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
 		ret = mt76x02_mac_load_tx_status(&dev->mt76, &stat);
-		spin_unlock_irqrestore(&dev->irq_lock, flags);
+		spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
 
 		if (!ret)
 			break;
@@ -202,9 +203,9 @@ void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val)
 	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
 
 	if (en)
-		mt76x2_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+		mt76e_irq_enable(&dev->mt76, MT_INT_PRE_TBTT | MT_INT_TBTT);
 	else
-		mt76x2_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+		mt76e_irq_disable(&dev->mt76, MT_INT_PRE_TBTT | MT_INT_TBTT);
 }
 
 void mt76x2_update_channel(struct mt76_dev *mdev)
-- 
2.7.5
