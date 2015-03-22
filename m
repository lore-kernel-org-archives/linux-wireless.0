Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50615 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbbCVSby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:31:54 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 16/18] ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_gain
Date: Sun, 22 Mar 2015 19:30:01 +0100
Message-Id: <1427049003-8443-17-git-send-email-linux@rempel-privat.de> (sfid-20150322_193418_091079_8FA66D77)
In-Reply-To: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
References: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it is possible to reduce time needed for this function
by rplacing REG_WRITE with REG_RMW (plus dummy 0) and putt all commands
in same buffer.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 291c1d1..38dc965 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -772,15 +772,14 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 				 struct ar5416_eeprom_4k *eep,
 				 u8 txRxAttenLocal)
 {
-	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0,
-		  pModal->antCtrlChain[0]);
+	ENABLE_REG_RMW_BUFFER(ah);
+	REG_RMW(ah, AR_PHY_SWITCH_CHAIN_0,
+		pModal->antCtrlChain[0], 0);
 
-	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0),
-		  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
-		   ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
-		     AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
-		  SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
-		  SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
+	REG_RMW(ah, AR_PHY_TIMING_CTRL4(0),
+		SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
+		SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF),
+		AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF | AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF);
 
 	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
 	    AR5416_EEP_MINOR_VER_3) {
@@ -819,6 +818,7 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 		      AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
 	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + 0x1000,
 		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 /*
-- 
1.9.1

