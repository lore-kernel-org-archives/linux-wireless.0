Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37727 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3LPBkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 20:40:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2] ath9k: Fix interrupt handling for the AR9002 family
Date: Mon, 16 Dec 2013 07:04:59 +0530
Message-Id: <1387157699-16704-1-git-send-email-sujith@msujith.org> (sfid-20131216_024029_018892_23C29D11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch adds a driver workaround for a HW issue.

A race condition in the HW results in missing interrupts,
which can be avoided by a read/write with the ISR register.
All chips in the AR9002 series are affected by this bug - AR9003
and above do not have this problem.

Cc: stable@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
v2 - Clear the ISR status register properly for AR9100, pointed
     out by Felix.

 drivers/net/wireless/ath/ath9k/ar9002_mac.c | 52 ++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 8d78253..a366d6b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -76,9 +76,16 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 				mask2 |= ATH9K_INT_CST;
 			if (isr2 & AR_ISR_S2_TSFOOR)
 				mask2 |= ATH9K_INT_TSFOOR;
+
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+				REG_WRITE(ah, AR_ISR_S2, isr2);
+				isr &= ~AR_ISR_BCNMISC;
+			}
 		}
 
-		isr = REG_READ(ah, AR_ISR_RAC);
+		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)
+			isr = REG_READ(ah, AR_ISR_RAC);
+
 		if (isr == 0xffffffff) {
 			*masked = 0;
 			return false;
@@ -97,11 +104,23 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 			*masked |= ATH9K_INT_TX;
 
-			s0_s = REG_READ(ah, AR_ISR_S0_S);
+			if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
+				s0_s = REG_READ(ah, AR_ISR_S0_S);
+				s1_s = REG_READ(ah, AR_ISR_S1_S);
+			} else {
+				s0_s = REG_READ(ah, AR_ISR_S0);
+				REG_WRITE(ah, AR_ISR_S0, s0_s);
+				s1_s = REG_READ(ah, AR_ISR_S1);
+				REG_WRITE(ah, AR_ISR_S1, s1_s);
+
+				isr &= ~(AR_ISR_TXOK |
+					 AR_ISR_TXDESC |
+					 AR_ISR_TXERR |
+					 AR_ISR_TXEOL);
+			}
+
 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
-
-			s1_s = REG_READ(ah, AR_ISR_S1_S);
 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
 		}
@@ -114,13 +133,15 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		*masked |= mask2;
 	}
 
-	if (AR_SREV_9100(ah))
-		return true;
-
-	if (isr & AR_ISR_GENTMR) {
+	if (!AR_SREV_9100(ah) && (isr & AR_ISR_GENTMR)) {
 		u32 s5_s;
 
-		s5_s = REG_READ(ah, AR_ISR_S5_S);
+		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
+			s5_s = REG_READ(ah, AR_ISR_S5_S);
+		} else {
+			s5_s = REG_READ(ah, AR_ISR_S5);
+		}
+
 		ah->intr_gen_timer_trigger =
 				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
 
@@ -133,8 +154,21 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		if ((s5_s & AR_ISR_S5_TIM_TIMER) &&
 		    !(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 			*masked |= ATH9K_INT_TIM_TIMER;
+
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+			REG_WRITE(ah, AR_ISR_S5, s5_s);
+			isr &= ~AR_ISR_GENTMR;
+		}
 	}
 
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+		REG_WRITE(ah, AR_ISR, isr);
+		REG_READ(ah, AR_ISR);
+	}
+
+	if (AR_SREV_9100(ah))
+		return true;
+
 	if (sync_cause) {
 		ath9k_debug_sync_cause(common, sync_cause);
 		fatal_int =
-- 
1.8.5.1

