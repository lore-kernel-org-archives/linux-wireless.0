Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59497 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbYFON23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 09:28:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Do not return TX_BUSY from op_tx
Date: Sun, 15 Jun 2008 15:27:49 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806151527.49961.mb@bu3sch.de> (sfid-20080615_152854_813590_C8593ACC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Never return TX_BUSY from op_tx. It doesn't make sense to return
TX_BUSY, if we can not transmit the packet.
Drop the packet and return TX_OK.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.26.


Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2008-06-06 15:54:17.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2008-06-15 15:22:37.000000000 +0200
@@ -2374,14 +2374,16 @@ static int b43legacy_op_tx(struct ieee80
 		spin_lock_irqsave(&wl->irq_lock, flags);
 		err = b43legacy_pio_tx(dev, skb);
 		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	} else
 		err = b43legacy_dma_tx(dev, skb);
 out:
-	if (unlikely(err))
-		return NETDEV_TX_BUSY;
+	if (unlikely(err)) {
+		/* Drop the packet. */
+		dev_kfree_skb_any(skb);
+	}
 	return NETDEV_TX_OK;
 }
 
 static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 				const struct ieee80211_tx_queue_params *params)
 {
