Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:53141 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbbJTWsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/19] staging/wilc1000: move wilc1000_ops to drivers
Date: Wed, 21 Oct 2015 00:47:30 +0200
Message-Id: <1445381258-1455986-12-git-send-email-arnd@arndb.de> (sfid-20151021_004915_403251_8DC12D19)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two instances of struct wilc1000_ops reference functions that
are defined in just one file each. By moving the operations there,
we can mark all those functions as 'static' and avoid a number
of #ifdefs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c      | 43 ++++--------------------------
 drivers/staging/wilc1000/linux_wlan_sdio.c | 24 ++++++++++++-----
 drivers/staging/wilc1000/linux_wlan_sdio.h | 11 +++-----
 drivers/staging/wilc1000/linux_wlan_spi.c  | 29 +++++++++++++-------
 drivers/staging/wilc1000/linux_wlan_spi.h  |  8 ------
 drivers/staging/wilc1000/wilc_wlan.h       |  2 +-
 6 files changed, 45 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4ca045bcf537..aa6f5c7db139 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -26,11 +26,7 @@
 #include <linux/version.h>
 #include <linux/semaphore.h>
 
-#ifdef WILC_SDIO
 #include "linux_wlan_sdio.h"
-#else
-#include "linux_wlan_spi.h"
-#endif
 
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr);
 
@@ -915,30 +911,6 @@ static int wlan_deinit_locks(struct wilc *nic)
 	return 0;
 }
 
-#ifdef WILC_SDIO
-static const struct wilc1000_ops wilc1000_sdio_ops = {
-	.io_type = HIF_SDIO,
-	.io_init = wilc1000_sdio_init,
-	.io_deinit = wilc1000_sdio_deinit,
-	.u.sdio.sdio_cmd52 = wilc1000_sdio_cmd52,
-	.u.sdio.sdio_cmd53 = wilc1000_sdio_cmd53,
-	.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed,
-	.u.sdio.sdio_set_default_speed = wilc1000_sdio_set_default_speed,
-};
-#endif
-
-#ifdef WILC_SPI
-static const struct wilc1000_ops wilc1000_spi_ops = {
-	.io_type = HIF_SPI,
-	.io_init = wilc1000_spi_init,
-	.io_deinit = wilc1000_spi_deinit,
-	.u.spi.spi_tx = wilc1000_spi_write,
-	.u.spi.spi_rx = wilc1000_spi_read,
-	.u.spi.spi_trx = wilc1000_spi_write_read,
-	.u.spi.spi_max_speed = wilc1000_spi_set_max_speed,
-};
-#endif
-
 static int wlan_initialize_threads(perInterface_wlan_t *nic)
 {
 
@@ -1065,12 +1037,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wlan_init_locks(wilc1000_dev);
 
-#ifdef WILC_SDIO
-		wilc1000_dev->ops = &wilc1000_sdio_ops;
-#else
-		wilc1000_dev->ops = &wilc1000_spi_ops;
-#endif
-
 		ret = wilc_wlan_init(wilc1000_dev);
 		if (ret < 0) {
 			PRINT_ER("Initializing WILC_Wlan FAILED\n");
@@ -1622,7 +1588,7 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 		WILC_WFI_p2p_rx(wilc1000_dev->strInterfaceInfo[1].wilc_netdev, buff, size);
 }
 
-int wilc_netdev_init(void)
+int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops)
 {
 
 	int i;
@@ -1636,6 +1602,8 @@ int wilc_netdev_init(void)
 	if (!wilc1000_dev)
 		return -ENOMEM;
 
+	wilc1000_dev->ops = ops;
+
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
@@ -1672,10 +1640,9 @@ int wilc_netdev_init(void)
 			/*Register WiFi*/
 			wdev = wilc_create_wiphy(ndev);
 
-			#ifdef WILC_SDIO
 			/* set netdev, tony */
-			SET_NETDEV_DEV(ndev, &wilc1000_sdio_func->dev);
-			#endif
+			if (dev)
+				SET_NETDEV_DEV(ndev, dev);
 
 			if (wdev == NULL) {
 				PRINT_ER("Can't register WILC Wiphy\n");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index a6ae26739dd8..429bdc85ed62 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -1,4 +1,5 @@
 #include "wilc_wfi_netdevice.h"
+#include "linux_wlan_sdio.h"
 
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
@@ -44,7 +45,7 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 #endif
 
 
-int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd)
+static int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd)
 {
 	struct sdio_func *func = container_of(wilc1000_dev->dev, struct sdio_func, dev);
 	int ret;
@@ -76,7 +77,7 @@ int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd)
 }
 
 
-int wilc1000_sdio_cmd53(sdio_cmd53_t *cmd)
+static int wilc1000_sdio_cmd53(sdio_cmd53_t *cmd)
 {
 	struct sdio_func *func = container_of(wilc1000_dev->dev, struct sdio_func, dev);
 	int size, ret;
@@ -122,7 +123,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 #endif
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	wilc1000_sdio_func = func;
-	if (wilc_netdev_init()) {
+	if (wilc_netdev_init(&func->dev, &wilc1000_sdio_ops)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
@@ -204,7 +205,7 @@ static int linux_sdio_get_speed(void)
 	return wilc1000_sdio_func->card->host->ios.clock;
 }
 
-int wilc1000_sdio_init(void *pv)
+static int wilc1000_sdio_init(void *pv)
 {
 
 	/**
@@ -216,7 +217,7 @@ int wilc1000_sdio_init(void *pv)
 	return 1;
 }
 
-void wilc1000_sdio_deinit(void *pv)
+static void wilc1000_sdio_deinit(void *pv)
 {
 
 	/**
@@ -227,16 +228,25 @@ void wilc1000_sdio_deinit(void *pv)
 	sdio_unregister_driver(&wilc_bus);
 }
 
-int wilc1000_sdio_set_max_speed(void)
+static int wilc1000_sdio_set_max_speed(void)
 {
 	return linux_sdio_set_speed(MAX_SPEED);
 }
 
-int wilc1000_sdio_set_default_speed(void)
+static int wilc1000_sdio_set_default_speed(void)
 {
 	return linux_sdio_set_speed(sdio_default_speed);
 }
 
+const struct wilc1000_ops wilc1000_sdio_ops = {
+	.io_type = HIF_SDIO,
+	.io_init = wilc1000_sdio_init,
+	.io_deinit = wilc1000_sdio_deinit,
+	.u.sdio.sdio_cmd52 = wilc1000_sdio_cmd52,
+	.u.sdio.sdio_cmd53 = wilc1000_sdio_cmd53,
+	.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed,
+	.u.sdio.sdio_set_default_speed = wilc1000_sdio_set_default_speed,
+};
 
 static int __init init_wilc_sdio_driver(void)
 {
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index ff0a37b880c2..de79aff9f11c 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,14 +1,9 @@
+#include <linux/mmc/sdio_func.h>
+
 extern struct sdio_func *wilc1000_sdio_func;
 extern struct sdio_driver wilc_bus;
+extern const struct wilc1000_ops wilc1000_sdio_ops;
 
-#include <linux/mmc/sdio_func.h>
-
-int wilc1000_sdio_init(void *);
-void wilc1000_sdio_deinit(void *);
-int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd);
-int wilc1000_sdio_cmd53(sdio_cmd53_t *cmd);
 int wilc1000_sdio_enable_interrupt(void);
 void wilc1000_sdio_disable_interrupt(void);
-int wilc1000_sdio_set_max_speed(void);
-int wilc1000_sdio_set_default_speed(void);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index b5e9a1b9f509..788531e314c3 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -11,7 +11,6 @@
 
 #include "wilc_wfi_netdevice.h"
 #include "linux_wlan_common.h"
-#include "linux_wlan_spi.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
@@ -83,7 +82,7 @@ struct spi_driver wilc_bus __refdata = {
 };
 
 
-void wilc1000_spi_deinit(void *vp)
+static void wilc1000_spi_deinit(void *vp)
 {
 
 	spi_unregister_driver(&wilc_bus);
@@ -95,7 +94,7 @@ void wilc1000_spi_deinit(void *vp)
 
 
 
-int wilc1000_spi_init(void *vp)
+static int wilc1000_spi_init(void *vp)
 {
 	int ret = 1;
 	static int called;
@@ -118,7 +117,7 @@ int wilc1000_spi_init(void *vp)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int wilc1000_spi_write(u8 *b, u32 len)
+static int wilc1000_spi_write(u8 *b, u32 len)
 {
 	int ret;
 
@@ -195,7 +194,7 @@ int wilc1000_spi_write(u8 *b, u32 len)
 }
 
 #else
-int wilc1000_spi_write(u8 *b, u32 len)
+static int wilc1000_spi_write(u8 *b, u32 len)
 {
 
 	int ret;
@@ -246,7 +245,7 @@ int wilc1000_spi_write(u8 *b, u32 len)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int wilc1000_spi_read(u8 *rb, u32 rlen)
+static int wilc1000_spi_read(u8 *rb, u32 rlen)
 {
 	int ret;
 
@@ -320,7 +319,7 @@ int wilc1000_spi_read(u8 *rb, u32 rlen)
 }
 
 #else
-int wilc1000_spi_read(u8 *rb, u32 rlen)
+static int wilc1000_spi_read(u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -365,7 +364,7 @@ int wilc1000_spi_read(u8 *rb, u32 rlen)
 
 #endif
 
-int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
+static int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -402,7 +401,7 @@ int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 	return ret;
 }
 
-int wilc1000_spi_set_max_speed(void)
+static int wilc1000_spi_set_max_speed(void)
 {
 	SPEED = MAX_SPEED;
 
@@ -410,12 +409,22 @@ int wilc1000_spi_set_max_speed(void)
 	return 1;
 }
 
+static const struct wilc1000_ops wilc1000_spi_ops = {
+	.io_type = HIF_SPI,
+	.io_init = wilc1000_spi_init,
+	.io_deinit = wilc1000_spi_deinit,
+	.u.spi.spi_tx = wilc1000_spi_write,
+	.u.spi.spi_rx = wilc1000_spi_read,
+	.u.spi.spi_trx = wilc1000_spi_write_read,
+	.u.spi.spi_max_speed = wilc1000_spi_set_max_speed,
+};
+
 static int __init init_wilc_spi_driver(void)
 {
 	int ret;
 
 	wilc1000_init_driver();
-	ret = wilc_netdev_init();
+	ret = wilc_netdev_init(NULL, &wilc1000_spi_ops);
 	if (ret)
 		return ret;
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index efa95e3e8bfe..aa259c8ee12a 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -2,13 +2,5 @@
 #define LINUX_WLAN_SPI_H
 
 #include <linux/spi/spi.h>
-extern struct spi_device *wilc_spi_dev;
-extern struct spi_driver wilc_bus;
 
-int wilc1000_spi_init(void *vp);
-void wilc1000_spi_deinit(void *vp);
-int wilc1000_spi_write(u8 *b, u32 len);
-int wilc1000_spi_read(u8 *rb, u32 rlen);
-int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
-int wilc1000_spi_set_max_speed(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index dd312b0b1abf..8c5253cce97c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -320,7 +320,7 @@ void wilc1000_enable_tcp_ack_filter(bool value);
 void wilc1000_chip_sleep_manually(u32 u32SleepTime);
 int wilc1000_wlan_get_num_conn_ifcs(void);
 int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-int wilc_netdev_init(void);
+int wilc_netdev_init(struct device *, const struct wilc1000_ops *ops);
 void __exit wilc_netdev_free(struct wilc *wilc1000_dev);
 
 void wilc_handle_isr(void);
-- 
2.1.0.rc2

