Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:60979 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbbJTWsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/19] staging/wilc1000: move init/exit functions to driver files
Date: Wed, 21 Oct 2015 00:47:28 +0200
Message-Id: <1445381258-1455986-10-git-send-email-arnd@arndb.de> (sfid-20151021_005616_811598_4D901B0D)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver interfaces are in linux_wlan_sdio.c and linux_wlan_spi.c, so
this is where the init and exit functions should be. Splitting this up
enables further cleanups, including eventually allowing both modules
to be built together.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c      | 49 +++++++-----------------------
 drivers/staging/wilc1000/linux_wlan_sdio.c | 14 +++++++++
 drivers/staging/wilc1000/linux_wlan_spi.c  | 16 ++++++++++
 drivers/staging/wilc1000/wilc_wlan.h       |  4 +++
 4 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 53cecb892a84..caa85442c12d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1725,59 +1725,38 @@ int wilc_netdev_init(void)
 	return 0;
 }
 
-/*The 1st function called after module inserted*/
-static int __init init_wilc_driver(void)
+void __init wilc1000_init_driver(void)
 {
 #if defined(WILC_DEBUGFS)
-	if (wilc_debugfs_init() < 0) {
+	if (wilc_debugfs_init() < 0)
 		PRINT_D(GENERIC_DBG, "fail to create debugfs for wilc driver\n");
-		return -1;
-	}
 #endif
 
 	printk("IN INIT FUNCTION\n");
 	printk("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
-
-#ifdef WILC_SDIO
-	{
-		int ret;
-
-		ret = sdio_register_driver(&wilc_bus);
-		if (ret < 0)
-			PRINT_D(INIT_DBG, "init_wilc_driver: Failed register sdio driver\n");
-
-		return ret;
-	}
-#else
-	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	if (wilc_netdev_init())
-		PRINT_ER("Couldn't initialize netdev\n");
-	return 0;
-#endif
 }
-late_initcall(init_wilc_driver);
 
-static void __exit exit_wilc_driver(void)
+void __exit wilc_netdev_free(struct wilc *wilc1000_dev)
 {
 	int i = 0;
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
-	if ((wilc1000_dev != NULL) && (((wilc1000_dev->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((wilc1000_dev->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+	if (wilc1000_dev->strInterfaceInfo[0].wilc_netdev ||
+	    wilc1000_dev->strInterfaceInfo[1].wilc_netdev) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			nic[i] = netdev_priv(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 	}
 
-	if ((wilc1000_dev != NULL) && wilc1000_dev->wilc_firmware != NULL) {
+	if (wilc1000_dev->wilc_firmware) {
 		release_firmware(wilc1000_dev->wilc_firmware);
 		wilc1000_dev->wilc_firmware = NULL;
 	}
 
-	if ((wilc1000_dev != NULL) && (((wilc1000_dev->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((wilc1000_dev->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+	if (wilc1000_dev->strInterfaceInfo[0].wilc_netdev ||
+	    wilc1000_dev->strInterfaceInfo[1].wilc_netdev) {
 		PRINT_D(INIT_DBG, "Waiting for wilc1000_mac_close ....\n");
 
 		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
@@ -1801,15 +1780,10 @@ static void __exit exit_wilc_driver(void)
 			free_netdev(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 		}
 	}
+}
 
-#ifndef WILC_SDIO
-	PRINT_D(INIT_DBG, "SPI unregsiter...\n");
-	spi_unregister_driver(&wilc_bus);
-#else
-	PRINT_D(INIT_DBG, "SDIO unregsiter...\n");
-	sdio_unregister_driver(&wilc_bus);
-#endif
-
+void __exit wilc1000_exit_driver(void)
+{
 	kfree(wilc1000_dev);
 	wilc1000_dev = NULL;
 	printk("Module_exit Done.\n");
@@ -1818,6 +1792,5 @@ static void __exit exit_wilc_driver(void)
 	wilc_debugfs_remove();
 #endif
 }
-module_exit(exit_wilc_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 4e8c4e6d499e..badcae57875c 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -237,4 +237,18 @@ int wilc1000_sdio_set_default_speed(void)
 }
 
 
+static int __init init_wilc_sdio_driver(void)
+{
+	wilc1000_init_driver();
+	return sdio_register_driver(&wilc_bus);
+}
+late_initcall(init_wilc_sdio_driver);
 
+static void __exit exit_wilc_sdio_driver(void)
+{
+	if (wilc1000_dev)
+		wilc_netdev_free(wilc1000_dev);
+	sdio_unregister_driver(&wilc_bus);
+	wilc1000_exit_driver();
+}
+module_exit(exit_wilc_sdio_driver);
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 43cfeda97030..c90b741824dc 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -406,3 +406,19 @@ int wilc1000_spi_set_max_speed(void)
 	PRINT_INFO(BUS_DBG, "@@@@@@@@@@@@ change SPI speed to %d @@@@@@@@@\n", SPEED);
 	return 1;
 }
+
+static int __init init_wilc_spi_driver(void)
+{
+	wilc1000_init_driver();
+	return wilc_netdev_init();
+}
+late_initcall(init_wilc_spi_driver);
+
+static void __exit exit_wilc_spi_driver(void)
+{
+	if (wilc1000_dev)
+		wilc_netdev_free(wilc1000_dev);
+	spi_unregister_driver(&wilc_bus);
+	wilc1000_exit_driver();
+}
+module_exit(exit_wilc_spi_driver);
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 4460c482cb7a..dd312b0b1abf 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -321,6 +321,8 @@ void wilc1000_chip_sleep_manually(u32 u32SleepTime);
 int wilc1000_wlan_get_num_conn_ifcs(void);
 int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 int wilc_netdev_init(void);
+void __exit wilc_netdev_free(struct wilc *wilc1000_dev);
+
 void wilc_handle_isr(void);
 
 u16 wilc1000_set_machw_change_vir_if(bool bValue);
@@ -337,5 +339,7 @@ u8 wilc1000_core_11b_ready(void);
 extern bool wilc1000_enable_ps;
 extern volatile int wilc1000_probe;
 
+void __init wilc1000_init_driver(void);
+void __exit wilc1000_exit_driver(void);
 
 #endif
-- 
2.1.0.rc2

