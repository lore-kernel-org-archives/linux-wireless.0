Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41888 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3LFLD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:03:59 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/16] ath9k: Fix regulatory compliance
Date: Fri,  6 Dec 2013 16:28:50 +0530
Message-Id: <1386327534-31105-13-git-send-email-sujith@msujith.org> (sfid-20131206_120420_011569_12F2A71E)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Adjusting the CCA registers for maximum permissible
noise floor in ETSI/Japan domains has to be done for
all AR9003 family chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 5 +++--
 drivers/net/wireless/ath/ath9k/hw.c         | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 2af667b..bbbfc4d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -341,14 +341,15 @@
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
 
+#define AR_PHY_CCA_MAX_GOOD_VAL_9300_FCC_2GHZ -95
+#define AR_PHY_CCA_MAX_GOOD_VAL_9300_FCC_5GHZ -100
+
 #define AR_PHY_CCA_NOM_VAL_9462_2GHZ          -127
 #define AR_PHY_CCA_MIN_GOOD_VAL_9462_2GHZ     -127
 #define AR_PHY_CCA_MAX_GOOD_VAL_9462_2GHZ     -60
-#define AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_2GHZ -95
 #define AR_PHY_CCA_NOM_VAL_9462_5GHZ          -127
 #define AR_PHY_CCA_MIN_GOOD_VAL_9462_5GHZ     -127
 #define AR_PHY_CCA_MAX_GOOD_VAL_9462_5GHZ     -60
-#define AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_5GHZ -100
 
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 779d38a..4ee24b1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -548,11 +548,11 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	 * EEPROM needs to be initialized before we do this.
 	 * This is required for regulatory compliance.
 	 */
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		u16 regdmn = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
 		if ((regdmn & 0xF0) == CTL_FCC) {
-			ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_2GHZ;
-			ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_5GHZ;
+			ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_FCC_2GHZ;
+			ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_FCC_5GHZ;
 		}
 	}
 
-- 
1.8.4.2

