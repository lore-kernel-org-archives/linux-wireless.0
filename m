Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1DRNfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:35:32 -0400
Received: by fxm17 with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:35:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/23] Enable WLAN LED on Ralink SoC (rt305x) devices
Date: Mon, 18 Apr 2011 15:26:00 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104181526.01722.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Layne Edwards <ledwards@astrumtech.net>

This patch adds WLAN LED support to the mac80211 rt2x00 driver for
Ralink SoC (rt305x) devices.  The current WLAN LED drivers in
rt2800lib.c set the LED brightness via an MCU request, but do nothing
for SoC.  This patch checks for SoC and sets the register to enable the
WLAN LED (instead of an MCU request).  This enables the WLAN LED for
RT305x devices.

Signed-off-by: Layne Edwards <ledwards@astrumtech.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   60 +++++++++++++++++++++---------
 1 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 769c05c..13ccc1b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -949,25 +949,49 @@ static void rt2800_brightness_set(struct led_classdev *led_cdev,
 	unsigned int ledmode =
 		rt2x00_get_field16(led->rt2x00dev->led_mcu_reg,
 				   EEPROM_FREQ_LED_MODE);
+	u32 reg;
 
-	if (led->type == LED_TYPE_RADIO) {
-		rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
-				      enabled ? 0x20 : 0);
-	} else if (led->type == LED_TYPE_ASSOC) {
-		rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
-				      enabled ? (bg_mode ? 0x60 : 0xa0) : 0x20);
-	} else if (led->type == LED_TYPE_QUALITY) {
-		/*
-		 * The brightness is divided into 6 levels (0 - 5),
-		 * The specs tell us the following levels:
-		 *	0, 1 ,3, 7, 15, 31
-		 * to determine the level in a simple way we can simply
-		 * work with bitshifting:
-		 *	(1 << level) - 1
-		 */
-		rt2800_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
-				      (1 << brightness / (LED_FULL / 6)) - 1,
-				      polarity);
+	/* Check for SoC (SOC devices don't support MCU requests) */
+	if (rt2x00_is_soc(led->rt2x00dev)) {
+		rt2800_register_read(led->rt2x00dev, LED_CFG, &reg);
+
+		/* Set LED Polarity */
+		rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, polarity);
+
+		/* Set LED Mode */
+		if (led->type == LED_TYPE_RADIO) {
+			rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE,
+					   enabled ? 3 : 0);
+		} else if (led->type == LED_TYPE_ASSOC) {
+			rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE,
+					   enabled ? 3 : 0);
+		} else if (led->type == LED_TYPE_QUALITY) {
+			rt2x00_set_field32(&reg, LED_CFG_R_LED_MODE,
+					   enabled ? 3 : 0);
+		}
+
+		rt2800_register_write(led->rt2x00dev, LED_CFG, reg);
+
+	} else {
+		if (led->type == LED_TYPE_RADIO) {
+			rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
+					      enabled ? 0x20 : 0);
+		} else if (led->type == LED_TYPE_ASSOC) {
+			rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
+					      enabled ? (bg_mode ? 0x60 : 0xa0) : 0x20);
+		} else if (led->type == LED_TYPE_QUALITY) {
+			/*
+			 * The brightness is divided into 6 levels (0 - 5),
+			 * The specs tell us the following levels:
+			 *	0, 1 ,3, 7, 15, 31
+			 * to determine the level in a simple way we can simply
+			 * work with bitshifting:
+			 *	(1 << level) - 1
+			 */
+			rt2800_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
+					      (1 << brightness / (LED_FULL / 6)) - 1,
+					      polarity);
+		}
 	}
 }
 
-- 
1.7.2.3

