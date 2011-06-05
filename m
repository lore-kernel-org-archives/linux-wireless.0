Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33109 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345Ab1FEWIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:08:41 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC][PATCH 09/10] bcm47xx: add support for bcma bus
Date: Mon,  6 Jun 2011 00:07:37 +0200
Message-Id: <1307311658-15853-10-git-send-email-hauke@hauke-m.de> (sfid-20110606_000844_966227_E8280A6C)
In-Reply-To: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support for the bcma bus. Broadcom uses only Mips 74K
CPUs on the new SoC and on the old ons using ssb bus there are no Mips
74K CPUs.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/Kconfig                            |    4 +++
 arch/mips/bcm47xx/gpio.c                     |    9 ++++++++
 arch/mips/bcm47xx/nvram.c                    |    6 +++++
 arch/mips/bcm47xx/serial.c                   |   24 +++++++++++++++++++++++
 arch/mips/bcm47xx/setup.c                    |   27 ++++++++++++++++++++++++-
 arch/mips/bcm47xx/time.c                     |    3 ++
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    3 ++
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |   18 +++++++++++++++++
 drivers/watchdog/bcm47xx_wdt.c               |    6 +++++
 9 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 653da62..bdb0341 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -100,6 +100,10 @@ config BCM47XX
 	select SSB_EMBEDDED
 	select SSB_B43_PCI_BRIDGE if PCI
 	select SSB_PCICORE_HOSTMODE if PCI
+	select BCMA
+	select BCMA_HOST_EMBEDDED
+	select BCMA_DRIVER_MIPS
+	select BCMA_PCICORE_HOSTMODE
 	select GENERIC_GPIO
 	select SYS_HAS_EARLY_PRINTK
 	select CFE
diff --git a/arch/mips/bcm47xx/gpio.c b/arch/mips/bcm47xx/gpio.c
index 2f6d2df..42af3f8 100644
--- a/arch/mips/bcm47xx/gpio.c
+++ b/arch/mips/bcm47xx/gpio.c
@@ -34,6 +34,9 @@ int gpio_request(unsigned gpio, const char *tag)
 			return -EBUSY;
 
 		return 0;
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return -EINVAL;
 	}
 	return -EINVAL;
 }
@@ -53,6 +56,9 @@ void gpio_free(unsigned gpio)
 
 		clear_bit(gpio, gpio_in_use);
 		return;
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return;
 	}
 }
 EXPORT_SYMBOL(gpio_free);
@@ -67,6 +73,9 @@ int gpio_to_irq(unsigned gpio)
 			return ssb_mips_irq(bcm47xx_bus.ssb.extif.dev) + 2;
 		else
 			return -EINVAL;
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return -EINVAL;
 	}
 	return -EINVAL;
 }
diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index d2304d0..75c36c4 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -27,6 +27,7 @@ static char nvram_buf[NVRAM_SPACE];
 static void early_nvram_init(void)
 {
 	struct ssb_mipscore *mcore_ssb;
+	struct bcma_drv_mips *mcore_bcma;
 	struct nvram_header *header;
 	int i;
 	u32 base = 0;
@@ -40,6 +41,11 @@ static void early_nvram_init(void)
 		base = mcore_ssb->flash_window;
 		lim = mcore_ssb->flash_window_size;
 		break;
+	case BCM47XX_BUS_TYPE_BCMA:
+		mcore_bcma = &bcm47xx_bus.bcma.drv_mips;
+		base = mcore_bcma->flash_window;
+		lim = mcore_bcma->flash_window_size;
+		break;
 	}
 
 	off = FLASH_MIN;
diff --git a/arch/mips/bcm47xx/serial.c b/arch/mips/bcm47xx/serial.c
index 87c2c5e..ed74d975 100644
--- a/arch/mips/bcm47xx/serial.c
+++ b/arch/mips/bcm47xx/serial.c
@@ -45,11 +45,35 @@ static int __init uart8250_init_ssb(void)
 	return platform_device_register(&uart8250_device);
 }
 
+static int __init uart8250_init_bcma(void)
+{
+	int i;
+	struct bcma_drv_mips *mcore = &(bcm47xx_bus.bcma.drv_mips);
+
+	memset(&uart8250_data, 0,  sizeof(uart8250_data));
+
+	for (i = 0; i < mcore->nr_serial_ports; i++) {
+		struct plat_serial8250_port *p = &(uart8250_data[i]);
+		struct bcma_drv_mips_serial_port *bcma_port = &(mcore->serial_ports[i]);
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
+
 static int __init uart8250_init(void)
 {
 	switch (bcm47xx_active_bus_type) {
 	case BCM47XX_BUS_TYPE_SSB:
 		return uart8250_init_ssb();
+	case BCM47XX_BUS_TYPE_BCMA:
+		return uart8250_init_bcma();
 	}
 	return -EINVAL;
 }
diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index c64b76d..8dd82f3 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_embedded.h>
+#include <linux/bcma/bcma_embedded.h>
 #include <asm/bootinfo.h>
 #include <asm/reboot.h>
 #include <asm/time.h>
@@ -49,6 +50,9 @@ static void bcm47xx_machine_restart(char *command)
 	case BCM47XX_BUS_TYPE_SSB:
 		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 1);
 		break;
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.drv_cc, 1);
+		break;
 	}
 	while (1)
 		cpu_relax();
@@ -62,6 +66,9 @@ static void bcm47xx_machine_halt(void)
 	case BCM47XX_BUS_TYPE_SSB:
 		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0);
 		break;
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.drv_cc, 0);
+		break;
 	}
 	while (1)
 		cpu_relax();
@@ -288,12 +295,28 @@ static void __init bcm47xx_register_ssb(void)
 	}
 }
 
+static void __init bcm47xx_register_bcma(void)
+{
+	int err;
+
+	err = bcma_host_bcma_register(&bcm47xx_bus.bcma);
+	if (err)
+		panic("Failed to initialize BCMA bus (err %d)\n", err);
+}
+
 void __init plat_mem_setup(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 
-	bcm47xx_active_bus_type = BCM47XX_BUS_TYPE_SSB;
-	bcm47xx_register_ssb();
+	if (c->cputype == CPU_74K) {
+		printk(KERN_INFO "bcm47xx: using bcma bus\n");
+		bcm47xx_active_bus_type = BCM47XX_BUS_TYPE_BCMA;
+		bcm47xx_register_bcma();
+	} else {
+		printk(KERN_INFO "bcm47xx: using ssb bus\n");
+		bcm47xx_active_bus_type = BCM47XX_BUS_TYPE_SSB;
+		bcm47xx_register_ssb();
+	}
 
 	_machine_restart = bcm47xx_machine_restart;
 	_machine_halt = bcm47xx_machine_halt;
diff --git a/arch/mips/bcm47xx/time.c b/arch/mips/bcm47xx/time.c
index a7be993..ace3ba2 100644
--- a/arch/mips/bcm47xx/time.c
+++ b/arch/mips/bcm47xx/time.c
@@ -43,6 +43,9 @@ void __init plat_time_init(void)
 	case BCM47XX_BUS_TYPE_SSB:
 		hz = ssb_cpu_clock(&bcm47xx_bus.ssb.mipscore) / 2;
 		break;
+	case BCM47XX_BUS_TYPE_BCMA:
+		hz = bcma_cpu_clock(&bcm47xx_bus.bcma.drv_mips) / 2;
+		break;
 	}
 
 	if (!hz)
diff --git a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
index 4be8b95..3e6ccb9 100644
--- a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
+++ b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
@@ -20,13 +20,16 @@
 #define __ASM_BCM47XX_H
 
 #include <linux/ssb/ssb.h>
+#include <linux/bcma/bcma.h>
 
 enum bcm47xx_bus_type {
 	BCM47XX_BUS_TYPE_SSB,
+	BCM47XX_BUS_TYPE_BCMA,
 };
 
 union bcm47xx_bus {
 	struct ssb_bus ssb;
+	struct bcma_bus bcma;
 };
 
 extern union bcm47xx_bus bcm47xx_bus;
diff --git a/arch/mips/include/asm/mach-bcm47xx/gpio.h b/arch/mips/include/asm/mach-bcm47xx/gpio.h
index 16d6c19..e8629a8 100644
--- a/arch/mips/include/asm/mach-bcm47xx/gpio.h
+++ b/arch/mips/include/asm/mach-bcm47xx/gpio.h
@@ -24,6 +24,9 @@ static inline int gpio_get_value(unsigned gpio)
 	switch (bcm47xx_active_bus_type) {
 	case BCM47XX_BUS_TYPE_SSB:
 		return ssb_gpio_in(&bcm47xx_bus.ssb, 1 << gpio);
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return -EINVAL;
 	}
 	return -EINVAL;
 }
@@ -33,6 +36,9 @@ static inline void gpio_set_value(unsigned gpio, int value)
 	switch (bcm47xx_active_bus_type) {
 	case BCM47XX_BUS_TYPE_SSB:
 		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio, value ? 1 << gpio : 0);
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return;
 	}
 }
 
@@ -42,6 +48,9 @@ static inline int gpio_direction_input(unsigned gpio)
 	case BCM47XX_BUS_TYPE_SSB:
 		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 0);
 		return 0;
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return -EINVAL;
 	}
 	return -EINVAL;
 }
@@ -55,6 +64,9 @@ static inline int gpio_direction_output(unsigned gpio, int value)
 		/* then set the gpio mode */
 		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 1 << gpio);
 		return 0;
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return -EINVAL;
 	}
 	return -EINVAL;
 }
@@ -66,6 +78,9 @@ static inline int gpio_intmask(unsigned gpio, int value)
 		ssb_gpio_intmask(&bcm47xx_bus.ssb, 1 << gpio,
 				 value ? 1 << gpio : 0);
 		return 0;
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return -EINVAL;
 	}
 	return -EINVAL;
 }
@@ -77,6 +92,9 @@ static inline int gpio_polarity(unsigned gpio, int value)
 		ssb_gpio_polarity(&bcm47xx_bus.ssb, 1 << gpio,
 				  value ? 1 << gpio : 0);
 		return 0;
+	case BCM47XX_BUS_TYPE_BCMA:
+		/* Not implemenmted yet */
+		return -EINVAL;
 	}
 	return -EINVAL;
 }
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 7e4e063..8a31494 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -58,6 +58,9 @@ static inline void bcm47xx_wdt_hw_start(void)
 	case BCM47XX_BUS_TYPE_SSB:
 		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0xfffffff);
 		break;
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.drv_cc, 0xfffffff);
+		break;
 	}
 }
 
@@ -66,6 +69,9 @@ static inline int bcm47xx_wdt_hw_stop(void)
 	switch (bcm47xx_active_bus_type) {
 	case BCM47XX_BUS_TYPE_SSB:
 		return ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0);
+	case BCM47XX_BUS_TYPE_BCMA:
+		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.drv_cc, 0);
+		return 0;
 	}
 	return -EINVAL;
 }
-- 
1.7.4.1

