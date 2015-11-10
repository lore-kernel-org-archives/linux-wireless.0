Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:52226 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbKJXnC (ORCPT
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
Subject: [PATCH 19/20] staging/wilc1000: use more regular probing
Date: Wed, 11 Nov 2015 00:42:39 +0100
Message-Id: <1447198960-2760143-20-git-send-email-arnd@arndb.de> (sfid-20151111_004626_713133_90D13062)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far, my patches tried to do equivalent conversions of the
existing code.  This one goes beyond that by restructuring
how the devices get probed. In particular, the spi driver
no longer creates the netdev until the device is probed,
and I've removed the global wilc_sdio_func and wilc_spi_dev
variables in favor of retrieving them from the wilc_dev
variable that will eventually get passed through all functions
instead of using a global.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c        |   6 +-
 drivers/staging/wilc1000/linux_wlan_common.h |  12 ---
 drivers/staging/wilc1000/linux_wlan_sdio.c   |  30 +++----
 drivers/staging/wilc1000/linux_wlan_spi.c    | 122 +++++++++------------------
 drivers/staging/wilc1000/wilc_debugfs.c      |   6 +-
 5 files changed, 58 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 0d6c22ca7920..c3b521e085f2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1408,10 +1408,6 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	}
 
 	kfree(wilc);
-
-#if defined(WILC_DEBUGFS)
-	wilc_debugfs_remove();
-#endif
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
 
@@ -1491,3 +1487,5 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index f2ea8280b8f8..72b524a98cba 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -38,9 +38,6 @@ enum debug_region {
 #define FIRM_DBG                (1 << Firmware_debug)
 
 #if defined (WILC_DEBUGFS)
-int wilc_debugfs_init(void);
-void wilc_debugfs_remove(void);
-
 extern atomic_t WILC_REGION;
 extern atomic_t WILC_DEBUG_LEVEL;
 
@@ -122,15 +119,6 @@ extern atomic_t WILC_DEBUG_LEVEL;
 		printk(__VA_ARGS__);					\
 	} while (0)
 
-static inline int wilc_debugfs_init(void)
-{
-	return 0;
-}
-
-static inline void wilc_debugfs_remove(void)
-{
-}
-
 #endif
 
 #define FN_IN   /* PRINT_D(">>> \n") */
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 9072de43bcd9..1f366b5f0d2d 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -135,12 +135,14 @@ static void linux_sdio_remove(struct sdio_func *func)
 	wilc_netdev_cleanup(sdio_get_drvdata(func));
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
 
 int wilc_sdio_enable_interrupt(struct wilc *dev)
 {
@@ -178,14 +180,15 @@ void wilc_sdio_disable_interrupt(struct wilc *dev)
 static int linux_sdio_set_speed(int speed)
 {
 	struct mmc_ios ios;
+	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
 
-	sdio_claim_host(wilc_sdio_func);
+	sdio_claim_host(func);
 
-	memcpy((void *)&ios, (void *)&wilc_sdio_func->card->host->ios, sizeof(struct mmc_ios));
-	wilc_sdio_func->card->host->ios.clock = speed;
+	memcpy((void *)&ios, (void *)&func->card->host->ios, sizeof(struct mmc_ios));
+	func->card->host->ios.clock = speed;
 	ios.clock = speed;
-	wilc_sdio_func->card->host->ops->set_ios(wilc_sdio_func->card->host, &ios);
-	sdio_release_host(wilc_sdio_func);
+	func->card->host->ops->set_ios(func->card->host, &ios);
+	sdio_release_host(func);
 	PRINT_INFO(INIT_DBG, "@@@@@@@@@@@@ change SDIO speed to %d @@@@@@@@@\n", speed);
 
 	return 1;
@@ -193,7 +196,8 @@ static int linux_sdio_set_speed(int speed)
 
 static int linux_sdio_get_speed(void)
 {
-	return wilc_sdio_func->card->host->ios.clock;
+	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
+	return func->card->host->ios.clock;
 }
 
 int wilc_sdio_init(void)
@@ -218,16 +222,4 @@ int wilc_sdio_set_default_speed(void)
 	return linux_sdio_set_speed(sdio_default_speed);
 }
 
-static int __init init_wilc_sdio_driver(void)
-{
-	return sdio_register_driver(&wilc_bus);
-}
-late_initcall(init_wilc_sdio_driver);
-
-static void __exit exit_wilc_sdio_driver(void)
-{
-	sdio_unregister_driver(&wilc_bus);
-}
-module_exit(exit_wilc_sdio_driver);
-
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index a7a52593156a..1d8922d6eb6a 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 #include <linux/device.h>
 #include <linux/spi/spi.h>
+#include <linux/of_gpio.h>
 
 #include "linux_wlan_spi.h"
 #include "wilc_wfi_netdevice.h"
@@ -43,59 +44,53 @@
 
 static u32 SPEED = MIN_SPEED;
 
-struct spi_device *wilc_spi_dev;
+static const struct wilc1000_ops wilc1000_spi_ops;
 
-static int __init wilc_bus_probe(struct spi_device *spi)
+static int wilc_bus_probe(struct spi_device *spi)
 {
+	int ret, gpio;
+	struct wilc *wilc;
 
-	PRINT_D(BUS_DBG, "spiModalias: %s\n", spi->modalias);
-	PRINT_D(BUS_DBG, "spiMax-Speed: %d\n", spi->max_speed_hz);
-	wilc_spi_dev = spi;
+	gpio = of_get_gpio(spi->dev.of_node, 0);
+	if (gpio < 0)
+		gpio = GPIO_NUM;
+
+	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM, &wilc_hif_spi);
+	if (ret)
+		return ret;
+
+	spi_set_drvdata(spi, wilc);
+	wilc->dev = &spi->dev;
 
-	printk("Driver Initializing success\n");
 	return 0;
 }
 
-static int __exit wilc_bus_remove(struct spi_device *spi)
+static int wilc_bus_remove(struct spi_device *spi)
 {
-
+	wilc_netdev_cleanup(spi_get_drvdata(spi));
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static const struct of_device_id wilc1000_of_match[] = {
 	{ .compatible = "atmel,wilc_spi", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, wilc1000_of_match);
-#endif
 
-static struct spi_driver wilc_bus __refdata = {
+struct spi_driver wilc1000_spi_driver = {
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
+module_spi_driver(wilc1000_spi_driver);
+MODULE_LICENSE("GPL");
 
 int wilc_spi_init(void)
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
@@ -106,6 +101,7 @@ int wilc_spi_init(void)
 
 int wilc_spi_write(u8 *b, u32 len)
 {
+	struct spi_device *spi = to_spi_device(wilc_dev->dev);
 	int ret;
 
 	if (len > 0 && b != NULL) {
@@ -132,11 +128,11 @@ int wilc_spi_write(u8 *b, u32 len)
 
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
@@ -157,11 +153,11 @@ int wilc_spi_write(u8 *b, u32 len)
 
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
@@ -183,7 +179,7 @@ int wilc_spi_write(u8 *b, u32 len)
 #else
 int wilc_spi_write(u8 *b, u32 len)
 {
-
+	struct spi_device *spi = to_spi_device(wilc_dev->dev);
 	int ret;
 	struct spi_message msg;
 
@@ -204,12 +200,12 @@ int wilc_spi_write(u8 *b, u32 len)
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
@@ -234,6 +230,7 @@ int wilc_spi_write(u8 *b, u32 len)
 
 int wilc_spi_read(u8 *rb, u32 rlen)
 {
+	struct spi_device *spi = to_spi_device(wilc_dev->dev);
 	int ret;
 
 	if (rlen > 0) {
@@ -260,11 +257,11 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 
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
@@ -284,11 +281,11 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 
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
@@ -308,7 +305,7 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 #else
 int wilc_spi_read(u8 *rb, u32 rlen)
 {
-
+	struct spi_device *spi = to_spi_device(wilc_dev->dev);
 	int ret;
 
 	if (rlen > 0) {
@@ -329,12 +326,12 @@ int wilc_spi_read(u8 *rb, u32 rlen)
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
@@ -353,7 +350,7 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 
 int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 {
-
+	struct spi_device *spi = to_spi_device(wilc_dev->dev);
 	int ret;
 
 	if (rlen > 0) {
@@ -370,11 +367,11 @@ int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 
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
@@ -395,40 +392,3 @@ int wilc_spi_set_max_speed(void)
 	PRINT_INFO(BUS_DBG, "@@@@@@@@@@@@ change SPI speed to %d @@@@@@@@@\n", SPEED);
 	return 1;
 }
-
-static struct wilc *wilc;
-
-static int __init init_wilc_spi_driver(void)
-{
-	int ret;
-
-	wilc_debugfs_init();
-
-	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM, &wilc_hif_spi);
-	if (ret) {
-		wilc_debugfs_remove();
-		return ret;
-	}
-
-	if (!wilc_spi_init() || !wilc_spi_dev) {
-		PRINT_ER("Can't initialize SPI\n");
-		wilc_netdev_cleanup(wilc);
-		wilc_debugfs_remove();
-		return -ENXIO;
-	}
-	wilc_dev->dev = &wilc_spi_dev->dev;
-
-	return ret;
-}
-late_initcall(init_wilc_spi_driver);
-
-static void __exit exit_wilc_spi_driver(void)
-{
-	if (wilc)
-		wilc_netdev_cleanup(wilc);
-	spi_unregister_driver(&wilc_bus);
-	wilc_debugfs_remove();
-}
-module_exit(exit_wilc_spi_driver);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 158a1df17195..27c653a0cdf9 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -138,7 +138,7 @@ static struct wilc_debugfs_info_t debugfs_info[] = {
 	{ "wilc_debug_region",	0666,	(INIT_DBG | GENERIC_DBG | CFG80211_DBG), FOPS(NULL, wilc_debug_region_read, wilc_debug_region_write, NULL), },
 };
 
-int wilc_debugfs_init(void)
+static int __init wilc_debugfs_init(void)
 {
 	int i;
 
@@ -173,11 +173,13 @@ int wilc_debugfs_init(void)
 	}
 	return 0;
 }
+module_init(wilc_debugfs_init);
 
-void wilc_debugfs_remove(void)
+static void __exit wilc_debugfs_remove(void)
 {
 	debugfs_remove_recursive(wilc_dir);
 }
+module_exit(wilc_debugfs_remove);
 
 #endif
 
-- 
2.1.0.rc2

