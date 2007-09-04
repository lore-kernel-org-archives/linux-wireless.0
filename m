Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33521
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXIDNTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 09:19:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Always drop crypt-failed packets.
Date: Tue, 4 Sep 2007 15:18:51 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709041518.52209.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop packets for which the firmware was unable to decrypt it,
as we won't be able to decrypt them with the key, too.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/xmit.c	2007-08-31 17:40:05.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/xmit.c	2007-08-31 18:33:38.000000000 +0200
@@ -465,6 +465,12 @@ void b43_rx(struct b43_wldev *dev, struc
 
 	if (macstat & B43_RX_MAC_FCSERR)
 		dev->wl->ieee_stats.dot11FCSErrorCount++;
+	if (macstat & B43_RX_MAC_DECERR) {
+		/* Decryption with the given key failed.
+		 * Drop the packet. We also won't be able to decrypt it with
+		 * the key in software. */
+		goto drop;
+	}
 
 	/* Skip PLCP and padding */
 	padding = (macstat & B43_RX_MAC_PADDING) ? 2 : 0;
@@ -483,7 +489,7 @@ void b43_rx(struct b43_wldev *dev, struc
 	fctl = le16_to_cpu(wlhdr->frame_control);
 	skb_trim(skb, skb->len - FCS_LEN);
 
-	if ((macstat & B43_RX_MAC_DEC) && !(macstat & B43_RX_MAC_DECERR)) {
+	if (macstat & B43_RX_MAC_DEC) {
 		unsigned int keyidx;
 		int wlhdr_len;
 		int iv_len;
@@ -573,7 +579,7 @@ void b43_rx(struct b43_wldev *dev, struc
 	ieee80211_rx_irqsafe(dev->wl->hw, skb, &status);
 
 	return;
-      drop:
+drop:
 	b43dbg(dev->wl, "RX: Packet dropped\n");
 	dev_kfree_skb_any(skb);
 }
