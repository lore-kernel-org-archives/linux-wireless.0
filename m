Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54907 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbbCTMlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:41:11 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 17/18] ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_board_values
Date: Fri, 20 Mar 2015 13:38:57 +0100
Message-Id: <1426855138-6121-18-git-send-email-linux@rempel-privat.de> (sfid-20150320_140418_578048_8A541D57)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace REG_WRITE to REG_RMW and place every thing in one
RMW buffer.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 56621be..a631962 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1039,17 +1039,17 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	}
 	REG_RMW_BUFFER_FLUSH(ah);
 
-
+	ENABLE_REG_RMW_BUFFER(ah);
 	REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
 		      pModal->switchSettling);
 	REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ, AR_PHY_DESIRED_SZ_ADC,
 		      pModal->adcDesiredSize);
 
-	REG_WRITE(ah, AR_PHY_RF_CTL4,
-		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAA_OFF) |
-		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAB_OFF) |
-		  SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAA_ON)  |
-		  SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAB_ON));
+	REG_RMW(ah, AR_PHY_RF_CTL4,
+		SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAA_OFF) |
+		SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAB_OFF) |
+		SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAA_ON)  |
+		SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAB_ON), 0);
 
 	REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_A2_RX_ON,
 		      pModal->txEndToRxOn);
@@ -1078,6 +1078,8 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 				      pModal->swSettleHt40);
 	}
 
+	REG_RMW_BUFFER_FLUSH(ah);
+
 	bb_desired_scale = (pModal->bb_scale_smrt_antenna &
 			EEP_4K_BB_DESIRED_SCALE_MASK);
 	if ((pBase->txGainType == 0) && (bb_desired_scale != 0)) {
-- 
1.9.1

