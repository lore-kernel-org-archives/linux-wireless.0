Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44850 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZIRJeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:34:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:34:05 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21519.571008.709716@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:04:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH/REVIEW 2/9] ath9k: Update INI release for AR9287
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the current channel is between 2412 and 2472 MHz and if the channel is
changing to 2484 MHz, then the registers 0xa1f4, 0xa1f8 and 0xa1fc need to be
programmed to the "japan_2484" values.  Conversely, if the current channel
is 2484 MHz and if the channel is changing to one between 2412 and 2472 MHz, then
the three registers need to be programmed to the "normal" values.

This is needed for compliance with Japanese regulatory requirements.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c       |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.h       |    2 ++
 drivers/net/wireless/ath/ath9k/initvals.h |   23 ++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/phy.c      |   25 ++++++++++++++++++-------
 4 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6599426..6ed0289 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -943,6 +943,16 @@ int ath9k_hw_init(struct ath_hw *ah)
 	else
 		ath9k_hw_disablepcie(ah);
 
+	/* Support for Japan ch.14 (2484) spread */
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniCckfirNormal,
+		       ar9287Common_normal_cck_fir_coeff_92871_1,
+		       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_92871_1), 2);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+		       ar9287Common_japan_2484_cck_fir_coeff_92871_1,
+		       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_92871_1), 2);
+	}
+
 	r = ath9k_hw_post_init(ah);
 	if (r)
 		return r;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d854c17..6673a81 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -592,6 +592,8 @@ struct ath_hw {
 	struct ar5416IniArray iniModesAdditional;
 	struct ar5416IniArray iniModesRxGain;
 	struct ar5416IniArray iniModesTxGain;
+	struct ar5416IniArray iniCckfirNormal;
+	struct ar5416IniArray iniCckfirJapan2484;
 
 	u32 intr_gen_timer_trigger;
 	u32 intr_gen_timer_thresh;
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index 8622265..d8aaeee 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -5918,9 +5918,6 @@ static const u_int32_t ar9287Common_9287_1_1[][2] = {
     { 0x000099ec, 0x0cc80caa },
     { 0x000099f0, 0x00000000 },
     { 0x000099fc, 0x00001042 },
-    { 0x0000a1f4, 0x00fffeff },
-    { 0x0000a1f8, 0x00f5f9ff },
-    { 0x0000a1fc, 0xb79f6427 },
     { 0x0000a208, 0x803e4788 },
     { 0x0000a210, 0x4080a333 },
     { 0x0000a214, 0x40206c10 },
@@ -5980,7 +5977,7 @@ static const u_int32_t ar9287Common_9287_1_1[][2] = {
     { 0x0000b3f4, 0x00000000 },
     { 0x0000a7d8, 0x000003f1 },
     { 0x00007800, 0x00000800 },
-    { 0x00007804, 0x6c35ffc2 },
+    { 0x00007804, 0x6c35ffd2 },
     { 0x00007808, 0x6db6c000 },
     { 0x0000780c, 0x6db6cb30 },
     { 0x00007810, 0x6db6cb6c },
@@ -6000,7 +5997,7 @@ static const u_int32_t ar9287Common_9287_1_1[][2] = {
     { 0x00007848, 0x934934a8 },
     { 0x00007850, 0x00000000 },
     { 0x00007854, 0x00000800 },
-    { 0x00007858, 0x6c35ffc2 },
+    { 0x00007858, 0x6c35ffd2 },
     { 0x0000785c, 0x6db6c000 },
     { 0x00007860, 0x6db6cb30 },
     { 0x00007864, 0x6db6cb6c },
@@ -6027,6 +6024,22 @@ static const u_int32_t ar9287Common_9287_1_1[][2] = {
     { 0x000078b8, 0x2a850160 },
 };
 
+/*
+ * For Japanese regulatory requirements, 2484 MHz requires the following three
+ * registers be programmed differently from the channel between 2412 and 2472 MHz.
+ */
+static const u_int32_t ar9287Common_normal_cck_fir_coeff_92871_1[][2] = {
+    { 0x0000a1f4, 0x00fffeff },
+    { 0x0000a1f8, 0x00f5f9ff },
+    { 0x0000a1fc, 0xb79f6427 },
+};
+
+static const u_int32_t ar9287Common_japan_2484_cck_fir_coeff_92871_1[][2] = {
+    { 0x0000a1f4, 0x00000000 },
+    { 0x0000a1f8, 0xefff0301 },
+    { 0x0000a1fc, 0xca9228ee },
+};
+
 static const u_int32_t ar9287Modes_tx_gain_9287_1_1[][6] = {
     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index eec4f10..72a17c4 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -113,20 +113,31 @@ void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 
 	if (freq < 4800) {
 		u32 txctl;
+		int regWrites = 0;
 
 		bMode = 1;
 		fracMode = 1;
 		aModeRefSel = 0;
 		channelSel = (freq * 0x10000) / 15;
 
-		txctl = REG_READ(ah, AR_PHY_CCK_TX_CTRL);
-		if (freq == 2484) {
-
-			REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
-				  txctl | AR_PHY_CCK_TX_CTRL_JAPAN);
+		if (AR_SREV_9287_11_OR_LATER(ah)) {
+			if (freq == 2484) {
+				REG_WRITE_ARRAY(&ah->iniCckfirJapan2484,
+						1, regWrites);
+			} else {
+				REG_WRITE_ARRAY(&ah->iniCckfirNormal,
+						1, regWrites);
+			}
 		} else {
-			REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
-				  txctl & ~AR_PHY_CCK_TX_CTRL_JAPAN);
+			txctl = REG_READ(ah, AR_PHY_CCK_TX_CTRL);
+			if (freq == 2484) {
+				/* Enable channel spreading for channel 14 */
+				REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
+					  txctl | AR_PHY_CCK_TX_CTRL_JAPAN);
+			} else {
+				REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
+					  txctl &~ AR_PHY_CCK_TX_CTRL_JAPAN);
+			}
 		}
 	} else {
 		bMode = 0;
-- 
1.6.4.4

