Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1090 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdBDQJJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Feb 2017 11:09:09 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] mac80211: Allocate a sync skcipher explicitly for FILS AEAD
Date: Sat, 4 Feb 2017 18:08:42 +0200
Message-ID: <1486224522-26392-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170204_170939_470770_CF62C597)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The skcipher could have been of the async variant which may return from
skcipher_encrypt() with -EINPROGRESS after having queued the request.
The FILS AEAD implementation here does not have code for dealing with
that possibility, so allocate a sync cipher explicitly to avoid
potential issues with hardware accelerators.

This is based on the patch sent out by Ard.

Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode association frames")
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/fils_aead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index e3bbe24..912f3e2c 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -192,7 +192,7 @@ static int aes_siv_encrypt(const u8 *key, size_t key_len,
 
 	/* CTR */
 
-	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, 0);
+	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm2)) {
 		kfree(tmp);
 		return PTR_ERR(tfm2);
@@ -251,7 +251,7 @@ static int aes_siv_decrypt(const u8 *key, size_t key_len,
 
 	/* CTR */
 
-	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, 0);
+	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm2))
 		return PTR_ERR(tfm2);
 	/* K2 for CTR */
-- 
2.7.4
