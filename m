Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48597 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3ICFCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:02:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k: Fix regulatory compliance for AR9462/AR9565
Date: Tue,  3 Sep 2013 10:28:55 +0530
Message-Id: <1378184337-1816-1-git-send-email-sujith@msujith.org> (sfid-20130903_070250_594318_F7A9E9A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Adjust the CCA values based on the regulatory domain
present in the EEPROM.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |  4 ++++
 drivers/net/wireless/ath/ath9k/hw.c         | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 6fd7523..fca6243 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -343,8 +343,12 @@
 
 #define AR_PHY_CCA_NOM_VAL_9462_2GHZ          -127
 #define AR_PHY_CCA_MIN_GOOD_VAL_9462_2GHZ     -127
+#define AR_PHY_CCA_MAX_GOOD_VAL_9462_2GHZ     -60
+#define AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_2GHZ -95
 #define AR_PHY_CCA_NOM_VAL_9462_5GHZ          -127
 #define AR_PHY_CCA_MIN_GOOD_VAL_9462_5GHZ     -127
+#define AR_PHY_CCA_MAX_GOOD_VAL_9462_5GHZ     -60
+#define AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_5GHZ -100
 
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ecc6ec4..260e0c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -549,6 +549,18 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 
 	ath9k_hw_ani_init(ah);
 
+	/*
+	 * EEPROM needs to be initialized before we do this.
+	 * This is required for regulatory compliance.
+	 */
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+		u16 regdmn = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
+		if ((regdmn & 0xF0) == CTL_FCC) {
+			ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_2GHZ;
+			ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_9462_FCC_5GHZ;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.8.4

