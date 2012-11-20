Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55108 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2KTXZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 18:25:08 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 4/8] bcma: add GPIO driver
Date: Wed, 21 Nov 2012 00:24:30 +0100
Message-Id: <1353453874-523-5-git-send-email-hauke@hauke-m.de> (sfid-20121121_002511_837660_63457508)
In-Reply-To: <1353453874-523-1-git-send-email-hauke@hauke-m.de>
References: <1353453874-523-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register a GPIO driver to access the GPIOs provided by the chip.
The GPIOs of the SoC should always start at 0 and the other GPIOs could
start at a random position. There is just one SoC in a system and when
they start at 0 the number is predictable.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig                        |    9 +++
 drivers/bcma/Makefile                       |    1 +
 drivers/bcma/bcma_private.h                 |   10 +++
 drivers/bcma/driver_gpio.c                  |   98 +++++++++++++++++++++++++++
 drivers/bcma/main.c                         |    5 ++
 include/linux/bcma/bcma_driver_chipcommon.h |    5 ++
 6 files changed, 128 insertions(+)
 create mode 100644 drivers/bcma/driver_gpio.c

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index a533af2..d7b56a8 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -65,6 +65,15 @@ config BCMA_DRIVER_GMAC_CMN
 
 	  If unsure, say N
 
+config BCMA_DRIVER_GPIO
+	bool "BCMA GPIO driver"
+	depends on BCMA
+	select GPIOLIB
+	help
+	  Driver to provide access to the GPIO pins of the bcma bus.
+
+	  If unsure, say N
+
 config BCMA_DEBUG
 	bool "BCMA debugging"
 	depends on BCMA
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
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 169fc58..8cd80bf 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -89,4 +89,14 @@ bool __devinit bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc);
 void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
 #endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
 
+#ifdef CONFIG_BCMA_DRIVER_GPIO
+/* driver_gpio.c */
+int bcma_gpio_init(struct bcma_drv_cc *cc);
+#else
+static inline int bcma_gpio_init(struct bcma_drv_cc *cc)
+{
+	return -ENOTSUPP;
+}
+#endif /* CONFIG_BCMA_DRIVER_GPIO */
+
 #endif
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
new file mode 100644
index 0000000..9a6f585
--- /dev/null
+++ b/drivers/bcma/driver_gpio.c
@@ -0,0 +1,98 @@
+/*
+ * Broadcom specific AMBA
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
+#include <linux/bcma/bcma.h>
+
+#include "bcma_private.h"
+
+static inline struct bcma_drv_cc *bcma_gpio_get_cc(struct gpio_chip *chip)
+{
+	return container_of(chip, struct bcma_drv_cc, gpio);
+}
+
+static int bcma_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
+{
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+
+	return !!bcma_chipco_gpio_in(cc, 1 << gpio);
+}
+
+static void bcma_gpio_set_value(struct gpio_chip *chip, unsigned gpio,
+				int value)
+{
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+
+	bcma_chipco_gpio_out(cc, 1 << gpio, value ? 1 << gpio : 0);
+}
+
+static int bcma_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
+{
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+
+	bcma_chipco_gpio_outen(cc, 1 << gpio, 0);
+	return 0;
+}
+
+static int bcma_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
+				      int value)
+{
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+
+	bcma_chipco_gpio_outen(cc, 1 << gpio, 1 << gpio);
+	bcma_chipco_gpio_out(cc, 1 << gpio, value ? 1 << gpio : 0);
+	return 0;
+}
+
+static int bcma_gpio_request(struct gpio_chip *chip, unsigned gpio)
+{
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+
+	bcma_chipco_gpio_control(cc, 1 << gpio, 0);
+	/* clear pulldown */
+	bcma_chipco_gpio_pulldown(cc, 1 << gpio, 0);
+	/* Set pullup */
+	bcma_chipco_gpio_pullup(cc, 1 << gpio, 1 << gpio);
+
+	return 0;
+}
+
+static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
+{
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+
+	/* clear pullup */
+	bcma_chipco_gpio_pullup(cc, 1 << gpio, 0);
+}
+
+int bcma_gpio_init(struct bcma_drv_cc *cc)
+{
+	struct gpio_chip *chip = &cc->gpio;
+
+	chip->label		= "bcma_gpio";
+	chip->owner		= THIS_MODULE;
+	chip->request		= bcma_gpio_request;
+	chip->free		= bcma_gpio_free;
+	chip->get		= bcma_gpio_get_value;
+	chip->set		= bcma_gpio_set_value;
+	chip->direction_input	= bcma_gpio_direction_input;
+	chip->direction_output	= bcma_gpio_direction_output;
+	chip->ngpio		= 16;
+	/* There is just one SoC in one device and its GPIO addresses should be
+	 * deterministic to address them more easily. The other buses could get
+	 * a random base number. */
+	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
+		chip->base		= 0;
+	else
+		chip->base		= -1;
+
+	return gpiochip_add(chip);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index d865470..478ba01 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -152,6 +152,11 @@ static int bcma_register_cores(struct bcma_bus *bus)
 			bcma_err(bus, "Error registering NAND flash\n");
 	}
 #endif
+	err = bcma_gpio_init(&bus->drv_cc);
+	if (err == -ENOTSUPP)
+		bcma_debug(bus, "GPIO driver not activated\n");
+	else if (err)
+		bcma_err(bus, "Error registering GPIO driver: %i\n", err);
 
 	return 0;
 }
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 2567026..7d662a9 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -1,6 +1,8 @@
 #ifndef LINUX_BCMA_DRIVER_CC_H_
 #define LINUX_BCMA_DRIVER_CC_H_
 
+#include <linux/gpio.h>
+
 /** ChipCommon core registers. **/
 #define BCMA_CC_ID			0x0000
 #define  BCMA_CC_ID_ID			0x0000FFFF
@@ -570,6 +572,9 @@ struct bcma_drv_cc {
 
 	/* Lock for GPIO register access. */
 	spinlock_t gpio_lock;
+#ifdef CONFIG_BCMA_DRIVER_GPIO
+	struct gpio_chip gpio;
+#endif
 };
 
 /* Register access */
-- 
1.7.10.4

