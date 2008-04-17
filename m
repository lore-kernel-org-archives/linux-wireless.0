Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.249]:54275 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753164AbYDQUNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 16:13:48 -0400
Received: by rv-out-0506.google.com with SMTP id k29so112329rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 13:13:48 -0700 (PDT)
Subject: [PATCH 6/7] mac80211: tkip.c use struct tkip_ctx in phase 1 key
	mixing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 13:13:50 -0700
Message-Id: <1208463230.17196.28.camel@brick> (sfid-20080417_211453_095887_3757861D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index d74c91e..e9ee247 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -71,10 +71,12 @@ static u16 tkipS(u16 val)
  * TSC = TKIP sequence counter (48 bits, only 32 msb bits used)
  * P1K: 80 bits
  */
-static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
-			       u16 *p1k)
+static void tkip_mixing_phase1(struct ieee80211_key *key, const u8 *ta,
+			       struct tkip_ctx *ctx, u32 tsc_IV32)
 {
 	int i, j;
+	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
+	u16 *p1k = ctx->p1k;
 
 	p1k[0] = tsc_IV32 & 0xFFFF;
 	p1k[1] = tsc_IV32 >> 16;
@@ -90,6 +92,7 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 		p1k[3] += tkipS(p1k[2] ^ get_unaligned_le16(tk + 12 + j));
 		p1k[4] += tkipS(p1k[3] ^ get_unaligned_le16(tk + 0 + j)) + i;
 	}
+	ctx->initialized = 1;
 }
 
 static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
@@ -146,12 +149,8 @@ static void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
-	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized) {
-		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   key->u.tkip.tx.iv32, key->u.tkip.tx.p1k);
-		key->u.tkip.tx.initialized = 1;
-	}
+	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized)
+		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, key->u.tkip.tx.iv32);
 
 	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
@@ -190,12 +189,8 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
-	if (iv16 == 0 || !key->u.tkip.tx.initialized) {
-		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			iv32, key->u.tkip.tx.p1k);
-		key->u.tkip.tx.initialized = 1;
-	}
+	if (iv16 == 0 || !key->u.tkip.tx.initialized)
+		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, iv32);
 
 	if (type == IEEE80211_TKIP_P1_KEY) {
 		memcpy(outkey, key->u.tkip.tx.p1k, sizeof(u16) * 5);
@@ -286,10 +281,8 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 
 	if (!key->u.tkip.rx[queue].initialized ||
 	    key->u.tkip.rx[queue].iv32 != iv32) {
-		key->u.tkip.rx[queue].initialized = 1;
 		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   iv32, key->u.tkip.rx[queue].p1k);
+		tkip_mixing_phase1(key, ta, &key->u.tkip.rx[queue], iv32);
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
-- 
1.5.5.144.g3e42


