Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21536 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0IBIet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 04:34:49 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 01:34:44 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k_hw: Add capability flag for Antenna diversity and combining feature
Date: Thu, 2 Sep 2010 01:34:41 -0700
Message-ID: <1283416483-5674-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is enabled only for ar9285.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h    |    2 ++
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |    4 ++++
 drivers/net/wireless/ath/ath9k/hw.c        |    9 +++++++++
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 0b09db0..3216b70 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -266,6 +266,8 @@ enum eeprom_param {
 	EEP_INTERNAL_REGULATOR,
 	EEP_SWREG,
 	EEP_PAPRD,
+	EEP_MODAL_VER,
+	EEP_ANT_DIV_CTL1,
 };
 
 enum ar5416_rates {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 9cccd12..2e1397b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -213,6 +213,10 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 		return 0;
 	case EEP_PWR_TABLE_OFFSET:
 		return AR5416_PWR_TABLE_OFFSET_DB;
+	case EEP_MODAL_VER:
+		return pModal->version;
+	case EEP_ANT_DIV_CTL1:
+		return pModal->antdiv_ctl1;
 	default:
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3384ca1..68940a8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2056,6 +2056,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	u16 capField = 0, eeval;
+	u8 ant_div_ctl1;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
 	regulatory->current_rd = eeval;
@@ -2280,6 +2281,14 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (AR_SREV_9287_10_OR_LATER(ah) || AR_SREV_9271(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_SGI_20;
 
+	if (AR_SREV_9285(ah))
+		if (ah->eep_ops->get_eeprom(ah, EEP_MODAL_VER) >= 3) {
+			ant_div_ctl1 =
+				ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
+			if ((ant_div_ctl1 & 0x1) && ((ant_div_ctl1 >> 3) & 0x1))
+				pCap->hw_caps |= ATH9K_HW_CAP_ANT_DIV_COMB;
+		}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1601dd4..1a0efbd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -204,6 +204,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_FASTCLOCK			= BIT(20),
 	ATH9K_HW_CAP_SGI_20			= BIT(21),
 	ATH9K_HW_CAP_PAPRD			= BIT(22),
+	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(23),
 };
 
 struct ath9k_hw_capabilities {
-- 
1.7.0.4

