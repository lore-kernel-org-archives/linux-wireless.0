Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42605 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab2K0A01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 19:26:27 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 09/15] bcma: register watchdog driver
Date: Tue, 27 Nov 2012 01:25:19 +0100
Message-Id: <1353975925-32056-10-git-send-email-hauke@hauke-m.de> (sfid-20121127_012631_180059_1084C384)
In-Reply-To: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
References: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register the watchdog driver to the system if this is a SoC. Using the
watchdog on a non SoC device, like a PCIe card, will make the PCIe
card die when the timeout expired, but starting it again is not
supported by bcma.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h                 |    2 ++
 drivers/bcma/driver_chipcommon.c            |   22 ++++++++++++++++++++++
 drivers/bcma/main.c                         |    8 ++++++++
 include/linux/bcma/bcma_driver_chipcommon.h |    3 +++
 4 files changed, 35 insertions(+)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 169fc58..bcb830e 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -84,6 +84,8 @@ extern void __exit bcma_host_pci_exit(void);
 /* driver_pci.c */
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
 
+extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
+
 #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
 bool __devinit bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc);
 void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 1172226..d017f25 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -12,6 +12,7 @@
 #include "bcma_private.h"
 #include <linux/bcm47xx_wdt.h>
 #include <linux/export.h>
+#include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
 
 static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
@@ -87,6 +88,27 @@ static int bcma_chipco_watchdog_ticks_per_ms(struct bcma_drv_cc *cc)
 	}
 }
 
+int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc)
+{
+	struct bcm47xx_wdt wdt = {};
+	struct platform_device *pdev;
+
+	wdt.driver_data = cc;
+	wdt.timer_set = bcma_chipco_watchdog_timer_set_wdt;
+	wdt.timer_set_ms = bcma_chipco_watchdog_timer_set_ms_wdt;
+	wdt.max_timer_ms = bcma_chipco_watchdog_get_max_timer(cc) / cc->ticks_per_ms;
+
+	pdev = platform_device_register_data(NULL, "bcm47xx-wdt",
+					     cc->core->bus->num, &wdt,
+					     sizeof(wdt));
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	cc->watchdog = pdev;
+
+	return 0;
+}
+
 void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 {
 	if (cc->early_setup_done)
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index a971889..debd4f1 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -165,6 +165,12 @@ static int bcma_register_cores(struct bcma_bus *bus)
 	}
 #endif
 
+	if (bus->hosttype == BCMA_HOSTTYPE_SOC) {
+		err = bcma_chipco_watchdog_register(&bus->drv_cc);
+		if (err)
+			bcma_err(bus, "Error registering watchdog driver\n");
+	}
+
 	return 0;
 }
 
@@ -177,6 +183,8 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
 		if (core->dev_registered)
 			device_unregister(&core->dev);
 	}
+	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
+		platform_device_unregister(bus->drv_cc.watchdog);
 }
 
 int __devinit bcma_bus_register(struct bcma_bus *bus)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 2f9b014..e513591 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -1,6 +1,8 @@
 #ifndef LINUX_BCMA_DRIVER_CC_H_
 #define LINUX_BCMA_DRIVER_CC_H_
 
+#include <linux/platform_device.h>
+
 /** ChipCommon core registers. **/
 #define BCMA_CC_ID			0x0000
 #define  BCMA_CC_ID_ID			0x0000FFFF
@@ -571,6 +573,7 @@ struct bcma_drv_cc {
 	struct bcma_serial_port serial_ports[4];
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 	u32 ticks_per_ms;
+	struct platform_device *watchdog;
 };
 
 /* Register access */
-- 
1.7.10.4

