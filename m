Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55436 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 13/14] ath9k: inline AR9271 1.0 INI overrides
Date: Wed, 14 Mar 2012 16:40:33 +0100
Message-Id: <1331739634-22318-13-git-send-email-nbd@openwrt.org> (sfid-20120314_164114_247804_598CD223)
In-Reply-To: <1331739634-22318-12-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
 <1331739634-22318-6-git-send-email-nbd@openwrt.org>
 <1331739634-22318-7-git-send-email-nbd@openwrt.org>
 <1331739634-22318-8-git-send-email-nbd@openwrt.org>
 <1331739634-22318-9-git-send-email-nbd@openwrt.org>
 <1331739634-22318-10-git-send-email-nbd@openwrt.org>
 <1331739634-22318-11-git-send-email-nbd@openwrt.org>
 <1331739634-22318-12-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes them more readable and reduces code size

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c      |    7 ++++---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |    3 ---
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |    6 ------
 drivers/net/wireless/ath/ath9k/ar9002_phy.h      |    2 ++
 drivers/net/wireless/ath/ath9k/hw.h              |    1 -
 5 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3e108c8..d7d8e91 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -834,9 +834,10 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 	    AR_SREV_9287_11_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
-	if (AR_SREV_9271_10(ah))
-		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
-				modesIndex, regWrites);
+	if (AR_SREV_9271_10(ah)) {
+		REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENA);
+		REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_ADC_ON, 0xa);
+	}
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 99d2dd9..d9a69fc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -34,9 +34,6 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar9271Modes_9271), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271,
 			       ARRAY_SIZE(ar9271Common_9271), 2);
-		INIT_INI_ARRAY(&ah->iniModes_9271_1_0_only,
-			       ar9271Modes_9271_1_0_only,
-			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 5);
 		INIT_INI_ARRAY(&ah->iniModes_9271_ANI_reg, ar9271Modes_9271_ANI_reg,
 			       ARRAY_SIZE(ar9271Modes_9271_ANI_reg), 5);
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index d571c32..4d18c66 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -3092,12 +3092,6 @@ static const u32 ar9271Common_9271[][2] = {
 	{0x0000d384, 0xf3307ff0},
 };
 
-static const u32 ar9271Modes_9271_1_0_only[][5] = {
-	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x00009910, 0x30002311, 0x30002311, 0x30002311, 0x30002311},
-	{0x00009828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001},
-};
-
 static const u32 ar9271Modes_9271_ANI_reg[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009850, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2},
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index 453af6d..f9eb2c3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -60,6 +60,8 @@
 #define AR_PHY_RF_CTL3                  0x9828
 #define AR_PHY_TX_END_TO_A2_RX_ON       0x00FF0000
 #define AR_PHY_TX_END_TO_A2_RX_ON_S     16
+#define AR_PHY_TX_END_TO_ADC_ON         0xFF000000
+#define AR_PHY_TX_END_TO_ADC_ON_S       24
 
 #define AR_PHY_ADC_CTL                  0x982C
 #define AR_PHY_ADC_CTL_OFF_INBUFGAIN    0x00000003
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 489477c..67e467d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -831,7 +831,6 @@ struct ath_hw {
 	struct ar5416IniArray iniAdditional;
 	struct ar5416IniArray iniModesRxGain;
 	struct ar5416IniArray iniModesTxGain;
-	struct ar5416IniArray iniModes_9271_1_0_only;
 	struct ar5416IniArray iniCckfirNormal;
 	struct ar5416IniArray iniCckfirJapan2484;
 	struct ar5416IniArray ini_japan2484;
-- 
1.7.3.2

