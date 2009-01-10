Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:48823 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZAJTiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 14:38:09 -0500
Date: Sat, 10 Jan 2009 19:38:05 +0000
From: Andrew Price <andy@andrewprice.me.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo Van Doorn <ivdoorn@gmail.com>
Subject: [PATCH] rt2400,rt2500: init led_qual for LED_MODE_DEFAULT
Message-ID: <20090110193805.GA13086@silver.sucs.org> (sfid-20090110_203815_019902_36B8A16E)
References: <200901101345.57310.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901101345.57310.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a check for LED_MODE_DEFAULT so that we use the link LED for rt2400
and rt2500 devices.

Signed-off-by: Andrew Price <andy@andrewprice.me.uk>

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6a97767..b86400d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1365,7 +1365,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	if (value == LED_MODE_TXRX_ACTIVITY)
+	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
 		rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d3bc218..651cb4f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1524,7 +1524,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	if (value == LED_MODE_TXRX_ACTIVITY)
+	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
 		rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 30028e2..c8e38a5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1569,7 +1569,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	if (value == LED_MODE_TXRX_ACTIVITY)
+	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
 		rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
-- 
1.5.6.5

