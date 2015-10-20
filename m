Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63358 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbbJTWsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 19/19] [RFC] staging/wilc1000: use more regular probing
Date: Wed, 21 Oct 2015 00:47:38 +0200
Message-Id: <1445381258-1455986-20-git-send-email-arnd@arndb.de> (sfid-20151021_004840_261773_5D378082)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far, my patches tried to do equivalent conversions of the
existing code.  This one goes beyond that by restructuring
how the devices get probed. In particular, the spi driver
no longer creates the netdev until the device is probed,
and I've removed the global wilc1000_sdio_func and wilc_spi_dev
variables in favor of retrieving them from the wilc1000_dev
variable that will eventually get passed through all functions
instead of using a global.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c      |  30 ++++----
 drivers/staging/wilc1000/linux_wlan_sdio.c |  54 ++++---------
 drivers/staging/wilc1000/linux_wlan_spi.c  | 118 ++++++++++-------------------
 drivers/staging/wilc1000/wilc_wlan.h       |   5 +-
 4 files changed, 72 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8a5f4673c5d0..6e16c0b32f43 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1594,19 +1594,7 @@ int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops,
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_init);
 
-void __init wilc1000_init_driver(void)
-{
-#if defined(WILC_DEBUGFS)
-	if (wilc_debugfs_init() < 0)
-		PRINT_D(GENERIC_DBG, "fail to create debugfs for wilc driver\n");
-#endif
-
-	printk("IN INIT FUNCTION\n");
-	printk("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
-}
-EXPORT_SYMBOL_GPL(wilc1000_init_driver);
-
-void __exit wilc_netdev_free(struct wilc *wilc1000_dev)
+void wilc_netdev_free(struct wilc *wilc1000_dev)
 {
 	int i = 0;
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
@@ -1653,16 +1641,28 @@ void __exit wilc_netdev_free(struct wilc *wilc1000_dev)
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_free);
 
+int __init wilc1000_init_driver(void)
+{
+	int ret = 0;
+#if defined(WILC_DEBUGFS)
+	ret = wilc_debugfs_init();
+	if (ret < 0)
+		PRINT_D(GENERIC_DBG, "fail to create debugfs for wilc driver\n");
+#endif
+	return ret;
+
+}
+module_init(wilc1000_init_driver);
+
 void __exit wilc1000_exit_driver(void)
 {
 	kfree(wilc1000_dev);
 	wilc1000_dev = NULL;
-	printk("Module_exit Done.\n");
 
 #if defined(WILC_DEBUGFS)
 	wilc_debugfs_remove();
 #endif
 }
-EXPORT_SYMBOL_GPL(wilc1000_exit_driver);
+module_exit(wilc1000_exit_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 1f343ac72530..916c2a1d189d 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -24,7 +24,6 @@
 #endif
 
 
-static struct sdio_func *wilc1000_sdio_func;
 static unsigned int sdio_default_speed;
 
 #define SDIO_VENDOR_ID_WILC 0x0296
@@ -113,6 +112,7 @@ static const struct wilc1000_ops wilc1000_sdio_ops;
 
 static struct sdio_driver wilc_bus;
 static volatile int wilc1000_probe;
+static struct sdio_func *wilc1000_sdio_func;
 
 #define READY_CHECK_THRESHOLD		30
 static u8 wilc1000_prepare_11b_core(struct wilc *nic)
@@ -195,6 +195,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 		PRINT_D(INIT_DBG, "wilc1000_sdio_func isn't NULL\n");
 		return 0;
 	}
+	wilc1000_sdio_func = func;
 #endif
 
 	gpio = -1;
@@ -205,13 +206,13 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 	}
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	wilc1000_sdio_func = func;
 	if (wilc_netdev_init(&func->dev, &wilc1000_sdio_ops,
 	    &wilc1000_hif_sdio, gpio)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
-	wilc1000_dev->dev = &wilc1000_sdio_func->dev;
+	wilc1000_dev->dev = &func->dev;
+	sdio_set_drvdata(func, wilc1000_dev);
 
 	printk("Driver Initializing success\n");
 	return 0;
@@ -219,18 +220,17 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 static void linux_sdio_remove(struct sdio_func *func)
 {
-	/**
-	 *      TODO
-	 **/
-
+	wilc_netdev_free(sdio_get_drvdata(func));
 }
 
-static struct sdio_driver wilc_bus = {
+static struct sdio_driver wilc1000_sdio_driver = {
 	.name		= SDIO_MODALIAS,
 	.id_table	= wilc_sdio_ids,
 	.probe		= linux_sdio_probe,
 	.remove		= linux_sdio_remove,
 };
+module_driver(wilc1000_sdio_driver, sdio_register_driver, sdio_unregister_driver);
+MODULE_LICENSE("GPL");
 
 static int wilc1000_sdio_enable_interrupt(struct wilc *dev)
 {
@@ -268,14 +268,15 @@ static void wilc1000_sdio_disable_interrupt(struct wilc *dev)
 static int linux_sdio_set_speed(int speed)
 {
 	struct mmc_ios ios;
+	struct sdio_func *func = container_of(wilc1000_dev->dev, struct sdio_func, dev);
 
-	sdio_claim_host(wilc1000_sdio_func);
+	sdio_claim_host(func);
 
-	memcpy((void *)&ios, (void *)&wilc1000_sdio_func->card->host->ios, sizeof(struct mmc_ios));
-	wilc1000_sdio_func->card->host->ios.clock = speed;
+	memcpy((void *)&ios, (void *)&func->card->host->ios, sizeof(struct mmc_ios));
+	func->card->host->ios.clock = speed;
 	ios.clock = speed;
-	wilc1000_sdio_func->card->host->ops->set_ios(wilc1000_sdio_func->card->host, &ios);
-	sdio_release_host(wilc1000_sdio_func);
+	func->card->host->ops->set_ios(func->card->host, &ios);
+	sdio_release_host(func);
 	PRINT_INFO(INIT_DBG, "@@@@@@@@@@@@ change SDIO speed to %d @@@@@@@@@\n", speed);
 
 	return 1;
@@ -283,7 +284,8 @@ static int linux_sdio_set_speed(int speed)
 
 static int linux_sdio_get_speed(void)
 {
-	return wilc1000_sdio_func->card->host->ios.clock;
+	struct sdio_func *func = container_of(wilc1000_dev->dev, struct sdio_func, dev);
+	return func->card->host->ios.clock;
 }
 
 static int wilc1000_sdio_init(void *pv)
@@ -300,13 +302,6 @@ static int wilc1000_sdio_init(void *pv)
 
 static void wilc1000_sdio_deinit(void *pv)
 {
-
-	/**
-	 *      TODO :
-	 **/
-
-
-	sdio_unregister_driver(&wilc_bus);
 }
 
 static int wilc1000_sdio_set_max_speed(void)
@@ -334,20 +329,3 @@ static const struct wilc1000_ops wilc1000_sdio_ops = {
 	.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed,
 	.u.sdio.sdio_set_default_speed = wilc1000_sdio_set_default_speed,
 };
-
-static int __init init_wilc_sdio_driver(void)
-{
-	wilc1000_init_driver();
-	return sdio_register_driver(&wilc_bus);
-}
-late_initcall(init_wilc_sdio_driver);
-
-static void __exit exit_wilc_sdio_driver(void)
-{
-	if (wilc1000_dev)
-		wilc_netdev_free(wilc1000_dev);
-	sdio_unregister_driver(&wilc_bus);
-	wilc1000_exit_driver();
-}
-module_exit(exit_wilc_sdio_driver);
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index c0e0e6be6b0b..d472edcfdf9d 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 #include <linux/device.h>
 #include <linux/spi/spi.h>
+#include <linux/of_gpio.h>
 
 #include "wilc_wfi_netdevice.h"
 #include "linux_wlan_common.h"
@@ -43,72 +44,61 @@
 
 static u32 SPEED = MIN_SPEED;
 
-struct spi_device *wilc_spi_dev;
+static const struct wilc1000_ops wilc1000_spi_ops;
 
 static int __init wilc_bus_probe(struct spi_device *spi)
 {
+	int ret, gpio;
 
-	PRINT_D(BUS_DBG, "spiModalias: %s\n", spi->modalias);
-	PRINT_D(BUS_DBG, "spiMax-Speed: %d\n", spi->max_speed_hz);
-	wilc_spi_dev = spi;
+	gpio = of_get_gpio(spi->dev.of_node, 0);
+	if (gpio < 0)
+		gpio = GPIO_NUM;
+
+	ret = wilc_netdev_init(&spi->dev, &wilc1000_spi_ops, &wilc1000_hif_spi,
+			       gpio);
+	if (ret)
+		return ret;
+
+	spi_set_drvdata(spi, wilc1000_dev);
+	wilc1000_dev->dev = &spi->dev;
 
-	printk("Driver Initializing success\n");
 	return 0;
 }
 
-static int __exit wilc_bus_remove(struct spi_device *spi)
+static int wilc_bus_remove(struct spi_device *spi)
 {
-
+	wilc_netdev_free(spi_get_drvdata(spi));
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static const struct of_device_id wilc1000_of_match[] = {
 	{ .compatible = "atmel,wilc_spi", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, wilc1000_of_match);
-#endif
 
-struct spi_driver wilc_bus __refdata = {
+struct spi_driver wilc1000_spi_driver __refdata = {
 	.driver = {
 		.name = MODALIAS,
-#ifdef CONFIG_OF
 		.of_match_table = wilc1000_of_match,
-#endif
 	},
 	.probe =  wilc_bus_probe,
-	.remove = __exit_p(wilc_bus_remove),
+	.remove = wilc_bus_remove,
 };
-
+module_spi_driver(wilc1000_spi_driver);
+MODULE_LICENSE("GPL");
 
 static void wilc1000_spi_deinit(void *vp)
 {
-
-	spi_unregister_driver(&wilc_bus);
-
 	SPEED = MIN_SPEED;
 	PRINT_ER("@@@@@@@@@@@@ restore SPI speed to %d @@@@@@@@@\n", SPEED);
-
 }
 
 
 
 static int wilc1000_spi_init(void *vp)
 {
-	int ret = 1;
-	static int called;
-
-
-	if (called == 0) {
-		called++;
-		ret = spi_register_driver(&wilc_bus);
-	}
-
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
-
-	return ret;
+	return 1;
 }
 
 #if defined(PLAT_WMS8304)
@@ -119,6 +109,7 @@ static int wilc1000_spi_init(void *vp)
 
 static int wilc1000_spi_write(u8 *b, u32 len)
 {
+	struct spi_device *spi = to_spi_device(wilc1000_dev->dev);
 	int ret;
 
 	if (len > 0 && b != NULL) {
@@ -145,11 +136,11 @@ static int wilc1000_spi_write(u8 *b, u32 len)
 
 				memset(&msg, 0, sizeof(msg));
 				spi_message_init(&msg);
-				msg.spi = wilc_spi_dev;
+				msg.spi = spi;
 				msg.is_dma_mapped = USE_SPI_DMA;
 
 				spi_message_add_tail(&tr, &msg);
-				ret = spi_sync(wilc_spi_dev, &msg);
+				ret = spi_sync(spi, &msg);
 				if (ret < 0) {
 					PRINT_ER("SPI transaction failed\n");
 				}
@@ -170,11 +161,11 @@ static int wilc1000_spi_write(u8 *b, u32 len)
 
 			memset(&msg, 0, sizeof(msg));
 			spi_message_init(&msg);
-			msg.spi = wilc_spi_dev;
+			msg.spi = spi;
 			msg.is_dma_mapped = USE_SPI_DMA;                                /* rachel */
 
 			spi_message_add_tail(&tr, &msg);
-			ret = spi_sync(wilc_spi_dev, &msg);
+			ret = spi_sync(spi, &msg);
 			if (ret < 0) {
 				PRINT_ER("SPI transaction failed\n");
 			}
@@ -196,7 +187,7 @@ static int wilc1000_spi_write(u8 *b, u32 len)
 #else
 static int wilc1000_spi_write(u8 *b, u32 len)
 {
-
+	struct spi_device *spi = to_spi_device(wilc1000_dev->dev);
 	int ret;
 	struct spi_message msg;
 
@@ -217,12 +208,12 @@ static int wilc1000_spi_write(u8 *b, u32 len)
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
 /* [[johnny add */
-		msg.spi = wilc_spi_dev;
+		msg.spi = spi;
 		msg.is_dma_mapped = USE_SPI_DMA;
 /* ]] */
 		spi_message_add_tail(&tr, &msg);
 
-		ret = spi_sync(wilc_spi_dev, &msg);
+		ret = spi_sync(spi, &msg);
 		if (ret < 0) {
 			PRINT_ER("SPI transaction failed\n");
 		}
@@ -247,6 +238,7 @@ static int wilc1000_spi_write(u8 *b, u32 len)
 
 static int wilc1000_spi_read(u8 *rb, u32 rlen)
 {
+	struct spi_device *spi = to_spi_device(wilc1000_dev->dev);
 	int ret;
 
 	if (rlen > 0) {
@@ -273,11 +265,11 @@ static int wilc1000_spi_read(u8 *rb, u32 rlen)
 
 				memset(&msg, 0, sizeof(msg));
 				spi_message_init(&msg);
-				msg.spi = wilc_spi_dev;
+				msg.spi = spi;
 				msg.is_dma_mapped = USE_SPI_DMA;
 
 				spi_message_add_tail(&tr, &msg);
-				ret = spi_sync(wilc_spi_dev, &msg);
+				ret = spi_sync(spi, &msg);
 				if (ret < 0) {
 					PRINT_ER("SPI transaction failed\n");
 				}
@@ -297,11 +289,11 @@ static int wilc1000_spi_read(u8 *rb, u32 rlen)
 
 			memset(&msg, 0, sizeof(msg));
 			spi_message_init(&msg);
-			msg.spi = wilc_spi_dev;
+			msg.spi = spi;
 			msg.is_dma_mapped = USE_SPI_DMA;                                /* rachel */
 
 			spi_message_add_tail(&tr, &msg);
-			ret = spi_sync(wilc_spi_dev, &msg);
+			ret = spi_sync(spi, &msg);
 			if (ret < 0) {
 				PRINT_ER("SPI transaction failed\n");
 			}
@@ -321,7 +313,7 @@ static int wilc1000_spi_read(u8 *rb, u32 rlen)
 #else
 static int wilc1000_spi_read(u8 *rb, u32 rlen)
 {
-
+	struct spi_device *spi = to_spi_device(wilc1000_dev->dev);
 	int ret;
 
 	if (rlen > 0) {
@@ -342,12 +334,12 @@ static int wilc1000_spi_read(u8 *rb, u32 rlen)
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
 /* [[ johnny add */
-		msg.spi = wilc_spi_dev;
+		msg.spi = spi;
 		msg.is_dma_mapped = USE_SPI_DMA;
 /* ]] */
 		spi_message_add_tail(&tr, &msg);
 
-		ret = spi_sync(wilc_spi_dev, &msg);
+		ret = spi_sync(spi, &msg);
 		if (ret < 0) {
 			PRINT_ER("SPI transaction failed\n");
 		}
@@ -366,7 +358,7 @@ static int wilc1000_spi_read(u8 *rb, u32 rlen)
 
 static int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 {
-
+	struct spi_device *spi = to_spi_device(wilc1000_dev->dev);
 	int ret;
 
 	if (rlen > 0) {
@@ -383,11 +375,11 @@ static int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
-		msg.spi = wilc_spi_dev;
+		msg.spi = spi;
 		msg.is_dma_mapped = USE_SPI_DMA;
 
 		spi_message_add_tail(&tr, &msg);
-		ret = spi_sync(wilc_spi_dev, &msg);
+		ret = spi_sync(spi, &msg);
 		if (ret < 0) {
 			PRINT_ER("SPI transaction failed\n");
 		}
@@ -418,33 +410,3 @@ static const struct wilc1000_ops wilc1000_spi_ops = {
 	.u.spi.spi_trx = wilc1000_spi_write_read,
 	.u.spi.spi_max_speed = wilc1000_spi_set_max_speed,
 };
-
-static int __init init_wilc_spi_driver(void)
-{
-	int ret;
-
-	wilc1000_init_driver();
-	ret = wilc_netdev_init(NULL, &wilc1000_spi_ops, &wilc1000_hif_spi,
-			       GPIO_NUM);
-	if (ret)
-		return ret;
-
-	if (!wilc1000_spi_init(NULL)) {
-		PRINT_ER("Can't initialize SPI\n");
-		return -ENXIO;
-	}
-	wilc1000_dev->dev = &wilc_spi_dev->dev;
-
-	return ret;
-}
-late_initcall(init_wilc_spi_driver);
-
-static void __exit exit_wilc_spi_driver(void)
-{
-	if (wilc1000_dev)
-		wilc_netdev_free(wilc1000_dev);
-	spi_unregister_driver(&wilc_bus);
-	wilc1000_exit_driver();
-}
-module_exit(exit_wilc_spi_driver);
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index f684d5bf465d..a551e6810ff3 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -320,7 +320,7 @@ int wilc1000_wlan_get_num_conn_ifcs(void);
 int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 int wilc_netdev_init(struct device *, const struct wilc1000_ops *ops,
 		     const struct wilc1000_hif_ops *hif_ops, int gpio);
-void __exit wilc_netdev_free(struct wilc *wilc1000_dev);
+void wilc_netdev_free(struct wilc *wilc1000_dev);
 
 void wilc_handle_isr(void);
 
@@ -340,7 +340,4 @@ extern bool wilc1000_enable_ps;
 int wilc1000_firmware_download(struct wilc *p_nic);
 int wilc1000_start_firmware(struct wilc_per_interface *nic);
 
-void __init wilc1000_init_driver(void);
-void __exit wilc1000_exit_driver(void);
-
 #endif
-- 
2.1.0.rc2

