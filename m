Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53307 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeG2HgV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/8] staging: wilc1000: fix TODO to compile spi and sdio components in single module
Date: Sun, 29 Jul 2018 11:36:50 +0530
Message-ID: <1532844417-3192-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080710_530834_B3A535C0)
In-Reply-To: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes to compile module component along with SPI and SDIO module.
Previously 'wilc1000.ko' used to generate along with wilc-spi.ko or
wilc1000-sdio.ko module. After these changes only wilc1000-spi.ko or
wilc1000-sdio.ko modules are required for SPI and SDIO respectively.
These changes are done to address below TODO item.

- make SPI and SDIO components coexist in one build

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile       | 3 ++-
 drivers/staging/wilc1000/TODO           | 1 -
 drivers/staging/wilc1000/linux_wlan.c   | 6 ++----
 drivers/staging/wilc1000/wilc_debugfs.c | 7 ++-----
 drivers/staging/wilc1000/wilc_wlan.c    | 6 ------
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 ++
 6 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index ee7e26b..f7b07c0 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_WILC1000) += wilc1000.o
 
 ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
@@ -12,7 +11,9 @@ wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_wlan.o
 
 obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
+wilc1000-sdio-objs += $(wilc1000-objs)
 wilc1000-sdio-objs += wilc_sdio.o
 
 obj-$(CONFIG_WILC1000_SPI) += wilc1000-spi.o
+wilc1000-spi-objs += $(wilc1000-objs)
 wilc1000-spi-objs += wilc_spi.o
diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 3d82bb0..6fd3a4c 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -1,5 +1,4 @@
 TODO:
 - rework comments and function headers(also coding style)
-- make spi and sdio components coexist in one build
 - support soft-ap and p2p mode
 - support resume/suspend function
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 64c5d69..c9e771a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1033,8 +1033,8 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	}
 
 	kfree(wilc);
+	wilc_debugfs_remove();
 }
-EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
 
 static const struct net_device_ops wilc_netdev_ops = {
 	.ndo_init = mac_init_fn,
@@ -1057,6 +1057,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	if (!wl)
 		return -ENOMEM;
 
+	wilc_debugfs_init();
 	*wilc = wl;
 	wl->io_type = io_type;
 	wl->hif_func = ops;
@@ -1118,6 +1119,3 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(wilc_netdev_init);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 287c11b..ecbf3db 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -28,7 +28,6 @@ static struct dentry *wilc_dir;
 
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
-EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
 
 /*
  * ----------------------------------------------------------------------------
@@ -105,7 +104,7 @@ static struct wilc_debugfs_info_t debugfs_info[] = {
 	},
 };
 
-static int __init wilc_debugfs_init(void)
+int wilc_debugfs_init(void)
 {
 	int i;
 	struct wilc_debugfs_info_t *info;
@@ -121,12 +120,10 @@ static int __init wilc_debugfs_init(void)
 	}
 	return 0;
 }
-module_init(wilc_debugfs_init);
 
-static void __exit wilc_debugfs_remove(void)
+void wilc_debugfs_remove(void)
 {
 	debugfs_remove_recursive(wilc_dir);
 }
-module_exit(wilc_debugfs_remove);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ea2e77f..61dca05 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -407,7 +407,6 @@ void chip_allow_sleep(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0xf0, reg & ~BIT(0));
 	wilc->hif_func->hif_write_reg(wilc, 0xfa, 0);
 }
-EXPORT_SYMBOL_GPL(chip_allow_sleep);
 
 void chip_wakeup(struct wilc *wilc)
 {
@@ -462,7 +461,6 @@ void chip_wakeup(struct wilc *wilc)
 	}
 	chip_ps_state = CHIP_WAKEDUP;
 }
-EXPORT_SYMBOL_GPL(chip_wakeup);
 
 void wilc_chip_sleep_manually(struct wilc *wilc)
 {
@@ -476,7 +474,6 @@ void wilc_chip_sleep_manually(struct wilc *wilc)
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
 	release_bus(wilc, RELEASE_ONLY);
 }
-EXPORT_SYMBOL_GPL(wilc_chip_sleep_manually);
 
 void host_wakeup_notify(struct wilc *wilc)
 {
@@ -484,7 +481,6 @@ void host_wakeup_notify(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0x10b0, 1);
 	release_bus(wilc, RELEASE_ONLY);
 }
-EXPORT_SYMBOL_GPL(host_wakeup_notify);
 
 void host_sleep_notify(struct wilc *wilc)
 {
@@ -492,7 +488,6 @@ void host_sleep_notify(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0x10ac, 1);
 	release_bus(wilc, RELEASE_ONLY);
 }
-EXPORT_SYMBOL_GPL(host_sleep_notify);
 
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 {
@@ -869,7 +864,6 @@ void wilc_handle_isr(struct wilc *wilc)
 
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 }
-EXPORT_SYMBOL_GPL(wilc_handle_isr);
 
 int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 				u32 buffer_size)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 73b57fb..598c8dc 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -835,4 +835,6 @@ struct wilc;
 int wilc_wlan_init(struct net_device *dev);
 u32 wilc_get_chipid(struct wilc *wilc, bool update);
 
+int wilc_debugfs_init(void);
+void wilc_debugfs_remove(void);
 #endif
-- 
2.7.4
