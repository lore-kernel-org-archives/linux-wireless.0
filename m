Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34156 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934282AbZIDU6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 16:58:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/5] b43: Remove TX spinlock
Date: Fri, 4 Sep 2009 22:53:18 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909042253.18417.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the TX spinlock and defers TX to a workqueue to allow
locking wl->mutex instead and to allow sleeping for register accesses.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-09-04 22:18:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-09-04 22:18:48.000000000 +0200
@@ -683,6 +683,11 @@ struct b43_wl {
 	 * This is scheduled when we determine that the actual TX output
 	 * power doesn't match what we want. */
 	struct work_struct txpower_adjust_work;
+
+	/* Packet transmit work */
+	struct work_struct tx_work;
+	/* Queue of packets to be transmitted. */
+	struct sk_buff_head tx_queue;
 };
 
 /* The type of the firmware file. */
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-04 22:18:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-04 22:18:49.000000000 +0200
@@ -690,7 +690,6 @@ static void b43_short_slot_timing_disabl
  */
 void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 {
-	struct b43_wl *wl = dev->wl;
 	struct b43_phy *phy = &dev->phy;
 	unsigned int i, max_loop;
 	u16 value;
@@ -710,8 +709,6 @@ void b43_dummy_transmission(struct b43_w
 		buffer[0] = 0x000B846E;
 	}
 
-	write_lock_irq(&wl->tx_lock);
-
 	for (i = 0; i < 5; i++)
 		b43_ram_write(dev, i * 4, buffer[i]);
 
@@ -767,8 +764,6 @@ void b43_dummy_transmission(struct b43_w
 	}
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
 		b43_radio_write16(dev, 0x0051, 0x0037);
-
-	write_unlock_irq(&wl->tx_lock);
 }
 
 static void key_write(struct b43_wldev *dev,
@@ -3098,42 +3093,49 @@ static int b43_rng_init(struct b43_wl *w
 	return err;
 }
 
-static int b43_op_tx(struct ieee80211_hw *hw,
-		     struct sk_buff *skb)
+static void b43_tx_work(struct work_struct *work)
 {
-	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
-	int err;
+	struct b43_wl *wl = container_of(work, struct b43_wl, tx_work);
+	struct b43_wldev *dev;
+	struct sk_buff *skb;
+	int err = 0;
 
-	if (unlikely(skb->len < 2 + 2 + 6)) {
-		/* Too short, this can't be a valid frame. */
-		goto drop_packet;
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (unlikely(!dev || b43_status(dev) < B43_STAT_STARTED)) {
+		mutex_unlock(&wl->mutex);
+		return;
 	}
-	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
-	if (unlikely(!dev))
-		goto drop_packet;
 
-	/* Transmissions on seperate queues can run concurrently. */
-	read_lock_irqsave(&wl->tx_lock, flags);
+	while (skb_queue_len(&wl->tx_queue)) {
+		skb = skb_dequeue(&wl->tx_queue);
 
-	err = -ENODEV;
-	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
 		if (b43_using_pio_transfers(dev))
 			err = b43_pio_tx(dev, skb);
 		else
 			err = b43_dma_tx(dev, skb);
+		if (unlikely(err))
+			dev_kfree_skb(skb); /* Drop it */
 	}
 
-	read_unlock_irqrestore(&wl->tx_lock, flags);
+	mutex_unlock(&wl->mutex);
+}
 
-	if (unlikely(err))
-		goto drop_packet;
-	return NETDEV_TX_OK;
+static int b43_op_tx(struct ieee80211_hw *hw,
+		     struct sk_buff *skb)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+
+	if (unlikely(skb->len < 2 + 2 + 6)) {
+		/* Too short, this can't be a valid frame. */
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
+
+	skb_queue_tail(&wl->tx_queue, skb);
+	ieee80211_queue_work(wl->hw, &wl->tx_work);
 
-drop_packet:
-	/* We can not transmit this packet. Drop it. */
-	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
@@ -3686,18 +3688,12 @@ static int b43_op_set_key(struct ieee802
 	u8 algorithm;
 	u8 index;
 	int err;
-	unsigned long flags;
 	static const u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	if (modparam_nohwcrypt)
 		return -ENOSPC; /* User disabled HW-crypto */
 
 	mutex_lock(&wl->mutex);
-	write_lock_irqsave(&wl->tx_lock, flags);
-	/* mutex     -> Every config operation must take it.
-	 * tx_lock   -> We modify the dev->key array, which is accessed
-	 *              in the TX handler.
-	 */
 
 	dev = wl->current_dev;
 	err = -ENODEV;
@@ -3789,7 +3785,6 @@ out_unlock:
 		       sta ? sta->addr : bcast_addr);
 		b43_dump_keymemory(dev);
 	}
-	write_unlock_irqrestore(&wl->tx_lock, flags);
 	mutex_unlock(&wl->mutex);
 
 	return err;
@@ -3846,9 +3841,10 @@ redo:
 	if (!dev || b43_status(dev) < B43_STAT_STARTED)
 		return dev;
 
-	/* Disable periodic work. Unlock to avoid deadlocks. */
+	/* Cancel work. Unlock to avoid deadlocks. */
 	mutex_unlock(&wl->mutex);
 	cancel_delayed_work_sync(&dev->periodic_work);
+	cancel_work_sync(&wl->tx_work);
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (!dev || b43_status(dev) < B43_STAT_STARTED) {
@@ -3883,6 +3879,10 @@ redo:
 	}
 	B43_WARN_ON(b43_read32(dev, B43_MMIO_GEN_IRQ_MASK));
 
+	/* Drain the TX queue */
+	while (skb_queue_len(&wl->tx_queue))
+		dev_kfree_skb(skb_dequeue(&wl->tx_queue));
+
 	b43_pio_stop(dev);
 	b43_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
@@ -4866,7 +4866,6 @@ static int b43_wireless_init(struct ssb_
 
 	/* Initialize struct b43_wl */
 	wl->hw = hw;
-	rwlock_init(&wl->tx_lock);
 	spin_lock_init(&wl->leds_lock);
 	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);
@@ -4874,6 +4873,8 @@ static int b43_wireless_init(struct ssb_
 	INIT_LIST_HEAD(&wl->devlist);
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
+	INIT_WORK(&wl->tx_work, b43_tx_work);
+	skb_queue_head_init(&wl->tx_queue);
 
 	ssb_set_devtypedata(dev, wl);
 	b43info(wl, "Broadcom %04X WLAN found (core revision %u)\n",

-- 
Greetings, Michael.
