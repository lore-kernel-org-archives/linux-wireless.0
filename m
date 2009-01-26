Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40061 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZAZO6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 09:58:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 06:58:19 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: Fix AR9285 specific noise floor eeprom reads.
Date: Mon, 26 Jan 2009 20:28:14 +0530
Message-ID: <1232981894-5829-1-git-send-email-senthilkumar@atheros.com> (sfid-20090126_155823_315636_13191E52)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix AR9285 specific noise floor reads and initialize tx and rx
chainmask during reset. This along with the following earlier
patches of ath9k fixes an issue with association noticed in
noisy environment.

ath9k: Fix typo in chip version check
ath9k: Remove unnecessary gpio configuration in ath9k_hw_reset()
ath9k: Fix bug in NF calibration

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c |   78 +++++++++++++++++------------------
 drivers/net/wireless/ath9k/hw.c    |    5 ++-
 2 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index c6d1de0..69ff01c 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -105,27 +105,29 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 		"NF calibrated [ctl] [chain 0] is %d\n", nf);
 	nfarray[0] = nf;
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
-			AR9280_PHY_CH1_MINCCA_PWR);
-	else
-		nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
-			AR_PHY_CH1_MINCCA_PWR);
-
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-		"NF calibrated [ctl] [chain 1] is %d\n", nf);
-	nfarray[1] = nf;
+	if (!AR_SREV_9285(ah)) {
+		if (AR_SREV_9280_10_OR_LATER(ah))
+			nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
+					AR9280_PHY_CH1_MINCCA_PWR);
+		else
+			nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
+					AR_PHY_CH1_MINCCA_PWR);
 
-	if (!AR_SREV_9280(ah)) {
-		nf = MS(REG_READ(ah, AR_PHY_CH2_CCA),
-			AR_PHY_CH2_MINCCA_PWR);
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"NF calibrated [ctl] [chain 2] is %d\n", nf);
-		nfarray[2] = nf;
+				"NF calibrated [ctl] [chain 1] is %d\n", nf);
+		nfarray[1] = nf;
+
+		if (!AR_SREV_9280(ah)) {
+			nf = MS(REG_READ(ah, AR_PHY_CH2_CCA),
+					AR_PHY_CH2_MINCCA_PWR);
+			if (nf & 0x100)
+				nf = 0 - ((nf ^ 0x1ff) + 1);
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+				"NF calibrated [ctl] [chain 2] is %d\n", nf);
+			nfarray[2] = nf;
+		}
 	}
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
@@ -141,27 +143,29 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 		"NF calibrated [ext] [chain 0] is %d\n", nf);
 	nfarray[3] = nf;
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
-			AR9280_PHY_CH1_EXT_MINCCA_PWR);
-	else
-		nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
-			AR_PHY_CH1_EXT_MINCCA_PWR);
+	if (!AR_SREV_9285(ah)) {
+		if (AR_SREV_9280_10_OR_LATER(ah))
+			nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
+					AR9280_PHY_CH1_EXT_MINCCA_PWR);
+		else
+			nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
+					AR_PHY_CH1_EXT_MINCCA_PWR);
 
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-		"NF calibrated [ext] [chain 1] is %d\n", nf);
-	nfarray[4] = nf;
-
-	if (!AR_SREV_9280(ah)) {
-		nf = MS(REG_READ(ah, AR_PHY_CH2_EXT_CCA),
-			AR_PHY_CH2_EXT_MINCCA_PWR);
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"NF calibrated [ext] [chain 2] is %d\n", nf);
-		nfarray[5] = nf;
+				"NF calibrated [ext] [chain 1] is %d\n", nf);
+		nfarray[4] = nf;
+
+		if (!AR_SREV_9280(ah)) {
+			nf = MS(REG_READ(ah, AR_PHY_CH2_EXT_CCA),
+					AR_PHY_CH2_EXT_MINCCA_PWR);
+			if (nf & 0x100)
+				nf = 0 - ((nf ^ 0x1ff) + 1);
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+				"NF calibrated [ext] [chain 2] is %d\n", nf);
+			nfarray[5] = nf;
+		}
 	}
 }
 
@@ -668,12 +672,6 @@ int16_t ath9k_hw_getnf(struct ath_hal *ah,
 	int16_t nfarray[NUM_NF_READINGS] = { 0 };
 	struct ath9k_nfcal_hist *h;
 	struct ieee80211_channel *c = chan->chan;
-	u8 chainmask;
-
-	if (AR_SREV_9280(ah))
-		chainmask = 0x1B;
-	else
-		chainmask = 0x3F;
 
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index bb8628c..7728234 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2165,7 +2165,10 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	ahp->ah_txchainmask = sc->sc_tx_chainmask;
 	ahp->ah_rxchainmask = sc->sc_rx_chainmask;
 
-	if (AR_SREV_9280(ah)) {
+	if (AR_SREV_9285(ah)) {
+		ahp->ah_txchainmask &= 0x1;
+		ahp->ah_rxchainmask &= 0x1;
+	} else if (AR_SREV_9280(ah)) {
 		ahp->ah_txchainmask &= 0x3;
 		ahp->ah_rxchainmask &= 0x3;
 	}
-- 
1.6.0.4

