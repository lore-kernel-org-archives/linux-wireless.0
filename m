Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49422 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2HELMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 07:12:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] bcma: add GPIO driver for SoCs
Date: Sun,  5 Aug 2012 13:12:02 +0200
Message-Id: <1344165123-4640-3-git-send-email-hauke@hauke-m.de> (sfid-20120805_131300_694899_6483D74E)
In-Reply-To: <1344165123-4640-1-git-send-email-hauke@hauke-m.de>
References: <1344165123-4640-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GPIOs are access through some registers in the chip common core.
We need locking around these GPIO accesses, all GPIOs are accessed
through the same registers and parallel writes will cause problems.

CC: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig                  |    5 ++
 drivers/bcma/Makefile                 |    1 +
 drivers/bcma/driver_gpio.c            |   90 +++++++++++++++++++++++++++++++++
 drivers/bcma/scan.c                   |    4 ++
 include/linux/bcma/bcma.h             |    5 ++
 include/linux/bcma/bcma_driver_gpio.h |   21 ++++++++
 6 files changed, 126 insertions(+)
 create mode 100644 drivers/bcma/driver_gpio.c
 create mode 100644 include/linux/bcma/bcma_driver_gpio.h

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 06b3207..49a0899 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -46,6 +46,11 @@ config BCMA_DRIVER_MIPS
 
 	  If unsure, say N
 
+config BCMA_DRIVER_GPIO
+	bool
+	depends on BCMA_DRIVER_MIPS
+	default y
+
 config BCMA_SFLASH
 	bool
 	depends on BCMA_DRIVER_MIPS && BROKEN
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 8ad42d4..734b32f 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -6,6 +6,7 @@ bcma-y					+= driver_pci.o
 bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
 bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
 bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+= driver_gmac_cmn.o
+bcma-$(CONFIG_BCMA_DRIVER_GPIO)		+= driver_gpio.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
 bcma-$(CONFIG_BCMA_HOST_SOC)		+= host_soc.o
 obj-$(CONFIG_BCMA)			+= bcma.o
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
new file mode 100644
index 0000000..59436f2
--- /dev/null
+++ b/drivers/bcma/driver_gpio.c
@@ -0,0 +1,90 @@
+/*
+ * Broadcom specific AMBA
+ * GPIO driver for SoCs
+ *
+ * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/export.h>
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_driver_gpio.h>
+
+u32 bcma_gpio_in(struct bcma_bus *bus, u32 mask)
+{
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&bus->gpio_lock, flags);
+	res = bcma_chipco_gpio_in(&bus->drv_cc, mask);
+	spin_unlock_irqrestore(&bus->gpio_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(bcma_gpio_in);
+
+u32 bcma_gpio_out(struct bcma_bus *bus, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&bus->gpio_lock, flags);
+	res = bcma_chipco_gpio_out(&bus->drv_cc, mask, value);
+	spin_unlock_irqrestore(&bus->gpio_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(bcma_gpio_out);
+
+u32 bcma_gpio_outen(struct bcma_bus *bus, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&bus->gpio_lock, flags);
+	res = bcma_chipco_gpio_outen(&bus->drv_cc, mask, value);
+	spin_unlock_irqrestore(&bus->gpio_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(bcma_gpio_outen);
+
+u32 bcma_gpio_control(struct bcma_bus *bus, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&bus->gpio_lock, flags);
+	res = bcma_chipco_gpio_control(&bus->drv_cc, mask, value);
+	spin_unlock_irqrestore(&bus->gpio_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(bcma_gpio_control);
+
+u32 bcma_gpio_intmask(struct bcma_bus *bus, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&bus->gpio_lock, flags);
+	res = bcma_chipco_gpio_intmask(&bus->drv_cc, mask, value);
+	spin_unlock_irqrestore(&bus->gpio_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(bcma_gpio_intmask);
+
+u32 bcma_gpio_polarity(struct bcma_bus *bus, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&bus->gpio_lock, flags);
+	res = bcma_chipco_gpio_polarity(&bus->drv_cc, mask, value);
+	spin_unlock_irqrestore(&bus->gpio_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(bcma_gpio_polarity);
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 8d0b571..e4e444e 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -422,6 +422,10 @@ void bcma_init_bus(struct bcma_bus *bus)
 	if (bus->init_done)
 		return;
 
+#ifdef CONFIG_BCMA_DRIVER_GPIO
+	spin_lock_init(&bus->gpio_lock);
+#endif
+
 	INIT_LIST_HEAD(&bus->cores);
 	bus->nr_cores = 0;
 
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 1954a4e..2b535c9 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -255,6 +255,11 @@ struct bcma_bus {
 	struct bcma_drv_mips drv_mips;
 	struct bcma_drv_gmac_cmn drv_gmac_cmn;
 
+#ifdef CONFIG_BCMA_DRIVER_GPIO
+	/* Lock for GPIO register access. */
+	spinlock_t gpio_lock;
+#endif /* CONFIG_BCMA_DRIVER_GPIO */
+
 	/* We decided to share SPROM struct with SSB as long as we do not need
 	 * any hacks for BCMA. This simplifies drivers code. */
 	struct ssb_sprom sprom;
diff --git a/include/linux/bcma/bcma_driver_gpio.h b/include/linux/bcma/bcma_driver_gpio.h
new file mode 100644
index 0000000..1c99d6e
--- /dev/null
+++ b/include/linux/bcma/bcma_driver_gpio.h
@@ -0,0 +1,21 @@
+#ifndef LINUX_BCMA_DRIVER_GPIO_H_
+#define LINUX_BCMA_DRIVER_GPIO_H_
+
+#include <linux/types.h>
+#include <linux/bcma/bcma.h>
+
+#define BCMA_GPIO_CC_LINES	16
+
+u32 bcma_gpio_in(struct bcma_bus *bus, u32 mask);
+u32 bcma_gpio_out(struct bcma_bus *bus, u32 mask, u32 value);
+u32 bcma_gpio_outen(struct bcma_bus *bus, u32 mask, u32 value);
+u32 bcma_gpio_control(struct bcma_bus *bus, u32 mask, u32 value);
+u32 bcma_gpio_intmask(struct bcma_bus *bus, u32 mask, u32 value);
+u32 bcma_gpio_polarity(struct bcma_bus *bus, u32 mask, u32 value);
+
+static inline int bcma_gpio_count(struct bcma_bus *bus)
+{
+	return BCMA_GPIO_CC_LINES;
+}
+
+#endif /* LINUX_BCMA_DRIVER_GPIO_H_ */
-- 
1.7.9.5

