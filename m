Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:49794 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYFKVWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:22:16 -0400
Received: by py-out-1112.google.com with SMTP id p76so1566332pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:22:16 -0700 (PDT)
Subject: [PATCHv2 10/11] mac80211: tkip.c fold ieee80211_gen_rc4key into
	its one caller
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 14:22:00 -0700
Message-Id: <1213219321.5974.183.camel@brick> (sfid-20080611_232221_211678_4F2DB38A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also change the arguments of the phase1, 2 key mixing to take
a pointer to the encrytion key and the tkip_ctx in the same
order.

Do the dereference of the encryption key in the callers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index a8900e3..1fc744c 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -72,7 +72,6 @@ static u8 *write_tkip_iv(u8 *pos, u16 iv16)
 	return pos;
 }
 
-
 /*
  * P1K := Phase1(TA, TK, TSC)
  * TA = transmitter address (48 bits)
@@ -80,11 +79,10 @@ static u8 *write_tkip_iv(u8 *pos, u16 iv16)
  * TSC = TKIP sequence counter (48 bits, only 32 msb bits used)
  * P1K: 80 bits
  */
-static void tkip_mixing_phase1(struct ieee80211_key *key, const u8 *ta,
-			       struct tkip_ctx *ctx, u32 tsc_IV32)
+static void tkip_mixing_phase1(const u8 *tk, struct tkip_ctx *ctx,
+			       const u8 *ta, u32 tsc_IV32)
 {
 	int i, j;
-	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 	u16 *p1k = ctx->p1k;
 
 	p1k[0] = tsc_IV32 & 0xFFFF;
@@ -104,12 +102,11 @@ static void tkip_mixing_phase1(struct ieee80211_key *key, const u8 *ta,
 	ctx->initialized = 1;
 }
 
-static void tkip_mixing_phase2(struct ieee80211_key *key, struct tkip_ctx *ctx,
+static void tkip_mixing_phase2(const u8 *tk, struct tkip_ctx *ctx,
 			       u16 tsc_IV16, u8 *rc4key)
 {
 	u16 ppk[6];
 	const u16 *p1k = ctx->p1k;
-	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 	int i;
 
 	ppk[0] = p1k[0];
@@ -150,16 +147,6 @@ u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key, u16 iv16)
 	return pos + 4;
 }
 
-static void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
-			       u8 *rc4key)
-{
-	/* Calculate per-packet key */
-	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized)
-		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, key->u.tkip.tx.iv32);
-
-	tkip_mixing_phase2(key, &key->u.tkip.tx, key->u.tkip.tx.iv16, rc4key);
-}
-
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 			struct sk_buff *skb, enum ieee80211_tkip_key_type type,
 			u8 *outkey)
@@ -170,6 +157,7 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	u8 *data = (u8 *) hdr;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	int hdr_len = ieee80211_get_hdrlen(fc);
+	u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 	u8 *ta = hdr->addr2;
 	u16 iv16;
 	u32 iv32;
@@ -193,14 +181,14 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
 	if (iv16 == 0 || !key->u.tkip.tx.initialized)
-		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, iv32);
+		tkip_mixing_phase1(tk, &key->u.tkip.tx, ta, iv32);
 
 	if (type == IEEE80211_TKIP_P1_KEY) {
 		memcpy(outkey, key->u.tkip.tx.p1k, sizeof(u16) * 5);
 		return;
 	}
 
-	tkip_mixing_phase2(key, &key->u.tkip.tx, iv16, outkey);
+	tkip_mixing_phase2(tk, &key->u.tkip.tx, iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
 
@@ -214,8 +202,15 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 u8 *pos, size_t payload_len, u8 *ta)
 {
 	u8 rc4key[16];
+	struct tkip_ctx *ctx = &key->u.tkip.tx;
+	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
+
+	/* Calculate per-packet key */
+	if (ctx->iv16 == 0 || !ctx->initialized)
+		tkip_mixing_phase1(tk, ctx, ta, ctx->iv32);
+
+	tkip_mixing_phase2(tk, ctx, ctx->iv16, rc4key);
 
-	ieee80211_tkip_gen_rc4key(key, ta, rc4key);
 	pos = ieee80211_tkip_add_iv(pos, key, key->u.tkip.tx.iv16);
 	ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
 }
@@ -234,6 +229,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 	u32 iv16;
 	u8 rc4key[16], keyid, *pos = payload;
 	int res;
+	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 
 	if (payload_len < 12)
 		return -1;
@@ -284,7 +280,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 	if (!key->u.tkip.rx[queue].initialized ||
 	    key->u.tkip.rx[queue].iv32 != iv32) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(key, ta, &key->u.tkip.rx[queue], iv32);
+		tkip_mixing_phase1(tk, &key->u.tkip.rx[queue], ta, iv32);
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
@@ -317,7 +313,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		}
 	}
 
-	tkip_mixing_phase2(key, &key->u.tkip.rx[queue], iv16, rc4key);
+	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
 	{
 		int i;
-- 
1.5.6.rc2.261.ga8fbe


