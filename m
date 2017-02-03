Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34231 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752012AbdBCT0W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 14:26:22 -0500
Received: by mail-wm0-f50.google.com with SMTP id 196so17449733wmm.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2017 11:26:21 -0800 (PST)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        jouni@qca.qualcomm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/2] mac80211: fils_aead: clone shared CMAC functions into private version
Date: Fri,  3 Feb 2017 19:25:54 +0000
Message-Id: <1486149955-11825-2-git-send-email-ard.biesheuvel@linaro.org> (sfid-20170203_202627_131739_8ADE3A52)
In-Reply-To: <1486149955-11825-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486149955-11825-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before reworking the AES CMAC mac80211 code, clone the routines that it
shares with the FILS AEAD driver into its own source file, and remove the
external declaration from aes_cmac.h. This will allow us to carry over one
user at a time from the open coded CMAC code to the crypto API.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 net/mac80211/aes_cmac.h  |  4 --
 net/mac80211/fils_aead.c | 68 ++++++++++++++++++++
 2 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/aes_cmac.h b/net/mac80211/aes_cmac.h
index c827e1d5de8b..3702041f44fd 100644
--- a/net/mac80211/aes_cmac.h
+++ b/net/mac80211/aes_cmac.h
@@ -11,10 +11,6 @@
 
 #include <linux/crypto.h>
 
-void gf_mulx(u8 *pad);
-void aes_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
-		     const u8 *addr[], const size_t *len, u8 *mac,
-		     size_t mac_len);
 struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[],
 						   size_t key_len);
 void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index ecfdd97758a3..ec493e68957c 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -15,6 +15,74 @@
 #include "aes_cmac.h"
 #include "fils_aead.h"
 
+static void gf_mulx(u8 *pad)
+{
+	int i, carry;
+
+	carry = pad[0] & 0x80;
+	for (i = 0; i < AES_BLOCK_SIZE - 1; i++)
+		pad[i] = (pad[i] << 1) | (pad[i + 1] >> 7);
+	pad[AES_BLOCK_SIZE - 1] <<= 1;
+	if (carry)
+		pad[AES_BLOCK_SIZE - 1] ^= 0x87;
+}
+
+static void aes_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
+			    const u8 *addr[], const size_t *len, u8 *mac,
+			    size_t mac_len)
+{
+	u8 cbc[AES_BLOCK_SIZE], pad[AES_BLOCK_SIZE];
+	const u8 *pos, *end;
+	size_t i, e, left, total_len;
+
+	memset(cbc, 0, AES_BLOCK_SIZE);
+
+	total_len = 0;
+	for (e = 0; e < num_elem; e++)
+		total_len += len[e];
+	left = total_len;
+
+	e = 0;
+	pos = addr[0];
+	end = pos + len[0];
+
+	while (left >= AES_BLOCK_SIZE) {
+		for (i = 0; i < AES_BLOCK_SIZE; i++) {
+			cbc[i] ^= *pos++;
+			if (pos >= end) {
+				e++;
+				pos = addr[e];
+				end = pos + len[e];
+			}
+		}
+		if (left > AES_BLOCK_SIZE)
+			crypto_cipher_encrypt_one(tfm, cbc, cbc);
+		left -= AES_BLOCK_SIZE;
+	}
+
+	memset(pad, 0, AES_BLOCK_SIZE);
+	crypto_cipher_encrypt_one(tfm, pad, pad);
+	gf_mulx(pad);
+
+	if (left || total_len == 0) {
+		for (i = 0; i < left; i++) {
+			cbc[i] ^= *pos++;
+			if (pos >= end) {
+				e++;
+				pos = addr[e];
+				end = pos + len[e];
+			}
+		}
+		cbc[left] ^= 0x80;
+		gf_mulx(pad);
+	}
+
+	for (i = 0; i < AES_BLOCK_SIZE; i++)
+		pad[i] ^= cbc[i];
+	crypto_cipher_encrypt_one(tfm, pad, pad);
+	memcpy(mac, pad, mac_len);
+}
+
 static int aes_s2v(struct crypto_cipher *tfm,
 		   size_t num_elem, const u8 *addr[], size_t len[], u8 *v)
 {
-- 
2.7.4
