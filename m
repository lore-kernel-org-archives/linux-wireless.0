Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51274 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0F3AHv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 20:07:51 -0400
Message-ID: <4C2A8AD4.8070504@openwrt.org>
Date: Wed, 30 Jun 2010 02:07:48 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
Subject: [PATCH] ath9k: fix TSF after reset on AR913x
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When issuing a reset, the TSF value is lost in the hardware because of 
the 913x specific cold reset. As with some AR9280 cards, the TSF needs 
to be preserved in software here.

Additionally, there's an issue that frequently prevents a successful
TSF write directly after the chip reset. In this case, repeating the
TSF write after the initval-writes usually works.

This patch detects failed TSF writes and recovers from them, taking
into account the delay caused by the initval writes.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1280,7 +1280,8 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
 
 	/* For chips on which RTC reset is done, save TSF before it gets cleared */
-	if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+	if (AR_SREV_9100(ah) ||
+	    (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)))
 		tsf = ath9k_hw_gettsf64(ah);
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
@@ -1312,7 +1313,7 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	}
 
 	/* Restore TSF */
-	if (tsf && AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+	if (tsf)
 		ath9k_hw_settsf64(ah, tsf);
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
@@ -1325,6 +1326,17 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	if (r)
 		return r;
 
+	/*
+	 * Some AR91xx SoC devices frequently fail to accept TSF writes
+	 * right after the chip reset. When that happens, write a new
+	 * value after the initvals have been applied, with an offset
+	 * based on measured time difference
+	 */
+	if (AR_SREV_9100(ah) && (ath9k_hw_gettsf64(ah) < tsf)) {
+		tsf += 1500;
+		ath9k_hw_settsf64(ah, tsf);
+	}
+
 	/* Setup MFP options for CCMP */
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		/* Mask Retry(b11), PwrMgt(b12), MoreData(b13) to 0 in mgmt
