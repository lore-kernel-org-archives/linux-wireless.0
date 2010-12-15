Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:25143 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab0LOOVc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 09:21:32 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBFEL1R7002410
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 16:21:31 +0200
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Roger Quadros <roger.quadros@nokia.com>
Subject: [PATCH] wl12xx_sdio_test: rename files to match current style
Date: Wed, 15 Dec 2010 16:23:31 +0200
Message-Id: <1292423011-5467-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Change some file names and Kconfig settings so that this new module matches
the new way of using wl12xx instead of wl1271.

Also fix SDIO power enabling and disabling to match the latest way of doing
it.

Cc: Roger Quadros <roger.quadros@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/Kconfig            |   12 +-
 drivers/net/wireless/wl12xx/Makefile           |    3 +-
 drivers/net/wireless/wl12xx/sdio_test.c        |  520 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_sdio_test.c |  510 -----------------------
 4 files changed, 529 insertions(+), 516 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/sdio_test.c
 delete mode 100644 drivers/net/wireless/wl12xx/wl1271_sdio_test.c

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 085bc44..0e65bce 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -52,13 +52,15 @@ config WL12XX_SDIO
 	  If you choose to build a module, it'll be called wl12xx_sdio.
 	  Say N if unsure.
 
-config WL1271_SDIO_TEST
-	tristate "TI wl1271 SDIO testing support"
-	depends on WL1271 && MMC
+config WL12XX_SDIO_TEST
+	tristate "TI wl12xx SDIO testing support"
+	depends on WL12XX && MMC
+	default n
 	---help---
 	  This module adds support for the SDIO bus testing with the
-	  TI wl1271 chipset.  Select this if your platform is using
-	  the SDIO bus.
+	  TI wl12xx chipsets.  You probably don't want this unless you are
+	  testing a new hardware platform.  Select this if you want to test the
+	  SDIO bus which is connected to the wl12xx chip.
 
 config WL12XX_PLATFORM_DATA
 	bool
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 1876785..521c041 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -3,13 +3,14 @@ wl12xx-objs		= main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
 
 wl12xx_spi-objs	= spi.o
 wl12xx_sdio-objs	= sdio.o
+wl12xx_sdio_test-objs = sdio_test.o
 
 wl12xx-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
 obj-$(CONFIG_WL12XX)			+= wl12xx.o
 obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
 obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
 
-obj-$(CONFIG_WL1271_SDIO_TEST)	+= wl1271_sdio_test.o
+obj-$(CONFIG_WL12XX_SDIO_TEST)	+= wl12xx_sdio_test.o
 
 # small builtin driver bit
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
new file mode 100644
index 0000000..9475396
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -0,0 +1,520 @@
+/*
+ * wl12xx_sdio_test.c - SDIO testing driver for wl12xx
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contact: Roger Quadros <roger.quadros@nokia.com>
+ *
+ * wl12xx read/write routines taken from wl12xx_sdio.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/crc7.h>
+#include <linux/vmalloc.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/card.h>
+#include <linux/gpio.h>
+#include <linux/wl12xx.h>
+#include <linux/kthread.h>
+#include <linux/firmware.h>
+#include <linux/pm_runtime.h>
+
+#include "wl12xx.h"
+#include "io.h"
+#include "boot.h"
+
+#ifndef SDIO_VENDOR_ID_TI
+#define SDIO_VENDOR_ID_TI		0x0097
+#endif
+
+#ifndef SDIO_DEVICE_ID_TI_WL1271
+#define SDIO_DEVICE_ID_TI_WL1271	0x4076
+#endif
+
+static bool rx, tx;
+
+module_param(rx, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rx, "Perform rx test. Default (0). "
+	"This test continuously reads data from the SDIO device.\n");
+
+module_param(tx, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(tx, "Perform tx test. Default (0). "
+	"This test continuously writes data to the SDIO device.\n");
+
+struct wl1271_test {
+	struct wl1271 wl;
+	struct task_struct *test_task;
+};
+
+static const struct sdio_device_id wl1271_devices[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271) },
+	{}
+};
+
+static inline struct sdio_func *wl_to_func(struct wl1271 *wl)
+{
+	return wl->if_priv;
+}
+
+static struct device *wl1271_sdio_wl_to_dev(struct wl1271 *wl)
+{
+	return &(wl_to_func(wl)->dev);
+}
+
+static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
+		size_t len, bool fixed)
+{
+	int ret = 0;
+	struct sdio_func *func = wl_to_func(wl);
+
+	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
+		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
+		wl1271_debug(DEBUG_SDIO, "sdio read 52 addr 0x%x, byte 0x%02x",
+				addr, ((u8 *)buf)[0]);
+	} else {
+		if (fixed)
+			ret = sdio_readsb(func, buf, addr, len);
+		else
+			ret = sdio_memcpy_fromio(func, buf, addr, len);
+
+		wl1271_debug(DEBUG_SDIO, "sdio read 53 addr 0x%x, %zu bytes",
+				addr, len);
+		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
+	}
+
+	if (ret)
+		wl1271_error("sdio read failed (%d)", ret);
+}
+
+static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
+		size_t len, bool fixed)
+{
+	int ret = 0;
+	struct sdio_func *func = wl_to_func(wl);
+
+	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
+		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
+		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
+				addr, ((u8 *)buf)[0]);
+	} else {
+		wl1271_debug(DEBUG_SDIO, "sdio write 53 addr 0x%x, %zu bytes",
+				addr, len);
+		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
+
+		if (fixed)
+			ret = sdio_writesb(func, addr, buf, len);
+		else
+			ret = sdio_memcpy_toio(func, addr, buf, len);
+	}
+	if (ret)
+		wl1271_error("sdio write failed (%d)", ret);
+
+}
+
+static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
+{
+	struct sdio_func *func = wl_to_func(wl);
+	int ret;
+
+	/* Let the SDIO stack handle wlan_enable control, so we
+	 * keep host claimed while wlan is in use to keep wl1271
+	 * alive.
+	 */
+	if (enable) {
+		/* Power up the card */
+		ret = pm_runtime_get_sync(&func->dev);
+		if (ret < 0)
+			goto out;
+		sdio_claim_host(func);
+		sdio_enable_func(func);
+		sdio_release_host(func);
+	} else {
+		sdio_claim_host(func);
+		sdio_disable_func(func);
+		sdio_release_host(func);
+
+		/* Power down the card */
+		ret = pm_runtime_put_sync(&func->dev);
+	}
+
+out:
+	return ret;
+}
+
+static void wl1271_sdio_disable_interrupts(struct wl1271 *wl)
+{
+}
+
+static void wl1271_sdio_enable_interrupts(struct wl1271 *wl)
+{
+}
+
+
+static struct wl1271_if_operations sdio_ops = {
+	.read		= wl1271_sdio_raw_read,
+	.write		= wl1271_sdio_raw_write,
+	.power		= wl1271_sdio_set_power,
+	.dev		= wl1271_sdio_wl_to_dev,
+	.enable_irq	= wl1271_sdio_enable_interrupts,
+	.disable_irq	= wl1271_sdio_disable_interrupts,
+};
+
+static void wl1271_fw_wakeup(struct wl1271 *wl)
+{
+	u32 elp_reg;
+
+	elp_reg = ELPCTRL_WAKE_UP;
+	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
+}
+
+static int wl1271_fetch_firmware(struct wl1271 *wl)
+{
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, WL1271_FW_NAME, wl1271_wl_to_dev(wl));
+
+	if (ret < 0) {
+		wl1271_error("could not get firmware: %d", ret);
+		return ret;
+	}
+
+	if (fw->size % 4) {
+		wl1271_error("firmware size is not multiple of 32 bits: %zu",
+				fw->size);
+		ret = -EILSEQ;
+		goto out;
+	}
+
+	wl->fw_len = fw->size;
+	wl->fw = vmalloc(wl->fw_len);
+
+	if (!wl->fw) {
+		wl1271_error("could not allocate memory for the firmware");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(wl->fw, fw->data, wl->fw_len);
+
+	ret = 0;
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int wl1271_fetch_nvs(struct wl1271 *wl)
+{
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, WL1271_NVS_NAME, wl1271_wl_to_dev(wl));
+
+	if (ret < 0) {
+		wl1271_error("could not get nvs file: %d", ret);
+		return ret;
+	}
+
+	wl->nvs = kmemdup(fw->data, sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+
+	if (!wl->nvs) {
+		wl1271_error("could not allocate memory for the nvs file");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl->nvs_len = fw->size;
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int wl1271_chip_wakeup(struct wl1271 *wl)
+{
+	struct wl1271_partition_set partition;
+	int ret;
+
+	msleep(WL1271_PRE_POWER_ON_SLEEP);
+	ret = wl1271_power_on(wl);
+	if (ret)
+		return ret;
+
+	msleep(WL1271_POWER_ON_SLEEP);
+
+	/* We don't need a real memory partition here, because we only want
+	 * to use the registers at this point. */
+	memset(&partition, 0, sizeof(partition));
+	partition.reg.start = REGISTERS_BASE;
+	partition.reg.size = REGISTERS_DOWN_SIZE;
+	wl1271_set_partition(wl, &partition);
+
+	/* ELP module wake up */
+	wl1271_fw_wakeup(wl);
+
+	/* whal_FwCtrl_BootSm() */
+
+	/* 0. read chip id from CHIP_ID */
+	wl->chip.id = wl1271_read32(wl, CHIP_ID_B);
+
+	/* 1. check if chip id is valid */
+
+	switch (wl->chip.id) {
+	case CHIP_ID_1271_PG10:
+		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
+				wl->chip.id);
+		break;
+	case CHIP_ID_1271_PG20:
+		wl1271_notice("chip id 0x%x (1271 PG20)",
+				wl->chip.id);
+		break;
+	default:
+		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
+		return -ENODEV;
+	}
+
+	return ret;
+}
+
+static struct wl1271_partition_set part_down = {
+	.mem = {
+		.start = 0x00000000,
+		.size  = 0x000177c0
+	},
+	.reg = {
+		.start = REGISTERS_BASE,
+		.size  = 0x00008800
+	},
+	.mem2 = {
+		.start = 0x00000000,
+		.size  = 0x00000000
+	},
+	.mem3 = {
+		.start = 0x00000000,
+		.size  = 0x00000000
+	},
+};
+
+static int tester(void *data)
+{
+	struct wl1271 *wl = data;
+	struct sdio_func *func = wl_to_func(wl);
+	struct device *pdev = &func->dev;
+	int ret = 0;
+	bool rx_started = 0;
+	bool tx_started = 0;
+	uint8_t *tx_buf, *rx_buf;
+	int test_size = PAGE_SIZE;
+	u32 addr = 0;
+	struct wl1271_partition_set partition;
+
+	/* We assume chip is powered up and firmware fetched */
+
+	memcpy(&partition, &part_down, sizeof(partition));
+	partition.mem.start = addr;
+	wl1271_set_partition(wl, &partition);
+
+	tx_buf = kmalloc(test_size, GFP_KERNEL);
+	rx_buf = kmalloc(test_size, GFP_KERNEL);
+	if (!tx_buf || !rx_buf) {
+		dev_err(pdev,
+			"Could not allocate memory. Test will not run.\n");
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	memset(tx_buf, 0x5a, test_size);
+
+	/* write something in data area so we can read it back */
+	wl1271_write(wl, addr, tx_buf, test_size, false);
+
+	while (!kthread_should_stop()) {
+		if (rx && !rx_started) {
+			dev_info(pdev, "starting rx test\n");
+			rx_started = 1;
+		} else if (!rx && rx_started) {
+			dev_info(pdev, "stopping rx test\n");
+			rx_started = 0;
+		}
+
+		if (tx && !tx_started) {
+			dev_info(pdev, "starting tx test\n");
+			tx_started = 1;
+		} else if (!tx && tx_started) {
+			dev_info(pdev, "stopping tx test\n");
+			tx_started = 0;
+		}
+
+		if (rx_started)
+			wl1271_read(wl, addr, rx_buf, test_size, false);
+
+		if (tx_started)
+			wl1271_write(wl, addr, tx_buf, test_size, false);
+
+		if (!rx_started && !tx_started)
+			msleep(100);
+	}
+
+free:
+	kfree(tx_buf);
+	kfree(rx_buf);
+	return ret;
+}
+
+static int __devinit wl1271_probe(struct sdio_func *func,
+		const struct sdio_device_id *id)
+{
+	const struct wl12xx_platform_data *wlan_data;
+	struct wl1271 *wl;
+	struct wl1271_test *wl_test;
+	int ret = 0;
+
+	/* wl1271 has 2 sdio functions we handle just the wlan part */
+	if (func->num != 0x02)
+		return -ENODEV;
+
+	wl_test = kzalloc(sizeof(struct wl1271_test), GFP_KERNEL);
+	if (!wl_test) {
+		dev_err(&func->dev, "Could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	wl = &wl_test->wl;
+
+	wl->if_priv = func;
+	wl->if_ops = &sdio_ops;
+
+	/* Grab access to FN0 for ELP reg. */
+	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+
+	wlan_data = wl12xx_get_platform_data();
+	if (IS_ERR(wlan_data)) {
+		ret = PTR_ERR(wlan_data);
+		dev_err(&func->dev, "missing wlan platform data: %d\n", ret);
+		goto out_free;
+	}
+
+	wl->irq = wlan_data->irq;
+	wl->ref_clock = wlan_data->board_ref_clock;
+
+	sdio_set_drvdata(func, wl_test);
+
+
+	/* power up the device */
+	ret = wl1271_chip_wakeup(wl);
+	if (ret) {
+		dev_err(&func->dev, "could not wake up chip\n");
+		goto out_free;
+	}
+
+	if (wl->fw == NULL) {
+		ret = wl1271_fetch_firmware(wl);
+		if (ret < 0) {
+			dev_err(&func->dev, "firmware fetch error\n");
+			goto out_off;
+		}
+	}
+
+	/* fetch NVS */
+	if (wl->nvs == NULL) {
+		ret = wl1271_fetch_nvs(wl);
+		if (ret < 0) {
+			dev_err(&func->dev, "NVS fetch error\n");
+			goto out_off;
+		}
+	}
+
+	ret = wl1271_load_firmware(wl);
+	if (ret < 0) {
+		dev_err(&func->dev, "firmware load error: %d\n", ret);
+		goto out_free;
+	}
+
+	dev_info(&func->dev, "initialized\n");
+
+	/* I/O testing will be done in the tester thread */
+
+	wl_test->test_task = kthread_run(tester, wl, "sdio_tester");
+	if (IS_ERR(wl_test->test_task)) {
+		dev_err(&func->dev, "unable to create kernel thread\n");
+		ret = PTR_ERR(wl_test->test_task);
+		goto out_free;
+	}
+
+	return 0;
+
+out_off:
+	/* power off the chip */
+	wl1271_power_off(wl);
+
+out_free:
+	kfree(wl_test);
+	return ret;
+}
+
+static void __devexit wl1271_remove(struct sdio_func *func)
+{
+	struct wl1271_test *wl_test = sdio_get_drvdata(func);
+
+	/* stop the I/O test thread */
+	kthread_stop(wl_test->test_task);
+
+	/* power off the chip */
+	wl1271_power_off(&wl_test->wl);
+
+	vfree(wl_test->wl.fw);
+	wl_test->wl.fw = NULL;
+	kfree(wl_test->wl.nvs);
+	wl_test->wl.nvs = NULL;
+
+	kfree(wl_test);
+}
+
+static struct sdio_driver wl1271_sdio_driver = {
+	.name		= "wl12xx_sdio_test",
+	.id_table	= wl1271_devices,
+	.probe		= wl1271_probe,
+	.remove		= __devexit_p(wl1271_remove),
+};
+
+static int __init wl1271_init(void)
+{
+	int ret;
+
+	ret = sdio_register_driver(&wl1271_sdio_driver);
+	if (ret < 0)
+		pr_err("failed to register sdio driver: %d\n", ret);
+
+	return ret;
+}
+module_init(wl1271_init);
+
+static void __exit wl1271_exit(void)
+{
+	sdio_unregister_driver(&wl1271_sdio_driver);
+}
+module_exit(wl1271_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Roger Quadros <roger.quadros@nokia.com>");
+
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio_test.c b/drivers/net/wireless/wl12xx/wl1271_sdio_test.c
deleted file mode 100644
index 42d1314..0000000
--- a/drivers/net/wireless/wl12xx/wl1271_sdio_test.c
+++ /dev/null
@@ -1,510 +0,0 @@
-/*
- * wl1271_sdio_test.c - SDIO testing driver for wl1271
- *
- * Copyright (C) 2010 Nokia Corporation
- *
- * Contact: Roger Quadros <roger.quadros@nokia.com>
- *
- * wl1271 read/write routines taken from wl1271_sdio.c
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/irq.h>
-#include <linux/module.h>
-#include <linux/crc7.h>
-#include <linux/vmalloc.h>
-#include <linux/mmc/sdio_func.h>
-#include <linux/mmc/sdio_ids.h>
-#include <linux/mmc/card.h>
-#include <linux/gpio.h>
-#include <linux/wl12xx.h>
-#include <linux/kthread.h>
-#include <linux/firmware.h>
-
-#include "wl1271.h"
-#include "wl1271_io.h"
-#include "wl1271_boot.h"
-
-#ifndef SDIO_VENDOR_ID_TI
-#define SDIO_VENDOR_ID_TI		0x0097
-#endif
-
-#ifndef SDIO_DEVICE_ID_TI_WL1271
-#define SDIO_DEVICE_ID_TI_WL1271	0x4076
-#endif
-
-static bool rx, tx;
-
-module_param(rx, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(rx, "Perform rx test. Default (0). "
-	"This test continuously reads data from the SDIO device.\n");
-
-module_param(tx, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(tx, "Perform tx test. Default (0). "
-	"This test continuously writes data to the SDIO device.\n");
-
-struct wl1271_test {
-	struct wl1271 wl;
-	struct task_struct *test_task;
-};
-
-static const struct sdio_device_id wl1271_devices[] = {
-	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271) },
-	{}
-};
-
-static inline struct sdio_func *wl_to_func(struct wl1271 *wl)
-{
-	return wl->if_priv;
-}
-
-static struct device *wl1271_sdio_wl_to_dev(struct wl1271 *wl)
-{
-	return &(wl_to_func(wl)->dev);
-}
-
-static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
-		size_t len, bool fixed)
-{
-	int ret = 0;
-	struct sdio_func *func = wl_to_func(wl);
-
-	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
-		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
-		wl1271_debug(DEBUG_SDIO, "sdio read 52 addr 0x%x, byte 0x%02x",
-				addr, ((u8 *)buf)[0]);
-	} else {
-		if (fixed)
-			ret = sdio_readsb(func, buf, addr, len);
-		else
-			ret = sdio_memcpy_fromio(func, buf, addr, len);
-
-		wl1271_debug(DEBUG_SDIO, "sdio read 53 addr 0x%x, %zu bytes",
-				addr, len);
-		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
-	}
-
-	if (ret)
-		wl1271_error("sdio read failed (%d)", ret);
-}
-
-static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
-		size_t len, bool fixed)
-{
-	int ret = 0;
-	struct sdio_func *func = wl_to_func(wl);
-
-	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
-		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
-		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
-				addr, ((u8 *)buf)[0]);
-	} else {
-		wl1271_debug(DEBUG_SDIO, "sdio write 53 addr 0x%x, %zu bytes",
-				addr, len);
-		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
-
-		if (fixed)
-			ret = sdio_writesb(func, addr, buf, len);
-		else
-			ret = sdio_memcpy_toio(func, addr, buf, len);
-	}
-	if (ret)
-		wl1271_error("sdio write failed (%d)", ret);
-
-}
-
-static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
-{
-	struct sdio_func *func = wl_to_func(wl);
-
-	/* Let the SDIO stack handle wlan_enable control, so we
-	 * keep host claimed while wlan is in use to keep wl1271
-	 * alive.
-	 */
-	if (enable) {
-		sdio_claim_power(func);
-		sdio_claim_host(func);
-		sdio_enable_func(func);
-	} else {
-		sdio_disable_func(func);
-		sdio_release_host(func);
-		sdio_release_power(func);
-	}
-
-	return 0;
-}
-
-static void wl1271_sdio_disable_interrupts(struct wl1271 *wl)
-{
-}
-
-static void wl1271_sdio_enable_interrupts(struct wl1271 *wl)
-{
-}
-
-
-static struct wl1271_if_operations sdio_ops = {
-	.read		= wl1271_sdio_raw_read,
-	.write		= wl1271_sdio_raw_write,
-	.power		= wl1271_sdio_set_power,
-	.dev		= wl1271_sdio_wl_to_dev,
-	.enable_irq	= wl1271_sdio_enable_interrupts,
-	.disable_irq	= wl1271_sdio_disable_interrupts,
-};
-
-static void wl1271_fw_wakeup(struct wl1271 *wl)
-{
-	u32 elp_reg;
-
-	elp_reg = ELPCTRL_WAKE_UP;
-	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
-}
-
-static int wl1271_fetch_firmware(struct wl1271 *wl)
-{
-	const struct firmware *fw;
-	int ret;
-
-	ret = request_firmware(&fw, WL1271_FW_NAME, wl1271_wl_to_dev(wl));
-
-	if (ret < 0) {
-		wl1271_error("could not get firmware: %d", ret);
-		return ret;
-	}
-
-	if (fw->size % 4) {
-		wl1271_error("firmware size is not multiple of 32 bits: %zu",
-				fw->size);
-		ret = -EILSEQ;
-		goto out;
-	}
-
-	wl->fw_len = fw->size;
-	wl->fw = vmalloc(wl->fw_len);
-
-	if (!wl->fw) {
-		wl1271_error("could not allocate memory for the firmware");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(wl->fw, fw->data, wl->fw_len);
-
-	ret = 0;
-
-out:
-	release_firmware(fw);
-
-	return ret;
-}
-
-static int wl1271_fetch_nvs(struct wl1271 *wl)
-{
-	const struct firmware *fw;
-	int ret;
-
-	ret = request_firmware(&fw, WL1271_NVS_NAME, wl1271_wl_to_dev(wl));
-
-	if (ret < 0) {
-		wl1271_error("could not get nvs file: %d", ret);
-		return ret;
-	}
-
-	wl->nvs = kmemdup(fw->data, sizeof(struct wl1271_nvs_file), GFP_KERNEL);
-
-	if (!wl->nvs) {
-		wl1271_error("could not allocate memory for the nvs file");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	wl->nvs_len = fw->size;
-
-out:
-	release_firmware(fw);
-
-	return ret;
-}
-
-static int wl1271_chip_wakeup(struct wl1271 *wl)
-{
-	struct wl1271_partition_set partition;
-	int ret;
-
-	msleep(WL1271_PRE_POWER_ON_SLEEP);
-	ret = wl1271_power_on(wl);
-	if (ret)
-		return ret;
-
-	msleep(WL1271_POWER_ON_SLEEP);
-
-	/* We don't need a real memory partition here, because we only want
-	 * to use the registers at this point. */
-	memset(&partition, 0, sizeof(partition));
-	partition.reg.start = REGISTERS_BASE;
-	partition.reg.size = REGISTERS_DOWN_SIZE;
-	wl1271_set_partition(wl, &partition);
-
-	/* ELP module wake up */
-	wl1271_fw_wakeup(wl);
-
-	/* whal_FwCtrl_BootSm() */
-
-	/* 0. read chip id from CHIP_ID */
-	wl->chip.id = wl1271_read32(wl, CHIP_ID_B);
-
-	/* 1. check if chip id is valid */
-
-	switch (wl->chip.id) {
-	case CHIP_ID_1271_PG10:
-		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
-				wl->chip.id);
-		break;
-	case CHIP_ID_1271_PG20:
-		wl1271_notice("chip id 0x%x (1271 PG20)",
-				wl->chip.id);
-		break;
-	default:
-		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
-		return -ENODEV;
-	}
-
-	return ret;
-}
-
-static struct wl1271_partition_set part_down = {
-	.mem = {
-		.start = 0x00000000,
-		.size  = 0x000177c0
-	},
-	.reg = {
-		.start = REGISTERS_BASE,
-		.size  = 0x00008800
-	},
-	.mem2 = {
-		.start = 0x00000000,
-		.size  = 0x00000000
-	},
-	.mem3 = {
-		.start = 0x00000000,
-		.size  = 0x00000000
-	},
-};
-
-static int tester(void *data)
-{
-	struct wl1271 *wl = data;
-	struct sdio_func *func = wl_to_func(wl);
-	struct device *pdev = &func->dev;
-	int ret = 0;
-	bool rx_started = 0;
-	bool tx_started = 0;
-	uint8_t *tx_buf, *rx_buf;
-	int test_size = PAGE_SIZE;
-	u32 addr = 0;
-	struct wl1271_partition_set partition;
-
-	/* We assume chip is powered up and firmware fetched */
-
-	memcpy(&partition, &part_down, sizeof(partition));
-	partition.mem.start = addr;
-	wl1271_set_partition(wl, &partition);
-
-	tx_buf = kmalloc(test_size, GFP_KERNEL);
-	rx_buf = kmalloc(test_size, GFP_KERNEL);
-	if (!tx_buf || !rx_buf) {
-		dev_err(pdev,
-			"Could not allocate memory. Test will not run.\n");
-		ret = -ENOMEM;
-		goto free;
-	}
-
-	memset(tx_buf, 0x5a, test_size);
-
-	/* write something in data area so we can read it back */
-	wl1271_write(wl, addr, tx_buf, test_size, false);
-
-	while (!kthread_should_stop()) {
-		if (rx && !rx_started) {
-			dev_info(pdev, "starting rx test\n");
-			rx_started = 1;
-		} else if (!rx && rx_started) {
-			dev_info(pdev, "stopping rx test\n");
-			rx_started = 0;
-		}
-
-		if (tx && !tx_started) {
-			dev_info(pdev, "starting tx test\n");
-			tx_started = 1;
-		} else if (!tx && tx_started) {
-			dev_info(pdev, "stopping tx test\n");
-			tx_started = 0;
-		}
-
-		if (rx_started)
-			wl1271_read(wl, addr, rx_buf, test_size, false);
-
-		if (tx_started)
-			wl1271_write(wl, addr, tx_buf, test_size, false);
-
-		if (!rx_started && !tx_started)
-			msleep(100);
-	}
-
-free:
-	kfree(tx_buf);
-	kfree(rx_buf);
-	return ret;
-}
-
-static int __devinit wl1271_probe(struct sdio_func *func,
-		const struct sdio_device_id *id)
-{
-	const struct wl12xx_platform_data *wlan_data;
-	struct wl1271 *wl;
-	struct wl1271_test *wl_test;
-	int ret = 0;
-
-	/* wl1271 has 2 sdio functions we handle just the wlan part */
-	if (func->num != 0x02)
-		return -ENODEV;
-
-	wl_test = kzalloc(sizeof(struct wl1271_test), GFP_KERNEL);
-	if (!wl_test) {
-		dev_err(&func->dev, "Could not allocate memory\n");
-		return -ENOMEM;
-	}
-
-	wl = &wl_test->wl;
-
-	wl->if_priv = func;
-	wl->if_ops = &sdio_ops;
-
-	/* Grab access to FN0 for ELP reg. */
-	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
-
-	wlan_data = wl12xx_get_platform_data();
-	if (IS_ERR(wlan_data)) {
-		ret = PTR_ERR(wlan_data);
-		dev_err(&func->dev, "missing wlan platform data: %d\n", ret);
-		goto out_free;
-	}
-
-	wl->irq = wlan_data->irq;
-	wl->ref_clock = wlan_data->board_ref_clock;
-
-	sdio_set_drvdata(func, wl_test);
-
-
-	/* power up the device */
-	ret = wl1271_chip_wakeup(wl);
-	if (ret) {
-		dev_err(&func->dev, "could not wake up chip\n");
-		goto out_free;
-	}
-
-	if (wl->fw == NULL) {
-		ret = wl1271_fetch_firmware(wl);
-		if (ret < 0) {
-			dev_err(&func->dev, "firmware fetch error\n");
-			goto out_off;
-		}
-	}
-
-	/* fetch NVS */
-	if (wl->nvs == NULL) {
-		ret = wl1271_fetch_nvs(wl);
-		if (ret < 0) {
-			dev_err(&func->dev, "NVS fetch error\n");
-			goto out_off;
-		}
-	}
-
-	ret = wl1271_load_firmware(wl);
-	if (ret < 0) {
-		dev_err(&func->dev, "firmware load error: %d\n", ret);
-		goto out_free;
-	}
-
-	dev_info(&func->dev, "initialized\n");
-
-	/* I/O testing will be done in the tester thread */
-
-	wl_test->test_task = kthread_run(tester, wl, "sdio_tester");
-	if (IS_ERR(wl_test->test_task)) {
-		dev_err(&func->dev, "unable to create kernel thread\n");
-		ret = PTR_ERR(wl_test->test_task);
-		goto out_free;
-	}
-
-	return 0;
-
-out_off:
-	/* power off the chip */
-	wl1271_power_off(wl);
-
-out_free:
-	kfree(wl_test);
-	return ret;
-}
-
-static void __devexit wl1271_remove(struct sdio_func *func)
-{
-	struct wl1271_test *wl_test = sdio_get_drvdata(func);
-
-	/* stop the I/O test thread */
-	kthread_stop(wl_test->test_task);
-
-	/* power off the chip */
-	wl1271_power_off(&wl_test->wl);
-
-	vfree(wl_test->wl.fw);
-	wl_test->wl.fw = NULL;
-	kfree(wl_test->wl.nvs);
-	wl_test->wl.nvs = NULL;
-
-	kfree(wl_test);
-}
-
-static struct sdio_driver wl1271_sdio_driver = {
-	.name		= "wl1271_sdio_test",
-	.id_table	= wl1271_devices,
-	.probe		= wl1271_probe,
-	.remove		= __devexit_p(wl1271_remove),
-};
-
-static int __init wl1271_init(void)
-{
-	int ret;
-
-	ret = sdio_register_driver(&wl1271_sdio_driver);
-	if (ret < 0)
-		pr_err("failed to register sdio driver: %d\n", ret);
-
-	return ret;
-}
-module_init(wl1271_init);
-
-static void __exit wl1271_exit(void)
-{
-	sdio_unregister_driver(&wl1271_sdio_driver);
-}
-module_exit(wl1271_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Roger Quadros <roger.quadros@nokia.com>");
-
-- 
1.7.0.4

