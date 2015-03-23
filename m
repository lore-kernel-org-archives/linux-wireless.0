Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbCWOIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 10:08:30 -0400
Date: Mon, 23 Mar 2015 17:08:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [patch] mac80111: aes_ccm: cleanup ieee80211_aes_key_setup_encrypt()
Message-ID: <20150323140814.GA27609@mwanda> (sfid-20150323_150834_071043_A4722FF9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150323132409.GA20999@jouni.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code is written using an anti-pattern called "success handling"
which makes it hard to read, especially if you are used to normal kernel
style.  It should instead be written as a list of directives in a row
with branches for error handling.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index 7869bb40..208df7c 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -85,11 +85,15 @@ struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[],
 		return tfm;
 
 	err = crypto_aead_setkey(tfm, key, key_len);
-	if (!err)
-		err = crypto_aead_setauthsize(tfm, mic_len);
-	if (!err)
-		return tfm;
+	if (err)
+		goto free_aead;
+	err = crypto_aead_setauthsize(tfm, mic_len);
+	if (err)
+		goto free_aead;
+
+	return tfm;
 
+free_aead:
 	crypto_free_aead(tfm);
 	return ERR_PTR(err);
 }
