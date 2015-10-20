Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:23003 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbJTF2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:28:21 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 10/12] staging: wilc1000: remove COMPLEMENT_BOOT
Date: Tue, 20 Oct 2015 14:26:54 +0900
Message-ID: <1445318816-21686-11-git-send-email-tony.cho@atmel.com> (sfid-20151020_074654_372814_404FA8DC)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a preprocessor definition, COMPLEMENT_BOOT which is not used
anymore. This is just workaround to avoid weird issue, which is that 11b core
is not ready after the power is givin to the chip. However, this issue happened
only in the unstable hardware a long time ago and no more seen. In addition,
this patch removes _fail_threads_ statement to avoid the build warning after
removing COMPLEMENT_BOOT conditionals.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c      | 132 ++---------------------------
 drivers/staging/wilc1000/linux_wlan_sdio.c |   9 --
 drivers/staging/wilc1000/wilc_wlan.c       |  18 ----
 3 files changed, 8 insertions(+), 151 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 16b1d80..3cad5b6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -545,10 +545,6 @@ _fail_:
 
 }
 
-#ifdef COMPLEMENT_BOOT
-int repeat_power_cycle(perInterface_wlan_t *nic);
-#endif
-
 static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 {
 
@@ -565,18 +561,6 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
 	ret = linux_wlan_lock_timeout(&g_linux_wlan->sync_event, 5000);
 	if (ret) {
-#ifdef COMPLEMENT_BOOT
-		static int timeout = 5;
-
-		if (timeout--) {
-			PRINT_D(INIT_DBG, "repeat power cycle[%d]", timeout);
-			ret = repeat_power_cycle(nic);
-		} else {
-			timeout = 5;
-			ret = -1;
-			goto _fail_;
-		}
-#endif
 		PRINT_D(INIT_DBG, "Firmware start timed out");
 		goto _fail_;
 	}
@@ -1038,97 +1022,6 @@ static void wlan_deinitialize_threads(struct wilc *nic)
 	}
 }
 
-#ifdef COMPLEMENT_BOOT
-
-extern volatile int probe;
-extern u8 core_11b_ready(void);
-
-#define READY_CHECK_THRESHOLD		30
-extern void wilc_wlan_global_reset(void);
-u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
-{
-	u8 trials = 0;
-
-	while ((core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
-		PRINT_D(INIT_DBG, "11b core not ready yet: %u\n", trials);
-		wilc_wlan_cleanup();
-		wilc_wlan_global_reset();
-		sdio_unregister_driver(&wilc_bus);
-
-		linux_wlan_device_detection(0);
-
-		mdelay(100);
-
-		linux_wlan_device_detection(1);
-
-		sdio_register_driver(&wilc_bus);
-
-		while (!probe)
-			msleep(100);
-		probe = 0;
-		g_linux_wlan->wilc_sdio_func = local_sdio_func;
-		linux_to_wlan(nwi, nic);
-		wilc_wlan_init(nwi);
-	}
-
-	if (READY_CHECK_THRESHOLD <= trials)
-		return 1;
-	else
-		return 0;
-
-}
-
-int repeat_power_cycle(perInterface_wlan_t *nic)
-{
-	int ret = 0;
-	wilc_wlan_inp_t nwi;
-
-	sdio_unregister_driver(&wilc_bus);
-
-	linux_wlan_device_detection(0);
-	linux_wlan_device_power(0);
-	msleep(100);
-	linux_wlan_device_power(1);
-	msleep(80);
-	linux_wlan_device_detection(1);
-	msleep(20);
-
-	sdio_register_driver(&wilc_bus);
-
-	/* msleep(1000); */
-	while (!probe)
-		msleep(100);
-	probe = 0;
-	g_linux_wlan->wilc_sdio_func = local_sdio_func;
-	linux_to_wlan(&nwi, g_linux_wlan);
-	ret = wilc_wlan_init(&nwi);
-
-	g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
-	#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-	enable_sdio_interrupt();
-	#endif
-
-	if (linux_wlan_get_firmware(nic)) {
-		PRINT_ER("Can't get firmware\n");
-		ret = -1;
-		goto __fail__;
-	}
-
-	/*Download firmware*/
-	ret = linux_wlan_firmware_download(g_linux_wlan);
-	if (ret < 0) {
-		PRINT_ER("Failed to download firmware\n");
-		goto __fail__;
-	}
-	/* Start firmware*/
-	ret = linux_wlan_start_firmware(nic);
-	if (ret < 0)
-		PRINT_ER("Failed to start firmware\n");
-__fail__:
-	return ret;
-}
-#endif
-
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
 	wilc_wlan_inp_t nwi;
@@ -1150,29 +1043,21 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_locks_;
 		}
 
-		ret = wlan_initialize_threads(nic);
-		if (ret < 0) {
-			PRINT_ER("Initializing Threads FAILED\n");
-			ret = -EIO;
-			goto _fail_wilc_wlan_;
-		}
-
-#if (defined WILC_SDIO) && (defined COMPLEMENT_BOOT)
-		if (wilc1000_prepare_11b_core(&nwi, g_linux_wlan)) {
-			PRINT_ER("11b Core is not ready\n");
-			ret = -EIO;
-			goto _fail_threads_;
-		}
-#endif
-
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
 		if (init_irq(g_linux_wlan)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
-			goto _fail_threads_;
+			goto _fail_locks_;
 		}
 #endif
 
+		ret = wlan_initialize_threads(nic);
+		if (ret < 0) {
+			PRINT_ER("Initializing Threads FAILED\n");
+			ret = -EIO;
+			goto _fail_wilc_wlan_;
+		}
+
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
 		if (enable_sdio_interrupt()) {
 			PRINT_ER("couldn't initialize IRQ\n");
@@ -1239,7 +1124,6 @@ _fail_irq_init_:
 		deinit_irq(g_linux_wlan);
 
 #endif
-_fail_threads_:
 		wlan_deinitialize_threads(g_linux_wlan);
 _fail_wilc_wlan_:
 		wilc_wlan_cleanup();
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index e5764fc..1bd7f9b 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -110,19 +110,10 @@ int linux_sdio_cmd53(sdio_cmd53_t *cmd)
 	return 1;
 }
 
-volatile int probe; /* COMPLEMENT_BOOT */
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
 	PRINT_D(INIT_DBG, "probe function\n");
 
-#ifdef COMPLEMENT_BOOT
-	if (local_sdio_func != NULL) {
-		local_sdio_func = func;
-		probe = 1;
-		PRINT_D(INIT_DBG, "local_sdio_func isn't NULL\n");
-		return 0;
-	}
-#endif
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	local_sdio_func = func;
 	if (wilc_netdev_init()) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c731641..67b0c52 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1919,24 +1919,6 @@ _fail_:
 	return chipid;
 }
 
-#ifdef COMPLEMENT_BOOT
-u8 core_11b_ready(void)
-{
-	u32 reg_val;
-
-	acquire_bus(ACQUIRE_ONLY);
-	g_wlan.hif_func.hif_write_reg(0x16082c, 1);
-	g_wlan.hif_func.hif_write_reg(0x161600, 0x90);
-	g_wlan.hif_func.hif_read_reg(0x161600, &reg_val);
-	release_bus(RELEASE_ONLY);
-
-	if (reg_val == 0x90)
-		return 0;
-	else
-		return 1;
-}
-#endif
-
 int wilc_wlan_init(wilc_wlan_inp_t *inp)
 {
 
-- 
1.9.1

