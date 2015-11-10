Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:53338 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbbKJXnC (ORCPT
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
Subject: [PATCH 10/20] staging/wilc1000: move init/exit functions to driver files
Date: Wed, 11 Nov 2015 00:42:30 +0100
Message-Id: <1447198960-2760143-11-git-send-email-arnd@arndb.de> (sfid-20151111_004543_701108_51C082BE)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver interfaces are in linux_wlan_sdio.c and linux_wlan_spi.c, so
this is where the init and exit functions should be. Splitting this up
enables further cleanups, including eventually allowing both modules
to be built together.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 51 +--------------------------
 drivers/staging/wilc1000/linux_wlan_common.h  | 10 ++++++
 drivers/staging/wilc1000/linux_wlan_sdio.c    | 16 +++++++--
 drivers/staging/wilc1000/linux_wlan_sdio.h    |  6 ++--
 drivers/staging/wilc1000/linux_wlan_spi.c     | 23 +++++++++++-
 drivers/staging/wilc1000/linux_wlan_spi.h     |  3 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 7 files changed, 52 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 0747a0eefe92..876bcfb3b546 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1398,7 +1398,7 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 		WILC_WFI_p2p_rx(wilc->vif[1].ndev, buff, size);
 }
 
-void wl_wlan_cleanup(struct wilc *wilc)
+void wilc_netdev_cleanup(struct wilc *wilc)
 {
 	int i = 0;
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC];
@@ -1517,52 +1517,3 @@ int wilc_netdev_init(struct wilc **wilc)
 
 	return 0;
 }
-
-static int __init init_wilc_driver(void)
-{
-#ifdef WILC_SPI
-	struct wilc *wilc;
-#endif
-
-#if defined(WILC_DEBUGFS)
-	if (wilc_debugfs_init() < 0) {
-		PRINT_D(GENERIC_DBG, "fail to create debugfs for wilc driver\n");
-		return -1;
-	}
-#endif
-
-	printk("IN INIT FUNCTION\n");
-	printk("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
-
-#ifdef WILC_SDIO
-	{
-		int ret;
-
-		ret = sdio_register_driver(&wilc_bus);
-		if (ret < 0)
-			PRINT_D(INIT_DBG, "init_wilc_driver: Failed register sdio driver\n");
-
-		return ret;
-	}
-#else
-	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	if (wilc_netdev_init(&wilc))
-		PRINT_ER("Couldn't initialize netdev\n");
-	return 0;
-#endif
-}
-late_initcall(init_wilc_driver);
-
-static void __exit exit_wilc_driver(void)
-{
-#ifndef WILC_SDIO
-	PRINT_D(INIT_DBG, "SPI unregister...\n");
-	spi_unregister_driver(&wilc_bus);
-#else
-	PRINT_D(INIT_DBG, "SDIO unregister...\n");
-	sdio_unregister_driver(&wilc_bus);
-#endif
-}
-module_exit(exit_wilc_driver);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index b8dfc4a5e5cb..f2ea8280b8f8 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -121,6 +121,16 @@ extern atomic_t WILC_DEBUG_LEVEL;
 		printk("ERR [%s: %d]", __func__, __LINE__);		\
 		printk(__VA_ARGS__);					\
 	} while (0)
+
+static inline int wilc_debugfs_init(void)
+{
+	return 0;
+}
+
+static inline void wilc_debugfs_remove(void)
+{
+}
+
 #endif
 
 #define FN_IN   /* PRINT_D(">>> \n") */
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 0b01873faf79..06fd0e600c2a 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -146,11 +146,11 @@ static void linux_sdio_remove(struct sdio_func *func)
 	struct wilc_sdio *wl_sdio;
 
 	wl_sdio = sdio_get_drvdata(func);
-	wl_wlan_cleanup(wl_sdio->wilc);
+	wilc_netdev_cleanup(wl_sdio->wilc);
 	kfree(wl_sdio);
 }
 
-struct sdio_driver wilc_bus = {
+static struct sdio_driver wilc_bus = {
 	.name		= SDIO_MODALIAS,
 	.id_table	= wilc_sdio_ids,
 	.probe		= linux_sdio_probe,
@@ -237,4 +237,16 @@ int wilc_sdio_set_default_speed(void)
 }
 
 
+static int __init init_wilc_sdio_driver(void)
+{
+	return sdio_register_driver(&wilc_bus);
+}
+late_initcall(init_wilc_sdio_driver);
+
+static void __exit exit_wilc_sdio_driver(void)
+{
+	sdio_unregister_driver(&wilc_bus);
+}
+module_exit(exit_wilc_sdio_driver);
 
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 49cce2c43410..3e1618526e78 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,11 +1,11 @@
-extern struct sdio_func *wilc_sdio_func;
-extern struct sdio_driver wilc_bus;
-
 #include <linux/mmc/sdio_func.h>
 
+extern struct sdio_func *wilc_sdio_func;
+
 int wilc_sdio_init(void);
 int wilc_sdio_cmd52(sdio_cmd52_t *cmd);
 int wilc_sdio_cmd53(sdio_cmd53_t *cmd);
+
 int wilc_sdio_enable_interrupt(void);
 void wilc_sdio_disable_interrupt(void);
 int wilc_sdio_set_max_speed(void);
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 790128f6d034..f279a434c4c2 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -11,6 +11,7 @@
 
 #include "linux_wlan_common.h"
 #include "linux_wlan_spi.h"
+#include "wilc_wfi_netdevice.h"
 
 #define USE_SPI_DMA     0       /* johnny add */
 
@@ -68,7 +69,7 @@ static const struct of_device_id wilc1000_of_match[] = {
 MODULE_DEVICE_TABLE(of, wilc1000_of_match);
 #endif
 
-struct spi_driver wilc_bus __refdata = {
+static struct spi_driver wilc_bus __refdata = {
 	.driver = {
 		.name = MODALIAS,
 #ifdef CONFIG_OF
@@ -393,3 +394,23 @@ int wilc_spi_set_max_speed(void)
 	PRINT_INFO(BUS_DBG, "@@@@@@@@@@@@ change SPI speed to %d @@@@@@@@@\n", SPEED);
 	return 1;
 }
+
+static struct wilc *wilc;
+
+static int __init init_wilc_spi_driver(void)
+{
+	wilc_debugfs_init();
+	return wilc_netdev_init(&wilc);
+}
+late_initcall(init_wilc_spi_driver);
+
+static void __exit exit_wilc_spi_driver(void)
+{
+	if (wilc)
+		wilc_netdev_cleanup(wilc);
+	spi_unregister_driver(&wilc_bus);
+	wilc_debugfs_remove();
+}
+module_exit(exit_wilc_spi_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index aecb522ff56d..f434f79913ab 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -2,12 +2,11 @@
 #define LINUX_WLAN_SPI_H
 
 #include <linux/spi/spi.h>
-extern struct spi_device *wilc_spi_dev;
-extern struct spi_driver wilc_bus;
 
 int wilc_spi_init(void);
 int wilc_spi_write(u8 *b, u32 len);
 int wilc_spi_read(u8 *rb, u32 rlen);
 int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
 int wilc_spi_set_max_speed(void);
+
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0c608d73a22e..9adac5c781ee 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -216,7 +216,7 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag);
 void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
-void wl_wlan_cleanup(struct wilc *wilc);
+void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-- 
2.1.0.rc2

