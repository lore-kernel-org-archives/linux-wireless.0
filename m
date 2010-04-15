Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab0DOVjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 45/97] ath9k_hw: the eep_map is used only for AR9280 PCI card ini fixup
Date: Thu, 15 Apr 2010 17:38:50 -0400
Message-Id: <1271367582-992-46-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

We can reorganize the code in such a way that eep_map can be removed,
which makes the code more clearer.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |    3 ---
 drivers/net/wireless/ath/ath9k/eeprom.h |    7 -------
 drivers/net/wireless/ath/ath9k/hw.c     |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h     |    1 -
 4 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index dacaae9..1a48f43 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -257,13 +257,10 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah)
 	int status;
 
 	if (AR_SREV_9287(ah)) {
-		ah->eep_map = EEP_MAP_AR9287;
 		ah->eep_ops = &eep_AR9287_ops;
 	} else if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
-		ah->eep_map = EEP_MAP_4KBITS;
 		ah->eep_ops = &eep_4k_ops;
 	} else {
-		ah->eep_map = EEP_MAP_DEFAULT;
 		ah->eep_ops = &eep_def_ops;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 2f2993b..e087e2d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -656,13 +656,6 @@ struct ath9k_country_entry {
 	u8 iso[3];
 };
 
-enum ath9k_eep_map {
-	EEP_MAP_DEFAULT = 0x0,
-	EEP_MAP_4KBITS,
-	EEP_MAP_AR9287,
-	EEP_MAP_MAX
-};
-
 struct eeprom_ops {
 	int (*check_eeprom)(struct ath_hw *hw);
 	u32 (*get_eeprom)(struct ath_hw *hw, enum eeprom_param param);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2dcfaa9..ec48e7b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -947,7 +947,7 @@ static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	ah->need_an_top2_fixup = (ah->hw_version.devid == AR9280_DEVID_PCI) &&
-				 (ah->eep_map != EEP_MAP_4KBITS) &&
+				 !AR_SREV_9285(ah) && !AR_SREV_9271(ah) &&
 				 ((pBase->version & 0xff) > 0x0a) &&
 				 (pBase->pwdclkind == 0);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7889ecb..48fb5ce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -548,7 +548,6 @@ struct ath_hw {
 		struct ar9287_eeprom map9287;
 	} eeprom;
 	const struct eeprom_ops *eep_ops;
-	enum ath9k_eep_map eep_map;
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
-- 
1.6.3.3

