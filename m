Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:47146 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbeHNAFS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 20:05:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: revert "fix TODO to compile spi and sdio components in single module"
Date: Mon, 13 Aug 2018 23:20:33 +0200
Message-Id: <20180813212108.2442868-1-arnd@arndb.de> (sfid-20180813_232147_270984_FC89F64D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TODO item named "make spi and sdio components coexist in one build"
was apparently addressed a long time ago, but never removed from the
TODO file. However, the new patch that tries to address it actually
makes it worse again by duplicating the common parts of the driver into
two separate modules rather than sharing them. This also introduces a
build regression when one of the two is built-in while the other is a
loadable module:

drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined reference to `__this_module'

Reverting the patch makes it build again. I'm leaving the TODO file
modification though, as there is nothing left to do for this item.

A related problem however still seems to exist: one still cannot have
multiple concurrent instances of wilc1000 devices present in the
system, as there are lots of shared global variables such as

host_interface.c:static struct wilc_vif *periodic_rssi_vif;
wilc_sdio.c:static struct wilc_sdio g_sdio;
wilc_wlan.c:static enum chip_ps_states chip_ps_state = CHIP_WAKEDUP;
wilc_wlan.c:static u32 pending_acks;
wilc_wfi_cfgoperations.c:int wilc_connecting;

In order to have multiple instances working (sdio, spi, or mixed),
all such variables need to be dynamically allocated per instance and
stored in 'struct wilc' or one of the structures referenced by it.

Fixes: 9abc44ba4e2f ("staging: wilc1000: fix TODO to compile spi and sdio components in single module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Makefile       | 3 +--
 drivers/staging/wilc1000/linux_wlan.c   | 6 ++++--
 drivers/staging/wilc1000/wilc_debugfs.c | 7 +++++--
 drivers/staging/wilc1000/wilc_wlan.c    | 6 ++++++
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 --
 5 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index f7b07c0b5ce2..ee7e26b886a5 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_WILC1000) += wilc1000.o
 
 ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
@@ -11,9 +12,7 @@ wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_wlan.o
 
 obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
-wilc1000-sdio-objs += $(wilc1000-objs)
 wilc1000-sdio-objs += wilc_sdio.o
 
 obj-$(CONFIG_WILC1000_SPI) += wilc1000-spi.o
-wilc1000-spi-objs += $(wilc1000-objs)
 wilc1000-spi-objs += wilc_spi.o
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 01cf4bd2e192..3b8d237decbf 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1038,8 +1038,8 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	}
 
 	kfree(wilc);
-	wilc_debugfs_remove();
 }
+EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
 
 static const struct net_device_ops wilc_netdev_ops = {
 	.ndo_init = mac_init_fn,
@@ -1062,7 +1062,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	if (!wl)
 		return -ENOMEM;
 
-	wilc_debugfs_init();
 	*wilc = wl;
 	wl->io_type = io_type;
 	wl->hif_func = ops;
@@ -1124,3 +1123,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wilc_netdev_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index edc72876458d..8001df66b8c2 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -19,6 +19,7 @@ static struct dentry *wilc_dir;
 
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
+EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
 
 static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
 				     size_t count, loff_t *ppos)
@@ -87,7 +88,7 @@ static struct wilc_debugfs_info_t debugfs_info[] = {
 	},
 };
 
-int wilc_debugfs_init(void)
+static int __init wilc_debugfs_init(void)
 {
 	int i;
 	struct wilc_debugfs_info_t *info;
@@ -103,10 +104,12 @@ int wilc_debugfs_init(void)
 	}
 	return 0;
 }
+module_init(wilc_debugfs_init);
 
-void wilc_debugfs_remove(void)
+static void __exit wilc_debugfs_remove(void)
 {
 	debugfs_remove_recursive(wilc_dir);
 }
+module_exit(wilc_debugfs_remove);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 6787b6e9f124..8b184aa30d25 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -417,6 +417,7 @@ void chip_allow_sleep(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0xf0, reg & ~BIT(0));
 	wilc->hif_func->hif_write_reg(wilc, 0xfa, 0);
 }
+EXPORT_SYMBOL_GPL(chip_allow_sleep);
 
 void chip_wakeup(struct wilc *wilc)
 {
@@ -471,6 +472,7 @@ void chip_wakeup(struct wilc *wilc)
 	}
 	chip_ps_state = CHIP_WAKEDUP;
 }
+EXPORT_SYMBOL_GPL(chip_wakeup);
 
 void wilc_chip_sleep_manually(struct wilc *wilc)
 {
@@ -484,6 +486,7 @@ void wilc_chip_sleep_manually(struct wilc *wilc)
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
 	release_bus(wilc, RELEASE_ONLY);
 }
+EXPORT_SYMBOL_GPL(wilc_chip_sleep_manually);
 
 void host_wakeup_notify(struct wilc *wilc)
 {
@@ -491,6 +494,7 @@ void host_wakeup_notify(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0x10b0, 1);
 	release_bus(wilc, RELEASE_ONLY);
 }
+EXPORT_SYMBOL_GPL(host_wakeup_notify);
 
 void host_sleep_notify(struct wilc *wilc)
 {
@@ -498,6 +502,7 @@ void host_sleep_notify(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0x10ac, 1);
 	release_bus(wilc, RELEASE_ONLY);
 }
+EXPORT_SYMBOL_GPL(host_sleep_notify);
 
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 {
@@ -871,6 +876,7 @@ void wilc_handle_isr(struct wilc *wilc)
 
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 }
+EXPORT_SYMBOL_GPL(wilc_handle_isr);
 
 int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 				u32 buffer_size)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 00d13b153f80..b81a73b9bd67 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -831,6 +831,4 @@ struct wilc;
 int wilc_wlan_init(struct net_device *dev);
 u32 wilc_get_chipid(struct wilc *wilc, bool update);
 
-int wilc_debugfs_init(void);
-void wilc_debugfs_remove(void);
 #endif
-- 
2.18.0
