Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:11652 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYGHS1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 14:27:36 -0400
Received: by yx-out-2324.google.com with SMTP id 8so658804yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 11:27:36 -0700 (PDT)
Subject: [PATCH 8/8] mac80211: aes_ccm.c remove crypto wrapper and extra
	args
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 11:00:29 -0700
Message-Id: <1215540029.476.23.camel@brick> (sfid-20080708_202739_054184_A5240441)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/aes_ccm.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index e756ed9..a87cb3b 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -16,31 +16,28 @@
 #include "key.h"
 #include "aes_ccm.h"
 
-
-static void ieee80211_aes_encrypt(struct crypto_cipher *tfm,
-				  const u8 pt[16], u8 ct[16])
-{
-	crypto_cipher_encrypt_one(tfm, ct, pt);
-}
-
-
-static inline void aes_ccm_prepare(struct crypto_cipher *tfm, u8 *b_0, u8 *aad,
-				   u8 *b, u8 *s_0, u8 *a)
+static void aes_ccm_prepare(struct crypto_cipher *tfm, u8 *scratch, u8 *a)
 {
 	int i;
+	u8 *b_0, *aad, *b, *s_0;
 
-	ieee80211_aes_encrypt(tfm, b_0, b);
+	b_0 = scratch + 3 * AES_BLOCK_LEN;
+	aad = scratch + 4 * AES_BLOCK_LEN;
+	b = scratch;
+	s_0 = scratch + AES_BLOCK_LEN;
+
+	crypto_cipher_encrypt_one(tfm, b, b_0);
 
 	/* Extra Authenticate-only data (always two AES blocks) */
 	for (i = 0; i < AES_BLOCK_LEN; i++)
 		aad[i] ^= b[i];
-	ieee80211_aes_encrypt(tfm, aad, b);
+	crypto_cipher_encrypt_one(tfm, b, aad);
 
 	aad += AES_BLOCK_LEN;
 
 	for (i = 0; i < AES_BLOCK_LEN; i++)
 		aad[i] ^= b[i];
-	ieee80211_aes_encrypt(tfm, aad, a);
+	crypto_cipher_encrypt_one(tfm, a, aad);
 
 	/* Mask out bits from auth-only-b_0 */
 	b_0[0] &= 0x07;
@@ -48,7 +45,7 @@ static inline void aes_ccm_prepare(struct crypto_cipher *tfm, u8 *b_0, u8 *aad,
 	/* S_0 is used to encrypt T (= MIC) */
 	b_0[14] = 0;
 	b_0[15] = 0;
-	ieee80211_aes_encrypt(tfm, b_0, s_0);
+	crypto_cipher_encrypt_one(tfm, s_0, b_0);
 }
 

@@ -67,7 +64,7 @@ void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
 
 	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
 	last_len = data_len % AES_BLOCK_LEN;
-	aes_ccm_prepare(tfm, b_0, aad, b, s_0, b);
+	aes_ccm_prepare(tfm, scratch, b);
 
 	/* Process payload blocks */
 	pos = data;
@@ -79,11 +76,11 @@ void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
 		/* Authentication followed by encryption */
 		for (i = 0; i < blen; i++)
 			b[i] ^= pos[i];
-		ieee80211_aes_encrypt(tfm, b, b);
+		crypto_cipher_encrypt_one(tfm, b, b);
 
 		b_0[14] = (j >> 8) & 0xff;
 		b_0[15] = j & 0xff;
-		ieee80211_aes_encrypt(tfm, b_0, e);
+		crypto_cipher_encrypt_one(tfm, e, b_0);
 		for (i = 0; i < blen; i++)
 			*cpos++ = *pos++ ^ e[i];
 	}
@@ -107,7 +104,7 @@ int ieee80211_aes_ccm_decrypt(struct crypto_cipher *tfm, u8 *scratch,
 
 	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
 	last_len = data_len % AES_BLOCK_LEN;
-	aes_ccm_prepare(tfm, b_0, aad, b, s_0, a);
+	aes_ccm_prepare(tfm, scratch, a);
 
 	/* Process payload blocks */
 	cpos = cdata;
@@ -119,13 +116,12 @@ int ieee80211_aes_ccm_decrypt(struct crypto_cipher *tfm, u8 *scratch,
 		/* Decryption followed by authentication */
 		b_0[14] = (j >> 8) & 0xff;
 		b_0[15] = j & 0xff;
-		ieee80211_aes_encrypt(tfm, b_0, b);
+		crypto_cipher_encrypt_one(tfm, b, b_0);
 		for (i = 0; i < blen; i++) {
 			*pos = *cpos++ ^ b[i];
 			a[i] ^= *pos++;
 		}
-
-		ieee80211_aes_encrypt(tfm, a, a);
+		crypto_cipher_encrypt_one(tfm, a, a);
 	}
 
 	for (i = 0; i < CCMP_MIC_LEN; i++) {
-- 
1.5.6.1.322.ge904b

