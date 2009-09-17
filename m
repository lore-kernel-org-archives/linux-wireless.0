Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21647 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477AbZIQD53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:57:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:57:33 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.45997.717001.308525@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:27:33 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/12] ath9k: Adjust the chainmasks properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

This is needed to account for the number of chains in use,
not just the number of chains present.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 439f2c7..22a3a69 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -609,14 +609,24 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		AR_PHY_CH1_EXT_CCA,
 		AR_PHY_CH2_EXT_CCA
 	};
-	u8 chainmask;
+	u8 chainmask, rx_chain_status;
 
+	rx_chain_status = REG_READ(ah, AR_PHY_RX_CHAINMASK);
 	if (AR_SREV_9285(ah))
 		chainmask = 0x9;
-	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah))
-		chainmask = 0x1B;
-	else
-		chainmask = 0x3F;
+	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah)) {
+		if ((rx_chain_status & 0x2) || (rx_chain_status & 0x4))
+			chainmask = 0x1B;
+		else
+			chainmask = 0x09;
+	} else {
+		if (rx_chain_status & 0x4)
+			chainmask = 0x3F;
+		else if (rx_chain_status & 0x2)
+			chainmask = 0x1B;
+		else
+			chainmask = 0x09;
+	}
 
 	h = ah->nfCalHist;
 
-- 
1.6.4.3

