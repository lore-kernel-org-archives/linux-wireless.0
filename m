Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:44989 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYCHJXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 04:23:04 -0500
Received: by rv-out-0910.google.com with SMTP id k20so492983rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Mar 2008 01:23:03 -0800 (PST)
Subject: [PATCH 2/5] tkip: remove unused function, other cleanups
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 01:23:04 -0800
Message-Id: <1204968185.23455.38.camel@brick> (sfid-20080308_092340_520643_C35AE989)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tkip_S had an opencoded swab16
make ieee80211_tkip_gen_rc4key() static
remove the unused ieee80211_tkip_gen_phase1key()

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   18 +++---------------
 net/mac80211/tkip.h |    4 ----
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 229b4b4..90c11e7 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -90,11 +90,9 @@ static inline u16 Lo16(u32 v)
 	return v & 0xffff;
 }
 
-static inline u16 tkip_S(u16 val)
+static u16 tkip_S(u16 val)
 {
-	u16 a = tkip_sbox[Hi8(val)];
-
-	return tkip_sbox[Lo8(val)] ^ Hi8(a) ^ (Lo8(a) << 8);
+	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
 }
 

@@ -182,15 +180,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 	return pos;
 }
 
-
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key)
-{
-	tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv32, phase1key);
-}
-
-void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
+static void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
@@ -337,5 +327,3 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 
 	return res;
 }
-
-
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index 73d8ef2..944d5fa 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -15,10 +15,6 @@
 
 u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2);
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key);
-void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
-			       u8 *rc4key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
-- 
1.5.4.GIT


