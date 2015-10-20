Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57396 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbbJTWsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/19] staging/wilc1000: remove linux_wlan_{device_power,device_detection}
Date: Wed, 21 Oct 2015 00:47:26 +0200
Message-Id: <1445381258-1455986-8-git-send-email-arnd@arndb.de> (sfid-20151021_005414_895745_AE493894)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver provides an interface for custom power management
and detection that is meant to be filled by people customizing
the driver. The default implementation of this is empty, and
we don't actually want people to have to modify the source code.

If anybody needs this, they need to describe the respective
hardware specifics using device tree or platform data and make
the driver handle this is a more general way.

This removes the empty stubs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c | 62 -----------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d3cc255cd91b..eb4c6cba4575 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -32,47 +32,6 @@
 #include "linux_wlan_spi.h"
 #endif
 
-#if defined(CUSTOMER_PLATFORM)
-/*
- TODO : Write power control functions as customer platform.
- */
-#else
-
- #define _linux_wlan_device_power_on()		{}
- #define _linux_wlan_device_power_off()		{}
-
- #define _linux_wlan_device_detection()		{}
- #define _linux_wlan_device_removal()		{}
-#endif
-
-static int linux_wlan_device_power(int on_off)
-{
-	PRINT_D(INIT_DBG, "linux_wlan_device_power.. (%d)\n", on_off);
-
-	if (on_off) {
-		_linux_wlan_device_power_on();
-	} else {
-		_linux_wlan_device_power_off();
-	}
-
-	return 0;
-}
-
-static int linux_wlan_device_detection(int on_off)
-{
-	PRINT_D(INIT_DBG, "linux_wlan_device_detection.. (%d)\n", on_off);
-
-#ifdef WILC_SDIO
-	if (on_off) {
-		_linux_wlan_device_detection();
-	} else {
-		_linux_wlan_device_removal();
-	}
-#endif
-
-	return 0;
-}
-
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr);
 
 static struct notifier_block g_dev_notifier = {
@@ -1046,12 +1005,6 @@ static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 		wilc_wlan_global_reset();
 		sdio_unregister_driver(&wilc_bus);
 
-		linux_wlan_device_detection(0);
-
-		mdelay(100);
-
-		linux_wlan_device_detection(1);
-
 		sdio_register_driver(&wilc_bus);
 
 		while (!wilc1000_probe)
@@ -1076,14 +1029,6 @@ static int repeat_power_cycle(perInterface_wlan_t *nic)
 
 	sdio_unregister_driver(&wilc_bus);
 
-	linux_wlan_device_detection(0);
-	linux_wlan_device_power(0);
-	msleep(100);
-	linux_wlan_device_power(1);
-	msleep(80);
-	linux_wlan_device_detection(1);
-	msleep(20);
-
 	sdio_register_driver(&wilc_bus);
 
 	/* msleep(1000); */
@@ -1794,10 +1739,6 @@ static int __init init_wilc_driver(void)
 	printk("IN INIT FUNCTION\n");
 	printk("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
 
-	linux_wlan_device_power(1);
-	msleep(100);
-	linux_wlan_device_detection(1);
-
 #ifdef WILC_SDIO
 	{
 		int ret;
@@ -1877,9 +1818,6 @@ static void __exit exit_wilc_driver(void)
 #if defined(WILC_DEBUGFS)
 	wilc_debugfs_remove();
 #endif
-
-	linux_wlan_device_detection(0);
-	linux_wlan_device_power(0);
 }
 module_exit(exit_wilc_driver);
 
-- 
2.1.0.rc2

