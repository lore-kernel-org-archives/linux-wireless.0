Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab0DOVjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 49/97] ath9k_hw: shift code for AR9280 OLC temp comp
Date: Thu, 15 Apr 2010 17:38:54 -0400
Message-Id: <1271367582-992-50-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're bailing out on the alternative code path so remove the
else branch.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   35 +++++++++++++++----------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index e2c427b..5d61169 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -711,25 +711,24 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 		rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
 		currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
 
-		if (ah->initPDADC == 0 || currPDADC == 0) {
+		if (ah->initPDADC == 0 || currPDADC == 0)
 			return;
-		} else {
-			if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
-				delta = (currPDADC - ah->initPDADC + 4) / 8;
-			else
-				delta = (currPDADC - ah->initPDADC + 5) / 10;
-
-			if (delta != ah->PDADCdelta) {
-				ah->PDADCdelta = delta;
-				for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
-					regval = ah->originalGain[i] - delta;
-					if (regval < 0)
-						regval = 0;
-
-					REG_RMW_FIELD(ah,
-						      AR_PHY_TX_GAIN_TBL1 + i * 4,
-						      AR_PHY_TX_GAIN, regval);
-				}
+
+		if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
+			delta = (currPDADC - ah->initPDADC + 4) / 8;
+		else
+			delta = (currPDADC - ah->initPDADC + 5) / 10;
+
+		if (delta != ah->PDADCdelta) {
+			ah->PDADCdelta = delta;
+			for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
+				regval = ah->originalGain[i] - delta;
+				if (regval < 0)
+					regval = 0;
+
+				REG_RMW_FIELD(ah,
+					      AR_PHY_TX_GAIN_TBL1 + i * 4,
+					      AR_PHY_TX_GAIN, regval);
 			}
 		}
 	}
-- 
1.6.3.3

