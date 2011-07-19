Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57260 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1GSGq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 02:46:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: validate and fix broken eeprom chainmask settings
Date: Tue, 19 Jul 2011 08:46:44 +0200
Message-Id: <1311058004-44356-1-git-send-email-nbd@openwrt.org> (sfid-20110719_084659_186344_B020A937)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices (e.g. Ubiquiti AirRouter) ship with broken EEPROM chainmask
data, which breaks the initial calibration after a hardware reset.
To fix this, mask the eeprom chainmask with the chainmask of the chip,
and use the chip chainmask if the result is zero.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a5f908..8006ce0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1997,12 +1997,22 @@ EXPORT_SYMBOL(ath9k_hw_set_sta_beacon_timers);
 /* HW Capabilities */
 /*******************/
 
+static u8 fixup_chainmask(u8 chip_chainmask, u8 eeprom_chainmask)
+{
+	eeprom_chainmask &= chip_chainmask;
+	if (eeprom_chainmask)
+		return eeprom_chainmask;
+	else
+		return chip_chainmask;
+}
+
 int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	unsigned int chip_chainmask;
 
 	u16 eeval;
 	u8 ant_div_ctl1, tx_chainmask, rx_chainmask;
@@ -2039,6 +2049,15 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (eeval & AR5416_OPFLAGS_11G)
 		pCap->hw_caps |= ATH9K_HW_CAP_2GHZ;
 
+	if (AR_SREV_9485(ah) || AR_SREV_9285(ah) || AR_SREV_9330(ah))
+		chip_chainmask = 1;
+	else if (!AR_SREV_9280_20_OR_LATER(ah))
+		chip_chainmask = 7;
+	else if (!AR_SREV_9300_20_OR_LATER(ah) || AR_SREV_9340(ah))
+		chip_chainmask = 3;
+	else
+		chip_chainmask = 7;
+
 	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
 	/*
 	 * For AR9271 we will temporarilly uses the rx chainmax as read from
@@ -2055,6 +2074,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		/* Use rx_chainmask from EEPROM. */
 		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
 
+	pCap->tx_chainmask = fixup_chainmask(chip_chainmask, pCap->tx_chainmask);
+	pCap->rx_chainmask = fixup_chainmask(chip_chainmask, pCap->rx_chainmask);
+
 	ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
 
 	/* enable key search for every frame in an aggregate */
-- 
1.7.3.2

