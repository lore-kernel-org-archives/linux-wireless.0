Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934868AbYEBUsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 16:48:20 -0400
Message-Id: <200805022047.m42Klmv4014227@imap1.linux-foundation.org> (sfid-20080502_224756_199374_77148E52)
Subject: [patch 7/9] mac80211: tkip.c use struct tkip_ctx in phase 2 key mixing
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2008 13:47:47 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing
+++ a/net/mac80211/tkip.c
@@ -95,10 +95,12 @@ static void tkip_mixing_phase1(struct ie
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
@@ -152,9 +154,7 @@ static void ieee80211_tkip_gen_rc4key(st
 	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized)
 		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, key->u.tkip.tx.iv32);
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.tx.iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, key->u.tkip.tx.iv16, rc4key);
 }
 
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
@@ -197,8 +197,7 @@ void ieee80211_get_tkip_key(struct ieee8
 		return;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
 
@@ -315,9 +314,7 @@ int ieee80211_tkip_decrypt_data(struct c
 		}
 	}
 
-	tkip_mixing_phase2(key->u.tkip.rx[queue].p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.rx[queue], iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
 	{
 		int i;
_
