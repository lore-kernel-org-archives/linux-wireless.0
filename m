Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30957 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759068Ab1EMPAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:00:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:00:06 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/9] ath9k_hw: config diversity based on eeprom contents
Date: Fri, 13 May 2011 20:30:27 +0530
Message-ID: <1305298827-3426-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_170043_227357_7FAA99E7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

* enable LNA-diversity, fast-diversity for AR9485 based  on
  the value read from EEPROM content
* if antenna diversity/combining is supported, set LNA1 for the main
  antenna and LNA2 for the alternate antenna based on the new diversity
  algorithm

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   50 +++++++++++++++++++++---
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 37f86c0..f8617ba 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3498,6 +3498,8 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah,
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int chain;
+	u32 regval;
+	u32 ant_div_ctl1;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
 			AR_PHY_SWITCH_CHAIN_1,
@@ -3523,13 +3525,49 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 
 	if (AR_SREV_9485(ah)) {
 		value = ath9k_hw_ar9300_get_eeprom(ah, EEP_ANT_DIV_CTL1);
-		REG_RMW_FIELD(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_CTRL_ALL,
-			      value);
-		REG_RMW_FIELD(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE,
-			      value >> 6);
-		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE,
-			      value >> 7);
+		/*
+		 * main_lnaconf, alt_lnaconf, main_tb, alt_tb
+		 * are the fields present
+		 */
+		regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+		regval &= (~AR_ANT_DIV_CTRL_ALL);
+		regval |= (value & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
+		/* enable_lnadiv */
+		regval &= (~AR_PHY_9485_ANT_DIV_LNADIV);
+		regval |= ((value >> 6) & 0x1) <<
+				AR_PHY_9485_ANT_DIV_LNADIV_S;
+		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+
+		/*enable fast_div */
+		regval = REG_READ(ah, AR_PHY_CCK_DETECT);
+		regval &= (~AR_FAST_DIV_ENABLE);
+		regval |= ((value >> 7) & 0x1) <<
+				AR_FAST_DIV_ENABLE_S;
+		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
+		ant_div_ctl1 =
+			ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
+		/* check whether antenna diversity is enabled */
+		if ((ant_div_ctl1 >> 0x6) == 0x3) {
+			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+			/*
+			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
+			 * main_tb, alt_tb
+			 */
+			regval &= (~(AR_PHY_9485_ANT_DIV_MAIN_LNACONF |
+					AR_PHY_9485_ANT_DIV_ALT_LNACONF |
+					AR_PHY_9485_ANT_DIV_ALT_GAINTB |
+					AR_PHY_9485_ANT_DIV_MAIN_GAINTB));
+			/* by default use LNA1 for the main antenna */
+			regval |= (AR_PHY_9485_ANT_DIV_LNA1 <<
+					AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S);
+			regval |= (AR_PHY_9485_ANT_DIV_LNA2 <<
+					AR_PHY_9485_ANT_DIV_ALT_LNACONF_S);
+			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+		}
+
+
 	}
+
 }
 
 static void ar9003_hw_drive_strength_apply(struct ath_hw *ah)
-- 
1.7.0.4

