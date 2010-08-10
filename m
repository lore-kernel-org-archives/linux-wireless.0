Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab0HJHvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 03:51:03 -0400
Message-Id: <20100810074700.385206959@sipsolutions.net>
Date: Tue, 10 Aug 2010 09:46:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] mac80211: remove unused status flag checks
References: <20100810074637.034583799@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The decryption code verifies whether or not
a given frame was decrypted and verified by
hardware. This is unnecessary, as the crypto
RX handler already does it long before the
decryption code is even invoked, so remove
that code to avoid confusion.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wpa.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

--- wireless-testing.orig/net/mac80211/wpa.c	2010-08-08 10:38:47.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2010-08-08 10:40:03.000000000 +0200
@@ -221,19 +221,13 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	if (!rx->sta || skb->len - hdrlen < 12)
 		return RX_DROP_UNUSABLE;
 
-	if (status->flag & RX_FLAG_DECRYPTED) {
-		if (status->flag & RX_FLAG_IV_STRIPPED) {
-			/*
-			 * Hardware took care of all processing, including
-			 * replay protection, and stripped the ICV/IV so
-			 * we cannot do any checks here.
-			 */
-			return RX_CONTINUE;
-		}
-
-		/* let TKIP code verify IV, but skip decryption */
+	/*
+	 * Let TKIP code verify IV, but skip decryption.
+	 * In the case where hardware checks the IV as well,
+	 * we don't even get here, see ieee80211_rx_h_decrypt()
+	 */
+	if (status->flag & RX_FLAG_DECRYPTED)
 		hwaccel = 1;
-	}
 
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
@@ -447,10 +441,6 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
 
-	if ((status->flag & RX_FLAG_DECRYPTED) &&
-	    (status->flag & RX_FLAG_IV_STRIPPED))
-		return RX_CONTINUE;
-
 	ccmp_hdr2pn(pn, skb->data + hdrlen);
 
 	queue = ieee80211_is_mgmt(hdr->frame_control) ?
@@ -564,10 +554,6 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 	if (!ieee80211_is_mgmt(hdr->frame_control))
 		return RX_CONTINUE;
 
-	if ((status->flag & RX_FLAG_DECRYPTED) &&
-	    (status->flag & RX_FLAG_IV_STRIPPED))
-		return RX_CONTINUE;
-
 	if (skb->len < 24 + sizeof(*mmie))
 		return RX_DROP_UNUSABLE;
 


