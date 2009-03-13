Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63484 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbZCMDaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:30:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:30:08 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.53836.43335.967273@gargle.gargle.HOWL> (sfid-20090313_043015_563943_48D5D460)
Date: Fri, 13 Mar 2009 08:56:04 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/7] ath9k: Introduce a helper function for setting board gain values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves readability. Handle both 4K/non-4K EEPROM
in this patch.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |  219 ++++++++++++++++-------------------
 1 files changed, 99 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 49dee23..c3bb196 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1193,57 +1193,63 @@ static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
 	}
 }
 
-static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
-					 struct ath9k_channel *chan)
+static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
+				 struct modal_eep_4k_header *pModal,
+				 struct ar5416_eeprom_4k *eep,
+				 u8 txRxAttenLocal, int regChainOffset)
 {
-	struct modal_eep_4k_header *pModal;
-	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
-	int regChainOffset;
-	u8 txRxAttenLocal;
-	u8 ob[5], db1[5], db2[5];
-	u8 ant_div_control1, ant_div_control2;
-	u32 regVal;
-
-
-	pModal = &eep->modalHeader;
-
-	txRxAttenLocal = 23;
-
-	REG_WRITE(ah, AR_PHY_SWITCH_COM,
-		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
-
-	regChainOffset = 0;
 	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0 + regChainOffset,
 		  pModal->antCtrlChain[0]);
 
 	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset,
-		 (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset) &
-		 ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
-		 AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
-		 SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
-		 SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
+		  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset) &
+		   ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
+		     AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
+		  SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
+		  SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
 
 	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
-			AR5416_EEP_MINOR_VER_3) {
+	    AR5416_EEP_MINOR_VER_3) {
 		txRxAttenLocal = pModal->txRxAttenCh[0];
+
 		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN, pModal->bswMargin[0]);
+			      AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN, pModal->bswMargin[0]);
 		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN1_DB, pModal->bswAtten[0]);
+			      AR_PHY_GAIN_2GHZ_XATTEN1_DB, pModal->bswAtten[0]);
 		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
-			pModal->xatten2Margin[0]);
+			      AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
+			      pModal->xatten2Margin[0]);
 		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN2_DB, pModal->xatten2Db[0]);
+			      AR_PHY_GAIN_2GHZ_XATTEN2_DB, pModal->xatten2Db[0]);
 	}
 
 	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
-			AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
+		      AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
 	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
-			AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
+		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
 
 	if (AR_SREV_9285_11(ah))
 		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
+}
+
+static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	struct modal_eep_4k_header *pModal;
+	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
+	u8 txRxAttenLocal;
+	u8 ob[5], db1[5], db2[5];
+	u8 ant_div_control1, ant_div_control2;
+	u32 regVal;
+
+	pModal = &eep->modalHeader;
+	txRxAttenLocal = 23;
+
+	REG_WRITE(ah, AR_PHY_SWITCH_COM,
+		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
+
+	/* Single chain for 4K EEPROM*/
+	ath9k_hw_4k_set_gain(ah, pModal, eep, txRxAttenLocal, 0);
 
 	/* Initialize Ant Diversity settings from EEPROM */
 	if (pModal->version == 3) {
@@ -1656,7 +1662,62 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 	}
 }
 
-/* XXX: Clean me up, make me more legible */
+static void ath9k_hw_def_set_gain(struct ath_hw *ah,
+				  struct modal_eep_header *pModal,
+				  struct ar5416_eeprom_def *eep,
+				  u8 txRxAttenLocal, int regChainOffset, int i)
+{
+	if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_3) {
+		txRxAttenLocal = pModal->txRxAttenCh[i];
+
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			      AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN,
+			      pModal->bswMargin[i]);
+			REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			      AR_PHY_GAIN_2GHZ_XATTEN1_DB,
+			      pModal->bswAtten[i]);
+			REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			      AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
+			      pModal->xatten2Margin[i]);
+			REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			      AR_PHY_GAIN_2GHZ_XATTEN2_DB,
+			      pModal->xatten2Db[i]);
+		} else {
+			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
+			   ~AR_PHY_GAIN_2GHZ_BSW_MARGIN)
+			  | SM(pModal-> bswMargin[i],
+			       AR_PHY_GAIN_2GHZ_BSW_MARGIN));
+			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
+			   ~AR_PHY_GAIN_2GHZ_BSW_ATTEN)
+			  | SM(pModal->bswAtten[i],
+			       AR_PHY_GAIN_2GHZ_BSW_ATTEN));
+		}
+	}
+
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		REG_RMW_FIELD(ah,
+		      AR_PHY_RXGAIN + regChainOffset,
+		      AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
+		REG_RMW_FIELD(ah,
+		      AR_PHY_RXGAIN + regChainOffset,
+		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[i]);
+	} else {
+		REG_WRITE(ah,
+			  AR_PHY_RXGAIN + regChainOffset,
+			  (REG_READ(ah, AR_PHY_RXGAIN + regChainOffset) &
+			   ~AR_PHY_RXGAIN_TXRX_ATTEN)
+			  | SM(txRxAttenLocal, AR_PHY_RXGAIN_TXRX_ATTEN));
+		REG_WRITE(ah,
+			  AR_PHY_GAIN_2GHZ + regChainOffset,
+			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
+			   ~AR_PHY_GAIN_2GHZ_RXTX_MARGIN) |
+			  SM(pModal->rxTxMarginCh[i], AR_PHY_GAIN_2GHZ_RXTX_MARGIN));
+	}
+}
+
 static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 					  struct ath9k_channel *chan)
 {
@@ -1666,7 +1727,6 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 	u8 txRxAttenLocal;
 
 	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
-
 	txRxAttenLocal = IS_CHAN_2GHZ(chan) ? 23 : 44;
 
 	REG_WRITE(ah, AR_PHY_SWITCH_COM,
@@ -1679,8 +1739,7 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 		}
 
 		if (AR_SREV_5416_20_OR_LATER(ah) &&
-		    (ah->rxchainmask == 5 || ah->txchainmask == 5)
-		    && (i != 0))
+		    (ah->rxchainmask == 5 || ah->txchainmask == 5) && (i != 0))
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		else
 			regChainOffset = i * 0x1000;
@@ -1689,9 +1748,7 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 			  pModal->antCtrlChain[i]);
 
 		REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset,
-			  (REG_READ(ah,
-				    AR_PHY_TIMING_CTRL4(0) +
-				    regChainOffset) &
+			  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset) &
 			   ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
 			     AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
 			  SM(pModal->iqCalICh[i],
@@ -1699,87 +1756,9 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 			  SM(pModal->iqCalQCh[i],
 			     AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
 
-		if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
-			if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_3) {
-				txRxAttenLocal = pModal->txRxAttenCh[i];
-				if (AR_SREV_9280_10_OR_LATER(ah)) {
-					REG_RMW_FIELD(ah,
-						AR_PHY_GAIN_2GHZ +
-						regChainOffset,
-						AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN,
-						pModal->
-						bswMargin[i]);
-					REG_RMW_FIELD(ah,
-						AR_PHY_GAIN_2GHZ +
-						regChainOffset,
-						AR_PHY_GAIN_2GHZ_XATTEN1_DB,
-						pModal->
-						bswAtten[i]);
-					REG_RMW_FIELD(ah,
-						AR_PHY_GAIN_2GHZ +
-						regChainOffset,
-						AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
-						pModal->
-						xatten2Margin[i]);
-					REG_RMW_FIELD(ah,
-						AR_PHY_GAIN_2GHZ +
-						regChainOffset,
-						AR_PHY_GAIN_2GHZ_XATTEN2_DB,
-						pModal->
-						xatten2Db[i]);
-				} else {
-					REG_WRITE(ah,
-						  AR_PHY_GAIN_2GHZ +
-						  regChainOffset,
-						  (REG_READ(ah,
-							    AR_PHY_GAIN_2GHZ +
-							    regChainOffset) &
-						   ~AR_PHY_GAIN_2GHZ_BSW_MARGIN)
-						  | SM(pModal->
-						  bswMargin[i],
-						  AR_PHY_GAIN_2GHZ_BSW_MARGIN));
-					REG_WRITE(ah,
-						  AR_PHY_GAIN_2GHZ +
-						  regChainOffset,
-						  (REG_READ(ah,
-							    AR_PHY_GAIN_2GHZ +
-							    regChainOffset) &
-						   ~AR_PHY_GAIN_2GHZ_BSW_ATTEN)
-						  | SM(pModal->bswAtten[i],
-						  AR_PHY_GAIN_2GHZ_BSW_ATTEN));
-				}
-			}
-			if (AR_SREV_9280_10_OR_LATER(ah)) {
-				REG_RMW_FIELD(ah,
-					      AR_PHY_RXGAIN +
-					      regChainOffset,
-					      AR9280_PHY_RXGAIN_TXRX_ATTEN,
-					      txRxAttenLocal);
-				REG_RMW_FIELD(ah,
-					      AR_PHY_RXGAIN +
-					      regChainOffset,
-					      AR9280_PHY_RXGAIN_TXRX_MARGIN,
-					      pModal->rxTxMarginCh[i]);
-			} else {
-				REG_WRITE(ah,
-					  AR_PHY_RXGAIN + regChainOffset,
-					  (REG_READ(ah,
-						    AR_PHY_RXGAIN +
-						    regChainOffset) &
-					   ~AR_PHY_RXGAIN_TXRX_ATTEN) |
-					  SM(txRxAttenLocal,
-					     AR_PHY_RXGAIN_TXRX_ATTEN));
-				REG_WRITE(ah,
-					  AR_PHY_GAIN_2GHZ +
-					  regChainOffset,
-					  (REG_READ(ah,
-						    AR_PHY_GAIN_2GHZ +
-						    regChainOffset) &
-					   ~AR_PHY_GAIN_2GHZ_RXTX_MARGIN) |
-					  SM(pModal->rxTxMarginCh[i],
-					     AR_PHY_GAIN_2GHZ_RXTX_MARGIN));
-			}
-		}
+		if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah))
+			ath9k_hw_def_set_gain(ah, pModal, eep, txRxAttenLocal,
+					      regChainOffset, i);
 	}
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-- 
1.6.2

