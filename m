Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43259 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3FDKO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:14:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] ath9k: Fix ofdm weak signal configuration
Date: Tue,  4 Jun 2013 15:41:33 +0530
Message-Id: <1370340695-29003-4-git-send-email-sujith@msujith.org> (sfid-20130604_121431_570835_5E04EC36)
In-Reply-To: <1370340695-29003-1-git-send-email-sujith@msujith.org>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit, "ath9k_hw: improve ANI processing and rx desensitizing parameters"
removed code setting various phy registers holding threshold values.

This is likely required for OFDM weak signal detection to function
correctly, so add them, but skip AR9462 and AR9565.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 60 +++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 83e0385..bc48312 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -906,6 +906,11 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ar5416AniState *aniState = &ah->ani;
+	int m1ThreshLow, m2ThreshLow;
+	int m1Thresh, m2Thresh;
+	int m2CountThr, m2CountThrLow;
+	int m1ThreshLowExt, m2ThreshLowExt;
+	int m1ThreshExt, m2ThreshExt;
 	s32 value, value2;
 
 	switch (cmd & ah->ani_function) {
@@ -919,6 +924,61 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		 */
 		u32 on = param ? 1 : 0;
 
+		if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+			goto skip_ws_det;
+
+		m1ThreshLow = on ?
+			aniState->iniDef.m1ThreshLow : m1ThreshLow_off;
+		m2ThreshLow = on ?
+			aniState->iniDef.m2ThreshLow : m2ThreshLow_off;
+		m1Thresh = on ?
+			aniState->iniDef.m1Thresh : m1Thresh_off;
+		m2Thresh = on ?
+			aniState->iniDef.m2Thresh : m2Thresh_off;
+		m2CountThr = on ?
+			aniState->iniDef.m2CountThr : m2CountThr_off;
+		m2CountThrLow = on ?
+			aniState->iniDef.m2CountThrLow : m2CountThrLow_off;
+		m1ThreshLowExt = on ?
+			aniState->iniDef.m1ThreshLowExt : m1ThreshLowExt_off;
+		m2ThreshLowExt = on ?
+			aniState->iniDef.m2ThreshLowExt : m2ThreshLowExt_off;
+		m1ThreshExt = on ?
+			aniState->iniDef.m1ThreshExt : m1ThreshExt_off;
+		m2ThreshExt = on ?
+			aniState->iniDef.m2ThreshExt : m2ThreshExt_off;
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
+			      m1ThreshLow);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
+			      m2ThreshLow);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M1_THRESH,
+			      m1Thresh);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2_THRESH,
+			      m2Thresh);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2COUNT_THR,
+			      m2CountThr);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
+			      m2CountThrLow);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW,
+			      m1ThreshLowExt);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW,
+			      m2ThreshLowExt);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH,
+			      m1ThreshExt);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH,
+			      m2ThreshExt);
+skip_ws_det:
 		if (on)
 			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
 				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
-- 
1.8.3

