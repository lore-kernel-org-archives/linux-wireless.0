Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:9218 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762708AbYCSUxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 16:53:23 -0400
Received: by rn-out-0910.google.com with SMTP id v46so565536rnb.15
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 13:53:22 -0700 (PDT)
Subject: [PATCH 2/5] mac80211: tkip.c remove unused function, make function
	static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 14:28:35 -0700
Message-Id: <1205875715.17607.21.camel@brick> (sfid-20080319_205432_972551_94092E07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

make static void ieee80211_tkip_gen_rc4key static
remove the unused ieee80211_tkip_gen_phase1key

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   10 +---------
 net/mac80211/tkip.h |    4 ----
 2 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index a5745c1..f4b0c85 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -184,15 +184,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
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
1.5.4.4.684.g0e08


