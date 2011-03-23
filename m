Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44607 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 07/10] ath9k_hw: remove pCap->reg_cap
Date: Wed, 23 Mar 2011 20:57:30 +0100
Message-Id: <1300910253-28189-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-6-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
 <1300910253-28189-3-git-send-email-nbd@openwrt.org>
 <1300910253-28189-4-git-send-email-nbd@openwrt.org>
 <1300910253-28189-5-git-send-email-nbd@openwrt.org>
 <1300910253-28189-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not used anywhere and seems pointless

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   17 -----------------
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 625ad0b..be22574 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1932,23 +1932,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
 
-	if (regulatory->current_rd_ext & (1 << REG_EXT_JAPAN_MIDBAND)) {
-		pCap->reg_cap =
-			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
-			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
-			AR_EEPROM_EEREGCAP_EN_KK_U2 |
-			AR_EEPROM_EEREGCAP_EN_KK_MIDBAND;
-	} else {
-		pCap->reg_cap =
-			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
-			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN;
-	}
-
-	/* Advertise midband for AR5416 with FCC midband set in eeprom */
-	if (regulatory->current_rd_ext & (1 << REG_EXT_FCC_MIDBAND) &&
-	    AR_SREV_5416(ah))
-		pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
-
 	if (AR_SREV_9280_20_OR_LATER(ah) && common->btcoex_enabled) {
 		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7bbf701..a255f9a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -200,7 +200,6 @@ struct ath9k_hw_capabilities {
 	u8 max_txchains;
 	u8 max_rxchains;
 	u16 tx_triglevel_max;
-	u16 reg_cap;
 	u8 num_gpio_pins;
 	u8 rx_hp_qdepth;
 	u8 rx_lp_qdepth;
-- 
1.7.3.2

