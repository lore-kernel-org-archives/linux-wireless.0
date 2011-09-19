Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:32819 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab1ISRim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 13:38:42 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 4/4] ath9k_hw: remove EEP_REG_1
Date: Mon, 19 Sep 2011 19:38:23 +0200
Message-Id: <1316453903-75710-4-git-send-email-nbd@openwrt.org> (sfid-20110919_193850_934385_8DEEF030)
In-Reply-To: <1316453903-75710-3-git-send-email-nbd@openwrt.org>
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org>
 <1316453903-75710-2-git-send-email-nbd@openwrt.org>
 <1316453903-75710-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was previously used for current_rd_ext

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 --
 drivers/net/wireless/ath/ath9k/eeprom.h        |    1 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    2 --
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    2 --
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    2 --
 5 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d7a5ca7..bf08acc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2995,8 +2995,6 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 		return get_unaligned_be16(eep->macAddr + 4);
 	case EEP_REG_0:
 		return le16_to_cpu(pBase->regDmn[0]);
-	case EEP_REG_1:
-		return le16_to_cpu(pBase->regDmn[1]);
 	case EEP_OP_CAP:
 		return pBase->deviceCap;
 	case EEP_OP_MODE:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 085d3ba..291489b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -225,7 +225,6 @@ enum eeprom_param {
 	EEP_MAC_MID,
 	EEP_MAC_LSW,
 	EEP_REG_0,
-	EEP_REG_1,
 	EEP_OP_CAP,
 	EEP_OP_MODE,
 	EEP_RF_SILENT,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index ab6811d..9a7520f 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -322,8 +322,6 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 		return get_unaligned_be16(pBase->macAddr + 4);
 	case EEP_REG_0:
 		return pBase->regDmn[0];
-	case EEP_REG_1:
-		return pBase->regDmn[1];
 	case EEP_OP_CAP:
 		return pBase->deviceCap;
 	case EEP_OP_MODE:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 90d771f..4f5c50a 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -308,8 +308,6 @@ static u32 ath9k_hw_ar9287_get_eeprom(struct ath_hw *ah,
 		return get_unaligned_be16(pBase->macAddr + 4);
 	case EEP_REG_0:
 		return pBase->regDmn[0];
-	case EEP_REG_1:
-		return pBase->regDmn[1];
 	case EEP_OP_CAP:
 		return pBase->deviceCap;
 	case EEP_OP_MODE:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index e175e20..81e6296 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -415,8 +415,6 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 		return get_unaligned_be16(pBase->macAddr + 4);
 	case EEP_REG_0:
 		return pBase->regDmn[0];
-	case EEP_REG_1:
-		return pBase->regDmn[1];
 	case EEP_OP_CAP:
 		return pBase->deviceCap;
 	case EEP_OP_MODE:
-- 
1.7.3.2

