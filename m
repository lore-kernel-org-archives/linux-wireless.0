Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:58495 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbYIHRRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 13:17:22 -0400
Received: by ey-out-2122.google.com with SMTP id 6so727098eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 10:17:20 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Make rt2x00 LEDS invisible config option
Date: Mon, 8 Sep 2008 19:07:15 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809081907.15648.IvDoorn@gmail.com> (sfid-20080908_191747_617428_E69745A4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There isn't really a good reason to have the LED
configuration options selectable per driver, lets
make it default 'y' and make it depend on the
NEW_LEDS and LEDS_CLASS interface.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com
---
 drivers/net/wireless/rt2x00/Kconfig     |   45 +++----------------------------
 drivers/net/wireless/rt2x00/rt2400pci.c |    8 +++---
 drivers/net/wireless/rt2x00/rt2500pci.c |    8 +++---
 drivers/net/wireless/rt2x00/rt2500usb.c |    8 +++---
 drivers/net/wireless/rt2x00/rt61pci.c   |   12 ++++----
 drivers/net/wireless/rt2x00/rt73usb.c   |    8 +++---
 6 files changed, 26 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index c896c99..b686dc4 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -45,7 +45,10 @@ config RT2X00_LIB_RFKILL
 
 config RT2X00_LIB_LEDS
 	boolean
-	depends on RT2X00_LIB && NEW_LEDS
+	depends on RT2X00_LIB
+	depends on NEW_LEDS
+	depends on LEDS_CLASS
+	default y
 
 config RT2400PCI
 	tristate "Ralink rt2400 (PCI/PCMCIA) support"
@@ -58,14 +61,6 @@ config RT2400PCI
 
 	  When compiled as a module, this driver will be called "rt2400pci.ko".
 
-config RT2400PCI_LEDS
-	bool "Ralink rt2400 leds support"
-	depends on RT2400PCI && NEW_LEDS
-	select LEDS_CLASS
-	select RT2X00_LIB_LEDS
-	---help---
-	  This adds support for led triggers provided my mac80211.
-
 config RT2500PCI
 	tristate "Ralink rt2500 (PCI/PCMCIA) support"
 	depends on PCI
@@ -77,14 +72,6 @@ config RT2500PCI
 
 	  When compiled as a module, this driver will be called "rt2500pci.ko".
 
-config RT2500PCI_LEDS
-	bool "Ralink rt2500 leds support"
-	depends on RT2500PCI && NEW_LEDS
-	select LEDS_CLASS
-	select RT2X00_LIB_LEDS
-	---help---
-	  This adds support for led triggers provided my mac80211.
-
 config RT61PCI
 	tristate "Ralink rt2501/rt61 (PCI/PCMCIA) support"
 	depends on PCI
@@ -99,14 +86,6 @@ config RT61PCI
 
 	  When compiled as a module, this driver will be called "rt61pci.ko".
 
-config RT61PCI_LEDS
-	bool "Ralink rt2501/rt61 leds support"
-	depends on RT61PCI && NEW_LEDS
-	select LEDS_CLASS
-	select RT2X00_LIB_LEDS
-	---help---
-	  This adds support for led triggers provided my mac80211.
-
 config RT2500USB
 	tristate "Ralink rt2500 (USB) support"
 	depends on USB
@@ -117,14 +96,6 @@ config RT2500USB
 
 	  When compiled as a module, this driver will be called "rt2500usb.ko".
 
-config RT2500USB_LEDS
-	bool "Ralink rt2500 leds support"
-	depends on RT2500USB && NEW_LEDS
-	select LEDS_CLASS
-	select RT2X00_LIB_LEDS
-	---help---
-	  This adds support for led triggers provided my mac80211.
-
 config RT73USB
 	tristate "Ralink rt2501/rt73 (USB) support"
 	depends on USB
@@ -138,14 +109,6 @@ config RT73USB
 
 	  When compiled as a module, this driver will be called "rt73usb.ko".
 
-config RT73USB_LEDS
-	bool "Ralink rt2501/rt73 leds support"
-	depends on RT73USB && NEW_LEDS
-	select LEDS_CLASS
-	select RT2X00_LIB_LEDS
-	---help---
-	  This adds support for led triggers provided my mac80211.
-
 config RT2X00_LIB_DEBUGFS
 	bool "Ralink debugfs support"
 	depends on RT2X00_LIB && MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 0083e7e..08cb9ee 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -243,7 +243,7 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 #define rt2400pci_rfkill_poll	NULL
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
-#ifdef CONFIG_RT2400PCI_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2400pci_brightness_set(struct led_classdev *led_cdev,
 				     enum led_brightness brightness)
 {
@@ -288,7 +288,7 @@ static void rt2400pci_init_led(struct rt2x00_dev *rt2x00dev,
 	led->led_dev.blink_set = rt2400pci_blink_set;
 	led->flags = LED_INITIALIZED;
 }
-#endif /* CONFIG_RT2400PCI_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 /*
  * Configuration handlers.
@@ -1374,14 +1374,14 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Store led mode, for correct led behaviour.
 	 */
-#ifdef CONFIG_RT2400PCI_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
 	if (value == LED_MODE_TXRX_ACTIVITY)
 		rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
-#endif /* CONFIG_RT2400PCI_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
 	 * Detect if this device has an hardware controlled radio.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d8c9d67..ef42cc0 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -243,7 +243,7 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 #define rt2500pci_rfkill_poll	NULL
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
-#ifdef CONFIG_RT2500PCI_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2500pci_brightness_set(struct led_classdev *led_cdev,
 				     enum led_brightness brightness)
 {
@@ -288,7 +288,7 @@ static void rt2500pci_init_led(struct rt2x00_dev *rt2x00dev,
 	led->led_dev.blink_set = rt2500pci_blink_set;
 	led->flags = LED_INITIALIZED;
 }
-#endif /* CONFIG_RT2500PCI_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 /*
  * Configuration handlers.
@@ -1533,14 +1533,14 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Store led mode, for correct led behaviour.
 	 */
-#ifdef CONFIG_RT2500PCI_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
 	if (value == LED_MODE_TXRX_ACTIVITY)
 		rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
-#endif /* CONFIG_RT2500PCI_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
 	 * Detect if this device has an hardware controlled radio.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1cfda45..cb5f2d0 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -288,7 +288,7 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2500USB_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2500usb_brightness_set(struct led_classdev *led_cdev,
 				     enum led_brightness brightness)
 {
@@ -333,7 +333,7 @@ static void rt2500usb_init_led(struct rt2x00_dev *rt2x00dev,
 	led->led_dev.blink_set = rt2500usb_blink_set;
 	led->flags = LED_INITIALIZED;
 }
-#endif /* CONFIG_RT2500USB_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 /*
  * Configuration handlers.
@@ -1473,14 +1473,14 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Store led mode, for correct led behaviour.
 	 */
-#ifdef CONFIG_RT2500USB_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
 	if (value == LED_MODE_TXRX_ACTIVITY)
 		rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
-#endif /* CONFIG_RT2500USB_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
 	 * Check if the BBP tuning should be disabled.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a5c9352..2c36b91 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -163,7 +163,7 @@ rf_write:
 	rt2x00_rf_write(rt2x00dev, word, value);
 }
 
-#ifdef CONFIG_RT61PCI_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 /*
  * This function is only called from rt61pci_led_brightness()
  * make gcc happy by placing this function inside the
@@ -195,7 +195,7 @@ static void rt61pci_mcu_request(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, HOST_CMD_CSR_INTERRUPT_MCU, 1);
 	rt2x00pci_register_write(rt2x00dev, HOST_CMD_CSR, reg);
 }
-#endif /* CONFIG_RT61PCI_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 static void rt61pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 {
@@ -283,7 +283,7 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 #define rt61pci_rfkill_poll	NULL
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
-#ifdef CONFIG_RT61PCI_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt61pci_brightness_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
@@ -348,7 +348,7 @@ static void rt61pci_init_led(struct rt2x00_dev *rt2x00dev,
 	led->led_dev.blink_set = rt61pci_blink_set;
 	led->flags = LED_INITIALIZED;
 }
-#endif /* CONFIG_RT61PCI_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 /*
  * Configuration handlers.
@@ -2374,7 +2374,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * If the eeprom value is invalid,
 	 * switch to default led mode.
 	 */
-#ifdef CONFIG_RT61PCI_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED, &eeprom);
 	value = rt2x00_get_field16(eeprom, EEPROM_LED_LED_MODE);
 
@@ -2408,7 +2408,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_POLARITY_READY_A,
 			   rt2x00_get_field16(eeprom,
 					      EEPROM_LED_POLARITY_RDY_A));
-#endif /* CONFIG_RT61PCI_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d9ef34c..27dde3e 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -292,7 +292,7 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT73USB_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt73usb_brightness_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
@@ -359,7 +359,7 @@ static void rt73usb_init_led(struct rt2x00_dev *rt2x00dev,
 	led->led_dev.blink_set = rt73usb_blink_set;
 	led->flags = LED_INITIALIZED;
 }
-#endif /* CONFIG_RT73USB_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 /*
  * Configuration handlers.
@@ -1932,7 +1932,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Store led settings, for correct led behaviour.
 	 */
-#ifdef CONFIG_RT73USB_LEDS
+#ifdef CONFIG_RT2X00_LIB_LEDS
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED, &eeprom);
 
 	rt73usb_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
@@ -1965,7 +1965,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_POLARITY_READY_A,
 			   rt2x00_get_field16(eeprom,
 					      EEPROM_LED_POLARITY_RDY_A));
-#endif /* CONFIG_RT73USB_LEDS */
+#endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	return 0;
 }
-- 
1.5.6.1

