Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:61254 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbKJXm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:42:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/20] staging/wilc1000: remove linux_wlan_{device_power,device_detection}
Date: Wed, 11 Nov 2015 00:42:28 +0100
Message-Id: <1447198960-2760143-9-git-send-email-arnd@arndb.de> (sfid-20151111_004900_682370_4B187CE3)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
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
 drivers/staging/wilc1000/linux_wlan.c | 40 -----------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 040caa0d0d0b..6e1ef99fc856 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -31,40 +31,6 @@
 #include "linux_wlan_spi.h"
 #endif
 
- #define _linux_wlan_device_power_on()		{}
- #define _linux_wlan_device_power_off()		{}
-
- #define _linux_wlan_device_detection()		{}
- #define _linux_wlan_device_removal()		{}
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
@@ -1476,8 +1442,6 @@ void wl_wlan_cleanup(struct wilc *wilc)
 #if defined(WILC_DEBUGFS)
 	wilc_debugfs_remove();
 #endif
-	linux_wlan_device_detection(0);
-	linux_wlan_device_power(0);
 }
 
 int wilc_netdev_init(struct wilc **wilc)
@@ -1579,10 +1543,6 @@ static int __init init_wilc_driver(void)
 	printk("IN INIT FUNCTION\n");
 	printk("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
 
-	linux_wlan_device_power(1);
-	msleep(100);
-	linux_wlan_device_detection(1);
-
 #ifdef WILC_SDIO
 	{
 		int ret;
-- 
2.1.0.rc2

