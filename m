Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755931AbYENX1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 19:27:06 -0400
Message-Id: <200805142326.m4ENQIWp027091@imap1.linux-foundation.org> (sfid-20080515_012710_228676_70B9FE14)
Subject: [patch 05/12] mac80211: add const, remove unused function, make one function static
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2008 16:26:18 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |    7 +++----
 net/mac80211/michael.h |    4 ++--
 net/mac80211/tkip.c    |   12 ++----------
 net/mac80211/tkip.h    |    4 ----
 4 files changed, 7 insertions(+), 20 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/michael.c
@@ -6,7 +6,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <asm/unaligned.h>
@@ -28,7 +27,7 @@ static void michael_block(struct michael
 }
 
 static void michael_mic_hdr(struct michael_mic_ctx *mctx,
-			    u8 *key, u8 *da, u8 *sa, u8 priority)
+			const u8 *key, const u8 *da, const u8 *sa, u8 priority)
 {
 	mctx->l = get_unaligned_le32(key);
 	mctx->r = get_unaligned_le32(key + 4);
@@ -44,8 +43,8 @@ static void michael_mic_hdr(struct micha
 	michael_block(mctx, priority);
 }
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic)
+void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+		 const u8 *data, size_t data_len, u8 *mic)
 {
 	u32 val;
 	size_t block, blocks, left;
diff -puN net/mac80211/michael.h~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/michael.h
--- a/net/mac80211/michael.h~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/michael.h
@@ -18,7 +18,7 @@ struct michael_mic_ctx {
 	u32 l, r;
 };
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic);
+void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+		 const u8 *data, size_t data_len, u8 *mic);
 
 #endif /* MICHAEL_H */
diff -puN net/mac80211/tkip.c~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/tkip.c
@@ -6,7 +6,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
@@ -132,7 +131,7 @@ static void tkip_mixing_phase2(const u16
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
-u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2)
 {
 	*pos++ = iv0;
@@ -143,14 +142,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
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
diff -puN net/mac80211/tkip.h~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/tkip.h
--- a/net/mac80211/tkip.h~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/tkip.h
@@ -15,10 +15,6 @@
 
 u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			  u8 iv0, u8 iv1, u8 iv2);
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key);
-void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
-			       u8 *rc4key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
_
