Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1LVAsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 19:48:02 -0500
Date: Wed, 21 Dec 2011 18:47:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Avoid packet losses in the dma worker code
Message-ID: <4ef27e3f.tFRWY9MvjhFyKiq+%Larry.Finger@lwfinger.net> (sfid-20111222_014809_740874_8D5F1BB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses a bug in the dma worker code that keeps draining
packets even when the hardware queues are full. In such cases packets
can not be passed down to the device and are erroneusly dropped by the
code. It is based on commit bad6919469662b7c92bc6353642aaaa777b36bac,
which fixes the same problem in b43.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch could be applied to 3.3, but is OK for 3.4.

Larry

Index: wireless-testing-new/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing-new/drivers/net/wireless/b43legacy/b43legacy.h
@@ -560,8 +560,16 @@ struct b43legacy_key {
 	u8 algorithm;
 };
 
+#define B43legacy_QOS_QUEUE_NUM	4
+
 struct b43legacy_wldev;
 
+/* QOS parameters for a queue. */
+struct b43legacy_qos_params {
+	/* The QOS parameters */
+	struct ieee80211_tx_queue_params p;
+};
+
 /* Data structure for the WLAN parts (802.11 cores) of the b43legacy chip. */
 struct b43legacy_wl {
 	/* Pointer to the active wireless device on this chip */
@@ -611,6 +619,18 @@ struct b43legacy_wl {
 	bool beacon1_uploaded;
 	bool beacon_templates_virgin; /* Never wrote the templates? */
 	struct work_struct beacon_update_trigger;
+	/* The current QOS parameters for the 4 queues. */
+	struct b43legacy_qos_params qos_params[B43legacy_QOS_QUEUE_NUM];
+
+	/* Packet transmit work */
+	struct work_struct tx_work;
+
+	/* Queue of packets to be transmitted. */
+	struct sk_buff_head tx_queue[B43legacy_QOS_QUEUE_NUM];
+
+	/* Flag that implement the queues stopping. */
+	bool tx_queue_stopped[B43legacy_QOS_QUEUE_NUM];
+
 };
 
 /* Pointers to the firmware data and meta information about it. */
Index: wireless-testing-new/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43legacy/dma.c
+++ wireless-testing-new/drivers/net/wireless/b43legacy/dma.c
@@ -727,7 +727,6 @@ struct b43legacy_dmaring *b43legacy_setu
 		} else
 			B43legacy_WARN_ON(1);
 	}
-	spin_lock_init(&ring->lock);
 #ifdef CONFIG_B43LEGACY_DEBUG
 	ring->last_injected_overflow = jiffies;
 #endif
@@ -1144,10 +1143,8 @@ int b43legacy_dma_tx(struct b43legacy_wl
 {
 	struct b43legacy_dmaring *ring;
 	int err = 0;
-	unsigned long flags;
 
 	ring = priority_to_txring(dev, skb_get_queue_mapping(skb));
-	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
 
 	if (unlikely(ring->stopped)) {
@@ -1157,16 +1154,14 @@ int b43legacy_dma_tx(struct b43legacy_wl
 		 * For now, just refuse the transmit. */
 		if (b43legacy_debug(dev, B43legacy_DBG_DMAVERBOSE))
 			b43legacyerr(dev->wl, "Packet after queue stopped\n");
-		err = -ENOSPC;
-		goto out_unlock;
+		return -ENOSPC;
 	}
 
 	if (unlikely(WARN_ON(free_slots(ring) < SLOTS_PER_PACKET))) {
 		/* If we get here, we have a real error with the queue
 		 * full, but queues not stopped. */
 		b43legacyerr(dev->wl, "DMA queue overflow\n");
-		err = -ENOSPC;
-		goto out_unlock;
+		return -ENOSPC;
 	}
 
 	/* dma_tx_fragment might reallocate the skb, so invalidate pointers pointing
@@ -1176,25 +1171,23 @@ int b43legacy_dma_tx(struct b43legacy_wl
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
 		dev_kfree_skb_any(skb);
-		err = 0;
-		goto out_unlock;
+		return 0;
 	}
 	if (unlikely(err)) {
 		b43legacyerr(dev->wl, "DMA tx mapping failure\n");
-		goto out_unlock;
+		return err;
 	}
 	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
-		ieee80211_stop_queue(dev->wl->hw, txring_to_priority(ring));
+		unsigned int skb_mapping = skb_get_queue_mapping(skb);
+		ieee80211_stop_queue(dev->wl->hw, skb_mapping);
+		dev->wl->tx_queue_stopped[skb_mapping] = 1;
 		ring->stopped = 1;
 		if (b43legacy_debug(dev, B43legacy_DBG_DMAVERBOSE))
 			b43legacydbg(dev->wl, "Stopped TX ring %d\n",
 			       ring->index);
 	}
-out_unlock:
-	spin_unlock_irqrestore(&ring->lock, flags);
-
 	return err;
 }
 
@@ -1205,14 +1198,29 @@ void b43legacy_dma_handle_txstatus(struc
 	struct b43legacy_dmadesc_meta *meta;
 	int retry_limit;
 	int slot;
+	int firstused;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
 		return;
-	B43legacy_WARN_ON(!irqs_disabled());
-	spin_lock(&ring->lock);
-
 	B43legacy_WARN_ON(!ring->tx);
+
+	/* Sanity check: TX packets are processed in-order on one ring.
+	 * Check if the slot deduced from the cookie really is the first
+	 * used slot. */
+	firstused = ring->current_slot - ring->used_slots + 1;
+	if (firstused < 0)
+		firstused = ring->nr_slots + firstused;
+	if (unlikely(slot != firstused)) {
+		/* This possibly is a firmware bug and will result in
+		 * malfunction, memory leaks and/or stall of DMA functionality.
+		 */
+		b43legacydbg(dev->wl, "Out of order TX status report on DMA "
+			     "ring %d. Expected %d, but got %d\n",
+			     ring->index, firstused, slot);
+		return;
+	}
+
 	while (1) {
 		B43legacy_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 		op32_idx2desc(ring, slot, &meta);
@@ -1285,14 +1293,21 @@ void b43legacy_dma_handle_txstatus(struc
 	dev->stats.last_tx = jiffies;
 	if (ring->stopped) {
 		B43legacy_WARN_ON(free_slots(ring) < SLOTS_PER_PACKET);
-		ieee80211_wake_queue(dev->wl->hw, txring_to_priority(ring));
 		ring->stopped = 0;
+	}
+
+	if (dev->wl->tx_queue_stopped[ring->queue_prio]) {
+		dev->wl->tx_queue_stopped[ring->queue_prio] = 0;
+	} else {
+		/* If the driver queue is running wake the corresponding
+		 * mac80211 queue. */
+		ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
 		if (b43legacy_debug(dev, B43legacy_DBG_DMAVERBOSE))
 			b43legacydbg(dev->wl, "Woke up TX ring %d\n",
-			       ring->index);
+				     ring->index);
 	}
-
-	spin_unlock(&ring->lock);
+	/* Add work to the queue. */
+	ieee80211_queue_work(dev->wl->hw, &dev->wl->tx_work);
 }
 
 static void dma_rx(struct b43legacy_dmaring *ring,
@@ -1415,22 +1430,14 @@ void b43legacy_dma_rx(struct b43legacy_d
 
 static void b43legacy_dma_tx_suspend_ring(struct b43legacy_dmaring *ring)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
 	op32_tx_suspend(ring);
-	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
 static void b43legacy_dma_tx_resume_ring(struct b43legacy_dmaring *ring)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
 	op32_tx_resume(ring);
-	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
 void b43legacy_dma_tx_suspend(struct b43legacy_wldev *dev)
Index: wireless-testing-new/drivers/net/wireless/b43legacy/dma.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43legacy/dma.h
+++ wireless-testing-new/drivers/net/wireless/b43legacy/dma.h
@@ -150,8 +150,9 @@ struct b43legacy_dmaring {
 	enum b43legacy_dmatype type;
 	/* Boolean. Is this ring stopped at ieee80211 level? */
 	bool stopped;
-	/* Lock, only used for TX. */
-	spinlock_t lock;
+	/* The QOS priority assigned to this ring. Only used for TX rings.
+	 * This is the mac80211 "queue" value. */
+	u8 queue_prio;
 	struct b43legacy_wldev *dev;
 #ifdef CONFIG_B43LEGACY_DEBUG
 	/* Maximum number of used slots. */
Index: wireless-testing-new/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing-new/drivers/net/wireless/b43legacy/main.c
@@ -2440,30 +2440,64 @@ static int b43legacy_rng_init(struct b43
 	return err;
 }
 
+static void b43legacy_tx_work(struct work_struct *work)
+{
+	struct b43legacy_wl *wl = container_of(work, struct b43legacy_wl,
+				  tx_work);
+	struct b43legacy_wldev *dev;
+	struct sk_buff *skb;
+	int queue_num;
+	int err = 0;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (unlikely(!dev || b43legacy_status(dev) < B43legacy_STAT_STARTED)) {
+		mutex_unlock(&wl->mutex);
+		return;
+	}
+
+	for (queue_num = 0; queue_num < B43legacy_QOS_QUEUE_NUM; queue_num++) {
+		while (skb_queue_len(&wl->tx_queue[queue_num])) {
+			skb = skb_dequeue(&wl->tx_queue[queue_num]);
+			if (b43legacy_using_pio(dev))
+				err = b43legacy_pio_tx(dev, skb);
+			else
+				err = b43legacy_dma_tx(dev, skb);
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
+
+		if (!err)
+			wl->tx_queue_stopped[queue_num] = 0;
+	}
+
+	mutex_unlock(&wl->mutex);
+}
+
 static void b43legacy_op_tx(struct ieee80211_hw *hw,
 			    struct sk_buff *skb)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
-	struct b43legacy_wldev *dev = wl->current_dev;
-	int err = -ENODEV;
-	unsigned long flags;
 
-	if (unlikely(!dev))
-		goto out;
-	if (unlikely(b43legacy_status(dev) < B43legacy_STAT_STARTED))
-		goto out;
-	/* DMA-TX is done without a global lock. */
-	if (b43legacy_using_pio(dev)) {
-		spin_lock_irqsave(&wl->irq_lock, flags);
-		err = b43legacy_pio_tx(dev, skb);
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
-	} else
-		err = b43legacy_dma_tx(dev, skb);
-out:
-	if (unlikely(err)) {
-		/* Drop the packet. */
+	if (unlikely(skb->len < 2 + 2 + 6)) {
+		/* Too short, this can't be a valid frame. */
 		dev_kfree_skb_any(skb);
+		return;
 	}
+	B43legacy_WARN_ON(skb_shinfo(skb)->nr_frags);
+
+	skb_queue_tail(&wl->tx_queue[skb->queue_mapping], skb);
+	if (!wl->tx_queue_stopped[skb->queue_mapping])
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
+	else
+		ieee80211_stop_queue(wl->hw, skb->queue_mapping);
 }
 
 static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
@@ -2879,6 +2913,7 @@ static void b43legacy_wireless_core_stop
 {
 	struct b43legacy_wl *wl = dev->wl;
 	unsigned long flags;
+	int queue_num;
 
 	if (b43legacy_status(dev) < B43legacy_STAT_STARTED)
 		return;
@@ -2898,11 +2933,16 @@ static void b43legacy_wireless_core_stop
 	/* Must unlock as it would otherwise deadlock. No races here.
 	 * Cancel the possibly running self-rearming periodic work. */
 	cancel_delayed_work_sync(&dev->periodic_work);
+	cancel_work_sync(&wl->tx_work);
 	mutex_lock(&wl->mutex);
 
-	ieee80211_stop_queues(wl->hw); /* FIXME this could cause a deadlock */
+	/* Drain all TX queues. */
+	for (queue_num = 0; queue_num < B43legacy_QOS_QUEUE_NUM; queue_num++) {
+		while (skb_queue_len(&wl->tx_queue[queue_num]))
+			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
+	}
 
-	b43legacy_mac_suspend(dev);
+b43legacy_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43legacydbg(wl, "Wireless interface stopped\n");
 }
@@ -3748,6 +3788,7 @@ static int b43legacy_wireless_init(struc
 	struct ieee80211_hw *hw;
 	struct b43legacy_wl *wl;
 	int err = -ENOMEM;
+	int queue_num;
 
 	b43legacy_sprom_fixup(dev->bus);
 
@@ -3782,6 +3823,13 @@ static int b43legacy_wireless_init(struc
 	mutex_init(&wl->mutex);
 	INIT_LIST_HEAD(&wl->devlist);
 	INIT_WORK(&wl->beacon_update_trigger, b43legacy_beacon_update_trigger_work);
+	INIT_WORK(&wl->tx_work, b43legacy_tx_work);
+
+	/* Initialize queues and flags. */
+	for (queue_num = 0; queue_num < B43legacy_QOS_QUEUE_NUM; queue_num++) {
+		skb_queue_head_init(&wl->tx_queue[queue_num]);
+		wl->tx_queue_stopped[queue_num] = 0;
+	}
 
 	ssb_set_devtypedata(dev, wl);
 	b43legacyinfo(wl, "Broadcom %04X WLAN found (core revision %u)\n",
