Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40112 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbeD3OMw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 10:12:52 -0400
Received: by mail-wr0-f195.google.com with SMTP id v60-v6so8183631wrc.7
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 07:12:52 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC 01/18] mt76x2: use completion instead of wait_queue for mcu rx queue
Date: Mon, 30 Apr 2018 16:12:16 +0200
Message-Id: <1a04d20c7e6199311f5b0179359be666beeab345.1525096206.git.lorenzo.bianconi@redhat.com> (sfid-20180430_161255_671720_84BA63BC)
In-Reply-To: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to reuse mcu related code supporting mt76x2u based devices,
use completion instead of wait_queue for mcu responses queue

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index a5d1255e4b9c..a31602d9310e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -47,7 +47,7 @@
 struct mt76x2_mcu {
 	struct mutex mutex;
 
-	wait_queue_head_t wait;
+	struct completion resp_cmpl;
 	struct sk_buff_head res_q;
 
 	u32 msg_seq;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index fd1ec4743e0b..ab71b6e6c6dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -74,7 +74,7 @@ void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 
 	if (q == MT_RXQ_MCU) {
 		skb_queue_tail(&dev->mcu.res_q, skb);
-		wake_up(&dev->mcu.wait);
+		complete(&dev->mcu.resp_cmpl);
 		return;
 	}
 
@@ -139,7 +139,7 @@ int mt76x2_dma_init(struct mt76x2_dev *dev)
 
 	mt76_dma_attach(&dev->mt76);
 
-	init_waitqueue_head(&dev->mcu.wait);
+	init_completion(&dev->mcu.resp_cmpl);
 	skb_queue_head_init(&dev->mcu.res_q);
 
 	tasklet_init(&dev->tx_tasklet, mt76x2_tx_tasklet, (unsigned long) dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index dfd36d736b06..3e2a7216ffdd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -61,8 +61,7 @@ mt76x2_mcu_get_response(struct mt76x2_dev *dev, unsigned long expires)
 		return NULL;
 
 	timeout = expires - jiffies;
-	wait_event_timeout(dev->mcu.wait, !skb_queue_empty(&dev->mcu.res_q),
-			   timeout);
+	wait_for_completion_timeout(&dev->mcu.resp_cmpl, timeout);
 	return skb_dequeue(&dev->mcu.res_q);
 }
 
-- 
2.14.3
