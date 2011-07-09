Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60823 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1GILHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 07:07:04 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 10/11] bcm47xx: add support for bcma bus
Date: Sat,  9 Jul 2011 13:06:02 +0200
Message-Id: <1310209563-6405-11-git-send-email-hauke@hauke-m.de> (sfid-20110709_131610_176281_A8916B38)
In-Reply-To: <1310209563-6405-1-git-send-email-hauke@hauke-m.de>
References: <1310209563-6405-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support for the bcma bus. Broadcom uses only Mips 74K
CPUs on the new SoC and on the old ons using ssb bus there are no Mips
74K CPUs.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/Kconfig                    |   13 ++++++
 arch/mips/bcm47xx/gpio.c                     |   22 +++++++++++
 arch/mips/bcm47xx/nvram.c                    |   10 +++++
 arch/mips/bcm47xx/serial.c                   |   29 ++++++++++++++
 arch/mips/bcm47xx/setup.c                    |   53 +++++++++++++++++++++++++-
 arch/mips/bcm47xx/time.c                     |    5 ++
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    8 ++++
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |   41 ++++++++++++++++++++
 drivers/watchdog/bcm47xx_wdt.c               |   11 +++++
 9 files changed, 190 insertions(+), 2 deletions(-)

diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
index 0346f92..6210b8d 100644
--- a/arch/mips/bcm47xx/Kconfig
+++ b/arch/mips/bcm47xx/Kconfig
@@ -15,4 +15,17 @@ config BCM47XX_SSB
 
 	 This will generate an image with support for SSB and MIPS32 R1 instruction set.
 
+config BCM47XX_BCMA
+	bool "BCMA Support for Broadcom BCM47XX"
+	select SYS_HAS_CPU_MIPS32_R2
+	select BCMA
+	select BCMA_HOST_SOC
+	select BCMA_DRIVER_MIPS
+	select BCMA_DRIVER_PCI_HOSTMODE if PCI
+	default y
+	help
+	 Add support for new Broadcom BCM47xx boards with Broadcom specific Advanced Microcontroller Bus.
+
+	 This will generate an image with support for BCMA and MIPS32 R2 instruction set.
+
 endif
diff --git a/arch/mips/bcm47xx/gpio.c b/arch/mips/bcm47xx/gpio.c
index 3320e91..9d5bafe 100644
--- a/arch/mips/bcm47xx/gpio.c
+++ b/arch/mips/bcm47xx/gpio.c
@@ -36,6 +36,16 @@ int gpio_request(unsigned gpio, const char *tag)
 
 		return 0;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		if ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES)
+			return -EINVAL;
+
+		if (test_and_set_bit(gpio, gpio_in_use))
+			return -EBUSY;
+
+		return 0;
+#endif
 	}
 	return -EINVAL;
 }
@@ -57,6 +67,14 @@ void gpio_free(unsigned gpio)
 		clear_bit(gpio, gpio_in_use);
 		return;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		if ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES)
+			return;
+
+		clear_bit(gpio, gpio_in_use);
+		return;
+#endif
 	}
 }
 EXPORT_SYMBOL(gpio_free);
@@ -73,6 +91,10 @@ int gpio_to_irq(unsigned gpio)
 		else
 			return -EINVAL;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		return bcma_core_mips_irq(bcm47xx_bus.bcma.bus.drv_cc.core) + 2;
+#endif
 	}
 	return -EINVAL;
 }
diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index d223dac..1dafb9b 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -29,6 +29,9 @@ static void early_nvram_init(void)
 #ifdef CONFIG_BCM47XX_SSB
 	struct ssb_mipscore *mcore_ssb;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	struct bcma_drv_mips *mcore_bcma;
+#endif
 	struct nvram_header *header;
 	int i;
 	u32 base = 0;
@@ -44,6 +47,13 @@ static void early_nvram_init(void)
 		lim = mcore_ssb->flash_window_size;
 		break;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		mcore_bcma = &bcm47xx_bus.bcma.bus.drv_mips;
+		base = mcore_bcma->flash_window;
+		lim = mcore_bcma->flash_window_size;
+		break;
+#endif
 	}
 
 	off = FLASH_MIN;
diff --git a/arch/mips/bcm47xx/serial.c b/arch/mips/bcm47xx/serial.c
index e9258cb..52ce06a 100644
--- a/arch/mips/bcm47xx/serial.c
+++ b/arch/mips/bcm47xx/serial.c
@@ -47,6 +47,31 @@ static int __init uart8250_init_ssb(void)
 }
 #endif
 
+#ifdef CONFIG_BCM47XX_BCMA
+static int __init uart8250_init_bcma(void)
+{
+	int i;
+	struct bcma_drv_mips *mcore = &(bcm47xx_bus.bcma.bus.drv_mips);
+
+	memset(&uart8250_data, 0,  sizeof(uart8250_data));
+
+	for (i = 0; i < mcore->nr_serial_ports; i++) {
+		struct plat_serial8250_port *p = &(uart8250_data[i]);
+		struct bcma_drv_mips_serial_port *bcma_port;
+		bcma_port = &(mcore->serial_ports[i]);
+
+		p->mapbase = (unsigned int) bcma_port->regs;
+		p->membase = (void *) bcma_port->regs;
+		p->irq = bcma_port->irq + 2;
+		p->uartclk = bcma_port->baud_base;
+		p->regshift = bcma_port->reg_shift;
+		p->iotype = UPIO_MEM;
+		p->flags = UPF_BOOT_AUTOCONF | UPF_SHARE_IRQ;
+	}
+	return platform_device_register(&uart8250_device);
+}
+#endif
+
 static int __init uart8250_init(void)
 {
 	switch (bcm47xx_active_bus_type) {
@@ -54,6 +79,10 @@ static int __init uart8250_init(void)
 	case BCM47XX_BUS_TYPE_SSB:
 		return uart8250_init_ssb();
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		return uart8250_init_bcma();
+#endif
 	}
 	return -EINVAL;
 }
diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 9fc92bd..612a5ec 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_embedded.h>
+#include <linux/bcma/bcma_soc.h>
 #include <asm/bootinfo.h>
 #include <asm/reboot.h>
 #include <asm/time.h>
@@ -52,6 +53,11 @@ static void bcm47xx_machine_restart(char *command)
 		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 1);
 		break;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.bus.drv_cc, 1);
+		break;
+#endif
 	}
 	while (1)
 		cpu_relax();
@@ -67,6 +73,11 @@ static void bcm47xx_machine_halt(void)
 		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0);
 		break;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.bus.drv_cc, 0);
+		break;
+#endif
 	}
 	while (1)
 		cpu_relax();
@@ -295,16 +306,54 @@ static void __init bcm47xx_register_ssb(void)
 }
 #endif
 
+#ifdef CONFIG_BCM47XX_BCMA
+static void __init bcm47xx_register_bcma(void)
+{
+	int err;
+
+	err = bcma_host_soc_register(&bcm47xx_bus.bcma);
+	if (err)
+		panic("Failed to initialize BCMA bus (err %d)\n", err);
+}
+#endif
+
 void __init plat_mem_setup(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 
+	if (c->cputype == CPU_74K) {
+		printk(KERN_INFO "bcm47xx: using bcma bus\n");
+#ifdef CONFIG_BCM47XX_BCMA
+		bcm47xx_active_bus_type = BCM47XX_BUS_TYPE_BCMA;
+		bcm47xx_register_bcma();
+#endif
+	} else {
+		printk(KERN_INFO "bcm47xx: using ssb bus\n");
 #ifdef CONFIG_BCM47XX_SSB
-	bcm47xx_active_bus_type = BCM47XX_BUS_TYPE_SSB;
-	bcm47xx_register_ssb();
+		bcm47xx_active_bus_type = BCM47XX_BUS_TYPE_SSB;
+		bcm47xx_register_ssb();
 #endif
+	}
 
 	_machine_restart = bcm47xx_machine_restart;
 	_machine_halt = bcm47xx_machine_halt;
 	pm_power_off = bcm47xx_machine_halt;
 }
+
+static int __init bcm47xx_register_bus_complete(void)
+{
+	switch (bcm47xx_active_bus_type) {
+#ifdef CONFIG_BCM47XX_SSB
+	case BCM47XX_BUS_TYPE_SSB:
+		/* Nothing to do */
+		break;
+#endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_bus_register(&bcm47xx_bus.bcma.bus);
+		break;
+#endif
+	}
+	return 0;
+}
+device_initcall(bcm47xx_register_bus_complete);
diff --git a/arch/mips/bcm47xx/time.c b/arch/mips/bcm47xx/time.c
index 02a652a..c10471a 100644
--- a/arch/mips/bcm47xx/time.c
+++ b/arch/mips/bcm47xx/time.c
@@ -45,6 +45,11 @@ void __init plat_time_init(void)
 		hz = ssb_cpu_clock(&bcm47xx_bus.ssb.mipscore) / 2;
 		break;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		hz = bcma_cpu_clock(&bcm47xx_bus.bcma.bus.drv_mips) / 2;
+		break;
+#endif
 	}
 
 	if (!hz)
diff --git a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
index 764afea..3959485 100644
--- a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
+++ b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
@@ -20,17 +20,25 @@
 #define __ASM_BCM47XX_H
 
 #include <linux/ssb/ssb.h>
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_soc.h>
 
 enum bcm47xx_bus_type {
 #ifdef CONFIG_BCM47XX_SSB
 	BCM47XX_BUS_TYPE_SSB,
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	BCM47XX_BUS_TYPE_BCMA,
+#endif
 };
 
 union bcm47xx_bus {
 #ifdef CONFIG_BCM47XX_SSB
 	struct ssb_bus ssb;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	struct bcma_soc bcma;
+#endif
 };
 
 extern union bcm47xx_bus bcm47xx_bus;
diff --git a/arch/mips/include/asm/mach-bcm47xx/gpio.h b/arch/mips/include/asm/mach-bcm47xx/gpio.h
index 0c3bd1f..0dcb71a 100644
--- a/arch/mips/include/asm/mach-bcm47xx/gpio.h
+++ b/arch/mips/include/asm/mach-bcm47xx/gpio.h
@@ -10,6 +10,7 @@
 #define __BCM47XX_GPIO_H
 
 #include <linux/ssb/ssb_embedded.h>
+#include <linux/bcma/bcma.h>
 #include <asm/mach-bcm47xx/bcm47xx.h>
 
 #define BCM47XX_EXTIF_GPIO_LINES	5
@@ -26,6 +27,11 @@ static inline int gpio_get_value(unsigned gpio)
 	case BCM47XX_BUS_TYPE_SSB:
 		return ssb_gpio_in(&bcm47xx_bus.ssb, 1 << gpio);
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		return bcma_chipco_gpio_in(&bcm47xx_bus.bcma.bus.drv_cc,
+					   1 << gpio);
+#endif
 	}
 	return -EINVAL;
 }
@@ -37,6 +43,13 @@ static inline void gpio_set_value(unsigned gpio, int value)
 	case BCM47XX_BUS_TYPE_SSB:
 		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio,
 			     value ? 1 << gpio : 0);
+		return;
+#endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_gpio_out(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
+				     value ? 1 << gpio : 0);
+		return;
 #endif
 	}
 }
@@ -49,6 +62,12 @@ static inline int gpio_direction_input(unsigned gpio)
 		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 0);
 		return 0;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_gpio_outen(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
+				       0);
+		return 0;
+#endif
 	}
 	return -EINVAL;
 }
@@ -65,6 +84,16 @@ static inline int gpio_direction_output(unsigned gpio, int value)
 		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 1 << gpio);
 		return 0;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* first set the gpio out value */
+		bcma_chipco_gpio_out(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
+				     value ? 1 << gpio : 0);
+		/* then set the gpio mode */
+		bcma_chipco_gpio_outen(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
+				       1 << gpio);
+		return 0;
+#endif
 	}
 	return -EINVAL;
 }
@@ -78,6 +107,12 @@ static inline int gpio_intmask(unsigned gpio, int value)
 				 value ? 1 << gpio : 0);
 		return 0;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_gpio_intmask(&bcm47xx_bus.bcma.bus.drv_cc,
+					 1 << gpio, value ? 1 << gpio : 0);
+		return 0;
+#endif
 	}
 	return -EINVAL;
 }
@@ -91,6 +126,12 @@ static inline int gpio_polarity(unsigned gpio, int value)
 				  value ? 1 << gpio : 0);
 		return 0;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_gpio_polarity(&bcm47xx_bus.bcma.bus.drv_cc,
+					  1 << gpio, value ? 1 << gpio : 0);
+		return 0;
+#endif
 	}
 	return -EINVAL;
 }
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index beacd79..febce9b 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -60,6 +60,12 @@ static inline void bcm47xx_wdt_hw_start(void)
 		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0xfffffff);
 		break;
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.bus.drv_cc,
+					       0xfffffff);
+		break;
+#endif
 	}
 }
 
@@ -70,6 +76,11 @@ static inline int bcm47xx_wdt_hw_stop(void)
 	case BCM47XX_BUS_TYPE_SSB:
 		return ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0);
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.bus.drv_cc, 0);
+		return 0;
+#endif
 	}
 	return -EINVAL;
 }
-- 
1.7.4.1

