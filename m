Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23158 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZLNJYK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 04:24:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 01:24:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19238.1252.530915.570397@gargle.gargle.HOWL>
Date: Mon, 14 Dec 2009 14:57:00 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] ath9k: Clarify Interrupt mitigation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k currently supports only RX interrupt
mitigation.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   10 +++++-----
 drivers/net/wireless/ath/ath9k/hw.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2ec61f0..3068535 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -392,7 +392,7 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	ah->config.intr_mitigation = true;
+	ah->config.rx_intr_mitigation = true;
 
 	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
@@ -1184,7 +1184,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (ah->config.intr_mitigation)
+	if (ah->config.rx_intr_mitigation)
 		ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
 	else
 		ah->mask_reg |= AR_IMR_RXOK;
@@ -2121,7 +2121,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_OBS, 8);
 
-	if (ah->config.intr_mitigation) {
+	if (ah->config.rx_intr_mitigation) {
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
 	}
@@ -2781,7 +2781,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 
 		*masked = isr & ATH9K_INT_COMMON;
 
-		if (ah->config.intr_mitigation) {
+		if (ah->config.rx_intr_mitigation) {
 			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
 				*masked |= ATH9K_INT_RX;
 		}
@@ -2914,7 +2914,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	}
 	if (ints & ATH9K_INT_RX) {
 		mask |= AR_IMR_RXERR;
-		if (ah->config.intr_mitigation)
+		if (ah->config.rx_intr_mitigation)
 			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
 		else
 			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e2b0c73..8849450 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -212,7 +212,7 @@ struct ath9k_ops_config {
 	u32 cck_trig_low;
 	u32 enable_ani;
 	int serialize_regmode;
-	bool intr_mitigation;
+	bool rx_intr_mitigation;
 #define SPUR_DISABLE        	0
 #define SPUR_ENABLE_IOCTL   	1
 #define SPUR_ENABLE_EEPROM  	2
-- 
1.6.5.6

