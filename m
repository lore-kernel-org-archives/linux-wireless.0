Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64120 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaAPLQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 06:16:37 -0500
Received: by mail-wg0-f51.google.com with SMTP id z12so2952237wgg.18
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 03:16:35 -0800 (PST)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: patches@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] mac80211: drop unused param 'encrypted' from ccmp_special_blocks()
Date: Thu, 16 Jan 2014 12:16:30 +0100
Message-Id: <1389870990-3735-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20140116_121640_417536_FD792BDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 7ec7c4a9a686 ("mac80211: port CCMP to cryptoapi's CCM driver")
resulted in the 'encrypted' param of ccmp_special_blocks() to be no
longer used so it can be dropped from the prototype.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 net/mac80211/wpa.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index d65728220763..0781840c8415 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -301,8 +301,7 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 }
 
 
-static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
-				int encrypted)
+static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad)
 {
 	__le16 mask_fc;
 	int a4_included, mgmt;
@@ -456,7 +455,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 
 	pos += IEEE80211_CCMP_HDR_LEN;
-	ccmp_special_blocks(skb, pn, b_0, aad, 0);
+	ccmp_special_blocks(skb, pn, b_0, aad);
 	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, b_0, aad, pos, len,
 				  skb_put(skb, IEEE80211_CCMP_MIC_LEN));
 
@@ -524,7 +523,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 		u8 aad[2 * AES_BLOCK_SIZE];
 		u8 b_0[AES_BLOCK_SIZE];
 		/* hardware didn't decrypt/verify MIC */
-		ccmp_special_blocks(skb, pn, b_0, aad, 1);
+		ccmp_special_blocks(skb, pn, b_0, aad);
 
 		if (ieee80211_aes_ccm_decrypt(
 			    key->u.ccmp.tfm, b_0, aad,
-- 
1.8.3.2

