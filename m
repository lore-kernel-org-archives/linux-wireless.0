Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33773 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbcHUOtc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 10:49:32 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        chunkeey@googlemail.com, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5/5] ath9k: Make EEPROM endianness swapping configurable via devicetree
Date: Sun, 21 Aug 2016 16:49:06 +0200
Message-Id: <20160821144906.30984-6-martin.blumenstingl@googlemail.com> (sfid-20160821_164939_103365_5D827E86)
In-Reply-To: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The endianness swapping is disabled by default since many devices have
EEPROMs with incorrect endianness magic bytes (at the beginning).
Devices where the EEPROM is known to indicate the correct endianness
can enable the new flag to enable swapping when required.
This behavior is consistent with ath9k_platform_data where the endian
check also has to be enabled explicitly.
---
 .../devicetree/bindings/net/wireless/qca,ath9k.txt       | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c                    |  6 +++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
index 98065ad..05c54c4 100644
--- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -17,6 +17,22 @@ Optional properties:
 			ath9k wireless chip (in this case the calibration /
 			EEPROM data will be loaded from userspace using the
 			kernel firmware loader).
+- qca,check-eeprom-endianness: When enabled, the driver checks if the
+				endianness of the EEPROM (using two checks,
+				one is based on the two magic bytes at the
+				start of the EEPROM and a second one which
+				relies on a flag within the EEPROM data)
+				matches the host system's native endianness.
+				The data will be swapped accordingly if there
+				is a mismatch.
+				Leaving this disabled means that the EEPROM
+				data will always be interpreted in the
+				system's native endianness.
+				Enable this option only when the EEPROMs
+				endianness identifiers are known to be
+				correct, because otherwise the EEPROM data
+				may be swapped and thus interpreted
+				incorrectly.
 - qca,disable-2ghz: Overrides the settings from the EEPROM and disables the
 			2.4GHz band. Setting this property is only needed
 			when the RF circuit does not support the 2.4GHz band
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c123145..d123977 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -581,6 +581,11 @@ static int ath9k_of_init(struct ath_softc *sc)
 	if (of_property_read_bool(np, "qca,disable-5ghz"))
 		ah->disable_5ghz = true;
 
+	if (of_property_read_bool(np, "qca,check-eeprom-endianness"))
+		ah->ah_flags &= ~AH_NO_EEP_SWAP;
+	else
+		ah->ah_flags |= AH_NO_EEP_SWAP;
+
 	if (of_property_read_bool(np, "qca,no-eeprom")) {
 		/* ath9k-eeprom-<bus>-<id>.bin */
 		scnprintf(eeprom_name, sizeof(eeprom_name),
@@ -597,7 +602,6 @@ static int ath9k_of_init(struct ath_softc *sc)
 		ether_addr_copy(common->macaddr, mac);
 
 	ah->ah_flags &= ~AH_USE_EEPROM;
-	ah->ah_flags |= AH_NO_EEP_SWAP;
 
 	return 0;
 }
-- 
2.9.3
