Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45887 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbaCQJdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 05:33:46 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 3/3] ath9k: Fix temperature compensation
Date: Mon, 17 Mar 2014 15:02:48 +0530
Message-Id: <1395048768-25245-3-git-send-email-sujith@msujith.org> (sfid-20140317_103350_009297_DD3340D4)
In-Reply-To: <1395048768-25245-1-git-send-email-sujith@msujith.org>
References: <1395048768-25245-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The registers for temperature compensation need to
be programmed only for active chains. Use the TX chainmask
to make sure that this is done properly for QCA953x.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 59 +++++++++++++++-----------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d7625ec..235053b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4792,43 +4792,54 @@ static void ar9003_hw_power_control_override(struct ath_hw *ah,
 
 tempslope:
 	if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+		u8 txmask = (eep->baseEepHeader.txrxMask & 0xf0) >> 4;
+
 		/*
 		 * AR955x has tempSlope register for each chain.
 		 * Check whether temp_compensation feature is enabled or not.
 		 */
 		if (eep->baseEepHeader.featureEnable & 0x1) {
 			if (frequency < 4000) {
-				REG_RMW_FIELD(ah, AR_PHY_TPC_19,
-					      AR_PHY_TPC_19_ALPHA_THERM,
-					      eep->base_ext2.tempSlopeLow);
-				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
-					      AR_PHY_TPC_19_ALPHA_THERM,
-					      temp_slope);
-				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
-					      AR_PHY_TPC_19_ALPHA_THERM,
-					      eep->base_ext2.tempSlopeHigh);
+				if (txmask & BIT(0))
+					REG_RMW_FIELD(ah, AR_PHY_TPC_19,
+						      AR_PHY_TPC_19_ALPHA_THERM,
+						      eep->base_ext2.tempSlopeLow);
+				if (txmask & BIT(1))
+					REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
+						      AR_PHY_TPC_19_ALPHA_THERM,
+						      temp_slope);
+				if (txmask & BIT(2))
+					REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
+						      AR_PHY_TPC_19_ALPHA_THERM,
+						      eep->base_ext2.tempSlopeHigh);
 			} else {
-				REG_RMW_FIELD(ah, AR_PHY_TPC_19,
-					      AR_PHY_TPC_19_ALPHA_THERM,
-					      temp_slope);
-				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
-					      AR_PHY_TPC_19_ALPHA_THERM,
-					      temp_slope1);
-				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
-					      AR_PHY_TPC_19_ALPHA_THERM,
-					      temp_slope2);
+				if (txmask & BIT(0))
+					REG_RMW_FIELD(ah, AR_PHY_TPC_19,
+						      AR_PHY_TPC_19_ALPHA_THERM,
+						      temp_slope);
+				if (txmask & BIT(1))
+					REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
+						      AR_PHY_TPC_19_ALPHA_THERM,
+						      temp_slope1);
+				if (txmask & BIT(2))
+					REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
+						      AR_PHY_TPC_19_ALPHA_THERM,
+						      temp_slope2);
 			}
 		} else {
 			/*
 			 * If temp compensation is not enabled,
 			 * set all registers to 0.
 			 */
-			REG_RMW_FIELD(ah, AR_PHY_TPC_19,
-				      AR_PHY_TPC_19_ALPHA_THERM, 0);
-			REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
-				      AR_PHY_TPC_19_ALPHA_THERM, 0);
-			REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
-				      AR_PHY_TPC_19_ALPHA_THERM, 0);
+			if (txmask & BIT(0))
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19,
+					      AR_PHY_TPC_19_ALPHA_THERM, 0);
+			if (txmask & BIT(1))
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
+					      AR_PHY_TPC_19_ALPHA_THERM, 0);
+			if (txmask & BIT(2))
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
+					      AR_PHY_TPC_19_ALPHA_THERM, 0);
 		}
 	} else {
 		REG_RMW_FIELD(ah, AR_PHY_TPC_19,
-- 
1.9.0

