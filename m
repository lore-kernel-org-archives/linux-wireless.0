Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34900 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYBHXUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 18:20:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add driver load messages
Date: Sat, 9 Feb 2008 00:18:35 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Message-Id: <200802090018.35592.mb@bu3sch.de> (sfid-20080208_232012_134071_E39486D5)
Content-Type: text/plain;
  charset="us-ascii"
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
firmware for the driver. (the script will grep the .ko for the "Firmware-ID: xxx" string.
While the driver might still support other versions of the firmware for backward
compatibility, this will always print out the officially supported version, which
people _should_ use.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, as this has a negative chance of introducing regressions, I'd like
to have it in 2.6.25, even if it's not strictly a bugfix.
Stefano, we should port this to legacy. See fwcutter git for the ID I assigned
to the legacy firmware blob.

Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2008-02-08 23:28:23.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2008-02-09 00:05:57.000000000 +0100
@@ -11,12 +11,18 @@
 #include "debugfs.h"
 #include "leds.h"
 #include "rfkill.h"
 #include "lo.h"
 #include "phy.h"
 
+
+/* The unique identifier of the firmware that's officially supported by
+ * this driver version. */
+#define B43_SUPPORTED_FIRMWARE_ID	"FW13"
+
+
 #ifdef CONFIG_B43_DEBUG
 # define B43_DEBUG	1
 #else
 # define B43_DEBUG	0
 #endif
 
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-02-08 23:28:23.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-02-09 00:17:12.000000000 +0100
@@ -4190,23 +4190,51 @@ static struct ssb_driver b43_ssb_driver 
 	.probe		= b43_probe,
 	.remove		= b43_remove,
 	.suspend	= b43_suspend,
 	.resume		= b43_resume,
 };
 
+static void b43_print_driverinfo(void)
+{
+	const char *feat_pci = "", *feat_pcmcia = "", *feat_nphy = "",
+		   *feat_leds = "", *feat_rfkill = "";
+
+#ifdef CONFIG_B43_PCI_AUTOSELECT
+	feat_pci = "P";
+#endif
+#ifdef CONFIG_B43_PCMCIA
+	feat_pcmcia = "M";
+#endif
+#ifdef CONFIG_B43_NPHY
+	feat_nphy = "N";
+#endif
+#ifdef CONFIG_B43_LEDS
+	feat_leds = "L";
+#endif
+#ifdef CONFIG_B43_RFKILL
+	feat_rfkill = "R";
+#endif
+	printk(KERN_INFO "Broadcom 43xx driver loaded "
+	       "[ Features: %s%s%s%s%s, Firmware-ID: "
+	       B43_SUPPORTED_FIRMWARE_ID " ]\n",
+	       feat_pci, feat_pcmcia, feat_nphy,
+	       feat_leds, feat_rfkill);
+}
+
 static int __init b43_init(void)
 {
 	int err;
 
 	b43_debugfs_init();
 	err = b43_pcmcia_init();
 	if (err)
 		goto err_dfs_exit;
 	err = ssb_driver_register(&b43_ssb_driver);
 	if (err)
 		goto err_pcmcia_exit;
+	b43_print_driverinfo();
 
 	return err;
 
 err_pcmcia_exit:
 	b43_pcmcia_exit();
 err_dfs_exit:
