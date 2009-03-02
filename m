Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49664 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbZCBWWB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 17:22:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Pass more RX flags to mac80211
Date: Mon, 2 Mar 2009 23:18:37 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903022318.37977.mb@bu3sch.de> (sfid-20090302_232206_259509_5FC972DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the RX handler to pass more status flags to mac80211.
It also changes part of the drop policy, if bad frames were requested. (Note that
currently mac80211 will throw a WARN_ON in that case. But nothing bad will happen).

This also removes some obsolete unused timestamping code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---


John, please queue for the next feature release.
I'll probably look into the WARN_ON issue, too, but this is not too important
as weird things are expected to happen if user requests passing of bad frames.


Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-03-02 23:14:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-03-02 23:14:54.000000000 +0100
@@ -538,8 +538,14 @@ void b43_rx(struct b43_wldev *dev, struc
 	chanstat = le16_to_cpu(rxhdr->channel);
 	phytype = chanstat & B43_RX_CHAN_PHYTYPE;
 
-	if (macstat & B43_RX_MAC_FCSERR)
+	if (unlikely(macstat & B43_RX_MAC_FCSERR)) {
 		dev->wl->ieee_stats.dot11FCSErrorCount++;
+		status.flag |= RX_FLAG_FAILED_FCS_CRC;
+	}
+	if (unlikely(phystat0 & (B43_RX_PHYST0_PLCPHCF | B43_RX_PHYST0_PLCPFV)))
+		status.flag |= RX_FLAG_FAILED_PLCP_CRC;
+	if (phystat0 & B43_RX_PHYST0_SHORTPRMBL)
+		status.flag |= RX_FLAG_SHORTPRE;
 	if (macstat & B43_RX_MAC_DECERR) {
 		/* Decryption with the given key failed.
 		 * Drop the packet. We also won't be able to decrypt it with
@@ -606,8 +612,12 @@ void b43_rx(struct b43_wldev *dev, struc
 						phytype == B43_PHYTYPE_A);
 	else
 		status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
-	if (unlikely(status.rate_idx == -1))
-		goto drop;
+	if (unlikely(status.rate_idx == -1)) {
+		/* PLCP seems to be corrupted.
+		 * Drop the frame, if we are not interested in corrupted frames. */
+		if (!(dev->wl->filter_flags & FIF_PLCPFAIL))
+			goto drop;
+	}
 	status.antenna = !!(phystat0 & B43_RX_PHYST0_ANT);
 
 	/*
@@ -661,7 +671,6 @@ void b43_rx(struct b43_wldev *dev, struc
 		goto drop;
 	}
 
-	dev->stats.last_rx = jiffies;
 	ieee80211_rx_irqsafe(dev->wl->hw, skb, &status);
 
 	return;
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-03-02 23:14:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-03-02 23:14:54.000000000 +0100
@@ -550,9 +550,6 @@ struct b43_noise_calculation {
 
 struct b43_stats {
 	u8 link_noise;
-	/* Store the last TX/RX times here for updating the leds. */
-	unsigned long last_tx;
-	unsigned long last_rx;
 };
 
 struct b43_key {
Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-03-02 23:14:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-03-02 23:14:54.000000000 +0100
@@ -1425,7 +1425,6 @@ void b43_dma_handle_txstatus(struct b43_
 			break;
 		slot = next_slot(ring, slot);
 	}
-	dev->stats.last_tx = jiffies;
 	if (ring->stopped) {
 		B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
 		ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);

-- 
Greetings, Michael.
