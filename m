Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.249]:54275 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753164AbYDQUNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 16:13:44 -0400
Received: by rv-out-0506.google.com with SMTP id k29so112329rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 13:13:44 -0700 (PDT)
Subject: [PATCH 4/7] mac80211: add const, remove unused function, make one
	function static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 13:13:49 -0700
Message-Id: <1208463229.17196.26.camel@brick> (sfid-20080417_211451_832758_6B1DA99D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/michael.c |    7 +++----
 net/mac80211/michael.h |    4 ++--
 net/mac80211/tkip.c    |   12 ++----------
 net/mac80211/tkip.h    |    6 +-----
 4 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 4e151e0..1fcdf38 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -6,7 +6,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <asm/unaligned.h>
@@ -28,7 +27,7 @@ static void michael_block(struct michael_mic_ctx *mctx, u32 val)
 }
 
 static void michael_mic_hdr(struct michael_mic_ctx *mctx,
-			    u8 *key, u8 *da, u8 *sa, u8 priority)
+			const u8 *key, const u8 *da, const u8 *sa, u8 priority)
 {
 	mctx->l = get_unaligned_le32(key);
 	mctx->r = get_unaligned_le32(key + 4);
@@ -44,8 +43,8 @@ static void michael_mic_hdr(struct michael_mic_ctx *mctx,
 	michael_block(mctx, priority);
 }
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic)
+void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+		 const u8 *data, size_t data_len, u8 *mic)
 {
 	u32 val;
 	size_t block, blocks, left;
diff --git a/net/mac80211/michael.h b/net/mac80211/michael.h
index 7d5707b..69b4501 100644
--- a/net/mac80211/michael.h
+++ b/net/mac80211/michael.h
@@ -18,7 +18,7 @@ struct michael_mic_ctx {
 	u32 l, r;
 };
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic);
+void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+		 const u8 *data, size_t data_len, u8 *mic);
 
 #endif /* MICHAEL_H */
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index a7c3feb..8cdf053 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -6,7 +6,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
@@ -132,7 +131,7 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
-u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2)
 {
 	*pos++ = iv0;
@@ -143,14 +142,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 	return pos + 4;
 }
 
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
index b7c2ee7..7cfdb23 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -13,12 +13,8 @@
 #include <linux/crypto.h>
 #include "key.h"
 
-u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2);
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key);
-void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
-			       u8 *rc4key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
-- 
1.5.5.144.g3e42


