Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34165 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934283AbZIDU6P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 16:58:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 4/5] b43: Remove PIO RX workqueue
Date: Fri, 4 Sep 2009 22:56:19 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909042256.20125.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the PIO RX work. It's not needed anymore, because
we can sleep in the threaded interrupt handler.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2009-09-04 22:18:53.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2009-09-04 22:18:54.000000000 +0200
@@ -32,9 +32,6 @@
 #include <linux/delay.h>
 
 
-static void b43_pio_rx_work(struct work_struct *work);
-
-
 static u16 generate_cookie(struct b43_pio_txqueue *q,
 			   struct b43_pio_txpacket *pack)
 {
@@ -182,7 +179,6 @@ static struct b43_pio_rxqueue *b43_setup
 	q->rev = dev->dev->id.revision;
 	q->mmio_base = index_to_pioqueue_base(dev, index) +
 		       pio_rxqueue_offset(dev);
-	INIT_WORK(&q->rx_work, b43_pio_rx_work);
 
 	/* Enable Direct FIFO RX (PIO) on the engine. */
 	b43_dma_direct_fifo_rx(dev, index, 1);
@@ -247,13 +243,6 @@ void b43_pio_free(struct b43_wldev *dev)
 	destroy_queue_tx(pio, tx_queue_AC_BK);
 }
 
-void b43_pio_stop(struct b43_wldev *dev)
-{
-	if (!b43_using_pio_transfers(dev))
-		return;
-	cancel_work_sync(&dev->pio.rx_queue->rx_work);
-}
-
 int b43_pio_init(struct b43_wldev *dev)
 {
 	struct b43_pio *pio = &dev->pio;
@@ -745,30 +734,19 @@ rx_error:
 	return 1;
 }
 
-/* RX workqueue. We can sleep, yay! */
-static void b43_pio_rx_work(struct work_struct *work)
+void b43_pio_rx(struct b43_pio_rxqueue *q)
 {
-	struct b43_pio_rxqueue *q = container_of(work, struct b43_pio_rxqueue,
-						 rx_work);
-	unsigned int budget = 50;
+	unsigned int count = 0;
 	bool stop;
 
-	do {
-		mutex_lock(&q->dev->wl->mutex);
+	while (1) {
 		stop = (pio_rx_frame(q) == 0);
-		mutex_unlock(&q->dev->wl->mutex);
-		cond_resched();
 		if (stop)
 			break;
-	} while (--budget);
-}
-
-/* Called with IRQs disabled. */
-void b43_pio_rx(struct b43_pio_rxqueue *q)
-{
-	/* Due to latency issues we must run the RX path in
-	 * a workqueue to be able to schedule between packets. */
-	ieee80211_queue_work(q->dev->wl->hw, &q->rx_work);
+		cond_resched();
+		if (WARN_ON_ONCE(++count > 10000))
+			break;
+	}
 }
 
 static void b43_pio_tx_suspend_queue(struct b43_pio_txqueue *q)
Index: wireless-testing/drivers/net/wireless/b43/pio.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.h	2009-09-04 22:18:53.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.h	2009-09-04 22:18:54.000000000 +0200
@@ -104,9 +104,6 @@ struct b43_pio_rxqueue {
 	struct b43_wldev *dev;
 	u16 mmio_base;
 
-	/* Work to reduce latency issues on RX. */
-	struct work_struct rx_work;
-
 	/* Shortcut to the 802.11 core revision. This is to
 	 * avoid horrible pointer dereferencing in the fastpaths. */
 	u8 rev;
@@ -160,7 +157,6 @@ static inline void b43_piorx_write32(str
 
 
 int b43_pio_init(struct b43_wldev *dev);
-void b43_pio_stop(struct b43_wldev *dev);
 void b43_pio_free(struct b43_wldev *dev);
 
 int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb);
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-04 22:18:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-04 22:18:54.000000000 +0200
@@ -3883,7 +3883,6 @@ redo:
 	while (skb_queue_len(&wl->tx_queue))
 		dev_kfree_skb(skb_dequeue(&wl->tx_queue));
 
-	b43_pio_stop(dev);
 	b43_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43dbg(wl, "Wireless interface stopped\n");

-- 
Greetings, Michael.
