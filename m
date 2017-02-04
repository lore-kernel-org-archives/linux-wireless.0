Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24051 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753923AbdBDMAX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Feb 2017 07:00:23 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] mac80211: Fix FILS AEAD protection in Association Request frame
Date: Sat, 4 Feb 2017 13:59:22 +0200
Message-ID: <1486209562-23415-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170204_130029_863904_A7D25D47)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorrect num_elem parameter value (1 vs. 5) was used in the
aes_siv_encrypt() call. This resulted in only the first one of the five
AAD vectors to SIV getting included in calculation. This does not
protect all the contents correctly and would not interoperate with a
standard compliant implementation.

Fix this by using the correct number. A matching fix is needed in the AP
side (hostapd) to get FILS authentication working properly.

Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode association frames")
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/fils_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

If there is still time, it would be nice to get this included in Linux
4.10 since fils_aead.c is being added there. If not, Cc: stable could be
added.

diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index ecfdd97..e795aaa 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -272,7 +272,7 @@ int fils_encrypt_assoc_req(struct sk_buff *skb,
 	crypt_len = skb->data + skb->len - encr;
 	skb_put(skb, AES_BLOCK_SIZE);
 	return aes_siv_encrypt(assoc_data->fils_kek, assoc_data->fils_kek_len,
-			       encr, crypt_len, 1, addr, len, encr);
+			       encr, crypt_len, 5, addr, len, encr);
 }
 
 int fils_decrypt_assoc_resp(struct ieee80211_sub_if_data *sdata,
-- 
2.7.4
