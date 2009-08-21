Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44380 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbZHUWNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 18:13:50 -0400
Received: by bwz19 with SMTP id 19so669285bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 15:13:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 22 Aug 2009 00:13:50 +0200
Message-ID: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
Subject: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 tkip code won't call update_tkip_key, if some rx packets
get received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
first packet because the hardware key stuff is called asynchronously with
todo workqueue.

This patch workaround that by tracking if we send the key to hardware.

Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Index: linux-2.6/net/mac80211/tkip.c
===================================================================
--- linux-2.6.orig/net/mac80211/tkip.c	2009-06-30 20:27:02.000000000 +0000
+++ linux-2.6/net/mac80211/tkip.c	2009-08-21 22:02:34.000000000 +0000
@@ -100,7 +100,7 @@
 		p1k[3] += tkipS(p1k[2] ^ get_unaligned_le16(tk + 12 + j));
 		p1k[4] += tkipS(p1k[3] ^ get_unaligned_le16(tk + 0 + j)) + i;
 	}
-	ctx->initialized = 1;
+	ctx->initialized = TKIP_INITIALIZED_PHASE1;
 }

 static void tkip_mixing_phase2(const u8 *tk, struct tkip_ctx *ctx,
@@ -183,7 +183,7 @@
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
-	if (iv16 == 0 || !ctx->initialized)
+	if (iv16 == 0 || ctx->initialized == TKIP_INITIALIZED_NONE)
 		tkip_mixing_phase1(tk, ctx, hdr->addr2, iv32);

 	if (type == IEEE80211_TKIP_P1_KEY) {
@@ -209,7 +209,7 @@
 	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];

 	/* Calculate per-packet key */
-	if (ctx->iv16 == 0 || !ctx->initialized)
+	if (ctx->iv16 == 0 || ctx->initialized == TKIP_INITIALIZED_NONE)
 		tkip_mixing_phase1(tk, ctx, ta, ctx->iv32);

 	tkip_mixing_phase2(tk, ctx, ctx->iv16, rc4key);
@@ -259,7 +259,7 @@
 	if ((keyid >> 6) != key->conf.keyidx)
 		return TKIP_DECRYPT_INVALID_KEYIDX;

-	if (key->u.tkip.rx[queue].initialized &&
+	if (key->u.tkip.rx[queue].initialized != TKIP_INITIALIZED_NONE &&
 	    (iv32 < key->u.tkip.rx[queue].iv32 ||
 	     (iv32 == key->u.tkip.rx[queue].iv32 &&
 	      iv16 <= key->u.tkip.rx[queue].iv16))) {
@@ -275,11 +275,11 @@

 	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
-		key->u.tkip.rx[queue].initialized = 1;
+		key->u.tkip.rx[queue].initialized = TKIP_INITIALIZED_UPDATE_KEY;
 		goto done;
 	}

-	if (!key->u.tkip.rx[queue].initialized ||
+	if (key->u.tkip.rx[queue].initialized == TKIP_INITIALIZED_NONE ||
 	    key->u.tkip.rx[queue].iv32 != iv32) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(tk, &key->u.tkip.rx[queue], ta, iv32);
@@ -299,18 +299,20 @@
 			printk("\n");
 		}
 #endif
-		if (key->local->ops->update_tkip_key &&
-			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-			u8 bcast[ETH_ALEN] =
-				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-			u8 *sta_addr = key->sta->sta.addr;
-
-			if (is_multicast_ether_addr(ra))
-				sta_addr = bcast;
-
-			drv_update_tkip_key(key->local, &key->conf, sta_addr,
-					    iv32, key->u.tkip.rx[queue].p1k);
-		}
+	}
+	if (key->local->ops->update_tkip_key &&
+	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+	    key->u.tkip.rx[queue].initialized != TKIP_INITIALIZED_UPDATE_KEY) {
+		u8 bcast[ETH_ALEN] =
+			{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+		u8 *sta_addr = key->sta->sta.addr;
+
+		if (is_multicast_ether_addr(ra))
+			sta_addr = bcast;
+
+		drv_update_tkip_key(key->local, &key->conf, sta_addr,
+					iv32, key->u.tkip.rx[queue].p1k);
+		key->u.tkip.rx[queue].initialized = TKIP_INITIALIZED_UPDATE_KEY;
 	}

 	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
Index: linux-2.6/net/mac80211/key.h
===================================================================
--- linux-2.6.orig/net/mac80211/key.h	2009-08-21 22:03:09.000000000 +0000
+++ linux-2.6/net/mac80211/key.h	2009-08-21 22:03:12.000000000 +0000
@@ -59,11 +59,17 @@
 	KEY_FLAG_TODO_DEFMGMTKEY	= BIT(6),
 };

+enum ieee80211_internal_tkip_initialized {
+	TKIP_INITIALIZED_NONE,
+	TKIP_INITIALIZED_PHASE1,
+	TKIP_INITIALIZED_UPDATE_KEY,
+};
+
 struct tkip_ctx {
 	u32 iv32;
 	u16 iv16;
 	u16 p1k[5];
-	int initialized;
+	enum ieee80211_internal_tkip_initialized initialized;
 };

 struct ieee80211_key {
