Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:35309 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbXE1Qm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 12:42:29 -0400
Message-Id: <20070528164202.620537050@localhost>
References: <20070528163845.448090722@localhost>
Date: Mon, 28 May 2007 09:38:49 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] hostap: Remove driver version number
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver version number has not been updated since the driver was
included in the main kernel tree and there is no plan on updating this
in the future either. At this point, the only correct way to refer to
the version is to use the kernel version. The 0.4.4 version is
confusing since there are external version with higher version number
even though they are not actually any newer than the in-tree version.

Let's get rid of the version number in the kernel tree in order to
avoid this kind of confusion.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: linux-2.6/drivers/net/wireless/hostap/hostap_config.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_config.h
+++ linux-2.6/drivers/net/wireless/hostap/hostap_config.h
@@ -1,8 +1,6 @@
 #ifndef HOSTAP_CONFIG_H
 #define HOSTAP_CONFIG_H
 
-#define PRISM2_VERSION "0.4.4-kernel"
-
 /* In the previous versions of Host AP driver, support for user space version
  * of IEEE 802.11 management (hostapd) used to be disabled in the default
  * configuration. From now on, support for hostapd is always included and it is
Index: linux-2.6/drivers/net/wireless/hostap/hostap_cs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_cs.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_cs.c
@@ -22,7 +22,6 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static dev_info_t dev_info = "hostap_cs";
 
 MODULE_AUTHOR("Jouni Malinen");
@@ -30,7 +29,6 @@ MODULE_DESCRIPTION("Support for Intersil
 		   "cards (PC Card).");
 MODULE_SUPPORTED_DEVICE("Intersil Prism2-based WLAN cards (PC Card)");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(PRISM2_VERSION);
 
 
 static int ignore_cis_vcc;
@@ -910,14 +908,12 @@ static struct pcmcia_driver hostap_drive
 
 static int __init init_prism2_pccard(void)
 {
-	printk(KERN_INFO "%s: %s\n", dev_info, version);
 	return pcmcia_register_driver(&hostap_driver);
 }
 
 static void __exit exit_prism2_pccard(void)
 {
 	pcmcia_unregister_driver(&hostap_driver);
-	printk(KERN_INFO "%s: Driver unloaded\n", dev_info);
 }
 
 
Index: linux-2.6/drivers/net/wireless/hostap/hostap_ioctl.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_ioctl.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -3893,8 +3893,6 @@ static void prism2_get_drvinfo(struct ne
 	local = iface->local;
 
 	strncpy(info->driver, "hostap", sizeof(info->driver) - 1);
-	strncpy(info->version, PRISM2_VERSION,
-		sizeof(info->version) - 1);
 	snprintf(info->fw_version, sizeof(info->fw_version) - 1,
 		 "%d.%d.%d", (local->sta_fw_ver >> 16) & 0xff,
 		 (local->sta_fw_ver >> 8) & 0xff,
Index: linux-2.6/drivers/net/wireless/hostap/hostap_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_main.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_main.c
@@ -37,7 +37,6 @@
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP common routines");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(PRISM2_VERSION);
 
 #define TX_TIMEOUT (2 * HZ)
 
Index: linux-2.6/drivers/net/wireless/hostap/hostap_pci.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_pci.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_pci.c
@@ -20,7 +20,6 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static char *dev_info = "hostap_pci";
 
 
@@ -29,7 +28,6 @@ MODULE_DESCRIPTION("Support for Intersil
 		   "PCI cards.");
 MODULE_SUPPORTED_DEVICE("Intersil Prism2.5-based WLAN PCI cards");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(PRISM2_VERSION);
 
 
 /* struct local_info::hw_priv */
@@ -462,8 +460,6 @@ static struct pci_driver prism2_pci_drv_
 
 static int __init init_prism2_pci(void)
 {
-	printk(KERN_INFO "%s: %s\n", dev_info, version);
-
 	return pci_register_driver(&prism2_pci_drv_id);
 }
 
@@ -471,7 +467,6 @@ static int __init init_prism2_pci(void)
 static void __exit exit_prism2_pci(void)
 {
 	pci_unregister_driver(&prism2_pci_drv_id);
-	printk(KERN_INFO "%s: Driver unloaded\n", dev_info);
 }
 
 
Index: linux-2.6/drivers/net/wireless/hostap/hostap_plx.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_plx.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_plx.c
@@ -23,7 +23,6 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static char *dev_info = "hostap_plx";
 
 
@@ -32,7 +31,6 @@ MODULE_DESCRIPTION("Support for Intersil
 		   "cards (PLX).");
 MODULE_SUPPORTED_DEVICE("Intersil Prism2-based WLAN cards (PLX)");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(PRISM2_VERSION);
 
 
 static int ignore_cis;
@@ -623,8 +621,6 @@ static struct pci_driver prism2_plx_drv_
 
 static int __init init_prism2_plx(void)
 {
-	printk(KERN_INFO "%s: %s\n", dev_info, version);
-
 	return pci_register_driver(&prism2_plx_drv_id);
 }
 
@@ -632,7 +628,6 @@ static int __init init_prism2_plx(void)
 static void __exit exit_prism2_plx(void)
 {
 	pci_unregister_driver(&prism2_plx_drv_id);
-	printk(KERN_INFO "%s: Driver unloaded\n", dev_info);
 }
 
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
