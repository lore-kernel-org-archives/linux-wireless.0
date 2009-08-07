Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32420 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbZHGEQe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:16:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:16:36 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43693.836150.327183@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:46:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/12] ath9k: Cleanup ath9k_hw_4k_set_gain() interface
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

regChainOffset is always zero, remove it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 111f4d7..aafc6d3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -844,13 +844,13 @@ static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
 static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 				 struct modal_eep_4k_header *pModal,
 				 struct ar5416_eeprom_4k *eep,
-				 u8 txRxAttenLocal, int regChainOffset)
+				 u8 txRxAttenLocal)
 {
-	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0 + regChainOffset,
+	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0,
 		  pModal->antCtrlChain[0]);
 
-	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset,
-		  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset) &
+	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0),
+		  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
 		   ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
 		     AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
 		  SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
@@ -860,14 +860,14 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 	    AR5416_EEP_MINOR_VER_3) {
 		txRxAttenLocal = pModal->txRxAttenCh[0];
 
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ,
 			      AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN, pModal->bswMargin[0]);
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ,
 			      AR_PHY_GAIN_2GHZ_XATTEN1_DB, pModal->bswAtten[0]);
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ,
 			      AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
 			      pModal->xatten2Margin[0]);
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ,
 			      AR_PHY_GAIN_2GHZ_XATTEN2_DB, pModal->xatten2Db[0]);
 
 		/* Set the block 1 value to block 0 value */
@@ -884,9 +884,9 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 			      pModal->xatten2Db[0]);
 	}
 
-	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
+	REG_RMW_FIELD(ah, AR_PHY_RXGAIN,
 		      AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
-	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
+	REG_RMW_FIELD(ah, AR_PHY_RXGAIN,
 		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
 
 	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + 0x1000,
@@ -919,7 +919,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
 
 	/* Single chain for 4K EEPROM*/
-	ath9k_hw_4k_set_gain(ah, pModal, eep, txRxAttenLocal, 0);
+	ath9k_hw_4k_set_gain(ah, pModal, eep, txRxAttenLocal);
 
 	/* Initialize Ant Diversity settings from EEPROM */
 	if (pModal->version >= 3) {
-- 
1.6.4

