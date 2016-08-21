Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35689 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753148AbcHUOtb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 10:49:31 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        chunkeey@googlemail.com, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4/5] ath9k: Make the EEPROM swapping check use the eepmisc register
Date: Sun, 21 Aug 2016 16:49:05 +0200
Message-Id: <20160821144906.30984-5-martin.blumenstingl@googlemail.com> (sfid-20160821_164937_593400_9E3DC529)
In-Reply-To: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two ways of swapping the EEPROM data in the ath9k driver:
1) swab16 based on the first two EEPROM "magic" bytes (same for all
   EEPROM formats)
2) field and EEPROM format specific swab16/swab32 (different for
   eeprom_def, eeprom_4k and eeprom_9287)

The result of the first check was used to also enable the second swap.
This behavior seems incorrect, since the data may only be byte-swapped
(afterwards the data could be in the correct endianness).
Thus we introduce a separate check based on the "eepmisc" register
(which is part of the EEPROM data). When bit 0 is set, then the EEPROM
format specific values are in "big endian". This is also done by the
FreeBSD kernel, see [0] for example.

This allows us to parse EEPROMs with the "correct" magic bytes but
swapped EEPROM format specific values. These EEPROMs (mostly found in
lantiq and broadcom based big endian MIPS based devices) only worked
due to platform specific "hacks" which swapped the EEPROM so the
magic was inverted, which also enabled the format specific swapping.
With this patch the old behavior is still supported, but neither
recommended nor needed anymore.

[0]
https://github.com/freebsd/freebsd/blob/50719b56d9ce8d7d4beb53b16e9edb2e9a4a7a18/sys/dev/ath/ath_hal/ah_eeprom_9287.c#L351
---
 drivers/net/wireless/ath/ath9k/eeprom.c | 57 ++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index a449588..8138a1d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -155,11 +155,19 @@ bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
 	return ret;
 }
 
+#ifdef __BIG_ENDIAN
+#define EXPECTED_EEPMISC_VAL AR5416_EEPMISC_BIG_ENDIAN
+#else
+#define EXPECTED_EEPMISC_VAL 0
+#endif
+
 int ath9k_hw_nvram_swap_data(struct ath_hw *ah, bool *swap_needed, int size)
 {
 	u16 magic;
 	u16 *eepdata;
+	u8 eepmisc;
 	int i;
+	bool needs_byteswap = false;
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
@@ -167,36 +175,53 @@ int ath9k_hw_nvram_swap_data(struct ath_hw *ah, bool *swap_needed, int size)
 		return -EIO;
 	}
 
-	*swap_needed = false;
 	if (swab16(magic) == AR5416_EEPROM_MAGIC) {
+		needs_byteswap = true;
+		ath_dbg(common, EEPROM,
+			"EEPROM needs byte-swapping to correct endianness.\n");
+	} else if (magic != AR5416_EEPROM_MAGIC) {
+		if (ath9k_hw_use_flash(ah)) {
+			ath_dbg(common, EEPROM,
+				"Ignoring invalid EEPROM magic (0x%04x).\n",
+				magic);
+		} else {
+			ath_err(common,
+				"Invalid EEPROM magic (0x%04x).\n", magic);
+			return -EINVAL;
+		}
+	}
+
+	if (needs_byteswap) {
 		if (ah->ah_flags & AH_NO_EEP_SWAP) {
 			ath_info(common,
 				 "Ignoring endianness difference in EEPROM magic bytes.\n");
 		} else {
-			*swap_needed = true;
-		}
-	} else if (magic != AR5416_EEPROM_MAGIC) {
-		if (ath9k_hw_use_flash(ah))
-			return 0;
+			eepdata = (u16 *)(&ah->eeprom);
 
-		ath_err(common,
-			"Invalid EEPROM Magic (0x%04x).\n", magic);
-		return -EINVAL;
+			for (i = 0; i < size; i++)
+				eepdata[i] = swab16(eepdata[i]);
+		}
 	}
 
-	eepdata = (u16 *)(&ah->eeprom);
-
-	if (*swap_needed) {
-		ath_dbg(common, EEPROM,
-			"EEPROM Endianness is not native.. Changing.\n");
+	*swap_needed = false;
 
-		for (i = 0; i < size; i++)
-			eepdata[i] = swab16(eepdata[i]);
+	eepmisc = ah->eep_ops->get_eepmisc(ah);
+	if ((eepmisc & AR5416_EEPMISC_BIG_ENDIAN) != EXPECTED_EEPMISC_VAL) {
+		if (ah->ah_flags & AH_NO_EEP_SWAP) {
+			ath_info(common,
+				 "Ignoring endianness difference in eepmisc register.\n");
+		} else {
+			*swap_needed = true;
+			ath_dbg(common, EEPROM,
+				"EEPROM needs swapping according to the eepmisc register.\n");
+		}
 	}
 
 	return 0;
 }
 
+#undef EXPECTED_EEPMISC_VAL
+
 bool ath9k_hw_nvram_validate_checksum(struct ath_hw *ah, int size)
 {
 	u32 i, sum = 0;
-- 
2.9.3
