Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50811 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab0BRL2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:40 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 19/22] wl1271: Moved common IO functions from wl271_spi.c to wl1271_io.c
Date: Thu, 18 Feb 2010 13:25:54 +0200
Message-Id: <1266492357-462-20-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

In prepraration for integration of SDIO implementation moved some IO
functions common for SPI and SDIO to separate file.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/Makefile     |    3 +-
 drivers/net/wireless/wl12xx/wl1271_io.c  |  203 ++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_io.h  |   37 ++++++
 drivers/net/wireless/wl12xx/wl1271_spi.c |  157 -----------------------
 4 files changed, 242 insertions(+), 158 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_io.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_io.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index d089b5d..f47ec94 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
 wl1271-objs		= wl1271_main.o  wl1271_spi.o wl1271_cmd.o  \
 			  wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
 			  wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
-			  wl1271_init.o  wl1271_debugfs.o
+			  wl1271_init.o  wl1271_debugfs.o wl1271_io.o
+
 wl1271-$(CONFIG_NL80211_TESTMODE)	+= wl1271_testmode.o
 obj-$(CONFIG_WL1271)	+= wl1271.o
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/wl1271_io.c
new file mode 100644
index 0000000..dcb588b
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_io.c
@@ -0,0 +1,203 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2010 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/crc7.h>
+#include <linux/spi/spi.h>
+
+#include "wl1271.h"
+#include "wl12xx_80211.h"
+#include "wl1271_spi.h"
+#include "wl1271_io.h"
+
+static int wl1271_translate_addr(struct wl1271 *wl, int addr)
+{
+	/*
+	 * To translate, first check to which window of addresses the
+	 * particular address belongs. Then subtract the starting address
+	 * of that window from the address. Then, add offset of the
+	 * translated region.
+	 *
+	 * The translated regions occur next to each other in physical device
+	 * memory, so just add the sizes of the preceeding address regions to
+	 * get the offset to the new region.
+	 *
+	 * Currently, only the two first regions are addressed, and the
+	 * assumption is that all addresses will fall into either of those
+	 * two.
+	 */
+	if ((addr >= wl->part.reg.start) &&
+	    (addr < wl->part.reg.start + wl->part.reg.size))
+		return addr - wl->part.reg.start + wl->part.mem.size;
+	else
+		return addr - wl->part.mem.start;
+}
+
+/* Set the SPI partitions to access the chip addresses
+ *
+ * To simplify driver code, a fixed (virtual) memory map is defined for
+ * register and memory addresses. Because in the chipset, in different stages
+ * of operation, those addresses will move around, an address translation
+ * mechanism is required.
+ *
+ * There are four partitions (three memory and one register partition),
+ * which are mapped to two different areas of the hardware memory.
+ *
+ *                                Virtual address
+ *                                     space
+ *
+ *                                    |    |
+ *                                 ...+----+--> mem.start
+ *          Physical address    ...   |    |
+ *               space       ...      |    | [PART_0]
+ *                        ...         |    |
+ *  00000000  <--+----+...         ...+----+--> mem.start + mem.size
+ *               |    |         ...   |    |
+ *               |MEM |      ...      |    |
+ *               |    |   ...         |    |
+ *  mem.size  <--+----+...            |    | {unused area)
+ *               |    |   ...         |    |
+ *               |REG |      ...      |    |
+ *  mem.size     |    |         ...   |    |
+ *      +     <--+----+...         ...+----+--> reg.start
+ *  reg.size     |    |   ...         |    |
+ *               |MEM2|      ...      |    | [PART_1]
+ *               |    |         ...   |    |
+ *                                 ...+----+--> reg.start + reg.size
+ *                                    |    |
+ *
+ */
+int wl1271_set_partition(struct wl1271 *wl,
+			 struct wl1271_partition_set *p)
+{
+	/* copy partition info */
+	memcpy(&wl->part, p, sizeof(*p));
+
+	wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		     p->mem.start, p->mem.size);
+	wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		     p->reg.start, p->reg.size);
+	wl1271_debug(DEBUG_SPI, "mem2_start %08X mem2_size %08X",
+		     p->mem2.start, p->mem2.size);
+	wl1271_debug(DEBUG_SPI, "mem3_start %08X mem3_size %08X",
+		     p->mem3.start, p->mem3.size);
+
+	/* write partition info to the chipset */
+	wl1271_raw_write32(wl, HW_PART0_START_ADDR, p->mem.start);
+	wl1271_raw_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
+	wl1271_raw_write32(wl, HW_PART1_START_ADDR, p->reg.start);
+	wl1271_raw_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
+	wl1271_raw_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
+	wl1271_raw_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
+	wl1271_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
+
+	return 0;
+}
+
+void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
+		      size_t len, bool fixed)
+{
+	wl1271_spi_raw_write(wl, addr, buf, len, fixed);
+}
+
+void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
+		     size_t len, bool fixed)
+{
+	wl1271_spi_read(wl, addr, buf, len, fixed);
+}
+
+void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf, size_t len,
+		     bool fixed)
+{
+	int physical;
+
+	physical = wl1271_translate_addr(wl, addr);
+
+	wl1271_spi_raw_read(wl, physical, buf, len, fixed);
+}
+
+void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf, size_t len,
+		      bool fixed)
+{
+	int physical;
+
+	physical = wl1271_translate_addr(wl, addr);
+
+	wl1271_spi_raw_write(wl, physical, buf, len, fixed);
+}
+
+u32 wl1271_spi_read32(struct wl1271 *wl, int addr)
+{
+	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
+}
+
+void wl1271_spi_write32(struct wl1271 *wl, int addr, u32 val)
+{
+	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
+}
+
+void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
+{
+	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
+	addr = (addr >> 1) + 0x30000;
+	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
+
+	/* write value to OCP_POR_WDATA */
+	wl1271_spi_write32(wl, OCP_DATA_WRITE, val);
+
+	/* write 1 to OCP_CMD */
+	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_WRITE);
+}
+
+u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
+{
+	u32 val;
+	int timeout = OCP_CMD_LOOP;
+
+	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
+	addr = (addr >> 1) + 0x30000;
+	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
+
+	/* write 2 to OCP_CMD */
+	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_READ);
+
+	/* poll for data ready */
+	do {
+		val = wl1271_spi_read32(wl, OCP_DATA_READ);
+	} while (!(val & OCP_READY_MASK) && --timeout);
+
+	if (!timeout) {
+		wl1271_warning("Top register access timed out.");
+		return 0xffff;
+	}
+
+	/* check data status and return if OK */
+	if ((val & OCP_STATUS_MASK) == OCP_STATUS_OK)
+		return val & 0xffff;
+	else {
+		wl1271_warning("Top register access returned error.");
+		return 0xffff;
+	}
+}
+
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
new file mode 100644
index 0000000..2dc6abb
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -0,0 +1,37 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2010 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_IO_H__
+#define __WL1271_IO_H__
+
+struct wl1271;
+
+
+/* Raw target IO, address is not translated */
+void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
+		      size_t len, bool fixed);
+void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
+		     size_t len, bool fixed);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index ee9564a..67a8293 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -30,28 +30,6 @@
 #include "wl12xx_80211.h"
 #include "wl1271_spi.h"
 
-static int wl1271_translate_addr(struct wl1271 *wl, int addr)
-{
-	/*
-	 * To translate, first check to which window of addresses the
-	 * particular address belongs. Then subtract the starting address
-	 * of that window from the address. Then, add offset of the
-	 * translated region.
-	 *
-	 * The translated regions occur next to each other in physical device
-	 * memory, so just add the sizes of the preceeding address regions to
-	 * get the offset to the new region.
-	 *
-	 * Currently, only the two first regions are addressed, and the
-	 * assumption is that all addresses will fall into either of those
-	 * two.
-	 */
-	if ((addr >= wl->part.reg.start) &&
-	    (addr < wl->part.reg.start + wl->part.reg.size))
-		return addr - wl->part.reg.start + wl->part.mem.size;
-	else
-		return addr - wl->part.mem.start;
-}
 
 void wl1271_spi_reset(struct wl1271 *wl)
 {
@@ -133,67 +111,6 @@ void wl1271_spi_init(struct wl1271 *wl)
 	wl1271_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-/* Set the SPI partitions to access the chip addresses
- *
- * To simplify driver code, a fixed (virtual) memory map is defined for
- * register and memory addresses. Because in the chipset, in different stages
- * of operation, those addresses will move around, an address translation
- * mechanism is required.
- *
- * There are four partitions (three memory and one register partition),
- * which are mapped to two different areas of the hardware memory.
- *
- *                                Virtual address
- *                                     space
- *
- *                                    |    |
- *                                 ...+----+--> mem.start
- *          Physical address    ...   |    |
- *               space       ...      |    | [PART_0]
- *                        ...         |    |
- *  00000000  <--+----+...         ...+----+--> mem.start + mem.size
- *               |    |         ...   |    |
- *               |MEM |      ...      |    |
- *               |    |   ...         |    |
- *  mem.size  <--+----+...            |    | {unused area)
- *               |    |   ...         |    |
- *               |REG |      ...      |    |
- *  mem.size     |    |         ...   |    |
- *      +     <--+----+...         ...+----+--> reg.start
- *  reg.size     |    |   ...         |    |
- *               |MEM2|      ...      |    | [PART_1]
- *               |    |         ...   |    |
- *                                 ...+----+--> reg.start + reg.size
- *                                    |    |
- *
- */
-int wl1271_set_partition(struct wl1271 *wl,
-			 struct wl1271_partition_set *p)
-{
-	/* copy partition info */
-	memcpy(&wl->part, p, sizeof(*p));
-
-	wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-		     p->mem.start, p->mem.size);
-	wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-		     p->reg.start, p->reg.size);
-	wl1271_debug(DEBUG_SPI, "mem2_start %08X mem2_size %08X",
-		     p->mem2.start, p->mem2.size);
-	wl1271_debug(DEBUG_SPI, "mem3_start %08X mem3_size %08X",
-		     p->mem3.start, p->mem3.size);
-
-	/* write partition info to the chipset */
-	wl1271_raw_write32(wl, HW_PART0_START_ADDR, p->mem.start);
-	wl1271_raw_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
-	wl1271_raw_write32(wl, HW_PART1_START_ADDR, p->reg.start);
-	wl1271_raw_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
-	wl1271_raw_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
-	wl1271_raw_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
-	wl1271_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
-
-	return 0;
-}
-
 #define WL1271_BUSY_WORD_TIMEOUT 1000
 
 /* FIXME: Check busy words, removed due to SPI bug */
@@ -338,77 +255,3 @@ void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 	wl1271_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
 	wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
-
-void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf, size_t len,
-		     bool fixed)
-{
-	int physical;
-
-	physical = wl1271_translate_addr(wl, addr);
-
-	wl1271_spi_raw_read(wl, physical, buf, len, fixed);
-}
-
-void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf, size_t len,
-		      bool fixed)
-{
-	int physical;
-
-	physical = wl1271_translate_addr(wl, addr);
-
-	wl1271_spi_raw_write(wl, physical, buf, len, fixed);
-}
-
-u32 wl1271_spi_read32(struct wl1271 *wl, int addr)
-{
-	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
-}
-
-void wl1271_spi_write32(struct wl1271 *wl, int addr, u32 val)
-{
-	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
-}
-
-void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
-{
-	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
-	addr = (addr >> 1) + 0x30000;
-	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
-
-	/* write value to OCP_POR_WDATA */
-	wl1271_spi_write32(wl, OCP_DATA_WRITE, val);
-
-	/* write 1 to OCP_CMD */
-	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_WRITE);
-}
-
-u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
-{
-	u32 val;
-	int timeout = OCP_CMD_LOOP;
-
-	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
-	addr = (addr >> 1) + 0x30000;
-	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
-
-	/* write 2 to OCP_CMD */
-	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_READ);
-
-	/* poll for data ready */
-	do {
-		val = wl1271_spi_read32(wl, OCP_DATA_READ);
-	} while (!(val & OCP_READY_MASK) && --timeout);
-
-	if (!timeout) {
-		wl1271_warning("Top register access timed out.");
-		return 0xffff;
-	}
-
-	/* check data status and return if OK */
-	if ((val & OCP_STATUS_MASK) == OCP_STATUS_OK)
-		return val & 0xffff;
-	else {
-		wl1271_warning("Top register access returned error.");
-		return 0xffff;
-	}
-}
-- 
1.6.3.3

