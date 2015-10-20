Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:61874 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbJTWsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 14/19] staging/wilc1000: get rid of WILC_SDIO_IRQ_GPIO
Date: Wed, 21 Oct 2015 00:47:33 +0200
Message-Id: <1445381258-1455986-15-git-send-email-arnd@arndb.de> (sfid-20151021_005027_466622_74401EAF)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whether the SDIO function uses an internal or external interrupt
should not be a compiletime decision but be determined at runtime.

This changes the code to pass a GPIO number from the init code
as early as possible, and leaves just one #ifdef WILC_SDIO_IRQ_GPIO
to preserve the previous behavior.

All other locations that check for the interrupt method are turned
into runtime checks based on the gpio number (>=0) or the interrupt
number (>0).

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Makefile             |   1 -
 drivers/staging/wilc1000/linux_wlan.c         |  66 +++++++---------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  26 ++++---
 drivers/staging/wilc1000/linux_wlan_spi.c     |   2 +-
 drivers/staging/wilc1000/wilc_sdio.c          | 105 +++++++++++---------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   5 +-
 drivers/staging/wilc1000/wilc_wlan.c          |   8 +-
 drivers/staging/wilc1000/wilc_wlan.h          |   2 +-
 8 files changed, 94 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 55b2ac2b15a8..b96fee8f94f2 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_WILC1000) += wilc1000.o
 
 ccflags-$(CONFIG_WILC1000_SDIO) += -DWILC_SDIO -DCOMPLEMENT_BOOT
-ccflags-$(CONFIG_WILC1000_HW_OOB_INTR) += -DWILC_SDIO_IRQ_GPIO
 ccflags-$(CONFIG_WILC1000_SPI) += -DWILC_SPI
 
 ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 980c2c8d300d..beafc543aac3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -170,7 +170,6 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
 	PRINT_D(INT_DBG, "Interrupt received UH\n");
@@ -208,16 +207,16 @@ static int init_irq(struct wilc *p_nic)
 
 	/*initialize GPIO and register IRQ num*/
 	/*GPIO request*/
-	if ((gpio_request(GPIO_NUM, "WILC_INTR") == 0) &&
-	    (gpio_direction_input(GPIO_NUM) == 0)) {
+	if ((gpio_request(nic->gpio, "WILC_INTR") == 0) &&
+	    (gpio_direction_input(nic->gpio) == 0)) {
 #if defined(CUSTOMER_PLATFORM)
 /*
  TODO : save the registerd irq number to the private wilc context in kernel.
  *
- * ex) nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
+ * ex) nic->dev_irq_num = gpio_to_irq(nic->gpio);
  */
 #else
-		nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
+		nic->dev_irq_num = gpio_to_irq(nic->gpio);
 #endif
 	} else {
 		ret = -1;
@@ -228,28 +227,25 @@ static int init_irq(struct wilc *p_nic)
 						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,               /*Without IRQF_ONESHOT the uh will remain kicked in and dont gave a chance to bh*/
 						  "WILC_IRQ", nic)) < 0) {
 
-		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
+		PRINT_ER("Failed to request IRQ for GPIO: %d\n", nic->gpio);
 		ret = -1;
 	} else {
 
 		PRINT_D(INIT_DBG, "IRQ request succeeded IRQ-NUM= %d on GPIO: %d\n",
-			nic->dev_irq_num, GPIO_NUM);
+			nic->dev_irq_num, nic->gpio);
 	}
 
 	return ret;
 }
-#endif
 
 static void deinit_irq(struct wilc *nic)
 {
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 	/* Deintialize IRQ */
-	if (&nic->dev_irq_num != 0) {
+	if (nic->gpio >= 0 && &nic->dev_irq_num != 0) {
 		free_irq(nic->dev_irq_num, wilc1000_dev);
 
-		gpio_free(GPIO_NUM);
+		gpio_free(nic->gpio);
 	}
-#endif
 }
 
 /*
@@ -830,11 +826,11 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 #endif
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
-#ifdef WILC_SDIO
-		mutex_lock(&wilc1000_dev->hif_cs);
-		wilc1000_sdio_disable_interrupt();
-		mutex_unlock(&wilc1000_dev->hif_cs);
-#endif
+		if (wilc1000_dev->gpio < 0) {
+			mutex_lock(&wilc1000_dev->hif_cs);
+			wilc1000_sdio_disable_interrupt();
+			mutex_unlock(&wilc1000_dev->hif_cs);
+		}
 		if (&wilc1000_dev->txq_event != NULL)
 			up(&wilc1000_dev->txq_event);
 
@@ -848,14 +844,13 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_cleanup();
-#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-  #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
-
-		mutex_lock(&wilc1000_dev->hif_cs);
-		wilc1000_sdio_disable_interrupt();
-		mutex_unlock(&wilc1000_dev->hif_cs);
-  #endif
+#if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
+		if (wilc1000_dev->gpio < 0) {
+			PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
+
+			mutex_lock(&wilc1000_dev->hif_cs);
+			wilc1000_sdio_disable_interrupt();
+			mutex_unlock(&wilc1000_dev->hif_cs);
 #endif
 
 		/*De-Initialize locks*/
@@ -982,21 +977,17 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_threads_;
 		}
 
-#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		if (init_irq(wilc1000_dev)) {
+		if (wilc1000_dev->gpio >= 0 && init_irq(wilc1000_dev)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_threads_;
 		}
-#endif
 
-#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		if (wilc1000_sdio_enable_interrupt()) {
+		if (wilc1000_dev->gpio < 0 && wilc1000_sdio_enable_interrupt()) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
 		}
-#endif
 
 		if (wilc1000_wlan_get_firmware(nic)) {
 			PRINT_ER("Can't get firmware\n");
@@ -1048,14 +1039,12 @@ _fail_fw_start_:
 		wilc_wlan_stop();
 
 _fail_irq_enable_:
-#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		wilc1000_sdio_disable_interrupt();
+		if (wilc1000_dev->gpio < 0)
+			wilc1000_sdio_disable_interrupt();
 _fail_irq_init_:
-#endif
-#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		deinit_irq(wilc1000_dev);
+		if (wilc1000_dev->gpio >= 0)
+			deinit_irq(wilc1000_dev);
 
-#endif
 _fail_threads_:
 		wlan_deinitialize_threads(wilc1000_dev);
 _fail_wilc_wlan_:
@@ -1511,7 +1500,7 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 		WILC_WFI_p2p_rx(wilc1000_dev->strInterfaceInfo[1].wilc_netdev, buff, size);
 }
 
-int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops)
+int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops, int gpio)
 {
 
 	int i;
@@ -1526,6 +1515,7 @@ int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops)
 		return -ENOMEM;
 
 	wilc1000_dev->ops = ops;
+	wilc1000_dev->gpio = gpio;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index bb4a3acf16d0..64c8c5725277 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -7,6 +7,7 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/host.h>
+#include <linux/of_gpio.h>
 
 
 
@@ -36,15 +37,12 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 };
 
 
-#ifndef WILC_SDIO_IRQ_GPIO
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
 	sdio_release_host(func);
 	wilc_handle_isr();
 	sdio_claim_host(func);
 }
-#endif
-
 
 static int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd)
 {
@@ -161,9 +159,8 @@ static int repeat_power_cycle(perInterface_wlan_t *nic)
 	ret = wilc_wlan_init(wilc1000_dev);
 
 	wilc1000_dev->mac_status = WILC_MAC_STATUS_INIT;
-#if !defined WILC_SDIO_IRQ_GPIO
-	wilc1000_sdio_enable_interrupt();
-#endif
+	if (wilc1000_dev->gpio < 0)
+		wilc1000_sdio_enable_interrupt();
 
 	if (wilc1000_wlan_get_firmware(nic)) {
 		PRINT_ER("Can't get firmware\n");
@@ -188,6 +185,8 @@ __fail__:
 
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
+	int gpio;
+
 	PRINT_D(INIT_DBG, "probe function\n");
 
 #ifdef COMPLEMENT_BOOT
@@ -198,9 +197,17 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 		return 0;
 	}
 #endif
+
+	gpio = -1;
+	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
+		gpio = of_get_gpio(func->dev.of_node, 0);
+		if (gpio < 0)
+			gpio = GPIO_NUM;
+	}
+
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	wilc1000_sdio_func = func;
-	if (wilc_netdev_init(&func->dev, &wilc1000_sdio_ops)) {
+	if (wilc_netdev_init(&func->dev, &wilc1000_sdio_ops, gpio)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
@@ -228,7 +235,6 @@ static struct sdio_driver wilc_bus = {
 int wilc1000_sdio_enable_interrupt(void)
 {
 	int ret = 0;
-#ifndef WILC_SDIO_IRQ_GPIO
 
 	sdio_claim_host(wilc1000_sdio_func);
 	ret = sdio_claim_irq(wilc1000_sdio_func, wilc_sdio_interrupt);
@@ -238,14 +244,11 @@ int wilc1000_sdio_enable_interrupt(void)
 		PRINT_ER("can't claim sdio_irq, err(%d)\n", ret);
 		ret = -EIO;
 	}
-#endif
 	return ret;
 }
 
 void wilc1000_sdio_disable_interrupt(void)
 {
-
-#ifndef WILC_SDIO_IRQ_GPIO
 	int ret;
 
 	PRINT_D(INIT_DBG, "wilc1000_sdio_disable_interrupt IN\n");
@@ -258,7 +261,6 @@ void wilc1000_sdio_disable_interrupt(void)
 	sdio_release_host(wilc1000_sdio_func);
 
 	PRINT_D(INIT_DBG, "wilc1000_sdio_disable_interrupt OUT\n");
-#endif
 }
 
 static int linux_sdio_set_speed(int speed)
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 788531e314c3..c6ea3ef0664f 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -424,7 +424,7 @@ static int __init init_wilc_spi_driver(void)
 	int ret;
 
 	wilc1000_init_driver();
-	ret = wilc_netdev_init(NULL, &wilc1000_spi_ops);
+	ret = wilc_netdev_init(NULL, &wilc1000_spi_ops, GPIO_NUM);
 	if (ret)
 		return ret;
 
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 2d39a5386718..69b7c72b76c5 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -16,6 +16,7 @@
 
 typedef struct {
 	void *os_context;
+	bool irq_gpio;
 	u32 block_size;
 	int (*sdio_cmd52)(sdio_cmd52_t *);
 	int (*sdio_cmd53)(sdio_cmd53_t *);
@@ -29,10 +30,8 @@ typedef struct {
 
 static wilc_sdio_t g_sdio;
 
-#ifdef WILC_SDIO_IRQ_GPIO
 static int sdio_write_reg(u32 addr, u32 data);
 static int sdio_read_reg(u32 addr, u32 *data);
-#endif
 
 /********************************************
  *
@@ -135,29 +134,29 @@ _fail_:
 
 static int sdio_clear_int(void)
 {
-#ifndef WILC_SDIO_IRQ_GPIO
-	/* u32 sts; */
-	sdio_cmd52_t cmd;
+	if (!g_sdio.irq_gpio) {
+		/* u32 sts; */
+		sdio_cmd52_t cmd;
 
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x4;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+		cmd.read_write = 0;
+		cmd.function = 1;
+		cmd.raw = 0;
+		cmd.address = 0x4;
+		cmd.data = 0;
+		g_sdio.sdio_cmd52(&cmd);
 
-	return cmd.data;
-#else
-	u32 reg;
+		return cmd.data;
+	} else {
+		u32 reg;
 
-	if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
-		g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
-		return 0;
+		if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
+			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
+			return 0;
+		}
+		reg &= ~0x1;
+		sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
+		return 1;
 	}
-	reg &= ~0x1;
-	sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
-	return 1;
-#endif
 
 }
 
@@ -459,8 +458,7 @@ static int sdio_sync(void)
 		return 0;
 	}
 
-#ifdef WILC_SDIO_IRQ_GPIO
-	{
+	if (g_sdio.irq_gpio) {
 		u32 reg;
 		int ret;
 
@@ -494,7 +492,6 @@ static int sdio_sync(void)
 			return 0;
 		}
 	}
-#endif
 
 	return 1;
 }
@@ -509,6 +506,7 @@ static int sdio_init(struct wilc *inp, wilc_debug_func func)
 
 	g_sdio.dPrint = func;
 	g_sdio.os_context = inp;
+	g_sdio.irq_gpio = (inp->gpio >= 0);
 
 	if (inp->ops->io_init) {
 		if (!inp->ops->io_init(g_sdio.os_context)) {
@@ -674,36 +672,33 @@ static int sdio_read_int(u32 *int_status)
 	/**
 	 *      Read IRQ flags
 	 **/
-#ifndef WILC_SDIO_IRQ_GPIO
-	cmd.function = 1;
-	cmd.address = 0x04;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
-
-	if (cmd.data & BIT(0))
-		tmp |= INT_0;
-	if (cmd.data & BIT(2))
-		tmp |= INT_1;
-	if (cmd.data & BIT(3))
-		tmp |= INT_2;
-	if (cmd.data & BIT(4))
-		tmp |= INT_3;
-	if (cmd.data & BIT(5))
-		tmp |= INT_4;
-	if (cmd.data & BIT(6))
-		tmp |= INT_5;
-	{
+	if (!g_sdio.irq_gpio) {
 		int i;
 
+		cmd.function = 1;
+		cmd.address = 0x04;
+		cmd.data = 0;
+		g_sdio.sdio_cmd52(&cmd);
+
+		if (cmd.data & BIT(0))
+			tmp |= INT_0;
+		if (cmd.data & BIT(2))
+			tmp |= INT_1;
+		if (cmd.data & BIT(3))
+			tmp |= INT_2;
+		if (cmd.data & BIT(4))
+			tmp |= INT_3;
+		if (cmd.data & BIT(5))
+			tmp |= INT_4;
+		if (cmd.data & BIT(6))
+			tmp |= INT_5;
 		for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
 			if ((tmp >> (IRG_FLAGS_OFFSET + i)) & 0x1) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt (1) : tmp=%x, data=%x\n", tmp, cmd.data);
 				break;
 			}
 		}
-	}
-#else
-	{
+	} else {
 		u32 irq_flags;
 
 		cmd.read_write = 0;
@@ -716,8 +711,6 @@ static int sdio_read_int(u32 *int_status)
 		tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
 	}
 
-#endif
-
 	*int_status = tmp;
 
 	return 1;
@@ -730,16 +723,14 @@ static int sdio_clear_int_ext(u32 val)
 	if (g_sdio.has_thrpt_enh3) {
 		u32 reg;
 
-#ifdef WILC_SDIO_IRQ_GPIO
-		{
+		if (g_sdio.irq_gpio) {
 			u32 flags;
 
 			flags = val & (BIT(MAX_NUN_INT_THRPT_ENH2) - 1);
 			reg = flags;
+		} else {
+			reg = 0;
 		}
-#else
-		reg = 0;
-#endif
 		/* select VMM table 0 */
 		if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
 			reg |= BIT(5);
@@ -766,8 +757,7 @@ static int sdio_clear_int_ext(u32 val)
 
 		}
 	} else {
-#ifdef WILC_SDIO_IRQ_GPIO
-		{
+		if (g_sdio.irq_gpio) {
 			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
 			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
 			u32 flags;
@@ -807,7 +797,6 @@ static int sdio_clear_int_ext(u32 val)
 				}
 			}
 		}
-#endif /* WILC_SDIO_IRQ_GPIO */
 
 		{
 			u32 vmm_ctl;
@@ -874,8 +863,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 		return 0;
 	}
 
-#ifdef WILC_SDIO_IRQ_GPIO
-	{
+	if (g_sdio.irq_gpio) {
 		u32 reg;
 		int ret, i;
 
@@ -927,7 +915,6 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 			}
 		}
 	}
-#endif /* WILC_SDIO_IRQ_GPIO */
 	return 1;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ec5a8b1215b7..f1f78f51fea0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -159,9 +159,8 @@ struct wilc {
 	const struct wilc1000_ops *ops;
 	int mac_status;
 	int wilc1000_initialized;
-	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-	unsigned short dev_irq_num;
-	#endif
+	int gpio;
+	int dev_irq_num;
 	int close;
 	u8 u8NoIfcs;
 	struct wilc_vif strInterfaceInfo[NUM_CONCURRENT_IFC];
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7e1b892f721d..d12a4e7df32c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1369,9 +1369,6 @@ void wilc_handle_isr(void)
 		wilc_sleeptimer_isr_ext(int_status);
 
 	if (!(int_status & (ALL_INT_EXT))) {
-#ifdef WILC_SDIO
-		PRINT_D(TX_DBG, ">> UNKNOWN_INTERRUPT - 0x%08x\n", int_status);
-#endif
 		wilc_unknown_isr_ext();
 	}
 	release_bus(RELEASE_ALLOW_SLEEP);
@@ -1481,9 +1478,8 @@ int wilc_wlan_start(void)
 		return ret;
 	}
 	reg = 0;
-#ifdef WILC_SDIO_IRQ_GPIO
-	reg |= WILC_HAVE_SDIO_IRQ_GPIO;
-#endif
+	if (p->io_func->io_type == HIF_SDIO && wilc1000_dev->gpio >= 0)
+		reg |= WILC_HAVE_SDIO_IRQ_GPIO;
 
 #ifdef WILC_DISABLE_PMU
 #else
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 10b2a2f9e1b2..2e9b5d50ff7e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -321,7 +321,7 @@ void wilc1000_enable_tcp_ack_filter(bool value);
 void wilc1000_chip_sleep_manually(u32 u32SleepTime);
 int wilc1000_wlan_get_num_conn_ifcs(void);
 int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-int wilc_netdev_init(struct device *, const struct wilc1000_ops *ops);
+int wilc_netdev_init(struct device *, const struct wilc1000_ops *ops, int gpio);
 void __exit wilc_netdev_free(struct wilc *wilc1000_dev);
 
 void wilc_handle_isr(void);
-- 
2.1.0.rc2

