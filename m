Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35331 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbbJNWeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 18:34:15 -0400
Received: by wicll6 with SMTP id ll6so16736313wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 15:34:13 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	nbd@openwrt.org,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] ath9k: Simplify and fix eeprom endianness swapping
Date: Thu, 15 Oct 2015 00:33:32 +0200
Message-Id: <1444862012-25376-2-git-send-email-martin.blumenstingl@googlemail.com> (sfid-20151015_003422_220699_C259EB71)
In-Reply-To: <1444862012-25376-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1444862012-25376-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The three eeprom implementations had quite some duplicate code when it
came to endianness swapping.
Additionally there was a bug in eeprom_4k and eeprom_9287 which
prevented the endianness swapping from working correctly, because the
swapping code was guarded within an "if (!ath9k_hw_use_flash(ah))". In
eeprom_def this check did not exist, so it seems that eeprom_def was the
only implementation where endianness swapping worked.

This patch takes the duplicate code and moves it from eeprom_* to
eeprom.c. The new code is derived from eeprom_def, while taking into
account the specifics from the other implementations.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c      | 75 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom.h      |  3 ++
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 76 ++++++----------------------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c | 68 ++++++-------------------
 drivers/net/wireless/ath/ath9k/eeprom_def.c  | 61 ++++++----------------
 5 files changed, 124 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index cc81482..9257d77 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -138,6 +138,81 @@ bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
 	return ret;
 }
 
+int ath9k_hw_nvram_swap_data(struct ath_hw *ah, bool *swap_needed, int size)
+{
+	u16 magic;
+	u16 *eepdata;
+	int i;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		ath_err(common, "Reading Magic # failed\n");
+		return -EIO;
+	}
+
+	if (magic == AR5416_EEPROM_MAGIC) {
+		*swap_needed = false;
+	} else if (swab16(magic) == AR5416_EEPROM_MAGIC) {
+		if (ah->ah_flags & AH_NO_EEP_SWAP) {
+			ath_err(common, "EEPROM Endianness mismatch.\n");
+			return -EINVAL;
+		}
+
+		*swap_needed = true;
+	} else {
+		ath_err(common,
+			"Invalid EEPROM Magic (0x%04x).\n", magic);
+		return -EINVAL;
+	}
+
+	eepdata = (u16 *)(&ah->eeprom);
+
+	if (*swap_needed) {
+		ath_dbg(common, EEPROM,
+			"EEPROM Endianness is not native.. Changing.\n");
+
+		for (i = 0; i < size; i++)
+			eepdata[i] = swab16(eepdata[i]);
+	} else {
+		ath_dbg(common, EEPROM,
+			"EEPROM Endianness is native.. no swap required.\n");
+	}
+
+	return 0;
+}
+
+bool ath9k_hw_nvram_validate_checksum(struct ath_hw *ah, int size)
+{
+	u32 i, sum = 0;
+	u16 *eepdata = (u16 *)(&ah->eeprom);
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	for (i = 0; i < size; i++)
+		sum ^= eepdata[i];
+
+	if (sum != 0xffff) {
+		ath_err(common, "Bad EEPROM checksum 0x%x\n", sum);
+		return false;
+	}
+
+	return true;
+}
+
+bool ath9k_hw_nvram_check_version(struct ath_hw *ah, int version, int minrev)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (ah->eep_ops->get_eeprom_ver(ah) != version ||
+	    ah->eep_ops->get_eeprom_rev(ah) < minrev) {
+		ath_err(common, "Bad EEPROM VER 0x%04x or REV 0x%04x\n",
+			ah->eep_ops->get_eeprom_ver(ah),
+			ah->eep_ops->get_eeprom_rev(ah));
+		return -EINVAL;
+	}
+
+	return true;
+}
+
 void ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 			     u8 *pVpdList, u16 numIntercepts,
 			     u8 *pRetVpdList)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 40d4f62..4465c65 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -664,6 +664,9 @@ int16_t ath9k_hw_interpolate(u16 target, u16 srcLeft, u16 srcRight,
 bool ath9k_hw_get_lower_upper_index(u8 target, u8 *pList, u16 listSize,
 				    u16 *indexL, u16 *indexR);
 bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data);
+int ath9k_hw_nvram_swap_data(struct ath_hw *ah, bool *swap_needed, int size);
+bool ath9k_hw_nvram_validate_checksum(struct ath_hw *ah, int size);
+bool ath9k_hw_nvram_check_version(struct ath_hw *ah, int version, int minrev);
 void ath9k_hw_usb_gen_fill_eeprom(struct ath_hw *ah, u16 *eep_data,
 				  int eep_start_loc, int size);
 void ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 4773da6..5da0826 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -177,74 +177,30 @@ static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 }
 #endif
 
-
-#undef SIZE_EEPROM_4K
-
 static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 {
-#define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
-	u16 *eepdata, temp, magic, magic2;
-	u32 sum = 0, el;
-	bool need_swap = false;
-	int i, addr;
+	u32 el;
+	bool need_swap;
+	int i, err;
 
-
-	if (!ath9k_hw_use_flash(ah)) {
-		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
-					 &magic)) {
-			ath_err(common, "Reading Magic # failed\n");
-			return false;
-		}
-
-		ath_dbg(common, EEPROM, "Read Magic = 0x%04X\n", magic);
-
-		if (magic != AR5416_EEPROM_MAGIC) {
-			magic2 = swab16(magic);
-
-			if (magic2 == AR5416_EEPROM_MAGIC) {
-				need_swap = true;
-				eepdata = (u16 *) (&ah->eeprom);
-
-				for (addr = 0; addr < EEPROM_4K_SIZE; addr++) {
-					temp = swab16(*eepdata);
-					*eepdata = temp;
-					eepdata++;
-				}
-			} else {
-				ath_err(common,
-					"Invalid EEPROM Magic. Endianness mismatch.\n");
-				return -EINVAL;
-			}
-		}
-	}
-
-	ath_dbg(common, EEPROM, "need_swap = %s\n",
-		need_swap ? "True" : "False");
+	err = ath9k_hw_nvram_swap_data(ah, &need_swap, SIZE_EEPROM_4K);
+	if (err)
+		return err;
 
 	if (need_swap)
-		el = swab16(ah->eeprom.map4k.baseEepHeader.length);
-	else
-		el = ah->eeprom.map4k.baseEepHeader.length;
-
-	if (el > sizeof(struct ar5416_eeprom_4k))
-		el = sizeof(struct ar5416_eeprom_4k) / sizeof(u16);
+		el = swab16(eep->baseEepHeader.length);
 	else
-		el = el / sizeof(u16);
+		el = eep->baseEepHeader.length;
 
-	eepdata = (u16 *)(&ah->eeprom);
-
-	for (i = 0; i < el; i++)
-		sum ^= *eepdata++;
+	el = min(el / sizeof(u16), SIZE_EEPROM_4K);
+	if (!ath9k_hw_nvram_validate_checksum(ah, el))
+		return -EINVAL;
 
 	if (need_swap) {
 		u32 integer;
 		u16 word;
 
-		ath_dbg(common, EEPROM,
-			"EEPROM Endianness is not native.. Changing\n");
-
 		word = swab16(eep->baseEepHeader.length);
 		eep->baseEepHeader.length = word;
 
@@ -283,17 +239,15 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
-	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		ath_err(common, "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ah->eep_ops->get_eeprom_ver(ah));
+	if (!ath9k_hw_nvram_check_version(ah, AR5416_EEP_VER,
+	    AR5416_EEP_NO_BACK_VER))
 		return -EINVAL;
-	}
 
 	return 0;
-#undef EEPROM_4K_SIZE
 }
 
+#undef SIZE_EEPROM_4K
+
 static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 				  enum eeprom_param param)
 {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 6ca33df..1a019a3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -177,59 +177,24 @@ static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 
 static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 {
-	u32 sum = 0, el, integer;
-	u16 temp, word, magic, magic2, *eepdata;
-	int i, addr;
-	bool need_swap = false;
+	u32 el, integer;
+	u16 word;
+	int i, err;
+	bool need_swap;
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (!ath9k_hw_use_flash(ah)) {
-		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
-					 &magic)) {
-			ath_err(common, "Reading Magic # failed\n");
-			return false;
-		}
-
-		ath_dbg(common, EEPROM, "Read Magic = 0x%04X\n", magic);
-
-		if (magic != AR5416_EEPROM_MAGIC) {
-			magic2 = swab16(magic);
-
-			if (magic2 == AR5416_EEPROM_MAGIC) {
-				need_swap = true;
-				eepdata = (u16 *)(&ah->eeprom);
-
-				for (addr = 0; addr < SIZE_EEPROM_AR9287; addr++) {
-					temp = swab16(*eepdata);
-					*eepdata = temp;
-					eepdata++;
-				}
-			} else {
-				ath_err(common,
-					"Invalid EEPROM Magic. Endianness mismatch.\n");
-				return -EINVAL;
-			}
-		}
-	}
 
-	ath_dbg(common, EEPROM, "need_swap = %s\n",
-		need_swap ? "True" : "False");
+	err = ath9k_hw_nvram_swap_data(ah, &need_swap, SIZE_EEPROM_AR9287);
+	if (err)
+		return err;
 
 	if (need_swap)
-		el = swab16(ah->eeprom.map9287.baseEepHeader.length);
-	else
-		el = ah->eeprom.map9287.baseEepHeader.length;
-
-	if (el > sizeof(struct ar9287_eeprom))
-		el = sizeof(struct ar9287_eeprom) / sizeof(u16);
+		el = swab16(eep->baseEepHeader.length);
 	else
-		el = el / sizeof(u16);
-
-	eepdata = (u16 *)(&ah->eeprom);
+		el = eep->baseEepHeader.length;
 
-	for (i = 0; i < el; i++)
-		sum ^= *eepdata++;
+	el = min(el / sizeof(u16), SIZE_EEPROM_AR9287);
+	if (!ath9k_hw_nvram_validate_checksum(ah, el))
+		return -EINVAL;
 
 	if (need_swap) {
 		word = swab16(eep->baseEepHeader.length);
@@ -270,16 +235,15 @@ static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR9287_EEP_VER
-	    || ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		ath_err(common, "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ah->eep_ops->get_eeprom_ver(ah));
+	if (!ath9k_hw_nvram_check_version(ah, AR9287_EEP_VER,
+	    AR5416_EEP_NO_BACK_VER))
 		return -EINVAL;
-	}
 
 	return 0;
 }
 
+#undef SIZE_EEPROM_AR9287
+
 static u32 ath9k_hw_ar9287_get_eeprom(struct ath_hw *ah,
 				      enum eeprom_param param)
 {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 056f516..959682f 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -126,8 +126,6 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_def_fill_eeprom(ah);
 }
 
-#undef SIZE_EEPROM_DEF
-
 #if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
 static u32 ath9k_def_dump_modal_eeprom(char *buf, u32 len, u32 size,
 				       struct modal_eep_header *modal_hdr)
@@ -257,59 +255,31 @@ static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 }
 #endif
 
-
 static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 {
 	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u16 *eepdata, temp, magic;
-	u32 sum = 0, el;
-	bool need_swap = false;
-	int i, addr, size;
-
-	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
-		ath_err(common, "Reading Magic # failed\n");
-		return false;
-	}
-
-	if (swab16(magic) == AR5416_EEPROM_MAGIC &&
-	    !(ah->ah_flags & AH_NO_EEP_SWAP)) {
-		size = sizeof(struct ar5416_eeprom_def);
-		need_swap = true;
-		eepdata = (u16 *) (&ah->eeprom);
-
-		for (addr = 0; addr < size / sizeof(u16); addr++) {
-			temp = swab16(*eepdata);
-			*eepdata = temp;
-			eepdata++;
-		}
-	}
+	u32 el;
+	bool need_swap;
+	int i, err;
 
-	ath_dbg(common, EEPROM, "need_swap = %s\n",
-		need_swap ? "True" : "False");
+	err = ath9k_hw_nvram_swap_data(ah, &need_swap, SIZE_EEPROM_DEF);
+	if (err)
+		return err;
 
 	if (need_swap)
-		el = swab16(ah->eeprom.def.baseEepHeader.length);
+		el = swab16(eep->baseEepHeader.length);
 	else
-		el = ah->eeprom.def.baseEepHeader.length;
+		el = eep->baseEepHeader.length;
 
-	if (el > sizeof(struct ar5416_eeprom_def))
-		el = sizeof(struct ar5416_eeprom_def) / sizeof(u16);
-	else
-		el = el / sizeof(u16);
-
-	eepdata = (u16 *)(&ah->eeprom);
-
-	for (i = 0; i < el; i++)
-		sum ^= *eepdata++;
+	el = min(el / sizeof(u16), SIZE_EEPROM_DEF);
+	if (!ath9k_hw_nvram_validate_checksum(ah, el))
+		return -EINVAL;
 
 	if (need_swap) {
 		u32 integer, j;
 		u16 word;
 
-		ath_dbg(common, EEPROM,
-			"EEPROM Endianness is not native.. Changing.\n");
-
 		word = swab16(eep->baseEepHeader.length);
 		eep->baseEepHeader.length = word;
 
@@ -356,12 +326,9 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
-	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		ath_err(common, "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ah->eep_ops->get_eeprom_ver(ah));
+	if (!ath9k_hw_nvram_check_version(ah, AR5416_EEP_VER,
+	    AR5416_EEP_NO_BACK_VER))
 		return -EINVAL;
-	}
 
 	/* Enable fixup for AR_AN_TOP2 if necessary */
 	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
@@ -376,6 +343,8 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	return 0;
 }
 
+#undef SIZE_EEPROM_DEF
+
 static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 				   enum eeprom_param param)
 {
-- 
2.6.1

