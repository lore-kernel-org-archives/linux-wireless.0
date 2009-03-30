Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25180 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168AbZC3KCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:49 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:48 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38859.237623.861759@gargle.gargle.HOWL> (sfid-20090330_120251_515801_D4A337EE)
Date: Mon, 30 Mar 2009 15:28:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 05/17] ath9k: Remove redundant variable for Interrupt Mitigation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The state is already stored in ath9k_ops_config, so remove
the duplicate variable in ath_hw.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   14 +++++---------
 drivers/net/wireless/ath9k/hw.h |    3 +--
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4ad1508..bb208f5 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -380,7 +380,7 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	ah->config.intr_mitigation = 1;
+	ah->config.intr_mitigation = true;
 
 	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
@@ -599,9 +599,6 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	ath9k_hw_set_defaults(ah);
 
-	if (ah->config.intr_mitigation != 0)
-		ah->intr_mitigation = true;
-
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
 		ecode = -EIO;
@@ -1028,7 +1025,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (ah->intr_mitigation)
+	if (ah->config.intr_mitigation)
 		ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
 	else
 		ah->mask_reg |= AR_IMR_RXOK;
@@ -2301,8 +2298,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_OBS, 8);
 
-	if (ah->intr_mitigation) {
-
+	if (ah->config.intr_mitigation) {
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
 	}
@@ -2908,7 +2904,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 
 		*masked = isr & ATH9K_INT_COMMON;
 
-		if (ah->intr_mitigation) {
+		if (ah->config.intr_mitigation) {
 			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
 				*masked |= ATH9K_INT_RX;
 		}
@@ -3026,7 +3022,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	}
 	if (ints & ATH9K_INT_RX) {
 		mask |= AR_IMR_RXERR;
-		if (ah->intr_mitigation)
+		if (ah->config.intr_mitigation)
 			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
 		else
 			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index c50faae..5a1128d 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -190,7 +190,7 @@ struct ath9k_ops_config {
 	u16 diversity_control;
 	u16 antenna_switch_swap;
 	int serialize_regmode;
-	int intr_mitigation;
+	bool intr_mitigation;
 #define SPUR_DISABLE        	0
 #define SPUR_ENABLE_IOCTL   	1
 #define SPUR_ENABLE_EEPROM  	2
@@ -524,7 +524,6 @@ struct ath_hw {
 	enum ath9k_ani_cmd ani_function;
 
 	u32 intr_txqs;
-	bool intr_mitigation;
 	enum ath9k_ht_extprotspacing extprotspacing;
 	u8 txchainmask;
 	u8 rxchainmask;
-- 
1.6.2.1

