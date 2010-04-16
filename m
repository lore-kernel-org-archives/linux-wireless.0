Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:18971
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756682Ab0DPKwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:52:39 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Tor Krill <tor@excito.com>,
	Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 1/6] ath9k: clean up rx skb post-process logic
Date: Fri, 16 Apr 2010 12:52:10 +0200
Message-Id: <1271415135-18317-1-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100416104850.GA13329@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor IEEE80211_FCTL_PROTECTED and decryption error test.

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---
 drivers/net/wireless/ath/ath9k/common.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 09effde..0cd10dc 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -255,15 +255,15 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 
 	keyix = rx_stats->rs_keyix;
 
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
-	    ieee80211_has_protected(fc)) {
-		rxs->flag |= RX_FLAG_DECRYPTED;
-	} else if (ieee80211_has_protected(fc)
-		   && !decrypt_error && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
-
-		if (test_bit(keyix, common->keymap))
+	if (ieee80211_has_protected(fc) && !decrypt_error) {
+		if (keyix != ATH9K_RXKEYIX_INVALID) {
 			rxs->flag |= RX_FLAG_DECRYPTED;
+		} else if (skb->len >= hdrlen + 4) {
+			keyix = skb->data[hdrlen + 3] >> 6;
+
+			if (test_bit(keyix, common->keymap))
+				rxs->flag |= RX_FLAG_DECRYPTED;
+		}
 	}
 	if (ah->sw_mgmt_crypto &&
 	    (rxs->flag & RX_FLAG_DECRYPTED) &&
-- 
1.7.0.3

