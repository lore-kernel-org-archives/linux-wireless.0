Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51462 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2KSW65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 17:58:57 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/8] ssb: add GPIO driver
Date: Mon, 19 Nov 2012 23:57:56 +0100
Message-Id: <1353365877-11131-8-git-send-email-hauke@hauke-m.de> (sfid-20121119_235859_912523_010F7072)
In-Reply-To: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register a GPIO driver to access the GPIOs provided by the chip.
The GPIOs of the SoC should always start at 0 and the other GPIOs could
start at a random position. There is just one SoC in a system and when
they start at 0 the number is predictable.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/Kconfig       |    9 +++
 drivers/ssb/Makefile      |    1 +
 drivers/ssb/driver_gpio.c |  170 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ssb/main.c        |    1 +
 drivers/ssb/ssb_private.h |    9 +++
 include/linux/ssb/ssb.h   |    4 ++
 6 files changed, 194 insertions(+)
 create mode 100644 drivers/ssb/driver_gpio.c

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 42cdaa9..8b5460f 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -160,4 +160,13 @@ config SSB_DRIVER_GIGE
 
 	  If unsure, say N
 
+config SSB_DRIVER_GPIO
+	bool
+	depends on SSB
+	select GPIOLIB
+	help
+	  Driver to provide access to the GPIO pins.
+
+	  If unsure, say N
+
 endmenu
diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 656e58b..9159ba7 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -15,6 +15,7 @@ ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
 ssb-$(CONFIG_SSB_DRIVER_EXTIF)		+= driver_extif.o
 ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 ssb-$(CONFIG_SSB_DRIVER_GIGE)		+= driver_gige.o
+ssb-$(CONFIG_SSB_DRIVER_GPIO)		+= driver_gpio.o
 
 # b43 pci-ssb-bridge driver
 # Not strictly a part of SSB, but kept here for convenience
diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
new file mode 100644
index 0000000..e4ab9f6
--- /dev/null
+++ b/drivers/ssb/driver_gpio.c
@@ -0,0 +1,170 @@
+/*
+ * Sonics Silicon Backplane
+ * GPIO driver
+ *
+ * Copyright 2011, Broadcom Corporation
+ * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/gpio.h>
+#include <linux/export.h>
+#include <linux/ssb/ssb.h>
+
+#include "ssb_private.h"
+
+static struct ssb_bus *ssb_gpio_get_bus(struct gpio_chip *chip)
+{
+	return container_of(chip, struct ssb_bus, gpio);
+}
+
+static int ssb_gpio_chipco_get_value(struct gpio_chip *chip, unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	return !!ssb_chipco_gpio_in(&bus->chipco, 1 << gpio);
+}
+
+static void ssb_gpio_chipco_set_value(struct gpio_chip *chip, unsigned gpio,
+				      int value)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	ssb_chipco_gpio_out(&bus->chipco, 1 << gpio, value ? 1 << gpio : 0);
+}
+
+static int ssb_gpio_chipco_direction_input(struct gpio_chip *chip,
+					   unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	ssb_chipco_gpio_outen(&bus->chipco, 1 << gpio, 0);
+	return 0;
+}
+
+static int ssb_gpio_chipco_direction_output(struct gpio_chip *chip,
+					    unsigned gpio, int value)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	ssb_chipco_gpio_outen(&bus->chipco, 1 << gpio, 1 << gpio);
+	ssb_chipco_gpio_out(&bus->chipco, 1 << gpio, value ? 1 << gpio : 0);
+	return 0;
+}
+
+static int ssb_gpio_chipco_request(struct gpio_chip *chip, unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	ssb_chipco_gpio_control(&bus->chipco, 1 << gpio, 0);
+	/* clear pulldown */
+	ssb_chipco_gpio_pulldown(&bus->chipco, 1 << gpio, 0);
+	/* Set pullup */
+	ssb_chipco_gpio_pullup(&bus->chipco, 1 << gpio, 1 << gpio);
+
+	return 0;
+}
+
+static void ssb_gpio_chipco_free(struct gpio_chip *chip, unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	/* clear pullup */
+	ssb_chipco_gpio_pullup(&bus->chipco, 1 << gpio, 0);
+}
+
+static int ssb_gpio_chipco_init(struct ssb_bus *bus)
+{
+	struct gpio_chip *chip = &bus->gpio;
+
+	chip->label		= "ssb_chipco_gpio";
+	chip->owner		= THIS_MODULE;
+	chip->request		= ssb_gpio_chipco_request;
+	chip->free		= ssb_gpio_chipco_free;
+	chip->get		= ssb_gpio_chipco_get_value;
+	chip->set		= ssb_gpio_chipco_set_value;
+	chip->direction_input	= ssb_gpio_chipco_direction_input;
+	chip->direction_output	= ssb_gpio_chipco_direction_output;
+	chip->ngpio		= 16;
+	if (bus->bustype == SSB_BUSTYPE_SSB)
+		chip->base		= 0;
+	else
+		chip->base		= -1;
+
+	return gpiochip_add(chip);
+}
+
+#ifdef CONFIG_SSB_DRIVER_EXTIF
+
+static int ssb_gpio_extif_get_value(struct gpio_chip *chip, unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	return !!ssb_extif_gpio_in(&bus->extif, 1 << gpio);
+}
+
+static void ssb_gpio_extif_set_value(struct gpio_chip *chip, unsigned gpio,
+				     int value)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	ssb_extif_gpio_out(&bus->extif, 1 << gpio, value ? 1 << gpio : 0);
+}
+
+static int ssb_gpio_extif_direction_input(struct gpio_chip *chip,
+					  unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	ssb_extif_gpio_outen(&bus->extif, 1 << gpio, 0);
+	return 0;
+}
+
+static int ssb_gpio_extif_direction_output(struct gpio_chip *chip,
+					   unsigned gpio, int value)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	ssb_extif_gpio_outen(&bus->extif, 1 << gpio, 1 << gpio);
+	ssb_extif_gpio_out(&bus->extif, 1 << gpio, value ? 1 << gpio : 0);
+	return 0;
+}
+
+static int ssb_gpio_extif_init(struct ssb_bus *bus)
+{
+	struct gpio_chip *chip = &bus->gpio;
+
+	chip->label		= "ssb_extif_gpio";
+	chip->owner		= THIS_MODULE;
+	chip->get		= ssb_gpio_extif_get_value;
+	chip->set		= ssb_gpio_extif_set_value;
+	chip->direction_input	= ssb_gpio_extif_direction_input;
+	chip->direction_output	= ssb_gpio_extif_direction_output;
+	chip->ngpio		= 5;
+	if (bus->bustype == SSB_BUSTYPE_SSB)
+		chip->base		= 0;
+	else
+		chip->base		= -1;
+
+	return gpiochip_add(chip);
+}
+
+#else
+static int ssb_gpio_extif_init(struct ssb_bus *bus)
+{
+	return 0;
+}
+#endif
+
+int ssb_gpio_init(struct ssb_bus *bus)
+{
+	if (ssb_chipco_available(&bus->chipco))
+		return ssb_gpio_chipco_init(bus);
+	else if (ssb_extif_available(&bus->extif))
+		return ssb_gpio_extif_init(bus);
+	else
+		SSB_WARN_ON(1);
+
+	return -1;
+}
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 6fe2d10..6ac1ca3 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -798,6 +798,7 @@ static int __devinit ssb_bus_register(struct ssb_bus *bus,
 	ssb_chipcommon_init(&bus->chipco);
 	ssb_extif_init(&bus->extif);
 	ssb_mipscore_init(&bus->mipscore);
+	ssb_gpio_init(bus);
 	err = ssb_fetch_invariants(bus, get_invariants);
 	if (err) {
 		ssb_bus_may_powerdown(bus);
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index d6a1ba9..8497397 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -219,4 +219,13 @@ static inline void ssb_extif_init(struct ssb_extif *extif)
 }
 #endif
 
+#ifdef CONFIG_SSB_DRIVER_GPIO
+extern int ssb_gpio_init(struct ssb_bus *bus);
+#else /* CONFIG_SSB_DRIVER_GPIO */
+static inline int ssb_gpio_init(struct ssb_bus *bus);
+{
+	return 0;
+}
+#endif /* CONFIG_SSB_DRIVER_GPIO */
+
 #endif /* LINUX_SSB_PRIVATE_H_ */
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index bb674c0..3862a5b 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/gpio.h>
 #include <linux/mod_devicetable.h>
 #include <linux/dma-mapping.h>
 
@@ -433,6 +434,9 @@ struct ssb_bus {
 	/* Lock for GPIO register access. */
 	spinlock_t gpio_lock;
 #endif /* EMBEDDED */
+#ifdef CONFIG_SSB_DRIVER_GPIO
+	struct gpio_chip gpio;
+#endif /* DRIVER_GPIO */
 
 	/* Internal-only stuff follows. Do not touch. */
 	struct list_head list;
-- 
1.7.10.4

