Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbXIZNYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:09 -0400
Message-Id: <20070926132134.337214000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 07/12] mac80211: fix TKIP IV update
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TKIP IV should be updated only after MMIC verification,
this patch changes it to be at that spot.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/tkip.c        |   16 ++++++++++------
 net/mac80211/tkip.h        |    3 ++-
 net/mac80211/wpa.c         |    8 +++++++-
 4 files changed, 21 insertions(+), 8 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-25 23:29:36.561571777 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-25 23:29:37.921572374 +0200
@@ -153,6 +153,8 @@ struct ieee80211_txrx_data {
 			int sent_ps_buffered;
 			int queue;
 			int load;
+			u32 tkip_iv32;
+			u16 tkip_iv16;
 		} rx;
 	} u;
 };
--- wireless-dev.orig/net/mac80211/tkip.c	2007-09-25 23:28:21.111571506 +0200
+++ wireless-dev/net/mac80211/tkip.c	2007-09-25 23:29:37.921572374 +0200
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
@@ -332,11 +333,14 @@ int ieee80211_tkip_decrypt_data(struct c
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
--- wireless-dev.orig/net/mac80211/tkip.h	2007-09-25 23:28:21.151572971 +0200
+++ wireless-dev/net/mac80211/tkip.h	2007-09-25 23:29:37.931571561 +0200
@@ -31,6 +31,7 @@ enum {
 int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
-				int only_iv, int queue);
+				int only_iv, int queue,
+				u32 *out_iv32, u16 *out_iv16);
 
 #endif /* TKIP_H */
--- wireless-dev.orig/net/mac80211/wpa.c	2007-09-25 23:29:35.111582139 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-09-25 23:29:37.931571561 +0200
@@ -175,6 +175,10 @@ ieee80211_rx_h_michael_mic_verify(struct
 	/* remove Michael MIC from payload */
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
+	/* update IV in key information to be able to detect replays */
+	rx->key->u.tkip.iv32_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv32;
+	rx->key->u.tkip.iv16_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv16;
+
 	return TXRX_CONTINUE;
 }
 
@@ -315,7 +319,9 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->addr,
-					  hwaccel, rx->u.rx.queue);
+					  hwaccel, rx->u.rx.queue,
+					  &rx->u.rx.tkip_iv32,
+					  &rx->u.rx.tkip_iv16);
 	if (res != TKIP_DECRYPT_OK || wpa_test) {
 		printk(KERN_DEBUG "%s: TKIP decrypt failed for RX frame from "
 		       "%s (res=%d)\n",

-- 

