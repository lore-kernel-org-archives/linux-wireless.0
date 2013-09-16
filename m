Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56278 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3IPFLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 01:11:02 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k: Remove incorrect diversity initialization
Date: Mon, 16 Sep 2013 10:37:01 +0530
Message-Id: <1379308021-20891-3-git-send-email-sujith@msujith.org> (sfid-20130916_071106_898444_0EE25738)
In-Reply-To: <1379308021-20891-1-git-send-email-sujith@msujith.org>
References: <1379308021-20891-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Fast antenna diversity is required only for single chain
chips and the diversity initialization is done in the
per-family board setup routines. Enabling of diversity
should be done based on the calibrated EEPROM/OTP data,
doing it for all chips is incorrect.

Remove the code that sets the fast_div bit for all cards, since
the documentation for the AR_PHY_CCK_DETECT register says:

reg 642: sig_detect_cck
enable_ant_fast_div : Only used for single chain chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 3 ---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 9e4e2a6..cb6435e 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -631,9 +631,6 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
 	}
 
-	REG_SET_BIT(ah, AR_PHY_CCK_DETECT,
-		    AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
-
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		return;
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ec37213..0131ba2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -632,9 +632,6 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 	       AR_PCU_MISC_MODE2_CFP_IGNORE;
 	REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
 
-	REG_SET_BIT(ah, AR_PHY_CCK_DETECT,
-		    AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
-
 	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		REG_WRITE(ah, AR_GLB_SWREG_DISCONT_MODE,
 			  AR_GLB_SWREG_DISCONT_EN_BT_WLAN);
-- 
1.8.4

