Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47568
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXBCRdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Feb 2007 12:33:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH RFC] d80211: Fix TKIP phase1 key mixing for hwcrypto
Date: Sat, 3 Feb 2007 18:32:48 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
MIME-Version: 1.0
Message-Id: <200702031832.48505.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is not runtime tested, as I did not implement tkip
support in bcm43xx, yet.

--

This fixes TKIP phase1 key mixing for hwcrypto on BigEndian
platforms.
Casting an u8 array to u16* is wrong and will only work
on le platforms.
Make it explicit and expect an u8* parameter for
ieee80211_tkip_gen_phase1key(). The function will take
care to return an u8 array, instead of an u16 array, as
that's what drivers assume.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: bu3sch-wireless-dev/net/d80211/tkip.c
===================================================================
--- bu3sch-wireless-dev.orig/net/d80211/tkip.c	2007-01-11 19:09:43.000000000 +0100
+++ bu3sch-wireless-dev/net/d80211/tkip.c	2007-02-03 18:23:52.000000000 +0100
@@ -192,10 +192,15 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
 
 
 void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key)
+				  u8 *phase1key)
 {
+	__le16 *k = (__le16 *)phase1key;
+	int i;
+
 	tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv32, phase1key);
+			   key->u.tkip.iv32, (u16 *)k);
+	for (i = 0; i < 5; i++)
+		k[i] = cpu_to_le16(k[i]);
 }
 
 void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
Index: bu3sch-wireless-dev/net/d80211/tkip.h
===================================================================
--- bu3sch-wireless-dev.orig/net/d80211/tkip.h	2007-01-11 19:09:43.000000000 +0100
+++ bu3sch-wireless-dev/net/d80211/tkip.h	2007-02-03 18:19:18.000000000 +0100
@@ -16,7 +16,7 @@
 u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2);
 void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key);
+				  u8 *phase1key);
 void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
Index: bu3sch-wireless-dev/net/d80211/wpa.c
===================================================================
--- bu3sch-wireless-dev.orig/net/d80211/wpa.c	2007-01-11 19:09:43.000000000 +0100
+++ bu3sch-wireless-dev/net/d80211/wpa.c	2007-02-03 18:18:50.000000000 +0100
@@ -349,7 +349,7 @@ skip_iv_inc:
 			if (key->u.tkip.iv16 == 0 ||
 			    !key->u.tkip.tx_initialized) {
 				ieee80211_tkip_gen_phase1key(key, hdr->addr2,
-					    (u16 *)tx->u.tx.control->tkip_key);
+					tx->u.tx.control->tkip_key);
 				key->u.tkip.tx_initialized = 1;
 				tx->u.tx.control->flags |=
 					    IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY;


-- 
Greetings Michael.
