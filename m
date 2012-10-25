Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29489 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab2JYPbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 11:31:16 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k: Do not enable ANT diversity if ANT control bit is 0
Date: Thu, 25 Oct 2012 20:54:50 +0530
Message-ID: <1351178692-2054-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121025_173120_844054_F98716A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RvR test is not good when ANT control bit is not set so
enable ANT diversity only when ANT control bit is set.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   22 +++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 189aeb2..d2e44c3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3630,15 +3630,21 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
 		regval &= (~AR_ANT_DIV_CTRL_ALL);
 		regval |= (value & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
-		/* enable_lnadiv */
-		regval &= (~AR_PHY_ANT_DIV_LNADIV);
-		regval |= ((value >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
+
+		if (AR_SREV_9485(ah)) {
+			/* enable_lnadiv */
+			regval &= (~AR_PHY_ANT_DIV_LNADIV);
+			regval |= ((value >> 6) & 0x1) <<
+				   AR_PHY_ANT_DIV_LNADIV_S;
+		}
 
 		if (AR_SREV_9565(ah)) {
-			if (ah->shared_chain_lnadiv) {
+			if (ah->shared_chain_lnadiv &&
+			    (value & AR_EEP_ANT_DIV_ENABLE)) {
+				regval |= AR_ANT_DIV_ENABLE;
 				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
 			} else {
-				regval &= ~(1 << AR_PHY_ANT_DIV_LNADIV_S);
+				regval &= ~AR_ANT_DIV_ENABLE;
 				regval &= ~(1 << AR_PHY_ANT_SW_RX_PROT_S);
 			}
 		}
@@ -3649,6 +3655,12 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		regval = REG_READ(ah, AR_PHY_CCK_DETECT);
 		regval &= (~AR_FAST_DIV_ENABLE);
 		regval |= ((value >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
+		if (ah->shared_chain_lnadiv &&
+		    (AR_SREV_9485(ah) || (AR_SREV_9565(ah) &&
+		    (value & AR_EEP_FAST_DIV_ENABLE))))
+			regval |= AR_FAST_DIV_ENABLE;
+		else
+			regval &= ~AR_FAST_DIV_ENABLE;
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
 
 		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 9a48e3d..ecf5cc7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -299,6 +299,8 @@
 #define AR_PHY_ANT_DIV_LNA2                     0x1
 #define AR_PHY_ANT_DIV_LNA1                     0x2
 #define AR_PHY_ANT_DIV_LNA1_PLUS_LNA2           0x3
+#define AR_EEP_ANT_DIV_ENABLE                   0x80
+#define AR_EEP_FAST_DIV_ENABLE                  0x40
 
 #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
 #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
-- 
1.7.4.1

