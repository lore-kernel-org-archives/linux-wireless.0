Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56774 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbYGBXFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 19:05:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable] b43: Do not return TX_BUSY from op_tx
Date: Thu, 3 Jul 2008 01:04:29 +0200
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807030104.30100.mb@bu3sch.de> (sfid-20080703_010639_122352_267C7D9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Never return TX_BUSY from op_tx. It doesn't make sense to return
TX_BUSY, if we can not transmit the packet.
Drop the packet and return TX_OK.
This will fix the resume hang.

Upstream commit is
66193a7cef2239bfd1b9b96e304770facf7a49c7

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6.25.6/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.25.6.orig/drivers/net/wireless/b43/main.c	2008-06-14 22:47:31.000000000 +0200
+++ linux-2.6.25.6/drivers/net/wireless/b43/main.c	2008-07-03 00:50:53.000000000 +0200
@@ -2604,25 +2604,30 @@ static int b43_op_tx(struct ieee80211_hw
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	unsigned long flags;
 	int err;
 
 	if (unlikely(!dev))
-		return NETDEV_TX_BUSY;
+		goto drop_packet;
 
 	/* Transmissions on seperate queues can run concurrently. */
 	read_lock_irqsave(&wl->tx_lock, flags);
 
 	err = -ENODEV;
 	if (likely(b43_status(dev) >= B43_STAT_STARTED))
 		err = b43_dma_tx(dev, skb, ctl);
 
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
 
 static int b43_op_conf_tx(struct ieee80211_hw *hw,
 			  int queue,
 			  const struct ieee80211_tx_queue_params *params)
