Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:18978
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757882Ab0DPKwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:52:47 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Tor Krill <tor@excito.com>,
	Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 6/6] ath9k: clear mic error flag on encrypted frames
Date: Fri, 16 Apr 2010 12:52:15 +0200
Message-Id: <1271415135-18317-6-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100416104850.GA13329@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does not make sense to forward MIC-errors on non-decrypted frames.

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---

 drivers/net/wireless/ath/ath9k/common.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 1623af1..6efb388 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -255,11 +255,15 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 
 	keyix = rx_stats->rs_keyix;
 
-	if (ieee80211_has_protected(fc) && !decrypt_error &&
-		!(rx_stats->rs_flags & ATH9K_RX_DECRYPT_BUSY) &&
-		!(rx_stats->rs_flags & ATH9K_RX_KEY_MISS)) {
-		if (keyix != ATH9K_RXKEYIX_INVALID)
+	if (ieee80211_has_protected(fc)) {
+		if (!decrypt_error &&
+		    !(rx_stats->rs_flags & ATH9K_RX_DECRYPT_BUSY) &&
+		    !(rx_stats->rs_flags & ATH9K_RX_KEY_MISS) &&
+		    keyix != ATH9K_RXKEYIX_INVALID) {
 			rxs->flag |= RX_FLAG_DECRYPTED;
+		}
+		if (!(rxs->flag & RX_FLAG_DECRYPTED))
+			rxs->flag &= ~RX_FLAG_MMIC_ERROR;
 	}
 	if (ah->sw_mgmt_crypto &&
 	    (rxs->flag & RX_FLAG_DECRYPTED) &&
-- 
1.7.0.3

