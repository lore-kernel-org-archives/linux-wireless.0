Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22973 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbJTF2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:28:09 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 08/12] staging: wilc1000: move clean up codes into wl_wlan_cleanup function
Date: Tue, 20 Oct 2015 14:26:52 +0900
Message-ID: <1445318816-21686-9-git-send-email-tony.cho@atmel.com> (sfid-20151020_072812_376016_D9E166B1)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves clean up codes from exit_wilc_driver into the wl_wlan_cleanup
newly introduced in this patch. In addition, it is called by linux_sdio_remove
function.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 95 ++++++++++++---------------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  5 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 3 files changed, 43 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 41a2f09..74b7cc0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1696,6 +1696,47 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 		WILC_WFI_p2p_rx(g_linux_wlan->vif[1].ndev, buff, size);
 }
 
+void wl_wlan_cleanup(void)
+{
+	int i = 0;
+	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC];
+
+	if (g_linux_wlan &&
+	   (g_linux_wlan->vif[0].ndev || g_linux_wlan->vif[1].ndev)) {
+		unregister_inetaddr_notifier(&g_dev_notifier);
+
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
+			nic[i] = netdev_priv(g_linux_wlan->vif[i].ndev);
+	}
+
+	if (g_linux_wlan && g_linux_wlan->wilc_firmware)
+		release_firmware(g_linux_wlan->wilc_firmware);
+
+	if (g_linux_wlan &&
+	   (g_linux_wlan->vif[0].ndev || g_linux_wlan->vif[1].ndev)) {
+		linux_wlan_lock_timeout(&close_exit_sync, 12 * 1000);
+
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
+			if (g_linux_wlan->vif[i].ndev)
+				if (nic[i]->mac_opened)
+					mac_close(g_linux_wlan->vif[i].ndev);
+
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
+			unregister_netdev(g_linux_wlan->vif[i].ndev);
+			wilc_free_wiphy(g_linux_wlan->vif[i].ndev);
+			free_netdev(g_linux_wlan->vif[i].ndev);
+		}
+	}
+
+	kfree(g_linux_wlan);
+
+#if defined(WILC_DEBUGFS)
+	wilc_debugfs_remove();
+#endif
+	linux_wlan_device_detection(0);
+	linux_wlan_device_power(0);
+}
+
 int wilc_netdev_init(void)
 {
 
@@ -1828,49 +1869,6 @@ late_initcall(init_wilc_driver);
 
 static void __exit exit_wilc_driver(void)
 {
-	int i = 0;
-	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
-	#define CLOSE_TIMEOUT (12 * 1000)
-
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].ndev) != NULL)
-				       || ((g_linux_wlan->vif[1].ndev) != NULL))) {
-		unregister_inetaddr_notifier(&g_dev_notifier);
-
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(g_linux_wlan->vif[i].ndev);
-	}
-
-	if ((g_linux_wlan != NULL) && g_linux_wlan->wilc_firmware != NULL) {
-		release_firmware(g_linux_wlan->wilc_firmware);
-		g_linux_wlan->wilc_firmware = NULL;
-	}
-
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].ndev) != NULL)
-				       || ((g_linux_wlan->vif[1].ndev) != NULL))) {
-		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
-
-		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
-			PRINT_D(INIT_DBG, "Closed TimedOUT\n");
-		else
-			PRINT_D(INIT_DBG, "mac_closed\n");
-
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			/* close all opened interfaces */
-			if (g_linux_wlan->vif[i].ndev != NULL) {
-				if (nic[i]->mac_opened)
-					mac_close(g_linux_wlan->vif[i].ndev);
-			}
-		}
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->vif[i].ndev);
-			unregister_netdev(g_linux_wlan->vif[i].ndev);
-			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(g_linux_wlan->vif[i].ndev);
-			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(g_linux_wlan->vif[i].ndev);
-		}
-	}
-
 #ifndef WILC_SDIO
 	PRINT_D(INIT_DBG, "SPI unregsiter...\n");
 	spi_unregister_driver(&wilc_bus);
@@ -1878,17 +1876,6 @@ static void __exit exit_wilc_driver(void)
 	PRINT_D(INIT_DBG, "SDIO unregsiter...\n");
 	sdio_unregister_driver(&wilc_bus);
 #endif
-
-	kfree(g_linux_wlan);
-	g_linux_wlan = NULL;
-	printk("Module_exit Done.\n");
-
-#if defined(WILC_DEBUGFS)
-	wilc_debugfs_remove();
-#endif
-
-	linux_wlan_device_detection(0);
-	linux_wlan_device_power(0);
 }
 module_exit(exit_wilc_driver);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index ebacd29..e5764fc 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -136,10 +136,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 static void linux_sdio_remove(struct sdio_func *func)
 {
-	/**
-	 *      TODO
-	 **/
-
+	wl_wlan_cleanup();
 }
 
 struct sdio_driver wilc_bus = {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 429b654..b410424 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -213,5 +213,5 @@ void linux_wlan_mac_indicate(int flag);
 void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
-
+void wl_wlan_cleanup(void);
 #endif
-- 
1.9.1

