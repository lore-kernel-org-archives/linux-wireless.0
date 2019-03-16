Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FDBC10F03
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ECE8218D4
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="QEs489Nr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfCPUmq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:42:46 -0400
Received: from nbd.name ([46.4.11.11]:39540 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfCPUmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1OB/lAtvpr5VHZVDVN2/nietzOKLW/99e5fva5GgaQk=; b=QEs489NrPdd9u9D5pIVINFqkJ2
        Vz4Mpejx0lTNeVO/YA9Gt8vgcPUqF/nAiiFm6DLcDDKLw/ceeZ2OQeV8itxJWC0jiyeW9Qt3nr5jV
        vIKL/5t8eJZeEZniqvwLS2jBY+rqDsncnh0KexGjerc3aCw9KSNhgD9Jm2cYgDFLL1Xg=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5G8h-0005S0-OF
        for linux-wireless@vger.kernel.org; Sat, 16 Mar 2019 21:42:43 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CA357530F04C; Sat, 16 Mar 2019 21:42:42 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] mt76: move tx tasklet to struct mt76_dev
Date:   Sat, 16 Mar 2019 21:42:41 +0100
Message-Id: <20190316204242.73560-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316204242.73560-1-nbd@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allows it to be scheduled from core code

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h         |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt7603/core.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c   |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c   |  6 +++---
 .../net/wireless/mediatek/mt76/mt7603/mt7603.h    |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 15 ++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/usb.c          |  6 +++---
 9 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 6bee65edb26a..54e1e50eb4d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -396,7 +396,6 @@ struct mt76_usb {
 	u8 data[32];
 
 	struct tasklet_struct rx_tasklet;
-	struct tasklet_struct tx_tasklet;
 	struct delayed_work stat_work;
 
 	u8 out_ep[__MT_EP_OUT_MAX];
@@ -458,6 +457,8 @@ struct mt76_dev {
 	const struct mt76_queue_ops *queue_ops;
 	int tx_dma_idx[4];
 
+	struct tasklet_struct tx_tasklet;
+
 	wait_queue_head_t tx_wait;
 	struct sk_buff_head status_list;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/core.c b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
index 4668c573f74a..0d06ff67ce44 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
@@ -35,7 +35,7 @@ irqreturn_t mt7603_irq_handler(int irq, void *dev_instance)
 
 	if (intr & MT_INT_TX_DONE_ALL) {
 		mt7603_irq_disable(dev, MT_INT_TX_DONE_ALL);
-		tasklet_schedule(&dev->tx_tasklet);
+		tasklet_schedule(&dev->mt76.tx_tasklet);
 	}
 
 	if (intr & MT_INT_RX_DONE(0)) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 37cedfcedce4..f7e3566c96fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -164,7 +164,7 @@ int mt7603_dma_init(struct mt7603_dev *dev)
 	init_waitqueue_head(&dev->mt76.mmio.mcu.wait);
 	skb_queue_head_init(&dev->mt76.mmio.mcu.res_q);
 
-	tasklet_init(&dev->tx_tasklet, mt7603_tx_tasklet, (unsigned long)dev);
+	tasklet_init(&dev->mt76.tx_tasklet, mt7603_tx_tasklet, (unsigned long)dev);
 
 	mt76_clear(dev, MT_WPDMA_GLO_CFG,
 		   MT_WPDMA_GLO_CFG_TX_DMA_EN |
@@ -224,6 +224,6 @@ void mt7603_dma_cleanup(struct mt7603_dev *dev)
 		   MT_WPDMA_GLO_CFG_RX_DMA_EN |
 		   MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
 
-	tasklet_kill(&dev->tx_tasklet);
+	tasklet_kill(&dev->mt76.tx_tasklet);
 	mt76_dma_cleanup(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index fb1961ac9dc6..2badfe527397 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1306,7 +1306,7 @@ static void mt7603_mac_watchdog_reset(struct mt7603_dev *dev)
 	/* lock/unlock all queues to ensure that no tx is pending */
 	mt76_txq_schedule_all(&dev->mt76);
 
-	tasklet_disable(&dev->tx_tasklet);
+	tasklet_disable(&dev->mt76.tx_tasklet);
 	tasklet_disable(&dev->pre_tbtt_tasklet);
 	napi_disable(&dev->mt76.napi[0]);
 	napi_disable(&dev->mt76.napi[1]);
@@ -1353,8 +1353,8 @@ static void mt7603_mac_watchdog_reset(struct mt7603_dev *dev)
 	clear_bit(MT76_RESET, &dev->mt76.state);
 	mutex_unlock(&dev->mt76.mutex);
 
-	tasklet_enable(&dev->tx_tasklet);
-	tasklet_schedule(&dev->tx_tasklet);
+	tasklet_enable(&dev->mt76.tx_tasklet);
+	tasklet_schedule(&dev->mt76.tx_tasklet);
 
 	tasklet_enable(&dev->pre_tbtt_tasklet);
 	mt7603_beacon_set_timer(dev, -1, beacon_int);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 9cc8ca7a4d1c..3848a011105f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -145,7 +145,6 @@ struct mt7603_dev {
 	unsigned int reset_cause[__RESET_CAUSE_MAX];
 
 	struct delayed_work mac_work;
-	struct tasklet_struct tx_tasklet;
 	struct tasklet_struct pre_tbtt_tasklet;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 91718647da02..ff887454e51e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -326,7 +326,7 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 		goto err;
 
 	tasklet_enable(&usb->rx_tasklet);
-	tasklet_enable(&usb->tx_tasklet);
+	tasklet_enable(&dev->mt76.tx_tasklet);
 
 	ret = mt76x0u_init_hardware(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 736a77936249..1e82b99d0789 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -229,7 +229,8 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 	if (!status_fifo)
 		return -ENOMEM;
 
-	tasklet_init(&dev->tx_tasklet, mt76x02_tx_tasklet, (unsigned long) dev);
+	tasklet_init(&dev->mt76.tx_tasklet, mt76x02_tx_tasklet,
+		     (unsigned long) dev);
 	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
 		     (unsigned long)dev);
 
@@ -299,7 +300,7 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 
 	if (intr & MT_INT_TX_DONE_ALL) {
 		mt76x02_irq_disable(dev, MT_INT_TX_DONE_ALL);
-		tasklet_schedule(&dev->tx_tasklet);
+		tasklet_schedule(&dev->mt76.tx_tasklet);
 	}
 
 	if (intr & MT_INT_RX_DONE(0)) {
@@ -325,7 +326,7 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 
 	if (intr & MT_INT_TX_STAT) {
 		mt76x02_mac_poll_tx_status(dev, true);
-		tasklet_schedule(&dev->tx_tasklet);
+		tasklet_schedule(&dev->mt76.tx_tasklet);
 	}
 
 	if (intr & MT_INT_GPTIMER) {
@@ -355,7 +356,7 @@ static void mt76x02_dma_enable(struct mt76x02_dev *dev)
 
 void mt76x02_dma_cleanup(struct mt76x02_dev *dev)
 {
-	tasklet_kill(&dev->tx_tasklet);
+	tasklet_kill(&dev->mt76.tx_tasklet);
 	mt76_dma_cleanup(&dev->mt76);
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_cleanup);
@@ -476,7 +477,7 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 	set_bit(MT76_RESET, &dev->mt76.state);
 
 	tasklet_disable(&dev->pre_tbtt_tasklet);
-	tasklet_disable(&dev->tx_tasklet);
+	tasklet_disable(&dev->mt76.tx_tasklet);
 
 	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++)
 		napi_disable(&dev->mt76.napi[i]);
@@ -529,8 +530,8 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 
 	clear_bit(MT76_RESET, &dev->mt76.state);
 
-	tasklet_enable(&dev->tx_tasklet);
-	tasklet_schedule(&dev->tx_tasklet);
+	tasklet_enable(&dev->mt76.tx_tasklet);
+	tasklet_schedule(&dev->mt76.tx_tasklet);
 
 	tasklet_enable(&dev->pre_tbtt_tasklet);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 7a5d539873ca..77575727df47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -117,7 +117,7 @@ static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
 		goto err;
 
 	tasklet_enable(&usb->rx_tasklet);
-	tasklet_enable(&usb->tx_tasklet);
+	tasklet_enable(&dev->mt76.tx_tasklet);
 
 	err = mt76x2u_init_hardware(dev);
 	if (err < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 2dbd8dfd62a0..ac03acdae279 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -713,7 +713,7 @@ static void mt76u_complete_tx(struct urb *urb)
 		dev_err(dev->dev, "tx urb failed: %d\n", urb->status);
 	buf->done = true;
 
-	tasklet_schedule(&dev->usb.tx_tasklet);
+	tasklet_schedule(&dev->tx_tasklet);
 }
 
 static int
@@ -859,7 +859,7 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
 void mt76u_stop_queues(struct mt76_dev *dev)
 {
 	tasklet_disable(&dev->usb.rx_tasklet);
-	tasklet_disable(&dev->usb.tx_tasklet);
+	tasklet_disable(&dev->tx_tasklet);
 
 	mt76u_stop_rx(dev);
 	mt76u_stop_tx(dev);
@@ -914,7 +914,7 @@ int mt76u_init(struct mt76_dev *dev,
 	struct mt76_usb *usb = &dev->usb;
 
 	tasklet_init(&usb->rx_tasklet, mt76u_rx_tasklet, (unsigned long)dev);
-	tasklet_init(&usb->tx_tasklet, mt76u_tx_tasklet, (unsigned long)dev);
+	tasklet_init(&dev->tx_tasklet, mt76u_tx_tasklet, (unsigned long)dev);
 	INIT_DELAYED_WORK(&usb->stat_work, mt76u_tx_status_data);
 	skb_queue_head_init(&dev->rx_skb[MT_RXQ_MAIN]);
 
-- 
2.17.0

