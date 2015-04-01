Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42654 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbbDACUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 22:20:38 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH] ath9k: add extra GPIO led support
Date: Wed, 1 Apr 2015 10:19:57 +0800
Message-ID: <1427854797-30332-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150401_042041_781850_DDC873D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

ar9550 or later chips, the AR_GPIO_IN_OUT register only can
control GPIO[0:3]. For the extra GPIO, use standard GPIO calls
instead of WMAC internal registers.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |  8 +++++++-
 drivers/net/wireless/ath/ath9k/hw.c   | 17 +++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h   |  1 +
 drivers/net/wireless/ath/ath9k/reg.h  |  4 ++++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 86d46c1..2847067 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -69,9 +69,15 @@ void ath_fill_led_pin(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-	if (AR_SREV_9100(ah) || (ah->led_pin >= 0))
+	if (AR_SREV_9100(ah))
 		return;
 
+	if (ah->led_pin >= 0) {
+		if (!((1 << ah->led_pin) & AR_GPIO_OE_OUT_MASK))
+			ath9k_hw_request_gpio(ah, ah->led_pin, "ath9k-led");
+		return;
+	}
+
 	if (AR_SREV_9287(ah))
 		ah->led_pin = ATH_LED_PIN_9287;
 	else if (AR_SREV_9485(sc->sc_ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a8c87df..fd9ca2b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -20,6 +20,7 @@
 #include <linux/time.h>
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
+#include <linux/gpio.h>
 #include <asm/unaligned.h>
 
 #include "hw.h"
@@ -2677,11 +2678,23 @@ void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
 	if (AR_SREV_9271(ah))
 		val = ~val;
 
-	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
-		AR_GPIO_BIT(gpio));
+	if ((1 << gpio) & AR_GPIO_OE_OUT_MASK)
+		REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
+			AR_GPIO_BIT(gpio));
+	else
+		gpio_set_value(gpio, val & 1);
 }
 EXPORT_SYMBOL(ath9k_hw_set_gpio);
 
+void ath9k_hw_request_gpio(struct ath_hw *ah, u32 gpio, const char *label)
+{
+	if (gpio >= ah->caps.num_gpio_pins)
+		return;
+
+	gpio_request_one(gpio, GPIOF_DIR_OUT | GPIOF_INIT_LOW, label);
+}
+EXPORT_SYMBOL(ath9k_hw_request_gpio);
+
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna)
 {
 	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index aaec945..bcbf117 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1010,6 +1010,7 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio);
 void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 			 u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
+void ath9k_hw_request_gpio(struct ath_hw *ah, u32 gpio, const char *label);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
 
 /* General Operation */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 1234399..caba54d 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -958,6 +958,8 @@
 
 #define AR_SREV_9550(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9550))
+#define AR_SREV_9550_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9550))
 
 #define AR_SREV_9580(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9580) && \
@@ -1128,6 +1130,8 @@ enum {
 
 #define AR_GPIO_OE_OUT                           (AR_SREV_9340(ah) ? 0x4030 : \
 						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c))
+#define AR_GPIO_OE_OUT_MASK			 (AR_SREV_9550_OR_LATER(ah) ? \
+						  0x0000000F : 0xFFFFFFFF)
 #define AR_GPIO_OE_OUT_DRV                       0x3
 #define AR_GPIO_OE_OUT_DRV_NO                    0x0
 #define AR_GPIO_OE_OUT_DRV_LOW                   0x1
-- 
1.9.1

