Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753153AbdF0MuX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 08:50:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.18 16/16] mac80211/wpa: use constant time memory comparison for MACs
Date: Tue, 27 Jun 2017 14:49:53 +0200
Message-Id: <20170627124439.174584655@linuxfoundation.org> (sfid-20170627_145055_694050_A1EBA5DA)
In-Reply-To: <20170627124436.634493038@linuxfoundation.org>
References: <20170627124436.634493038@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 98c67d187db7808b1f3c95f2110dd4392d034182 upstream.

Otherwise, we enable all sorts of forgeries via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/mac80211/wpa.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -16,6 +16,7 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 
 #include "ieee80211_i.h"
 #include "michael.h"
@@ -150,7 +151,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
 	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
 	michael_mic(key, hdr, data, data_len, mic);
-	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
+	if (crypto_memneq(mic, data + data_len, MICHAEL_MIC_LEN))
 		goto mic_fail;
 
 	/* remove Michael MIC from payload */
@@ -771,7 +772,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
 				   skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
