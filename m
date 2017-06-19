Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:58813 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750828AbdFSQqj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 12:46:39 -0400
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3.18-stable] mac80211/wpa: use constant time memory comparison for MACs
Date: Mon, 19 Jun 2017 18:44:06 +0200
Message-Id: <20170619164406.23738-1-Jason@zx2c4.com> (sfid-20170619_184642_601041_5EEDA816)
In-Reply-To: <1497818656.2259.1.camel@sipsolutions.net>
References: <1497818656.2259.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, we enable all sorts of forgeries via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This is for 3.18. Tested this, and it works as intended.

 net/mac80211/wpa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 983527a4c1ab..bf87de469c03 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -16,6 +16,7 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 
 #include "ieee80211_i.h"
 #include "michael.h"
@@ -150,7 +151,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
 	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
 	michael_mic(key, hdr, data, data_len, mic);
-	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
+	if (crypto_memneq(mic, data + data_len, MICHAEL_MIC_LEN))
 		goto mic_fail;
 
 	/* remove Michael MIC from payload */
@@ -771,7 +772,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
 				   skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
-- 
2.13.1
