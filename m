Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:37229 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYCHJXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 04:23:07 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1079716wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 08 Mar 2008 01:23:07 -0800 (PST)
Subject: [PATCH 5/5] mac80211: remove Hi8/Lo8 helpers, add initialization
	vector helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 01:23:08 -0800
Message-Id: <1204968188.23455.41.camel@brick> (sfid-20080308_092341_810876_E42905A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   51 +++++++++++++++++++++++++--------------------------
 net/mac80211/tkip.h |    3 +--
 net/mac80211/wpa.c  |    6 +-----
 3 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 264e392..07f7112 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -60,16 +60,6 @@ static const u16 tkip_sbox[256] =
 	0x82C3, 0x29B0, 0x5A77, 0x1E11, 0x7BCB, 0xA8FC, 0x6DD6, 0x2C3A,
 };
 
-static inline u8 Hi8(u16 v)
-{
-	return v >> 8;
-}
-
-static inline u8 Lo8(u16 v)
-{
-	return v & 0xff;
-}
-
 static u16 tkip_S(u16 val)
 {
 	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
@@ -104,6 +94,19 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 	}
 }
 
+static u8 *set_ext_iv(u8 *pos, u16 iv16)
+{
+	*pos++ = iv16 >> 8;
+	*pos++ = ((iv16 >> 8) | 0x20) & 0x7f;
+	*pos++ = iv16 & 0xff;
+	return pos;
+}
+
+static u8 *set_tkip_iv(u8 *pos, u32 iv32)
+{
+	*((u32 *)pos) = cpu_to_le32(iv32);
+	return pos + 4;
+}
 
 static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 			       u8 *rc4key)
@@ -133,14 +136,12 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	ppk[5] += ror16(ppk[4], 1);
 
 	leptr = (__le16 *)tk;
-	rc4key[0] = Hi8(tsc_IV16);
-	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
-	rc4key[2] = Lo8(tsc_IV16);
-	rc4key[3] = Lo8((ppk[5] ^ le16_to_cpup(leptr)) >> 1);
+	set_ext_iv(rc4key, tsc_IV16);
+	rc4key[3] = ((ppk[5] ^ le16_to_cpup(leptr)) >> 1) & 0xff;
 
 	for (i = 0; i < 6; i++) {
-		rc4key[4 + 2 * i] = Lo8(ppk[i]);
-		rc4key[5 + 2 * i] = Hi8(ppk[i]);
+		rc4key[4 + 2 * i] = (ppk[i]) & 0xff;
+		rc4key[5 + 2 * i] = (ppk[i]) >> 8;
 	}
 }
 
@@ -148,17 +149,11 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
-u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
-			   u8 iv0, u8 iv1, u8 iv2)
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key)
 {
-	*pos++ = iv0;
-	*pos++ = iv1;
-	*pos++ = iv2;
+	pos = set_ext_iv(pos, key->u.tkip.iv16);
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
-	*pos++ = key->u.tkip.iv32 & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 8) & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 16) & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 24) & 0xff;
+	pos = set_tkip_iv(pos, key->u.tkip.iv32);
 	return pos;
 }
 
@@ -190,7 +185,11 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 	u8 rc4key[16];
 
 	ieee80211_tkip_gen_rc4key(key, ta, rc4key);
-	pos = ieee80211_tkip_add_iv(pos, key, rc4key[0], rc4key[1], rc4key[2]);
+	*pos++ = rc4key[0];
+	*pos++ = rc4key[1];
+	*pos++ = rc4key[2];
+	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
+	pos = set_tkip_iv(pos, key->u.tkip.iv32);
 	ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
 }
 
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index 944d5fa..662354b 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -13,8 +13,7 @@
 #include <linux/crypto.h>
 #include "ieee80211_key.h"
 
-u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
-			   u8 iv0, u8 iv1, u8 iv2);
+u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b35e51c..78ebcb7 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -222,11 +222,7 @@ static int tkip_encrypt_skb(struct ieee80211_txrx_data *tx,
 		hdr = (struct ieee80211_hdr *)skb->data;
 
 		/* hwaccel - with preallocated room for IV */
-		ieee80211_tkip_add_iv(pos, key,
-				      (u8) (key->u.tkip.iv16 >> 8),
-				      (u8) (((key->u.tkip.iv16 >> 8) | 0x20) &
-					    0x7f),
-				      (u8) key->u.tkip.iv16);
+		ieee80211_tkip_add_iv(pos, key);
 
 		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
-- 
1.5.4.GIT

