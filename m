Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44748 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751382AbYBIGXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2008 01:23:33 -0500
Date: Sat, 9 Feb 2008 07:20:43 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] b43legacy: Add driver load messages
Message-ID: <20080209072043.05af8bd5@morte> (sfid-20080209_062338_030058_20F7B7EC)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds printk messages with basic information about the driver being loaded.
This information includes a summary of the compiled-in features, which
simplifies bug-reporting and debugging a lot.
Also a firmware ID is printed. This is a unique identifier blob for a specific
version of the firmware. This ID is attached to a specific version of the firmware
blob in b43-fwcutter (see fwcutter git).
This helps users to select the right firmware for their device.
This also makes it possible to use automated scripts to fetch and extract the right
firmware for the driver. (The script will grep the .ko for the "Firmware-ID: xxx" string.)
While the driver might still support other versions of the firmware for backward
compatibility, this will always print out the officially supported version, which
people _should_ use.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
@@ -23,6 +23,10 @@
 #include "phy.h"
 
 
+/* The unique identifier of the firmware that's officially supported by this
+ * driver version. */
+#define B43legacy_SUPPORTED_FIRMWARE_ID	"FW10"
+
 #define B43legacy_IRQWAIT_MAX_RETRIES	20
 
 #define B43legacy_RX_MAX_SSI		60 /* best guess at max ssi */
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -3,7 +3,7 @@
  *  Broadcom B43legacy wireless driver
  *
  *  Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>
- *  Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
+ *  Copyright (c) 2005-2008 Stefano Brivio <stefano.brivio@polimi.it>
  *  Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
  *  Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
  *  Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
@@ -3847,6 +3847,32 @@ static struct ssb_driver b43legacy_ssb_d
 	.resume		= b43legacy_resume,
 };
 
+static void b43legacy_print_driverinfo(void)
+{
+	const char *feat_pci = "", *feat_leds = "", *feat_rfkill = "",
+		   *feat_pio = "", *feat_dma = "";
+
+#ifdef CONFIG_B43LEGACY_PCI_AUTOSELECT
+	feat_pci = "P";
+#endif
+#ifdef CONFIG_B43LEGACY_LEDS
+	feat_leds = "L";
+#endif
+#ifdef CONFIG_B43LEGACY_RFKILL
+	feat_rfkill = "R";
+#endif
+#ifdef CONFIG_B43LEGACY_PIO
+	feat_pio = "I";
+#endif
+#ifdef CONFIG_B43LEGACY_DMA
+	feat_dma = "D";
+#endif
+	printk(KERN_INFO "Broadcom 43xx driver loaded "
+	       "[ Features: %s%s%s%s%s, Firmware-ID: "
+	       B43legacy_SUPPORTED_FIRMWARE_ID " ]\n",
+	       feat_pci, feat_leds, feat_rfkill, feat_pio, feat_dma);
+}
+
 static int __init b43legacy_init(void)
 {
 	int err;
@@ -3857,6 +3883,8 @@ static int __init b43legacy_init(void)
 	if (err)
 		goto err_dfs_exit;
 
+	b43legacy_print_driverinfo();
+
 	return err;
 
 err_dfs_exit:


-- 
Ciao
Stefano
