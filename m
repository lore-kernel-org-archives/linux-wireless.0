Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40312 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1ADHrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 02:47:52 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so14032331iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 23:47:51 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19746.53392.798796.493571@gargle.gargle.HOWL>
Date: Tue, 4 Jan 2011 13:17:28 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 5/5] ath9k_hw: Offload USB eeprom reading to target
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

For USB devices, reading the EEPROM data can be offloaded
to the target. Use multiple register reads to take advantage
of this feature to reduce initialization time.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c      |   32 ++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom.h      |    2 +
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   41 +++++++++++++++++------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   45 +++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   32 ++++++++++++++++--
 5 files changed, 123 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index d051631..8c18bed 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -89,6 +89,38 @@ bool ath9k_hw_get_lower_upper_index(u8 target, u8 *pList, u16 listSize,
 	return false;
 }
 
+void ath9k_hw_usb_gen_fill_eeprom(struct ath_hw *ah, u16 *eep_data,
+				  int eep_start_loc, int size)
+{
+	int i = 0, j, addr;
+	u32 addrdata[8];
+	u32 data[8];
+
+	for (addr = 0; addr < size; addr++) {
+		addrdata[i] = AR5416_EEPROM_OFFSET +
+			((addr + eep_start_loc) << AR5416_EEPROM_S);
+		i++;
+		if (i == 8) {
+			REG_READ_MULTI(ah, addrdata, data, i);
+
+			for (j = 0; j < i; j++) {
+				*eep_data = data[j];
+				eep_data++;
+			}
+			i = 0;
+		}
+	}
+
+	if (i != 0) {
+		REG_READ_MULTI(ah, addrdata, data, i);
+
+		for (j = 0; j < i; j++) {
+			*eep_data = data[j];
+			eep_data++;
+		}
+	}
+}
+
 bool ath9k_hw_nvram_read(struct ath_common *common, u32 off, u16 *data)
 {
 	return common->bus_ops->eeprom_read(common, off, data);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 58e2ddc..bd82447 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -665,6 +665,8 @@ int16_t ath9k_hw_interpolate(u16 target, u16 srcLeft, u16 srcRight,
 bool ath9k_hw_get_lower_upper_index(u8 target, u8 *pList, u16 listSize,
 				    u16 *indexL, u16 *indexR);
 bool ath9k_hw_nvram_read(struct ath_common *common, u32 off, u16 *data);
+void ath9k_hw_usb_gen_fill_eeprom(struct ath_hw *ah, u16 *eep_data,
+				  int eep_start_loc, int size);
 void ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 			     u8 *pVpdList, u16 numIntercepts,
 			     u8 *pRetVpdList);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index fbdff7e..bc77a30 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -27,19 +27,13 @@ static int ath9k_hw_4k_get_eeprom_rev(struct ath_hw *ah)
 	return ((ah->eeprom.map4k.baseEepHeader.version) & 0xFFF);
 }
 
-static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
-{
 #define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
+
+static bool __ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
+{
 	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eep_data = (u16 *)&ah->eeprom.map4k;
-	int addr, eep_start_loc = 0;
-
-	eep_start_loc = 64;
-
-	if (!ath9k_hw_use_flash(ah)) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
-	}
+	int addr, eep_start_loc = 64;
 
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
 		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc, eep_data)) {
@@ -51,9 +45,34 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 	}
 
 	return true;
-#undef SIZE_EEPROM_4K
 }
 
+static bool __ath9k_hw_usb_4k_fill_eeprom(struct ath_hw *ah)
+{
+	u16 *eep_data = (u16 *)&ah->eeprom.map4k;
+
+	ath9k_hw_usb_gen_fill_eeprom(ah, eep_data, 64, SIZE_EEPROM_4K);
+
+	return true;
+}
+
+static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!ath9k_hw_use_flash(ah)) {
+		ath_dbg(common, ATH_DBG_EEPROM,
+			"Reading from EEPROM, not flash\n");
+	}
+
+	if (common->bus_ops->ath_bus_type == ATH_USB)
+		return __ath9k_hw_usb_4k_fill_eeprom(ah);
+	else
+		return __ath9k_hw_4k_fill_eeprom(ah);
+}
+
+#undef SIZE_EEPROM_4K
+
 static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 {
 #define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 9b6bc8a..8cd8333 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -17,7 +17,7 @@
 #include "hw.h"
 #include "ar9002_phy.h"
 
-#define NUM_EEP_WORDS (sizeof(struct ar9287_eeprom) / sizeof(u16))
+#define SIZE_EEPROM_AR9287 (sizeof(struct ar9287_eeprom) / sizeof(u16))
 
 static int ath9k_hw_ar9287_get_eeprom_ver(struct ath_hw *ah)
 {
@@ -29,25 +29,15 @@ static int ath9k_hw_ar9287_get_eeprom_rev(struct ath_hw *ah)
 	return (ah->eeprom.map9287.baseEepHeader.version) & 0xFFF;
 }
 
-static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
+static bool __ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eep_data;
-	int addr, eep_start_loc;
+	int addr, eep_start_loc = AR9287_EEP_START_LOC;
 	eep_data = (u16 *)eep;
 
-	if (common->bus_ops->ath_bus_type == ATH_USB)
-		eep_start_loc = AR9287_HTC_EEP_START_LOC;
-	else
-		eep_start_loc = AR9287_EEP_START_LOC;
-
-	if (!ath9k_hw_use_flash(ah)) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
-	}
-
-	for (addr = 0; addr < NUM_EEP_WORDS; addr++) {
+	for (addr = 0; addr < SIZE_EEPROM_AR9287; addr++) {
 		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc,
 					 eep_data)) {
 			ath_dbg(common, ATH_DBG_EEPROM,
@@ -60,6 +50,31 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 	return true;
 }
 
+static bool __ath9k_hw_usb_ar9287_fill_eeprom(struct ath_hw *ah)
+{
+	u16 *eep_data = (u16 *)&ah->eeprom.map9287;
+
+	ath9k_hw_usb_gen_fill_eeprom(ah, eep_data,
+				     AR9287_HTC_EEP_START_LOC,
+				     SIZE_EEPROM_AR9287);
+	return true;
+}
+
+static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!ath9k_hw_use_flash(ah)) {
+		ath_dbg(common, ATH_DBG_EEPROM,
+			"Reading from EEPROM, not flash\n");
+	}
+
+	if (common->bus_ops->ath_bus_type == ATH_USB)
+		return __ath9k_hw_usb_ar9287_fill_eeprom(ah);
+	else
+		return __ath9k_hw_ar9287_fill_eeprom(ah);
+}
+
 static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 {
 	u32 sum = 0, el, integer;
@@ -86,7 +101,7 @@ static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 				need_swap = true;
 				eepdata = (u16 *)(&ah->eeprom);
 
-				for (addr = 0; addr < NUM_EEP_WORDS; addr++) {
+				for (addr = 0; addr < SIZE_EEPROM_AR9287; addr++) {
 					temp = swab16(*eepdata);
 					*eepdata = temp;
 					eepdata++;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 749a936..c9318ff 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -86,9 +86,10 @@ static int ath9k_hw_def_get_eeprom_rev(struct ath_hw *ah)
 	return ((ah->eeprom.def.baseEepHeader.version) & 0xFFF);
 }
 
-static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
-{
 #define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
+
+static bool __ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
+{
 	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eep_data = (u16 *)&ah->eeprom.def;
 	int addr, ar5416_eep_start_loc = 0x100;
@@ -103,9 +104,34 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 		eep_data++;
 	}
 	return true;
-#undef SIZE_EEPROM_DEF
 }
 
+static bool __ath9k_hw_usb_def_fill_eeprom(struct ath_hw *ah)
+{
+	u16 *eep_data = (u16 *)&ah->eeprom.def;
+
+	ath9k_hw_usb_gen_fill_eeprom(ah, eep_data,
+				     0x100, SIZE_EEPROM_DEF);
+	return true;
+}
+
+static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!ath9k_hw_use_flash(ah)) {
+		ath_dbg(common, ATH_DBG_EEPROM,
+			"Reading from EEPROM, not flash\n");
+	}
+
+	if (common->bus_ops->ath_bus_type == ATH_USB)
+		return __ath9k_hw_usb_def_fill_eeprom(ah);
+	else
+		return __ath9k_hw_def_fill_eeprom(ah);
+}
+
+#undef SIZE_EEPROM_DEF
+
 static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 {
 	struct ar5416_eeprom_def *eep =
-- 
1.7.3.4

