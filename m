Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21475 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbIHIID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 04:08:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/5] staging: wilc1000: remove unused NM73131_0_BOARD
Date: Tue, 8 Sep 2015 17:08:02 +0900
Message-ID: <1441699683-31463-4-git-send-email-tony.cho@atmel.com> (sfid-20150908_100812_242872_61E42A98)
In-Reply-To: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
References: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Kim, Leo" <leo.kim@atmel.com>

This patch removes the preprocessor definition, NM73131_0_BOARD which is
not used anymore.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 40 --------------
 drivers/staging/wilc1000/linux_wlan_common.h  |  7 +--
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  8 +--
 drivers/staging/wilc1000/linux_wlan_spi.c     | 75 +--------------------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  4 +-
 5 files changed, 5 insertions(+), 129 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index dc297fc..b24cb75 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -471,8 +471,6 @@ static int init_irq(linux_wlan_t *p_nic)
  *
  * ex) nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
  */
-#elif defined(NM73131_0_BOARD)
-		nic->dev_irq_num = IRQ_WILC1000;
 #elif defined(PANDA_BOARD)
 		gpio_export(GPIO_NUM, 1);
 		nic->dev_irq_num = OMAP_GPIO_IRQ(GPIO_NUM);
@@ -1719,7 +1717,6 @@ _fail_locks_:
  *      - this function will be called automatically by OS when module inserted.
  */
 
-#if !defined(NM73131_0_BOARD)
 int mac_init_fn(struct net_device *ndev)
 {
 
@@ -1729,28 +1726,11 @@ int mac_init_fn(struct net_device *ndev)
 
 	return 0;
 }
-#else
-int mac_init_fn(struct net_device *ndev)
-{
-
-	unsigned char mac_add[] = {0x00, 0x50, 0xc2, 0x5e, 0x10, 0x00};
-	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, mac_add, 6);
-
-	if (!is_valid_ether_addr(ndev->dev_addr)) {
-		PRINT_ER("Error: Wrong MAC address\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-#endif
 
 void    WILC_WFI_frame_register(struct wiphy *wiphy, struct net_device *dev,
 				u16 frame_type, bool reg);
 
 /* This fn is called, when this device is setup using ifconfig */
-#if !defined(NM73131_0_BOARD)
 int mac_open(struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
@@ -1822,26 +1802,6 @@ _err_:
 	wilc1000_wlan_deinit(g_linux_wlan);
 	return ret;
 }
-#else
-int mac_open(struct net_device *ndev)
-{
-
-	linux_wlan_t *nic;
-
-	nic = netdev_priv(ndev);
-
-	/*initialize platform*/
-	if (wilc1000_wlan_init(nic)) {
-		PRINT_ER("Failed to initialize platform\n");
-		return 1;
-	}
-	/* Start the network interface queue for this device */
-	PRINT_D(INIT_DBG, "Starting netifQ\n");
-	netif_start_queue(ndev);
-/*	down(&close_exit_sync); */
-	return 0;
-}
-#endif
 
 struct net_device_stats *mac_stats(struct net_device *dev)
 {
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index e6ebf3e..ea121f9 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -135,12 +135,7 @@ extern atomic_t DEBUG_LEVEL;
 
 #define WILC_MULTICAST_TABLE_SIZE	8
 
-#if defined (NM73131_0_BOARD)
-
-#define MODALIAS "wilc_spi"
-#define GPIO_NUM	IRQ_WILC1000_GPIO
-
-#elif defined (BEAGLE_BOARD)
+#if defined (BEAGLE_BOARD)
 	#define SPI_CHANNEL	4
 
 	#if SPI_CHANNEL == 4
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 62e6b62..1120a0f 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -8,15 +8,9 @@
 
 
 
-#if defined (NM73131_0_BOARD)
-#define SDIO_MODALIAS "wilc_sdio"
-#else
 #define SDIO_MODALIAS "wilc1000_sdio"
-#endif
 
-#if defined (NM73131_0_BOARD)
- #define MAX_SPEED 50000000
-#elif defined(CUSTOMER_PLATFORM)
+#if defined(CUSTOMER_PLATFORM)
 /* TODO : User have to stable bus clock as user's environment. */
  #ifdef MAX_BUS_SPEED
  #define MAX_SPEED MAX_BUS_SPEED
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index c5cdab7..8bcbed8 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -113,45 +113,7 @@ int linux_spi_init(void *vp)
 #define TXRX_PHASE_SIZE (4096)
 #endif
 
-#if defined (NM73131_0_BOARD)
-
-int linux_spi_write(uint8_t *b, uint32_t len)
-{
-
-	int ret;
-
-	if (len > 0 && b != NULL) {
-		struct spi_message msg;
-
-		PRINT_D(BUS_DBG, "Request writing %d bytes\n", len);
-		struct spi_transfer tr = {
-			.tx_buf = b,
-			.len = len,
-			.speed_hz = SPEED,
-			.delay_usecs = 0,
-		};
-
-		spi_message_init(&msg);
-		spi_message_add_tail(&tr, &msg);
-		ret = spi_sync(wilc_spi_dev, &msg);
-		if (ret < 0) {
-			PRINT_ER("SPI transaction failed\n");
-		}
-
-	} else {
-		PRINT_ER("can't write data with the following length: %d\n", len);
-		PRINT_ER("FAILED due to NULL buffer or ZERO length check the following length: %d\n", len);
-		ret = -1;
-	}
-
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
-
-
-	return ret;
-}
-
-#elif defined(TXRX_PHASE_SIZE)
+#if defined(TXRX_PHASE_SIZE)
 
 int linux_spi_write(uint8_t *b, uint32_t len)
 {
@@ -282,40 +244,7 @@ int linux_spi_write(uint8_t *b, uint32_t len)
 
 #endif
 
-#if defined (NM73131_0_BOARD)
-
-int linux_spi_read(unsigned char *rb, unsigned long rlen)
-{
-
-	int ret;
-
-	if (rlen > 0) {
-		struct spi_message msg;
-		struct spi_transfer tr = {
-			.rx_buf = rb,
-			.len = rlen,
-			.speed_hz = SPEED,
-			.delay_usecs = 0,
-
-		};
-
-		spi_message_init(&msg);
-		spi_message_add_tail(&tr, &msg);
-		ret = spi_sync(wilc_spi_dev, &msg);
-		if (ret < 0) {
-			PRINT_ER("SPI transaction failed\n");
-		}
-	} else {
-		PRINT_ER("can't read data with the following length: %ld\n", rlen);
-		ret = -1;
-	}
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
-
-	return ret;
-}
-
-#elif defined(TXRX_PHASE_SIZE)
+#if defined(TXRX_PHASE_SIZE)
 
 int linux_spi_read(unsigned char *rb, unsigned long rlen)
 {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 27c6920..e1caea9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -80,9 +80,7 @@ struct WILC_WFI_stats {
  * LPC3131 which is important to get the MAC start status when you are blocked
  * inside linux_wlan_firmware_download() which blocks mac_open().
  */
-#if defined(NM73131_0_BOARD)
- #define RX_BH_TYPE  RX_BH_KTHREAD
-#elif defined(PANDA_BOARD)
+#if defined(PANDA_BOARD)
  #define RX_BH_TYPE  RX_BH_THREADED_IRQ
 #else
  #define RX_BH_TYPE  RX_BH_KTHREAD
-- 
1.9.1

