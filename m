Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33106 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZBSTUT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 14:20:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Move DMA stop sanity check
Date: Thu, 19 Feb 2009 20:17:36 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200902192017.36403.mb@bu3sch.de> (sfid-20090219_202024_783347_5188231A)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the DMA stop sanity check up a few lines, so it's actually
theoretically possible to trigger. (But it still shouldn't trigger, of course).

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-12-26 22:47:29.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-02-19 20:14:56.000000000 +0100
@@ -1306,16 +1306,18 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	}
 
 	spin_lock_irqsave(&ring->lock, flags);
+
 	B43_WARN_ON(!ring->tx);
+	/* Check if the queue was stopped in mac80211,
+	 * but we got called nevertheless.
+	 * That would be a mac80211 bug. */
+	B43_WARN_ON(ring->stopped);
+
 	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
 		b43warn(dev->wl, "DMA queue overflow\n");
 		err = -ENOSPC;
 		goto out_unlock;
 	}
-	/* Check if the queue was stopped in mac80211,
-	 * but we got called nevertheless.
-	 * That would be a mac80211 bug. */
-	B43_WARN_ON(ring->stopped);
 
 	/* Assign the queue number to the ring (if not already done before)
 	 * so TX status handling can use it. The queue to ring mapping is

-- 
Greetings, Michael.
