Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1GFKQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 06:16:35 -0400
Message-Id: <20110706101558.179153800@sipsolutions.net> (sfid-20110706_121640_349789_D56165B4)
Date: Wed, 06 Jul 2011 12:09:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: fix TKIP races, make API easier to use
References: <20110706100929.554431961@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Our current TKIP code races against itself on TX
since we can process multiple packets at the same
time on different ACs, but they all share the TX
context for TKIP. This can lead to bad IVs etc.

Also, the crypto offload helper code just obtains
the P1K/P2K from the cache, and can update it as
well, but there's no guarantee that packets are
really processed in order.

To fix these issues, first introduce a spinlock
that will protect the IV16/IV32 values in the TX
context. This first step makes sure that we don't
assign the same IV multiple times or get confused
in other ways.

Secondly, change the way the P1K cache works. I
add a field "p1k_iv32" that stores the value of
the IV32 when the P1K was last recomputed, and
if different from the last time, then a new P1K
is recomputed. This can cause the P1K computation
to flip back and forth if packets are processed
out of order. All this also happens under the new
spinlock.

Finally, because there are argument differences,
split up the ieee80211_get_tkip_key() API into
ieee80211_get_tkip_p1k() and ieee80211_get_tkip_p2k()
and give them the correct arguments.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/b43/xmit.c             |    3 
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c |    3 
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    3 
 include/net/mac80211.h                      |   51 ++++++------
 net/mac80211/key.c                          |    1 
 net/mac80211/key.h                          |   10 +-
 net/mac80211/tkip.c                         |  111 +++++++++++++++-------------
 net/mac80211/tkip.h                         |    8 +-
 net/mac80211/wpa.c                          |    9 +-
 9 files changed, 105 insertions(+), 94 deletions(-)

--- a/include/net/mac80211.h	2011-07-06 12:08:39.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-06 12:08:57.000000000 +0200
@@ -962,21 +962,6 @@ enum sta_notify_cmd {
 };
 
 /**
- * enum ieee80211_tkip_key_type - get tkip key
- *
- * Used by drivers which need to get a tkip key for skb. Some drivers need a
- * phase 1 key, others need a phase 2 key. A single function allows the driver
- * to get the key, this enum indicates what type of key is required.
- *
- * @IEEE80211_TKIP_P1_KEY: the driver needs a phase 1 key
- * @IEEE80211_TKIP_P2_KEY: the driver needs a phase 2 key
- */
-enum ieee80211_tkip_key_type {
-	IEEE80211_TKIP_P1_KEY,
-	IEEE80211_TKIP_P2_KEY,
-};
-
-/**
  * enum ieee80211_hw_flags - hardware flags
  *
  * These flags are used to indicate hardware capabilities to
@@ -2579,21 +2564,33 @@ struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 
 /**
- * ieee80211_get_tkip_key - get a TKIP rc4 for skb
+ * ieee80211_get_tkip_p1k - get a TKIP phase 1 key
+ *
+ * This function returns the TKIP phase 1 key for the IV32 taken
+ * from the given packet.
+ *
+ * @keyconf: the parameter passed with the set key
+ * @skb: the packet to take the IV32 value from that will be encrypted
+ *	with this P1K
+ * @p1k: a buffer to which the key will be written, as 5 u16 values
+ */
+void ieee80211_get_tkip_p1k(struct ieee80211_key_conf *keyconf,
+			    struct sk_buff *skb, u16 *p1k);
+
+/**
+ * ieee80211_get_tkip_p2k - get a TKIP phase 2 key
  *
- * This function computes a TKIP rc4 key for an skb. It computes
- * a phase 1 key if needed (iv16 wraps around). This function is to
- * be used by drivers which can do HW encryption but need to compute
- * to phase 1/2 key in SW.
+ * This function computes the TKIP RC4 key for the IV values
+ * in the packet.
  *
  * @keyconf: the parameter passed with the set key
- * @skb: the skb for which the key is needed
- * @type: TBD
- * @key: a buffer to which the key will be written
- */
-void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
-				struct sk_buff *skb,
-				enum ieee80211_tkip_key_type type, u8 *key);
+ * @skb: the packet to take the IV32/IV16 values from that will be
+ *	encrypted with this key
+ * @p2k: a buffer to which the key will be written, 16 bytes
+ */
+void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
+			    struct sk_buff *skb, u8 *p2k);
+
 /**
  * ieee80211_gtk_rekey_notify - notify userspace supplicant of rekeying
  * @vif: virtual interface the rekeying was done on
--- a/net/mac80211/tkip.c	2011-07-06 12:06:57.000000000 +0200
+++ b/net/mac80211/tkip.c	2011-07-06 12:08:57.000000000 +0200
@@ -101,6 +101,7 @@ static void tkip_mixing_phase1(const u8
 		p1k[4] += tkipS(p1k[3] ^ get_unaligned_le16(tk + 0 + j)) + i;
 	}
 	ctx->state = TKIP_STATE_PHASE1_DONE;
+	ctx->p1k_iv32 = tsc_IV32;
 }
 
 static void tkip_mixing_phase2(const u8 *tk, struct tkip_ctx *ctx,
@@ -140,60 +141,72 @@ static void tkip_mixing_phase2(const u8
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
-u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key, u16 iv16)
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key)
 {
-	pos = write_tkip_iv(pos, iv16);
+	lockdep_assert_held(&key->u.tkip.txlock);
+
+	pos = write_tkip_iv(pos, key->u.tkip.tx.iv16);
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
 	put_unaligned_le32(key->u.tkip.tx.iv32, pos);
 	return pos + 4;
 }
 
-void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
-			struct sk_buff *skb, enum ieee80211_tkip_key_type type,
-			u8 *outkey)
+static void ieee80211_compute_tkip_p1k(struct ieee80211_key *key, u32 iv32)
+{
+	struct ieee80211_sub_if_data *sdata = key->sdata;
+	struct tkip_ctx *ctx = &key->u.tkip.tx;
+	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
+
+	lockdep_assert_held(&key->u.tkip.txlock);
+
+	/*
+	 * Update the P1K when the IV32 is different from the value it
+	 * had when we last computed it (or when not initialised yet).
+	 * This might flip-flop back and forth if packets are processed
+	 * out-of-order due to the different ACs, but then we have to
+	 * just compute the P1K more often.
+	 */
+	if (ctx->p1k_iv32 != iv32 || ctx->state == TKIP_STATE_NOT_INIT)
+		tkip_mixing_phase1(tk, ctx, sdata->vif.addr, iv32);
+}
+
+void ieee80211_get_tkip_p1k(struct ieee80211_key_conf *keyconf,
+			    struct sk_buff *skb, u16 *p1k)
 {
 	struct ieee80211_key *key = (struct ieee80211_key *)
 			container_of(keyconf, struct ieee80211_key, conf);
+	struct tkip_ctx *ctx = &key->u.tkip.tx;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	u8 *data;
-	const u8 *tk;
-	struct tkip_ctx *ctx;
-	u16 iv16;
-	u32 iv32;
-
-	data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
-	iv16 = data[2] | (data[0] << 8);
-	iv32 = get_unaligned_le32(&data[4]);
-
-	tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
-	ctx = &key->u.tkip.tx;
-
-#ifdef CONFIG_MAC80211_TKIP_DEBUG
-	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
-			iv16, iv32);
-
-	if (iv32 != ctx->iv32) {
-		printk(KERN_DEBUG "skb: iv32 = 0x%08x key: iv32 = 0x%08x\n",
-			iv32, ctx->iv32);
-		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
-			"fragmented packet\n");
-	}
-#endif
-
-	/* Update the p1k only when the iv16 in the packet wraps around, this
-	 * might occur after the wrap around of iv16 in the key in case of
-	 * fragmented packets. */
-	if (iv16 == 0 || ctx->state == TKIP_STATE_NOT_INIT)
-		tkip_mixing_phase1(tk, ctx, hdr->addr2, iv32);
-
-	if (type == IEEE80211_TKIP_P1_KEY) {
-		memcpy(outkey, ctx->p1k, sizeof(u16) * 5);
-		return;
-	}
+	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
+	u32 iv32 = get_unaligned_le32(&data[4]);
+	unsigned long flags;
+
+	spin_lock_irqsave(&key->u.tkip.txlock, flags);
+	ieee80211_compute_tkip_p1k(key, iv32);
+	memcpy(p1k, ctx->p1k, sizeof(ctx->p1k));
+	spin_unlock_irqrestore(&key->u.tkip.txlock, flags);
+}
+EXPORT_SYMBOL(ieee80211_get_tkip_p1k);
 
-	tkip_mixing_phase2(tk, ctx, iv16, outkey);
+void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
+			    struct sk_buff *skb, u8 *p2k)
+{
+	struct ieee80211_key *key = (struct ieee80211_key *)
+			container_of(keyconf, struct ieee80211_key, conf);
+	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
+	struct tkip_ctx *ctx = &key->u.tkip.tx;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
+	u32 iv32 = get_unaligned_le32(&data[4]);
+	u16 iv16 = data[2] | (data[0] << 8);
+	unsigned long flags;
+
+	spin_lock_irqsave(&key->u.tkip.txlock, flags);
+	ieee80211_compute_tkip_p1k(key, iv32);
+	tkip_mixing_phase2(tk, ctx, iv16, p2k);
+	spin_unlock_irqrestore(&key->u.tkip.txlock, flags);
 }
-EXPORT_SYMBOL(ieee80211_get_tkip_key);
+EXPORT_SYMBOL(ieee80211_get_tkip_p2k);
 
 /*
  * Encrypt packet payload with TKIP using @key. @pos is a pointer to the
@@ -204,19 +217,15 @@ EXPORT_SYMBOL(ieee80211_get_tkip_key);
  */
 int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
 				struct ieee80211_key *key,
-				u8 *pos, size_t payload_len, u8 *ta)
+				struct sk_buff *skb,
+				u8 *payload, size_t payload_len)
 {
 	u8 rc4key[16];
-	struct tkip_ctx *ctx = &key->u.tkip.tx;
-	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
-
-	/* Calculate per-packet key */
-	if (ctx->iv16 == 0 || ctx->state == TKIP_STATE_NOT_INIT)
-		tkip_mixing_phase1(tk, ctx, ta, ctx->iv32);
 
-	tkip_mixing_phase2(tk, ctx, ctx->iv16, rc4key);
+	ieee80211_get_tkip_p2k(&key->conf, skb, rc4key);
 
-	return ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
+	return ieee80211_wep_encrypt_data(tfm, rc4key, 16,
+					  payload, payload_len);
 }
 
 /* Decrypt packet payload with TKIP using @key. @pos is a pointer to the
--- a/drivers/net/wireless/b43/xmit.c	2011-07-06 12:06:57.000000000 +0200
+++ b/drivers/net/wireless/b43/xmit.c	2011-07-06 12:08:57.000000000 +0200
@@ -323,8 +323,7 @@ int b43_generate_txhdr(struct b43_wldev
 			/* we give the phase1key and iv16 here, the key is stored in
 			 * shm. With that the hardware can do phase 2 and encryption.
 			 */
-			ieee80211_get_tkip_key(info->control.hw_key, skb_frag,
-					IEEE80211_TKIP_P1_KEY, (u8*)phase1key);
+			ieee80211_get_tkip_p1k(info->control.hw_key, skb_frag, phase1key);
 			/* phase1key is in host endian. Copy to little-endian txhdr->iv. */
 			for (i = 0; i < 5; i++) {
 				txhdr->iv[i * 2 + 0] = phase1key[i];
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c	2011-07-06 12:06:57.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c	2011-07-06 12:08:57.000000000 +0200
@@ -240,8 +240,7 @@ static void iwl4965_tx_cmd_build_hwcrypt
 
 	case WLAN_CIPHER_SUITE_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
-		ieee80211_get_tkip_key(keyconf, skb_frag,
-			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
+		ieee80211_get_tkip_p2k(keyconf, skb_frag, tx_cmd->key);
 		IWL_DEBUG_TX(priv, "tx_cmd with tkip hwcrypto\n");
 		break;
 
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-07-06 12:07:43.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-07-06 12:08:57.000000000 +0200
@@ -497,8 +497,7 @@ static void iwlagn_tx_cmd_build_hwcrypto
 
 	case WLAN_CIPHER_SUITE_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
-		ieee80211_get_tkip_key(keyconf, skb_frag,
-			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
+		ieee80211_get_tkip_p2k(keyconf, skb_frag, tx_cmd->key);
 		IWL_DEBUG_TX(priv, "tx_cmd with tkip hwcrypto\n");
 		break;
 
--- a/net/mac80211/key.c	2011-07-06 12:08:39.000000000 +0200
+++ b/net/mac80211/key.c	2011-07-06 12:08:57.000000000 +0200
@@ -369,6 +369,7 @@ struct ieee80211_key *ieee80211_key_allo
 					get_unaligned_le16(seq);
 			}
 		}
+		spin_lock_init(&key->u.tkip.txlock);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key->conf.iv_len = CCMP_HDR_LEN;
--- a/net/mac80211/key.h	2011-07-06 12:06:57.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-06 12:08:57.000000000 +0200
@@ -52,9 +52,10 @@ enum ieee80211_internal_tkip_state {
 };
 
 struct tkip_ctx {
-	u32 iv32;
-	u16 iv16;
-	u16 p1k[5];
+	u32 iv32;	/* current iv32 */
+	u16 iv16;	/* current iv16 */
+	u16 p1k[5];	/* p1k cache */
+	u32 p1k_iv32;	/* iv32 for which p1k computed */
 	enum ieee80211_internal_tkip_state state;
 };
 
@@ -71,6 +72,9 @@ struct ieee80211_key {
 
 	union {
 		struct {
+			/* protects tx context */
+			spinlock_t txlock;
+
 			/* last used TSC */
 			struct tkip_ctx tx;
 
--- a/net/mac80211/tkip.h	2011-07-06 12:06:57.000000000 +0200
+++ b/net/mac80211/tkip.h	2011-07-06 12:08:57.000000000 +0200
@@ -13,11 +13,13 @@
 #include <linux/crypto.h>
 #include "key.h"
 
-u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key, u16 iv16);
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key);
 
 int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
-				 struct ieee80211_key *key,
-				 u8 *pos, size_t payload_len, u8 *ta);
+				struct ieee80211_key *key,
+				struct sk_buff *skb,
+				u8 *payload, size_t payload_len);
+
 enum {
 	TKIP_DECRYPT_OK = 0,
 	TKIP_DECRYPT_NO_EXT_IV = -1,
--- a/net/mac80211/wpa.c	2011-07-06 12:07:45.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-07-06 12:08:57.000000000 +0200
@@ -171,6 +171,7 @@ static int tkip_encrypt_skb(struct ieee8
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	unsigned long flags;
 	unsigned int hdrlen;
 	int len, tail;
 	u8 *pos;
@@ -198,11 +199,12 @@ static int tkip_encrypt_skb(struct ieee8
 	pos += hdrlen;
 
 	/* Increase IV for the frame */
+	spin_lock_irqsave(&key->u.tkip.txlock, flags);
 	key->u.tkip.tx.iv16++;
 	if (key->u.tkip.tx.iv16 == 0)
 		key->u.tkip.tx.iv32++;
-
-	pos = ieee80211_tkip_add_iv(pos, key, key->u.tkip.tx.iv16);
+	pos = ieee80211_tkip_add_iv(pos, key);
+	spin_unlock_irqrestore(&key->u.tkip.txlock, flags);
 
 	/* hwaccel - with software IV */
 	if (info->control.hw_key)
@@ -211,9 +213,8 @@ static int tkip_encrypt_skb(struct ieee8
 	/* Add room for ICV */
 	skb_put(skb, TKIP_ICV_LEN);
 
-	hdr = (struct ieee80211_hdr *) skb->data;
 	return ieee80211_tkip_encrypt_data(tx->local->wep_tx_tfm,
-					   key, pos, len, hdr->addr2);
+					   key, skb, pos, len);
 }
 
 


