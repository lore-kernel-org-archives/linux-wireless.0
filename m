Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753904AbdFSPc2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 11:32:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 06/30] mac80211/wpa: use constant time memory comparison for MACs
Date: Mon, 19 Jun 2017 23:20:40 +0800
Message-Id: <20170619152033.564848069@linuxfoundation.org> (sfid-20170619_174510_477137_1F70D4D6)
In-Reply-To: <20170619152033.211450261@linuxfoundation.org>
References: <20170619152033.211450261@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 98c67d187db7808b1f3c95f2110dd4392d034182 upstream.

Otherwise, we enable all sorts of forgeries via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/wpa.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -16,6 +16,7 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 
 #include "ieee80211_i.h"
 #include "michael.h"
@@ -152,7 +153,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
 	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
 	michael_mic(key, hdr, data, data_len, mic);
-	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
+	if (crypto_memneq(mic, data + data_len, MICHAEL_MIC_LEN))
 		goto mic_fail;
 
 	/* remove Michael MIC from payload */
@@ -1044,7 +1045,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
 				   skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
@@ -1094,7 +1095,7 @@ ieee80211_crypto_aes_cmac_256_decrypt(st
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
 				       skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
@@ -1198,7 +1199,7 @@ ieee80211_crypto_aes_gmac_decrypt(struct
 		if (ieee80211_aes_gmac(key->u.aes_gmac.tfm, aad, nonce,
 				       skb->data + 24, skb->len - 24,
 				       mic) < 0 ||
-		    memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		    crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_gmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
