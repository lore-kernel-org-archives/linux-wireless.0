Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37061
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbXHNSN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:13:57 -0400
Message-Id: <20070814181214.144680000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:15 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 2/9] b43: Remove PCI to SSB bridge code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be added to ssb

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-12 16:38:52.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-12 20:12:24.000000000 +0200
@@ -104,7 +104,11 @@ module_param_named(hwpctl, modparam_hwpc
 MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
 
 static const struct ssb_device_id b43_ssb_tbl[] = {
-	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, SSB_ANY_REV),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
 	SSB_DEVTABLE_END
 };
 
@@ -3959,67 +3963,35 @@ static int b43_resume(struct ssb_device 
 
 #else /* CONFIG_PM */
 # define b43_suspend	NULL
-# define b43_resume		NULL
+# define b43_resume	NULL
 #endif /* CONFIG_PM */
 
 static struct ssb_driver b43_ssb_driver = {
-	.name = KBUILD_MODNAME,
-	.id_table = b43_ssb_tbl,
-	.probe = b43_probe,
-	.remove = b43_remove,
-	.suspend = b43_suspend,
-	.resume = b43_resume,
+	.name		= KBUILD_MODNAME,
+	.id_table	= b43_ssb_tbl,
+	.probe		= b43_probe,
+	.remove		= b43_remove,
+	.suspend	= b43_suspend,
+	.resume		= b43_resume,
 };
 
-#ifdef CONFIG_B43_PCI
-/* The PCI frontend stub */
-static const struct pci_device_id b43_pci_tbl[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325)},
-	{0},
-};
-
-MODULE_DEVICE_TABLE(pci, b43_pci_tbl);
-
-static struct pci_driver b43_pci_driver = {
-	.name = "b43-pci",
-	.id_table = b43_pci_tbl,
-};
-#endif /* CONFIG_B43_PCI */
-
 static int __init b43_init(void)
 {
 	int err;
 
 	b43_debugfs_init();
-#ifdef CONFIG_B43_PCI
-	err = ssb_pcihost_register(&b43_pci_driver);
-	if (err)
-		goto err_dfs_exit;
-#endif
 	err = b43_pcmcia_init();
 	if (err)
-		goto err_pci_exit;
+		goto err_dfs_exit;
 	err = ssb_driver_register(&b43_ssb_driver);
 	if (err)
 		goto err_pcmcia_exit;
 
 	return err;
 
-      err_pcmcia_exit:
+err_pcmcia_exit:
 	b43_pcmcia_exit();
-      err_pci_exit:
-#ifdef CONFIG_B43_PCI
-	ssb_pcihost_unregister(&b43_pci_driver);
-#endif
-      err_dfs_exit:
+err_dfs_exit:
 	b43_debugfs_exit();
 	return err;
 }
@@ -4028,11 +4000,8 @@ static void __exit b43_exit(void)
 {
 	ssb_driver_unregister(&b43_ssb_driver);
 	b43_pcmcia_exit();
-#ifdef CONFIG_B43_PCI
-	ssb_pcihost_unregister(&b43_pci_driver);
-#endif
 	b43_debugfs_exit();
 }
 
 module_init(b43_init)
-    module_exit(b43_exit)
+module_exit(b43_exit)

-- 

