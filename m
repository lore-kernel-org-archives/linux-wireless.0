Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19654 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0IPGI7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 02:08:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 23:08:53 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_hw: remove warning in ath9k_hw_def_get_num_ant_config
Date: Thu, 16 Sep 2010 11:40:06 +0530
Message-ID: <1284617406-8285-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes following warning

drivers/net/wireless/ath/ath9k/eeprom_def.c: In function 'ath9k_hw_def_get_num_ant_config'
drivers/net/wireless/ath/ath9k/eeprom_def.c:1425:47: warning: comparison
			between 'enum ath9k_hal_freq_band' and 'enum ieee80211_band'

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    3 ++-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    4 ++--
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 057fb69..c418235 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -968,7 +968,7 @@ static int ath9k_hw_ar9300_get_eeprom_rev(struct ath_hw *ah)
 }
 
 static u8 ath9k_hw_ar9300_get_num_ant_config(struct ath_hw *ah,
-					     enum ieee80211_band freq_band)
+					     enum ath9k_hal_freq_band freq_band)
 {
 	return 1;
 }
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 3216b70..3030564 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -672,7 +672,8 @@ struct eeprom_ops {
 	bool (*fill_eeprom)(struct ath_hw *hw);
 	int (*get_eeprom_ver)(struct ath_hw *hw);
 	int (*get_eeprom_rev)(struct ath_hw *hw);
-	u8 (*get_num_ant_config)(struct ath_hw *hw, enum ieee80211_band band);
+	u8 (*get_num_ant_config)(struct ath_hw *hw,
+				 enum ath9k_hal_freq_band band);
 	u32 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
 				      struct ath9k_channel *chan);
 	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 2e1397b..ead8b0d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1161,7 +1161,7 @@ static u32 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
 }
 
 static u8 ath9k_hw_4k_get_num_ant_config(struct ath_hw *ah,
-					 enum ieee80211_band freq_band)
+					 enum ath9k_hal_freq_band freq_band)
 {
 	return 1;
 }
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index dff2da7..e618651 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1126,7 +1126,7 @@ static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 }
 
 static u8 ath9k_hw_ar9287_get_num_ant_config(struct ath_hw *ah,
-					     enum ieee80211_band freq_band)
+					     enum ath9k_hal_freq_band freq_band)
 {
 	return 1;
 }
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index afa2b73..23f480d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1418,11 +1418,11 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 }
 
 static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
-					  enum ieee80211_band freq_band)
+					  enum ath9k_hal_freq_band freq_band)
 {
 	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
-		&(eep->modalHeader[ATH9K_HAL_FREQ_BAND_2GHZ == freq_band]);
+		&(eep->modalHeader[freq_band]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
 	u8 num_ant_config;
 
-- 
1.7.2.3

