Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:63887 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbKPOF1 (ORCPT
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
Subject: [PATCH 10/19] staging/wilc1000: unify device pointer
Date: Mon, 16 Nov 2015 15:05:01 +0100
Message-Id: <1447682710-2908925-11-git-send-email-arnd@arndb.de> (sfid-20151116_150904_480951_9C0B1FB5)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct wilc has two pointers to store the device, one for sdio_func
and one for spi_device. By changing the pointer to a 'struct device',
we can simplify the logic and avoid a few #ifdefs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 25 +++-----------------
 drivers/staging/wilc1000/linux_wlan_sdio.c    | 33 +++++----------------------
 drivers/staging/wilc1000/linux_wlan_spi.c     | 22 ++++++++++++++++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  6 +----
 4 files changed, 30 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 876bcfb3b546..faad01f6f2d1 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -453,19 +453,11 @@ int wilc_wlan_get_firmware(struct net_device *dev)
 		goto _fail_;
 	}
 
-#ifdef WILC_SDIO
-	if (request_firmware(&wilc_firmware, firmware, &wilc->wilc_sdio_func->dev) != 0) {
-		PRINT_ER("%s - firmare not available\n", firmware);
-		ret = -1;
-		goto _fail_;
-	}
-#else
-	if (request_firmware(&wilc_firmware, firmware, &wilc->wilc_spidev->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, wilc->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
-#endif
 	wilc->firmware = wilc_firmware;
 
 _fail_:
@@ -1015,12 +1007,11 @@ int wilc_mac_open(struct net_device *ndev)
 	nic = netdev_priv(ndev);
 	wl = nic->wilc;
 
-#ifdef WILC_SPI
-	if (!wl || !wl->wilc_spidev) {
+	if (!wl|| !wl->dev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
-#endif
+
 	nic = netdev_priv(ndev);
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
@@ -1505,15 +1496,5 @@ int wilc_netdev_init(struct wilc **wilc)
 		nic->mac_opened = 0;
 	}
 
-	#ifndef WILC_SDIO
-	if (!wilc_spi_init()) {
-		PRINT_ER("Can't initialize SPI\n");
-		return -1;
-	}
-	wilc_dev->wilc_spidev = wilc_spi_dev;
-	#else
-	wilc_dev->wilc_sdio_func = wilc_sdio_func;
-	#endif
-
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 06fd0e600c2a..8df69b2aff2d 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -21,13 +21,7 @@
  #define MAX_SPEED (6 * 1000000) /* Max 50M */
 #endif
 
-struct wilc_sdio {
-	struct sdio_func *func;
-	struct wilc *wilc;
-};
-
 struct sdio_func *wilc_sdio_func;
-
 static unsigned int sdio_default_speed;
 
 #define SDIO_VENDOR_ID_WILC 0x0296
@@ -42,12 +36,8 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 #ifndef WILC_SDIO_IRQ_GPIO
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
-	struct wilc_sdio *wl_sdio;
-
-	wl_sdio = sdio_get_drvdata(func);
-
 	sdio_release_host(func);
-	wilc_handle_isr(wl_sdio->wilc);
+	wilc_handle_isr(sdio_get_drvdata(func));
 	sdio_claim_host(func);
 }
 #endif
@@ -55,7 +45,7 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 
 int wilc_sdio_cmd52(sdio_cmd52_t *cmd)
 {
-	struct sdio_func *func = wilc_dev->wilc_sdio_func;
+	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
 	int ret;
 	u8 data;
 
@@ -87,7 +77,7 @@ int wilc_sdio_cmd52(sdio_cmd52_t *cmd)
 
 int wilc_sdio_cmd53(sdio_cmd53_t *cmd)
 {
-	struct sdio_func *func = wilc_dev->wilc_sdio_func;
+	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
 	int size, ret;
 
 	sdio_claim_host(func);
@@ -118,24 +108,17 @@ int wilc_sdio_cmd53(sdio_cmd53_t *cmd)
 
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
-	struct wilc_sdio *wl_sdio;
 	struct wilc *wilc;
 
-	PRINT_D(INIT_DBG, "probe function\n");
-	wl_sdio = kzalloc(sizeof(struct wilc_sdio), GFP_KERNEL);
-	if (!wl_sdio)
-		return -ENOMEM;
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	wilc_sdio_func = func;
 	if (wilc_netdev_init(&wilc)) {
 		PRINT_ER("Couldn't initialize netdev\n");
-		kfree(wl_sdio);
 		return -1;
 	}
-	wl_sdio->func = func;
-	wl_sdio->wilc = wilc;
-	sdio_set_drvdata(func, wl_sdio);
+	sdio_set_drvdata(func, wilc);
+	wilc->dev = &func->dev;
 
 	printk("Driver Initializing success\n");
 	return 0;
@@ -143,11 +126,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 static void linux_sdio_remove(struct sdio_func *func)
 {
-	struct wilc_sdio *wl_sdio;
-
-	wl_sdio = sdio_get_drvdata(func);
-	wilc_netdev_cleanup(wl_sdio->wilc);
-	kfree(wl_sdio);
+	wilc_netdev_cleanup(sdio_get_drvdata(func));
 }
 
 static struct sdio_driver wilc_bus = {
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index f279a434c4c2..29dd9d4e5ff0 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -9,9 +9,10 @@
 #include <linux/device.h>
 #include <linux/spi/spi.h>
 
+#include "wilc_wfi_netdevice.h"
 #include "linux_wlan_common.h"
 #include "linux_wlan_spi.h"
-#include "wilc_wfi_netdevice.h"
+#include "wilc_wlan_if.h"
 
 #define USE_SPI_DMA     0       /* johnny add */
 
@@ -399,8 +400,25 @@ static struct wilc *wilc;
 
 static int __init init_wilc_spi_driver(void)
 {
+	int ret;
+
 	wilc_debugfs_init();
-	return wilc_netdev_init(&wilc);
+
+	ret = wilc_netdev_init(&wilc);
+	if (ret) {
+		wilc_debugfs_remove();
+		return ret;
+	}
+
+	if (!wilc_spi_init() || !wilc_spi_dev) {
+		PRINT_ER("Can't initialize SPI\n");
+		wilc_netdev_cleanup(wilc);
+		wilc_debugfs_remove();
+		return -ENXIO;
+	}
+	wilc_dev->dev = &wilc_spi_dev->dev;
+
+	return ret;
 }
 late_initcall(init_wilc_spi_driver);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 9adac5c781ee..a099f2877b6e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -185,11 +185,7 @@ struct wilc {
 
 	const struct firmware *firmware;
 
-#ifdef WILC_SDIO
-	struct sdio_func *wilc_sdio_func;
-#else
-	struct spi_device *wilc_spidev;
-#endif
+	struct device *dev;
 };
 
 typedef struct {
-- 
2.1.0.rc2

