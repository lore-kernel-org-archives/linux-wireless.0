Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34119 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYLTKCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:01 -0500
Received: by ewy10 with SMTP id 10so1457128ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:01:59 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 6/15] rt2x00: Add RFKILL support to rt2500usb and rt73usb
Date: Sat, 20 Dec 2008 10:55:57 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201054.54391.IvDoorn@gmail.com> <200812201055.34597.IvDoorn@gmail.com>
In-Reply-To: <200812201055.34597.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201055.58126.IvDoorn@gmail.com> (sfid-20081220_110210_253042_A1256324)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some very rare Ralink USB hardware exists which features
the RFKILL switch on the USB stick.
This patch adds the EEPROM check function to see if RFKILL
is supported and the polling function to rt2500usb and
rt73usb in order to support RFKILL for that hardware.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   21 +++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2500usb.h |    8 ++++++++
 drivers/net/wireless/rt2x00/rt73usb.c   |   21 +++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt73usb.h   |   13 +++++++++++++
 4 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 79f0771..ce76a87 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -280,6 +280,18 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
+#ifdef CONFIG_RT2X00_LIB_RFKILL
+static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
+{
+	u16 reg;
+
+	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
+	return rt2x00_get_field32(reg, MAC_CSR19_BIT7);
+}
+#else
+#define rt2500usb_rfkill_poll	NULL
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
+
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2500usb_brightness_set(struct led_classdev *led_cdev,
 				     enum led_brightness brightness)
@@ -1606,6 +1618,14 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
+	 * Detect if this device has an hardware controlled radio.
+	 */
+#ifdef CONFIG_RT2X00_LIB_RFKILL
+	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
+		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
+
+	/*
 	 * Check if the BBP tuning should be disabled.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
@@ -1911,6 +1931,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.uninitialize		= rt2x00usb_uninitialize,
 	.clear_entry		= rt2x00usb_clear_entry,
 	.set_device_state	= rt2500usb_set_device_state,
+	.rfkill_poll		= rt2500usb_rfkill_poll,
 	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
 	.link_tuner		= rt2500usb_link_tuner,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 4347dfd..e1f714e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -189,6 +189,14 @@
  * MAC_CSR19: GPIO control register.
  */
 #define MAC_CSR19			0x0426
+#define MAC_CSR19_BIT0			FIELD32(0x0001)
+#define MAC_CSR19_BIT1			FIELD32(0x0002)
+#define MAC_CSR19_BIT2			FIELD32(0x0004)
+#define MAC_CSR19_BIT3			FIELD32(0x0008)
+#define MAC_CSR19_BIT4			FIELD32(0x0010)
+#define MAC_CSR19_BIT5			FIELD32(0x0020)
+#define MAC_CSR19_BIT6			FIELD32(0x0040)
+#define MAC_CSR19_BIT7			FIELD32(0x0080)
 
 /*
  * MAC_CSR20: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 5992c8f..2268d5c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -186,6 +186,18 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
+#ifdef CONFIG_RT2X00_LIB_RFKILL
+static int rt73usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
+	return rt2x00_get_field32(reg, MAC_CSR13_BIT7);
+}
+#else
+#define rt73usb_rfkill_poll	NULL
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
+
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt73usb_brightness_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
@@ -1855,6 +1867,14 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags);
 
 	/*
+	 * Detect if this device has an hardware controlled radio.
+	 */
+#ifdef CONFIG_RT2X00_LIB_RFKILL
+	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
+		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
+
+	/*
 	 * Read frequency offset.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
@@ -2259,6 +2279,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.uninitialize		= rt2x00usb_uninitialize,
 	.clear_entry		= rt2x00usb_clear_entry,
 	.set_device_state	= rt73usb_set_device_state,
+	.rfkill_poll		= rt73usb_rfkill_poll,
 	.link_stats		= rt73usb_link_stats,
 	.reset_tuner		= rt73usb_reset_tuner,
 	.link_tuner		= rt73usb_link_tuner,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 46e1405..204bbd5 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -267,6 +267,19 @@ struct hw_pairwise_ta_entry {
  * MAC_CSR13: GPIO.
  */
 #define MAC_CSR13			0x3034
+#define MAC_CSR13_BIT0			FIELD32(0x00000001)
+#define MAC_CSR13_BIT1			FIELD32(0x00000002)
+#define MAC_CSR13_BIT2			FIELD32(0x00000004)
+#define MAC_CSR13_BIT3			FIELD32(0x00000008)
+#define MAC_CSR13_BIT4			FIELD32(0x00000010)
+#define MAC_CSR13_BIT5			FIELD32(0x00000020)
+#define MAC_CSR13_BIT6			FIELD32(0x00000040)
+#define MAC_CSR13_BIT7			FIELD32(0x00000080)
+#define MAC_CSR13_BIT8			FIELD32(0x00000100)
+#define MAC_CSR13_BIT9			FIELD32(0x00000200)
+#define MAC_CSR13_BIT10			FIELD32(0x00000400)
+#define MAC_CSR13_BIT11			FIELD32(0x00000800)
+#define MAC_CSR13_BIT12			FIELD32(0x00001000)
 
 /*
  * MAC_CSR14: LED control register.
-- 
1.5.6.1

