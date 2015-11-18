Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20475 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:08:25 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/16] staging: wilc1000: remove sdio speed control codes
Date: Wed, 18 Nov 2015 15:11:22 +0900
Message-ID: <1447827097-9436-2-git-send-email-glen.lee@atmel.com> (sfid-20151118_070830_024877_B8C4F079)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes spi speed control related functions and variable. We cannot
get exact clock what we need in this way and it can causes some problem in host
side by setting the clock, so remove the codes.
Speed control codes in spi also will removed in next patch, so it's ok to
remove functions in linux_wlan.c and wilc_wlan.c which also not used anymore.

The Following functions and varialbe are removed.
MAX_SPEED, sdio_default_speed
wilc_bus_set_default_speed
wilc_bus_set_max_speed
linux_sdio_set_speed
linux_sdio_get_speed
wilc_sdio_set_max_speed
wilc_sdio_set_default_speed

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c      |  8 -----
 drivers/staging/wilc1000/linux_wlan_sdio.c | 52 ------------------------------
 drivers/staging/wilc1000/linux_wlan_sdio.h |  3 --
 drivers/staging/wilc1000/wilc_sdio.c       | 12 -------
 drivers/staging/wilc1000/wilc_wlan.c       | 10 ------
 5 files changed, 85 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 89b5aca..ab17110 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -733,12 +733,6 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 	if (wl->initialized)	{
 		netdev_info(dev, "Deinitializing wilc1000...\n");
 
-#if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-		PRINT_D(INIT_DBG, "skip wilc_bus_set_default_speed\n");
-#else
-		wilc_bus_set_default_speed();
-#endif
-
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
 		if (!wl->dev_irq_num &&
 		    wl->ops->disable_interrupt) {
@@ -929,8 +923,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_irq_enable_;
 		}
 
-		wilc_bus_set_max_speed();
-
 		if (wilc_wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
 			int size;
 			char Firmware_ver[20];
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 1f366b5..761cb3d 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -11,19 +11,7 @@
 
 #define SDIO_MODALIAS "wilc1000_sdio"
 
-#if defined(CUSTOMER_PLATFORM)
-/* TODO : User have to stable bus clock as user's environment. */
- #ifdef MAX_BUS_SPEED
- #define MAX_SPEED MAX_BUS_SPEED
- #else
- #define MAX_SPEED 50000000
- #endif
-#else
- #define MAX_SPEED (6 * 1000000) /* Max 50M */
-#endif
-
 static struct sdio_func *wilc_sdio_func;
-static unsigned int sdio_default_speed;
 
 #define SDIO_VENDOR_ID_WILC 0x0296
 #define SDIO_DEVICE_ID_WILC 0x5347
@@ -177,49 +165,9 @@ void wilc_sdio_disable_interrupt(struct wilc *dev)
 	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt OUT\n");
 }
 
-static int linux_sdio_set_speed(int speed)
-{
-	struct mmc_ios ios;
-	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
-
-	sdio_claim_host(func);
-
-	memcpy((void *)&ios, (void *)&func->card->host->ios, sizeof(struct mmc_ios));
-	func->card->host->ios.clock = speed;
-	ios.clock = speed;
-	func->card->host->ops->set_ios(func->card->host, &ios);
-	sdio_release_host(func);
-	PRINT_INFO(INIT_DBG, "@@@@@@@@@@@@ change SDIO speed to %d @@@@@@@@@\n", speed);
-
-	return 1;
-}
-
-static int linux_sdio_get_speed(void)
-{
-	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
-	return func->card->host->ios.clock;
-}
-
 int wilc_sdio_init(void)
 {
-
-	/**
-	 *      TODO :
-	 **/
-
-
-	sdio_default_speed = linux_sdio_get_speed();
 	return 1;
 }
 
-int wilc_sdio_set_max_speed(void)
-{
-	return linux_sdio_set_speed(MAX_SPEED);
-}
-
-int wilc_sdio_set_default_speed(void)
-{
-	return linux_sdio_set_speed(sdio_default_speed);
-}
-
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index d7b213a..dbe911a 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -6,6 +6,3 @@ int wilc_sdio_cmd53(sdio_cmd53_t *cmd);
 
 int wilc_sdio_enable_interrupt(struct wilc *);
 void wilc_sdio_disable_interrupt(struct wilc *);
-int wilc_sdio_set_max_speed(void);
-int wilc_sdio_set_default_speed(void);
-
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 2418d52..398c7f5 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -608,16 +608,6 @@ _fail_:
 	return 0;
 }
 
-static void sdio_set_max_speed(void)
-{
-	wilc_sdio_set_max_speed();
-}
-
-static void sdio_set_default_speed(void)
-{
-	wilc_sdio_set_default_speed();
-}
-
 static int sdio_read_size(u32 *size)
 {
 
@@ -925,8 +915,6 @@ const struct wilc_hif_func wilc_hif_sdio = {
 	.hif_block_tx_ext = sdio_write,
 	.hif_block_rx_ext = sdio_read,
 	.hif_sync_ext = sdio_sync_ext,
-	.hif_set_max_bus_speed = sdio_set_max_speed,
-	.hif_set_default_bus_speed = sdio_set_default_speed,
 	.enable_interrupt = wilc_sdio_enable_interrupt,
 	.disable_interrupt = wilc_sdio_disable_interrupt,
 };
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index df8503f..114ea95 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1575,16 +1575,6 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
-void wilc_bus_set_max_speed(void)
-{
-	g_wlan.hif_func.hif_set_max_bus_speed();
-}
-
-void wilc_bus_set_default_speed(void)
-{
-	g_wlan.hif_func.hif_set_default_bus_speed();
-}
-
 static u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
-- 
1.9.1

