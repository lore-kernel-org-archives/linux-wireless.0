Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55151 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2KTXZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 18:25:26 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 8/8] MIPS: BCM47XX: remove GPIO driver
Date: Wed, 21 Nov 2012 00:24:34 +0100
Message-Id: <1353453874-523-9-git-send-email-hauke@hauke-m.de> (sfid-20121121_002531_119017_E1B85B7F)
In-Reply-To: <1353453874-523-1-git-send-email-hauke@hauke-m.de>
References: <1353453874-523-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instated of providing an own GPIO driver use the one provided by ssb and
bcma.

Acked-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/Kconfig                         |    2 +-
 arch/mips/bcm47xx/Kconfig                 |    2 +
 arch/mips/bcm47xx/Makefile                |    2 +-
 arch/mips/bcm47xx/gpio.c                  |  102 -------------------
 arch/mips/include/asm/mach-bcm47xx/gpio.h |  154 ++---------------------------
 5 files changed, 12 insertions(+), 250 deletions(-)
 delete mode 100644 arch/mips/bcm47xx/gpio.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index dba9390..abc8b69 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -105,6 +105,7 @@ config ATH79
 
 config BCM47XX
 	bool "Broadcom BCM47XX based boards"
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select CEVT_R4K
 	select CSRC_R4K
 	select DMA_NONCOHERENT
@@ -112,7 +113,6 @@ config BCM47XX
 	select IRQ_CPU
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
-	select GENERIC_GPIO
 	select SYS_HAS_EARLY_PRINTK
 	select CFE
 	help
diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
index b311be4..d7af29f 100644
--- a/arch/mips/bcm47xx/Kconfig
+++ b/arch/mips/bcm47xx/Kconfig
@@ -9,6 +9,7 @@ config BCM47XX_SSB
 	select SSB_EMBEDDED
 	select SSB_B43_PCI_BRIDGE if PCI
 	select SSB_PCICORE_HOSTMODE if PCI
+	select SSB_DRIVER_GPIO
 	default y
 	help
 	 Add support for old Broadcom BCM47xx boards with Sonics Silicon Backplane support.
@@ -23,6 +24,7 @@ config BCM47XX_BCMA
 	select BCMA_DRIVER_MIPS
 	select BCMA_HOST_PCI if PCI
 	select BCMA_DRIVER_PCI_HOSTMODE if PCI
+	select BCMA_DRIVER_GPIO
 	default y
 	help
 	 Add support for new Broadcom BCM47xx boards with Broadcom specific Advanced Microcontroller Bus.
diff --git a/arch/mips/bcm47xx/Makefile b/arch/mips/bcm47xx/Makefile
index 4389de1..1a3567f 100644
--- a/arch/mips/bcm47xx/Makefile
+++ b/arch/mips/bcm47xx/Makefile
@@ -3,5 +3,5 @@
 # under Linux.
 #
 
-obj-y 				+= gpio.o irq.o nvram.o prom.o serial.o setup.o time.o sprom.o
+obj-y 				+= irq.o nvram.o prom.o serial.o setup.o time.o sprom.o
 obj-$(CONFIG_BCM47XX_SSB)	+= wgt634u.o
diff --git a/arch/mips/bcm47xx/gpio.c b/arch/mips/bcm47xx/gpio.c
deleted file mode 100644
index 5ebdf62..0000000
--- a/arch/mips/bcm47xx/gpio.c
+++ /dev/null
@@ -1,102 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2007 Aurelien Jarno <aurelien@aurel32.net>
- */
-
-#include <linux/export.h>
-#include <linux/ssb/ssb.h>
-#include <linux/ssb/ssb_driver_chipcommon.h>
-#include <linux/ssb/ssb_driver_extif.h>
-#include <asm/mach-bcm47xx/bcm47xx.h>
-#include <asm/mach-bcm47xx/gpio.h>
-
-#if (BCM47XX_CHIPCO_GPIO_LINES > BCM47XX_EXTIF_GPIO_LINES)
-static DECLARE_BITMAP(gpio_in_use, BCM47XX_CHIPCO_GPIO_LINES);
-#else
-static DECLARE_BITMAP(gpio_in_use, BCM47XX_EXTIF_GPIO_LINES);
-#endif
-
-int gpio_request(unsigned gpio, const char *tag)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco) &&
-		    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
-			return -EINVAL;
-
-		if (ssb_extif_available(&bcm47xx_bus.ssb.extif) &&
-		    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
-			return -EINVAL;
-
-		if (test_and_set_bit(gpio, gpio_in_use))
-			return -EBUSY;
-
-		return 0;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		if (gpio >= BCM47XX_CHIPCO_GPIO_LINES)
-			return -EINVAL;
-
-		if (test_and_set_bit(gpio, gpio_in_use))
-			return -EBUSY;
-
-		return 0;
-#endif
-	}
-	return -EINVAL;
-}
-EXPORT_SYMBOL(gpio_request);
-
-void gpio_free(unsigned gpio)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco) &&
-		    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
-			return;
-
-		if (ssb_extif_available(&bcm47xx_bus.ssb.extif) &&
-		    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
-			return;
-
-		clear_bit(gpio, gpio_in_use);
-		return;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		if (gpio >= BCM47XX_CHIPCO_GPIO_LINES)
-			return;
-
-		clear_bit(gpio, gpio_in_use);
-		return;
-#endif
-	}
-}
-EXPORT_SYMBOL(gpio_free);
-
-int gpio_to_irq(unsigned gpio)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco))
-			return ssb_mips_irq(bcm47xx_bus.ssb.chipco.dev) + 2;
-		else if (ssb_extif_available(&bcm47xx_bus.ssb.extif))
-			return ssb_mips_irq(bcm47xx_bus.ssb.extif.dev) + 2;
-		else
-			return -EINVAL;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		return bcma_core_mips_irq(bcm47xx_bus.bcma.bus.drv_cc.core) + 2;
-#endif
-	}
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(gpio_to_irq);
diff --git a/arch/mips/include/asm/mach-bcm47xx/gpio.h b/arch/mips/include/asm/mach-bcm47xx/gpio.h
index 2ef17e8..90daefa 100644
--- a/arch/mips/include/asm/mach-bcm47xx/gpio.h
+++ b/arch/mips/include/asm/mach-bcm47xx/gpio.h
@@ -1,155 +1,17 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2007 Aurelien Jarno <aurelien@aurel32.net>
- */
+#ifndef __ASM_MIPS_MACH_BCM47XX_GPIO_H
+#define __ASM_MIPS_MACH_BCM47XX_GPIO_H
 
-#ifndef __BCM47XX_GPIO_H
-#define __BCM47XX_GPIO_H
+#include <asm-generic/gpio.h>
 
-#include <linux/ssb/ssb_embedded.h>
-#include <linux/bcma/bcma.h>
-#include <asm/mach-bcm47xx/bcm47xx.h>
+#define gpio_get_value __gpio_get_value
+#define gpio_set_value __gpio_set_value
 
-#define BCM47XX_EXTIF_GPIO_LINES	5
-#define BCM47XX_CHIPCO_GPIO_LINES	16
+#define gpio_cansleep __gpio_cansleep
+#define gpio_to_irq __gpio_to_irq
 
-extern int gpio_request(unsigned gpio, const char *label);
-extern void gpio_free(unsigned gpio);
-extern int gpio_to_irq(unsigned gpio);
-
-static inline int gpio_get_value(unsigned gpio)
+static inline int irq_to_gpio(unsigned int irq)
 {
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		return ssb_gpio_in(&bcm47xx_bus.ssb, 1 << gpio);
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		return bcma_chipco_gpio_in(&bcm47xx_bus.bcma.bus.drv_cc,
-					   1 << gpio);
-#endif
-	}
 	return -EINVAL;
 }
 
-#define gpio_get_value_cansleep	gpio_get_value
-
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio,
-			     value ? 1 << gpio : 0);
-		return;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		bcma_chipco_gpio_out(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
-				     value ? 1 << gpio : 0);
-		return;
 #endif
-	}
-}
-
-#define gpio_set_value_cansleep gpio_set_value
-
-static inline int gpio_cansleep(unsigned gpio)
-{
-	return 0;
-}
-
-static inline int gpio_is_valid(unsigned gpio)
-{
-	return gpio < (BCM47XX_EXTIF_GPIO_LINES + BCM47XX_CHIPCO_GPIO_LINES);
-}
-
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 0);
-		return 0;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		bcma_chipco_gpio_outen(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
-				       0);
-		return 0;
-#endif
-	}
-	return -EINVAL;
-}
-
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		/* first set the gpio out value */
-		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio,
-			     value ? 1 << gpio : 0);
-		/* then set the gpio mode */
-		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 1 << gpio);
-		return 0;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		/* first set the gpio out value */
-		bcma_chipco_gpio_out(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
-				     value ? 1 << gpio : 0);
-		/* then set the gpio mode */
-		bcma_chipco_gpio_outen(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
-				       1 << gpio);
-		return 0;
-#endif
-	}
-	return -EINVAL;
-}
-
-static inline int gpio_intmask(unsigned gpio, int value)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		ssb_gpio_intmask(&bcm47xx_bus.ssb, 1 << gpio,
-				 value ? 1 << gpio : 0);
-		return 0;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		bcma_chipco_gpio_intmask(&bcm47xx_bus.bcma.bus.drv_cc,
-					 1 << gpio, value ? 1 << gpio : 0);
-		return 0;
-#endif
-	}
-	return -EINVAL;
-}
-
-static inline int gpio_polarity(unsigned gpio, int value)
-{
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		ssb_gpio_polarity(&bcm47xx_bus.ssb, 1 << gpio,
-				  value ? 1 << gpio : 0);
-		return 0;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		bcma_chipco_gpio_polarity(&bcm47xx_bus.bcma.bus.drv_cc,
-					  1 << gpio, value ? 1 << gpio : 0);
-		return 0;
-#endif
-	}
-	return -EINVAL;
-}
-
-
-#endif /* __BCM47XX_GPIO_H */
-- 
1.7.10.4

