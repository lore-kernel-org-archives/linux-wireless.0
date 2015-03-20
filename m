Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62488 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbbCTMlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:41:11 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 18/18] ath9k: use REG_RMW and rmw buffer in ath9k_hw_def_set_gain
Date: Fri, 20 Mar 2015 13:38:58 +0100
Message-Id: <1426855138-6121-19-git-send-email-linux@rempel-privat.de> (sfid-20150320_140418_810346_C127323C)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 0980590..4b43539 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -466,6 +466,7 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 				  struct ar5416_eeprom_def *eep,
 				  u8 txRxAttenLocal, int regChainOffset, int i)
 {
+	ENABLE_REG_RMW_BUFFER(ah);
 	if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_3) {
 		txRxAttenLocal = pModal->txRxAttenCh[i];
 
@@ -483,16 +484,16 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 			      AR_PHY_GAIN_2GHZ_XATTEN2_DB,
 			      pModal->xatten2Db[i]);
 		} else {
-			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			REG_RMW(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
 			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
 			   ~AR_PHY_GAIN_2GHZ_BSW_MARGIN)
 			  | SM(pModal-> bswMargin[i],
-			       AR_PHY_GAIN_2GHZ_BSW_MARGIN));
-			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			       AR_PHY_GAIN_2GHZ_BSW_MARGIN), 0);
+			REG_RMW(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
 			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
 			   ~AR_PHY_GAIN_2GHZ_BSW_ATTEN)
 			  | SM(pModal->bswAtten[i],
-			       AR_PHY_GAIN_2GHZ_BSW_ATTEN));
+			       AR_PHY_GAIN_2GHZ_BSW_ATTEN), 0);
 		}
 	}
 
@@ -504,17 +505,19 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 		      AR_PHY_RXGAIN + regChainOffset,
 		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[i]);
 	} else {
-		REG_WRITE(ah,
+		REG_RMW(ah,
 			  AR_PHY_RXGAIN + regChainOffset,
 			  (REG_READ(ah, AR_PHY_RXGAIN + regChainOffset) &
 			   ~AR_PHY_RXGAIN_TXRX_ATTEN)
-			  | SM(txRxAttenLocal, AR_PHY_RXGAIN_TXRX_ATTEN));
-		REG_WRITE(ah,
+			  | SM(txRxAttenLocal, AR_PHY_RXGAIN_TXRX_ATTEN), 0);
+		REG_RMW(ah,
 			  AR_PHY_GAIN_2GHZ + regChainOffset,
 			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
 			   ~AR_PHY_GAIN_2GHZ_RXTX_MARGIN) |
-			  SM(pModal->rxTxMarginCh[i], AR_PHY_GAIN_2GHZ_RXTX_MARGIN));
+			  SM(pModal->rxTxMarginCh[i],
+			  AR_PHY_GAIN_2GHZ_RXTX_MARGIN), 0);
 	}
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
-- 
1.9.1

