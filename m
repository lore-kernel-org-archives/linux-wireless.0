Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54174 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZIJSWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 14:22:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Do not use _irqsafe callbacks
Date: Thu, 10 Sep 2009 20:22:02 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909102022.02987.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need to call the irqsafe callbacks.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Apply on top the other patches.

Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-09-05 12:31:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-09-10 20:14:25.000000000 +0200
@@ -1428,9 +1428,9 @@ void b43_dma_handle_txstatus(struct b43_
 				ring->nr_failed_tx_packets++;
 			ring->nr_total_packet_tries += status->frame_count;
 #endif /* DEBUG */
-			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb);
+			ieee80211_tx_status(dev->wl->hw, meta->skb);
 
-			/* skb is freed by ieee80211_tx_status_irqsafe() */
+			/* skb is freed by ieee80211_tx_status() */
 			meta->skb = NULL;
 		} else {
 			/* No need to call free_descriptor_buffer here, as
Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2009-09-05 12:31:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2009-09-10 20:14:37.000000000 +0200
@@ -574,7 +574,7 @@ void b43_pio_handle_txstatus(struct b43_
 	q->buffer_used -= total_len;
 	q->free_packet_slots += 1;
 
-	ieee80211_tx_status_irqsafe(dev->wl->hw, pack->skb);
+	ieee80211_tx_status(dev->wl->hw, pack->skb);
 	pack->skb = NULL;
 	list_add(&pack->list, &q->packets_list);
 
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-09-06 16:17:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-09-10 20:13:29.000000000 +0200
@@ -690,7 +690,7 @@ void b43_rx(struct b43_wldev *dev, struc
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
-	ieee80211_rx_irqsafe(dev->wl->hw, skb);
+	ieee80211_rx(dev->wl->hw, skb);
 
 	return;
 drop:

-- 
Greetings, Michael.
