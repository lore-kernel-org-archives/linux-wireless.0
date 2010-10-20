Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58171 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0JTAJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 20:09:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k_hw: initialize regulatory->max_power_level in set_txpower for AR9003
Date: Wed, 20 Oct 2010 02:09:44 +0200
Message-Id: <1287533386-68715-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same is done for the older chip families as well.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c418235..92cfef2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2133,6 +2133,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					u8 twiceMaxRegulatoryPower,
 					u8 powerLimit)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
 	u8 targetPowerValT2[ar9300RateSize];
 	unsigned int i = 0;
@@ -2180,6 +2181,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 		i = ALL_TARGET_HT20_0_8_16; /* ht20 */
 
 	ah->txpower_limit = targetPowerValT2[i];
+	regulatory->max_power_level = ratesArray[i];
 
 	ar9003_hw_calibration_apply(ah, chan->channel);
 }
-- 
1.7.2.2

