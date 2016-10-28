Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55570 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934180AbcJ1SI2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Oct 2016 14:08:28 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: fix incorrect error return path on tmp allocation failure
Date: Fri, 28 Oct 2016 19:08:24 +0100
Message-Id: <20161028180824.7110-1-colin.king@canonical.com> (sfid-20161028_200852_698594_32A2BC9A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The current exit path when tmp fails to be allocated is via the
fail label which frees tfm2 which has not yet been allocated,
which is problematic since tfm2 is not initialized and is a garbage
pointer. Fix this by exiting directly to the return at the end
of the function and hence avoiding the freeing of tfm2.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mac80211/fils_aead.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index b81b4f24..c114737 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -112,7 +112,7 @@ static int aes_siv_encrypt(const u8 *key, size_t key_len,
 	tmp = kmemdup(plain, plain_len, GFP_KERNEL);
 	if (!tmp) {
 		res = -ENOMEM;
-		goto fail;
+		goto fail_ret;
 	}
 
 	/* IV for CTR before encrypted data */
@@ -150,6 +150,7 @@ static int aes_siv_encrypt(const u8 *key, size_t key_len,
 fail:
 	kfree(tmp);
 	crypto_free_skcipher(tfm2);
+fail_ret:
 	return res;
 }
 
-- 
2.9.3
