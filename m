Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43076 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753944AbdIIXEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Sep 2017 19:04:16 -0400
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Johannes Berg" <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 09 Sep 2017 22:47:15 +0100
Message-ID: <lsq.1504993635.208015375@decadent.org.uk> (sfid-20170910_011025_840039_0E8AC244)
Subject: [PATCH 3.16 191/233] mac80211/wpa: use constant time memory
 comparison for MACs
In-Reply-To: <lsq.1504993633.197134470@decadent.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3.16.48-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 98c67d187db7808b1f3c95f2110dd4392d034182 upstream.

Otherwise, we enable all sorts of forgeries via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.16: drop changes in
 ieee80211_crypto_aes_{cmac_256,mac}_decrypt()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/wpa.c | 9 +++++----
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
@@ -147,7 +148,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
 	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
 	michael_mic(key, hdr, data, data_len, mic);
-	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
+	if (crypto_memneq(mic, data + data_len, MICHAEL_MIC_LEN))
 		goto mic_fail;
 
 	/* remove Michael MIC from payload */
@@ -768,7 +769,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
 				   skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
