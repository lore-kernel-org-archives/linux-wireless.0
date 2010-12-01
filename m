Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13847 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0LAHea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:34:30 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:34:16 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/26] ath9k_hw: Configure xpa bias level for AR9485
Date: Tue, 30 Nov 2010 23:32:43 -0800
Message-ID: <1291188775-13707-15-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   12 +++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    4 ++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c85b97e..02b6150 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3449,9 +3449,15 @@ static s32 ar9003_hw_xpa_bias_level_get(struct ath_hw *ah, bool is2ghz)
 static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int bias = ar9003_hw_xpa_bias_level_get(ah, is2ghz);
-	REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
-	REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPABIASLVL_MSB, bias >> 2);
-	REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPASHORT2GND, 1);
+
+	if (AR_SREV_9485(ah))
+		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
+	else {
+		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
+		REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPABIASLVL_MSB,
+			      bias >> 2);
+		REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPASHORT2GND, 1);
+	}
 }
 
 static u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 3394dfe..b772081 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -584,6 +584,10 @@
 #define AR_PHY_65NM_CH2_RXTX1       0x16900
 #define AR_PHY_65NM_CH2_RXTX2       0x16904
 
+#define AR_CH0_TOP2 (AR_SREV_9485(ah) ? 0x00016284 : 0x0001628c)
+#define AR_CH0_TOP2_XPABIASLVL		0xf000
+#define AR_CH0_TOP2_XPABIASLVL_S	12
+
 #define AR_PHY_RX1DB_BIQUAD_LONG_SHIFT		0x00380000
 #define AR_PHY_RX1DB_BIQUAD_LONG_SHIFT_S	19
 #define AR_PHY_RX6DB_BIQUAD_LONG_SHIFT		0x00c00000
-- 
1.7.0.4

