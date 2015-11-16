Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58537 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbbKPOF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/19] staging/wilc1000: pass io_type to wilc_netdev_init
Date: Mon, 16 Nov 2015 15:05:02 +0100
Message-Id: <1447682710-2908925-12-git-send-email-arnd@arndb.de> (sfid-20151116_150849_694318_1229760C)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to avoid some of the #ifdefs, this passes the io_type
and device pointer as an argument to wilc_netdev_init.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 18 ++++--------------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  4 ++--
 drivers/staging/wilc1000/linux_wlan_spi.c     |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 4 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index faad01f6f2d1..b1707147aa7d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -25,11 +25,7 @@
 
 #include <linux/semaphore.h>
 
-#ifdef WILC_SDIO
 #include "linux_wlan_sdio.h"
-#else
-#include "linux_wlan_spi.h"
-#endif
 
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr);
 
@@ -884,11 +880,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wlan_init_locks(dev);
 
-#ifdef WILC_SDIO
-		wl->io_type = HIF_SDIO;
-#else
-		wl->io_type = HIF_SPI;
-#endif
 		ret = wilc_wlan_init(dev);
 		if (ret < 0) {
 			PRINT_ER("Initializing WILC_Wlan FAILED\n");
@@ -1426,7 +1417,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 #endif
 }
 
-int wilc_netdev_init(struct wilc **wilc)
+int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type)
 {
 	int i;
 	perInterface_wlan_t *nic;
@@ -1439,7 +1430,7 @@ int wilc_netdev_init(struct wilc **wilc)
 		return -ENOMEM;
 
 	*wilc = wilc_dev;
-
+	wilc_dev->io_type = io_type;
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
@@ -1468,9 +1459,8 @@ int wilc_netdev_init(struct wilc **wilc)
 			struct wireless_dev *wdev;
 			wdev = wilc_create_wiphy(ndev);
 
-			#ifdef WILC_SDIO
-			SET_NETDEV_DEV(ndev, &wilc_sdio_func->dev);
-			#endif
+			if (dev)
+				SET_NETDEV_DEV(ndev, dev);
 
 			if (!wdev) {
 				PRINT_ER("Can't register WILC Wiphy\n");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 8df69b2aff2d..d2843b949a1b 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -1,4 +1,5 @@
 #include "wilc_wfi_netdevice.h"
+#include "linux_wlan_sdio.h"
 
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
@@ -113,7 +114,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	wilc_sdio_func = func;
-	if (wilc_netdev_init(&wilc)) {
+	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
@@ -215,7 +216,6 @@ int wilc_sdio_set_default_speed(void)
 	return linux_sdio_set_speed(sdio_default_speed);
 }
 
-
 static int __init init_wilc_sdio_driver(void)
 {
 	return sdio_register_driver(&wilc_bus);
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 29dd9d4e5ff0..a459c502a8a8 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -9,9 +9,9 @@
 #include <linux/device.h>
 #include <linux/spi/spi.h>
 
+#include "linux_wlan_spi.h"
 #include "wilc_wfi_netdevice.h"
 #include "linux_wlan_common.h"
-#include "linux_wlan_spi.h"
 #include "wilc_wlan_if.h"
 
 #define USE_SPI_DMA     0       /* johnny add */
@@ -404,7 +404,7 @@ static int __init init_wilc_spi_driver(void)
 
 	wilc_debugfs_init();
 
-	ret = wilc_netdev_init(&wilc);
+	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI);
 	if (ret) {
 		wilc_debugfs_remove();
 		return ret;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a099f2877b6e..eae9ce175351 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -213,7 +213,7 @@ void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
-int wilc_netdev_init(struct wilc **wilc);
+int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value);
-- 
2.1.0.rc2

