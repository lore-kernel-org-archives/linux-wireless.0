Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23966 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYLHOOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 09:14:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 06:14:17 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 4/5] ath9k: Incorrect band enum causes invalid antenna configuration.
Date: Mon, 8 Dec 2008 19:43:49 +0530
Message-ID: <1228745630-6928-4-git-send-email-senthilkumar@atheros.com> (sfid-20081208_151420_843959_91AEEFDF)
In-Reply-To: <1228745630-6928-3-git-send-email-senthilkumar@atheros.com>
References: <1228745630-6928-1-git-send-email-senthilkumar@atheros.com>
 <1228745630-6928-2-git-send-email-senthilkumar@atheros.com>
 <1228745630-6928-3-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's a regression from the patch titled "ath9k: Use mac80211's band
macros and remove enum hal_freq_band". MAC80211 band macros can't be
mapped directly with our hal band enum.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    2 +-
 drivers/net/wireless/ath9k/hw.c     |    4 ++--
 drivers/net/wireless/ath9k/hw.h     |    5 +++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index d4e51dd..14f8d40 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -2631,7 +2631,7 @@ u8 ath9k_hw_get_def_num_ant_config(struct ath_hal *ah,
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	struct modal_eep_header *pModal =
-		&(eep->modalHeader[IEEE80211_BAND_5GHZ == freq_band]);
+		&(eep->modalHeader[ATH9K_HAL_FREQ_BAND_2GHZ == freq_band]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
 	u8 num_ant_config;
 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index d7a2c20..92cda20 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3388,9 +3388,9 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
 
 	pCap->num_antcfg_5ghz =
-		ath9k_hw_get_num_ant_config(ah, IEEE80211_BAND_5GHZ);
+		ath9k_hw_get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_5GHZ);
 	pCap->num_antcfg_2ghz =
-		ath9k_hw_get_num_ant_config(ah, IEEE80211_BAND_2GHZ);
+		ath9k_hw_get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
 	return true;
 }
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index a4d5285..91d8f59 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -495,6 +495,11 @@ enum ar5416_rates {
 	Ar5416RateSize
 };
 
+enum ath9k_hal_freq_band {
+	ATH9K_HAL_FREQ_BAND_5GHZ = 0,
+	ATH9K_HAL_FREQ_BAND_2GHZ = 1
+};
+
 struct base_eep_header {
 	u16 length;
 	u16 checksum;
-- 
1.6.0.4

