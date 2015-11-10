Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63365 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbbKJXnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:43:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 14/20] staging/wilc1000: get rid of WILC_SDIO_IRQ_GPIO
Date: Wed, 11 Nov 2015 00:42:34 +0100
Message-Id: <1447198960-2760143-15-git-send-email-arnd@arndb.de> (sfid-20151111_004541_026588_6FDBB5F6)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
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
 drivers/staging/wilc1000/linux_wlan.c         |  69 ++++++++---------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  18 ++---
 drivers/staging/wilc1000/linux_wlan_spi.c     |   2 +-
 drivers/staging/wilc1000/wilc_sdio.c          | 105 +++++++++++---------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   7 +-
 drivers/staging/wilc1000/wilc_wlan.c          |   8 +-
 7 files changed, 92 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 9696f69bda48..fe480c76c521 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_WILC1000) += wilc1000.o
 
 ccflags-$(CONFIG_WILC1000_SDIO) += -DWILC_SDIO -DCOMPLEMENT_BOOT
-ccflags-$(CONFIG_WILC1000_HW_OOB_INTR) += -DWILC_SDIO_IRQ_GPIO
 ccflags-$(CONFIG_WILC1000_SPI) += -DWILC_SPI
 
 ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 08c3be8728b2..e81e90678d0f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -161,7 +161,6 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	return NOTIFY_DONE;
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
 	perInterface_wlan_t *nic;
@@ -207,9 +206,9 @@ static int init_irq(struct net_device *dev)
 	nic = netdev_priv(dev);
 	wl = nic->wilc;
 
-	if ((gpio_request(GPIO_NUM, "WILC_INTR") == 0) &&
-	    (gpio_direction_input(GPIO_NUM) == 0)) {
-		wl->dev_irq_num = gpio_to_irq(GPIO_NUM);
+	if ((gpio_request(wl->gpio, "WILC_INTR") == 0) &&
+	    (gpio_direction_input(wl->gpio) == 0)) {
+		wl->dev_irq_num = gpio_to_irq(wl->gpio);
 	} else {
 		ret = -1;
 		PRINT_ER("could not obtain gpio for WILC_INTR\n");
@@ -220,16 +219,16 @@ static int init_irq(struct net_device *dev)
 					      isr_bh_routine,
 					      IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 					      "WILC_IRQ", dev) < 0) {
-		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
+		PRINT_ER("Failed to request IRQ for GPIO: %d\n", wl->gpio);
+		gpio_free(wl->gpio);
 		ret = -1;
 	} else {
 		PRINT_D(INIT_DBG, "IRQ request succeeded IRQ-NUM= %d on GPIO: %d\n",
-			wl->dev_irq_num, GPIO_NUM);
+			wl->dev_irq_num, wl->gpio);
 	}
 
 	return ret;
 }
-#endif
 
 static void deinit_irq(struct net_device *dev)
 {
@@ -239,13 +238,11 @@ static void deinit_irq(struct net_device *dev)
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
-	if (&wilc->dev_irq_num != 0) {
+	/* Deintialize IRQ */
+	if (wilc->dev_irq_num) {
 		free_irq(wilc->dev_irq_num, wilc);
-
-		gpio_free(GPIO_NUM);
+		gpio_free(wilc->gpio);
 	}
-#endif
 }
 
 void linux_wlan_dbg(u8 *buff)
@@ -742,11 +739,11 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 #endif
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
-#ifdef WILC_SDIO
-		mutex_lock(&wl->hif_cs);
-		wilc_sdio_disable_interrupt();
-		mutex_unlock(&wl->hif_cs);
-#endif
+		if (!wl->dev_irq_num) {
+			mutex_lock(&wl->hif_cs);
+			wilc_sdio_disable_interrupt();
+			mutex_unlock(&wl->hif_cs);
+		}
 		if (&wl->txq_event)
 			up(&wl->txq_event);
 
@@ -760,14 +757,14 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_cleanup(dev);
-#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-  #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
-
-		mutex_lock(&wl->hif_cs);
-		wilc_sdio_disable_interrupt();
-		mutex_unlock(&wl->hif_cs);
-  #endif
+#if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
+		if (!wl->dev_irq_num) {
+			PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
+
+			mutex_lock(&wl->hif_cs);
+			wilc_sdio_disable_interrupt();
+			mutex_unlock(&wl->hif_cs);
+		}
 #endif
 
 		PRINT_D(INIT_DBG, "Deinitializing Locks\n");
@@ -887,13 +884,11 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_locks_;
 		}
 
-#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		if (init_irq(dev)) {
+		if (wl->gpio >= 0 && init_irq(dev)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_locks_;
 		}
-#endif
 
 		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
@@ -902,13 +897,11 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_wilc_wlan_;
 		}
 
-#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		if (wilc_sdio_enable_interrupt()) {
+		if (!wl->dev_irq_num && wilc_sdio_enable_interrupt()) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
 		}
-#endif
 
 		if (wilc_wlan_get_firmware(dev)) {
 			PRINT_ER("Can't get firmware\n");
@@ -957,14 +950,12 @@ _fail_fw_start_:
 		wilc_wlan_stop();
 
 _fail_irq_enable_:
-#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		wilc_sdio_disable_interrupt();
+		if (!wl->dev_irq_num)
+			wilc_sdio_disable_interrupt();
 _fail_irq_init_:
-#endif
-#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		deinit_irq(dev);
+		if (wl->dev_irq_num)
+			deinit_irq(dev);
 
-#endif
 		wlan_deinitialize_threads(dev);
 _fail_wilc_wlan_:
 		wilc_wlan_cleanup(dev);
@@ -1417,7 +1408,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 #endif
 }
 
-int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type)
+int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type, int gpio)
 {
 	int i;
 	perInterface_wlan_t *nic;
@@ -1431,6 +1422,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type)
 
 	*wilc = wilc_dev;
 	wilc_dev->io_type = io_type;
+	wilc_dev->gpio = gpio;
+
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 874a859cad21..732b0d66366b 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -6,6 +6,7 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/host.h>
+#include <linux/of_gpio.h>
 
 
 
@@ -34,15 +35,12 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 };
 
 
-#ifndef WILC_SDIO_IRQ_GPIO
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
 	sdio_release_host(func);
 	wilc_handle_isr(sdio_get_drvdata(func));
 	sdio_claim_host(func);
 }
-#endif
-
 
 int wilc_sdio_cmd52(sdio_cmd52_t *cmd)
 {
@@ -110,11 +108,18 @@ int wilc_sdio_cmd53(sdio_cmd53_t *cmd)
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
 	struct wilc *wilc;
+	int gpio;
 
+	gpio = -1;
+	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
+		gpio = of_get_gpio(func->dev.of_node, 0);
+		if (gpio < 0)
+			gpio = GPIO_NUM;
+	}
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	wilc_sdio_func = func;
-	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO)) {
+	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
@@ -140,7 +145,6 @@ static struct sdio_driver wilc_bus = {
 int wilc_sdio_enable_interrupt(void)
 {
 	int ret = 0;
-#ifndef WILC_SDIO_IRQ_GPIO
 
 	sdio_claim_host(wilc_sdio_func);
 	ret = sdio_claim_irq(wilc_sdio_func, wilc_sdio_interrupt);
@@ -150,14 +154,11 @@ int wilc_sdio_enable_interrupt(void)
 		PRINT_ER("can't claim sdio_irq, err(%d)\n", ret);
 		ret = -EIO;
 	}
-#endif
 	return ret;
 }
 
 void wilc_sdio_disable_interrupt(void)
 {
-
-#ifndef WILC_SDIO_IRQ_GPIO
 	int ret;
 
 	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt IN\n");
@@ -170,7 +171,6 @@ void wilc_sdio_disable_interrupt(void)
 	sdio_release_host(wilc_sdio_func);
 
 	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt OUT\n");
-#endif
 }
 
 static int linux_sdio_set_speed(int speed)
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index a459c502a8a8..f4dda4a6fa7b 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -404,7 +404,7 @@ static int __init init_wilc_spi_driver(void)
 
 	wilc_debugfs_init();
 
-	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI);
+	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM);
 	if (ret) {
 		wilc_debugfs_remove();
 		return ret;
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 7fca3b23b485..8441fcccccc4 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -16,6 +16,7 @@
 #define WILC_SDIO_BLOCK_SIZE 512
 
 typedef struct {
+	bool irq_gpio;
 	u32 block_size;
 	wilc_debug_func dPrint;
 	int nint;
@@ -25,10 +26,8 @@ typedef struct {
 
 static wilc_sdio_t g_sdio;
 
-#ifdef WILC_SDIO_IRQ_GPIO
 static int sdio_write_reg(u32 addr, u32 data);
 static int sdio_read_reg(u32 addr, u32 *data);
-#endif
 
 /********************************************
  *
@@ -131,29 +130,29 @@ _fail_:
 
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
-	wilc_sdio_cmd52(&cmd);
+		cmd.read_write = 0;
+		cmd.function = 1;
+		cmd.raw = 0;
+		cmd.address = 0x4;
+		cmd.data = 0;
+		wilc_sdio_cmd52(&cmd);
 
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
 
@@ -455,8 +454,7 @@ static int sdio_sync(void)
 		return 0;
 	}
 
-#ifdef WILC_SDIO_IRQ_GPIO
-	{
+	if (g_sdio.irq_gpio) {
 		u32 reg;
 		int ret;
 
@@ -490,7 +488,6 @@ static int sdio_sync(void)
 			return 0;
 		}
 	}
-#endif
 
 	return 1;
 }
@@ -504,6 +501,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
 
 	g_sdio.dPrint = func;
+	g_sdio.irq_gpio = (wilc->dev_irq_num);
 
 	if (!wilc_sdio_init()) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
@@ -662,36 +660,33 @@ static int sdio_read_int(u32 *int_status)
 	/**
 	 *      Read IRQ flags
 	 **/
-#ifndef WILC_SDIO_IRQ_GPIO
-	cmd.function = 1;
-	cmd.address = 0x04;
-	cmd.data = 0;
-	wilc_sdio_cmd52(&cmd);
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
+		wilc_sdio_cmd52(&cmd);
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
@@ -704,8 +699,6 @@ static int sdio_read_int(u32 *int_status)
 		tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
 	}
 
-#endif
-
 	*int_status = tmp;
 
 	return 1;
@@ -718,16 +711,14 @@ static int sdio_clear_int_ext(u32 val)
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
@@ -754,8 +745,7 @@ static int sdio_clear_int_ext(u32 val)
 
 		}
 	} else {
-#ifdef WILC_SDIO_IRQ_GPIO
-		{
+		if (g_sdio.irq_gpio) {
 			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
 			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
 			u32 flags;
@@ -795,7 +785,6 @@ static int sdio_clear_int_ext(u32 val)
 				}
 			}
 		}
-#endif /* WILC_SDIO_IRQ_GPIO */
 
 		{
 			u32 vmm_ctl;
@@ -862,8 +851,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 		return 0;
 	}
 
-#ifdef WILC_SDIO_IRQ_GPIO
-	{
+	if (g_sdio.irq_gpio) {
 		u32 reg;
 		int ret, i;
 
@@ -915,7 +903,6 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 			}
 		}
 	}
-#endif /* WILC_SDIO_IRQ_GPIO */
 	return 1;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index eae9ce175351..92f4cb71608d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -158,10 +158,9 @@ struct wilc_vif {
 struct wilc {
 	int io_type;
 	int mac_status;
+	int gpio;
 	bool initialized;
-	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-	unsigned short dev_irq_num;
-	#endif
+	int dev_irq_num;
 	int close;
 	u8 vif_num;
 	struct wilc_vif vif[NUM_CONCURRENT_IFC];
@@ -213,7 +212,7 @@ void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
-int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type);
+int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 2958689a13c6..3d53550149fb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1174,9 +1174,6 @@ void wilc_handle_isr(void *wilc)
 		wilc_sleeptimer_isr_ext(int_status);
 
 	if (!(int_status & (ALL_INT_EXT))) {
-#ifdef WILC_SDIO
-		PRINT_D(TX_DBG, ">> UNKNOWN_INTERRUPT - 0x%08x\n", int_status);
-#endif
 		wilc_unknown_isr_ext();
 	}
 	release_bus(RELEASE_ALLOW_SLEEP);
@@ -1267,9 +1264,8 @@ int wilc_wlan_start(void)
 		return ret;
 	}
 	reg = 0;
-#ifdef WILC_SDIO_IRQ_GPIO
-	reg |= WILC_HAVE_SDIO_IRQ_GPIO;
-#endif
+	if (p->io_type == HIF_SDIO && wilc_dev->dev_irq_num)
+		reg |= WILC_HAVE_SDIO_IRQ_GPIO;
 
 #ifdef WILC_DISABLE_PMU
 #else
-- 
2.1.0.rc2

