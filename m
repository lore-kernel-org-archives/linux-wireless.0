Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56938 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbKJXnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:43:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 15/20] staging/wilc1000: pass hif operations through initialization
Date: Wed, 11 Nov 2015 00:42:35 +0100
Message-Id: <1447198960-2760143-16-git-send-email-arnd@arndb.de> (sfid-20151111_004700_231321_606CD0E1)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wilc_hif_spi and wilc_hif_sdio structures are part of
the bus specific code, and the generic code should have no knowledge
of their addresses.

This changes the code to reference them only from the bus
specific initialization code, which we can then use to split
up the driver into separate modules.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         |  4 ++-
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  3 ++-
 drivers/staging/wilc1000/linux_wlan_spi.c     |  2 +-
 drivers/staging/wilc1000/wilc_sdio.c          | 35 +++++++++++++--------------
 drivers/staging/wilc1000/wilc_spi.c           | 34 +++++++++++++-------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  4 ++-
 drivers/staging/wilc1000/wilc_wlan.c          | 15 ++----------
 drivers/staging/wilc1000/wilc_wlan.h          |  4 +--
 8 files changed, 47 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e81e90678d0f..2fb1d97bded1 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1408,7 +1408,8 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 #endif
 }
 
-int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type, int gpio)
+int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
+		     int gpio, const struct wilc_hif_func *ops)
 {
 	int i;
 	perInterface_wlan_t *nic;
@@ -1423,6 +1424,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type, int gp
 	*wilc = wilc_dev;
 	wilc_dev->io_type = io_type;
 	wilc_dev->gpio = gpio;
+	wilc_dev->ops = ops;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 732b0d66366b..f4250fda6cf1 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -119,7 +119,8 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	wilc_sdio_func = func;
-	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio)) {
+	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
+			     &wilc_hif_sdio)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index f4dda4a6fa7b..a7a52593156a 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -404,7 +404,7 @@ static int __init init_wilc_spi_driver(void)
 
 	wilc_debugfs_init();
 
-	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM);
+	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM, &wilc_hif_spi);
 	if (ret) {
 		wilc_debugfs_remove();
 		return ret;
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8441fcccccc4..0a9b5a71772e 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -912,23 +912,22 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
  *
  ********************************************/
 
-struct wilc_hif_func wilc_hif_sdio = {
-	sdio_init,
-	sdio_deinit,
-	sdio_read_reg,
-	sdio_write_reg,
-	sdio_read,
-	sdio_write,
-	sdio_sync,
-	sdio_clear_int,
-	sdio_read_int,
-	sdio_clear_int_ext,
-	sdio_read_size,
-	sdio_write,
-	sdio_read,
-	sdio_sync_ext,
-
-	sdio_set_max_speed,
-	sdio_set_default_speed,
+const struct wilc_hif_func wilc_hif_sdio = {
+	.hif_init = sdio_init,
+	.hif_deinit = sdio_deinit,
+	.hif_read_reg = sdio_read_reg,
+	.hif_write_reg = sdio_write_reg,
+	.hif_block_rx = sdio_read,
+	.hif_block_tx = sdio_write,
+	.hif_sync = sdio_sync,
+	.hif_clear_int = sdio_clear_int,
+	.hif_read_int = sdio_read_int,
+	.hif_clear_int_ext = sdio_clear_int_ext,
+	.hif_read_size = sdio_read_size,
+	.hif_block_rx_ext = sdio_write,
+	.hif_block_tx_ext = sdio_read,
+	.hif_sync_ext = sdio_sync_ext,
+	.hif_set_max_bus_speed = sdio_set_max_speed,
+	.hif_set_default_bus_speed = sdio_set_default_speed,
 };
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index dc9cdf5e4065..0433e2b5f80a 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1021,21 +1021,21 @@ static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
  *      Global spi HIF function table
  *
  ********************************************/
-struct wilc_hif_func wilc_hif_spi = {
-	_wilc_spi_init,
-	_wilc_spi_deinit,
-	wilc_spi_read_reg,
-	wilc_spi_write_reg,
-	_wilc_spi_read,
-	_wilc_spi_write,
-	wilc_spi_sync,
-	wilc_spi_clear_int,
-	wilc_spi_read_int,
-	wilc_spi_clear_int_ext,
-	wilc_spi_read_size,
-	_wilc_spi_write,
-	_wilc_spi_read,
-	wilc_spi_sync_ext,
-	wilc_spi_max_bus_speed,
-	wilc_spi_default_bus_speed,
+const struct wilc_hif_func wilc_hif_spi = {
+	.hif_init = _wilc_spi_init,
+	.hif_deinit = _wilc_spi_deinit,
+	.hif_read_reg = wilc_spi_read_reg,
+	.hif_write_reg = wilc_spi_write_reg,
+	.hif_block_rx = _wilc_spi_read,
+	.hif_block_tx = _wilc_spi_write,
+	.hif_sync = wilc_spi_sync,
+	.hif_clear_int = wilc_spi_clear_int,
+	.hif_read_int = wilc_spi_read_int,
+	.hif_clear_int_ext = wilc_spi_clear_int_ext,
+	.hif_read_size = wilc_spi_read_size,
+	.hif_block_rx_ext = _wilc_spi_write,
+	.hif_block_rx_ext = _wilc_spi_read,
+	.hif_sync_ext = wilc_spi_sync_ext,
+	.hif_set_max_bus_speed = wilc_spi_max_bus_speed,
+	.hif_set_default_bus_speed = wilc_spi_default_bus_speed,
 };
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 92f4cb71608d..761bc3f59138 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -156,6 +156,7 @@ struct wilc_vif {
 };
 
 struct wilc {
+	const struct wilc_hif_func *ops;
 	int io_type;
 	int mac_status;
 	int gpio;
@@ -212,7 +213,8 @@ void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
-int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio);
+int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
+		     const struct wilc_hif_func *ops);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3d53550149fb..5e37ec65d3bb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1657,22 +1657,11 @@ int wilc_wlan_init(struct net_device *dev)
 
 	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
 	g_wlan.io_type = wilc->io_type;
-
-#ifdef WILC_SDIO
-	if (!wilc_hif_sdio.hif_init(wilc, wilc_debug)) {
-		ret = -EIO;
-		goto _fail_;
-	}
-	memcpy((void *)&g_wlan.hif_func, &wilc_hif_sdio,
-	       sizeof(struct wilc_hif_func));
-#else
-	if (!wilc_hif_spi.hif_init(wilc, wilc_debug)) {
+	g_wlan.hif_func = *wilc->ops;
+	if (!g_wlan.hif_func.hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
 	}
-	memcpy((void *)&g_wlan.hif_func, &wilc_hif_spi,
-	       sizeof(struct wilc_hif_func));
-#endif
 
 	if (!wilc_wlan_cfg_init(wilc_debug)) {
 		ret = -ENOBUFS;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 326d71bf91df..c0a5a955b1d4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -258,8 +258,8 @@ struct wilc_hif_func {
 	void (*hif_set_default_bus_speed)(void);
 };
 
-extern struct wilc_hif_func wilc_hif_spi;
-extern struct wilc_hif_func wilc_hif_sdio;
+extern const struct wilc_hif_func wilc_hif_spi;
+extern const struct wilc_hif_func wilc_hif_sdio;
 
 /********************************************
  *
-- 
2.1.0.rc2

