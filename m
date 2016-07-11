Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52463 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbcGKIfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 04:35:44 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k_hw: fix spectral scan on AR9285 and newer
Date: Mon, 11 Jul 2016 10:35:39 +0200
Message-Id: <20160711083539.58649-1-nbd@nbd.name> (sfid-20160711_103548_985242_E79FFB66)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The register layout of AR_PHY_SPECTRAL_SCAN has changed, only AR9280
uses the old layout

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 32 +++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |  5 ++++-
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 53d7445..61a9b85 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -476,6 +476,7 @@ static void ar9002_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 				    struct ath_spec_scan *param)
 {
+	u32 repeat_bit;
 	u8 count;
 
 	if (!param->enabled) {
@@ -486,12 +487,15 @@ static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
 
+	if (AR_SREV_9280(ah))
+		repeat_bit = AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT;
+	else
+		repeat_bit = AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_KIWI;
+
 	if (param->short_repeat)
-		REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
-			    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+		REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, repeat_bit);
 	else
-		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
-			    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN, repeat_bit);
 
 	/* on AR92xx, the highest bit of count will make the the chip send
 	 * spectral samples endlessly. Check if this really was intended,
@@ -499,15 +503,25 @@ static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 	 */
 	count = param->count;
 	if (param->endless) {
-		if (AR_SREV_9271(ah))
-			count = 0;
-		else
+		if (AR_SREV_9280(ah))
 			count = 0x80;
+		else
+			count = 0;
 	} else if (count & 0x80)
 		count = 0x7f;
+	else if (!count)
+		count = 1;
+
+	if (AR_SREV_9280(ah)) {
+		REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+			      AR_PHY_SPECTRAL_SCAN_COUNT, count);
+	} else {
+		REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+			      AR_PHY_SPECTRAL_SCAN_COUNT_KIWI, count);
+		REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+			    AR_PHY_SPECTRAL_SCAN_PHYERR_MASK_SELECT);
+	}
 
-	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
-		      AR_PHY_SPECTRAL_SCAN_COUNT, count);
 	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
 		      AR_PHY_SPECTRAL_SCAN_PERIOD, param->period);
 	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index 9d17a53..2b58245 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -177,8 +177,11 @@
 #define AR_PHY_SPECTRAL_SCAN_PERIOD_S		8
 #define AR_PHY_SPECTRAL_SCAN_COUNT		0x00FF0000  /* Number of reports, reg 68, bits 16-23*/
 #define AR_PHY_SPECTRAL_SCAN_COUNT_S		16
+#define AR_PHY_SPECTRAL_SCAN_COUNT_KIWI		0x0FFF0000  /* Number of reports, reg 68, bits 16-27*/
+#define AR_PHY_SPECTRAL_SCAN_COUNT_KIWI_S	16
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT	0x01000000  /* Short repeat, reg 68, bit 24*/
-#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S	24  /* Short repeat, reg 68, bit 24*/
+#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_KIWI	0x10000000  /* Short repeat, reg 68, bit 28*/
+#define AR_PHY_SPECTRAL_SCAN_PHYERR_MASK_SELECT	0x40000000
 
 #define AR_PHY_RX_DELAY           0x9914
 #define AR_PHY_SEARCH_START_DELAY 0x9918
-- 
2.8.4

