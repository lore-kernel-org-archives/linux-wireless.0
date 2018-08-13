Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:4495 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeHMITm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 04:19:42 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: fix for undefined reference to `__this_module' error
Date: Mon, 13 Aug 2018 11:08:52 +0530
Message-ID: <1534138732-12732-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180813_073908_810650_25D421BD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_debugfs.o object file is included for both SDIO and SPI module.
When anyone(either SDIO or SPI) module is compiled as loaded module and
another as builtin module then below compilation error occurs.

"drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined
reference to `__this_module'"

Deleted wilc_debugfs.c file as it's not used, fixed the compilation error.

Fixes: 9abc44ba4e2f ("staging: wilc1000: fix TODO to compile spi and sdio components in single module")
Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile       |   5 +-
 drivers/staging/wilc1000/linux_wlan.c   |   2 -
 drivers/staging/wilc1000/wilc_debugfs.c | 112 --------------------------------
 drivers/staging/wilc1000/wilc_wlan_if.h |   2 -
 4 files changed, 2 insertions(+), 119 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_debugfs.c

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index f7b07c0..b37001c 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -3,12 +3,11 @@
 ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
 
-ccflags-y += -I$(src)/ -DWILC_ASIC_A0 -DWILC_DEBUGFS
+ccflags-y += -I$(src)/ -DWILC_ASIC_A0
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			coreconfigurator.o host_interface.o \
-			wilc_wlan_cfg.o wilc_debugfs.o \
-			wilc_wlan.o
+			wilc_wlan_cfg.o wilc_wlan.o
 
 obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
 wilc1000-sdio-objs += $(wilc1000-objs)
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 01cf4bd..8018efb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1038,7 +1038,6 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	}
 
 	kfree(wilc);
-	wilc_debugfs_remove();
 }
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -1062,7 +1061,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	if (!wl)
 		return -ENOMEM;
 
-	wilc_debugfs_init();
 	*wilc = wl;
 	wl->io_type = io_type;
 	wl->hif_func = ops;
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
deleted file mode 100644
index edc7287..0000000
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ /dev/null
@@ -1,112 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
- * All rights reserved.
- */
-
-#if defined(WILC_DEBUGFS)
-#include <linux/module.h>
-#include <linux/debugfs.h>
-
-#include "wilc_wlan_if.h"
-
-static struct dentry *wilc_dir;
-
-#define DEBUG           BIT(0)
-#define INFO            BIT(1)
-#define WRN             BIT(2)
-#define ERR             BIT(3)
-
-#define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
-
-static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
-				     size_t count, loff_t *ppos)
-{
-	char buf[128];
-	int res = 0;
-
-	/* only allow read from start */
-	if (*ppos > 0)
-		return 0;
-
-	res = scnprintf(buf, sizeof(buf), "Debug Level: %x\n",
-			atomic_read(&WILC_DEBUG_LEVEL));
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
-}
-
-static ssize_t wilc_debug_level_write(struct file *filp,
-				      const char __user *buf, size_t count,
-				      loff_t *ppos)
-{
-	int flag = 0;
-	int ret;
-
-	ret = kstrtouint_from_user(buf, count, 16, &flag);
-	if (ret)
-		return ret;
-
-	if (flag > DBG_LEVEL_ALL) {
-		pr_info("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n",
-			__func__, flag, atomic_read(&WILC_DEBUG_LEVEL));
-		return -EINVAL;
-	}
-
-	atomic_set(&WILC_DEBUG_LEVEL, (int)flag);
-
-	if (flag == 0)
-		pr_info("Debug-level disabled\n");
-	else
-		pr_info("Debug-level enabled\n");
-
-	return count;
-}
-
-#define FOPS(_open, _read, _write, _poll) { \
-		.owner	= THIS_MODULE, \
-		.open	= (_open), \
-		.read	= (_read), \
-		.write	= (_write), \
-		.poll		= (_poll), \
-}
-
-struct wilc_debugfs_info_t {
-	const char *name;
-	int perm;
-	unsigned int data;
-	const struct file_operations fops;
-};
-
-static struct wilc_debugfs_info_t debugfs_info[] = {
-	{
-		"wilc_debug_level",
-		0666,
-		(DEBUG | ERR),
-		FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL),
-	},
-};
-
-int wilc_debugfs_init(void)
-{
-	int i;
-	struct wilc_debugfs_info_t *info;
-
-	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
-	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
-		info = &debugfs_info[i];
-		debugfs_create_file(info->name,
-				    info->perm,
-				    wilc_dir,
-				    &info->data,
-				    &info->fops);
-	}
-	return 0;
-}
-
-void wilc_debugfs_remove(void)
-{
-	debugfs_remove_recursive(wilc_dir);
-}
-
-#endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 00d13b1..b81a73b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -831,6 +831,4 @@ struct wilc;
 int wilc_wlan_init(struct net_device *dev);
 u32 wilc_get_chipid(struct wilc *wilc, bool update);
 
-int wilc_debugfs_init(void);
-void wilc_debugfs_remove(void);
 #endif
-- 
2.7.4
