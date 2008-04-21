Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:45010 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762247AbYDURAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:10 -0400
Received: by nf-out-0910.google.com with SMTP id g13so577983nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:05 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 5/9] rt2x00: Fix quality/activity led handling
Date: Mon, 21 Apr 2008 19:01:09 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211901.09522.IvDoorn@gmail.com> (sfid-20080421_190105_597325_2D34B124)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was an obvious typo in LED structure
initialization which caused the radio and quality/activity
leds to be incorrectly initialized which resulted in
the leds not being enabled.

Additionally add the rt2x00led_led_activity() handler
that will enable TX/RX activity leds when the radio
is being enabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c  |    2 ++
 drivers/net/wireless/rt2x00/rt2x00leds.c |   15 +++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00lib.h  |    6 ++++++
 drivers/net/wireless/rt2x00/rt61pci.c    |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c    |    2 +-
 8 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1a860d2..705bc2d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1305,7 +1305,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	if (value == LED_MODE_TXRX_ACTIVITY) {
 		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_radio.type = LED_TYPE_ACTIVITY;
+		rt2x00dev->led_qual.type = LED_TYPE_ACTIVITY;
 		rt2x00dev->led_qual.led_dev.brightness_set =
 		    rt2400pci_brightness_set;
 		rt2x00dev->led_qual.led_dev.blink_set =
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 34f6e3d..0d53c75 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1481,7 +1481,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	if (value == LED_MODE_TXRX_ACTIVITY) {
 		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_radio.type = LED_TYPE_ACTIVITY;
+		rt2x00dev->led_qual.type = LED_TYPE_ACTIVITY;
 		rt2x00dev->led_qual.led_dev.brightness_set =
 		    rt2500pci_brightness_set;
 		rt2x00dev->led_qual.led_dev.blink_set =
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 2782ef4..0dac1f5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1394,7 +1394,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	if (value == LED_MODE_TXRX_ACTIVITY) {
 		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_radio.type = LED_TYPE_ACTIVITY;
+		rt2x00dev->led_qual.type = LED_TYPE_ACTIVITY;
 		rt2x00dev->led_qual.led_dev.brightness_set =
 		    rt2500usb_brightness_set;
 		rt2x00dev->led_qual.led_dev.blink_set =
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0a398da..b1a324d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -114,6 +114,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return status;
 
 	rt2x00leds_led_radio(rt2x00dev, true);
+	rt2x00led_led_activity(rt2x00dev, true);
 
 	__set_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags);
 
@@ -157,6 +158,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Disable radio.
 	 */
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_OFF);
+	rt2x00led_led_activity(rt2x00dev, false);
 	rt2x00leds_led_radio(rt2x00dev, false);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index 40c1f5c..b362a1c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -72,6 +72,21 @@ void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi)
 	}
 }
 
+void rt2x00led_led_activity(struct rt2x00_dev *rt2x00dev, bool enabled)
+{
+	struct rt2x00_led *led = &rt2x00dev->led_qual;
+	unsigned int brightness;
+
+	if ((led->type != LED_TYPE_ACTIVITY) || !(led->flags & LED_REGISTERED))
+		return;
+
+	brightness = enabled ? LED_FULL : LED_OFF;
+	if (brightness != led->led_dev.brightness) {
+		led->led_dev.brightness_set(&led->led_dev, brightness);
+		led->led_dev.brightness = brightness;
+	}
+}
+
 void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled)
 {
 	struct rt2x00_led *led = &rt2x00dev->led_assoc;
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 5be32ff..41ee02c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -185,6 +185,7 @@ static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev)
  */
 #ifdef CONFIG_RT2X00_LIB_LEDS
 void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi);
+void rt2x00led_led_activity(struct rt2x00_dev *rt2x00dev, bool enabled);
 void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled);
 void rt2x00leds_led_radio(struct rt2x00_dev *rt2x00dev, bool enabled);
 void rt2x00leds_register(struct rt2x00_dev *rt2x00dev);
@@ -197,6 +198,11 @@ static inline void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev,
 {
 }
 
+static inline void rt2x00led_led_activity(struct rt2x00_dev *rt2x00dev,
+					  bool enabled)
+{
+}
+
 static inline void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev,
 					bool enabled)
 {
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d173a03..98af4d2 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2083,7 +2083,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	if (value == LED_MODE_SIGNAL_STRENGTH) {
 		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_radio.type = LED_TYPE_QUALITY;
+		rt2x00dev->led_qual.type = LED_TYPE_QUALITY;
 		rt2x00dev->led_qual.led_dev.brightness_set =
 		    rt61pci_brightness_set;
 		rt2x00dev->led_qual.led_dev.blink_set =
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d7028c5..a6419c9 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1647,7 +1647,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	if (value == LED_MODE_SIGNAL_STRENGTH) {
 		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
-		rt2x00dev->led_radio.type = LED_TYPE_QUALITY;
+		rt2x00dev->led_qual.type = LED_TYPE_QUALITY;
 		rt2x00dev->led_qual.led_dev.brightness_set =
 		    rt73usb_brightness_set;
 		rt2x00dev->led_qual.led_dev.blink_set =
-- 
1.5.4.5

