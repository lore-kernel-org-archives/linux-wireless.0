Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53493 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1GVXUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 19:20:54 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org
Cc: jonas.gorski@gmail.com, ralf@linux-mips.org, zajec5@gmail.com,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 08/11] bcm47xx: prepare to support different buses
Date: Sat, 23 Jul 2011 01:20:12 +0200
Message-Id: <1311376815-15755-9-git-send-email-hauke@hauke-m.de> (sfid-20110723_012057_388748_90DC7EE2)
In-Reply-To: <1311376815-15755-1-git-send-email-hauke@hauke-m.de>
References: <1311376815-15755-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepare bcm47xx to support different System buses. Before adding
support for bcma it should be possible to build bcm47xx without the
need of ssb. With this patch bcm47xx does not directly contain a
ssb_bus, but a union contain all the supported system buses. As a SoC
just uses one system bus a union is a good choice.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/gpio.c                     |   56 ++++++++++++++++----------
 arch/mips/bcm47xx/nvram.c                    |   15 +++++--
 arch/mips/bcm47xx/serial.c                   |   13 +++++-
 arch/mips/bcm47xx/setup.c                    |   33 ++++++++++++---
 arch/mips/bcm47xx/time.c                     |    9 +++-
 arch/mips/bcm47xx/wgt634u.c                  |   14 ++++--
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |   14 ++++++-
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |   55 ++++++++++++++++++-------
 drivers/watchdog/bcm47xx_wdt.c               |   12 +++++-
 9 files changed, 160 insertions(+), 61 deletions(-)

diff --git a/arch/mips/bcm47xx/gpio.c b/arch/mips/bcm47xx/gpio.c
index e4a5ee9..99e1c50 100644
--- a/arch/mips/bcm47xx/gpio.c
+++ b/arch/mips/bcm47xx/gpio.c
@@ -20,42 +20,54 @@ static DECLARE_BITMAP(gpio_in_use, BCM47XX_EXTIF_GPIO_LINES);
 
 int gpio_request(unsigned gpio, const char *tag)
 {
-	if (ssb_chipco_available(&ssb_bcm47xx.chipco) &&
-	    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
-		return -EINVAL;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco) &&
+		    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
+			return -EINVAL;
 
-	if (ssb_extif_available(&ssb_bcm47xx.extif) &&
-	    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
-		return -EINVAL;
+		if (ssb_extif_available(&bcm47xx_bus.ssb.extif) &&
+		    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
+			return -EINVAL;
 
-	if (test_and_set_bit(gpio, gpio_in_use))
-		return -EBUSY;
+		if (test_and_set_bit(gpio, gpio_in_use))
+			return -EBUSY;
 
-	return 0;
+		return 0;
+	}
+	return -EINVAL;
 }
 EXPORT_SYMBOL(gpio_request);
 
 void gpio_free(unsigned gpio)
 {
-	if (ssb_chipco_available(&ssb_bcm47xx.chipco) &&
-	    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
-		return;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco) &&
+		    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
+			return;
 
-	if (ssb_extif_available(&ssb_bcm47xx.extif) &&
-	    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
-		return;
+		if (ssb_extif_available(&bcm47xx_bus.ssb.extif) &&
+		    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
+			return;
 
-	clear_bit(gpio, gpio_in_use);
+		clear_bit(gpio, gpio_in_use);
+		return;
+	}
 }
 EXPORT_SYMBOL(gpio_free);
 
 int gpio_to_irq(unsigned gpio)
 {
-	if (ssb_chipco_available(&ssb_bcm47xx.chipco))
-		return ssb_mips_irq(ssb_bcm47xx.chipco.dev) + 2;
-	else if (ssb_extif_available(&ssb_bcm47xx.extif))
-		return ssb_mips_irq(ssb_bcm47xx.extif.dev) + 2;
-	else
-		return -EINVAL;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco))
+			return ssb_mips_irq(bcm47xx_bus.ssb.chipco.dev) + 2;
+		else if (ssb_extif_available(&bcm47xx_bus.ssb.extif))
+			return ssb_mips_irq(bcm47xx_bus.ssb.extif.dev) + 2;
+		else
+			return -EINVAL;
+	}
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(gpio_to_irq);
diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index 54db815..bcac2ff 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -26,14 +26,21 @@ static char nvram_buf[NVRAM_SPACE];
 /* Probe for NVRAM header */
 static void early_nvram_init(void)
 {
-	struct ssb_mipscore *mcore = &ssb_bcm47xx.mipscore;
+	struct ssb_mipscore *mcore_ssb;
 	struct nvram_header *header;
 	int i;
-	u32 base, lim, off;
+	u32 base = 0;
+	u32 lim = 0;
+	u32 off;
 	u32 *src, *dst;
 
-	base = mcore->flash_window;
-	lim = mcore->flash_window_size;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		mcore_ssb = &bcm47xx_bus.ssb.mipscore;
+		base = mcore_ssb->flash_window;
+		lim = mcore_ssb->flash_window_size;
+		break;
+	}
 
 	off = FLASH_MIN;
 	while (off <= lim) {
diff --git a/arch/mips/bcm47xx/serial.c b/arch/mips/bcm47xx/serial.c
index 59c11af..17c67e2 100644
--- a/arch/mips/bcm47xx/serial.c
+++ b/arch/mips/bcm47xx/serial.c
@@ -23,10 +23,10 @@ static struct platform_device uart8250_device = {
 	},
 };
 
-static int __init uart8250_init(void)
+static int __init uart8250_init_ssb(void)
 {
 	int i;
-	struct ssb_mipscore *mcore = &(ssb_bcm47xx.mipscore);
+	struct ssb_mipscore *mcore = &(bcm47xx_bus.ssb.mipscore);
 
 	memset(&uart8250_data, 0,  sizeof(uart8250_data));
 
@@ -45,6 +45,15 @@ static int __init uart8250_init(void)
 	return platform_device_register(&uart8250_device);
 }
 
+static int __init uart8250_init(void)
+{
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		return uart8250_init_ssb();
+	}
+	return -EINVAL;
+}
+
 module_init(uart8250_init);
 
 MODULE_AUTHOR("Aurelien Jarno <aurelien@aurel32.net>");
diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 73b529b..9828b60 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -35,15 +35,22 @@
 #include <bcm47xx.h>
 #include <asm/mach-bcm47xx/nvram.h>
 
-struct ssb_bus ssb_bcm47xx;
-EXPORT_SYMBOL(ssb_bcm47xx);
+union bcm47xx_bus bcm47xx_bus;
+EXPORT_SYMBOL(bcm47xx_bus);
+
+enum bcm47xx_bus_type bcm47xx_bus_type;
+EXPORT_SYMBOL(bcm47xx_bus_type);
 
 static void bcm47xx_machine_restart(char *command)
 {
 	printk(KERN_ALERT "Please stand by while rebooting the system...\n");
 	local_irq_disable();
 	/* Set the watchdog timer to reset immediately */
-	ssb_watchdog_timer_set(&ssb_bcm47xx, 1);
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 1);
+		break;
+	}
 	while (1)
 		cpu_relax();
 }
@@ -52,7 +59,11 @@ static void bcm47xx_machine_halt(void)
 {
 	/* Disable interrupts and watchdog and spin forever */
 	local_irq_disable();
-	ssb_watchdog_timer_set(&ssb_bcm47xx, 0);
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0);
+		break;
+	}
 	while (1)
 		cpu_relax();
 }
@@ -247,7 +258,7 @@ static int bcm47xx_get_invariants(struct ssb_bus *bus,
 	return 0;
 }
 
-void __init plat_mem_setup(void)
+static void __init bcm47xx_register_ssb(void)
 {
 	int err;
 	char buf[100];
@@ -258,12 +269,12 @@ void __init plat_mem_setup(void)
 		printk(KERN_WARNING "bcm47xx: someone else already registered"
 			" a ssb SPROM callback handler (err %d)\n", err);
 
-	err = ssb_bus_ssbbus_register(&ssb_bcm47xx, SSB_ENUM_BASE,
+	err = ssb_bus_ssbbus_register(&(bcm47xx_bus.ssb), SSB_ENUM_BASE,
 				      bcm47xx_get_invariants);
 	if (err)
 		panic("Failed to initialize SSB bus (err %d)\n", err);
 
-	mcore = &ssb_bcm47xx.mipscore;
+	mcore = &bcm47xx_bus.ssb.mipscore;
 	if (nvram_getenv("kernel_args", buf, sizeof(buf)) >= 0) {
 		if (strstr(buf, "console=ttyS1")) {
 			struct ssb_serial_port port;
@@ -276,6 +287,14 @@ void __init plat_mem_setup(void)
 			memcpy(&mcore->serial_ports[1], &port, sizeof(port));
 		}
 	}
+}
+
+void __init plat_mem_setup(void)
+{
+	struct cpuinfo_mips *c = &current_cpu_data;
+
+	bcm47xx_bus_type = BCM47XX_BUS_TYPE_SSB;
+	bcm47xx_register_ssb();
 
 	_machine_restart = bcm47xx_machine_restart;
 	_machine_halt = bcm47xx_machine_halt;
diff --git a/arch/mips/bcm47xx/time.c b/arch/mips/bcm47xx/time.c
index 0c6f47b..50aea2e 100644
--- a/arch/mips/bcm47xx/time.c
+++ b/arch/mips/bcm47xx/time.c
@@ -30,7 +30,7 @@
 
 void __init plat_time_init(void)
 {
-	unsigned long hz;
+	unsigned long hz = 0;
 
 	/*
 	 * Use deterministic values for initial counter interrupt
@@ -39,7 +39,12 @@ void __init plat_time_init(void)
 	write_c0_count(0);
 	write_c0_compare(0xffff);
 
-	hz = ssb_cpu_clock(&ssb_bcm47xx.mipscore) / 2;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		hz = ssb_cpu_clock(&bcm47xx_bus.ssb.mipscore) / 2;
+		break;
+	}
+
 	if (!hz)
 		hz = 100000000;
 
diff --git a/arch/mips/bcm47xx/wgt634u.c b/arch/mips/bcm47xx/wgt634u.c
index 74d0696..e9f9ec8 100644
--- a/arch/mips/bcm47xx/wgt634u.c
+++ b/arch/mips/bcm47xx/wgt634u.c
@@ -108,7 +108,7 @@ static irqreturn_t gpio_interrupt(int irq, void *ignored)
 
 	/* Interrupts are shared, check if the current one is
 	   a GPIO interrupt. */
-	if (!ssb_chipco_irq_status(&ssb_bcm47xx.chipco,
+	if (!ssb_chipco_irq_status(&bcm47xx_bus.ssb.chipco,
 				   SSB_CHIPCO_IRQ_GPIO))
 		return IRQ_NONE;
 
@@ -132,22 +132,26 @@ static int __init wgt634u_init(void)
 	 * machine. Use the MAC address as an heuristic. Netgear Inc. has
 	 * been allocated ranges 00:09:5b:xx:xx:xx and 00:0f:b5:xx:xx:xx.
 	 */
+	u8 *et0mac;
 
-	u8 *et0mac = ssb_bcm47xx.sprom.et0mac;
+	if (bcm47xx_bus_type != BCM47XX_BUS_TYPE_SSB)
+		return -ENODEV;
+
+	et0mac = bcm47xx_bus.ssb.sprom.et0mac;
 
 	if (et0mac[0] == 0x00 &&
 	    ((et0mac[1] == 0x09 && et0mac[2] == 0x5b) ||
 	     (et0mac[1] == 0x0f && et0mac[2] == 0xb5))) {
-		struct ssb_mipscore *mcore = &ssb_bcm47xx.mipscore;
+		struct ssb_mipscore *mcore = &bcm47xx_bus.ssb.mipscore;
 
 		printk(KERN_INFO "WGT634U machine detected.\n");
 
 		if (!request_irq(gpio_to_irq(WGT634U_GPIO_RESET),
 				 gpio_interrupt, IRQF_SHARED,
-				 "WGT634U GPIO", &ssb_bcm47xx.chipco)) {
+				 "WGT634U GPIO", &bcm47xx_bus.ssb.chipco)) {
 			gpio_direction_input(WGT634U_GPIO_RESET);
 			gpio_intmask(WGT634U_GPIO_RESET, 1);
-			ssb_chipco_irq_mask(&ssb_bcm47xx.chipco,
+			ssb_chipco_irq_mask(&bcm47xx_bus.ssb.chipco,
 					    SSB_CHIPCO_IRQ_GPIO,
 					    SSB_CHIPCO_IRQ_GPIO);
 		}
diff --git a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
index d008f47..7cf481b 100644
--- a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
+++ b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
@@ -19,7 +19,17 @@
 #ifndef __ASM_BCM47XX_H
 #define __ASM_BCM47XX_H
 
-/* SSB bus */
-extern struct ssb_bus ssb_bcm47xx;
+#include <linux/ssb/ssb.h>
+
+enum bcm47xx_bus_type {
+	BCM47XX_BUS_TYPE_SSB,
+};
+
+union bcm47xx_bus {
+	struct ssb_bus ssb;
+};
+
+extern union bcm47xx_bus bcm47xx_bus;
+extern enum bcm47xx_bus_type bcm47xx_bus_type;
 
 #endif /* __ASM_BCM47XX_H */
diff --git a/arch/mips/include/asm/mach-bcm47xx/gpio.h b/arch/mips/include/asm/mach-bcm47xx/gpio.h
index 9850414..6b78827 100644
--- a/arch/mips/include/asm/mach-bcm47xx/gpio.h
+++ b/arch/mips/include/asm/mach-bcm47xx/gpio.h
@@ -21,41 +21,66 @@ extern int gpio_to_irq(unsigned gpio);
 
 static inline int gpio_get_value(unsigned gpio)
 {
-	return ssb_gpio_in(&ssb_bcm47xx, 1 << gpio);
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		return ssb_gpio_in(&bcm47xx_bus.ssb, 1 << gpio);
+	}
+	return -EINVAL;
 }
 
 static inline void gpio_set_value(unsigned gpio, int value)
 {
-	ssb_gpio_out(&ssb_bcm47xx, 1 << gpio, value ? 1 << gpio : 0);
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio,
+			     value ? 1 << gpio : 0);
+	}
 }
 
 static inline int gpio_direction_input(unsigned gpio)
 {
-	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
-	return 0;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 0);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 static inline int gpio_direction_output(unsigned gpio, int value)
 {
-	/* first set the gpio out value */
-	ssb_gpio_out(&ssb_bcm47xx, 1 << gpio, value ? 1 << gpio : 0);
-	/* then set the gpio mode */
-	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
-	return 0;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		/* first set the gpio out value */
+		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio,
+			     value ? 1 << gpio : 0);
+		/* then set the gpio mode */
+		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 1 << gpio);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 static inline int gpio_intmask(unsigned gpio, int value)
 {
-	ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
-			 value ? 1 << gpio : 0);
-	return 0;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		ssb_gpio_intmask(&bcm47xx_bus.ssb, 1 << gpio,
+				 value ? 1 << gpio : 0);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 static inline int gpio_polarity(unsigned gpio, int value)
 {
-	ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
-			  value ? 1 << gpio : 0);
-	return 0;
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		ssb_gpio_polarity(&bcm47xx_bus.ssb, 1 << gpio,
+				  value ? 1 << gpio : 0);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index bd44417..c43406c 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -54,12 +54,20 @@ static atomic_t ticks;
 static inline void bcm47xx_wdt_hw_start(void)
 {
 	/* this is 2,5s on 100Mhz clock  and 2s on 133 Mhz */
-	ssb_watchdog_timer_set(&ssb_bcm47xx, 0xfffffff);
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0xfffffff);
+		break;
+	}
 }
 
 static inline int bcm47xx_wdt_hw_stop(void)
 {
-	return ssb_watchdog_timer_set(&ssb_bcm47xx, 0);
+	switch (bcm47xx_bus_type) {
+	case BCM47XX_BUS_TYPE_SSB:
+		return ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0);
+	}
+	return -EINVAL;
 }
 
 static void bcm47xx_timer_tick(unsigned long unused)
-- 
1.7.4.1

