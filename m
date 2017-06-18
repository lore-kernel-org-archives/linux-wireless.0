Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:55573 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbdFRTTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 15:19:09 -0400
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211/wpa: use constant time memory comparison for MACs
Date: Sun, 18 Jun 2017 21:18:54 +0200
Message-Id: <20170618191854.17767-1-Jason@zx2c4.com> (sfid-20170618_211919_340429_89855755)
In-Reply-To: <1497720871224217@kroah.com>
References: <1497720871224217@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, we enable all sorts of forgeries via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Here's the backport for 3.18.

 net/mac80211/wpa.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 983527a4c1ab..49592c7e4199 100644
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
+	if (crypto_memneq(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
 		goto mic_fail;
 
 	/* remove Michael MIC from payload */
@@ -520,7 +521,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 	queue = rx->security_idx;
 
-	if (memcmp(pn, key->u.ccmp.rx_pn[queue], IEEE80211_CCMP_PN_LEN) <= 0) {
+	if (crypto_memneq(pn, key->u.ccmp.rx_pn[queue], IEEE80211_CCMP_PN_LEN) <= 0) {
 		key->u.ccmp.replays++;
 		return RX_DROP_UNUSABLE;
 	}
@@ -771,7 +772,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
 				   skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
-- 
2.13.1
