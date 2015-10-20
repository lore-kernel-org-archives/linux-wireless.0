Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:54911 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbbJTWsS (ORCPT
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
Subject: [PATCH 17/19] staging/wilc1000: pass hif operations through initialization
Date: Wed, 21 Oct 2015 00:47:36 +0200
Message-Id: <1445381258-1455986-18-git-send-email-arnd@arndb.de> (sfid-20151021_004916_085013_06D42ED2)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wilc1000_hif_spi and wilc1000_hif_sdio structures are part of
the bus specific code, and the generic code should have no knowledge
of their addresses.

This changes the code to reference them only from the bus
specific initialization code, which we can then use to split
up the driver into separate modules.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         |  4 ++-
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  3 ++-
 drivers/staging/wilc1000/linux_wlan_spi.c     |  3 ++-
 drivers/staging/wilc1000/wilc_sdio.c          | 35 +++++++++++++--------------
 drivers/staging/wilc1000/wilc_spi.c           | 34 +++++++++++++-------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 29 ++++------------------
 drivers/staging/wilc1000/wilc_wlan.h          | 11 +++++----
 8 files changed, 53 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7b0ac31f04a2..04ebb6310070 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1503,7 +1503,8 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 		WILC_WFI_p2p_rx(wilc1000_dev->strInterfaceInfo[1].wilc_netdev, buff, size);
 }
 
-int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops, int gpio)
+int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops,
+		     const struct wilc1000_hif_ops *hif_ops, int gpio)
 {
 
 	int i;
@@ -1518,6 +1519,7 @@ int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops, int gpi
 		return -ENOMEM;
 
 	wilc1000_dev->ops = ops;
+	wilc1000_dev->hif_ops = hif_ops;
 	wilc1000_dev->gpio = gpio;
 
 	register_inetaddr_notifier(&g_dev_notifier);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 86251b907197..1f79d986be5c 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -206,7 +206,8 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	wilc1000_sdio_func = func;
-	if (wilc_netdev_init(&func->dev, &wilc1000_sdio_ops, gpio)) {
+	if (wilc_netdev_init(&func->dev, &wilc1000_sdio_ops,
+	    &wilc1000_hif_sdio, gpio)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
 	}
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index c6ea3ef0664f..02b922ab86bb 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -424,7 +424,8 @@ static int __init init_wilc_spi_driver(void)
 	int ret;
 
 	wilc1000_init_driver();
-	ret = wilc_netdev_init(NULL, &wilc1000_spi_ops, GPIO_NUM);
+	ret = wilc_netdev_init(NULL, &wilc1000_spi_ops, &wilc1000_hif_spi,
+			       GPIO_NUM);
 	if (ret)
 		return ret;
 
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 69b7c72b76c5..5bfc093b6201 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -924,23 +924,22 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
  *
  ********************************************/
 
-wilc_hif_func_t wilc1000_hif_sdio = {
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
+const struct wilc1000_hif_ops wilc1000_hif_sdio = {
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
index 4c5659b72f29..a418774d7960 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1032,21 +1032,21 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
  *      Global spi HIF function table
  *
  ********************************************/
-wilc_hif_func_t wilc1000_hif_spi = {
-	spi_init,
-	spi_deinit,
-	spi_read_reg,
-	spi_write_reg,
-	spi_read,
-	spi_write,
-	spi_sync,
-	spi_clear_int,
-	spi_read_int,
-	spi_clear_int_ext,
-	spi_read_size,
-	spi_write,
-	spi_read,
-	spi_sync_ext,
-	spi_max_bus_speed,
-	spi_default_bus_speed,
+const struct wilc1000_hif_ops wilc1000_hif_spi = {
+	.hif_init = spi_init,
+	.hif_deinit = spi_deinit,
+	.hif_read_reg = spi_read_reg,
+	.hif_write_reg = spi_write_reg,
+	.hif_block_rx = spi_read,
+	.hif_block_tx = spi_write,
+	.hif_sync = spi_sync,
+	.hif_clear_int = spi_clear_int,
+	.hif_read_int = spi_read_int,
+	.hif_clear_int_ext = spi_clear_int_ext,
+	.hif_read_size = spi_read_size,
+	.hif_block_rx_ext = spi_write,
+	.hif_block_tx_ext = spi_read,
+	.hif_sync_ext = spi_sync_ext,
+	.hif_set_max_bus_speed = spi_max_bus_speed,
+	.hif_set_default_bus_speed = spi_default_bus_speed,
 };
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index f1f78f51fea0..791ede247465 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -157,6 +157,7 @@ struct wilc_vif {
 
 struct wilc {
 	const struct wilc1000_ops *ops;
+	const struct wilc1000_hif_ops *hif_ops;
 	int mac_status;
 	int wilc1000_initialized;
 	int gpio;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 038c9b2eee6c..04d2938a383c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -28,7 +28,7 @@ typedef struct {
 	/**
 	 *      host interface functions
 	 **/
-	wilc_hif_func_t hif_func;
+	struct wilc1000_hif_ops hif_func;
 
 	/**
 	 *      configuration interface functions
@@ -1947,29 +1947,10 @@ int wilc_wlan_init(struct wilc *inp)
 	/***
 	 *      host interface init
 	 **/
-	if ((inp->ops->io_type & 0x1) == HIF_SDIO) {
-		if (!wilc1000_hif_sdio.hif_init(inp, wilc_debug)) {
-			/* EIO	5 */
-			ret = -5;
-			goto _fail_;
-		}
-		memcpy((void *)&g_wlan.hif_func, &wilc1000_hif_sdio, sizeof(wilc_hif_func_t));
-	} else {
-		if ((inp->ops->io_type & 0x1) == HIF_SPI) {
-			/**
-			 *      TODO:
-			 **/
-			if (!wilc1000_hif_spi.hif_init(inp, wilc_debug)) {
-				/* EIO	5 */
-				ret = -5;
-				goto _fail_;
-			}
-			memcpy((void *)&g_wlan.hif_func, &wilc1000_hif_spi, sizeof(wilc_hif_func_t));
-		} else {
-			/* EIO	5 */
-			ret = -5;
-			goto _fail_;
-		}
+	g_wlan.hif_func = *inp->hif_ops;
+	if (!g_wlan.hif_func.hif_init(inp, wilc_debug))	{
+		ret = -EIO;
+		goto _fail_;
 	}
 
 	/***
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2f636534fc5d..f684d5bf465d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -251,7 +251,7 @@ struct rxq_entry_t {
 
 struct wilc;
 
-typedef struct {
+struct wilc1000_hif_ops {
 	int (*hif_init)(struct wilc *, wilc_debug_func);
 	int (*hif_deinit)(void *);
 	int (*hif_read_reg)(u32, u32 *);
@@ -268,10 +268,10 @@ typedef struct {
 	int (*hif_sync_ext)(int);
 	void (*hif_set_max_bus_speed)(void);
 	void (*hif_set_default_bus_speed)(void);
-} wilc_hif_func_t;
+};
 
-extern wilc_hif_func_t wilc1000_hif_spi;
-extern wilc_hif_func_t wilc1000_hif_sdio;
+extern const struct wilc1000_hif_ops wilc1000_hif_spi;
+extern const struct wilc1000_hif_ops wilc1000_hif_sdio;
 
 /********************************************
  *
@@ -318,7 +318,8 @@ void wilc1000_enable_tcp_ack_filter(bool value);
 void wilc1000_chip_sleep_manually(u32 u32SleepTime);
 int wilc1000_wlan_get_num_conn_ifcs(void);
 int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-int wilc_netdev_init(struct device *, const struct wilc1000_ops *ops, int gpio);
+int wilc_netdev_init(struct device *, const struct wilc1000_ops *ops,
+		     const struct wilc1000_hif_ops *hif_ops, int gpio);
 void __exit wilc_netdev_free(struct wilc *wilc1000_dev);
 
 void wilc_handle_isr(void);
-- 
2.1.0.rc2

