Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28482 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbbCWNln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 09:41:43 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix misplaced return in AES-GMAC key setup
Date: Mon, 23 Mar 2015 15:41:15 +0200
Message-ID: <1427118075-30959-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20150323_144147_089231_529B6EB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 8ade538bf39b ("mac80111: Add BIP-GMAC-128 and BIP-GMAC-256
ciphers") had the success return in incorrect place before the
crypto_aead_setauthsize() call which practically ended up skipping that
call unconditionally.

The missing call did not actually change any functionality since
GMAC_MIC_LEN (16) is identical to the maxauthsize in gcm(aes) and as
such, the default value used for the authsize parameter.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/aes_gmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/aes_gmac.c b/net/mac80211/aes_gmac.c
index 1c72edc..f1321b7 100644
--- a/net/mac80211/aes_gmac.c
+++ b/net/mac80211/aes_gmac.c
@@ -69,10 +69,10 @@ struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
 		return tfm;
 
 	err = crypto_aead_setkey(tfm, key, key_len);
-	if (!err)
-		return tfm;
 	if (!err)
 		err = crypto_aead_setauthsize(tfm, GMAC_MIC_LEN);
+	if (!err)
+		return tfm;
 
 	crypto_free_aead(tfm);
 	return ERR_PTR(err);
-- 
1.9.1

