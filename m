Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbXIJMPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 08:15:47 -0400
Subject: [RFC/RFT] mac80211: fix TKIP IV update
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 14:17:12 +0200
Message-Id: <1189426632.4506.89.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TKIP IV should be updated only after MMIC verification,
this patch changes it to be at that spot.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
I'm not entirely sure about this, the comment said it should be correct
but I haven't double-checked the specs. It does seem to work, however,
I've connected to my TKIP[GTK]/CCMP[PTK] network without ill effects and
multicast traffic was fine.

 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/tkip.c        |   16 ++++++++++------
 net/mac80211/tkip.h        |    3 ++-
 net/mac80211/wpa.c         |    8 +++++++-
 4 files changed, 21 insertions(+), 8 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-10 14:13:03.907220974 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-10 14:13:08.237222493 +0200
@@ -160,6 +160,8 @@ struct ieee80211_txrx_data {
 			int sent_ps_buffered;
 			int queue;
 			int load;
+			u32 tkip_iv32;
+			u16 tkip_iv16;
 			u16 qos_control;
 		} rx;
 	} u;
--- wireless-dev.orig/net/mac80211/tkip.c	2007-09-10 14:13:03.957223904 +0200
+++ wireless-dev/net/mac80211/tkip.c	2007-09-10 14:13:08.237222493 +0200
@@ -238,7 +238,8 @@ void ieee80211_tkip_encrypt_data(struct 
 int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
-				int only_iv, int queue)
+				int only_iv, int queue,
+				u32 *out_iv32, u16 *out_iv16)
 {
 	u32 iv32;
 	u32 iv16;
@@ -330,11 +331,14 @@ int ieee80211_tkip_decrypt_data(struct c
 	res = ieee80211_wep_decrypt_data(tfm, rc4key, 16, pos, payload_len - 12);
  done:
 	if (res == TKIP_DECRYPT_OK) {
-		/* FIX: these should be updated only after Michael MIC has been
-		 * verified */
-		/* Record previously received IV */
-		key->u.tkip.iv32_rx[queue] = iv32;
-		key->u.tkip.iv16_rx[queue] = iv16;
+		/*
+		 * Record previously received IV, will be copied into the
+		 * key information after MIC verification. It is possible
+		 * that we don't catch replays of fragments but that's ok
+		 * because the Michael MIC verication will then fail.
+		 */
+		*out_iv32 = iv32;
+		*out_iv16 = iv16;
 	}
 
 	return res;
--- wireless-dev.orig/net/mac80211/tkip.h	2007-09-10 14:13:03.977220323 +0200
+++ wireless-dev/net/mac80211/tkip.h	2007-09-10 14:13:08.237222493 +0200
@@ -31,6 +31,7 @@ enum {
 int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
-				int only_iv, int queue);
+				int only_iv, int queue,
+				u32 *out_iv32, u16 *out_iv16);
 
 #endif /* TKIP_H */
--- wireless-dev.orig/net/mac80211/wpa.c	2007-09-10 14:13:04.027227485 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-09-10 14:13:08.237222493 +0200
@@ -239,6 +239,10 @@ ieee80211_rx_h_michael_mic_verify(struct
 	/* remove Michael MIC from payload */
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
+	/* update IV in key information to be able to detect replays */
+	rx->key->u.tkip.iv32_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv32;
+	rx->key->u.tkip.iv16_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv16;
+
 	return TXRX_CONTINUE;
 }
 
@@ -461,7 +465,9 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->addr,
-					  hwaccel, rx->u.rx.queue);
+					  hwaccel, rx->u.rx.queue,
+					  &rx->u.rx.tkip_iv32,
+					  &rx->u.rx.tkip_iv16);
 	if (res != TKIP_DECRYPT_OK || wpa_test) {
 		printk(KERN_DEBUG "%s: TKIP decrypt failed for RX frame from "
 		       MAC_FMT " (res=%d)\n",


