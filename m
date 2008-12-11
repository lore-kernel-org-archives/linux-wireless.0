Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53594 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756416AbYLKQyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 11:54:11 -0500
Date: Thu, 11 Dec 2008 18:22:13 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: [PATCH] ath9k: Do not remove header padding on RX from short frames
Message-ID: <20081211162213.GA28193@jm.kir.nu> (sfid-20081211_175428_927129_C92B2A02)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 802.11 header is only padded to 32-bit boundary when the frame has
a non-zero length payload. In other words, control frames (e.g., ACK)
do not have a padding and we should not try to remove it. This fixes
monitor mode for short control frames. In addition, the hdrlen&3 use
is described in more detail to make it easier to understand how the
padding length is calculated.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/recv.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2008-12-11 11:35:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2008-12-11 12:18:02.000000000 +0200
@@ -571,8 +571,16 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		hdr = (struct ieee80211_hdr *)skb->data;
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 
-		if (hdrlen & 3) {
-			padsize = hdrlen % 4;
+		/* The MAC header is padded to have 32-bit boundary if the
+		 * packet payload is non-zero. The general calculation for
+		 * padsize would take into account odd header lengths:
+		 * padsize = (4 - hdrlen % 4) % 4; However, since only
+		 * even-length headers are used, padding can only be 0 or 2
+		 * bytes and we can optimize this a bit. In addition, we must
+		 * not try to remove padding from short control frames that do
+		 * not have payload. */
+		padsize = hdrlen & 3;
+		if (padsize && hdrlen >= 24) {
 			memmove(skb->data + padsize, skb->data, hdrlen);
 			skb_pull(skb, padsize);
 		}

-- 
Jouni Malinen                                            PGP id EFC895FA
