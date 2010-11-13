Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47304 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0KMSOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:10 -0500
Received: by eye27 with SMTP id 27so2445882eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:09 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/9] rt2x00: Add initial support for RT3370/RT3390 devices.
Date: Sat, 13 Nov 2010 19:09:50 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com>
In-Reply-To: <201011131908.15595.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <201011131909.50885.IvDoorn@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Modified from Eddy's patch by adding the RT3370 USB support as well.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Eddy Tsai <Eddy_Tsai@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |   22 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |    9 ++++++---
 drivers/net/wireless/rt2x00/rt2800pci.c |    3 +++
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++++---
 5 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index eea1ef2..f0f0152 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -96,6 +96,17 @@ config RT2800PCI_RT30XX
 	  Support for these devices is non-functional at the moment and is
 	  intended for testers and developers.
 
+config RT2800PCI_RT33XX
+	bool "rt2800pci - Include support for rt33xx (PCI/PCIe/PCMCIA) devices"
+	default n
+	---help---
+	  This adds support for rt33xx wireless chipset family to the
+	  rt2800pci driver.
+	  Supported chips: RT3390
+
+	  Support for these devices is non-functional at the moment and is
+	  intended for testers and developers.
+
 config RT2800PCI_RT35XX
 	bool "rt2800pci - Include support for rt35xx (PCI/PCIe/PCMCIA) devices"
 	default n
@@ -165,6 +176,17 @@ config RT2800USB_RT30XX
 	  Support for these devices is non-functional at the moment and is
 	  intended for testers and developers.
 
+config RT2800USB_RT33XX
+	bool "rt2800usb - Include support for rt33xx (USB) devices"
+	default n
+	---help---
+	  This adds support for rt33xx wireless chipset family to the
+	  rt2800usb driver.
+	  Supported chips: RT3370
+
+	  Support for these devices is non-functional at the moment and is
+	  intended for testers and developers.
+
 config RT2800USB_RT35XX
 	bool "rt2800usb - Include support for rt35xx (USB) devices"
 	default n
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 002224c..a81c437 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -47,6 +47,7 @@
  * RF3021 2.4G 1T2R
  * RF3022 2.4G 2T2R
  * RF3052 2.4G 2T2R
+ * RF3320 2.4G 1T1R
  */
 #define RF2820				0x0001
 #define RF2850				0x0002
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b5d2eba..ce8df66 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1544,7 +1544,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(rt2x00dev, RF3020) ||
 	    rt2x00_rf(rt2x00dev, RF3021) ||
 	    rt2x00_rf(rt2x00dev, RF3022) ||
-	    rt2x00_rf(rt2x00dev, RF3052))
+	    rt2x00_rf(rt2x00dev, RF3052) ||
+	    rt2x00_rf(rt2x00dev, RF3320))
 		rt2800_config_channel_rf3xxx(rt2x00dev, conf, rf, info);
 	else
 		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
@@ -3012,7 +3013,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rf(rt2x00dev, RF2020) &&
 	    !rt2x00_rf(rt2x00dev, RF3021) &&
 	    !rt2x00_rf(rt2x00dev, RF3022) &&
-	    !rt2x00_rf(rt2x00dev, RF3052)) {
+	    !rt2x00_rf(rt2x00dev, RF3052) &&
+	    !rt2x00_rf(rt2x00dev, RF3320)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -3276,7 +3278,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rf(rt2x00dev, RF3020) ||
 		   rt2x00_rf(rt2x00dev, RF2020) ||
 		   rt2x00_rf(rt2x00dev, RF3021) ||
-		   rt2x00_rf(rt2x00dev, RF3022)) {
+		   rt2x00_rf(rt2x00dev, RF3022) ||
+		   rt2x00_rf(rt2x00dev, RF3320)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
 	} else if (rt2x00_rf(rt2x00dev, RF3052)) {
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 5f3a018..6642f13 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1051,6 +1051,9 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x3092), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1462, 0x891a), PCI_DEVICE_DATA(&rt2800pci_ops) },
 #endif
+#ifdef CONFIG_RT2800PCI_RT33XX
+	{ PCI_DEVICE(0x1814, 0x3390), PCI_DEVICE_DATA(&rt2800pci_ops) },
+#endif
 #ifdef CONFIG_RT2800PCI_RT35XX
 	{ PCI_DEVICE(0x1814, 0x3060), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 389ecba..61852c5 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -839,6 +839,13 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x5a57, 0x0283), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },
 #endif
+#ifdef CONFIG_RT2800USB_RT33XX
+	/* Ralink */
+	{ USB_DEVICE(0x148f, 0x3370), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x148f, 0x8070), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Sitecom */
+	{ USB_DEVICE(0x0df6, 0x0050), USB_DEVICE_DATA(&rt2800usb_ops) },
+#endif
 #ifdef CONFIG_RT2800USB_RT35XX
 	/* Allwin */
 	{ USB_DEVICE(0x8516, 0x3572), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -851,12 +858,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* I-O DATA */
 	{ USB_DEVICE(0x04bb, 0x0944), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ralink */
-	{ USB_DEVICE(0x148f, 0x3370), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x3572), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x148f, 0x8070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x0050), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0284), USB_DEVICE_DATA(&rt2800usb_ops) },
 #endif
-- 
1.7.2.3

