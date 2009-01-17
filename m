Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:41813 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874AbZAQToU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 14:44:20 -0500
Received: by ey-out-2122.google.com with SMTP id 22so398534eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 11:44:18 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 3/3] rt2x00: Add LED_MODE_ASUS support
Date: Sat, 17 Jan 2009 20:44:08 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901172042.32618.IvDoorn@gmail.com> <200901172042.58545.IvDoorn@gmail.com>
In-Reply-To: <200901172042.58545.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901172044.08251.IvDoorn@gmail.com> (sfid-20090117_204426_285361_9F51858C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the led mode is asus, the activity led mode must
be registered otherwise the second LED will not be enabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, this should fix Fedora Bug 437391:
"RT2500 from kernel-2.6.23.15-137.fc8 - no power LED"

 drivers/net/wireless/rt2x00/rt2400pci.c |    4 +++-
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 +++-
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 5c617b9..908f43a 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1397,7 +1397,9 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
+	if (value == LED_MODE_TXRX_ACTIVITY ||
+	    value == LED_MODE_DEFAULT ||
+	    value == LED_MODE_ASUS)
 		rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 09ae308..b9563aa 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1555,7 +1555,9 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
+	if (value == LED_MODE_TXRX_ACTIVITY ||
+	    value == LED_MODE_DEFAULT ||
+	    value == LED_MODE_ASUS)
 		rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index cecaba9..31d8474 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1605,7 +1605,9 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
+	if (value == LED_MODE_TXRX_ACTIVITY ||
+	    value == LED_MODE_DEFAULT ||
+	    value == LED_MODE_ASUS)
 		rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
-- 
1.5.6.1

