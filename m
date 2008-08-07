Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54269 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbYHGFfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:35:07 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:35:07 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18586.34523.289642.210458@localhost.localdomain> (sfid-20080807_073511_346128_DAB2DB5B)
Date: Thu, 7 Aug 2008 10:53:39 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/6] ath9k: Use mac80211's band macros and remove enum hal_freq_band
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    5 -----
 drivers/net/wireless/ath9k/hw.c    |    8 ++++----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 587c0fe..9976406 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -679,11 +679,6 @@ struct ath9k_ht_cwm {
 	enum ath9k_ht_extprotspacing ht_extprotspacing;
 };
 
-enum hal_freq_band {
-	HAL_FREQ_BAND_5GHZ = 0,
-	HAL_FREQ_BAND_2GHZ = 1,
-};
-
 enum ath9k_ani_cmd {
 	ATH9K_ANI_PRESENT = 0x1,
 	ATH9K_ANI_NOISE_IMMUNITY_LEVEL = 0x2,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index cf1800a..8c6165c 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -465,11 +465,11 @@ static void ath9k_hw_analog_shift_rmw(struct ath_hal *ah,
 }
 
 static u8 ath9k_hw_get_num_ant_config(struct ath_hal_5416 *ahp,
-					    enum hal_freq_band freq_band)
+				      enum ieee80211_band freq_band)
 {
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
 	struct modal_eep_header *pModal =
-		&(eep->modalHeader[HAL_FREQ_BAND_2GHZ == freq_band]);
+		&(eep->modalHeader[IEEE80211_BAND_5GHZ == freq_band]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
 	u8 num_ant_config;
 
@@ -3111,9 +3111,9 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
 
 	pCap->num_antcfg_5ghz =
-		ath9k_hw_get_num_ant_config(ahp, HAL_FREQ_BAND_5GHZ);
+		ath9k_hw_get_num_ant_config(ahp, IEEE80211_BAND_5GHZ);
 	pCap->num_antcfg_2ghz =
-		ath9k_hw_get_num_ant_config(ahp, HAL_FREQ_BAND_2GHZ);
+		ath9k_hw_get_num_ant_config(ahp, IEEE80211_BAND_2GHZ);
 
 	return true;
 }
-- 
1.5.6.5

