Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46130 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0GKKs6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:48:58 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 1/7] ath9k_hw: fix antenna diversity on AR9285
Date: Sun, 11 Jul 2010 12:48:39 +0200
Message-Id: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR9285, the antenna switch configuration register uses more than just
16 bits. Because of an arbitrary mask applied to the EEPROM value that
stores this configuration, diversity was broken in some cases, leading
to a significant degradation in signal strength.
Fix this by changing the callback to return a 32 bit value and remove
the arbitrary mask.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 343c9a4..ace8d26 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -951,7 +951,7 @@ static u8 ath9k_hw_ar9300_get_num_ant_config(struct ath_hw *ah,
 	return 1;
 }
 
-static u16 ath9k_hw_ar9300_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u32 ath9k_hw_ar9300_get_eeprom_antenna_cfg(struct ath_hw *ah,
 						  struct ath9k_channel *chan)
 {
 	return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index bdd8aa0..8750c55 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -670,7 +670,7 @@ struct eeprom_ops {
 	int (*get_eeprom_ver)(struct ath_hw *hw);
 	int (*get_eeprom_rev)(struct ath_hw *hw);
 	u8 (*get_num_ant_config)(struct ath_hw *hw, enum ieee80211_band band);
-	u16 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
+	u32 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
 				      struct ath9k_channel *chan);
 	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
 	void (*set_addac)(struct ath_hw *hw, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index e25a2ab..afafc4d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1150,13 +1150,13 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	}
 }
 
-static u16 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u32 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
 					      struct ath9k_channel *chan)
 {
 	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 
-	return pModal->antCtrlCommon & 0xFFFF;
+	return pModal->antCtrlCommon;
 }
 
 static u8 ath9k_hw_4k_get_num_ant_config(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 39a4105..37207df 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1130,13 +1130,13 @@ static u8 ath9k_hw_ar9287_get_num_ant_config(struct ath_hw *ah,
 	return 1;
 }
 
-static u16 ath9k_hw_ar9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u32 ath9k_hw_ar9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
 						  struct ath9k_channel *chan)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
 
-	return pModal->antCtrlCommon & 0xFFFF;
+	return pModal->antCtrlCommon;
 }
 
 static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 77b1433..60480a1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1438,14 +1438,14 @@ static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
 	return num_ant_config;
 }
 
-static u16 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u32 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
 					       struct ath9k_channel *chan)
 {
 	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 
-	return pModal->antCtrlCommon & 0xFFFF;
+	return pModal->antCtrlCommon;
 }
 
 static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
-- 
1.6.4.2

