Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C8AC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D63102172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D63102172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbeI1NCr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53868 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeI1NCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id b19-v6so1033644wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuqXWE2gLkvy2/J4nuQv49It3QiZjmU4ZTsbej9DK8E=;
        b=n6BstByveWOG5nFLHjaj0R3NuL+YTPuAEg359PCZJQzt+iX+frr5OM3F46AsFJ5XS9
         sw1UhLMjhevsLv1fGkOqRz1xdLmAyWOjC921NoXL7mkjBSLY0Qmz2Jw/EHvu/yWt++Dy
         12O7v/OuaiJxUVfpHpdgI9YOGUZkz5pGYAySvxW9prloEv6MsKxeLX9I2AxpDPbU41Z4
         sRCKu+zMY1GeFFD1ZZewb1ZQKEF8qt4HiQlVaG8kVJdyVCDFZZyiInaTiB3I5tAThmU5
         pt07mbX1wMslXcCe/+2Q4sPQa/InodOzcdb+0rZ+Jb294bumHls5ghP+k4kwBH9Qz9ks
         MWDQ==
X-Gm-Message-State: ABuFfoh0VK+PyvwYudE3xIt64okIcxaQxeuY4VFyuWAQXHGjYsk0w4gD
        S+moNjihe0bSDER9cgXBOQEThdEl0aM=
X-Google-Smtp-Source: ACcGV63YQv/gYiJIKLftqTtOky9vkTfpgUuJWyxs88c+1JgGgEWWCpHOsR/xlXT9c9eVBl+lg40Qow==
X-Received: by 2002:a1c:2905:: with SMTP id p5-v6mr661183wmp.1.1538116831864;
        Thu, 27 Sep 2018 23:40:31 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:31 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 04/24] mt76: move mt76x02_set_irq_mask in mt76x02_mmio.c
Date:   Fri, 28 Sep 2018 08:39:57 +0200
Message-Id: <20180928064017.26870-5-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_set_irq_mask, mt76x02_irq_enable and mt76x02_irq_disable
in mt76x02-lib module in order to be reused by mt76x0 driver.
Moreover move irq_lock and irqmask in mt76_mmio data structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mmio.c     |  1 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 12 ++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.h | 13 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h   | 15 ----------
 .../net/wireless/mediatek/mt76/mt76x2_core.c  | 28 ++++++-------------
 .../net/wireless/mediatek/mt76/mt76x2_dfs.c   |  7 +++--
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   |  7 +++--
 .../net/wireless/mediatek/mt76/mt76x2_init.c  |  6 ++--
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   |  8 +++---
 10 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 2f09f451a9b6..08685f515bf6 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -60,6 +60,7 @@ void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 
 	skb_queue_head_init(&dev->mmio.mcu.res_q);
 	init_waitqueue_head(&dev->mmio.mcu.wait);
+	spin_lock_init(&dev->mmio.irq_lock);
 	mutex_init(&dev->mmio.mcu.mutex);
 }
 EXPORT_SYMBOL_GPL(mt76_mmio_init);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 8031360a6592..d747d60d59ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -363,6 +363,8 @@ struct mt76_mmio {
 		u32 msg_seq;
 	} mcu;
 	void __iomem *regs;
+	spinlock_t irq_lock;
+	u32 irqmask;
 };
 
 struct mt76_dev {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index f471c3a0674a..1b0dc6b0ecf3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -21,6 +21,18 @@
 #include "mt76x02_dma.h"
 #include "mt76x02_regs.h"
 
+void mt76x02_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->mmio.irq_lock, flags);
+	dev->mmio.irqmask &= ~clear;
+	dev->mmio.irqmask |= set;
+	__mt76_wr(dev, MT_INT_MASK_CSR, dev->mmio.irqmask);
+	spin_unlock_irqrestore(&dev->mmio.irq_lock, flags);
+}
+EXPORT_SYMBOL_GPL(mt76x02_set_irq_mask);
+
 void mt76x02_dma_enable(struct mt76_dev *dev)
 {
 	u32 val;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 2ea9e68bfa3f..2c1ead85077e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -51,4 +51,17 @@ void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
 void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
+
+void mt76x02_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set);
+
+static inline void mt76x02_irq_enable(struct mt76_dev *dev, u32 mask)
+{
+	mt76x02_set_irq_mask(dev, 0, mask);
+}
+
+static inline void mt76x02_irq_disable(struct mt76_dev *dev, u32 mask)
+{
+	mt76x02_set_irq_mask(dev, mask, 0);
+}
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index b950361e5f87..2597bf43c2fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -95,9 +95,6 @@ struct mt76x2_dev {
 
 	u32 aggr_stats[32];
 
-	spinlock_t irq_lock;
-	u32 irqmask;
-
 	struct sk_buff *beacons[8];
 	u8 beacon_mask;
 	u8 beacon_data_mask;
@@ -124,8 +121,6 @@ static inline bool is_mt7612(struct mt76x2_dev *dev)
 	return mt76_chip(&dev->mt76) == 0x7612;
 }
 
-void mt76x2_set_irq_mask(struct mt76x2_dev *dev, u32 clear, u32 set);
-
 static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
@@ -134,16 +129,6 @@ static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
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
index 2629779e8d3e..06e47f960f9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
@@ -17,23 +17,11 @@
 #include <linux/delay.h>
 #include "mt76x2.h"
 #include "mt76x2_trace.h"
-
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
+#include "mt76x02_util.h"
 
 void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 {
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
-
-	mt76x2_irq_enable(dev, MT_INT_RX_DONE(q));
+	mt76x02_irq_enable(mdev, MT_INT_RX_DONE(q));
 }
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
@@ -47,22 +35,22 @@ irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
 		return IRQ_NONE;
 
-	trace_dev_irq(dev, intr, dev->irqmask);
+	trace_dev_irq(dev, intr, dev->mt76.mmio.irqmask);
 
-	intr &= dev->irqmask;
+	intr &= dev->mt76.mmio.irqmask;
 
 	if (intr & MT_INT_TX_DONE_ALL) {
-		mt76x2_irq_disable(dev, MT_INT_TX_DONE_ALL);
+		mt76x02_irq_disable(&dev->mt76, MT_INT_TX_DONE_ALL);
 		tasklet_schedule(&dev->tx_tasklet);
 	}
 
 	if (intr & MT_INT_RX_DONE(0)) {
-		mt76x2_irq_disable(dev, MT_INT_RX_DONE(0));
+		mt76x02_irq_disable(&dev->mt76, MT_INT_RX_DONE(0));
 		napi_schedule(&dev->mt76.napi[0]);
 	}
 
 	if (intr & MT_INT_RX_DONE(1)) {
-		mt76x2_irq_disable(dev, MT_INT_RX_DONE(1));
+		mt76x02_irq_disable(&dev->mt76, MT_INT_RX_DONE(1));
 		napi_schedule(&dev->mt76.napi[1]);
 	}
 
@@ -79,7 +67,7 @@ irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 	}
 
 	if (intr & MT_INT_GPTIMER) {
-		mt76x2_irq_disable(dev, MT_INT_GPTIMER);
+		mt76x02_irq_disable(&dev->mt76, MT_INT_GPTIMER);
 		tasklet_schedule(&dev->dfs_pd.dfs_tasklet);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index 374cc655c11d..8cfa3a063bda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -15,6 +15,7 @@
  */
 
 #include "mt76x2.h"
+#include "mt76x02_util.h"
 
 #define RADAR_SPEC(m, len, el, eh, wl, wh,		\
 		   w_tolerance, tl, th, t_tolerance,	\
@@ -678,7 +679,7 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 	mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
 
 out:
-	mt76x2_irq_enable(dev, MT_INT_GPTIMER);
+	mt76x02_irq_enable(&dev->mt76, MT_INT_GPTIMER);
 }
 
 static void mt76x2_dfs_init_sw_detector(struct mt76x2_dev *dev)
@@ -834,7 +835,7 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 		/* enable debug mode */
 		mt76x2_dfs_set_capture_mode_ctrl(dev, true);
 
-		mt76x2_irq_enable(dev, MT_INT_GPTIMER);
+		mt76x02_irq_enable(&dev->mt76, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
 			       MT_INT_TIMER_EN_GP_TIMER_EN, 1);
 	} else {
@@ -844,7 +845,7 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 		mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
 		mt76_wr(dev, 0x212c, 0);
 
-		mt76x2_irq_disable(dev, MT_INT_GPTIMER);
+		mt76x02_irq_disable(&dev->mt76, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
 			       MT_INT_TIMER_EN_GP_TIMER_EN, 0);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 879ed9138841..45bed7cbcdec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -16,6 +16,7 @@
 
 #include "mt76x2.h"
 #include "mt76x02_dma.h"
+#include "mt76x02_util.h"
 
 static int
 mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
@@ -31,7 +32,7 @@ mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 	if (ret)
 		return ret;
 
-	mt76x2_irq_enable(dev, MT_INT_TX_DONE(idx));
+	mt76x02_irq_enable(&dev->mt76, MT_INT_TX_DONE(idx));
 
 	return 0;
 }
@@ -50,7 +51,7 @@ mt76x2_init_rx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 	if (ret)
 		return ret;
 
-	mt76x2_irq_enable(dev, MT_INT_RX_DONE(idx));
+	mt76x02_irq_enable(&dev->mt76, MT_INT_RX_DONE(idx));
 
 	return 0;
 }
@@ -67,7 +68,7 @@ mt76x2_tx_tasklet(unsigned long data)
 		mt76_queue_tx_cleanup(dev, i, false);
 
 	mt76x2_mac_poll_tx_status(dev, false);
-	mt76x2_irq_enable(dev, MT_INT_TX_DONE_ALL);
+	mt76x02_irq_enable(&dev->mt76, MT_INT_TX_DONE_ALL);
 }
 
 int mt76x2_dma_init(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index bd52c8b2ee9f..d4134e322ff4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -213,8 +213,9 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 		MT_MAC_SYS_CTRL_ENABLE_TX |
 		MT_MAC_SYS_CTRL_ENABLE_RX);
 
-	mt76x2_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
-			       MT_INT_TX_STAT);
+	mt76x02_irq_enable(&dev->mt76,
+			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			   MT_INT_TX_STAT);
 
 	return 0;
 }
@@ -422,7 +423,6 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 	dev = container_of(mdev, struct mt76x2_dev, mt76);
 	mdev->dev = pdev;
 	mdev->drv = &drv_ops;
-	spin_lock_init(&dev->irq_lock);
 
 	return dev;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 241ede98e6d3..5fff0860731b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -42,9 +42,9 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 	trace_mac_txstat_poll(dev);
 
 	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
-		spin_lock_irqsave(&dev->irq_lock, flags);
+		spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
 		ret = mt76x02_mac_load_tx_status(&dev->mt76, &stat);
-		spin_unlock_irqrestore(&dev->irq_lock, flags);
+		spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
 
 		if (!ret)
 			break;
@@ -202,9 +202,9 @@ void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val)
 	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
 
 	if (en)
-		mt76x2_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+		mt76x02_irq_enable(&dev->mt76, MT_INT_PRE_TBTT | MT_INT_TBTT);
 	else
-		mt76x2_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+		mt76x02_irq_disable(&dev->mt76, MT_INT_PRE_TBTT | MT_INT_TBTT);
 }
 
 void mt76x2_update_channel(struct mt76_dev *mdev)
-- 
2.19.0

