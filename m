Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:44042 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZCFII5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 03:08:57 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Imre Kaloz <kaloz@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 1/3] ath9k: cleanup AR5416 version checking macros
Date: Fri,  6 Mar 2009 09:08:51 +0100
Message-Id: <1236326933-27412-2-git-send-email-juhosg@openwrt.org> (sfid-20090306_090859_828542_EBBF1AEF)
In-Reply-To: <1236326933-27412-1-git-send-email-juhosg@openwrt.org>
References: <1236326933-27412-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we have two different versions of this macros. Because they
would have to do the same thing, we should simplify and merge them.

Changes-licensed-under: ISC

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/eeprom.c |   16 ++++++++--------
 drivers/net/wireless/ath9k/hw.c     |    4 ++--
 drivers/net/wireless/ath9k/mac.h    |    2 +-
 drivers/net/wireless/ath9k/reg.h    |   19 +++++++++++--------
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index b1cf590..8a9e062 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -640,7 +640,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 		pPdGainBoundaries[i] =
 			min((u16)AR5416_MAX_RATE_POWER, pPdGainBoundaries[i]);
 
-		if ((i == 0) && !AR_SREV_5416_V20_OR_LATER(ah)) {
+		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
 			minDelta = pPdGainBoundaries[0] - 23;
 			pPdGainBoundaries[0] = 23;
 		} else {
@@ -755,7 +755,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3, 0);
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		if (AR_SREV_5416_V20_OR_LATER(ah) &&
+		if (AR_SREV_5416_20_OR_LATER(ah) &&
 		    (ah->rxchainmask == 5 || ah->txchainmask == 5) &&
 		    (i != 0)) {
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
@@ -771,7 +771,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 					    &tMinCalPower, gainBoundaries,
 					    pdadcValues, numXpdGain);
 
-			if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
+			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
 				REG_WRITE(ah, AR_PHY_TPCRG5 + regChainOffset,
 					  SM(pdGainOverlap_t2,
 					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
@@ -1707,7 +1707,7 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 				break;
 		}
 
-		if (AR_SREV_5416_V20_OR_LATER(ah) &&
+		if (AR_SREV_5416_20_OR_LATER(ah) &&
 		    (ah->rxchainmask == 5 || ah->txchainmask == 5)
 		    && (i != 0))
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
@@ -1728,7 +1728,7 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 			  SM(pModal->iqCalQCh[i],
 			     AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
 
-		if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
+		if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
 			if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_3) {
 				txRxAttenLocal = pModal->txRxAttenCh[i];
 				if (AR_SREV_9280_10_OR_LATER(ah)) {
@@ -2094,7 +2094,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 		pPdGainBoundaries[i] =
 			min((u16)AR5416_MAX_RATE_POWER, pPdGainBoundaries[i]);
 
-		if ((i == 0) && !AR_SREV_5416_V20_OR_LATER(ah)) {
+		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
 			minDelta = pPdGainBoundaries[0] - 23;
 			pPdGainBoundaries[0] = 23;
 		} else {
@@ -2228,7 +2228,7 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 		      xpdGainValues[2]);
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		if (AR_SREV_5416_V20_OR_LATER(ah) &&
+		if (AR_SREV_5416_20_OR_LATER(ah) &&
 		    (ah->rxchainmask == 5 || ah->txchainmask == 5) &&
 		    (i != 0)) {
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
@@ -2262,7 +2262,7 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 							numXpdGain);
 			}
 
-			if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
+			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
 				if (OLC_FOR_AR9280_20_LATER) {
 					REG_WRITE(ah,
 						AR_PHY_TPCRG5 + regChainOffset,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index eb750a5..5d72588 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1153,7 +1153,7 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
 
-	if (!AR_SREV_5416_V20_OR_LATER(ah) ||
+	if (!AR_SREV_5416_20_OR_LATER(ah) ||
 	    AR_SREV_9280_10_OR_LATER(ah))
 		return;
 
@@ -1255,7 +1255,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
 	ah->eep_ops->set_addac(ah, chan);
 
-	if (AR_SREV_5416_V22_OR_LATER(ah)) {
+	if (AR_SREV_5416_22_OR_LATER(ah)) {
 		REG_WRITE_ARRAY(&ah->iniAddac, 1, regWrites);
 	} else {
 		struct ar5416IniArray temp;
diff --git a/drivers/net/wireless/ath9k/mac.h b/drivers/net/wireless/ath9k/mac.h
index 37e3948..a75f65d 100644
--- a/drivers/net/wireless/ath9k/mac.h
+++ b/drivers/net/wireless/ath9k/mac.h
@@ -17,7 +17,7 @@
 #ifndef MAC_H
 #define MAC_H
 
-#define RXSTATUS_RATE(ah, ads) (AR_SREV_5416_V20_OR_LATER(ah) ?		\
+#define RXSTATUS_RATE(ah, ads) (AR_SREV_5416_20_OR_LATER(ah) ?		\
 				MS(ads->ds_rxstatus0, AR_RxRate) :	\
 				(ads->ds_rxstatus3 >> 2) & 0xFF)
 
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 91442da..a40c0bb 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -161,10 +161,6 @@
 #define AR_SREV_VERSION_9100                  0x014
 
 #define AR_SREV_9100(ah) ((ah->hw_version.macVersion) == AR_SREV_VERSION_9100)
-#define AR_SREV_5416_V20_OR_LATER(_ah) \
-	(AR_SREV_9100((_ah)) || AR_SREV_5416_20_OR_LATER(_ah))
-#define AR_SREV_5416_V22_OR_LATER(_ah) \
-	(AR_SREV_9100((_ah)) || AR_SREV_5416_22_OR_LATER(_ah))
 
 #define AR_ISR               0x0080
 #define AR_ISR_RXOK          0x00000001
@@ -748,12 +744,19 @@
 
 #define AR_SREV_9100_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_5416_PCIE))
+
+#define AR_SREV_5416(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
+	 ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE))
 #define AR_SREV_5416_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160) || \
-		((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20))
+	(((AR_SREV_5416(_ah)) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
+	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
 #define AR_SREV_5416_22_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160) || \
-		((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22))
+	(((AR_SREV_5416(_ah)) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)) || \
+	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
+
 #define AR_SREV_9160(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9160))
 #define AR_SREV_9160_10_OR_LATER(_ah) \
-- 
1.5.3.2

