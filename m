Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab0DODaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 50/97] ath9k_hw: move the AR9280 OLC temp comp to its own helper
Date: Wed, 14 Apr 2010 23:30:04 -0400
Message-Id: <1271302251-9075-51-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   52 +++++++++++++++++--------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 5d61169..dae200c 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -700,40 +700,44 @@ static void ar9287_hw_olc_temp_compensation(struct ath_hw *ah)
 	}
 }
 
-static void ath9k_olc_temp_compensation(struct ath_hw *ah)
+static void ar9280_hw_olc_temp_compensation(struct ath_hw *ah)
 {
 	u32 rddata, i;
 	int delta, currPDADC, regval;
 
-	if (OLC_FOR_AR9287_10_LATER) {
-		ar9287_hw_olc_temp_compensation(ah);
-	} else {
-		rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
-		currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
+	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
+	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
 
-		if (ah->initPDADC == 0 || currPDADC == 0)
-			return;
+	if (ah->initPDADC == 0 || currPDADC == 0)
+		return;
 
-		if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
-			delta = (currPDADC - ah->initPDADC + 4) / 8;
-		else
-			delta = (currPDADC - ah->initPDADC + 5) / 10;
-
-		if (delta != ah->PDADCdelta) {
-			ah->PDADCdelta = delta;
-			for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
-				regval = ah->originalGain[i] - delta;
-				if (regval < 0)
-					regval = 0;
-
-				REG_RMW_FIELD(ah,
-					      AR_PHY_TX_GAIN_TBL1 + i * 4,
-					      AR_PHY_TX_GAIN, regval);
-			}
+	if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
+		delta = (currPDADC - ah->initPDADC + 4) / 8;
+	else
+		delta = (currPDADC - ah->initPDADC + 5) / 10;
+
+	if (delta != ah->PDADCdelta) {
+		ah->PDADCdelta = delta;
+		for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
+			regval = ah->originalGain[i] - delta;
+			if (regval < 0)
+				regval = 0;
+
+			REG_RMW_FIELD(ah,
+				      AR_PHY_TX_GAIN_TBL1 + i * 4,
+				      AR_PHY_TX_GAIN, regval);
 		}
 	}
 }
 
+static void ath9k_olc_temp_compensation(struct ath_hw *ah)
+{
+	if (OLC_FOR_AR9287_10_LATER)
+		ar9287_hw_olc_temp_compensation(ah);
+	else
+		ar9280_hw_olc_temp_compensation(ah);
+}
+
 static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 	u32 regVal;
-- 
1.6.3.3

