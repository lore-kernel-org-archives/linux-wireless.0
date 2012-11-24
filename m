Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36569 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2KXW0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 17:26:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wim@iguana.be,
	linux-watchdog@vger.kernel.org, castet.matthieu@free.fr,
	biblbroks@sezampro.rs, m@bues.ch, zajec5@gmail.com,
	linux-mips@linux-mips.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 15/15] ssb: register watchdog driver
Date: Sat, 24 Nov 2012 23:24:15 +0100
Message-Id: <1353795855-22236-16-git-send-email-hauke@hauke-m.de> (sfid-20121124_233122_136798_F9D8C861)
In-Reply-To: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
References: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register the watchdog driver to the system if this is a SoC. Using the
watchdog on a non SoC device, like a PCIe card, it will make the PCIe
card die when the timeout expired, but starting it again is not
supported.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/embedded.c    |   35 +++++++++++++++++++++++++++++++++++
 drivers/ssb/main.c        |    8 ++++++++
 drivers/ssb/ssb_private.h |   10 ++++++++++
 include/linux/ssb/ssb.h   |    2 ++
 4 files changed, 55 insertions(+)

diff --git a/drivers/ssb/embedded.c b/drivers/ssb/embedded.c
index 9ef124f..bb18d76 100644
--- a/drivers/ssb/embedded.c
+++ b/drivers/ssb/embedded.c
@@ -4,11 +4,13 @@
  *
  * Copyright 2005-2008, Broadcom Corporation
  * Copyright 2006-2008, Michael Buesch <m@bues.ch>
+ * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
 #include <linux/export.h>
+#include <linux/platform_device.h>
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_embedded.h>
 #include <linux/ssb/ssb_driver_pci.h>
@@ -32,6 +34,39 @@ int ssb_watchdog_timer_set(struct ssb_bus *bus, u32 ticks)
 }
 EXPORT_SYMBOL(ssb_watchdog_timer_set);
 
+int ssb_watchdog_register(struct ssb_bus *bus)
+{
+	struct bcm47xx_wdt wdt = {};
+	struct platform_device *pdev;
+
+	if (ssb_chipco_available(&bus->chipco)) {
+		wdt.driver_data = &bus->chipco;
+		wdt.timer_set = ssb_chipco_watchdog_timer_set_wdt;
+		wdt.timer_set_ms = ssb_chipco_watchdog_timer_set_ms;
+		wdt.max_timer_ms = bus->chipco.max_timer_ms;
+	} else if (ssb_extif_available(&bus->extif)) {
+		wdt.driver_data = &bus->extif;
+		wdt.timer_set = ssb_extif_watchdog_timer_set_wdt;
+		wdt.timer_set_ms = ssb_extif_watchdog_timer_set_ms;
+		wdt.max_timer_ms = SSB_EXTIF_WATCHDOG_MAX_TIMER_MS;
+	} else {
+		return -ENODEV;
+	}
+
+	pdev = platform_device_register_data(NULL, "bcm47xx-wdt",
+					     bus->busnumber, &wdt,
+					     sizeof(wdt));
+	if (IS_ERR(pdev)) {
+		ssb_dprintk(KERN_INFO PFX
+			    "can not register watchdog device, err: %li\n",
+			    PTR_ERR(pdev));
+		return PTR_ERR(pdev);
+	}
+
+	bus->watchdog = pdev;
+	return 0;
+}
+
 u32 ssb_gpio_in(struct ssb_bus *bus, u32 mask)
 {
 	unsigned long flags;
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index df0f145..58c7da2 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_regs.h>
 #include <linux/ssb/ssb_driver_gige.h>
@@ -433,6 +434,11 @@ static void ssb_devices_unregister(struct ssb_bus *bus)
 		if (sdev->dev)
 			device_unregister(sdev->dev);
 	}
+
+#ifdef CONFIG_SSB_EMBEDDED
+	if (bus->bustype == SSB_BUSTYPE_SSB)
+		platform_device_unregister(bus->watchdog);
+#endif
 }
 
 void ssb_bus_unregister(struct ssb_bus *bus)
@@ -561,6 +567,8 @@ static int __devinit ssb_attach_queued_buses(void)
 		if (err)
 			goto error;
 		ssb_pcicore_init(&bus->pcicore);
+		if (bus->bustype == SSB_BUSTYPE_SSB)
+			ssb_watchdog_register(bus);
 		ssb_bus_may_powerdown(bus);
 
 		err = ssb_devices_register(bus);
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 50ea028..8942db1 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -232,4 +232,14 @@ static inline u32 ssb_extif_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt,
 	return 0;
 }
 #endif
+
+#ifdef CONFIG_SSB_EMBEDDED
+extern int ssb_watchdog_register(struct ssb_bus *bus);
+#else /* CONFIG_SSB_EMBEDDED */
+static inline int ssb_watchdog_register(struct ssb_bus *bus)
+{
+	return 0;
+}
+#endif /* CONFIG_SSB_EMBEDDED */
+
 #endif /* LINUX_SSB_PRIVATE_H_ */
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index bb674c0..1f64e3f 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/mod_devicetable.h>
 #include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
 
 #include <linux/ssb/ssb_regs.h>
 
@@ -432,6 +433,7 @@ struct ssb_bus {
 #ifdef CONFIG_SSB_EMBEDDED
 	/* Lock for GPIO register access. */
 	spinlock_t gpio_lock;
+	struct platform_device *watchdog;
 #endif /* EMBEDDED */
 
 	/* Internal-only stuff follows. Do not touch. */
-- 
1.7.10.4

