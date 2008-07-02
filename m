Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57208 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYGBXHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 19:07:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable] b43legacy: Do not return TX_BUSY from op_tx
Date: Thu, 3 Jul 2008 01:06:32 +0200
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807030106.32960.mb@bu3sch.de> (sfid-20080703_010726_276273_309E9BAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Never return TX_BUSY from op_tx. It doesn't make sense to return
TX_BUSY, if we can not transmit the packet.
Drop the packet and return TX_OK.

Upstream commit is
eb803e419ca6be06ece2e42027bb4ebd8ec09f91

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6.25.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.25.6.orig/drivers/net/wireless/b43legacy/main.c	2008-06-14 22:41:44.000000000 +0200
+++ linux-2.6.25.6/drivers/net/wireless/b43legacy/main.c	2008-07-03 00:51:33.000000000 +0200
@@ -2347,14 +2347,16 @@ static int b43legacy_op_tx(struct ieee80
 		spin_lock_irqsave(&wl->irq_lock, flags);
 		err = b43legacy_pio_tx(dev, skb, ctl);
 		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	} else
 		err = b43legacy_dma_tx(dev, skb, ctl);
 out:
-	if (unlikely(err))
-		return NETDEV_TX_BUSY;
+	if (unlikely(err)) {
+		/* Drop the packet. */
+		dev_kfree_skb_any(skb);
+	}
 	return NETDEV_TX_OK;
 }
 
 static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
 				int queue,
 				const struct ieee80211_tx_queue_params *params)
