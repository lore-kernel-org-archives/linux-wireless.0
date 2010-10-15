Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38720 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab0JOSDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 14:03:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/6] ath9k_hw: small optimization in ar9002_hw_get_isr
Date: Fri, 15 Oct 2010 20:03:29 +0200
Message-Id: <1287165813-94331-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah->config.rx_intr_mitigation does not need to be checked before checking
the rx interrupt mask for AR_ISR_RXMINTR or AR_ISR_RXINTM, as those
interrupts will be masked out if rx interrupt mitigation is disabled.

Avoid reading AR_ISR_S5_S twice by reordering the code to be more concise.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   32 +++++++++-----------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 50dda39..f5ed73d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -90,13 +90,10 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 		*masked = isr & ATH9K_INT_COMMON;
 
-		if (ah->config.rx_intr_mitigation) {
-			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
-				*masked |= ATH9K_INT_RX;
-		}
-
-		if (isr & (AR_ISR_RXOK | AR_ISR_RXERR))
+		if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM |
+			   AR_ISR_RXOK | AR_ISR_RXERR))
 			*masked |= ATH9K_INT_RX;
+
 		if (isr &
 		    (AR_ISR_TXOK | AR_ISR_TXDESC | AR_ISR_TXERR |
 		     AR_ISR_TXEOL)) {
@@ -118,14 +115,6 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 				  "receive FIFO overrun interrupt\n");
 		}
 
-		if (!AR_SREV_9100(ah)) {
-			if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-				u32 isr5 = REG_READ(ah, AR_ISR_S5_S);
-				if (isr5 & AR_ISR_S5_TIM_TIMER)
-					*masked |= ATH9K_INT_TIM_TIMER;
-			}
-		}
-
 		*masked |= mask2;
 	}
 
@@ -136,17 +125,18 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		u32 s5_s;
 
 		s5_s = REG_READ(ah, AR_ISR_S5_S);
-		if (isr & AR_ISR_GENTMR) {
-			ah->intr_gen_timer_trigger =
+		ah->intr_gen_timer_trigger =
 				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
 
-			ah->intr_gen_timer_thresh =
-				MS(s5_s, AR_ISR_S5_GENTIMER_THRESH);
+		ah->intr_gen_timer_thresh =
+			MS(s5_s, AR_ISR_S5_GENTIMER_THRESH);
 
-			if (ah->intr_gen_timer_trigger)
-				*masked |= ATH9K_INT_GENTIMER;
+		if (ah->intr_gen_timer_trigger)
+			*masked |= ATH9K_INT_GENTIMER;
 
-		}
+		if ((s5_s & AR_ISR_S5_TIM_TIMER) &&
+		    !(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
+			*masked |= ATH9K_INT_TIM_TIMER;
 	}
 
 	if (sync_cause) {
-- 
1.7.2.2

