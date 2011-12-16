Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ing.unibs.it ([192.167.20.248]:41971 "EHLO
	zmx1.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760236Ab1LPRdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 12:33:00 -0500
Date: Fri, 16 Dec 2011 18:34:56 +0100
From: francesco.gringoli@ing.unibs.it
To: m@bues.ch, linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org, michele.orru@hotmail.it,
	riccardo.paolillo@gmail.com, francesco.gringoli@ing.unibs.it
Subject: [PATCH V3] b43: avoid packet losses in the dma worker code.
Message-ID: <4eeb8140.pi1v8GzJ/vHn+Vh/%francesco.gringoli@ing.unibs.it> (sfid-20111216_183306_762115_0BED2E10)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following Rafal request, we verified that on "modern" CPUs using one
or more workers is equivalent. Here is patch V3 that addresses the
packet loss bug in the dma engine using only one worker.

-------

This patch addresses a bug in the dma worker code that keeps draining
packets even when the hardware queues are full. In such cases packets
can not be passed down to the device and are erroneusly dropped by the
code.

This problem was already discussed here

http://www.mail-archive.com/b43-dev@lists.infradead.org/msg01413.html

and acknowledged by Michael.

Number of hardware queues is now defined in b43.h (B43_QOS_QUEUE_NUM).

Acknowledgements to Riccardo Paolillo <riccardo.paolillo@gmail.com> and
Michele Orru <michele.orru@hotmail.it>

Signed-off-by: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
---

Index: wireless-testing-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/b43.h	2011-12-16 16:44:49.024580820 +0100
+++ wireless-testing-new/drivers/net/wireless/b43/b43.h	2011-12-16 17:26:45.444634786 +0100
@@ -667,6 +667,7 @@
 };
 
 /* SHM offsets to the QOS data structures for the 4 different queues. */
+#define B43_QOS_QUEUE_NUM	4
 #define B43_QOS_PARAMS(queue)	(B43_SHM_SH_EDCFQ + \
 				 (B43_NR_QOSPARAMS * sizeof(u16) * (queue)))
 #define B43_QOS_BACKGROUND	B43_QOS_PARAMS(0)
@@ -904,7 +905,7 @@
 	struct work_struct beacon_update_trigger;
 
 	/* The current QOS parameters for the 4 queues. */
-	struct b43_qos_params qos_params[4];
+	struct b43_qos_params qos_params[B43_QOS_QUEUE_NUM];
 
 	/* Work for adjustment of the transmission power.
 	 * This is scheduled when we determine that the actual TX output
@@ -913,8 +914,12 @@
 
 	/* Packet transmit work */
 	struct work_struct tx_work;
+
 	/* Queue of packets to be transmitted. */
-	struct sk_buff_head tx_queue;
+	struct sk_buff_head tx_queue[B43_QOS_QUEUE_NUM];
+
+	/* Flag that implement the queues stopping. */
+	bool tx_queue_stopped[B43_QOS_QUEUE_NUM];
 
 	/* The device LEDs. */
 	struct b43_leds leds;
Index: wireless-testing-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/main.c	2011-12-16 16:44:49.024580820 +0100
+++ wireless-testing-new/drivers/net/wireless/b43/main.c	2011-12-16 17:23:33.374507233 +0100
@@ -3378,6 +3378,7 @@
 	struct b43_wl *wl = container_of(work, struct b43_wl, tx_work);
 	struct b43_wldev *dev;
 	struct sk_buff *skb;
+	int queue_num;
 	int err = 0;
 
 	mutex_lock(&wl->mutex);
@@ -3387,15 +3388,26 @@
 		return;
 	}
 
-	while (skb_queue_len(&wl->tx_queue)) {
-		skb = skb_dequeue(&wl->tx_queue);
+	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
+		while (skb_queue_len(&wl->tx_queue[queue_num])) {
+			skb = skb_dequeue(&wl->tx_queue[queue_num]);
+			if (b43_using_pio_transfers(dev))
+				err = b43_pio_tx(dev, skb);
+			else
+				err = b43_dma_tx(dev, skb);
+			if (err == -ENOSPC) {
+				wl->tx_queue_stopped[queue_num] = 1;
+				ieee80211_stop_queue(wl->hw, queue_num);
+				skb_queue_head(&wl->tx_queue[queue_num], skb);
+				break;
+			}
+			if (unlikely(err))
+				dev_kfree_skb(skb); /* Drop it */
+			err = 0;
+		}
 
-		if (b43_using_pio_transfers(dev))
-			err = b43_pio_tx(dev, skb);
-		else
-			err = b43_dma_tx(dev, skb);
-		if (unlikely(err))
-			dev_kfree_skb(skb); /* Drop it */
+		if (!err)
+			wl->tx_queue_stopped[queue_num] = 0;
 	}
 
 #if B43_DEBUG
@@ -3416,8 +3428,12 @@
 	}
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
-	skb_queue_tail(&wl->tx_queue, skb);
-	ieee80211_queue_work(wl->hw, &wl->tx_work);
+	skb_queue_tail(&wl->tx_queue[skb->queue_mapping], skb);
+	if (!wl->tx_queue_stopped[skb->queue_mapping]) {
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
+	} else {
+		ieee80211_stop_queue(wl->hw, skb->queue_mapping);
+	}
 }
 
 static void b43_qos_params_upload(struct b43_wldev *dev,
@@ -4147,6 +4163,7 @@
 	struct b43_wl *wl;
 	struct b43_wldev *orig_dev;
 	u32 mask;
+	int queue_num;
 
 	if (!dev)
 		return NULL;
@@ -4199,9 +4216,11 @@
 	mask = b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);
 	B43_WARN_ON(mask != 0xFFFFFFFF && mask);
 
-	/* Drain the TX queue */
-	while (skb_queue_len(&wl->tx_queue))
-		dev_kfree_skb(skb_dequeue(&wl->tx_queue));
+	/* Drain all TX queues. */
+	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
+		while (skb_queue_len(&wl->tx_queue[queue_num]))
+			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
+	}
 
 	b43_mac_suspend(dev);
 	b43_leds_exit(dev);
@@ -5245,6 +5264,7 @@
 	struct ieee80211_hw *hw;
 	struct b43_wl *wl;
 	char chip_name[6];
+	int queue_num;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &b43_hw_ops);
 	if (!hw) {
@@ -5264,7 +5284,7 @@
 		BIT(NL80211_IFTYPE_WDS) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->queues = modparam_qos ? 4 : 1;
+	hw->queues = modparam_qos ? B43_QOS_QUEUE_NUM : 1;
 	wl->mac80211_initially_registered_queues = hw->queues;
 	hw->max_rates = 2;
 	SET_IEEE80211_DEV(hw, dev->dev);
@@ -5281,7 +5301,12 @@
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
 	INIT_WORK(&wl->tx_work, b43_tx_work);
-	skb_queue_head_init(&wl->tx_queue);
+
+	/* Initialize queues and flags. */
+	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
+		skb_queue_head_init(&wl->tx_queue[queue_num]);
+		wl->tx_queue_stopped[queue_num] = 0;
+	}
 
 	snprintf(chip_name, ARRAY_SIZE(chip_name),
 		 (dev->chip_id > 0x9999) ? "%d" : "%04X", dev->chip_id);
Index: wireless-testing-new/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/dma.c	2011-12-16 16:44:49.024580820 +0100
+++ wireless-testing-new/drivers/net/wireless/b43/dma.c	2011-12-16 17:24:28.414481213 +0100
@@ -1465,7 +1465,9 @@
 	if ((free_slots(ring) < TX_SLOTS_PER_FRAME) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
-		ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
+		unsigned int skb_mapping = skb_get_queue_mapping(skb);
+		ieee80211_stop_queue(dev->wl->hw, skb_mapping);
+		dev->wl->tx_queue_stopped[skb_mapping] = 1;
 		ring->stopped = 1;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
@@ -1584,12 +1586,21 @@
 	}
 	if (ring->stopped) {
 		B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
-		ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
 		ring->stopped = 0;
+	}
+
+	if (dev->wl->tx_queue_stopped[ring->queue_prio]) {
+		dev->wl->tx_queue_stopped[ring->queue_prio] = 0;
+	} else {
+		/* If the driver queue is running wake the corresponding
+		 * mac80211 queue. */
+		ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Woke up TX ring %d\n", ring->index);
 		}
 	}
+	/* Add work to the queue. */
+	ieee80211_queue_work(dev->wl->hw, &dev->wl->tx_work);
 }
 
 static void dma_rx(struct b43_dmaring *ring, int *slot)
