Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33943 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753148AbcHUOt2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 10:49:28 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        chunkeey@googlemail.com, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/5] ath9k: Set the "big endian" bit of the AR9003 EEPROM templates
Date: Sun, 21 Aug 2016 16:49:03 +0200
Message-Id: <20160821144906.30984-3-martin.blumenstingl@googlemail.com> (sfid-20160821_164931_990785_497B15E6)
In-Reply-To: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will default to the system's native endianness for the eepmisc value.
This may be overwritten by the actual calibration data. If it is not
overwritten we interpret the template data in it's native endianness,
meaning that no swapping is required.
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  6 ++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ea7b819..6669e36 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -53,7 +53,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_DEFAULT_VALUE,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -631,7 +631,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_DEFAULT_VALUE,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -1210,7 +1210,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_DEFAULT_VALUE,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -1789,7 +1789,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_DEFAULT_VALUE,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -2367,7 +2367,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.txrxMask =  0x33, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_DEFAULT_VALUE,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 0a4c736..7e06f12 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -69,6 +69,12 @@
 #define AR9300_BASE_ADDR 0x3ff
 #define AR9300_BASE_ADDR_512 0x1ff
 
+#ifdef __BIG_ENDIAN
+#define AR9300_EEPMISC_DEFAULT_VALUE AR5416_EEPMISC_BIG_ENDIAN
+#else
+#define AR9300_EEPMISC_DEFAULT_VALUE 0
+#endif
+
 #define AR9300_OTP_BASE \
 		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x30000 : 0x14000)
 #define AR9300_OTP_STATUS \
-- 
2.9.3
