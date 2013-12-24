Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46638 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3LXFTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 00:19:33 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/11] ath9k: Fix baseband watchdog interrupts
Date: Tue, 24 Dec 2013 10:44:22 +0530
Message-Id: <1387862067-25457-6-git-send-email-sujith@msujith.org> (sfid-20131224_062013_124908_B8DAED9B)
In-Reply-To: <1387862067-25457-1-git-send-email-sujith@msujith.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Program the required baseband watchdog interrupt
mask to ensure that the correct watchdog interrupts
are raised when the BB is hung for some reason.

Also, use the capability HW_BB_WATCHDOG instead of
relying on other flags.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mac.c  | 24 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/main.c |  8 +++++---
 drivers/net/wireless/ath/ath9k/reg.h  |  1 +
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 89d7e20..5f72758 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -922,11 +922,29 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah)
 			mask2 |= AR_IMR_S2_CST;
 	}
 
+	if (ah->config.hw_hang_checks & HW_BB_WATCHDOG) {
+		if (ints & ATH9K_INT_BB_WATCHDOG) {
+			mask |= AR_IMR_BCNMISC;
+			mask2 |= AR_IMR_S2_BB_WATCHDOG;
+		}
+	}
+
 	ath_dbg(common, INTERRUPT, "new IMR 0x%x\n", mask);
 	REG_WRITE(ah, AR_IMR, mask);
-	ah->imrs2_reg &= ~(AR_IMR_S2_TIM | AR_IMR_S2_DTIM | AR_IMR_S2_DTIMSYNC |
-			   AR_IMR_S2_CABEND | AR_IMR_S2_CABTO |
-			   AR_IMR_S2_TSFOOR | AR_IMR_S2_GTT | AR_IMR_S2_CST);
+	ah->imrs2_reg &= ~(AR_IMR_S2_TIM |
+			   AR_IMR_S2_DTIM |
+			   AR_IMR_S2_DTIMSYNC |
+			   AR_IMR_S2_CABEND |
+			   AR_IMR_S2_CABTO |
+			   AR_IMR_S2_TSFOOR |
+			   AR_IMR_S2_GTT |
+			   AR_IMR_S2_CST);
+
+	if (ah->config.hw_hang_checks & HW_BB_WATCHDOG) {
+		if (ints & ATH9K_INT_BB_WATCHDOG)
+			ah->imrs2_reg &= ~AR_IMR_S2_BB_WATCHDOG;
+	}
+
 	ah->imrs2_reg |= mask2;
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dd9bad2..894c892 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -587,7 +587,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	    !(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)))
 		goto chip_reset;
 
-	if ((ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
+	if ((ah->config.hw_hang_checks & HW_BB_WATCHDOG) &&
 	    (status & ATH9K_INT_BB_WATCHDOG)) {
 
 		spin_lock(&common->cc_lock);
@@ -726,11 +726,13 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		ah->imask |= ATH9K_INT_RXHP |
-			     ATH9K_INT_RXLP |
-			     ATH9K_INT_BB_WATCHDOG;
+			     ATH9K_INT_RXLP;
 	else
 		ah->imask |= ATH9K_INT_RX;
 
+	if (ah->config.hw_hang_checks & HW_BB_WATCHDOG)
+		ah->imask |= ATH9K_INT_BB_WATCHDOG;
+
 	ah->imask |= ATH9K_INT_GTT;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 9ad0073..c9a8b77 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -304,6 +304,7 @@
 #define AR_IMR_S2              0x00ac
 #define AR_IMR_S2_QCU_TXURN    0x000003FF
 #define AR_IMR_S2_QCU_TXURN_S  0
+#define AR_IMR_S2_BB_WATCHDOG  0x00010000
 #define AR_IMR_S2_CST          0x00400000
 #define AR_IMR_S2_GTT          0x00800000
 #define AR_IMR_S2_TIM          0x01000000
-- 
1.8.5.2

