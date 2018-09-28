Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A10C04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3645D2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3645D2172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbeI1NCr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38417 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbeI1NCr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id j8-v6so5078114wrw.5
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eJkTtJpDx5qdE9LMKNDRmUQEYLts68y28AIx8PiQLJQ=;
        b=twZZSVfV6+rweDpwEP4V0MZyV5yj2+pqw40TjsbZSko0pmh7F4EhyFbt21/kzKz5ic
         u0P4WbpMQGlgKVKcd7cGHd1q/Cgtx2kVwk3pJRVWxT3xfl4Micm+Wr3k12yam3CKbPxx
         dn9YY2NoxgYeb0vJ3TBrzk0xL+g7q/JytI51shKjh/9lyW/PXq5XNV5L8389vtGT4784
         u1HXAIcHoV3tfEy9C4MtzHpeFKjyTiVO1vTctwH4IPlZyqtix672JS2HrliiYiQLNexZ
         xAlBAaMQGfWTOZt/3jwY1goICuhZTvM2rRxaxZB0IofFzwK3oHuctmS3RE1iH9STMqzn
         2heQ==
X-Gm-Message-State: ABuFfojGasZ40KsMC2++IcJE+XDM7tNvIRcqe0uEoGGiSWxUGBVkEu8n
        sKPCKHHdBAsx5s89gWX1ooFzFZf68yc=
X-Google-Smtp-Source: ACcGV60E/Ts7FJLChmYVJfavavNfwQmZXXM7KurjhH+MkBTyY4w8476XZTV6aasUf078/KHZaM+4EA==
X-Received: by 2002:adf:eb0d:: with SMTP id s13-v6mr11018103wrn.174.1538116832894;
        Thu, 27 Sep 2018 23:40:32 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:32 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 05/24] mt76: move queue initialization in mt76x02_mmio.c
Date:   Fri, 28 Sep 2018 08:39:58 +0200
Message-Id: <20180928064017.26870-6-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_dma_init, mt76x02_init_rx_queue and mt76x02_init_tx_queue
routines in mt76x02-lib module in order to be reused by mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  4 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 87 +++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  5 +-
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   | 88 +------------------
 .../net/wireless/mediatek/mt76/mt76x2_init.c  |  3 +-
 6 files changed, 96 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index d747d60d59ea..9b800f009e6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -518,8 +518,8 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 #define mt76xx_chip(dev) mt76_chip(&((dev)->mt76))
 #define mt76xx_rev(dev) mt76_rev(&((dev)->mt76))
 
-#define mt76_init_queues(dev)		(dev)->mt76.queue_ops->init(&((dev)->mt76))
-#define mt76_queue_alloc(dev, ...)	(dev)->mt76.queue_ops->alloc(&((dev)->mt76), __VA_ARGS__)
+#define __mt76_init_queues(dev)		(dev)->queue_ops->init((dev))
+#define __mt76_queue_alloc(dev, ...)	(dev)->queue_ops->alloc((dev), __VA_ARGS__)
 #define mt76_queue_add_buf(dev, ...)	(dev)->mt76.queue_ops->add_buf(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
index 0b78857c9b4c..65b97f5713d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
@@ -48,6 +48,9 @@
 #define MT_MCU_MSG_TYPE			GENMASK(31, 30)
 #define MT_MCU_MSG_TYPE_CMD		BIT(30)
 
+#define MT_RX_HEADROOM			32
+#define MT76X02_RX_RING_SIZE		256
+
 enum dma_msg_port {
 	WLAN_PORT,
 	CPU_RX_PORT,
@@ -67,6 +70,7 @@ mt76x02_wait_for_wpdma(struct mt76_dev *dev, int timeout)
 			   0, timeout);
 }
 
+int mt76x02_dma_init(struct mt76_dev *dev);
 void mt76x02_dma_enable(struct mt76_dev *dev);
 void mt76x02_dma_disable(struct mt76_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 1b0dc6b0ecf3..8c083d2def37 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -19,7 +19,92 @@
 
 #include "mt76.h"
 #include "mt76x02_dma.h"
-#include "mt76x02_regs.h"
+#include "mt76x02_util.h"
+#include "mt76x02_mac.h"
+
+static int
+mt76x02_init_tx_queue(struct mt76_dev *dev, struct mt76_queue *q,
+		      int idx, int n_desc)
+{
+	int ret;
+
+	q->regs = dev->mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+	q->hw_idx = idx;
+
+	ret = __mt76_queue_alloc(dev, q);
+	if (ret)
+		return ret;
+
+	mt76x02_irq_enable(dev, MT_INT_TX_DONE(idx));
+
+	return 0;
+}
+
+static int
+mt76x02_init_rx_queue(struct mt76_dev *dev, struct mt76_queue *q,
+		      int idx, int n_desc, int bufsize)
+{
+	int ret;
+
+	q->regs = dev->mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+	q->buf_size = bufsize;
+
+	ret = __mt76_queue_alloc(dev, q);
+	if (ret)
+		return ret;
+
+	mt76x02_irq_enable(dev, MT_INT_RX_DONE(idx));
+
+	return 0;
+}
+
+int mt76x02_dma_init(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache __maybe_unused *t;
+	struct mt76_queue *q;
+	int i, ret;
+
+	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x02_txwi));
+	BUILD_BUG_ON(sizeof(struct mt76x02_rxwi) > MT_RX_HEADROOM);
+
+	mt76_dma_attach(dev);
+	__mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		ret = mt76x02_init_tx_queue(dev, &dev->q_tx[i],
+					    mt76_ac_to_hwq(i),
+					    MT_TX_RING_SIZE);
+		if (ret)
+			return ret;
+	}
+
+	ret = mt76x02_init_tx_queue(dev, &dev->q_tx[MT_TXQ_PSD],
+				    MT_TX_HW_QUEUE_MGMT, MT_TX_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt76x02_init_tx_queue(dev, &dev->q_tx[MT_TXQ_MCU],
+				    MT_TX_HW_QUEUE_MCU, MT_MCU_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt76x02_init_rx_queue(dev, &dev->q_rx[MT_RXQ_MCU], 1,
+				    MT_MCU_RING_SIZE, MT_RX_BUF_SIZE);
+	if (ret)
+		return ret;
+
+	q = &dev->q_rx[MT_RXQ_MAIN];
+	q->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x02_rxwi);
+	ret = mt76x02_init_rx_queue(dev, q, 0, MT76X02_RX_RING_SIZE,
+				    MT_RX_BUF_SIZE);
+	if (ret)
+		return ret;
+
+	return __mt76_init_queues(dev);
+}
+EXPORT_SYMBOL_GPL(mt76x02_dma_init);
 
 void mt76x02_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 2597bf43c2fe..1798f418c69d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -35,9 +35,6 @@
 #define MT7662U_FIRMWARE	"mediatek/mt7662u.bin"
 #define MT7662U_ROM_PATCH	"mediatek/mt7662u_rom_patch.bin"
 
-#define MT76x2_RX_RING_SIZE	256
-#define MT_RX_HEADROOM		32
-
 #define MT_MAX_CHAINS		2
 
 #define MT_CALIBRATE_INTERVAL	HZ
@@ -165,7 +162,7 @@ int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
 int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
 		       u8 channel);
 
-int mt76x2_dma_init(struct mt76x2_dev *dev);
+void mt76x2_tx_tasklet(unsigned long data);
 void mt76x2_dma_cleanup(struct mt76x2_dev *dev);
 
 void mt76x2_cleanup(struct mt76x2_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 45bed7cbcdec..7e5eccda47f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -18,46 +18,7 @@
 #include "mt76x02_dma.h"
 #include "mt76x02_util.h"
 
-static int
-mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
-		     int idx, int n_desc)
-{
-	int ret;
-
-	q->regs = dev->mt76.mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->hw_idx = idx;
-
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
-
-	mt76x02_irq_enable(&dev->mt76, MT_INT_TX_DONE(idx));
-
-	return 0;
-}
-
-static int
-mt76x2_init_rx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
-		     int idx, int n_desc, int bufsize)
-{
-	int ret;
-
-	q->regs = dev->mt76.mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->buf_size = bufsize;
-
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
-
-	mt76x02_irq_enable(&dev->mt76, MT_INT_RX_DONE(idx));
-
-	return 0;
-}
-
-static void
-mt76x2_tx_tasklet(unsigned long data)
+void mt76x2_tx_tasklet(unsigned long data)
 {
 	struct mt76x2_dev *dev = (struct mt76x2_dev *) data;
 	int i;
@@ -71,53 +32,6 @@ mt76x2_tx_tasklet(unsigned long data)
 	mt76x02_irq_enable(&dev->mt76, MT_INT_TX_DONE_ALL);
 }
 
-int mt76x2_dma_init(struct mt76x2_dev *dev)
-{
-	int ret;
-	int i;
-	struct mt76_txwi_cache __maybe_unused *t;
-	struct mt76_queue *q;
-
-	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x02_txwi));
-	BUILD_BUG_ON(sizeof(struct mt76x02_rxwi) > MT_RX_HEADROOM);
-
-	mt76_dma_attach(&dev->mt76);
-
-	tasklet_init(&dev->tx_tasklet, mt76x2_tx_tasklet, (unsigned long) dev);
-
-	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
-
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		ret = mt76x2_init_tx_queue(dev, &dev->mt76.q_tx[i],
-					   mt76_ac_to_hwq(i), MT_TX_RING_SIZE);
-		if (ret)
-			return ret;
-	}
-
-	ret = mt76x2_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_PSD],
-				   MT_TX_HW_QUEUE_MGMT, MT_TX_RING_SIZE);
-	if (ret)
-		return ret;
-
-	ret = mt76x2_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_MCU],
-				   MT_TX_HW_QUEUE_MCU, MT_MCU_RING_SIZE);
-	if (ret)
-		return ret;
-
-	ret = mt76x2_init_rx_queue(dev, &dev->mt76.q_rx[MT_RXQ_MCU], 1,
-				   MT_MCU_RING_SIZE, MT_RX_BUF_SIZE);
-	if (ret)
-		return ret;
-
-	q = &dev->mt76.q_rx[MT_RXQ_MAIN];
-	q->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x02_rxwi);
-	ret = mt76x2_init_rx_queue(dev, q, 0, MT76x2_RX_RING_SIZE, MT_RX_BUF_SIZE);
-	if (ret)
-		return ret;
-
-	return mt76_init_queues(dev);
-}
-
 void mt76x2_dma_cleanup(struct mt76x2_dev *dev)
 {
 	tasklet_kill(&dev->tx_tasklet);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index d4134e322ff4..98e40f6045b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -366,7 +366,7 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 
 	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
-	ret = mt76x2_dma_init(dev);
+	ret = mt76x02_dma_init(&dev->mt76);
 	if (ret)
 		return ret;
 
@@ -525,6 +525,7 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	if (!status_fifo)
 		return -ENOMEM;
 
+	tasklet_init(&dev->tx_tasklet, mt76x2_tx_tasklet, (unsigned long)dev);
 	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
 	INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
-- 
2.19.0

