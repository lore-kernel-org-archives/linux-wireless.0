Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYFCS0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644244nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:15 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/11] rt2x00: Move led initialization into function
Date: Tue, 3 Jun 2008 20:30:01 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032027.47342.IvDoorn@gmail.com> <200806032028.03154.IvDoorn@gmail.com>
In-Reply-To: <200806032028.03154.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032030.01699.IvDoorn@gmail.com> (sfid-20080603_202624_137683_35D10ADA)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce code duplication by moving led structure initialization
into a per-driver function.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   32 +++++++++++-------------
 drivers/net/wireless/rt2x00/rt2500pci.c |   32 +++++++++++-------------
 drivers/net/wireless/rt2x00/rt2500usb.c |   32 +++++++++++-------------
 drivers/net/wireless/rt2x00/rt61pci.c   |   41 ++++++++++++-------------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   41 ++++++++++++-------------------
 5 files changed, 77 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 900140d..1101610 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -277,6 +277,17 @@ static int rt2400pci_blink_set(struct led_classdev *led_cdev,
 
 	return 0;
 }
+
+static void rt2400pci_init_led(struct rt2x00_dev *rt2x00dev,
+			       struct rt2x00_led *led,
+			       enum led_type type)
+{
+	led->rt2x00dev = rt2x00dev;
+	led->type = type;
+	led->led_dev.brightness_set = rt2400pci_brightness_set;
+	led->led_dev.blink_set = rt2400pci_blink_set;
+	led->flags = LED_INITIALIZED;
+}
 #endif /* CONFIG_RT2400PCI_LEDS */
 
 /*
@@ -1300,23 +1311,10 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2400PCI_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
-	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
-	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
-	rt2x00dev->led_radio.led_dev.brightness_set =
-	    rt2400pci_brightness_set;
-	rt2x00dev->led_radio.led_dev.blink_set =
-	    rt2400pci_blink_set;
-	rt2x00dev->led_radio.flags = LED_INITIALIZED;
-
-	if (value == LED_MODE_TXRX_ACTIVITY) {
-		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_qual.type = LED_TYPE_ACTIVITY;
-		rt2x00dev->led_qual.led_dev.brightness_set =
-		    rt2400pci_brightness_set;
-		rt2x00dev->led_qual.led_dev.blink_set =
-		    rt2400pci_blink_set;
-		rt2x00dev->led_qual.flags = LED_INITIALIZED;
-	}
+	rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
+	if (value == LED_MODE_TXRX_ACTIVITY)
+		rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
+				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2400PCI_LEDS */
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 6733509..0ac934a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -277,6 +277,17 @@ static int rt2500pci_blink_set(struct led_classdev *led_cdev,
 
 	return 0;
 }
+
+static void rt2500pci_init_led(struct rt2x00_dev *rt2x00dev,
+			       struct rt2x00_led *led,
+			       enum led_type type)
+{
+	led->rt2x00dev = rt2x00dev;
+	led->type = type;
+	led->led_dev.brightness_set = rt2500pci_brightness_set;
+	led->led_dev.blink_set = rt2500pci_blink_set;
+	led->flags = LED_INITIALIZED;
+}
 #endif /* CONFIG_RT2500PCI_LEDS */
 
 /*
@@ -1478,23 +1489,10 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2500PCI_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
-	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
-	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
-	rt2x00dev->led_radio.led_dev.brightness_set =
-	    rt2500pci_brightness_set;
-	rt2x00dev->led_radio.led_dev.blink_set =
-	    rt2500pci_blink_set;
-	rt2x00dev->led_radio.flags = LED_INITIALIZED;
-
-	if (value == LED_MODE_TXRX_ACTIVITY) {
-		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_qual.type = LED_TYPE_ACTIVITY;
-		rt2x00dev->led_qual.led_dev.brightness_set =
-		    rt2500pci_brightness_set;
-		rt2x00dev->led_qual.led_dev.blink_set =
-		    rt2500pci_blink_set;
-		rt2x00dev->led_qual.flags = LED_INITIALIZED;
-	}
+	rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
+	if (value == LED_MODE_TXRX_ACTIVITY)
+		rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
+				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2500PCI_LEDS */
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index cca1504..0027f4b 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -316,6 +316,17 @@ static int rt2500usb_blink_set(struct led_classdev *led_cdev,
 
 	return 0;
 }
+
+static void rt2500usb_init_led(struct rt2x00_dev *rt2x00dev,
+			       struct rt2x00_led *led,
+			       enum led_type type)
+{
+	led->rt2x00dev = rt2x00dev;
+	led->type = type;
+	led->led_dev.brightness_set = rt2500usb_brightness_set;
+	led->led_dev.blink_set = rt2500usb_blink_set;
+	led->flags = LED_INITIALIZED;
+}
 #endif /* CONFIG_RT2500USB_LEDS */
 
 /*
@@ -1377,23 +1388,10 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2500USB_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
-	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
-	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
-	rt2x00dev->led_radio.led_dev.brightness_set =
-	    rt2500usb_brightness_set;
-	rt2x00dev->led_radio.led_dev.blink_set =
-	    rt2500usb_blink_set;
-	rt2x00dev->led_radio.flags = LED_INITIALIZED;
-
-	if (value == LED_MODE_TXRX_ACTIVITY) {
-		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_qual.type = LED_TYPE_ACTIVITY;
-		rt2x00dev->led_qual.led_dev.brightness_set =
-		    rt2500usb_brightness_set;
-		rt2x00dev->led_qual.led_dev.blink_set =
-		    rt2500usb_blink_set;
-		rt2x00dev->led_qual.flags = LED_INITIALIZED;
-	}
+	rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
+	if (value == LED_MODE_TXRX_ACTIVITY)
+		rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_qual,
+				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2500USB_LEDS */
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index e13ed5c..f03d21d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -330,6 +330,17 @@ static int rt61pci_blink_set(struct led_classdev *led_cdev,
 
 	return 0;
 }
+
+static void rt61pci_init_led(struct rt2x00_dev *rt2x00dev,
+			     struct rt2x00_led *led,
+			     enum led_type type)
+{
+	led->rt2x00dev = rt2x00dev;
+	led->type = type;
+	led->led_dev.brightness_set = rt61pci_brightness_set;
+	led->led_dev.blink_set = rt61pci_blink_set;
+	led->flags = LED_INITIALIZED;
+}
 #endif /* CONFIG_RT61PCI_LEDS */
 
 /*
@@ -2067,31 +2078,11 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED, &eeprom);
 	value = rt2x00_get_field16(eeprom, EEPROM_LED_LED_MODE);
 
-	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
-	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
-	rt2x00dev->led_radio.led_dev.brightness_set =
-	    rt61pci_brightness_set;
-	rt2x00dev->led_radio.led_dev.blink_set =
-	    rt61pci_blink_set;
-	rt2x00dev->led_radio.flags = LED_INITIALIZED;
-
-	rt2x00dev->led_assoc.rt2x00dev = rt2x00dev;
-	rt2x00dev->led_assoc.type = LED_TYPE_ASSOC;
-	rt2x00dev->led_assoc.led_dev.brightness_set =
-	    rt61pci_brightness_set;
-	rt2x00dev->led_assoc.led_dev.blink_set =
-	    rt61pci_blink_set;
-	rt2x00dev->led_assoc.flags = LED_INITIALIZED;
-
-	if (value == LED_MODE_SIGNAL_STRENGTH) {
-		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_qual.type = LED_TYPE_QUALITY;
-		rt2x00dev->led_qual.led_dev.brightness_set =
-		    rt61pci_brightness_set;
-		rt2x00dev->led_qual.led_dev.blink_set =
-		    rt61pci_blink_set;
-		rt2x00dev->led_qual.flags = LED_INITIALIZED;
-	}
+	rt61pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
+	rt61pci_init_led(rt2x00dev, &rt2x00dev->led_assoc, LED_TYPE_ASSOC);
+	if (value == LED_MODE_SIGNAL_STRENGTH)
+		rt61pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
+				 LED_TYPE_QUALITY);
 
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_LED_MODE, value);
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_POLARITY_GPIO_0,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 26c2e0a..779fa5b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -335,6 +335,17 @@ static int rt73usb_blink_set(struct led_classdev *led_cdev,
 
 	return 0;
 }
+
+static void rt73usb_init_led(struct rt2x00_dev *rt2x00dev,
+			     struct rt2x00_led *led,
+			     enum led_type type)
+{
+	led->rt2x00dev = rt2x00dev;
+	led->type = type;
+	led->led_dev.brightness_set = rt73usb_brightness_set;
+	led->led_dev.blink_set = rt73usb_blink_set;
+	led->flags = LED_INITIALIZED;
+}
 #endif /* CONFIG_RT73USB_LEDS */
 
 /*
@@ -1620,31 +1631,11 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT73USB_LEDS
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED, &eeprom);
 
-	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
-	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
-	rt2x00dev->led_radio.led_dev.brightness_set =
-	    rt73usb_brightness_set;
-	rt2x00dev->led_radio.led_dev.blink_set =
-	    rt73usb_blink_set;
-	rt2x00dev->led_radio.flags = LED_INITIALIZED;
-
-	rt2x00dev->led_assoc.rt2x00dev = rt2x00dev;
-	rt2x00dev->led_assoc.type = LED_TYPE_ASSOC;
-	rt2x00dev->led_assoc.led_dev.brightness_set =
-	    rt73usb_brightness_set;
-	rt2x00dev->led_assoc.led_dev.blink_set =
-	    rt73usb_blink_set;
-	rt2x00dev->led_assoc.flags = LED_INITIALIZED;
-
-	if (value == LED_MODE_SIGNAL_STRENGTH) {
-		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_qual.type = LED_TYPE_QUALITY;
-		rt2x00dev->led_qual.led_dev.brightness_set =
-		    rt73usb_brightness_set;
-		rt2x00dev->led_qual.led_dev.blink_set =
-		    rt73usb_blink_set;
-		rt2x00dev->led_qual.flags = LED_INITIALIZED;
-	}
+	rt73usb_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
+	rt73usb_init_led(rt2x00dev, &rt2x00dev->led_assoc, LED_TYPE_ASSOC);
+	if (value == LED_MODE_SIGNAL_STRENGTH)
+		rt73usb_init_led(rt2x00dev, &rt2x00dev->led_qual,
+				 LED_TYPE_QUALITY);
 
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_LED_MODE, value);
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_POLARITY_GPIO_0,
-- 
1.5.5.3

