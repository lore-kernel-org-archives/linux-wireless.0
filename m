Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEF6C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14D5520652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:29:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14D5520652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbeJEP0c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:26:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39598 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbeJEP0b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:26:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id 61-v6so11874204wrb.6
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xkHeupsEFqQoSQtJV72r+Bbd7ULiQhUp5bY/bqZIRGg=;
        b=JEk7l0HfVi6dDXWWkhzskbxBG+26TYNtaxIlkSFBcfevaaFyp9rCEXhnqfGYkMXbsQ
         s/ttkPhnreDn6MBLcG3W+2LBGEzV1YsLYZrkEn+jRvooKR4bzutgc4FXSNi+FOHOnzVO
         X1hR7C+b+ePNfRiR2SExx/8l9AAo31fzrQenHcrgYXKi9QTf6ip0jCIeGj83YCVw6cM5
         3BZ+CoTKdIECz3jIlwAtSc255VrXkg8dGSHnNAGEAGWO+4+3EdkvDC9ZL8tBkcPcMzKj
         H8849RLfjNsGCPw9GYxdAOYoOEA5cdJiYpytNvP8S2FitplOM5zIGf2VwMi+C4UDousV
         RNhg==
X-Gm-Message-State: ABuFfoio4lUm0Usonq1y6ahQz40qBkGnMjIUgt1kI8T+JLAFpbwYYHXK
        DSk2kIc2BVjOrxVWKaF/CjZeww==
X-Google-Smtp-Source: ACcGV62MBgRTrrlst80JDmZJMvJGGTHi0O35jCErTyYqWTczwGkgIIA+iYbSt23JShs1cr6lKc2v1w==
X-Received: by 2002:a05:6000:12c5:: with SMTP id l5mr7260139wrx.215.1538728130636;
        Fri, 05 Oct 2018 01:28:50 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 77-v6sm3630227wmv.6.2018.10.05.01.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:28:49 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mmio.c
Date:   Fri,  5 Oct 2018 10:28:36 +0200
Message-Id: <ce40d4b515152475904938c75540b1aae7935162.1538726819.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
References: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_mmio.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  8 +--
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  7 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 70 +++++++++----------
 .../wireless/mediatek/mt76/mt76x2/pci_core.c  | 13 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |  6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_dma.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  4 +-
 10 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index c47ad67ce2ff..f723a07cab29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -517,8 +517,8 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 #define mt76xx_chip(dev) mt76_chip(&((dev)->mt76))
 #define mt76xx_rev(dev) mt76_rev(&((dev)->mt76))
 
-#define __mt76_init_queues(dev)		(dev)->queue_ops->init((dev))
-#define __mt76_queue_alloc(dev, ...)	(dev)->queue_ops->alloc((dev), __VA_ARGS__)
+#define mt76_init_queues(dev)		(dev)->mt76.queue_ops->init(&((dev)->mt76))
+#define mt76_queue_alloc(dev, ...)	(dev)->mt76.queue_ops->alloc(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_add_buf(dev, ...)	(dev)->mt76.queue_ops->add_buf(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 55c62e40499b..f817c870587d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -27,7 +27,7 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&dev->mt76.mutex);
 
-	mt76x02_mac_start(&dev->mt76);
+	mt76x02_mac_start(dev);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
@@ -85,12 +85,12 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 	if (!mt76x02_wait_for_mac(&dev->mt76))
 		return -ETIMEDOUT;
 
-	mt76x02_dma_disable(&dev->mt76);
+	mt76x02_dma_disable(dev);
 	err = mt76x0e_mcu_init(dev);
 	if (err < 0)
 		return err;
 
-	err = mt76x02_dma_init(&dev->mt76);
+	err = mt76x02_dma_init(dev);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3f76754b139f..d4dd4547bb06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -155,15 +155,15 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
-void mt76x02_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set);
-void mt76x02_mac_start(struct mt76_dev *dev);
+void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
+void mt76x02_mac_start(struct mt76x02_dev *dev);
 
-static inline void mt76x02_irq_enable(struct mt76_dev *dev, u32 mask)
+static inline void mt76x02_irq_enable(struct mt76x02_dev *dev, u32 mask)
 {
 	mt76x02_set_irq_mask(dev, 0, mask);
 }
 
-static inline void mt76x02_irq_disable(struct mt76_dev *dev, u32 mask)
+static inline void mt76x02_irq_disable(struct mt76x02_dev *dev, u32 mask)
 {
 	mt76x02_set_irq_mask(dev, mask, 0);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
index 65b97f5713d3..aa38ef9ec7d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
@@ -17,8 +17,8 @@
 #ifndef __MT76x02_DMA_H
 #define __MT76x02_DMA_H
 
+#include "mt76x02.h"
 #include "dma.h"
-#include "mt76x02_regs.h"
 
 #define MT_TXD_INFO_LEN			GENMASK(15, 0)
 #define MT_TXD_INFO_NEXT_VLD		BIT(16)
@@ -70,8 +70,7 @@ mt76x02_wait_for_wpdma(struct mt76_dev *dev, int timeout)
 			   0, timeout);
 }
 
-int mt76x02_dma_init(struct mt76_dev *dev);
-void mt76x02_dma_enable(struct mt76_dev *dev);
-void mt76x02_dma_disable(struct mt76_dev *dev);
+int mt76x02_dma_init(struct mt76x02_dev *dev);
+void mt76x02_dma_disable(struct mt76x02_dev *dev);
 
 #endif /* __MT76x02_DMA_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index af95b6708eaf..98aeb64d9c37 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -20,16 +20,16 @@
 #include "mt76x02.h"
 
 static int
-mt76x02_init_tx_queue(struct mt76_dev *dev, struct mt76_queue *q,
+mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 		      int idx, int n_desc)
 {
 	int ret;
 
-	q->regs = dev->mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
+	q->regs = dev->mt76.mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
 	q->ndesc = n_desc;
 	q->hw_idx = idx;
 
-	ret = __mt76_queue_alloc(dev, q);
+	ret = mt76_queue_alloc(dev, q);
 	if (ret)
 		return ret;
 
@@ -39,16 +39,16 @@ mt76x02_init_tx_queue(struct mt76_dev *dev, struct mt76_queue *q,
 }
 
 static int
-mt76x02_init_rx_queue(struct mt76_dev *dev, struct mt76_queue *q,
+mt76x02_init_rx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 		      int idx, int n_desc, int bufsize)
 {
 	int ret;
 
-	q->regs = dev->mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
+	q->regs = dev->mt76.mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
 	q->ndesc = n_desc;
 	q->buf_size = bufsize;
 
-	ret = __mt76_queue_alloc(dev, q);
+	ret = mt76_queue_alloc(dev, q);
 	if (ret)
 		return ret;
 
@@ -57,7 +57,7 @@ mt76x02_init_rx_queue(struct mt76_dev *dev, struct mt76_queue *q,
 	return 0;
 }
 
-int mt76x02_dma_init(struct mt76_dev *dev)
+int mt76x02_dma_init(struct mt76x02_dev *dev)
 {
 	struct mt76_txwi_cache __maybe_unused *t;
 	struct mt76_queue *q;
@@ -66,91 +66,91 @@ int mt76x02_dma_init(struct mt76_dev *dev)
 	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x02_txwi));
 	BUILD_BUG_ON(sizeof(struct mt76x02_rxwi) > MT_RX_HEADROOM);
 
-	mt76_dma_attach(dev);
-	__mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
+	mt76_dma_attach(&dev->mt76);
+	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		ret = mt76x02_init_tx_queue(dev, &dev->q_tx[i],
+		ret = mt76x02_init_tx_queue(dev, &dev->mt76.q_tx[i],
 					    mt76_ac_to_hwq(i),
 					    MT_TX_RING_SIZE);
 		if (ret)
 			return ret;
 	}
 
-	ret = mt76x02_init_tx_queue(dev, &dev->q_tx[MT_TXQ_PSD],
+	ret = mt76x02_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_PSD],
 				    MT_TX_HW_QUEUE_MGMT, MT_TX_RING_SIZE);
 	if (ret)
 		return ret;
 
-	ret = mt76x02_init_tx_queue(dev, &dev->q_tx[MT_TXQ_MCU],
+	ret = mt76x02_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_MCU],
 				    MT_TX_HW_QUEUE_MCU, MT_MCU_RING_SIZE);
 	if (ret)
 		return ret;
 
-	ret = mt76x02_init_rx_queue(dev, &dev->q_rx[MT_RXQ_MCU], 1,
+	ret = mt76x02_init_rx_queue(dev, &dev->mt76.q_rx[MT_RXQ_MCU], 1,
 				    MT_MCU_RING_SIZE, MT_RX_BUF_SIZE);
 	if (ret)
 		return ret;
 
-	q = &dev->q_rx[MT_RXQ_MAIN];
+	q = &dev->mt76.q_rx[MT_RXQ_MAIN];
 	q->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x02_rxwi);
 	ret = mt76x02_init_rx_queue(dev, q, 0, MT76X02_RX_RING_SIZE,
 				    MT_RX_BUF_SIZE);
 	if (ret)
 		return ret;
 
-	return __mt76_init_queues(dev);
+	return mt76_init_queues(dev);
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_init);
 
-void mt76x02_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set)
+void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->mmio.irq_lock, flags);
-	dev->mmio.irqmask &= ~clear;
-	dev->mmio.irqmask |= set;
-	__mt76_wr(dev, MT_INT_MASK_CSR, dev->mmio.irqmask);
-	spin_unlock_irqrestore(&dev->mmio.irq_lock, flags);
+	spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
+	dev->mt76.mmio.irqmask &= ~clear;
+	dev->mt76.mmio.irqmask |= set;
+	mt76_wr(dev, MT_INT_MASK_CSR, dev->mt76.mmio.irqmask);
+	spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
 }
 EXPORT_SYMBOL_GPL(mt76x02_set_irq_mask);
 
-void mt76x02_dma_enable(struct mt76_dev *dev)
+static void mt76x02_dma_enable(struct mt76x02_dev *dev)
 {
 	u32 val;
 
-	__mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
-	mt76x02_wait_for_wpdma(dev, 1000);
+	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+	mt76x02_wait_for_wpdma(&dev->mt76, 1000);
 	usleep_range(50, 100);
 
 	val = FIELD_PREP(MT_WPDMA_GLO_CFG_DMA_BURST_SIZE, 3) |
 	      MT_WPDMA_GLO_CFG_TX_DMA_EN |
 	      MT_WPDMA_GLO_CFG_RX_DMA_EN;
-	__mt76_set(dev, MT_WPDMA_GLO_CFG, val);
-	__mt76_clear(dev, MT_WPDMA_GLO_CFG,
-		     MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+	mt76_set(dev, MT_WPDMA_GLO_CFG, val);
+	mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		   MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_enable);
 
-void mt76x02_dma_disable(struct mt76_dev *dev)
+void mt76x02_dma_disable(struct mt76x02_dev *dev)
 {
-	u32 val = __mt76_rr(dev, MT_WPDMA_GLO_CFG);
+	u32 val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
 
 	val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
 	       MT_WPDMA_GLO_CFG_BIG_ENDIAN |
 	       MT_WPDMA_GLO_CFG_HDR_SEG_LEN;
 	val |= MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE;
-	__mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
+	mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_disable);
 
-void mt76x02_mac_start(struct mt76_dev *dev)
+void mt76x02_mac_start(struct mt76x02_dev *dev)
 {
 	mt76x02_dma_enable(dev);
-	__mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
-	__mt76_wr(dev, MT_MAC_SYS_CTRL,
-		  MT_MAC_SYS_CTRL_ENABLE_TX |
-		  MT_MAC_SYS_CTRL_ENABLE_RX);
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX |
+		MT_MAC_SYS_CTRL_ENABLE_RX);
 	mt76x02_irq_enable(dev,
 			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
 			   MT_INT_TX_STAT);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
index 2abd891f229a..775ff0a43010 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
@@ -20,7 +20,10 @@
 
 void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 {
-	mt76x02_irq_enable(mdev, MT_INT_RX_DONE(q));
+	struct mt76x02_dev *dev;
+
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+	mt76x02_irq_enable(dev, MT_INT_RX_DONE(q));
 }
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
@@ -39,17 +42,17 @@ irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 	intr &= dev->mt76.mmio.irqmask;
 
 	if (intr & MT_INT_TX_DONE_ALL) {
-		mt76x02_irq_disable(&dev->mt76, MT_INT_TX_DONE_ALL);
+		mt76x02_irq_disable(dev, MT_INT_TX_DONE_ALL);
 		tasklet_schedule(&dev->tx_tasklet);
 	}
 
 	if (intr & MT_INT_RX_DONE(0)) {
-		mt76x02_irq_disable(&dev->mt76, MT_INT_RX_DONE(0));
+		mt76x02_irq_disable(dev, MT_INT_RX_DONE(0));
 		napi_schedule(&dev->mt76.napi[0]);
 	}
 
 	if (intr & MT_INT_RX_DONE(1)) {
-		mt76x02_irq_disable(&dev->mt76, MT_INT_RX_DONE(1));
+		mt76x02_irq_disable(dev, MT_INT_RX_DONE(1));
 		napi_schedule(&dev->mt76.napi[1]);
 	}
 
@@ -66,7 +69,7 @@ irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 	}
 
 	if (intr & MT_INT_GPTIMER) {
-		mt76x02_irq_disable(&dev->mt76, MT_INT_GPTIMER);
+		mt76x02_irq_disable(dev, MT_INT_GPTIMER);
 		tasklet_schedule(&dev->dfs_pd.dfs_tasklet);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
index c0a3485e96f6..b56febae8945 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
@@ -679,7 +679,7 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 	mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
 
 out:
-	mt76x02_irq_enable(&dev->mt76, MT_INT_GPTIMER);
+	mt76x02_irq_enable(dev, MT_INT_GPTIMER);
 }
 
 static void mt76x2_dfs_init_sw_detector(struct mt76x02_dev *dev)
@@ -835,7 +835,7 @@ void mt76x2_dfs_init_params(struct mt76x02_dev *dev)
 		/* enable debug mode */
 		mt76x2_dfs_set_capture_mode_ctrl(dev, true);
 
-		mt76x02_irq_enable(&dev->mt76, MT_INT_GPTIMER);
+		mt76x02_irq_enable(dev, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
 			       MT_INT_TIMER_EN_GP_TIMER_EN, 1);
 	} else {
@@ -845,7 +845,7 @@ void mt76x2_dfs_init_params(struct mt76x02_dev *dev)
 		mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
 		mt76_wr(dev, 0x212c, 0);
 
-		mt76x02_irq_disable(&dev->mt76, MT_INT_GPTIMER);
+		mt76x02_irq_disable(dev, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
 			       MT_INT_TIMER_EN_GP_TIMER_EN, 0);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
index bfb590d6f288..1ac0df9a7928 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
@@ -27,7 +27,7 @@ void mt76x2_tx_tasklet(unsigned long data)
 		mt76_queue_tx_cleanup(dev, i, false);
 
 	mt76x02_mac_poll_tx_status(dev, false);
-	mt76x02_irq_enable(&dev->mt76, MT_INT_TX_DONE_ALL);
+	mt76x02_irq_enable(dev, MT_INT_TX_DONE_ALL);
 }
 
 void mt76x2_dma_cleanup(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 404f5b6adc46..78fdc4754b77 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -186,7 +186,7 @@ int mt76x2_mac_start(struct mt76x02_dev *dev)
 		mt76_rr(dev, MT_TX_STAT_FIFO);
 
 	memset(dev->aggr_stats, 0, sizeof(dev->aggr_stats));
-	mt76x02_mac_start(&dev->mt76);
+	mt76x02_mac_start(dev);
 
 	return 0;
 }
@@ -301,7 +301,7 @@ int mt76x2_init_hardware(struct mt76x02_dev *dev)
 	tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
 		     (unsigned long) dev);
 
-	mt76x02_dma_disable(&dev->mt76);
+	mt76x02_dma_disable(dev);
 	mt76x2_reset_wlan(dev, true);
 	mt76x2_power_on(dev);
 
@@ -315,7 +315,7 @@ int mt76x2_init_hardware(struct mt76x02_dev *dev)
 
 	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
-	ret = mt76x02_dma_init(&dev->mt76);
+	ret = mt76x02_dma_init(dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 458e168bdf0e..710e91ca4af1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -142,9 +142,9 @@ void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev,
 	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
 
 	if (en)
-		mt76x02_irq_enable(&dev->mt76, MT_INT_PRE_TBTT | MT_INT_TBTT);
+		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
 	else
-		mt76x02_irq_disable(&dev->mt76, MT_INT_PRE_TBTT | MT_INT_TBTT);
+		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
 }
 
 void mt76x2_update_channel(struct mt76_dev *mdev)
-- 
2.17.1

