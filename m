Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49504 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbbCUIrk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 04:47:40 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 18/18] ath9k: use REG_RMW and rmw buffer in ath9k_hw_def_set_gain
Date: Sat, 21 Mar 2015 09:47:21 +0100
Message-Id: <1426927641-18474-19-git-send-email-linux@rempel-privat.de> (sfid-20150321_100417_468756_D6814C2D)
In-Reply-To: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
References: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c | 34 ++++++++++++-----------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 0980590..056f516 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -466,6 +466,7 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 				  struct ar5416_eeprom_def *eep,
 				  u8 txRxAttenLocal, int regChainOffset, int i)
 {
+	ENABLE_REG_RMW_BUFFER(ah);
 	if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_3) {
 		txRxAttenLocal = pModal->txRxAttenCh[i];
 
@@ -483,16 +484,12 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 			      AR_PHY_GAIN_2GHZ_XATTEN2_DB,
 			      pModal->xatten2Db[i]);
 		} else {
-			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
-			   ~AR_PHY_GAIN_2GHZ_BSW_MARGIN)
-			  | SM(pModal-> bswMargin[i],
-			       AR_PHY_GAIN_2GHZ_BSW_MARGIN));
-			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
-			   ~AR_PHY_GAIN_2GHZ_BSW_ATTEN)
-			  | SM(pModal->bswAtten[i],
-			       AR_PHY_GAIN_2GHZ_BSW_ATTEN));
+			REG_RMW(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+				SM(pModal-> bswMargin[i], AR_PHY_GAIN_2GHZ_BSW_MARGIN),
+				AR_PHY_GAIN_2GHZ_BSW_MARGIN);
+			REG_RMW(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+				SM(pModal->bswAtten[i], AR_PHY_GAIN_2GHZ_BSW_ATTEN),
+				AR_PHY_GAIN_2GHZ_BSW_ATTEN);
 		}
 	}
 
@@ -504,17 +501,14 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 		      AR_PHY_RXGAIN + regChainOffset,
 		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[i]);
 	} else {
-		REG_WRITE(ah,
-			  AR_PHY_RXGAIN + regChainOffset,
-			  (REG_READ(ah, AR_PHY_RXGAIN + regChainOffset) &
-			   ~AR_PHY_RXGAIN_TXRX_ATTEN)
-			  | SM(txRxAttenLocal, AR_PHY_RXGAIN_TXRX_ATTEN));
-		REG_WRITE(ah,
-			  AR_PHY_GAIN_2GHZ + regChainOffset,
-			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
-			   ~AR_PHY_GAIN_2GHZ_RXTX_MARGIN) |
-			  SM(pModal->rxTxMarginCh[i], AR_PHY_GAIN_2GHZ_RXTX_MARGIN));
+		REG_RMW(ah, AR_PHY_RXGAIN + regChainOffset,
+			SM(txRxAttenLocal, AR_PHY_RXGAIN_TXRX_ATTEN),
+			AR_PHY_RXGAIN_TXRX_ATTEN);
+		REG_RMW(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			SM(pModal->rxTxMarginCh[i], AR_PHY_GAIN_2GHZ_RXTX_MARGIN),
+			AR_PHY_GAIN_2GHZ_RXTX_MARGIN);
 	}
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
-- 
1.9.1

