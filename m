Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38308 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0GWCb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 22:31:58 -0400
Message-ID: <4C48FF1C.6030108@openwrt.org>
Date: Fri, 23 Jul 2010 04:31:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k_hw: simplify noisefloor calibration chainmask calculation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The noisefloor array index always corresponds to the rx chain number it
belongs to (with an offset of 3 for the extension chain).

It's much simpler (and actually more correct) to directly use the
chainmask to calculate the bitmask for the noisefloor array, instead of
using these weird chip revision checks and hardcoded mask values.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -172,26 +172,9 @@ void ath9k_hw_loadnf(struct ath_hw *ah,
 	struct ath9k_nfcal_hist *h;
 	unsigned i, j;
 	int32_t val;
-	u8 chainmask;
+	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	struct ath_common *common = ath9k_hw_common(ah);

-	if (AR_SREV_9300_20_OR_LATER(ah))
-		chainmask = 0x3F;
-	else if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
-		chainmask = 0x9;
-	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah)) {
-		if ((ah->rxchainmask & 0x2) || (ah->rxchainmask & 0x4))
-			chainmask = 0x1B;
-		else
-			chainmask = 0x09;
-	} else {
-		if (ah->rxchainmask & 0x4)
-			chainmask = 0x3F;
-		else if (ah->rxchainmask & 0x2)
-			chainmask = 0x1B;
-		else
-			chainmask = 0x09;
-	}
 	h = ah->nfCalHist;

 	for (i = 0; i < NUM_NF_READINGS; i++) {
