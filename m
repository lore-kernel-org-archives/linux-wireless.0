Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1653 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761206AbZFKCDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 1/7] wl12xx: separate bus i/o code into io.c
Date: Wed, 10 Jun 2009 22:02:54 -0400
Message-Id: <1244685780-28930-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to eventually support wl12xx spi and sdio interfaces, move
the register and memory transfer functions to a common file.  Also
rename wl12xx_spi_mem_{read,write} to indicate its common usage.
We still use spi_read internally until SDIO interface is introduced
so nothing functional should change here.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/Makefile |    2 +-
 drivers/net/wireless/wl12xx/acx.c    |    2 +-
 drivers/net/wireless/wl12xx/boot.c   |    3 +-
 drivers/net/wireless/wl12xx/cmd.c    |   14 +++---
 drivers/net/wireless/wl12xx/event.c  |    6 +-
 drivers/net/wireless/wl12xx/io.c     |   86 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/io.h     |   54 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c   |    3 +-
 drivers/net/wireless/wl12xx/ps.c     |    3 +-
 drivers/net/wireless/wl12xx/rx.c     |   10 ++--
 drivers/net/wireless/wl12xx/spi.c    |   63 -------------------------
 drivers/net/wireless/wl12xx/spi.h    |   27 -----------
 drivers/net/wireless/wl12xx/tx.c     |   63 +++++++++++++------------
 drivers/net/wireless/wl12xx/wl1251.c |    9 ++--
 14 files changed, 201 insertions(+), 144 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/io.c
 create mode 100644 drivers/net/wireless/wl12xx/io.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index d43de27..c1281fc 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,4 +1,4 @@
 wl12xx-objs		= main.o spi.o event.o tx.o rx.o \
 			  ps.o cmd.o acx.o boot.o init.o wl1251.o \
-			  debugfs.o
+			  debugfs.o io.o
 obj-$(CONFIG_WL12XX)	+= wl12xx.o
diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 1cfd458..9e48de2 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -7,7 +7,7 @@
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
index f73ab60..56bf6a6 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -7,7 +7,7 @@
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
-#include "spi.h"
+#include "io.h"
 #include "ps.h"
 
 int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len)
@@ -26,7 +26,7 @@ int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len)
 
 	wl12xx_ps_elp_wakeup(wl);
 
-	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, &cmd, cmd_len);
+	wl12xx_mem_write(wl, wl->cmd_box_addr, &cmd, cmd_len);
 
 	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
@@ -77,7 +77,7 @@ int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
 
 		wl12xx_ps_elp_wakeup(wl);
 
-		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+		wl12xx_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
 
 		wl12xx_ps_elp_sleep(wl);
 
@@ -112,8 +112,8 @@ int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 ie_id, u16 ie_len,
 	wl12xx_ps_elp_wakeup(wl);
 
 	/* the interrogate command got in, we can read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, answer,
-			    CMDMBOX_HEADER_LEN + ie_len);
+	wl12xx_mem_read(wl, wl->cmd_box_addr, answer,
+			CMDMBOX_HEADER_LEN + ie_len);
 
 	wl12xx_ps_elp_sleep(wl);
 
@@ -313,8 +313,8 @@ int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, u32 len, void *answer)
 	}
 
 	/* the read command got in, we can now read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, &cmd,
-			    CMDMBOX_HEADER_LEN + sizeof(mem_cmd));
+	wl12xx_mem_read(wl, wl->cmd_box_addr, &cmd,
+			CMDMBOX_HEADER_LEN + sizeof(mem_cmd));
 
 	if (cmd.status != CMD_STATUS_SUCCESS)
 		wl12xx_error("error in read command result: %d", cmd.status);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 99529ca..0a86a1a 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -24,7 +24,7 @@
 
 #include "wl12xx.h"
 #include "reg.h"
-#include "spi.h"
+#include "io.h"
 #include "event.h"
 #include "ps.h"
 
@@ -112,8 +112,8 @@ int wl12xx_event_handle(struct wl12xx *wl, u8 mbox_num)
 		return -EINVAL;
 
 	/* first we read the mbox descriptor */
-	wl12xx_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
-			    sizeof(struct event_mailbox));
+	wl12xx_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+			sizeof(struct event_mailbox));
 
 	/* process the descriptor */
 	ret = wl12xx_event_process(wl, &mbox);
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
new file mode 100644
index 0000000..15af799
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/io.c
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
+	wl12xx_spi_read(wl, physical, buf, len);
+}
+
+void wl12xx_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int physical;
+
+	physical = wl12xx_translate_mem_addr(wl, addr);
+
+	wl12xx_spi_write(wl, physical, buf, len);
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
+
+void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
+}
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
new file mode 100644
index 0000000..5f96871
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/io.h
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
+#ifndef __WL12XX_IO_H__
+#define __WL12XX_IO_H__
+
+#include "wl12xx.h"
+#include "spi.h"
+
+/* Raw target IO, address is not translated */
+void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf, size_t len);
+
+static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
+{
+	u32 response;
+
+	wl12xx_spi_read(wl, addr, &response, sizeof(u32));
+
+	return response;
+}
+
+static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl12xx_spi_write(wl, addr, &val, sizeof(u32));
+}
+
+/* Memory target IO, address is translated to partition 0 */
+void wl12xx_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len);
+u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
+void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
+/* Registers IO */
+u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
+void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..9ecfb9e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -35,6 +35,7 @@
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251.h"
+#include "io.h"
 #include "spi.h"
 #include "event.h"
 #include "tx.h"
@@ -885,7 +886,7 @@ static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
 	if (ret < 0)
 		wl12xx_error("SCAN failed");
 
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
+	wl12xx_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
 
 	cmd_answer = (struct wl12xx_command *) params;
 	if (cmd_answer->status != CMD_STATUS_SUCCESS) {
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
index 981ea25..f3a2ede 100644
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
@@ -39,8 +41,8 @@ static void wl12xx_rx_header(struct wl12xx *wl,
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, desc,
-			    sizeof(struct wl12xx_rx_descriptor));
+	wl12xx_mem_read(wl, rx_packet_ring_addr, desc,
+			sizeof(struct wl12xx_rx_descriptor));
 }
 
 static void wl12xx_rx_status(struct wl12xx *wl,
@@ -151,7 +153,7 @@ static void wl12xx_rx_body(struct wl12xx *wl,
 	}
 
 	rx_buffer = skb_put(skb, length);
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
+	wl12xx_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
 
 	/* The actual lenght doesn't include the target's alignment */
 	skb->len = desc->length  - PLCP_HEADER_LENGTH;
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index abdf171..aabc487 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -31,29 +31,6 @@
 #include "spi.h"
 #include "ps.h"
 
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
-
 void wl12xx_spi_reset(struct wl12xx *wl)
 {
 	u8 *cmd;
@@ -316,43 +293,3 @@ void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", &cmd, sizeof(cmd));
 	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
-
-void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf,
-			 size_t len)
-{
-	int physical;
-
-	physical = wl12xx_translate_mem_addr(wl, addr);
-
-	wl12xx_spi_read(wl, physical, buf, len);
-}
-
-void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
-			  size_t len)
-{
-	int physical;
-
-	physical = wl12xx_translate_mem_addr(wl, addr);
-
-	wl12xx_spi_write(wl, physical, buf, len);
-}
-
-u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
-{
-	return wl12xx_read32(wl, wl12xx_translate_mem_addr(wl, addr));
-}
-
-void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val)
-{
-	wl12xx_write32(wl, wl12xx_translate_mem_addr(wl, addr), val);
-}
-
-u32 wl12xx_reg_read32(struct wl12xx *wl, int addr)
-{
-	return wl12xx_read32(wl, wl12xx_translate_reg_addr(wl, addr));
-}
-
-void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
-{
-	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
-}
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index fd3227e..7c51475 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -71,19 +71,6 @@
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
 
 /* INIT and RESET words */
 void wl12xx_spi_reset(struct wl12xx *wl);
@@ -92,18 +79,4 @@ void wl12xx_set_partition(struct wl12xx *wl,
 			  u32 part_start, u32 part_size,
 			  u32 reg_start,  u32 reg_size);
 
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
 #endif /* __WL12XX_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 62145e2..2079aba 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -30,6 +30,7 @@
 #include "spi.h"
 #include "tx.h"
 #include "ps.h"
+#include "io.h"
 
 static bool wl12xx_tx_double_buffer_busy(struct wl12xx *wl, u32 data_out_count)
 {
@@ -235,7 +236,7 @@ static int wl12xx_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
 	else
 		addr = wl->data_path->tx_packet_ring_addr;
 
-	wl12xx_spi_mem_write(wl, addr, skb->data, len);
+	wl12xx_mem_write(wl, addr, skb->data, len);
 
 	wl12xx_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
 		     tx_hdr->id, skb, tx_hdr->length, tx_hdr->rate);
@@ -449,8 +450,8 @@ void wl12xx_tx_complete(struct wl12xx *wl)
 		return;
 
 	/* First we read the result */
-	wl12xx_spi_mem_read(wl, wl->data_path->tx_complete_addr,
-			    result, sizeof(result));
+	wl12xx_mem_read(wl, wl->data_path->tx_complete_addr,
+			result, sizeof(result));
 
 	result_index = wl->next_tx_complete;
 
@@ -480,41 +481,41 @@ void wl12xx_tx_complete(struct wl12xx *wl)
 		 */
 		if (result_index > wl->next_tx_complete) {
 			/* Only 1 write is needed */
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr +
-					     (wl->next_tx_complete *
-					      sizeof(struct tx_result)),
-					     &result[wl->next_tx_complete],
-					     num_complete *
-					     sizeof(struct tx_result));
+			wl12xx_mem_write(wl,
+					 wl->data_path->tx_complete_addr +
+					 (wl->next_tx_complete *
+					  sizeof(struct tx_result)),
+					 &result[wl->next_tx_complete],
+					 num_complete *
+					 sizeof(struct tx_result));
 
 
 		} else if (result_index < wl->next_tx_complete) {
 			/* 2 writes are needed */
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr +
-					     (wl->next_tx_complete *
-					      sizeof(struct tx_result)),
-					     &result[wl->next_tx_complete],
-					     (FW_TX_CMPLT_BLOCK_SIZE -
-					      wl->next_tx_complete) *
-					     sizeof(struct tx_result));
-
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr,
-					     result,
-					     (num_complete -
-					      FW_TX_CMPLT_BLOCK_SIZE +
-					      wl->next_tx_complete) *
-					     sizeof(struct tx_result));
+			wl12xx_mem_write(wl,
+					 wl->data_path->tx_complete_addr +
+					 (wl->next_tx_complete *
+					  sizeof(struct tx_result)),
+					 &result[wl->next_tx_complete],
+					 (FW_TX_CMPLT_BLOCK_SIZE -
+					  wl->next_tx_complete) *
+					 sizeof(struct tx_result));
+
+			wl12xx_mem_write(wl,
+					 wl->data_path->tx_complete_addr,
+					 result,
+					 (num_complete -
+					  FW_TX_CMPLT_BLOCK_SIZE +
+					  wl->next_tx_complete) *
+					 sizeof(struct tx_result));
 
 		} else {
 			/* We have to write the whole array */
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr,
-					     result,
-					     FW_TX_CMPLT_BLOCK_SIZE *
-					     sizeof(struct tx_result));
+			wl12xx_mem_write(wl,
+					 wl->data_path->tx_complete_addr,
+					 result,
+					 FW_TX_CMPLT_BLOCK_SIZE *
+					 sizeof(struct tx_result));
 		}
 
 	}
diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index ce1561a..543a5b8 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -34,6 +34,7 @@
 #include "rx.h"
 #include "ps.h"
 #include "init.h"
+#include "io.h"
 
 static struct wl12xx_partition_set wl1251_part_table[PART_TABLE_LEN] = {
 	[PART_DOWN] = {
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
@@ -412,8 +413,8 @@ static void wl1251_irq_work(struct work_struct *work)
 	wl12xx_debug(DEBUG_IRQ, "intr: 0x%x", intr);
 
 	if (wl->data_path) {
-		wl12xx_spi_mem_read(wl, wl->data_path->rx_control_addr,
-				    &wl->rx_counter, sizeof(u32));
+		wl12xx_mem_read(wl, wl->data_path->rx_control_addr,
+				&wl->rx_counter, sizeof(u32));
 
 		/* We handle a frmware bug here */
 		switch ((wl->rx_counter - wl->rx_handled) & 0xf) {
-- 
1.6.0.6


