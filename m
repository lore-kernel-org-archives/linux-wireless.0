Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51586 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1EDTmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 15:42:47 -0400
Received: by eyx24 with SMTP id 24so461576eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 12:42:46 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Initial support for RT5370 USB devices.
Date: Wed, 4 May 2011 21:41:36 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201105042141.37135.IvDoorn@gmail.com> (sfid-20110504_214251_580285_433E1532)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Add necessary RF chipset define and basic support for these devices.

Tested-by: Juan Carlos Garza <juancarlosgarza@gmail.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |   11 ++++++++++-
 drivers/net/wireless/rt2x00/rt2800.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 ++++-
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++++++++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index c457731..9def1e5 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -93,7 +93,7 @@ config RT2800PCI_RT35XX
 	  intended for testers and developers.
 
 config RT2800PCI_RT53XX
-       bool "rt2800-pci - Include support for rt53xx devices (EXPERIMENTAL)"
+       bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
        depends on EXPERIMENTAL
        default y
        ---help---
@@ -163,6 +163,15 @@ config RT2800USB_RT35XX
 	  Support for these devices is non-functional at the moment and is
 	  intended for testers and developers.
 
+config RT2800USB_RT53XX
+       bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       default y
+       ---help---
+         This adds support for rt53xx wireless chipset family to the
+         rt2800pci driver.
+         Supported chips: RT5370
+
 config RT2800USB_UNKNOWN
 	bool "rt2800usb - Include support for unknown (USB) devices"
 	default n
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 3b3d851..47a04d2 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -51,6 +51,7 @@
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
  * RF3853 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
+ * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
  */
 #define RF2820				0x0001
@@ -66,6 +67,7 @@
 #define RF3320				0x000b
 #define RF3322				0x000c
 #define RF3853				0x000d
+#define RF5370				0x5370
 #define RF5390				0x5390
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6ed646a..93fb674 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1751,7 +1751,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(rt2x00dev, RF3052) ||
 	    rt2x00_rf(rt2x00dev, RF3320))
 		rt2800_config_channel_rf3xxx(rt2x00dev, conf, rf, info);
-	else if (rt2x00_rf(rt2x00dev, RF5390))
+	else if (rt2x00_rf(rt2x00dev, RF5370) ||
+		 rt2x00_rf(rt2x00dev, RF5390))
 		rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
 	else
 		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
@@ -3686,6 +3687,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rf(rt2x00dev, RF3022) &&
 	    !rt2x00_rf(rt2x00dev, RF3052) &&
 	    !rt2x00_rf(rt2x00dev, RF3320) &&
+	    !rt2x00_rf(rt2x00dev, RF5370) &&
 	    !rt2x00_rf(rt2x00dev, RF5390)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
@@ -3988,6 +3990,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF3021) ||
 		   rt2x00_rf(rt2x00dev, RF3022) ||
 		   rt2x00_rf(rt2x00dev, RF3320) ||
+		   rt2x00_rf(rt2x00dev, RF5370) ||
 		   rt2x00_rf(rt2x00dev, RF5390)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 0eb44cf..ba82c97 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1000,6 +1000,14 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0284) },
 #endif
+#ifdef CONFIG_RT2800USB_RT53XX
+	/* Azurewave */
+	{ USB_DEVICE(0x13d3, 0x3329) },
+	{ USB_DEVICE(0x13d3, 0x3365) },
+	/* Ralink */
+	{ USB_DEVICE(0x148f, 0x5370) },
+	{ USB_DEVICE(0x148f, 0x5372) },
+#endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
 	 * Unclear what kind of devices these are (they aren't supported by the
-- 
1.7.2.3

