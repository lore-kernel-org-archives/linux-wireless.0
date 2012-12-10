Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37511 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2LJOav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 09:30:51 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/4] ath9k: move duplicated debug message to 'ath9k_hw_nvram_read'
Date: Mon, 10 Dec 2012 15:30:25 +0100
Message-Id: <1355149828-7394-1-git-send-email-juhosg@openwrt.org> (sfid-20121210_153054_727692_491C5BFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fill_eeprom functions are printing the same
debug message in case the 'ath9k_hw_nvram_read'
function fails. Remove the duplicated code from
fill_eeprom functions and add the ath_dbg call
directly into 'ath9k_hw_nvram_read'.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c      |    8 +++++++-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    6 ++----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    5 +----
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    5 +----
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 0512397..4b6a935 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -115,7 +115,13 @@ void ath9k_hw_usb_gen_fill_eeprom(struct ath_hw *ah, u16 *eep_data,
 
 bool ath9k_hw_nvram_read(struct ath_common *common, u32 off, u16 *data)
 {
-	return common->bus_ops->eeprom_read(common, off, data);
+	bool ret;
+
+	ret = common->bus_ops->eeprom_read(common, off, data);
+	if (!ret)
+		ath_dbg(common, EEPROM, "Unable to read eeprom region\n");
+
+	return ret;
 }
 
 void ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 7d07510..17c843d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -37,11 +37,9 @@ static bool __ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 	int addr, eep_start_loc = 64;
 
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
-		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc, eep_data)) {
-			ath_dbg(common, EEPROM,
-				"Unable to read eeprom region\n");
+		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc,
+					 eep_data))
 			return false;
-		}
 		eep_data++;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index cd742fb..f2c32bc 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -40,11 +40,8 @@ static bool __ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 
 	for (addr = 0; addr < SIZE_EEPROM_AR9287; addr++) {
 		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc,
-					 eep_data)) {
-			ath_dbg(common, EEPROM,
-				"Unable to read eeprom region\n");
+					 eep_data))
 			return false;
-		}
 		eep_data++;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index a8ac30a..2654f74 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -97,11 +97,8 @@ static bool __ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 
 	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
 		if (!ath9k_hw_nvram_read(common, addr + ar5416_eep_start_loc,
-					 eep_data)) {
-			ath_err(ath9k_hw_common(ah),
-				"Unable to read eeprom region\n");
+					 eep_data))
 			return false;
-		}
 		eep_data++;
 	}
 	return true;
-- 
1.7.10

