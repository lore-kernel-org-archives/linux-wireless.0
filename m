Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36956 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab1G0NBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 09:01:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/4] ath9k_hw: fix calculated runtime tx power limit
Date: Wed, 27 Jul 2011 15:01:04 +0200
Message-Id: <1311771665-59853-3-git-send-email-nbd@openwrt.org> (sfid-20110727_150124_768957_2E9D9793)
In-Reply-To: <1311771665-59853-2-git-send-email-nbd@openwrt.org>
References: <1311771665-59853-1-git-send-email-nbd@openwrt.org>
 <1311771665-59853-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the previously calculated maximum of all rates instead of just the one
from the lowest rate of the selected PHY mode.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   20 +-------------------
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    9 ---------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    7 -------
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   11 -----------
 4 files changed, 1 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d109c25..184abb6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4922,25 +4922,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 			"TPC[%02d] 0x%08x\n", i, targetPowerValT2[i]);
 	}
 
-	/*
-	 * This is the TX power we send back to driver core,
-	 * and it can use to pass to userspace to display our
-	 * currently configured TX power setting.
-	 *
-	 * Since power is rate dependent, use one of the indices
-	 * from the AR9300_Rates enum to select an entry from
-	 * targetPowerValT2[] to report. Currently returns the
-	 * power for HT40 MCS 0, HT20 MCS 0, or OFDM 6 Mbps
-	 * as CCK power is less interesting (?).
-	 */
-	i = ALL_TARGET_LEGACY_6_24; /* legacy */
-	if (IS_CHAN_HT40(chan))
-		i = ALL_TARGET_HT40_0_8_16; /* ht40 */
-	else if (IS_CHAN_HT20(chan))
-		i = ALL_TARGET_HT20_0_8_16; /* ht20 */
-
-	ah->txpower_limit = targetPowerValT2[i];
-	regulatory->max_power_level = targetPowerValT2[i];
+	ah->txpower_limit = regulatory->max_power_level;
 
 	/* Write target power array to registers */
 	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index bf64d67..abf40d3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -607,15 +607,6 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	if (test)
 	    return;
 
-	/* Update regulatory */
-	i = rate6mb;
-	if (IS_CHAN_HT40(chan))
-		i = rateHt40_0;
-	else if (IS_CHAN_HT20(chan))
-		i = rateHt20_0;
-
-	regulatory->max_power_level = ratesArray[i];
-
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
 			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET_DB * 2;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index a65d2a5..604312c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -746,13 +746,6 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	if (test)
 		return;
 
-	if (IS_CHAN_2GHZ(chan))
-		i = rate1l;
-	else
-		i = rate6mb;
-
-	regulatory->max_power_level = ratesArray[i];
-
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
 			ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index b665837..85057e0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1167,17 +1167,6 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 			regulatory->max_power_level = ratesArray[i];
 	}
 
-	if (!test) {
-		i = rate6mb;
-
-		if (IS_CHAN_HT40(chan))
-			i = rateHt40_0;
-		else if (IS_CHAN_HT20(chan))
-			i = rateHt20_0;
-
-		regulatory->max_power_level = ratesArray[i];
-	}
-
 	switch(ar5416_get_ntxchains(ah->txchainmask)) {
 	case 1:
 		break;
-- 
1.7.3.2

