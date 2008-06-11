Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:26201 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764302AbYFKRBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 13:01:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3186201wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 10:01:36 -0700 (PDT)
Subject: [PATCH 1/3] mac80211: tkip.c consolidate tkip IV writing in helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 10:01:35 -0700
Message-Id: <1213203695.5974.133.camel@brick> (sfid-20080611_190144_382710_0807795C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   25 ++++++++++++++-----------
 net/mac80211/tkip.h |    4 ++--
 net/mac80211/wpa.c  |    8 +-------
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index a00cf1e..a8900e3 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -64,6 +64,15 @@ static u16 tkipS(u16 val)
 	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
 }
 
+static u8 *write_tkip_iv(u8 *pos, u16 iv16)
+{
+	*pos++ = iv16 >> 8;
+	*pos++ = ((iv16 >> 8) | 0x20) & 0x7f;
+	*pos++ = iv16 & 0xFF;
+	return pos;
+}
+
+
 /*
  * P1K := Phase1(TA, TK, TSC)
  * TA = transmitter address (48 bits)
@@ -123,12 +132,9 @@ static void tkip_mixing_phase2(struct ieee80211_key *key, struct tkip_ctx *ctx,
 	ppk[4] += ror16(ppk[3], 1);
 	ppk[5] += ror16(ppk[4], 1);
 
-	rc4key[0] = tsc_IV16 >> 8;
-	rc4key[1] = ((tsc_IV16 >> 8) | 0x20) & 0x7f;
-	rc4key[2] = tsc_IV16 & 0xFF;
-	rc4key[3] = ((ppk[5] ^ get_unaligned_le16(tk)) >> 1) & 0xFF;
+	rc4key = write_tkip_iv(rc4key, tsc_IV16);
+	*rc4key++ = ((ppk[5] ^ get_unaligned_le16(tk)) >> 1) & 0xFF;
 
-	rc4key += 4;
 	for (i = 0; i < 6; i++)
 		put_unaligned_le16(ppk[i], rc4key + 2 * i);
 }
@@ -136,12 +142,9 @@ static void tkip_mixing_phase2(struct ieee80211_key *key, struct tkip_ctx *ctx,
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
-u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
-			   u8 iv0, u8 iv1, u8 iv2)
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key, u16 iv16)
 {
-	*pos++ = iv0;
-	*pos++ = iv1;
-	*pos++ = iv2;
+	pos = write_tkip_iv(pos, iv16); 
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
 	put_unaligned_le32(key->u.tkip.tx.iv32, pos);
 	return pos + 4;
@@ -213,7 +216,7 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 	u8 rc4key[16];
 
 	ieee80211_tkip_gen_rc4key(key, ta, rc4key);
-	pos = ieee80211_tkip_add_iv(pos, key, rc4key[0], rc4key[1], rc4key[2]);
+	pos = ieee80211_tkip_add_iv(pos, key, key->u.tkip.tx.iv16);
 	ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
 }
 
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index b890427..d471438 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -13,8 +13,8 @@
 #include <linux/crypto.h>
 #include "key.h"
 
-u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
-			  u8 iv0, u8 iv1, u8 iv2);
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key, u16 iv16);
+
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9834cec..345e10e 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -198,14 +198,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		key->u.tkip.tx.iv32++;
 
 	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-		hdr = (struct ieee80211_hdr *)skb->data;
-
 		/* hwaccel - with preallocated room for IV */
-		ieee80211_tkip_add_iv(pos, key,
-				      (u8) (key->u.tkip.tx.iv16 >> 8),
-				      (u8) (((key->u.tkip.tx.iv16 >> 8) | 0x20) &
-					    0x7f),
-				      (u8) key->u.tkip.tx.iv16);
+		ieee80211_tkip_add_iv(pos, key, key->u.tkip.tx.iv16);
 
 		info->control.hw_key = &tx->key->conf;
 		return 0;
-- 
1.5.6.rc2.261.ga8fbe


