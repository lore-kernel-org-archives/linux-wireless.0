Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34297 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbcJBW3X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Oct 2016 18:29:23 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, arnd@arndb.de
Cc: chunkeey@googlemail.com, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 2/7] ath9k: indicate that the AR9003 EEPROM template values are little endian
Date: Mon,  3 Oct 2016 00:29:08 +0200
Message-Id: <20161002222913.12223-3-martin.blumenstingl@googlemail.com> (sfid-20161003_002933_174027_AD405FA7)
In-Reply-To: <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The eepMisc field was not set explicitly. The default value of 0 means
that the values in the EEPROM (template) should be interpreted as little
endian. However, this is not clear until comparing the AR9003 code with
the other EEPROM formats.
To make the code easier to understand we explicitly state that the values
are little endian - there are no functional changes with this patch.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ea7b819..270d4ae 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -53,7 +53,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_LITTLE_ENDIAN,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -631,7 +631,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_LITTLE_ENDIAN,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -1210,7 +1210,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_LITTLE_ENDIAN,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -1789,7 +1789,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_LITTLE_ENDIAN,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
@@ -2367,7 +2367,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.txrxMask =  0x33, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
-			.eepMisc = 0,
+			.eepMisc = AR9300_EEPMISC_LITTLE_ENDIAN,
 		},
 		.rfSilent = 0,
 		.blueToothOptions = 0,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 0a4c736..7dc7205 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -69,6 +69,9 @@
 #define AR9300_BASE_ADDR 0x3ff
 #define AR9300_BASE_ADDR_512 0x1ff
 
+/* AR5416_EEPMISC_BIG_ENDIAN not set indicates little endian */
+#define AR9300_EEPMISC_LITTLE_ENDIAN 0
+
 #define AR9300_OTP_BASE \
 		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x30000 : 0x14000)
 #define AR9300_OTP_STATUS \
-- 
2.10.0
