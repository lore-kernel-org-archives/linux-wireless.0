Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:50930 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbbJTWsP (ORCPT
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
Subject: [PATCH 10/19] staging/wilc1000: unify device pointer
Date: Wed, 21 Oct 2015 00:47:29 +0200
Message-Id: <1445381258-1455986-11-git-send-email-arnd@arndb.de> (sfid-20151021_005024_823807_6067618D)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct wilc has two pointers to store the device, one for sdio_func
and one for spi_device. By changing the pointer to a 'struct device',
we can simplify the logic and avoid a few #ifdefs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 29 +++++----------------------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  5 +++--
 drivers/staging/wilc1000/linux_wlan_spi.c     | 17 +++++++++++++++-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  6 +-----
 4 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index caa85442c12d..4ca045bcf537 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -474,19 +474,11 @@ int wilc1000_wlan_get_firmware(perInterface_wlan_t *p_nic)
 	/*	the firmare should be located in /lib/firmware in
 	 *      root file system with the name specified above */
 
-#ifdef WILC_SDIO
-	if (request_firmware(&wilc_firmware, firmware, &wilc1000_dev->wilc_sdio_func->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, wilc1000_dev->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
-#else
-	if (request_firmware(&wilc_firmware, firmware, &wilc1000_dev->wilc_spidev->dev) != 0) {
-		PRINT_ER("%s - firmare not available\n", firmware);
-		ret = -1;
-		goto _fail_;
-	}
-#endif
 	wilc1000_dev->wilc_firmware = wilc_firmware;
 
 _fail_:
@@ -1008,7 +1000,7 @@ static u8 wilc1000_prepare_11b_core(struct wilc *nic)
 		while (!wilc1000_probe)
 			msleep(100);
 		wilc1000_probe = 0;
-		wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
+		wilc1000_dev->dev = &wilc1000_sdio_func->dev;
 		nic->ops = &wilc1000_sdio_ops;
 		wilc_wlan_init(nic);
 	}
@@ -1031,7 +1023,7 @@ static int repeat_power_cycle(perInterface_wlan_t *nic)
 	while (!wilc1000_probe)
 		msleep(100);
 	wilc1000_probe = 0;
-	wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
+	wilc1000_dev->dev = &wilc1000_sdio_func->dev;
 	wilc1000_dev->ops = &wilc1000_sdio_ops;
 	ret = wilc_wlan_init(wilc1000_dev);
 
@@ -1214,12 +1206,11 @@ int wilc1000_mac_open(struct net_device *ndev)
 	int i = 0;
 	struct wilc_priv *priv;
 
-#ifdef WILC_SPI
-	if (!wilc1000_dev || !wilc1000_dev->wilc_spidev) {
+	if (!wilc1000_dev || !wilc1000_dev->dev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
-#endif
+
 	nic = netdev_priv(ndev);
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
@@ -1712,16 +1703,6 @@ int wilc_netdev_init(void)
 
 	}
 
-	#ifndef WILC_SDIO
-	if (!wilc1000_spi_init(&wilc1000_dev->wilc_spidev)) {
-		PRINT_ER("Can't initialize SPI\n");
-		return -1; /* ERROR */
-	}
-	wilc1000_dev->wilc_spidev = wilc_spi_dev;
-	#else
-	wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
-	#endif
-
 	return 0;
 }
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index badcae57875c..a6ae26739dd8 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -46,7 +46,7 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 
 int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd)
 {
-	struct sdio_func *func = wilc1000_dev->wilc_sdio_func;
+	struct sdio_func *func = container_of(wilc1000_dev->dev, struct sdio_func, dev);
 	int ret;
 	u8 data;
 
@@ -78,7 +78,7 @@ int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd)
 
 int wilc1000_sdio_cmd53(sdio_cmd53_t *cmd)
 {
-	struct sdio_func *func = wilc1000_dev->wilc_sdio_func;
+	struct sdio_func *func = container_of(wilc1000_dev->dev, struct sdio_func, dev);
 	int size, ret;
 
 	sdio_claim_host(func);
@@ -126,6 +126,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
+	wilc1000_dev->dev = &wilc1000_sdio_func->dev;
 
 	printk("Driver Initializing success\n");
 	return 0;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index c90b741824dc..b5e9a1b9f509 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -9,8 +9,11 @@
 #include <linux/device.h>
 #include <linux/spi/spi.h>
 
+#include "wilc_wfi_netdevice.h"
 #include "linux_wlan_common.h"
 #include "linux_wlan_spi.h"
+#include "wilc_wlan_if.h"
+#include "wilc_wlan.h"
 
 #define USE_SPI_DMA     0       /* johnny add */
 
@@ -409,8 +412,20 @@ int wilc1000_spi_set_max_speed(void)
 
 static int __init init_wilc_spi_driver(void)
 {
+	int ret;
+
 	wilc1000_init_driver();
-	return wilc_netdev_init();
+	ret = wilc_netdev_init();
+	if (ret)
+		return ret;
+
+	if (!wilc1000_spi_init(NULL)) {
+		PRINT_ER("Can't initialize SPI\n");
+		return -ENXIO;
+	}
+	wilc1000_dev->dev = &wilc_spi_dev->dev;
+
+	return ret;
 }
 late_initcall(init_wilc_spi_driver);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 485df4768e78..1e5e7dcee11d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -185,11 +185,7 @@ struct wilc {
 
 	const struct firmware *wilc_firmware;
 
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

