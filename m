Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:10628 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYCaNyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 09:54:07 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2199414fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 06:54:03 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Remove MAC80211_LEDS dependency
Date: Mon, 31 Mar 2008 15:53:44 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803311553.44301.IvDoorn@gmail.com> (sfid-20080331_145413_472194_2D53FF04)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement triggers inside rt2x00 itself based
on input from mac80211. This replaces the method
of using the mac80211 trigger events which do
not work for USB drivers due to the scheduling
requirement.

After this patch RT2500USB_LEDS and RT73USB_LEDS
no longer need to be tagged as broken since they
now support LED handling again without having to
check for in_atomic().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig      |   14 +--
 drivers/net/wireless/rt2x00/rt2400pci.c  |   63 ++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c  |   63 ++++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c  |   85 +++++++++----------
 drivers/net/wireless/rt2x00/rt2x00.h     |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c  |   10 ++-
 drivers/net/wireless/rt2x00/rt2x00leds.c |  131 +++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2x00leds.h |   21 +----
 drivers/net/wireless/rt2x00/rt2x00lib.h  |   12 +++
 drivers/net/wireless/rt2x00/rt2x00mac.c  |    6 ++
 drivers/net/wireless/rt2x00/rt61pci.c    |   64 +++++++++-----
 drivers/net/wireless/rt2x00/rt73usb.c    |   70 +++++++++-------
 12 files changed, 297 insertions(+), 247 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index ad15495..a1e3938 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -38,10 +38,6 @@ config RT2X00_LIB_RFKILL
 config RT2X00_LIB_LEDS
 	boolean
 	depends on RT2X00_LIB
-	select NEW_LEDS
-	select LEDS_CLASS
-	select LEDS_TRIGGERS
-	select MAC80211_LEDS
 
 config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
@@ -64,7 +60,7 @@ config RT2400PCI_RFKILL
 
 config RT2400PCI_LEDS
 	bool "RT2400 leds support"
-	depends on RT2400PCI
+	depends on RT2400PCI && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -90,7 +86,7 @@ config RT2500PCI_RFKILL
 
 config RT2500PCI_LEDS
 	bool "RT2500 leds support"
-	depends on RT2500PCI
+	depends on RT2500PCI && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -118,7 +114,7 @@ config RT61PCI_RFKILL
 
 config RT61PCI_LEDS
 	bool "RT61 leds support"
-	depends on RT61PCI
+	depends on RT61PCI && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -134,7 +130,7 @@ config RT2500USB
 
 config RT2500USB_LEDS
 	bool "RT2500 leds support"
-	depends on RT2500USB && BROKEN
+	depends on RT2500USB && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -152,7 +148,7 @@ config RT73USB
 
 config RT73USB_LEDS
 	bool "RT73 leds support"
-	depends on RT73USB && BROKEN
+	depends on RT73USB && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 9abdfb8..b41187a 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -244,27 +244,39 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_RT2400PCI_RFKILL */
 
 #ifdef CONFIG_RT2400PCI_LEDS
-static void rt2400pci_led_brightness(struct led_classdev *led_cdev,
+static void rt2400pci_brightness_set(struct led_classdev *led_cdev,
 				     enum led_brightness brightness)
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	unsigned int enabled = brightness != LED_OFF;
-	unsigned int activity =
-	    led->rt2x00dev->led_flags & LED_SUPPORT_ACTIVITY;
 	u32 reg;
 
 	rt2x00pci_register_read(led->rt2x00dev, LEDCSR, &reg);
 
-	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC) {
+	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC)
 		rt2x00_set_field32(&reg, LEDCSR_LINK, enabled);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, enabled && activity);
-	}
+	else if (led->type == LED_TYPE_ACTIVITY)
+		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, enabled);
 
 	rt2x00pci_register_write(led->rt2x00dev, LEDCSR, reg);
 }
-#else
-#define rt2400pci_led_brightness	NULL
+
+static int rt2400pci_blink_set(struct led_classdev *led_cdev,
+			       unsigned long *delay_on,
+			       unsigned long *delay_off)
+{
+	struct rt2x00_led *led =
+	    container_of(led_cdev, struct rt2x00_led, led_dev);
+	u32 reg;
+
+	rt2x00pci_register_read(led->rt2x00dev, LEDCSR, &reg);
+	rt2x00_set_field32(&reg, LEDCSR_ON_PERIOD, *delay_on);
+	rt2x00_set_field32(&reg, LEDCSR_OFF_PERIOD, *delay_off);
+	rt2x00pci_register_write(led->rt2x00dev, LEDCSR, reg);
+
+	return 0;
+}
 #endif /* CONFIG_RT2400PCI_LEDS */
 
 /*
@@ -719,11 +731,6 @@ static int rt2400pci_init_registers(struct rt2x00_dev *rt2x00dev)
 			   (rt2x00dev->rx->data_size / 128));
 	rt2x00pci_register_write(rt2x00dev, CSR9, reg);
 
-	rt2x00pci_register_read(rt2x00dev, LEDCSR, &reg);
-	rt2x00_set_field32(&reg, LEDCSR_ON_PERIOD, 70);
-	rt2x00_set_field32(&reg, LEDCSR_OFF_PERIOD, 30);
-	rt2x00pci_register_write(rt2x00dev, LEDCSR, reg);
-
 	rt2x00pci_register_write(rt2x00dev, CNT3, 0x3f080000);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR0, &reg);
@@ -1291,19 +1298,22 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2400PCI_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
-	switch (value) {
-	case LED_MODE_ASUS:
-	case LED_MODE_ALPHA:
-	case LED_MODE_DEFAULT:
-		rt2x00dev->led_flags = LED_SUPPORT_RADIO;
-		break;
-	case LED_MODE_TXRX_ACTIVITY:
-		rt2x00dev->led_flags =
-		    LED_SUPPORT_RADIO | LED_SUPPORT_ACTIVITY;
-		break;
-	case LED_MODE_SIGNAL_STRENGTH:
-		rt2x00dev->led_flags = LED_SUPPORT_RADIO;
-		break;
+	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
+	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
+	rt2x00dev->led_radio.led_dev.brightness_set =
+	    rt2400pci_brightness_set;
+	rt2x00dev->led_radio.led_dev.blink_set =
+	    rt2400pci_blink_set;
+	rt2x00dev->led_radio.flags = LED_INITIALIZED;
+
+	if (value == LED_MODE_TXRX_ACTIVITY) {
+		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
+		rt2x00dev->led_radio.type = LED_TYPE_ACTIVITY;
+		rt2x00dev->led_qual.led_dev.brightness_set =
+		    rt2400pci_brightness_set;
+		rt2x00dev->led_qual.led_dev.blink_set =
+		    rt2400pci_blink_set;
+		rt2x00dev->led_qual.flags = LED_INITIALIZED;
 	}
 #endif /* CONFIG_RT2400PCI_LEDS */
 
@@ -1569,7 +1579,6 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.link_stats		= rt2400pci_link_stats,
 	.reset_tuner		= rt2400pci_reset_tuner,
 	.link_tuner		= rt2400pci_link_tuner,
-	.led_brightness		= rt2400pci_led_brightness,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt2400pci_kick_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 54c9a75..5ade097 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -244,27 +244,39 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_RT2500PCI_RFKILL */
 
 #ifdef CONFIG_RT2500PCI_LEDS
-static void rt2500pci_led_brightness(struct led_classdev *led_cdev,
+static void rt2500pci_brightness_set(struct led_classdev *led_cdev,
 				     enum led_brightness brightness)
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	unsigned int enabled = brightness != LED_OFF;
-	unsigned int activity =
-	    led->rt2x00dev->led_flags & LED_SUPPORT_ACTIVITY;
 	u32 reg;
 
 	rt2x00pci_register_read(led->rt2x00dev, LEDCSR, &reg);
 
-	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC) {
+	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC)
 		rt2x00_set_field32(&reg, LEDCSR_LINK, enabled);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, enabled && activity);
-	}
+	else if (led->type == LED_TYPE_ACTIVITY)
+		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, enabled);
 
 	rt2x00pci_register_write(led->rt2x00dev, LEDCSR, reg);
 }
-#else
-#define rt2500pci_led_brightness	NULL
+
+static int rt2500pci_blink_set(struct led_classdev *led_cdev,
+			       unsigned long *delay_on,
+			       unsigned long *delay_off)
+{
+	struct rt2x00_led *led =
+	    container_of(led_cdev, struct rt2x00_led, led_dev);
+	u32 reg;
+
+	rt2x00pci_register_read(led->rt2x00dev, LEDCSR, &reg);
+	rt2x00_set_field32(&reg, LEDCSR_ON_PERIOD, *delay_on);
+	rt2x00_set_field32(&reg, LEDCSR_OFF_PERIOD, *delay_off);
+	rt2x00pci_register_write(led->rt2x00dev, LEDCSR, reg);
+
+	return 0;
+}
 #endif /* CONFIG_RT2500PCI_LEDS */
 
 /*
@@ -812,11 +824,6 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, CSR11_CW_SELECT, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 
-	rt2x00pci_register_read(rt2x00dev, LEDCSR, &reg);
-	rt2x00_set_field32(&reg, LEDCSR_ON_PERIOD, 70);
-	rt2x00_set_field32(&reg, LEDCSR_OFF_PERIOD, 30);
-	rt2x00pci_register_write(rt2x00dev, LEDCSR, reg);
-
 	rt2x00pci_register_write(rt2x00dev, CNT3, 0);
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR8, &reg);
@@ -1468,19 +1475,22 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2500PCI_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
-	switch (value) {
-	case LED_MODE_ASUS:
-	case LED_MODE_ALPHA:
-	case LED_MODE_DEFAULT:
-		rt2x00dev->led_flags = LED_SUPPORT_RADIO;
-		break;
-	case LED_MODE_TXRX_ACTIVITY:
-		rt2x00dev->led_flags =
-		    LED_SUPPORT_RADIO | LED_SUPPORT_ACTIVITY;
-		break;
-	case LED_MODE_SIGNAL_STRENGTH:
-		rt2x00dev->led_flags = LED_SUPPORT_RADIO;
-		break;
+	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
+	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
+	rt2x00dev->led_radio.led_dev.brightness_set =
+	    rt2500pci_brightness_set;
+	rt2x00dev->led_radio.led_dev.blink_set =
+	    rt2500pci_blink_set;
+	rt2x00dev->led_radio.flags = LED_INITIALIZED;
+
+	if (value == LED_MODE_TXRX_ACTIVITY) {
+		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
+		rt2x00dev->led_radio.type = LED_TYPE_ACTIVITY;
+		rt2x00dev->led_qual.led_dev.brightness_set =
+		    rt2500pci_brightness_set;
+		rt2x00dev->led_qual.led_dev.blink_set =
+		    rt2500pci_blink_set;
+		rt2x00dev->led_qual.flags = LED_INITIALIZED;
 	}
 #endif /* CONFIG_RT2500PCI_LEDS */
 
@@ -1882,7 +1892,6 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.link_stats		= rt2500pci_link_stats,
 	.reset_tuner		= rt2500pci_reset_tuner,
 	.link_tuner		= rt2500pci_link_tuner,
-	.led_brightness		= rt2500pci_led_brightness,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt2500pci_kick_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 28fdf19..6bb07b3 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -283,34 +283,39 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
 #ifdef CONFIG_RT2500USB_LEDS
-static void rt2500usb_led_brightness(struct led_classdev *led_cdev,
+static void rt2500usb_brightness_set(struct led_classdev *led_cdev,
 				     enum led_brightness brightness)
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	unsigned int enabled = brightness != LED_OFF;
-	unsigned int activity =
-	    led->rt2x00dev->led_flags & LED_SUPPORT_ACTIVITY;
+	u16 reg;
 
-	if (in_atomic()) {
-		NOTICE(led->rt2x00dev,
-		       "Ignoring LED brightness command for led %d\n",
-		       led->type);
-		return;
-	}
+	rt2500usb_register_read(led->rt2x00dev, MAC_CSR20, &reg);
 
-	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC) {
-		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
-				   MAC_CSR20_LINK, enabled);
-		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
-				   MAC_CSR20_ACTIVITY, enabled && activity);
-	}
+	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC)
+		rt2x00_set_field16(&reg, MAC_CSR20_LINK, enabled);
+	else if (led->type == LED_TYPE_ACTIVITY)
+		rt2x00_set_field16(&reg, MAC_CSR20_ACTIVITY, enabled);
+
+	rt2500usb_register_write(led->rt2x00dev, MAC_CSR20, reg);
+}
+
+static int rt2500usb_blink_set(struct led_classdev *led_cdev,
+			       unsigned long *delay_on,
+			       unsigned long *delay_off)
+{
+	struct rt2x00_led *led =
+	    container_of(led_cdev, struct rt2x00_led, led_dev);
+	u16 reg;
+
+	rt2500usb_register_read(led->rt2x00dev, MAC_CSR21, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR21_ON_PERIOD, *delay_on);
+	rt2x00_set_field16(&reg, MAC_CSR21_OFF_PERIOD, *delay_off);
+	rt2500usb_register_write(led->rt2x00dev, MAC_CSR21, reg);
 
-	rt2500usb_register_write(led->rt2x00dev, MAC_CSR20,
-				 led->rt2x00dev->led_mcu_reg);
+	return 0;
 }
-#else
-#define rt2500usb_led_brightness	NULL
 #endif /* CONFIG_RT2500USB_LEDS */
 
 /*
@@ -762,11 +767,6 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field16(&reg, MAC_CSR1_HOST_READY, 0);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR1, reg);
 
-	rt2500usb_register_read(rt2x00dev, MAC_CSR21, &reg);
-	rt2x00_set_field16(&reg, MAC_CSR21_ON_PERIOD, 70);
-	rt2x00_set_field16(&reg, MAC_CSR21_OFF_PERIOD, 30);
-	rt2500usb_register_write(rt2x00dev, MAC_CSR21, reg);
-
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR5, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR5_BBP_ID0, 13);
 	rt2x00_set_field16(&reg, TXRX_CSR5_BBP_ID0_VALID, 1);
@@ -1384,27 +1384,23 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2500USB_LEDS
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
-	switch (value) {
-	case LED_MODE_ASUS:
-	case LED_MODE_ALPHA:
-	case LED_MODE_DEFAULT:
-		rt2x00dev->led_flags = LED_SUPPORT_RADIO;
-		break;
-	case LED_MODE_TXRX_ACTIVITY:
-		rt2x00dev->led_flags =
-		    LED_SUPPORT_RADIO | LED_SUPPORT_ACTIVITY;
-		break;
-	case LED_MODE_SIGNAL_STRENGTH:
-		rt2x00dev->led_flags = LED_SUPPORT_RADIO;
-		break;
+	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
+	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
+	rt2x00dev->led_radio.led_dev.brightness_set =
+	    rt2500usb_brightness_set;
+	rt2x00dev->led_radio.led_dev.blink_set =
+	    rt2500usb_blink_set;
+	rt2x00dev->led_radio.flags = LED_INITIALIZED;
+
+	if (value == LED_MODE_TXRX_ACTIVITY) {
+		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
+		rt2x00dev->led_radio.type = LED_TYPE_ACTIVITY;
+		rt2x00dev->led_qual.led_dev.brightness_set =
+		    rt2500usb_brightness_set;
+		rt2x00dev->led_qual.led_dev.blink_set =
+		    rt2500usb_blink_set;
+		rt2x00dev->led_qual.flags = LED_INITIALIZED;
 	}
-
-	/*
-	 * Store the current led register value, we need it later
-	 * in set_brightness but that is called in irq context which
-	 * means we can't use rt2500usb_register_read() at that time.
-	 */
-	rt2500usb_register_read(rt2x00dev, MAC_CSR20, &rt2x00dev->led_mcu_reg);
 #endif /* CONFIG_RT2500USB_LEDS */
 
 	/*
@@ -1792,7 +1788,6 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
 	.link_tuner		= rt2500usb_link_tuner,
-	.led_brightness		= rt2500usb_led_brightness,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 30f9f3a..57bdc15 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -385,6 +385,7 @@ struct rt2x00_intf {
 	unsigned int delayed_flags;
 #define DELAYED_UPDATE_BEACON		0x00000001
 #define DELAYED_CONFIG_ERP		0x00000002
+#define DELAYED_LED_ASSOC		0x00000004
 };
 
 static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
@@ -533,8 +534,6 @@ struct rt2x00lib_ops {
 			    struct link_qual *qual);
 	void (*reset_tuner) (struct rt2x00_dev *rt2x00dev);
 	void (*link_tuner) (struct rt2x00_dev *rt2x00dev);
-	void (*led_brightness) (struct led_classdev *led_cdev,
-				enum led_brightness brightness);
 
 	/*
 	 * TX control handlers
@@ -694,8 +693,6 @@ struct rt2x00_dev {
 	 * by mac8011 or the kernel.
 	 */
 #ifdef CONFIG_RT2X00_LIB_LEDS
-	unsigned int led_flags;
-	struct rt2x00_trigger trigger_qual;
 	struct rt2x00_led led_radio;
 	struct rt2x00_led led_assoc;
 	struct rt2x00_led led_qual;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c3084c5..50ea7bd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -108,11 +108,13 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable radio.
 	 */
-	status = rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-						       STATE_RADIO_ON);
+	status =
+	    rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_ON);
 	if (status)
 		return status;
 
+	rt2x00leds_led_radio(rt2x00dev, true);
+
 	__set_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags);
 
 	/*
@@ -155,6 +157,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Disable radio.
 	 */
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_OFF);
+	rt2x00leds_led_radio(rt2x00dev, false);
 }
 
 void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
@@ -449,6 +452,9 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 
 	if (delayed_flags & DELAYED_CONFIG_ERP)
 		rt2x00lib_config_erp(rt2x00dev, intf, &intf->conf);
+
+	if (delayed_flags & DELAYED_LED_ASSOC)
+		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
 }
 
 static void rt2x00lib_intf_scheduled(struct work_struct *work)
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index ca2d282..40c1f5c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -31,7 +31,10 @@
 
 void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi)
 {
-	if (!rt2x00dev->trigger_qual.registered)
+	struct rt2x00_led *led = &rt2x00dev->led_qual;
+	unsigned int brightness;
+
+	if ((led->type != LED_TYPE_QUALITY) || !(led->flags & LED_REGISTERED))
 		return;
 
 	/*
@@ -62,39 +65,51 @@ void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi)
 	 * is going to calculate the value and might use it in a
 	 * division.
 	 */
-	led_trigger_event(&rt2x00dev->trigger_qual.trigger,
-			  ((LED_FULL / 6) * rssi) + 1);
+	brightness = ((LED_FULL / 6) * rssi) + 1;
+	if (brightness != led->led_dev.brightness) {
+		led->led_dev.brightness_set(&led->led_dev, brightness);
+		led->led_dev.brightness = brightness;
+	}
 }
 
-static int rt2x00leds_register_trigger(struct rt2x00_dev *rt2x00dev,
-				       struct rt2x00_trigger *trigger,
-				       const char *name)
+void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled)
 {
-	int retval;
+	struct rt2x00_led *led = &rt2x00dev->led_assoc;
+	unsigned int brightness;
 
-	trigger->trigger.name = name;
-	retval = led_trigger_register(&trigger->trigger);
-	if (retval) {
-		ERROR(rt2x00dev, "Failed to register led trigger.\n");
-		return retval;
+	if ((led->type != LED_TYPE_ASSOC) || !(led->flags & LED_REGISTERED))
+		return;
+
+	brightness = enabled ? LED_FULL : LED_OFF;
+	if (brightness != led->led_dev.brightness) {
+		led->led_dev.brightness_set(&led->led_dev, brightness);
+		led->led_dev.brightness = brightness;
 	}
+}
 
-	trigger->registered = 1;
+void rt2x00leds_led_radio(struct rt2x00_dev *rt2x00dev, bool enabled)
+{
+	struct rt2x00_led *led = &rt2x00dev->led_radio;
+	unsigned int brightness;
 
-	return 0;
+	if ((led->type != LED_TYPE_RADIO) || !(led->flags & LED_REGISTERED))
+		return;
+
+	brightness = enabled ? LED_FULL : LED_OFF;
+	if (brightness != led->led_dev.brightness) {
+		led->led_dev.brightness_set(&led->led_dev, brightness);
+		led->led_dev.brightness = brightness;
+	}
 }
 
 static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 				   struct rt2x00_led *led,
-				   enum led_type type,
-				   const char *name, char *trigger)
+				   const char *name)
 {
 	struct device *device = wiphy_dev(rt2x00dev->hw->wiphy);
 	int retval;
 
 	led->led_dev.name = name;
-	led->led_dev.brightness_set = rt2x00dev->ops->lib->led_brightness;
-	led->led_dev.default_trigger = trigger;
 
 	retval = led_classdev_register(device, &led->led_dev);
 	if (retval) {
@@ -102,115 +117,103 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 		return retval;
 	}
 
-	led->rt2x00dev = rt2x00dev;
-	led->type = type;
-	led->registered = 1;
+	led->flags |= LED_REGISTERED;
 
 	return 0;
 }
 
 void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 {
-	char *trigger;
 	char dev_name[16];
 	char name[32];
 	int retval;
-
-	if (!rt2x00dev->ops->lib->led_brightness)
-		return;
+	unsigned long on_period;
+	unsigned long off_period;
 
 	snprintf(dev_name, sizeof(dev_name), "%s-%s",
 		 rt2x00dev->ops->name, wiphy_name(rt2x00dev->hw->wiphy));
 
-	if (rt2x00dev->led_flags & LED_SUPPORT_RADIO) {
-		trigger = ieee80211_get_radio_led_name(rt2x00dev->hw);
+	if (rt2x00dev->led_radio.flags & LED_INITIALIZED) {
 		snprintf(name, sizeof(name), "%s:radio", dev_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_radio,
-						 LED_TYPE_RADIO,
-						 name, trigger);
+						 name);
 		if (retval)
 			goto exit_fail;
 	}
 
-	if (rt2x00dev->led_flags & LED_SUPPORT_ASSOC) {
-		trigger = ieee80211_get_assoc_led_name(rt2x00dev->hw);
+	if (rt2x00dev->led_assoc.flags & LED_INITIALIZED) {
 		snprintf(name, sizeof(name), "%s:assoc", dev_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_assoc,
-						 LED_TYPE_ASSOC,
-						 name, trigger);
+						 name);
 		if (retval)
 			goto exit_fail;
 	}
 
-	if (rt2x00dev->led_flags & LED_SUPPORT_QUALITY) {
+	if (rt2x00dev->led_qual.flags & LED_INITIALIZED) {
 		snprintf(name, sizeof(name), "%s:quality", dev_name);
 
-		retval = rt2x00leds_register_trigger(rt2x00dev,
-						     &rt2x00dev->trigger_qual,
-						     name);
-
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_qual,
-						 LED_TYPE_QUALITY,
-						 name, name);
+						 name);
 		if (retval)
 			goto exit_fail;
 	}
 
+	/*
+	 * Initialize blink time to default value:
+	 * On period: 70ms
+	 * Off period: 30ms
+	 */
+	if (rt2x00dev->led_radio.led_dev.blink_set) {
+		on_period = 70;
+		off_period = 30;
+		rt2x00dev->led_radio.led_dev.blink_set(
+		    &rt2x00dev->led_radio.led_dev, &on_period, &off_period);
+	}
+
 	return;
 
 exit_fail:
 	rt2x00leds_unregister(rt2x00dev);
 }
 
-static void rt2x00leds_unregister_trigger(struct rt2x00_trigger *trigger)
-{
-	if (!trigger->registered)
-		return;
-
-	led_trigger_unregister(&trigger->trigger);
-	trigger->registered = 0;
-}
-
 static void rt2x00leds_unregister_led(struct rt2x00_led *led)
 {
-	if (!led->registered)
-		return;
-
 	led_classdev_unregister(&led->led_dev);
-
 	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
-	led->registered = 0;
+	led->flags &= ~LED_REGISTERED;
 }
 
 void rt2x00leds_unregister(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00leds_unregister_trigger(&rt2x00dev->trigger_qual);
-	rt2x00leds_unregister_led(&rt2x00dev->led_qual);
-	rt2x00leds_unregister_led(&rt2x00dev->led_assoc);
-	rt2x00leds_unregister_led(&rt2x00dev->led_radio);
+	if (rt2x00dev->led_qual.flags & LED_REGISTERED)
+		rt2x00leds_unregister_led(&rt2x00dev->led_qual);
+	if (rt2x00dev->led_assoc.flags & LED_REGISTERED)
+		rt2x00leds_unregister_led(&rt2x00dev->led_assoc);
+	if (rt2x00dev->led_radio.flags & LED_REGISTERED)
+		rt2x00leds_unregister_led(&rt2x00dev->led_radio);
 }
 
 void rt2x00leds_suspend(struct rt2x00_dev *rt2x00dev)
 {
-	if (rt2x00dev->led_qual.registered)
+	if (rt2x00dev->led_qual.flags & LED_REGISTERED)
 		led_classdev_suspend(&rt2x00dev->led_qual.led_dev);
-	if (rt2x00dev->led_assoc.registered)
+	if (rt2x00dev->led_assoc.flags & LED_REGISTERED)
 		led_classdev_suspend(&rt2x00dev->led_assoc.led_dev);
-	if (rt2x00dev->led_radio.registered)
+	if (rt2x00dev->led_radio.flags & LED_REGISTERED)
 		led_classdev_suspend(&rt2x00dev->led_radio.led_dev);
 }
 
 void rt2x00leds_resume(struct rt2x00_dev *rt2x00dev)
 {
-	if (rt2x00dev->led_radio.registered)
+	if (rt2x00dev->led_radio.flags & LED_REGISTERED)
 		led_classdev_resume(&rt2x00dev->led_radio.led_dev);
-	if (rt2x00dev->led_assoc.registered)
+	if (rt2x00dev->led_assoc.flags & LED_REGISTERED)
 		led_classdev_resume(&rt2x00dev->led_assoc.led_dev);
-	if (rt2x00dev->led_qual.registered)
+	if (rt2x00dev->led_qual.flags & LED_REGISTERED)
 		led_classdev_resume(&rt2x00dev->led_qual.led_dev);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.h b/drivers/net/wireless/rt2x00/rt2x00leds.h
index 11e71e9..9df4a49 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.h
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.h
@@ -26,18 +26,10 @@
 #ifndef RT2X00LEDS_H
 #define RT2X00LEDS_H
 
-/*
-* Flags used by driver to indicate which
- * which led types are supported.
- */
-#define LED_SUPPORT_RADIO	0x000001
-#define LED_SUPPORT_ASSOC	0x000002
-#define LED_SUPPORT_ACTIVITY	0x000004
-#define LED_SUPPORT_QUALITY	0x000008
-
 enum led_type {
 	LED_TYPE_RADIO,
 	LED_TYPE_ASSOC,
+	LED_TYPE_ACTIVITY,
 	LED_TYPE_QUALITY,
 };
 
@@ -48,14 +40,9 @@ struct rt2x00_led {
 	struct led_classdev led_dev;
 
 	enum led_type type;
-	unsigned int registered;
-};
-
-struct rt2x00_trigger {
-	struct led_trigger trigger;
-
-	enum led_type type;
-	unsigned int registered;
+	unsigned int flags;
+#define LED_INITIALIZED		( 1 << 0 )
+#define LED_REGISTERED		( 1 << 1 )
 };
 
 #endif /* CONFIG_RT2X00_LIB_LEDS */
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 64fae7e..5be32ff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -185,6 +185,8 @@ static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev)
  */
 #ifdef CONFIG_RT2X00_LIB_LEDS
 void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi);
+void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled);
+void rt2x00leds_led_radio(struct rt2x00_dev *rt2x00dev, bool enabled);
 void rt2x00leds_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00leds_unregister(struct rt2x00_dev *rt2x00dev);
 void rt2x00leds_suspend(struct rt2x00_dev *rt2x00dev);
@@ -195,6 +197,16 @@ static inline void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev,
 {
 }
 
+static inline void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev,
+					bool enabled)
+{
+}
+
+static inline void rt2x00leds_led_radio(struct rt2x00_dev *rt2x00dev,
+					bool enabled)
+{
+}
+
 static inline void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 {
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index dc70e7a..c206b50 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -485,6 +485,12 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 			rt2x00dev->intf_associated++;
 		else
 			rt2x00dev->intf_associated--;
+
+		if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
+			rt2x00leds_led_assoc(rt2x00dev,
+					     !!rt2x00dev->intf_associated);
+		else
+			delayed |= DELAYED_LED_ASSOC;
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c5c6251..1cb056b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -277,7 +277,7 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_RT61PCI_RFKILL */
 
 #ifdef CONFIG_RT61PCI_LEDS
-static void rt61pci_led_brightness(struct led_classdev *led_cdev,
+static void rt61pci_brightness_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
 	struct rt2x00_led *led =
@@ -314,8 +314,22 @@ static void rt61pci_led_brightness(struct led_classdev *led_cdev,
 				    brightness / (LED_FULL / 6), 0);
 	}
 }
-#else
-#define rt61pci_led_brightness	NULL
+
+static int rt61pci_blink_set(struct led_classdev *led_cdev,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off)
+{
+	struct rt2x00_led *led =
+	    container_of(led_cdev, struct rt2x00_led, led_dev);
+	u32 reg;
+
+	rt2x00pci_register_read(led->rt2x00dev, MAC_CSR14, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR14_ON_PERIOD, *delay_on);
+	rt2x00_set_field32(&reg, MAC_CSR14_OFF_PERIOD, *delay_off);
+	rt2x00pci_register_write(led->rt2x00dev, MAC_CSR14, reg);
+
+	return 0;
+}
 #endif /* CONFIG_RT61PCI_LEDS */
 
 /*
@@ -1202,11 +1216,6 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, 0x0000e000);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR14, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR14_ON_PERIOD, 70);
-	rt2x00_set_field32(&reg, MAC_CSR14_OFF_PERIOD, 30);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR14, reg);
-
 	/*
 	 * Invalidate all Shared Keys (SEC_CSR0),
 	 * and clear the Shared key Cipher algorithms (SEC_CSR1 & SEC_CSR5)
@@ -2058,22 +2067,32 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 */
 #ifdef CONFIG_RT61PCI_LEDS
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED, &eeprom);
-
 	value = rt2x00_get_field16(eeprom, EEPROM_LED_LED_MODE);
 
-	switch (value) {
-	case LED_MODE_TXRX_ACTIVITY:
-	case LED_MODE_ASUS:
-	case LED_MODE_ALPHA:
-	case LED_MODE_DEFAULT:
-		rt2x00dev->led_flags =
-		    LED_SUPPORT_RADIO | LED_SUPPORT_ASSOC;
-		break;
-	case LED_MODE_SIGNAL_STRENGTH:
-		rt2x00dev->led_flags =
-		    LED_SUPPORT_RADIO | LED_SUPPORT_ASSOC |
-		    LED_SUPPORT_QUALITY;
-		break;
+	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
+	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
+	rt2x00dev->led_radio.led_dev.brightness_set =
+	    rt61pci_brightness_set;
+	rt2x00dev->led_radio.led_dev.blink_set =
+	    rt61pci_blink_set;
+	rt2x00dev->led_radio.flags = LED_INITIALIZED;
+
+	rt2x00dev->led_assoc.rt2x00dev = rt2x00dev;
+	rt2x00dev->led_assoc.type = LED_TYPE_ASSOC;
+	rt2x00dev->led_assoc.led_dev.brightness_set =
+	    rt61pci_brightness_set;
+	rt2x00dev->led_assoc.led_dev.blink_set =
+	    rt61pci_blink_set;
+	rt2x00dev->led_assoc.flags = LED_INITIALIZED;
+
+	if (value == LED_MODE_SIGNAL_STRENGTH) {
+		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
+		rt2x00dev->led_radio.type = LED_TYPE_QUALITY;
+		rt2x00dev->led_qual.led_dev.brightness_set =
+		    rt61pci_brightness_set;
+		rt2x00dev->led_qual.led_dev.blink_set =
+		    rt61pci_blink_set;
+		rt2x00dev->led_qual.flags = LED_INITIALIZED;
 	}
 
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_LED_MODE, value);
@@ -2447,7 +2466,6 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.link_stats		= rt61pci_link_stats,
 	.reset_tuner		= rt61pci_reset_tuner,
 	.link_tuner		= rt61pci_link_tuner,
-	.led_brightness		= rt61pci_led_brightness,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt61pci_kick_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 796cf29..a9efe25 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -280,7 +280,7 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
 #ifdef CONFIG_RT73USB_LEDS
-static void rt73usb_led_brightness(struct led_classdev *led_cdev,
+static void rt73usb_brightness_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
 	struct rt2x00_led *led =
@@ -291,13 +291,6 @@ static void rt73usb_led_brightness(struct led_classdev *led_cdev,
 	unsigned int bg_mode =
 	    (enabled && led->rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
 
-	if (in_atomic()) {
-		NOTICE(led->rt2x00dev,
-		       "Ignoring LED brightness command for led %d\n",
-		       led->type);
-		return;
-	}
-
 	if (led->type == LED_TYPE_RADIO) {
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MCU_LEDCS_RADIO_STATUS, enabled);
@@ -326,8 +319,22 @@ static void rt73usb_led_brightness(struct led_classdev *led_cdev,
 					    REGISTER_TIMEOUT);
 	}
 }
-#else
-#define rt73usb_led_brightness	NULL
+
+static int rt73usb_blink_set(struct led_classdev *led_cdev,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off)
+{
+	struct rt2x00_led *led =
+	    container_of(led_cdev, struct rt2x00_led, led_dev);
+	u32 reg;
+
+	rt73usb_register_read(led->rt2x00dev, MAC_CSR14, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR14_ON_PERIOD, *delay_on);
+	rt2x00_set_field32(&reg, MAC_CSR14_OFF_PERIOD, *delay_off);
+	rt73usb_register_write(led->rt2x00dev, MAC_CSR14, reg);
+
+	return 0;
+}
 #endif /* CONFIG_RT73USB_LEDS */
 
 /*
@@ -1006,11 +1013,6 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt73usb_register_write(rt2x00dev, MAC_CSR13, 0x00007f00);
 
-	rt73usb_register_read(rt2x00dev, MAC_CSR14, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR14_ON_PERIOD, 70);
-	rt2x00_set_field32(&reg, MAC_CSR14_OFF_PERIOD, 30);
-	rt73usb_register_write(rt2x00dev, MAC_CSR14, reg);
-
 	/*
 	 * Invalidate all Shared Keys (SEC_CSR0),
 	 * and clear the Shared key Cipher algorithms (SEC_CSR1 & SEC_CSR5)
@@ -1627,19 +1629,30 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT73USB_LEDS
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED, &eeprom);
 
-	switch (value) {
-	case LED_MODE_TXRX_ACTIVITY:
-	case LED_MODE_ASUS:
-	case LED_MODE_ALPHA:
-	case LED_MODE_DEFAULT:
-		rt2x00dev->led_flags =
-		    LED_SUPPORT_RADIO | LED_SUPPORT_ASSOC;
-		break;
-	case LED_MODE_SIGNAL_STRENGTH:
-		rt2x00dev->led_flags =
-		    LED_SUPPORT_RADIO | LED_SUPPORT_ASSOC |
-		    LED_SUPPORT_QUALITY;
-		break;
+	rt2x00dev->led_radio.rt2x00dev = rt2x00dev;
+	rt2x00dev->led_radio.type = LED_TYPE_RADIO;
+	rt2x00dev->led_radio.led_dev.brightness_set =
+	    rt73usb_brightness_set;
+	rt2x00dev->led_radio.led_dev.blink_set =
+	    rt73usb_blink_set;
+	rt2x00dev->led_radio.flags = LED_INITIALIZED;
+
+	rt2x00dev->led_assoc.rt2x00dev = rt2x00dev;
+	rt2x00dev->led_assoc.type = LED_TYPE_ASSOC;
+	rt2x00dev->led_assoc.led_dev.brightness_set =
+	    rt73usb_brightness_set;
+	rt2x00dev->led_assoc.led_dev.blink_set =
+	    rt73usb_blink_set;
+	rt2x00dev->led_assoc.flags = LED_INITIALIZED;
+
+	if (value == LED_MODE_SIGNAL_STRENGTH) {
+		rt2x00dev->led_qual.rt2x00dev = rt2x00dev;
+		rt2x00dev->led_radio.type = LED_TYPE_QUALITY;
+		rt2x00dev->led_qual.led_dev.brightness_set =
+		    rt73usb_brightness_set;
+		rt2x00dev->led_qual.led_dev.blink_set =
+		    rt73usb_blink_set;
+		rt2x00dev->led_qual.flags = LED_INITIALIZED;
 	}
 
 	rt2x00_set_field16(&rt2x00dev->led_mcu_reg, MCU_LEDCS_LED_MODE, value);
@@ -2040,7 +2053,6 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.link_stats		= rt73usb_link_stats,
 	.reset_tuner		= rt73usb_reset_tuner,
 	.link_tuner		= rt73usb_link_tuner,
-	.led_brightness		= rt73usb_led_brightness,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
-- 
1.5.4.5

