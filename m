Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52683 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2J3LNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 07:13:37 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath9k: Do not enable ANT diversity if ANT control bit is not set
Date: Tue, 30 Oct 2012 16:43:32 +0530
Message-ID: <1351595612-3566-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121030_121341_093847_F799BB5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RvR test is not good when ANT control bit is not set so
enable ANT diversity only when ANT control bit is set.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   12 +++++++-----
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 ++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 759f5f5..c93af57 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1340,10 +1340,9 @@ static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
 	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
 	regval &= (~AR_ANT_DIV_CTRL_ALL);
 	regval |= (ant_div_ctl1 & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
-	regval &= ~AR_PHY_ANT_DIV_LNADIV;
-	regval |= ((ant_div_ctl1 >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
 
-	if (enable)
+	if (enable &&
+	    (ant_div_ctl1 & AR_EEP_ANT_DIV_ENABLE))
 		regval |= AR_ANT_DIV_ENABLE;
 
 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
@@ -1352,12 +1351,15 @@ static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
 	regval &= ~AR_FAST_DIV_ENABLE;
 	regval |= ((ant_div_ctl1 >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
 
-	if (enable)
+	if (enable &&
+	    (ant_div_ctl1 & AR_EEP_FAST_DIV_ENABLE))
 		regval |= AR_FAST_DIV_ENABLE;
 
 	REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
 
-	if (enable) {
+	if (enable &&
+	    (ant_div_ctl1 & (AR_EEP_ANT_DIV_ENABLE |
+			     AR_EEP_FAST_DIV_ENABLE))) {
 		REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
 			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
 		if (ah->curchan && IS_CHAN_2GHZ(ah->curchan))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 8f58523..b681f27 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -300,6 +300,8 @@
 #define AR_PHY_ANT_DIV_LNA2                     0x1
 #define AR_PHY_ANT_DIV_LNA1                     0x2
 #define AR_PHY_ANT_DIV_LNA1_PLUS_LNA2           0x3
+#define AR_EEP_ANT_DIV_ENABLE                   0x80
+#define AR_EEP_FAST_DIV_ENABLE                  0x40
 
 #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
 #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
-- 
1.7.4.1

