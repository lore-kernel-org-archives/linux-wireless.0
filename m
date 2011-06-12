Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51747 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1FLOdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 10:33:44 -0400
Received: by fxm17 with SMTP id 17so2301587fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2011 07:33:43 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc: francesco.gringoli@ing.unibs.it,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: do not try sending packets when ring can be full
Date: Sun, 12 Jun 2011 17:11:53 +0200
Message-Id: <1307891513-6812-1-git-send-email-zajec5@gmail.com> (sfid-20110612_163353_594450_5A459432)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
This prevents us from hitting "Packet after queue stopped", but still
is not an optimal solution. We stop sending packets from queue to
hardware if just a one ring is full. It may happen there are packets on
the queue that want to be send to different ring (qos).
---
 drivers/net/wireless/b43/b43.h  |    2 ++
 drivers/net/wireless/b43/dma.c  |    5 +++++
 drivers/net/wireless/b43/main.c |    5 +++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 1cb2dde..8d4bb28 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -582,6 +582,8 @@ struct b43_dma {
 	struct b43_dmaring *rx_ring;
 
 	u32 translation; /* Routing bits */
+
+	u8 stopped_rings; /* Amount of stopped rings */
 };
 
 struct b43_pio_txqueue;
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index d02cf83..a501992 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1056,6 +1056,7 @@ int b43_dma_init(struct b43_wldev *dev)
 	if (err)
 		return err;
 	dma->translation = ssb_dma_translation(dev->sdev);
+	dma->stopped_rings = 0;
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
@@ -1374,6 +1375,8 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
 		/* This TX ring is full. */
 		ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
 		ring->stopped = 1;
+		dev->dma.stopped_rings++;
+
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
 		}
@@ -1493,9 +1496,11 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 		B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
 		ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
 		ring->stopped = 0;
+		dev->dma.stopped_rings--;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Woke up TX ring %d\n", ring->index);
 		}
+		ieee80211_queue_work(dev->wl->hw, &dev->wl->tx_work);
 	}
 }
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1d8d983..2260b36 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3219,6 +3219,11 @@ static void b43_tx_work(struct work_struct *work)
 	}
 
 	while (skb_queue_len(&wl->tx_queue)) {
+		if (!b43_using_pio_transfers(dev) && dev->dma.stopped_rings) {
+			mutex_unlock(&wl->mutex);
+			return;
+		}
+
 		skb = skb_dequeue(&wl->tx_queue);
 
 		if (b43_using_pio_transfers(dev))
-- 
1.7.3.4

