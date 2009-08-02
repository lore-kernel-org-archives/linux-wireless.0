Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56459 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZHBDca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 23:32:30 -0400
Date: Sat, 01 Aug 2009 22:32:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Work around mac80211 race condition
Message-ID: <4a7508e0.l3Jz6c5c8JgW9wQm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As shown in http://thread.gmane.org/gmane.linux.kernel.wireless.general/36497,
mac80211 has a bug that allows a call to the TX routine after the queues have
been stopped. This situation will only occur under extreme stress. Although
b43legacy does not crash when this condition occurs, it does generate a WARN_ON
and also logs a queue overrun message. This patch recognizes b43legacy is not
at fault and logs a message only when the most verbose debugging mode is
enabled. In the unlikely event that the queue is not stopped when the DMA
queue becomes full, then a warning is issued.
    
This patch is based on the one used by b43.
   
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Index: wireless-testing/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/dma.c
+++ wireless-testing/drivers/net/wireless/b43legacy/dma.c
@@ -1366,15 +1366,25 @@ int b43legacy_dma_tx(struct b43legacy_wl
 	ring = priority_to_txring(dev, skb_get_queue_mapping(skb));
 	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
-	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
-		b43legacywarn(dev->wl, "DMA queue overflow\n");
+
+	if (unlikely(ring->stopped)) {
+		/* We get here only because of a bug in mac80211.
+		 * Because of a race, one packet may be queued after
+		 * the queue is stopped, thus we got called when we shouldn't.
+		 * For now, just refuse the transmit. */
+		if (b43legacy_debug(dev, B43legacy_DBG_DMAVERBOSE))
+			b43legacyerr(dev->wl, "Packet after queue stopped\n");
+		err = -ENOSPC;
+		goto out_unlock;
+	}
+
+	if (unlikely(WARN_ON(free_slots(ring) < SLOTS_PER_PACKET))) {
+		/* If we get here, we have a real error with the queue
+		 * full, but queues not stopped. */
+		b43legacyerr(dev->wl, "DMA queue overflow\n");
 		err = -ENOSPC;
 		goto out_unlock;
 	}
-	/* Check if the queue was stopped in mac80211,
-	 * but we got called nevertheless.
-	 * That would be a mac80211 bug. */
-	B43legacy_BUG_ON(ring->stopped);
 
 	err = dma_tx_fragment(ring, skb);
 	if (unlikely(err == -ENOKEY)) {
