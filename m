Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaGIOKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 10:10:06 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Max Stepanov <Max.Stepanov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix a potential NULL access in ieee80211_crypto_hw_decrypt
Date: Wed,  9 Jul 2014 16:55:32 +0300
Message-Id: <1404914132-13614-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140709_161011_398196_7DE10EE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

The NULL pointer access could happen when ieee80211_crypto_hw_decrypt
is called from ieee80211_rx_h_decrypt with the following condition:
1. rx->key->conf.cipher is not WEP, CCMP, TKIP or AES_CMAC
2. rx->sta is NULL

When ieee80211_crypto_hw_decrypt is called, it verifies
rx->sta->cipher_scheme and it will cause Oops if rx->sta is NULL.

This path adds an addirional rx->sta == NULL verification in
ieee80211_crypto_hw_decrypt for this case.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/wpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9b3dcc2..f7d4ca4 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -811,7 +811,7 @@ ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx)
 ieee80211_rx_result
 ieee80211_crypto_hw_decrypt(struct ieee80211_rx_data *rx)
 {
-	if (rx->sta->cipher_scheme)
+	if (rx->sta && rx->sta->cipher_scheme)
 		return ieee80211_crypto_cs_decrypt(rx);
 
 	return RX_DROP_UNUSABLE;
-- 
1.9.1

