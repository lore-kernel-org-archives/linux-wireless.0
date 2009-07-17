Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:39383 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZGQS6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 14:58:21 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [RFC PATCH v2 2/8] wl1251: separate bus i/o code into io.c
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2009 21:47:56 +0300
Message-ID: <20090717184756.25883.69247.stgit@tikku>
In-Reply-To: <20090717184643.25883.95065.stgit@tikku>
References: <20090717184643.25883.95065.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

In order to eventually support wl1251 spi and sdio interfaces, move
the register and memory transfer functions to a common file.  Also
rename wl1251_spi_mem_{read,write} to indicate its common usage.
We still use spi_read internally until SDIO interface is introduced
so nothing functional should change here.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/Makefile       |    2 -
 drivers/net/wireless/wl12xx/wl1251_acx.c   |    2 -
 drivers/net/wireless/wl12xx/wl1251_boot.c  |    2 -
 drivers/net/wireless/wl12xx/wl1251_cmd.c   |   10 ++-
 drivers/net/wireless/wl12xx/wl1251_event.c |    4 +
 drivers/net/wireless/wl12xx/wl1251_io.c    |   86 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_io.h    |   54 ++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_main.c  |    3 +
 drivers/net/wireless/wl12xx/wl1251_ops.c   |    6 +-
 drivers/net/wireless/wl12xx/wl1251_ps.c    |    3 +
 drivers/net/wireless/wl12xx/wl1251_rx.c    |    7 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c   |   81 --------------------------
 drivers/net/wireless/wl12xx/wl1251_spi.h   |   30 ----------
 drivers/net/wireless/wl12xx/wl1251_tx.c    |   61 ++++++++++----------
 14 files changed, 192 insertions(+), 159 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_io.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_io.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index d5595a8..a978567 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,5 +1,5 @@
 wl1251-objs		= wl1251_main.o wl1251_spi.o wl1251_event.o \
 			  wl1251_tx.o wl1251_rx.o wl1251_ps.o wl1251_cmd.o \
 			  wl1251_acx.o wl1251_boot.o wl1251_init.o \
-			  wl1251_ops.o wl1251_debugfs.o
+			  wl1251_ops.o wl1251_debugfs.o wl1251_io.o
 obj-$(CONFIG_WL1251)	+= wl1251.o
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index 5a8d21c..b89fa23 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -6,7 +6,7 @@
 
 #include "wl1251.h"
 #include "reg.h"
-#include "wl1251_spi.h"
+#include "wl1251_cmd.h"
 #include "wl1251_ps.h"
 
 int wl1251_acx_frame_rates(struct wl1251 *wl, u8 ctrl_rate, u8 ctrl_mod,
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index d8a155d..5702398 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -25,7 +25,7 @@
 
 #include "reg.h"
 #include "wl1251_boot.h"
-#include "wl1251_spi.h"
+#include "wl1251_io.h"
 #include "wl1251_event.h"
 
 static void wl1251_boot_enable_interrupts(struct wl1251 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index dc04d1f..2c30c70 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -6,7 +6,7 @@
 
 #include "wl1251.h"
 #include "reg.h"
-#include "wl1251_spi.h"
+#include "wl1251_io.h"
 #include "wl1251_ps.h"
 #include "wl1251_acx.h"
 
@@ -31,7 +31,7 @@ int wl1251_cmd_send(struct wl1251 *wl, u16 id, void *buf, size_t len)
 
 	WARN_ON(len % 4 != 0);
 
-	wl1251_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
+	wl1251_mem_write(wl, wl->cmd_box_addr, buf, len);
 
 	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
@@ -86,7 +86,7 @@ int wl1251_cmd_test(struct wl1251 *wl, void *buf, size_t buf_len, u8 answer)
 		 * The answer would be a wl1251_command, where the
 		 * parameter array contains the actual answer.
 		 */
-		wl1251_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+		wl1251_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
 
 		cmd_answer = buf;
 
@@ -125,7 +125,7 @@ int wl1251_cmd_interrogate(struct wl1251 *wl, u16 id, void *buf, size_t len)
 	}
 
 	/* the interrogate command got in, we can read the answer */
-	wl1251_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
+	wl1251_mem_read(wl, wl->cmd_box_addr, buf, len);
 
 	acx = buf;
 	if (acx->cmd.status != CMD_STATUS_SUCCESS)
@@ -379,7 +379,7 @@ int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 	}
 
 	/* the read command got in, we can now read the answer */
-	wl1251_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
+	wl1251_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
 
 	if (cmd->header.status != CMD_STATUS_SUCCESS)
 		wl1251_error("error in read command result: %d",
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index 1a0a0bc..1b4f8d2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -24,7 +24,7 @@
 
 #include "wl1251.h"
 #include "reg.h"
-#include "wl1251_spi.h"
+#include "wl1251_io.h"
 #include "wl1251_event.h"
 #include "wl1251_ps.h"
 
@@ -112,7 +112,7 @@ int wl1251_event_handle(struct wl1251 *wl, u8 mbox_num)
 		return -EINVAL;
 
 	/* first we read the mbox descriptor */
-	wl1251_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+	wl1251_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
 			    sizeof(struct event_mailbox));
 
 	/* process the descriptor */
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.c b/drivers/net/wireless/wl12xx/wl1251_io.c
new file mode 100644
index 0000000..1fa2674
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_io.c
@@ -0,0 +1,86 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
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
+#include "wl1251.h"
+#include "reg.h"
+#include "wl1251_io.h"
+
+static int wl1251_translate_reg_addr(struct wl1251 *wl, int addr)
+{
+	/* If the address is lower than REGISTERS_BASE, it means that this is
+	 * a chip-specific register address, so look it up in the registers
+	 * table */
+	if (addr < REGISTERS_BASE) {
+		/* Make sure we don't go over the table */
+		if (addr >= ACX_REG_TABLE_LEN) {
+			wl1251_error("address out of range (%d)", addr);
+			return -EINVAL;
+		}
+		addr = wl->chip.acx_reg_table[addr];
+	}
+
+	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
+}
+
+static int wl1251_translate_mem_addr(struct wl1251 *wl, int addr)
+{
+	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
+}
+
+void wl1251_mem_read(struct wl1251 *wl, int addr, void *buf, size_t len)
+{
+	int physical;
+
+	physical = wl1251_translate_mem_addr(wl, addr);
+
+	wl1251_spi_read(wl, physical, buf, len);
+}
+
+void wl1251_mem_write(struct wl1251 *wl, int addr, void *buf, size_t len)
+{
+	int physical;
+
+	physical = wl1251_translate_mem_addr(wl, addr);
+
+	wl1251_spi_write(wl, physical, buf, len);
+}
+
+u32 wl1251_mem_read32(struct wl1251 *wl, int addr)
+{
+	return wl1251_read32(wl, wl1251_translate_mem_addr(wl, addr));
+}
+
+void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val)
+{
+	wl1251_write32(wl, wl1251_translate_mem_addr(wl, addr), val);
+}
+
+u32 wl1251_reg_read32(struct wl1251 *wl, int addr)
+{
+	return wl1251_read32(wl, wl1251_translate_reg_addr(wl, addr));
+}
+
+void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val)
+{
+	wl1251_write32(wl, wl1251_translate_reg_addr(wl, addr), val);
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.h b/drivers/net/wireless/wl12xx/wl1251_io.h
new file mode 100644
index 0000000..e2bb954
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_io.h
@@ -0,0 +1,54 @@
+/*
+ * This file is part of wl12xx
+ *
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
+#ifndef __WL1251_IO_H__
+#define __WL1251_IO_H__
+
+#include "wl1251.h"
+#include "wl1251_spi.h"
+
+/* Raw target IO, address is not translated */
+void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf, size_t len);
+void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len);
+
+static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
+{
+	u32 response;
+
+	wl1251_spi_read(wl, addr, &response, sizeof(u32));
+
+	return response;
+}
+
+static inline void wl1251_write32(struct wl1251 *wl, int addr, u32 val)
+{
+	wl1251_spi_write(wl, addr, &val, sizeof(u32));
+}
+
+/* Memory target IO, address is translated to partition 0 */
+void wl1251_mem_read(struct wl1251 *wl, int addr, void *buf, size_t len);
+void wl1251_mem_write(struct wl1251 *wl, int addr, void *buf, size_t len);
+u32 wl1251_mem_read32(struct wl1251 *wl, int addr);
+void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val);
+/* Registers IO */
+u32 wl1251_reg_read32(struct wl1251 *wl, int addr);
+void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index cf5e054..2967e19 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -35,6 +35,7 @@
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_ops.h"
+#include "wl1251_io.h"
 #include "wl1251_spi.h"
 #include "wl1251_event.h"
 #include "wl1251_tx.h"
@@ -932,7 +933,7 @@ static int wl1251_hw_scan(struct wl1251 *wl, u8 *ssid, size_t len,
 	if (ret < 0)
 		wl1251_error("SCAN failed");
 
-	wl1251_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
+	wl1251_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
 
 	if (params->header.status != CMD_STATUS_SUCCESS) {
 		wl1251_error("TEST command answer error: %d",
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.c b/drivers/net/wireless/wl12xx/wl1251_ops.c
index 96a45f5..0c169ec 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.c
@@ -26,7 +26,7 @@
 
 #include "wl1251_ops.h"
 #include "reg.h"
-#include "wl1251_spi.h"
+#include "wl1251_io.h"
 #include "wl1251_boot.h"
 #include "wl1251_event.h"
 #include "wl1251_acx.h"
@@ -130,7 +130,7 @@ static int wl1251_upload_firmware(struct wl1251 *wl)
 		p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
 		wl1251_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl1251_spi_mem_write(wl, addr, p, CHUNK_SIZE);
+		wl1251_mem_write(wl, addr, p, CHUNK_SIZE);
 
 		chunk_num++;
 	}
@@ -140,7 +140,7 @@ static int wl1251_upload_firmware(struct wl1251 *wl)
 	p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
 	wl1251_debug(DEBUG_BOOT, "uploading fw last chunk (%zu B) 0x%p to 0x%x",
 		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl1251_spi_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
+	wl1251_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index 68ff7f1..0581677 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -23,7 +23,8 @@
 
 #include "reg.h"
 #include "wl1251_ps.h"
-#include "wl1251_spi.h"
+#include "wl1251_cmd.h"
+#include "wl1251_io.h"
 
 #define WL1251_WAKEUP_TIMEOUT 2000
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index 0dbb483..af81879 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -27,8 +27,9 @@
 
 #include "wl1251.h"
 #include "reg.h"
-#include "wl1251_spi.h"
+#include "wl1251_io.h"
 #include "wl1251_rx.h"
+#include "wl1251_cmd.h"
 #include "wl1251_acx.h"
 
 static void wl1251_rx_header(struct wl1251 *wl,
@@ -40,7 +41,7 @@ static void wl1251_rx_header(struct wl1251 *wl,
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
-	wl1251_spi_mem_read(wl, rx_packet_ring_addr, desc, sizeof(*desc));
+	wl1251_mem_read(wl, rx_packet_ring_addr, desc, sizeof(*desc));
 }
 
 static void wl1251_rx_status(struct wl1251 *wl,
@@ -136,7 +137,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
 	}
 
 	rx_buffer = skb_put(skb, length);
-	wl1251_spi_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
+	wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
 
 	/* The actual lenght doesn't include the target's alignment */
 	skb->len = desc->length  - PLCP_HEADER_LENGTH;
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index c2b813f..031a3ba 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -29,29 +29,6 @@
 #include "reg.h"
 #include "wl1251_spi.h"
 
-static int wl1251_translate_reg_addr(struct wl1251 *wl, int addr)
-{
-	/* If the address is lower than REGISTERS_BASE, it means that this is
-	 * a chip-specific register address, so look it up in the registers
-	 * table */
-	if (addr < REGISTERS_BASE) {
-		/* Make sure we don't go over the table */
-		if (addr >= ACX_REG_TABLE_LEN) {
-			wl1251_error("address out of range (%d)", addr);
-			return -EINVAL;
-		}
-		addr = wl->chip.acx_reg_table[addr];
-	}
-
-	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
-}
-
-static int wl1251_translate_mem_addr(struct wl1251 *wl, int addr)
-{
-	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
-}
-
-
 void wl1251_spi_reset(struct wl1251 *wl)
 {
 	u8 *cmd;
@@ -323,61 +300,3 @@ void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len)
 	wl1251_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
 	wl1251_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
-
-void wl1251_spi_mem_read(struct wl1251 *wl, int addr, void *buf,
-			 size_t len)
-{
-	int physical;
-
-	physical = wl1251_translate_mem_addr(wl, addr);
-
-	wl1251_spi_read(wl, physical, buf, len);
-}
-
-void wl1251_spi_mem_write(struct wl1251 *wl, int addr, void *buf,
-			  size_t len)
-{
-	int physical;
-
-	physical = wl1251_translate_mem_addr(wl, addr);
-
-	wl1251_spi_write(wl, physical, buf, len);
-}
-
-void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len)
-{
-	int physical;
-
-	physical = wl1251_translate_reg_addr(wl, addr);
-
-	wl1251_spi_read(wl, physical, buf, len);
-}
-
-void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len)
-{
-	int physical;
-
-	physical = wl1251_translate_reg_addr(wl, addr);
-
-	wl1251_spi_write(wl, physical, buf, len);
-}
-
-u32 wl1251_mem_read32(struct wl1251 *wl, int addr)
-{
-	return wl1251_read32(wl, wl1251_translate_mem_addr(wl, addr));
-}
-
-void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val)
-{
-	wl1251_write32(wl, wl1251_translate_mem_addr(wl, addr), val);
-}
-
-u32 wl1251_reg_read32(struct wl1251 *wl, int addr)
-{
-	return wl1251_read32(wl, wl1251_translate_reg_addr(wl, addr));
-}
-
-void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val)
-{
-	wl1251_write32(wl, wl1251_translate_reg_addr(wl, addr), val);
-}
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl12xx/wl1251_spi.h
index 7076352..ca9a851 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.h
@@ -69,23 +69,6 @@
 		((WL1251_BUSY_WORD_LEN - 4) / sizeof(u32))
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
-
-/* Raw target IO, address is not translated */
-void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len);
-void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf, size_t len);
-
-/* Memory target IO, address is tranlated to partition 0 */
-void wl1251_spi_mem_read(struct wl1251 *wl, int addr, void *buf, size_t len);
-void wl1251_spi_mem_write(struct wl1251 *wl, int addr, void *buf, size_t len);
-u32 wl1251_mem_read32(struct wl1251 *wl, int addr);
-void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val);
-
-/* Registers IO */
-void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len);
-void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len);
-u32 wl1251_reg_read32(struct wl1251 *wl, int addr);
-void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val);
-
 /* INIT and RESET words */
 void wl1251_spi_reset(struct wl1251 *wl);
 void wl1251_spi_init(struct wl1251 *wl);
@@ -93,17 +76,4 @@ int wl1251_set_partition(struct wl1251 *wl,
 			 u32 part_start, u32 part_size,
 			 u32 reg_start,  u32 reg_size);
 
-static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
-{
-	wl1251_spi_read(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
-
-	return wl->buffer_32;
-}
-
-static inline void wl1251_write32(struct wl1251 *wl, int addr, u32 val)
-{
-	wl->buffer_32 = val;
-	wl1251_spi_write(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
-}
-
 #endif /* __WL1251_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index 2652a22..7ddc9a3 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -30,6 +30,7 @@
 #include "wl1251_spi.h"
 #include "wl1251_tx.h"
 #include "wl1251_ps.h"
+#include "wl1251_io.h"
 
 static bool wl1251_tx_double_buffer_busy(struct wl1251 *wl, u32 data_out_count)
 {
@@ -235,7 +236,7 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
 	else
 		addr = wl->data_path->tx_packet_ring_addr;
 
-	wl1251_spi_mem_write(wl, addr, skb->data, len);
+	wl1251_mem_write(wl, addr, skb->data, len);
 
 	wl1251_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
 		     tx_hdr->id, skb, tx_hdr->length, tx_hdr->rate);
@@ -451,7 +452,7 @@ void wl1251_tx_complete(struct wl1251 *wl)
 		return;
 
 	/* First we read the result */
-	wl1251_spi_mem_read(wl, wl->data_path->tx_complete_addr,
+	wl1251_mem_read(wl, wl->data_path->tx_complete_addr,
 			    result, sizeof(result));
 
 	result_index = wl->next_tx_complete;
@@ -482,41 +483,41 @@ void wl1251_tx_complete(struct wl1251 *wl)
 		 */
 		if (result_index > wl->next_tx_complete) {
 			/* Only 1 write is needed */
-			wl1251_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr +
-					     (wl->next_tx_complete *
-					      sizeof(struct tx_result)),
-					     &result[wl->next_tx_complete],
-					     num_complete *
-					     sizeof(struct tx_result));
+			wl1251_mem_write(wl,
+					 wl->data_path->tx_complete_addr +
+					 (wl->next_tx_complete *
+					  sizeof(struct tx_result)),
+					 &result[wl->next_tx_complete],
+					 num_complete *
+					 sizeof(struct tx_result));
 
 
 		} else if (result_index < wl->next_tx_complete) {
 			/* 2 writes are needed */
-			wl1251_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr +
-					     (wl->next_tx_complete *
-					      sizeof(struct tx_result)),
-					     &result[wl->next_tx_complete],
-					     (FW_TX_CMPLT_BLOCK_SIZE -
-					      wl->next_tx_complete) *
-					     sizeof(struct tx_result));
-
-			wl1251_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr,
-					     result,
-					     (num_complete -
-					      FW_TX_CMPLT_BLOCK_SIZE +
-					      wl->next_tx_complete) *
-					     sizeof(struct tx_result));
+			wl1251_mem_write(wl,
+					 wl->data_path->tx_complete_addr +
+					 (wl->next_tx_complete *
+					  sizeof(struct tx_result)),
+					 &result[wl->next_tx_complete],
+					 (FW_TX_CMPLT_BLOCK_SIZE -
+					  wl->next_tx_complete) *
+					 sizeof(struct tx_result));
+
+			wl1251_mem_write(wl,
+					 wl->data_path->tx_complete_addr,
+					 result,
+					 (num_complete -
+					  FW_TX_CMPLT_BLOCK_SIZE +
+					  wl->next_tx_complete) *
+					 sizeof(struct tx_result));
 
 		} else {
 			/* We have to write the whole array */
-			wl1251_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr,
-					     result,
-					     FW_TX_CMPLT_BLOCK_SIZE *
-					     sizeof(struct tx_result));
+			wl1251_mem_write(wl,
+					 wl->data_path->tx_complete_addr,
+					 result,
+					 FW_TX_CMPLT_BLOCK_SIZE *
+					 sizeof(struct tx_result));
 		}
 
 	}

