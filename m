Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:31348 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbcBNL4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2016 06:56:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] mac80211: move TKIP TX IVs to public part of key struct
Date: Sun, 14 Feb 2016 13:56:35 +0200
Message-Id: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160214_125652_746907_07C2B4F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Some drivers/devices might want to set the IVs by
themselves (and still let mac80211 generate MMIC).

Specifically, this is needed when the device does
offloading at certain times, and the driver has
to make sure that the IVs of new tx frames (from
the host) are synchronized with IVs that were
potentially used during the offloading.

Similarly to CCMP, move the TX IVs of TKIP keys to the
public part of the key struct, and export a function
to add the IV right into the crypto header.

The public tx_pn field is defined as atomic64, so define
TKIP_PN_TO_IV16/32 helper macros to convert it to iv16/32
when needed.

Since the iv32 used for the p1k cache is taken
directly from the frame, we can safely remove
iv16/32 from being protected by tkip.txlock.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h     | 23 ++++++++++++++++++++---
 net/mac80211/cfg.c         |  5 +++--
 net/mac80211/debugfs_key.c |  5 +++--
 net/mac80211/key.c         |  9 +++++----
 net/mac80211/key.h         | 10 +++++++---
 net/mac80211/tkip.c        | 36 ++++++++++++++++++------------------
 net/mac80211/tkip.h        |  2 --
 net/mac80211/wpa.c         | 11 ++++-------
 8 files changed, 60 insertions(+), 41 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5714774..15879b4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1521,9 +1521,8 @@ enum ieee80211_key_flags {
  *	wants to be given when a frame is transmitted and needs to be
  *	encrypted in hardware.
  * @cipher: The key's cipher suite selector.
- * @tx_pn: PN used for TX on non-TKIP keys, may be used by the driver
- *	as well if it needs to do software PN assignment by itself
- *	(e.g. due to TSO)
+ * @tx_pn: PN used for TX keys, may be used by the driver as well if it
+ *	needs to do software PN assignment by itself (e.g. due to TSO)
  * @flags: key flags, see &enum ieee80211_key_flags.
  * @keyidx: the key index (0-3)
  * @keylen: key material length
@@ -1549,6 +1548,9 @@ struct ieee80211_key_conf {
 
 #define IEEE80211_MAX_PN_LEN	16
 
+#define TKIP_PN_TO_IV16(pn) ((u16)(pn & 0xffff))
+#define TKIP_PN_TO_IV32(pn) ((u32)((pn >> 16) & 0xffffffff))
+
 /**
  * struct ieee80211_key_seq - key sequence counter
  *
@@ -4447,6 +4449,21 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 			    struct sk_buff *skb, u8 *p2k);
 
 /**
+ * ieee80211_tkip_add_iv - write TKIP IV and Ext. IV to pos
+ *
+ * @pos: start of crypto header
+ * @keyconf: the parameter passed with the set key
+ * @pn: PN to add
+ *
+ * Returns: pointer to the octet following IVs (i.e. beginning of
+ * the packet payload)
+ *
+ * This function writes the tkip IV value to pos (which should
+ * point to the crypto header)
+ */
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key_conf *keyconf, u64 pn);
+
+/**
  * ieee80211_get_key_tx_seq - get key TX sequence counter
  *
  * @keyconf: the parameter passed with the set key
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 66d22de..fe1704c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -339,8 +339,9 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		iv32 = key->u.tkip.tx.iv32;
-		iv16 = key->u.tkip.tx.iv16;
+		pn64 = atomic64_read(&key->conf.tx_pn);
+		iv32 = TKIP_PN_TO_IV32(pn64);
+		iv16 = TKIP_PN_TO_IV16(pn64);
 
 		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 7961e7d..a2ef95f 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -132,9 +132,10 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 		len = scnprintf(buf, sizeof(buf), "\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
+		pn = atomic64_read(&key->conf.tx_pn);
 		len = scnprintf(buf, sizeof(buf), "%08x %04x\n",
-				key->u.tkip.tx.iv32,
-				key->u.tkip.tx.iv16);
+				TKIP_PN_TO_IV32(pn),
+				TKIP_PN_TO_IV16(pn));
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 5e5bc59..f9c4cb9 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -945,8 +945,9 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
 
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		seq->tkip.iv32 = key->u.tkip.tx.iv32;
-		seq->tkip.iv16 = key->u.tkip.tx.iv16;
+		pn64 = atomic64_read(&key->conf.tx_pn);
+		seq->tkip.iv32 = TKIP_PN_TO_IV32(pn64);
+		seq->tkip.iv16 = TKIP_PN_TO_IV16(pn64);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
@@ -1039,8 +1040,8 @@ void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
 
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		key->u.tkip.tx.iv32 = seq->tkip.iv32;
-		key->u.tkip.tx.iv16 = seq->tkip.iv16;
+		pn64 = (u64)seq->tkip.iv16 | ((u64)seq->tkip.iv32 << 16);
+		atomic64_set(&key->conf.tx_pn, pn64);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 9951ef0..4aa20ce 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -44,13 +44,17 @@ enum ieee80211_internal_tkip_state {
 };
 
 struct tkip_ctx {
-	u32 iv32;	/* current iv32 */
-	u16 iv16;	/* current iv16 */
 	u16 p1k[5];	/* p1k cache */
 	u32 p1k_iv32;	/* iv32 for which p1k computed */
 	enum ieee80211_internal_tkip_state state;
 };
 
+struct tkip_ctx_rx {
+	struct tkip_ctx ctx;
+	u32 iv32;	/* current iv32 */
+	u16 iv16;	/* current iv16 */
+};
+
 struct ieee80211_key {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -71,7 +75,7 @@ struct ieee80211_key {
 			struct tkip_ctx tx;
 
 			/* last received RSC */
-			struct tkip_ctx rx[IEEE80211_NUM_TIDS];
+			struct tkip_ctx_rx rx[IEEE80211_NUM_TIDS];
 
 			/* number of mic failures */
 			u32 mic_failures;
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 0ae2077..b362282 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -1,6 +1,7 @@
 /*
  * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
+ * Copyright (C) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -142,15 +143,14 @@ static void tkip_mixing_phase2(const u8 *tk, struct tkip_ctx *ctx,
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
-u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key)
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key_conf *keyconf, u64 pn)
 {
-	lockdep_assert_held(&key->u.tkip.txlock);
-
-	pos = write_tkip_iv(pos, key->u.tkip.tx.iv16);
-	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
-	put_unaligned_le32(key->u.tkip.tx.iv32, pos);
+	pos = write_tkip_iv(pos, TKIP_PN_TO_IV16(pn));
+	*pos++ = (keyconf->keyidx << 6) | (1 << 5) /* Ext IV */;
+	put_unaligned_le32(TKIP_PN_TO_IV32(pn), pos);
 	return pos + 4;
 }
+EXPORT_SYMBOL_GPL(ieee80211_tkip_add_iv);
 
 static void ieee80211_compute_tkip_p1k(struct ieee80211_key *key, u32 iv32)
 {
@@ -250,6 +250,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	u8 rc4key[16], keyid, *pos = payload;
 	int res;
 	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
+	struct tkip_ctx_rx *rx_ctx = &key->u.tkip.rx[queue];
 
 	if (payload_len < 12)
 		return -1;
@@ -265,37 +266,36 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	if ((keyid >> 6) != key->conf.keyidx)
 		return TKIP_DECRYPT_INVALID_KEYIDX;
 
-	if (key->u.tkip.rx[queue].state != TKIP_STATE_NOT_INIT &&
-	    (iv32 < key->u.tkip.rx[queue].iv32 ||
-	     (iv32 == key->u.tkip.rx[queue].iv32 &&
-	      iv16 <= key->u.tkip.rx[queue].iv16)))
+	if (rx_ctx->ctx.state != TKIP_STATE_NOT_INIT &&
+	    (iv32 < rx_ctx->iv32 ||
+	     (iv32 == rx_ctx->iv32 && iv16 <= rx_ctx->iv16)))
 		return TKIP_DECRYPT_REPLAY;
 
 	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
-		key->u.tkip.rx[queue].state = TKIP_STATE_PHASE1_HW_UPLOADED;
+		rx_ctx->ctx.state = TKIP_STATE_PHASE1_HW_UPLOADED;
 		goto done;
 	}
 
-	if (key->u.tkip.rx[queue].state == TKIP_STATE_NOT_INIT ||
-	    key->u.tkip.rx[queue].iv32 != iv32) {
+	if (rx_ctx->ctx.state == TKIP_STATE_NOT_INIT ||
+	    rx_ctx->iv32 != iv32) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(tk, &key->u.tkip.rx[queue], ta, iv32);
+		tkip_mixing_phase1(tk, &rx_ctx->ctx, ta, iv32);
 	}
 	if (key->local->ops->update_tkip_key &&
 	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
-	    key->u.tkip.rx[queue].state != TKIP_STATE_PHASE1_HW_UPLOADED) {
+	    rx_ctx->ctx.state != TKIP_STATE_PHASE1_HW_UPLOADED) {
 		struct ieee80211_sub_if_data *sdata = key->sdata;
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			sdata = container_of(key->sdata->bss,
 					struct ieee80211_sub_if_data, u.ap);
 		drv_update_tkip_key(key->local, sdata, &key->conf, key->sta,
-				iv32, key->u.tkip.rx[queue].p1k);
-		key->u.tkip.rx[queue].state = TKIP_STATE_PHASE1_HW_UPLOADED;
+				iv32, rx_ctx->ctx.p1k);
+		rx_ctx->ctx.state = TKIP_STATE_PHASE1_HW_UPLOADED;
 	}
 
-	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
+	tkip_mixing_phase2(tk, &rx_ctx->ctx, iv16, rc4key);
 
 	res = ieee80211_wep_decrypt_data(tfm, rc4key, 16, pos, payload_len - 12);
  done:
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index e3ecb65..a1bcbfb 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -13,8 +13,6 @@
 #include <linux/crypto.h>
 #include "key.h"
 
-u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key);
-
 int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
 				struct ieee80211_key *key,
 				struct sk_buff *skb,
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index d824c38..1884825 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -1,6 +1,7 @@
 /*
  * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2008, Jouni Malinen <j@w1.fi>
+ * Copyright (C) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -183,7 +184,6 @@ mic_fail_no_key:
 	return RX_DROP_UNUSABLE;
 }
 
-
 static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -191,6 +191,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned int hdrlen;
 	int len, tail;
+	u64 pn;
 	u8 *pos;
 
 	if (info->control.hw_key &&
@@ -222,12 +223,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 
 	/* Increase IV for the frame */
-	spin_lock(&key->u.tkip.txlock);
-	key->u.tkip.tx.iv16++;
-	if (key->u.tkip.tx.iv16 == 0)
-		key->u.tkip.tx.iv32++;
-	pos = ieee80211_tkip_add_iv(pos, key);
-	spin_unlock(&key->u.tkip.txlock);
+	pn = atomic64_inc_return(&key->conf.tx_pn);
+	pos = ieee80211_tkip_add_iv(pos, &key->conf, pn);
 
 	/* hwaccel - with software IV */
 	if (info->control.hw_key)
-- 
2.5.0

