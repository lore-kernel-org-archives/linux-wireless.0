Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3507 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZERSKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 14:10:18 -0400
Date: Mon, 18 May 2009 14:09:57 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@iki.fi
Subject: [WIP PATCH] sdio support for wl12xx
Message-ID: <20090518180957.GD2580@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here's a VERY rough patch containing SDIO support for wl12xx, not
yet for applying.  However, it does load (with the proper setup code)
on my Android dev phone, chip probe works, and probably the rest too,
though I didn't get that far.  This also splits out spi driver so
we have wl12xx.ko (core) and wl12xx_spi/_sdio.

A big thanks to the Nokia engineers for making this as easy as inserting
an io ops structure and shuffling some code around.  The actual SDIO
read/write bits are largely identical to TI/Google's own GPLed driver,
though I plan to rework them a bit before submitting this (see below).

TODO:
 - invoke setup code prior to bus probe (FIXMEs in sdio.c and main.c)
 - do something about sdio read/write functions (kill the loops, drop
   the _direct stuff if possible).
 - use readl/writel where appropriate (will fix endian issues)
---
 drivers/net/wireless/wl12xx/Kconfig  |   22 +++-
 drivers/net/wireless/wl12xx/Makefile |    9 +-
 drivers/net/wireless/wl12xx/acx.c    |    3 +-
 drivers/net/wireless/wl12xx/boot.c   |    3 +-
 drivers/net/wireless/wl12xx/cmd.c    |   11 +-
 drivers/net/wireless/wl12xx/event.c  |    4 +-
 drivers/net/wireless/wl12xx/io.c     |  181 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/io.h     |   58 +++++++
 drivers/net/wireless/wl12xx/main.c   |  175 +++++----------------
 drivers/net/wireless/wl12xx/ps.c     |    3 +-
 drivers/net/wireless/wl12xx/rx.c     |    8 +-
 drivers/net/wireless/wl12xx/sdio.c   |  266 +++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/spi.c    |  286 +++++++++++++++-------------------
 drivers/net/wireless/wl12xx/spi.h    |   34 +----
 drivers/net/wireless/wl12xx/tx.c     |   14 +-
 drivers/net/wireless/wl12xx/wl1251.c |    9 +-
 drivers/net/wireless/wl12xx/wl12xx.h |   18 ++
 17 files changed, 742 insertions(+), 362 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/io.c
 create mode 100644 drivers/net/wireless/wl12xx/io.h
 create mode 100644 drivers/net/wireless/wl12xx/sdio.c

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index a82c4cd..57ffee6 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,6 +1,6 @@
 config WL12XX
 	tristate "TI wl1251/wl1271 support"
-	depends on MAC80211 && WLAN_80211 && SPI_MASTER && GENERIC_HARDIRQS && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211 && GENERIC_HARDIRQS && EXPERIMENTAL
 	select FW_LOADER
 	select CRC7
 	---help---
@@ -9,3 +9,23 @@ config WL12XX
 
 	  If you choose to build a module, it'll be called wl12xx. Say N if
 	  unsure.
+
+config WL12XX_SPI
+	tristate "TI wl1251/wl1271 SPI support"
+	depends on WL12XX && SPI_MASTER
+	---help---
+	  This module adds support for the SPI interface of adapters using
+	  TI wl1251/wl1271 chipsets.
+
+	  If you choose to build a module, it'll be called wl12xx_spi. Say N if
+	  unsure.
+
+config WL12XX_SDIO
+	tristate "TI wl1251/wl1271 SDIO support"
+	depends on WL12XX
+	---help---
+	  This module adds support for the SDIO interface of adapters using
+	  TI wl1251/wl1271 chipsets.
+
+	  If you choose to build a module, it'll be called wl12xx_sdio. Say N if
+	  unsure.
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index d43de27..1053962 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,4 +1,9 @@
-wl12xx-objs		= main.o spi.o event.o tx.o rx.o \
+wl12xx-objs		= main.o event.o tx.o rx.o \
 			  ps.o cmd.o acx.o boot.o init.o wl1251.o \
-			  debugfs.o
+			  debugfs.o io.o
+wl12xx_spi-objs += spi.o
+wl12xx_sdio-objs += sdio.o
+
 obj-$(CONFIG_WL12XX)	+= wl12xx.o
+obj-$(CONFIG_WL12XX_SPI)	+= wl12xx_spi.o
+obj-$(CONFIG_WL12XX_SDIO)	+= wl12xx_sdio.o
diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 1cfd458..c55d6a6 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -2,12 +2,11 @@
 
 #include <linux/module.h>
 #include <linux/crc7.h>
-#include <linux/spi/spi.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
-#include "spi.h"
+#include "cmd.h"
 #include "ps.h"
 
 int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 48ac08c..1878dc5 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -25,7 +25,8 @@
 
 #include "reg.h"
 #include "boot.h"
-#include "spi.h"
+#include "io.h"
+#include "wl12xx.h"
 #include "event.h"
 
 static void wl12xx_boot_enable_interrupts(struct wl12xx *wl)
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index f73ab60..8efdaaf 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -2,12 +2,11 @@
 
 #include <linux/module.h>
 #include <linux/crc7.h>
-#include <linux/spi/spi.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
-#include "spi.h"
+#include "io.h"
 #include "ps.h"
 
 int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len)
@@ -26,7 +25,7 @@ int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len)
 
 	wl12xx_ps_elp_wakeup(wl);
 
-	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, &cmd, cmd_len);
+	wl12xx_mem_write(wl, wl->cmd_box_addr, &cmd, cmd_len);
 
 	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
@@ -77,7 +76,7 @@ int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
 
 		wl12xx_ps_elp_wakeup(wl);
 
-		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+		wl12xx_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
 
 		wl12xx_ps_elp_sleep(wl);
 
@@ -112,7 +111,7 @@ int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 ie_id, u16 ie_len,
 	wl12xx_ps_elp_wakeup(wl);
 
 	/* the interrogate command got in, we can read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, answer,
+	wl12xx_mem_read(wl, wl->cmd_box_addr, answer,
 			    CMDMBOX_HEADER_LEN + ie_len);
 
 	wl12xx_ps_elp_sleep(wl);
@@ -313,7 +312,7 @@ int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, u32 len, void *answer)
 	}
 
 	/* the read command got in, we can now read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, &cmd,
+	wl12xx_mem_read(wl, wl->cmd_box_addr, &cmd,
 			    CMDMBOX_HEADER_LEN + sizeof(mem_cmd));
 
 	if (cmd.status != CMD_STATUS_SUCCESS)
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 99529ca..789666f 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -24,7 +24,7 @@
 
 #include "wl12xx.h"
 #include "reg.h"
-#include "spi.h"
+#include "io.h"
 #include "event.h"
 #include "ps.h"
 
@@ -112,7 +112,7 @@ int wl12xx_event_handle(struct wl12xx *wl, u8 mbox_num)
 		return -EINVAL;
 
 	/* first we read the mbox descriptor */
-	wl12xx_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+	wl12xx_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
 			    sizeof(struct event_mailbox));
 
 	/* process the descriptor */
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
new file mode 100644
index 0000000..ebb8f9e
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -0,0 +1,181 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
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
+#include "wl12xx.h"
+#include "reg.h"
+#include "io.h"
+
+static int wl12xx_translate_reg_addr(struct wl12xx *wl, int addr)
+{
+	/* If the address is lower than REGISTERS_BASE, it means that this is
+	 * a chip-specific register address, so look it up in the registers
+	 * table */
+	if (addr < REGISTERS_BASE) {
+		/* Make sure we don't go over the table */
+		if (addr >= ACX_REG_TABLE_LEN) {
+			wl12xx_error("address out of range (%d)", addr);
+			return -EINVAL;
+		}
+		addr = wl->chip.acx_reg_table[addr];
+	}
+
+	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
+}
+
+static int wl12xx_translate_mem_addr(struct wl12xx *wl, int addr)
+{
+	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
+}
+
+void wl12xx_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int physical;
+
+	physical = wl12xx_translate_mem_addr(wl, addr);
+
+	wl->if_ops->read(wl, physical, buf, len);
+}
+
+void wl12xx_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int physical;
+
+	physical = wl12xx_translate_mem_addr(wl, addr);
+
+	wl->if_ops->write(wl, physical, buf, len);
+}
+
+u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
+{
+	return wl12xx_read32(wl, wl12xx_translate_mem_addr(wl, addr));
+}
+
+void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl12xx_write32(wl, wl12xx_translate_mem_addr(wl, addr), val);
+}
+
+u32 wl12xx_reg_read32(struct wl12xx *wl, int addr)
+{
+	return wl12xx_read32(wl, wl12xx_translate_reg_addr(wl, addr));
+}
+EXPORT_SYMBOL_GPL(wl12xx_reg_read32);
+
+void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
+}
+
+/* Set the SPI/SDIO partitions to access the chip addresses
+ *
+ * There are two VIRTUAL partitions (the memory partition and the
+ * registers partition), which are mapped to two different areas of the
+ * PHYSICAL (hardware) memory.  This function also makes other checks to
+ * ensure that the partitions are not overlapping.  In the diagram below, the
+ * memory partition comes before the register partition, but the opposite is
+ * also supported.
+ *
+ *                               PHYSICAL address
+ *                                     space
+ *
+ *                                    |    |
+ *                                 ...+----+--> mem_start
+ *          VIRTUAL address     ...   |    |
+ *               space       ...      |    | [PART_0]
+ *                        ...         |    |
+ * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
+ *               |    |         ...   |    |
+ *               |MEM |      ...      |    |
+ *               |    |   ...         |    |
+ *  part_size <--+----+...            |    | {unused area)
+ *               |    |   ...         |    |
+ *               |REG |      ...      |    |
+ *  part_size    |    |         ...   |    |
+ *      +     <--+----+...         ...+----+--> reg_start
+ *  reg_size              ...         |    |
+ *                           ...      |    | [PART_1]
+ *                              ...   |    |
+ *                                 ...+----+--> reg_start + reg_size
+ *                                    |    |
+ *
+ */
+void wl12xx_set_partition(struct wl12xx *wl,
+			  u32 mem_start, u32 mem_size,
+			  u32 reg_start, u32 reg_size)
+{
+	struct wl12xx_partition partition[2];
+
+	wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		     mem_start, mem_size);
+	wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		     reg_start, reg_size);
+
+	/* Make sure that the two partitions together don't exceed the
+	 * address range */
+	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
+		wl12xx_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
+			     " address range.  Truncating partition[0].");
+		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	if ((mem_start < reg_start) &&
+	    ((mem_start + mem_size) > reg_start)) {
+		/* Guarantee that the memory partition doesn't overlap the
+		 * registers partition */
+		wl12xx_debug(DEBUG_SPI, "End of partition[0] is "
+			     "overlapping partition[1].  Adjusted.");
+		mem_size = reg_start - mem_start;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	} else if ((reg_start < mem_start) &&
+		   ((reg_start + reg_size) > mem_start)) {
+		/* Guarantee that the register partition doesn't overlap the
+		 * memory partition */
+		wl12xx_debug(DEBUG_SPI, "End of partition[1] is"
+			     " overlapping partition[0].  Adjusted.");
+		reg_size = mem_start - reg_start;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	partition[0].start = mem_start;
+	partition[0].size  = mem_size;
+	partition[1].start = reg_start;
+	partition[1].size  = reg_size;
+
+	wl->physical_mem_addr = mem_start;
+	wl->physical_reg_addr = reg_start;
+
+	wl->virtual_mem_addr = 0;
+	wl->virtual_reg_addr = mem_size;
+
+	wl->if_ops->write(wl, HW_ACCESS_PART0_SIZE_ADDR, partition,
+		2 * sizeof(struct wl12xx_partition));
+}
+EXPORT_SYMBOL_GPL(wl12xx_set_partition);
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
new file mode 100644
index 0000000..2ddf4a1
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -0,0 +1,58 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
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
+#ifndef __WL12XX_IO_H__
+#define __WL12XX_IO_H__
+
+#include "wl12xx.h"
+
+#define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
+
+#define HW_ACCESS_PART0_SIZE_ADDR           0x1FFC0
+#define HW_ACCESS_PART0_START_ADDR          0x1FFC4
+#define HW_ACCESS_PART1_SIZE_ADDR           0x1FFC8
+#define HW_ACCESS_PART1_START_ADDR          0x1FFCC
+
+#define HW_ACCESS_REGISTER_SIZE             4
+
+#define HW_ACCESS_PRAM_MAX_RANGE		0x3c000
+
+
+static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
+{
+	u32 response;
+	wl->if_ops->read(wl, addr, &response, sizeof(u32));
+	return response;
+}
+
+static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl->if_ops->write(wl, addr, &val, sizeof(u32));
+}
+
+void wl12xx_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len);
+u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
+void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
+u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
+void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..bc8d4b1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -26,16 +26,15 @@
 #include <linux/firmware.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
-#include <linux/spi/spi.h>
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
-#include <linux/spi/wl12xx.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251.h"
-#include "spi.h"
+#include "io.h"
+#include "cmd.h"
 #include "event.h"
 #include "tx.h"
 #include "rx.h"
@@ -58,7 +57,7 @@ static void wl12xx_power_on(struct wl12xx *wl)
 	wl->set_power(true);
 }
 
-static irqreturn_t wl12xx_irq(int irq, void *cookie)
+irqreturn_t wl12xx_irq(int irq, void *cookie)
 {
 	struct wl12xx *wl;
 
@@ -70,13 +69,14 @@ static irqreturn_t wl12xx_irq(int irq, void *cookie)
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(wl12xx_irq);
 
 static int wl12xx_fetch_firmware(struct wl12xx *wl)
 {
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.fw_filename, &wl->spi->dev);
+	ret = request_firmware(&fw, wl->chip.fw_filename, wl->dev);
 
 	if (ret < 0) {
 		wl12xx_error("could not get firmware: %d", ret);
@@ -114,7 +114,7 @@ static int wl12xx_fetch_nvs(struct wl12xx *wl)
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.nvs_filename, &wl->spi->dev);
+	ret = request_firmware(&fw, wl->chip.nvs_filename, wl->dev);
 
 	if (ret < 0) {
 		wl12xx_error("could not get nvs file: %d", ret);
@@ -147,7 +147,7 @@ out:
 	return ret;
 }
 
-static void wl12xx_fw_wakeup(struct wl12xx *wl)
+void wl12xx_fw_wakeup(struct wl12xx *wl)
 {
 	u32 elp_reg;
 
@@ -161,15 +161,18 @@ static void wl12xx_fw_wakeup(struct wl12xx *wl)
 		wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
 	}
 }
+EXPORT_SYMBOL_GPL(wl12xx_fw_wakeup);
 
 static int wl12xx_chip_wakeup(struct wl12xx *wl)
 {
 	int ret = 0;
 
+#ifdef FIXME_SPI_CODE
 	wl12xx_power_on(wl);
 	msleep(wl->chip.power_on_sleep);
 	wl12xx_spi_reset(wl);
-	wl12xx_spi_init(wl);
+	wl12xx_spi_wake(wl);
+#endif
 
 	/* We don't need a real memory partition here, because we only want
 	 * to use the registers at this point. */
@@ -223,7 +226,7 @@ out:
 	return ret;
 }
 
-static void wl12xx_filter_work(struct work_struct *work)
+void wl12xx_filter_work(struct work_struct *work)
 {
 	struct wl12xx *wl =
 		container_of(work, struct wl12xx, filter_work);
@@ -885,7 +888,7 @@ static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
 	if (ret < 0)
 		wl12xx_error("SCAN failed");
 
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
+	wl12xx_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
 
 	cmd_answer = (struct wl12xx_command *) params;
 	if (cmd_answer->status != CMD_STATUS_SUCCESS) {
@@ -1126,7 +1129,7 @@ static const struct ieee80211_ops wl12xx_ops = {
 	.set_rts_threshold = wl12xx_op_set_rts_threshold,
 };
 
-static int wl12xx_register_hw(struct wl12xx *wl)
+int wl12xx_register_hw(struct wl12xx *wl)
 {
 	int ret;
 
@@ -1148,8 +1151,10 @@ static int wl12xx_register_hw(struct wl12xx *wl)
 	return 0;
 }
 
-static int wl12xx_init_ieee80211(struct wl12xx *wl)
+int wl12xx_init_ieee80211(struct wl12xx *wl)
 {
+	int ret;
+
 	/* The tx descriptor buffer and the TKIP space */
 	wl->hw->extra_tx_headroom = sizeof(struct tx_double_buffer_desc)
 		+ WL12XX_TKIP_IV_SPACE;
@@ -1165,38 +1170,40 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl12xx_band_2ghz;
 
-	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
+	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
-	return 0;
+	ret = wl12xx_register_hw(wl);
+	if (ret)
+		goto out;
+
+	wl12xx_debugfs_init(wl);
+
+	wl12xx_notice("initialized");
+
+	ret = 0;
+out:
+	return ret;
 }
+EXPORT_SYMBOL_GPL(wl12xx_init_ieee80211);
 
 #define WL12XX_DEFAULT_CHANNEL 1
-static int __devinit wl12xx_probe(struct spi_device *spi)
+struct ieee80211_hw *wl12xx_alloc_hw(void)
 {
-	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
 	struct wl12xx *wl;
-	int ret, i;
+	int i;
 	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
-	pdata = spi->dev.platform_data;
-	if (!pdata) {
-		wl12xx_error("no platform data");
-		return -ENODEV;
-	}
-
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl12xx_ops);
 	if (!hw) {
 		wl12xx_error("could not alloc ieee80211_hw");
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	wl = hw->priv;
 	memset(wl, 0, sizeof(*wl));
 
 	wl->hw = hw;
-	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
 
 	wl->data_in_count = 0;
 
@@ -1242,117 +1249,11 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	wl->tx_mgmt_frm_rate = DEFAULT_HW_GEN_TX_RATE;
 	wl->tx_mgmt_frm_mod = DEFAULT_HW_GEN_MODULATION_TYPE;
 
-	/* This is the only SPI value that we need to set here, the rest
-	 * comes from the board-peripherals file */
-	spi->bits_per_word = 32;
-
-	ret = spi_setup(spi);
-	if (ret < 0) {
-		wl12xx_error("spi_setup failed");
-		goto out_free;
-	}
-
-	wl->set_power = pdata->set_power;
-	if (!wl->set_power) {
-		wl12xx_error("set power function missing in platform data");
-		return -ENODEV;
-	}
-
-	wl->irq = spi->irq;
-	if (wl->irq < 0) {
-		wl12xx_error("irq missing in platform data");
-		return -ENODEV;
-	}
-
-	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);
-	if (ret < 0) {
-		wl12xx_error("request_irq() failed: %d", ret);
-		goto out_free;
-	}
-
-	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-
-	disable_irq(wl->irq);
-
-	ret = wl12xx_init_ieee80211(wl);
-	if (ret)
-		goto out_irq;
-
-	ret = wl12xx_register_hw(wl);
-	if (ret)
-		goto out_irq;
-
-	wl12xx_debugfs_init(wl);
-
-	wl12xx_notice("initialized");
-
-	return 0;
-
- out_irq:
-	free_irq(wl->irq, wl);
-
- out_free:
-	ieee80211_free_hw(hw);
-
-	return ret;
-}
-
-static int __devexit wl12xx_remove(struct spi_device *spi)
-{
-	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
-
-	ieee80211_unregister_hw(wl->hw);
-
-	wl12xx_debugfs_exit(wl);
-
-	free_irq(wl->irq, wl);
-	kfree(wl->target_mem_map);
-	kfree(wl->data_path);
-	kfree(wl->fw);
-	wl->fw = NULL;
-	kfree(wl->nvs);
-	wl->nvs = NULL;
-	ieee80211_free_hw(wl->hw);
-
-	return 0;
-}
-
-
-static struct spi_driver wl12xx_spi_driver = {
-	.driver = {
-		.name		= "wl12xx",
-		.bus		= &spi_bus_type,
-		.owner		= THIS_MODULE,
-	},
-
-	.probe		= wl12xx_probe,
-	.remove		= __devexit_p(wl12xx_remove),
-};
-
-static int __init wl12xx_init(void)
-{
-	int ret;
-
-	ret = spi_register_driver(&wl12xx_spi_driver);
-	if (ret < 0) {
-		wl12xx_error("failed to register spi driver: %d", ret);
-		goto out;
-	}
-
-out:
-	return ret;
+	return hw;
 }
+EXPORT_SYMBOL_GPL(wl12xx_alloc_hw);
 
-static void __exit wl12xx_exit(void)
-{
-	spi_unregister_driver(&wl12xx_spi_driver);
-
-	wl12xx_notice("unloaded");
-}
-
-module_init(wl12xx_init);
-module_exit(wl12xx_exit);
-
+MODULE_DESCRIPTION("TI 12xx Wireless LAN Driver");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
-		"Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 83a1011..f2de45b 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -23,7 +23,8 @@
 
 #include "reg.h"
 #include "ps.h"
-#include "spi.h"
+#include "cmd.h"
+#include "io.h"
 
 #define WL12XX_WAKEUP_TIMEOUT 2000
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 981ea25..044c330 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -27,8 +27,10 @@
 
 #include "wl12xx.h"
 #include "reg.h"
-#include "spi.h"
+#include "io.h"
 #include "rx.h"
+#include "cmd.h"
+#include "acx.h"
 
 static void wl12xx_rx_header(struct wl12xx *wl,
 			     struct wl12xx_rx_descriptor *desc)
@@ -39,7 +41,7 @@ static void wl12xx_rx_header(struct wl12xx *wl,
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, desc,
+	wl12xx_mem_read(wl, rx_packet_ring_addr, desc,
 			    sizeof(struct wl12xx_rx_descriptor));
 }
 
@@ -151,7 +153,7 @@ static void wl12xx_rx_body(struct wl12xx *wl,
 	}
 
 	rx_buffer = skb_put(skb, length);
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
+	wl12xx_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
 
 	/* The actual lenght doesn't include the target's alignment */
 	skb->len = desc->length  - PLCP_HEADER_LENGTH;
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
new file mode 100644
index 0000000..043b585
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -0,0 +1,266 @@
+/*
+ * wl12xx SDIO routines
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+ * Copyright (C) 2005 Texas Instruments Incorporated
+ * Copyright (C) 2008 Google Inc
+ * Copyright (C) 2009 Bob Copeland (me@bobcopeland.com)
+ */
+#include <linux/module.h>
+#include <linux/crc7.h>
+#include <linux/mod_devicetable.h>
+#include <linux/irq.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/platform_device.h>
+
+#include "wl12xx.h"
+#include "wl12xx_80211.h"
+#include "reg.h"
+#include "ps.h"
+#include "io.h"
+#include "tx.h"
+#include "debugfs.h"
+
+#define SDIO_VENDOR_ID_TI		0x104c
+#define SDIO_DEVICE_ID_WL1251		0x9066 
+
+void wl12xx_sdio_interrupt(struct sdio_func *func)
+{
+	wl12xx_irq(0, sdio_get_drvdata(func));
+}
+
+/* FIXME do this wifi_xxxx platform setup code differently */
+#if 0
+#include <linux/wifi_tiwlan.h>
+static int wifi_probe(struct platform_device *pdev)
+{
+	struct wifi_platform_data *wifi_ctrl = 
+		(struct wifi_platform_data *)(pdev->dev.platform_data);
+
+	if(wifi_ctrl) {
+		if(wifi_ctrl->set_power)
+			wifi_ctrl->set_power(1);	/* Power On */
+		if(wifi_ctrl->set_reset)
+			wifi_ctrl->set_reset(0);	/* Reset clear */
+		if(wifi_ctrl->set_carddetect)
+			wifi_ctrl->set_carddetect(1);	/* CardDetect (0->1) */
+	}
+	return 0;
+}
+
+static int wifi_remove(struct platform_device *pdev)
+{
+	struct wifi_platform_data *wifi_ctrl = 
+		(struct wifi_platform_data *)(pdev->dev.platform_data);
+
+	if(wifi_ctrl) {
+		if(wifi_ctrl->set_carddetect)
+			wifi_ctrl->set_carddetect(0);	/* CardDetect (1->0) */
+		if(wifi_ctrl->set_reset)
+			wifi_ctrl->set_reset(1);	/* Reset active */
+ 		if(wifi_ctrl->set_power)
+			wifi_ctrl->set_power(0);	/* Power Off */
+	}
+	return 0;
+}
+
+static struct platform_driver wifi_device = {
+	.probe		= wifi_probe,
+	.remove		= wifi_remove,
+	.driver		= {
+		.name   = "msm_wifi",
+	},
+};
+
+static int wifi_add_dev(void)
+{
+	return platform_driver_register(&wifi_device);
+}
+
+static void wifi_del_dev(void)
+{
+	platform_driver_unregister(&wifi_device);
+}
+/* end platform specific code */
+#else
+static int wifi_add_dev(void)
+{
+	return 0;
+}
+
+static void wifi_del_dev(void)
+{
+}
+#endif
+
+static const struct sdio_device_id wl12xx_devices[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_WL1251) },
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, wl12xx_devices);
+
+
+static int read_direct(struct sdio_func *func, unsigned char *buf, 
+                            unsigned long addr, unsigned len)
+{
+	unsigned i;
+	int rc0, rc = 0;
+
+	for(i=0; i < len; i++,addr++) {
+		*buf++ = (unsigned char)sdio_readb(func, addr, &rc0);
+		if (rc0)
+			rc = rc0;
+	}
+	return rc;
+}
+
+static int write_direct(struct sdio_func *func, unsigned long addr,
+			unsigned char *buf, unsigned len)
+{
+	unsigned i;
+	int rc0, rc = 0;
+
+	for(i=0; i < len; i++,addr++) {
+		sdio_writeb(func, *buf++, addr, &rc0);
+		if (rc0)
+			rc = rc0;
+	}
+	return rc;
+}
+
+void wl12xx_sdio_read(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int ret, i;
+	for (i=0; i < 5; i++) {
+		if (i < 2)
+			ret = read_direct(wl->func, buf, addr, len);
+		else
+			ret = sdio_memcpy_fromio(wl->func, buf, addr, len);
+
+		if (!ret)
+			break;
+	}
+}
+
+void wl12xx_sdio_write(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int ret, i;
+	for (i=0; i < 5; i++) {
+		if (i < 2)
+			ret = write_direct(wl->func, addr, buf, len);
+		else
+			ret = sdio_memcpy_toio(wl->func, addr, buf, len);
+
+		if (!ret)
+			break;
+	}
+}
+
+struct wl12xx_if_operations wl12xx_sdio_ops = {
+	.read = wl12xx_sdio_read,
+	.write = wl12xx_sdio_write,
+};
+
+int wl12xx_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
+{
+	int ret;
+	struct wl12xx *wl;
+	struct ieee80211_hw *hw;
+
+	printk(KERN_INFO "wl12xx: in probe\n");
+
+	hw = wl12xx_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
+
+	wl = hw->priv;
+
+	sdio_claim_host(func);
+	ret = sdio_enable_func(func);
+	if (ret)
+		goto release;
+
+	sdio_set_block_size(func, 512);
+
+	wl->func = func;
+	wl->dev = &func->dev;
+	wl->if_ops = &wl12xx_sdio_ops;
+
+	ret = wl12xx_init_ieee80211(wl);
+	if (ret)
+		goto disable;
+
+	/* XXX: error handling */
+	ret = sdio_claim_irq(func, wl12xx_sdio_interrupt);
+	if (ret)
+		goto disable;
+
+	sdio_release_host(func);
+	sdio_set_drvdata(func, wl);
+	return ret;
+
+disable:
+	sdio_disable_func(func);
+release:
+	sdio_release_host(func);
+	return ret;
+}
+
+void wl12xx_sdio_remove(struct sdio_func *func)
+{
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	sdio_disable_func(func);
+	sdio_release_host(func);
+}
+
+static struct sdio_driver wl12xx_sdio_driver = {
+	.name		= "wl12xx_sdio",
+	.id_table	= wl12xx_devices,
+	.probe		= wl12xx_sdio_probe,
+	.remove		= wl12xx_sdio_remove,
+};
+
+static int __init wl12xx_sdio_init(void)
+{
+	int ret;
+
+	printk(KERN_INFO "wl12xx: registering driver\n");
+	wifi_add_dev();
+	ret = sdio_register_driver(&wl12xx_sdio_driver);
+	if (ret < 0) {
+		wl12xx_error("failed to register sdio driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit wl12xx_sdio_exit(void)
+{
+	wifi_del_dev();
+	sdio_unregister_driver(&wl12xx_sdio_driver);
+	wl12xx_notice("unloaded");
+}
+
+module_init(wl12xx_sdio_init);
+module_exit(wl12xx_sdio_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index abdf171..5c6ad61 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -24,35 +24,16 @@
 #include <linux/module.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
+#include <linux/irq.h>
+#include <linux/spi/wl12xx.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "spi.h"
 #include "ps.h"
-
-static int wl12xx_translate_reg_addr(struct wl12xx *wl, int addr)
-{
-	/* If the address is lower than REGISTERS_BASE, it means that this is
-	 * a chip-specific register address, so look it up in the registers
-	 * table */
-	if (addr < REGISTERS_BASE) {
-		/* Make sure we don't go over the table */
-		if (addr >= ACX_REG_TABLE_LEN) {
-			wl12xx_error("address out of range (%d)", addr);
-			return -EINVAL;
-		}
-		addr = wl->chip.acx_reg_table[addr];
-	}
-
-	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
-}
-
-static int wl12xx_translate_mem_addr(struct wl12xx *wl, int addr)
-{
-	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
-}
-
+#include "tx.h"
+#include "debugfs.h"
 
 void wl12xx_spi_reset(struct wl12xx *wl)
 {
@@ -80,7 +61,7 @@ void wl12xx_spi_reset(struct wl12xx *wl)
 	wl12xx_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-void wl12xx_spi_init(struct wl12xx *wl)
+void wl12xx_spi_wake(struct wl12xx *wl)
 {
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
@@ -134,123 +115,6 @@ void wl12xx_spi_init(struct wl12xx *wl)
 	wl12xx_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-/* Set the SPI partitions to access the chip addresses
- *
- * There are two VIRTUAL (SPI) partitions (the memory partition and the
- * registers partition), which are mapped to two different areas of the
- * PHYSICAL (hardware) memory.  This function also makes other checks to
- * ensure that the partitions are not overlapping.  In the diagram below, the
- * memory partition comes before the register partition, but the opposite is
- * also supported.
- *
- *                               PHYSICAL address
- *                                     space
- *
- *                                    |    |
- *                                 ...+----+--> mem_start
- *          VIRTUAL address     ...   |    |
- *               space       ...      |    | [PART_0]
- *                        ...         |    |
- * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
- *               |    |         ...   |    |
- *               |MEM |      ...      |    |
- *               |    |   ...         |    |
- *  part_size <--+----+...            |    | {unused area)
- *               |    |   ...         |    |
- *               |REG |      ...      |    |
- *  part_size    |    |         ...   |    |
- *      +     <--+----+...         ...+----+--> reg_start
- *  reg_size              ...         |    |
- *                           ...      |    | [PART_1]
- *                              ...   |    |
- *                                 ...+----+--> reg_start + reg_size
- *                                    |    |
- *
- */
-void wl12xx_set_partition(struct wl12xx *wl,
-			  u32 mem_start, u32 mem_size,
-			  u32 reg_start, u32 reg_size)
-{
-	u8 tx_buf[sizeof(u32) + 2 * sizeof(struct wl12xx_partition)];
-	struct wl12xx_partition *partition;
-	struct spi_transfer t;
-	struct spi_message m;
-	u32 *cmd;
-	size_t len;
-	int addr;
-
-	spi_message_init(&m);
-	memset(&t, 0, sizeof(t));
-	memset(tx_buf, 0, sizeof(tx_buf));
-
-	cmd = (u32 *) tx_buf;
-	partition = (struct wl12xx_partition *) (tx_buf + sizeof(u32));
-	addr = HW_ACCESS_PART0_SIZE_ADDR;
-	len = 2 * sizeof(struct wl12xx_partition);
-
-	*cmd |= WSPI_CMD_WRITE;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
-
-	wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-		     mem_start, mem_size);
-	wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-		     reg_start, reg_size);
-
-	/* Make sure that the two partitions together don't exceed the
-	 * address range */
-	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
-		wl12xx_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
-			     " address range.  Truncating partition[0].");
-		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	if ((mem_start < reg_start) &&
-	    ((mem_start + mem_size) > reg_start)) {
-		/* Guarantee that the memory partition doesn't overlap the
-		 * registers partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[0] is "
-			     "overlapping partition[1].  Adjusted.");
-		mem_size = reg_start - mem_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	} else if ((reg_start < mem_start) &&
-		   ((reg_start + reg_size) > mem_start)) {
-		/* Guarantee that the register partition doesn't overlap the
-		 * memory partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[1] is"
-			     " overlapping partition[0].  Adjusted.");
-		reg_size = mem_start - reg_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	partition[0].start = mem_start;
-	partition[0].size  = mem_size;
-	partition[1].start = reg_start;
-	partition[1].size  = reg_size;
-
-	wl->physical_mem_addr = mem_start;
-	wl->physical_reg_addr = reg_start;
-
-	wl->virtual_mem_addr = 0;
-	wl->virtual_reg_addr = mem_size;
-
-	t.tx_buf = tx_buf;
-	t.len = sizeof(tx_buf);
-	spi_message_add_tail(&t, &m);
-
-	spi_sync(wl->spi, &m);
-}
-
 void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 		     size_t len)
 {
@@ -317,42 +181,138 @@ void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
 
-void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf,
-			 size_t len)
+struct wl12xx_if_operations wl12xx_spi_ops = 
 {
-	int physical;
+	.read = wl12xx_spi_read,
+	.write = wl12xx_spi_write,
+};
 
-	physical = wl12xx_translate_mem_addr(wl, addr);
+#define WL12XX_DEFAULT_CHANNEL 1
+static int __devinit wl12xx_spi_probe(struct spi_device *spi)
+{
+	struct wl12xx_platform_data *pdata;
+	struct ieee80211_hw *hw;
+	struct wl12xx *wl;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata) {
+		wl12xx_error("no platform data");
+		return -ENODEV;
+	}
 
-	wl12xx_spi_read(wl, physical, buf, len);
-}
+	hw = wl12xx_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
 
-void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
-			  size_t len)
-{
-	int physical;
+	wl = hw->priv;
+	dev_set_drvdata(&spi->dev, wl);
+	wl->spi = spi;
+	wl->dev = &spi->dev;
+	wl->if_ops = &wl12xx_spi_ops;
 
-	physical = wl12xx_translate_mem_addr(wl, addr);
+	/* This is the only SPI value that we need to set here, the rest
+	 * comes from the board-peripherals file */
+	spi->bits_per_word = 32;
 
-	wl12xx_spi_write(wl, physical, buf, len);
-}
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		wl12xx_error("spi_setup failed");
+		goto out_free;
+	}
 
-u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
-{
-	return wl12xx_read32(wl, wl12xx_translate_mem_addr(wl, addr));
+	wl->set_power = pdata->set_power;
+	if (!wl->set_power) {
+		wl12xx_error("set power function missing in platform data");
+		return -ENODEV;
+	}
+
+	wl->irq = spi->irq;
+	if (wl->irq < 0) {
+		wl12xx_error("irq missing in platform data");
+		return -ENODEV;
+	}
+
+	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);
+	if (ret < 0) {
+		wl12xx_error("request_irq() failed: %d", ret);
+		goto out_free;
+	}
+
+	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+
+	disable_irq(wl->irq);
+
+	ret = wl12xx_init_ieee80211(wl);
+	if (ret)
+		goto out_irq;
+
+	return 0;
+
+ out_irq:
+	free_irq(wl->irq, wl);
+
+ out_free:
+	ieee80211_free_hw(hw);
+
+	return ret;
 }
 
-void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val)
+static int __devexit wl12xx_spi_remove(struct spi_device *spi)
 {
-	wl12xx_write32(wl, wl12xx_translate_mem_addr(wl, addr), val);
+	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
+
+	ieee80211_unregister_hw(wl->hw);
+
+	wl12xx_debugfs_exit(wl);
+
+	free_irq(wl->irq, wl);
+	kfree(wl->target_mem_map);
+	kfree(wl->data_path);
+	kfree(wl->fw);
+	wl->fw = NULL;
+	kfree(wl->nvs);
+	wl->nvs = NULL;
+	ieee80211_free_hw(wl->hw);
+
+	return 0;
 }
 
-u32 wl12xx_reg_read32(struct wl12xx *wl, int addr)
+static struct spi_driver wl12xx_spi_driver = {
+	.driver = {
+		.name		= "wl12xx",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= wl12xx_spi_probe,
+	.remove		= __devexit_p(wl12xx_spi_remove),
+};
+
+static int __init wl12xx_spi_init(void)
 {
-	return wl12xx_read32(wl, wl12xx_translate_reg_addr(wl, addr));
+	int ret;
+
+	ret = spi_register_driver(&wl12xx_spi_driver);
+	if (ret < 0) {
+		wl12xx_error("failed to register spi driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
 }
 
-void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
+static void __exit wl12xx_spi_exit(void)
 {
-	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
+	spi_unregister_driver(&wl12xx_spi_driver);
+
+	wl12xx_notice("unloaded");
 }
+
+module_init(wl12xx_spi_init);
+module_exit(wl12xx_spi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index fd3227e..afb5757 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -71,39 +71,7 @@
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
 
-/* Raw target IO, address is not translated */
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf, size_t len);
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf, size_t len);
-
-/* Memory target IO, address is tranlated to partition 0 */
-void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len);
-void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len);
-u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
-void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
-
-/* Registers IO */
-u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
-void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
-
 /* INIT and RESET words */
 void wl12xx_spi_reset(struct wl12xx *wl);
-void wl12xx_spi_init(struct wl12xx *wl);
-void wl12xx_set_partition(struct wl12xx *wl,
-			  u32 part_start, u32 part_size,
-			  u32 reg_start,  u32 reg_size);
-
-static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
-{
-	u32 response;
-
-	wl12xx_spi_read(wl, addr, &response, sizeof(u32));
-
-	return response;
-}
-
-static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
-{
-	wl12xx_spi_write(wl, addr, &val, sizeof(u32));
-}
-
+void wl12xx_spi_wake(struct wl12xx *wl);
 #endif /* __WL12XX_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 62145e2..68cf366 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -27,7 +27,7 @@
 
 #include "wl12xx.h"
 #include "reg.h"
-#include "spi.h"
+#include "io.h"
 #include "tx.h"
 #include "ps.h"
 
@@ -235,7 +235,7 @@ static int wl12xx_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
 	else
 		addr = wl->data_path->tx_packet_ring_addr;
 
-	wl12xx_spi_mem_write(wl, addr, skb->data, len);
+	wl12xx_mem_write(wl, addr, skb->data, len);
 
 	wl12xx_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
 		     tx_hdr->id, skb, tx_hdr->length, tx_hdr->rate);
@@ -449,7 +449,7 @@ void wl12xx_tx_complete(struct wl12xx *wl)
 		return;
 
 	/* First we read the result */
-	wl12xx_spi_mem_read(wl, wl->data_path->tx_complete_addr,
+	wl12xx_mem_read(wl, wl->data_path->tx_complete_addr,
 			    result, sizeof(result));
 
 	result_index = wl->next_tx_complete;
@@ -480,7 +480,7 @@ void wl12xx_tx_complete(struct wl12xx *wl)
 		 */
 		if (result_index > wl->next_tx_complete) {
 			/* Only 1 write is needed */
-			wl12xx_spi_mem_write(wl,
+			wl12xx_mem_write(wl,
 					     wl->data_path->tx_complete_addr +
 					     (wl->next_tx_complete *
 					      sizeof(struct tx_result)),
@@ -491,7 +491,7 @@ void wl12xx_tx_complete(struct wl12xx *wl)
 
 		} else if (result_index < wl->next_tx_complete) {
 			/* 2 writes are needed */
-			wl12xx_spi_mem_write(wl,
+			wl12xx_mem_write(wl,
 					     wl->data_path->tx_complete_addr +
 					     (wl->next_tx_complete *
 					      sizeof(struct tx_result)),
@@ -500,7 +500,7 @@ void wl12xx_tx_complete(struct wl12xx *wl)
 					      wl->next_tx_complete) *
 					     sizeof(struct tx_result));
 
-			wl12xx_spi_mem_write(wl,
+			wl12xx_mem_write(wl,
 					     wl->data_path->tx_complete_addr,
 					     result,
 					     (num_complete -
@@ -510,7 +510,7 @@ void wl12xx_tx_complete(struct wl12xx *wl)
 
 		} else {
 			/* We have to write the whole array */
-			wl12xx_spi_mem_write(wl,
+			wl12xx_mem_write(wl,
 					     wl->data_path->tx_complete_addr,
 					     result,
 					     FW_TX_CMPLT_BLOCK_SIZE *
diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index ce1561a..95993dc 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -26,13 +26,14 @@
 
 #include "wl1251.h"
 #include "reg.h"
-#include "spi.h"
+#include "io.h"
 #include "boot.h"
 #include "event.h"
 #include "acx.h"
 #include "tx.h"
 #include "rx.h"
 #include "ps.h"
+#include "cmd.h"
 #include "init.h"
 
 static struct wl12xx_partition_set wl1251_part_table[PART_TABLE_LEN] = {
@@ -130,7 +131,7 @@ static int wl1251_upload_firmware(struct wl12xx *wl)
 		p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
 		wl12xx_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl12xx_spi_mem_write(wl, addr, p, CHUNK_SIZE);
+		wl12xx_mem_write(wl, addr, p, CHUNK_SIZE);
 
 		chunk_num++;
 	}
@@ -140,7 +141,7 @@ static int wl1251_upload_firmware(struct wl12xx *wl)
 	p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
 	wl12xx_debug(DEBUG_BOOT, "uploading fw last chunk (%zu B) 0x%p to 0x%x",
 		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl12xx_spi_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
+	wl12xx_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
 
 	return 0;
 }
@@ -412,7 +413,7 @@ static void wl1251_irq_work(struct work_struct *work)
 	wl12xx_debug(DEBUG_IRQ, "intr: 0x%x", intr);
 
 	if (wl->data_path) {
-		wl12xx_spi_mem_read(wl, wl->data_path->rx_control_addr,
+		wl12xx_mem_read(wl, wl->data_path->rx_control_addr,
 				    &wl->rx_counter, sizeof(u32));
 
 		/* We handle a frmware bug here */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4864143..7d331ba 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -276,11 +276,19 @@ struct wl12xx_debugfs {
 	struct dentry *excessive_retries;
 };
 
+struct wl12xx_if_operations {
+	void (*read)(struct wl12xx *, int addr, void *buf, size_t len);
+	void (*write)(struct wl12xx *, int addr, void *buf, size_t len);
+};
+
 struct wl12xx {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
+	struct sdio_func *func;
 	struct spi_device *spi;
+	struct device *dev;
+	struct wl12xx_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
 	int irq;
@@ -387,6 +395,16 @@ struct wl12xx {
 int wl12xx_plt_start(struct wl12xx *wl);
 int wl12xx_plt_stop(struct wl12xx *wl);
 
+irqreturn_t wl12xx_irq(int irq, void *cookie);
+struct ieee80211_hw *wl12xx_alloc_hw(void);
+int wl12xx_register_hw(struct wl12xx *wl);
+int wl12xx_init_ieee80211(struct wl12xx *wl);
+void wl12xx_filter_work(struct work_struct *work);
+void wl12xx_fw_wakeup(struct wl12xx *wl);
+void wl12xx_set_partition(struct wl12xx *wl,
+			  u32 part_start, u32 part_size,
+			  u32 reg_start,  u32 reg_size);
+
 #define DEFAULT_HW_GEN_MODULATION_TYPE    CCK_LONG /* Long Preamble */
 #define DEFAULT_HW_GEN_TX_RATE          RATE_2MBPS
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

