Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32891 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbJOFXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 01:23:37 -0400
Received: by wijp11 with SMTP id p11so11740784wij.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 22:23:36 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] ssb: pick PCMCIA host code support from b43 driver
Date: Thu, 15 Oct 2015 07:23:25 +0200
Message-Id: <1444886605-17010-1-git-send-email-zajec5@gmail.com> (sfid-20151015_072404_217121_1C2C13DD)
In-Reply-To: <1444850346-23085-1-git-send-email-zajec5@gmail.com>
References: <1444850346-23085-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb bus can be found on various "host" devices like PCI/PCMCIA/SDIO.
Every ssb bus contains cores AKA devices.
The main idea is to have ssb driver scan/initialize bus and register
ready-to-use cores. This way ssb drivers can operate on a single core
mostly ignoring underlaying details.

For some reason PCMCIA support was split between ssb and b43. We got
PCMCIA host device probing in b43, then bus scanning in ssb and then
wireless core probing back in b43. The truth is it's very unlikely we
will ever see PCMCIA ssb device with no 802.11 core but I still don't
see any advantage of the current architecture.

With proposed change we get the same functionality with a simpler
architecture, less Kconfig symbols, one killed EXPORT and hopefully
cleaner b43. Since b43 supports both: ssb & bcma I prefer to keep ssb
specific code in ssb driver.

This mostly moves code from b43's pcmcia.c to bridge_pcmcia_80211.c. We
already use similar solution with b43_pci_bridge.c. I didn't use "b43"
in name of this new file as in theory any driver can operate on wireless
core.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Final (from RFC):
1) Use bridge_pcmcia_80211.c

RESEND:
1) Pass -M40% to make git notice rename

V2:
1) Add missing #include <linux/module.h> (fixes mn10300 build)
Thanks Intel for your test robot!
---
 drivers/net/wireless/b43/Kconfig                   |  20 ----
 drivers/net/wireless/b43/Makefile                  |   1 -
 drivers/net/wireless/b43/main.c                    |   9 +-
 drivers/net/wireless/b43/pcmcia.h                  |  20 ----
 drivers/ssb/Makefile                               |   2 +-
 .../b43/pcmcia.c => ssb/bridge_pcmcia_80211.c}     | 101 +++++++++------------
 drivers/ssb/main.c                                 |   8 +-
 drivers/ssb/ssb_private.h                          |   9 ++
 8 files changed, 60 insertions(+), 110 deletions(-)
 delete mode 100644 drivers/net/wireless/b43/pcmcia.h
 rename drivers/{net/wireless/b43/pcmcia.c => ssb/bridge_pcmcia_80211.c} (49%)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 759fb8d..fba8560 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -71,26 +71,6 @@ config B43_PCICORE_AUTOSELECT
 	select SSB_DRIVER_PCICORE
 	default y
 
-config B43_PCMCIA
-	bool "Broadcom 43xx PCMCIA device support"
-	depends on B43 && B43_SSB && SSB_PCMCIAHOST_POSSIBLE
-	select SSB_PCMCIAHOST
-	---help---
-	  Broadcom 43xx PCMCIA device support.
-
-	  Support for 16bit PCMCIA devices.
-	  Please note that most PC-CARD devices are _NOT_ 16bit PCMCIA
-	  devices, but 32bit CardBUS devices. CardBUS devices are supported
-	  out of the box by b43.
-
-	  With this config option you can drive b43 cards in
-	  CompactFlash formfactor in a PCMCIA adaptor.
-	  CF b43 cards can sometimes be found in handheld PCs.
-
-	  It's safe to select Y here, even if you don't have a B43 PCMCIA device.
-
-	  If unsure, say N.
-
 config B43_SDIO
 	bool "Broadcom 43xx SDIO device support"
 	depends on B43 && B43_SSB && SSB_SDIOHOST_POSSIBLE
diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index c624d4d..ddc4df4 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -21,7 +21,6 @@ b43-y				+= pio.o
 b43-y				+= rfkill.o
 b43-y				+= ppr.o
 b43-$(CONFIG_B43_LEDS)		+= leds.o
-b43-$(CONFIG_B43_PCMCIA)	+= pcmcia.o
 b43-$(CONFIG_B43_SDIO)		+= sdio.o
 b43-$(CONFIG_B43_DEBUG)		+= debugfs.o
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2849070..ba792ae09 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -56,7 +56,6 @@
 #include "sysfs.h"
 #include "xmit.h"
 #include "lo.h"
-#include "pcmcia.h"
 #include "sdio.h"
 #include <linux/mmc/sdio_func.h>
 
@@ -5849,12 +5848,9 @@ static int __init b43_init(void)
 	int err;
 
 	b43_debugfs_init();
-	err = b43_pcmcia_init();
-	if (err)
-		goto err_dfs_exit;
 	err = b43_sdio_init();
 	if (err)
-		goto err_pcmcia_exit;
+		goto err_dfs_exit;
 #ifdef CONFIG_B43_BCMA
 	err = bcma_driver_register(&b43_bcma_driver);
 	if (err)
@@ -5877,8 +5873,6 @@ err_bcma_driver_exit:
 err_sdio_exit:
 #endif
 	b43_sdio_exit();
-err_pcmcia_exit:
-	b43_pcmcia_exit();
 err_dfs_exit:
 	b43_debugfs_exit();
 	return err;
@@ -5893,7 +5887,6 @@ static void __exit b43_exit(void)
 	bcma_driver_unregister(&b43_bcma_driver);
 #endif
 	b43_sdio_exit();
-	b43_pcmcia_exit();
 	b43_debugfs_exit();
 }
 
diff --git a/drivers/net/wireless/b43/pcmcia.h b/drivers/net/wireless/b43/pcmcia.h
deleted file mode 100644
index 85f120a..0000000
--- a/drivers/net/wireless/b43/pcmcia.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef B43_PCMCIA_H_
-#define B43_PCMCIA_H_
-
-#ifdef CONFIG_B43_PCMCIA
-
-int b43_pcmcia_init(void);
-void b43_pcmcia_exit(void);
-
-#else /* CONFIG_B43_PCMCIA */
-
-static inline int b43_pcmcia_init(void)
-{
-	return 0;
-}
-static inline void b43_pcmcia_exit(void)
-{
-}
-
-#endif /* CONFIG_B43_PCMCIA */
-#endif /* B43_PCMCIA_H_ */
diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index b1ddc11..7daa03e 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -5,7 +5,7 @@ ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 
 # host support
 ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
-ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o
+ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o bridge_pcmcia_80211.o
 ssb-$(CONFIG_SSB_SDIOHOST)		+= sdio.o
 
 # built-in drivers
diff --git a/drivers/net/wireless/b43/pcmcia.c b/drivers/ssb/bridge_pcmcia_80211.c
similarity index 49%
rename from drivers/net/wireless/b43/pcmcia.c
rename to drivers/ssb/bridge_pcmcia_80211.c
index 55f2bd7..d70568e 100644
--- a/drivers/net/wireless/b43/pcmcia.c
+++ b/drivers/ssb/bridge_pcmcia_80211.c
@@ -1,27 +1,10 @@
 /*
-
-  Broadcom B43 wireless driver
-
-  Copyright (c) 2007 Michael Buesch <m@bues.ch>
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; see the file COPYING.  If not, write to
-  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
-  Boston, MA 02110-1301, USA.
-
-*/
-
-#include "pcmcia.h"
+ * Broadcom 43xx PCMCIA-SSB bridge module
+ *
+ * Copyright (c) 2007 Michael Buesch <m@bues.ch>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
 
 #include <linux/ssb/ssb.h>
 #include <linux/slab.h>
@@ -32,35 +15,17 @@
 #include <pcmcia/ds.h>
 #include <pcmcia/cisreg.h>
 
+#include "ssb_private.h"
 
-static const struct pcmcia_device_id b43_pcmcia_tbl[] = {
+static const struct pcmcia_device_id ssb_host_pcmcia_tbl[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
 	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x476),
 	PCMCIA_DEVICE_NULL,
 };
 
-MODULE_DEVICE_TABLE(pcmcia, b43_pcmcia_tbl);
-
-#ifdef CONFIG_PM
-static int b43_pcmcia_suspend(struct pcmcia_device *dev)
-{
-	struct ssb_bus *ssb = dev->priv;
-
-	return ssb_bus_suspend(ssb);
-}
-
-static int b43_pcmcia_resume(struct pcmcia_device *dev)
-{
-	struct ssb_bus *ssb = dev->priv;
-
-	return ssb_bus_resume(ssb);
-}
-#else /* CONFIG_PM */
-# define b43_pcmcia_suspend		NULL
-# define b43_pcmcia_resume		NULL
-#endif /* CONFIG_PM */
+MODULE_DEVICE_TABLE(pcmcia, ssb_host_pcmcia_tbl);
 
-static int b43_pcmcia_probe(struct pcmcia_device *dev)
+static int ssb_host_pcmcia_probe(struct pcmcia_device *dev)
 {
 	struct ssb_bus *ssb;
 	int err = -ENOMEM;
@@ -105,12 +70,11 @@ err_disable:
 err_kfree_ssb:
 	kfree(ssb);
 out_error:
-	printk(KERN_ERR "b43-pcmcia: Initialization failed (%d, %d)\n",
-	       res, err);
+	ssb_err("Initialization failed (%d, %d)\n", res, err);
 	return err;
 }
 
-static void b43_pcmcia_remove(struct pcmcia_device *dev)
+static void ssb_host_pcmcia_remove(struct pcmcia_device *dev)
 {
 	struct ssb_bus *ssb = dev->priv;
 
@@ -120,26 +84,45 @@ static void b43_pcmcia_remove(struct pcmcia_device *dev)
 	dev->priv = NULL;
 }
 
-static struct pcmcia_driver b43_pcmcia_driver = {
+#ifdef CONFIG_PM
+static int ssb_host_pcmcia_suspend(struct pcmcia_device *dev)
+{
+	struct ssb_bus *ssb = dev->priv;
+
+	return ssb_bus_suspend(ssb);
+}
+
+static int ssb_host_pcmcia_resume(struct pcmcia_device *dev)
+{
+	struct ssb_bus *ssb = dev->priv;
+
+	return ssb_bus_resume(ssb);
+}
+#else /* CONFIG_PM */
+# define ssb_host_pcmcia_suspend		NULL
+# define ssb_host_pcmcia_resume		NULL
+#endif /* CONFIG_PM */
+
+static struct pcmcia_driver ssb_host_pcmcia_driver = {
 	.owner		= THIS_MODULE,
-	.name		= "b43-pcmcia",
-	.id_table	= b43_pcmcia_tbl,
-	.probe		= b43_pcmcia_probe,
-	.remove		= b43_pcmcia_remove,
-	.suspend	= b43_pcmcia_suspend,
-	.resume		= b43_pcmcia_resume,
+	.name		= "ssb-pcmcia",
+	.id_table	= ssb_host_pcmcia_tbl,
+	.probe		= ssb_host_pcmcia_probe,
+	.remove		= ssb_host_pcmcia_remove,
+	.suspend	= ssb_host_pcmcia_suspend,
+	.resume		= ssb_host_pcmcia_resume,
 };
 
 /*
  * These are not module init/exit functions!
  * The module_pcmcia_driver() helper cannot be used here.
  */
-int b43_pcmcia_init(void)
+int ssb_host_pcmcia_init(void)
 {
-	return pcmcia_register_driver(&b43_pcmcia_driver);
+	return pcmcia_register_driver(&ssb_host_pcmcia_driver);
 }
 
-void b43_pcmcia_exit(void)
+void ssb_host_pcmcia_exit(void)
 {
-	pcmcia_unregister_driver(&b43_pcmcia_driver);
+	pcmcia_unregister_driver(&ssb_host_pcmcia_driver);
 }
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 8cf23a2..90ec6a0 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -897,7 +897,6 @@ int ssb_bus_pcmciabus_register(struct ssb_bus *bus,
 
 	return err;
 }
-EXPORT_SYMBOL(ssb_bus_pcmciabus_register);
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
 #ifdef CONFIG_SSB_SDIOHOST
@@ -1464,6 +1463,12 @@ static int __init ssb_modinit(void)
 		/* don't fail SSB init because of this */
 		err = 0;
 	}
+	err = ssb_host_pcmcia_init();
+	if (err) {
+		ssb_err("PCMCIA host initialization failed\n");
+		/* don't fail SSB init because of this */
+		err = 0;
+	}
 	err = ssb_gige_init();
 	if (err) {
 		ssb_err("SSB Broadcom Gigabit Ethernet driver initialization failed\n");
@@ -1481,6 +1486,7 @@ fs_initcall(ssb_modinit);
 static void __exit ssb_modexit(void)
 {
 	ssb_gige_exit();
+	ssb_host_pcmcia_exit();
 	b43_pci_ssb_bridge_exit();
 	bus_unregister(&ssb_bustype);
 }
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 8a2ebc8..93bb8f0 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -94,6 +94,8 @@ extern int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 extern int ssb_pcmcia_hardware_setup(struct ssb_bus *bus);
 extern void ssb_pcmcia_exit(struct ssb_bus *bus);
 extern int ssb_pcmcia_init(struct ssb_bus *bus);
+extern int ssb_host_pcmcia_init(void);
+extern void ssb_host_pcmcia_exit(void);
 extern const struct ssb_bus_ops ssb_pcmcia_ops;
 #else /* CONFIG_SSB_PCMCIAHOST */
 static inline int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
@@ -117,6 +119,13 @@ static inline int ssb_pcmcia_init(struct ssb_bus *bus)
 {
 	return 0;
 }
+static inline int ssb_host_pcmcia_init(void)
+{
+	return 0;
+}
+static inline void ssb_host_pcmcia_exit(void)
+{
+}
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
 /* sdio.c */
-- 
1.8.4.5

