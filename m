Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50592 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3GPGgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 02:36:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] ath9k: Move INI overrides to ar9003_hw_override_ini
Date: Tue, 16 Jul 2013 12:03:17 +0530
Message-Id: <1373956402-22169-1-git-send-email-sujith@msujith.org> (sfid-20130716_083651_332182_725B499A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 33 ++++++++++++++---------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1f694ab..57e345a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -632,6 +632,22 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 
 	REG_SET_BIT(ah, AR_PHY_CCK_DETECT,
 		    AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
+
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+		REG_WRITE(ah, AR_GLB_SWREG_DISCONT_MODE,
+			  AR_GLB_SWREG_DISCONT_EN_BT_WLAN);
+
+		if (REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+				   AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL))
+			ah->enabled_cals |= TX_IQ_CAL;
+		else
+			ah->enabled_cals &= ~TX_IQ_CAL;
+
+		if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE)
+			ah->enabled_cals |= TX_CL_CAL;
+		else
+			ah->enabled_cals &= ~TX_CL_CAL;
+	}
 }
 
 static void ar9003_hw_prog_ini(struct ath_hw *ah,
@@ -814,29 +830,12 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	if (chan->channel == 2484)
 		ar9003_hw_prog_ini(ah, &ah->iniCckfirJapan2484, 1);
 
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
-		REG_WRITE(ah, AR_GLB_SWREG_DISCONT_MODE,
-			  AR_GLB_SWREG_DISCONT_EN_BT_WLAN);
-
 	ah->modes_index = modesIndex;
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 	ath9k_hw_apply_txpower(ah, chan, false);
 
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
-		if (REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_0,
-				   AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL))
-			ah->enabled_cals |= TX_IQ_CAL;
-		else
-			ah->enabled_cals &= ~TX_IQ_CAL;
-
-		if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE)
-			ah->enabled_cals |= TX_CL_CAL;
-		else
-			ah->enabled_cals &= ~TX_CL_CAL;
-	}
-
 	return 0;
 }
 
-- 
1.8.3.2

