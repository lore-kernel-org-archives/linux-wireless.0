Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57241 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYFONSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 09:18:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Do not return TX_BUSY from op_tx
Date: Sun, 15 Jun 2008 15:17:29 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806151517.30230.mb@bu3sch.de> (sfid-20080615_151820_909843_C97FF530)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Never return TX_BUSY from op_tx. It doesn't make sense to return
TX_BUSY, if we can not transmit the packet.
Drop the packet and return TX_OK.
This will fix the resume hang.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.26.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-06-15 14:33:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-06-15 14:36:31.000000000 +0200
@@ -2973,18 +2973,17 @@ static int b43_op_tx(struct ieee80211_hw
 	struct b43_wldev *dev = wl->current_dev;
 	unsigned long flags;
 	int err;
 
 	if (unlikely(skb->len < 2 + 2 + 6)) {
 		/* Too short, this can't be a valid frame. */
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
+		goto drop_packet;
 	}
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 	if (unlikely(!dev))
-		return NETDEV_TX_BUSY;
+		goto drop_packet;
 
 	/* Transmissions on seperate queues can run concurrently. */
 	read_lock_irqsave(&wl->tx_lock, flags);
 
 	err = -ENODEV;
 	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
@@ -2994,13 +2993,18 @@ static int b43_op_tx(struct ieee80211_hw
 			err = b43_dma_tx(dev, skb);
 	}
 
 	read_unlock_irqrestore(&wl->tx_lock, flags);
 
 	if (unlikely(err))
-		return NETDEV_TX_BUSY;
+		goto drop_packet;
+	return NETDEV_TX_OK;
+
+drop_packet:
+	/* We can not transmit this packet. Drop it. */
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
 /* Locking: wl->irq_lock */
 static void b43_qos_params_upload(struct b43_wldev *dev,
 				  const struct ieee80211_tx_queue_params *p,
