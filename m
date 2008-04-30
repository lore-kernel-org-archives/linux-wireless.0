Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:42482 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbYD3BIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 21:08:02 -0400
Received: by wa-out-1112.google.com with SMTP id m16so391916waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2008 18:08:02 -0700 (PDT)
Subject: [PATCH 7/7] mac80211: tkip.c use struct tkip_ctx in phase 2 key
	mixing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 18:07:37 -0700
Message-Id: <1209517670.24729.56.camel@brick> (sfid-20080430_030757_802490_5D4FAF6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index e9ee247..a00cf1e 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -95,10 +95,12 @@ static void tkip_mixing_phase1(struct ieee80211_key *key, const u8 *ta,
 	ctx->initialized = 1;
 }
 
-static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
-			       u8 *rc4key)
+static void tkip_mixing_phase2(struct ieee80211_key *key, struct tkip_ctx *ctx,
+			       u16 tsc_IV16, u8 *rc4key)
 {
 	u16 ppk[6];
+	const u16 *p1k = ctx->p1k;
+	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 	int i;
 
 	ppk[0] = p1k[0];
@@ -152,9 +154,7 @@ static void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized)
 		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, key->u.tkip.tx.iv32);
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.tx.iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, key->u.tkip.tx.iv16, rc4key);
 }
 
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
@@ -197,8 +197,7 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 		return;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
 
@@ -315,9 +314,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		}
 	}
 
-	tkip_mixing_phase2(key->u.tkip.rx[queue].p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.rx[queue], iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
 	{
 		int i;
-- 
1.5.5.144.g3e42

