Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1GFUCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 16:02:14 -0400
Subject: [PATCH] mac80211: use AES_BLOCK_SIZE
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 22:02:14 +0200
Message-ID: <1309982534.3893.14.camel@jlt3.sipsolutions.net> (sfid-20110706_220217_560495_D9347ED3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 has a defnition of AES_BLOCK_SIZE and
multiple definitions of AES_BLOCK_LEN. Remove
them all and use crypto/aes.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Applies on top of the race fixes.

 net/mac80211/aes_ccm.c  |   37 +++++++++++++++++++------------------
 net/mac80211/aes_ccm.h  |    2 --
 net/mac80211/aes_cmac.c |    2 +-
 net/mac80211/key.h      |    3 ---
 net/mac80211/wpa.c      |   10 +++++-----
 5 files changed, 25 insertions(+), 29 deletions(-)

--- a/net/mac80211/aes_ccm.c	2011-07-06 21:59:18.000000000 +0200
+++ b/net/mac80211/aes_ccm.c	2011-07-06 22:00:51.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/aes.h>
 
 #include <net/mac80211.h>
 #include "key.h"
@@ -21,21 +22,21 @@ static void aes_ccm_prepare(struct crypt
 	int i;
 	u8 *b_0, *aad, *b, *s_0;
 
-	b_0 = scratch + 3 * AES_BLOCK_LEN;
-	aad = scratch + 4 * AES_BLOCK_LEN;
+	b_0 = scratch + 3 * AES_BLOCK_SIZE;
+	aad = scratch + 4 * AES_BLOCK_SIZE;
 	b = scratch;
-	s_0 = scratch + AES_BLOCK_LEN;
+	s_0 = scratch + AES_BLOCK_SIZE;
 
 	crypto_cipher_encrypt_one(tfm, b, b_0);
 
 	/* Extra Authenticate-only data (always two AES blocks) */
-	for (i = 0; i < AES_BLOCK_LEN; i++)
+	for (i = 0; i < AES_BLOCK_SIZE; i++)
 		aad[i] ^= b[i];
 	crypto_cipher_encrypt_one(tfm, b, aad);
 
-	aad += AES_BLOCK_LEN;
+	aad += AES_BLOCK_SIZE;
 
-	for (i = 0; i < AES_BLOCK_LEN; i++)
+	for (i = 0; i < AES_BLOCK_SIZE; i++)
 		aad[i] ^= b[i];
 	crypto_cipher_encrypt_one(tfm, a, aad);
 
@@ -57,12 +58,12 @@ void ieee80211_aes_ccm_encrypt(struct cr
 	u8 *pos, *cpos, *b, *s_0, *e, *b_0;
 
 	b = scratch;
-	s_0 = scratch + AES_BLOCK_LEN;
-	e = scratch + 2 * AES_BLOCK_LEN;
-	b_0 = scratch + 3 * AES_BLOCK_LEN;
+	s_0 = scratch + AES_BLOCK_SIZE;
+	e = scratch + 2 * AES_BLOCK_SIZE;
+	b_0 = scratch + 3 * AES_BLOCK_SIZE;
 
-	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
-	last_len = data_len % AES_BLOCK_LEN;
+	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_SIZE);
+	last_len = data_len % AES_BLOCK_SIZE;
 	aes_ccm_prepare(tfm, scratch, b);
 
 	/* Process payload blocks */
@@ -70,7 +71,7 @@ void ieee80211_aes_ccm_encrypt(struct cr
 	cpos = cdata;
 	for (j = 1; j <= num_blocks; j++) {
 		int blen = (j == num_blocks && last_len) ?
-			last_len : AES_BLOCK_LEN;
+			last_len : AES_BLOCK_SIZE;
 
 		/* Authentication followed by encryption */
 		for (i = 0; i < blen; i++)
@@ -96,12 +97,12 @@ int ieee80211_aes_ccm_decrypt(struct cry
 	u8 *pos, *cpos, *b, *s_0, *a, *b_0;
 
 	b = scratch;
-	s_0 = scratch + AES_BLOCK_LEN;
-	a = scratch + 2 * AES_BLOCK_LEN;
-	b_0 = scratch + 3 * AES_BLOCK_LEN;
+	s_0 = scratch + AES_BLOCK_SIZE;
+	a = scratch + 2 * AES_BLOCK_SIZE;
+	b_0 = scratch + 3 * AES_BLOCK_SIZE;
 
-	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
-	last_len = data_len % AES_BLOCK_LEN;
+	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_SIZE);
+	last_len = data_len % AES_BLOCK_SIZE;
 	aes_ccm_prepare(tfm, scratch, a);
 
 	/* Process payload blocks */
@@ -109,7 +110,7 @@ int ieee80211_aes_ccm_decrypt(struct cry
 	pos = data;
 	for (j = 1; j <= num_blocks; j++) {
 		int blen = (j == num_blocks && last_len) ?
-			last_len : AES_BLOCK_LEN;
+			last_len : AES_BLOCK_SIZE;
 
 		/* Decryption followed by authentication */
 		b_0[14] = (j >> 8) & 0xff;
--- a/net/mac80211/aes_ccm.h	2011-07-06 21:59:17.000000000 +0200
+++ b/net/mac80211/aes_ccm.h	2011-07-06 22:00:51.000000000 +0200
@@ -12,8 +12,6 @@
 
 #include <linux/crypto.h>
 
-#define AES_BLOCK_LEN 16
-
 struct crypto_cipher *ieee80211_aes_key_setup_encrypt(const u8 key[]);
 void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
 			       u8 *data, size_t data_len,
--- a/net/mac80211/key.h	2011-07-06 22:00:49.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-06 22:00:51.000000000 +0200
@@ -92,9 +92,6 @@ struct ieee80211_key {
 			u8 rx_pn[NUM_RX_DATA_QUEUES + 1][6];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
-#ifndef AES_BLOCK_LEN
-#define AES_BLOCK_LEN 16
-#endif
 		} ccmp;
 		struct {
 			atomic64_t tx_pn;
--- a/net/mac80211/wpa.c	2011-07-06 22:00:49.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-07-06 22:00:51.000000000 +0200
@@ -291,10 +291,10 @@ static void ccmp_special_blocks(struct s
 	unsigned int hdrlen;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
-	memset(scratch, 0, 6 * AES_BLOCK_LEN);
+	memset(scratch, 0, 6 * AES_BLOCK_SIZE);
 
-	b_0 = scratch + 3 * AES_BLOCK_LEN;
-	aad = scratch + 4 * AES_BLOCK_LEN;
+	b_0 = scratch + 3 * AES_BLOCK_SIZE;
+	aad = scratch + 4 * AES_BLOCK_SIZE;
 
 	/*
 	 * Mask FC: zero subtype b4 b5 b6 (if not mgmt)
@@ -386,7 +386,7 @@ static int ccmp_encrypt_skb(struct ieee8
 	u8 *pos;
 	u8 pn[6];
 	u64 pn64;
-	u8 scratch[6 * AES_BLOCK_LEN];
+	u8 scratch[6 * AES_BLOCK_SIZE];
 
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
@@ -487,7 +487,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	}
 
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
-		u8 scratch[6 * AES_BLOCK_LEN];
+		u8 scratch[6 * AES_BLOCK_SIZE];
 		/* hardware didn't decrypt/verify MIC */
 		ccmp_special_blocks(skb, pn, scratch, 1);
 
--- a/net/mac80211/aes_cmac.c	2011-07-06 22:00:49.000000000 +0200
+++ b/net/mac80211/aes_cmac.c	2011-07-06 22:00:51.000000000 +0200
@@ -11,12 +11,12 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <crypto/aes.h>
 
 #include <net/mac80211.h>
 #include "key.h"
 #include "aes_cmac.h"
 
-#define AES_BLOCK_SIZE 16
 #define AES_CMAC_KEY_LEN 16
 #define CMAC_TLEN 8 /* CMAC TLen = 64 bits (8 octets) */
 #define AAD_LEN 20


