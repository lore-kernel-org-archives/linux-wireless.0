Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20509 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab0BVGl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:27 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 05/22] wl1271: Removed wl1271_spi.h and made some functions static
Date: Mon, 22 Feb 2010 08:38:25 +0200
Message-Id: <1266820722-20202-6-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Removed wl1271_spi.h header as there's no more need to access functions
declared there outside of wl1271_spi.c. Also made those SPI access
functions static.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c      |    1 -
 drivers/net/wireless/wl12xx/wl1271_boot.c     |    1 -
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |    1 -
 drivers/net/wireless/wl12xx/wl1271_event.c    |    1 -
 drivers/net/wireless/wl12xx/wl1271_io.c       |   14 +++-
 drivers/net/wireless/wl12xx/wl1271_io.h       |   17 ++++
 drivers/net/wireless/wl12xx/wl1271_main.c     |    1 -
 drivers/net/wireless/wl12xx/wl1271_ps.c       |    1 -
 drivers/net/wireless/wl12xx/wl1271_rx.c       |    1 -
 drivers/net/wireless/wl12xx/wl1271_spi.c      |   44 +++++++++--
 drivers/net/wireless/wl12xx/wl1271_spi.h      |   99 -------------------------
 drivers/net/wireless/wl12xx/wl1271_testmode.c |    1 -
 drivers/net/wireless/wl12xx/wl1271_tx.c       |    1 -
 13 files changed, 67 insertions(+), 116 deletions(-)
 delete mode 100644 drivers/net/wireless/wl12xx/wl1271_spi.h

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 60f10dc..f41f886 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -31,7 +31,6 @@
 #include "wl1271.h"
 #include "wl12xx_80211.h"
 #include "wl1271_reg.h"
-#include "wl1271_spi.h"
 #include "wl1271_ps.h"
 
 int wl1271_acx_wake_up_conditions(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 7d6d2e6..f88d52e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -26,7 +26,6 @@
 #include "wl1271_acx.h"
 #include "wl1271_reg.h"
 #include "wl1271_boot.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 #include "wl1271_event.h"
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 36a64e0..6759aa1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -29,7 +29,6 @@
 
 #include "wl1271.h"
 #include "wl1271_reg.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 #include "wl1271_acx.h"
 #include "wl12xx_80211.h"
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 7468ef1..5533519 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -23,7 +23,6 @@
 
 #include "wl1271.h"
 #include "wl1271_reg.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 #include "wl1271_event.h"
 #include "wl1271_ps.h"
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/wl1271_io.c
index c082658..c8759ac 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.c
+++ b/drivers/net/wireless/wl12xx/wl1271_io.c
@@ -28,9 +28,21 @@
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 
+#define OCP_CMD_LOOP  32
+
+#define OCP_CMD_WRITE 0x1
+#define OCP_CMD_READ  0x2
+
+#define OCP_READY_MASK  BIT(18)
+#define OCP_STATUS_MASK (BIT(16) | BIT(17))
+
+#define OCP_STATUS_NO_RESP    0x00000
+#define OCP_STATUS_OK         0x10000
+#define OCP_STATUS_REQ_FAILED 0x20000
+#define OCP_STATUS_RESP_ERROR 0x30000
+
 void wl1271_disable_interrupts(struct wl1271 *wl)
 {
 	wl->if_ops->disable_irq(wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index 8501898..95d2168 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -25,6 +25,23 @@
 #ifndef __WL1271_IO_H__
 #define __WL1271_IO_H__
 
+#include "wl1271_reg.h"
+
+#define HW_ACCESS_MEMORY_MAX_RANGE	0x1FFC0
+
+#define HW_PARTITION_REGISTERS_ADDR     0x1FFC0
+#define HW_PART0_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR)
+#define HW_PART0_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 4)
+#define HW_PART1_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 8)
+#define HW_PART1_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 12)
+#define HW_PART2_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 16)
+#define HW_PART2_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 20)
+#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 24)
+
+#define HW_ACCESS_REGISTER_SIZE         4
+
+#define HW_ACCESS_PRAM_MAX_RANGE	0x3c000
+
 struct wl1271;
 
 void wl1271_disable_interrupts(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 6b3fd00..54bc1e9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -33,7 +33,6 @@
 #include "wl1271.h"
 #include "wl12xx_80211.h"
 #include "wl1271_reg.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 #include "wl1271_event.h"
 #include "wl1271_tx.h"
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index e2b1ebf..5a04482 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -23,7 +23,6 @@
 
 #include "wl1271_reg.h"
 #include "wl1271_ps.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 
 #define WL1271_WAKEUP_TIMEOUT 500
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 6730f5b..b7a7c06 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -25,7 +25,6 @@
 #include "wl1271_acx.h"
 #include "wl1271_reg.h"
 #include "wl1271_rx.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 
 static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index f89e1b3..51171d7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -30,9 +30,39 @@
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 
+#include "wl1271_reg.h"
+
+#define WSPI_CMD_READ                 0x40000000
+#define WSPI_CMD_WRITE                0x00000000
+#define WSPI_CMD_FIXED                0x20000000
+#define WSPI_CMD_BYTE_LENGTH          0x1FFE0000
+#define WSPI_CMD_BYTE_LENGTH_OFFSET   17
+#define WSPI_CMD_BYTE_ADDR            0x0001FFFF
+
+#define WSPI_INIT_CMD_CRC_LEN       5
+
+#define WSPI_INIT_CMD_START         0x00
+#define WSPI_INIT_CMD_TX            0x40
+/* the extra bypass bit is sampled by the TNET as '1' */
+#define WSPI_INIT_CMD_BYPASS_BIT    0x80
+#define WSPI_INIT_CMD_FIXEDBUSY_LEN 0x07
+#define WSPI_INIT_CMD_EN_FIXEDBUSY  0x80
+#define WSPI_INIT_CMD_DIS_FIXEDBUSY 0x00
+#define WSPI_INIT_CMD_IOD           0x40
+#define WSPI_INIT_CMD_IP            0x20
+#define WSPI_INIT_CMD_CS            0x10
+#define WSPI_INIT_CMD_WS            0x08
+#define WSPI_INIT_CMD_WSPI          0x01
+#define WSPI_INIT_CMD_END           0x01
+
+#define WSPI_INIT_CMD_LEN           8
+
+#define HW_ACCESS_WSPI_FIXED_BUSY_LEN \
+		((WL1271_BUSY_WORD_LEN - 4) / sizeof(u32))
+#define HW_ACCESS_WSPI_INIT_CMD_MASK  0
+
 static inline struct spi_device *wl_to_spi(struct wl1271 *wl)
 {
 	return wl->if_priv;
@@ -43,17 +73,17 @@ static struct device *wl1271_spi_wl_to_dev(struct wl1271 *wl)
 	return &(wl_to_spi(wl)->dev);
 }
 
-void wl1271_spi_disable_interrupts(struct wl1271 *wl)
+static void wl1271_spi_disable_interrupts(struct wl1271 *wl)
 {
 	disable_irq(wl->irq);
 }
 
-void wl1271_spi_enable_interrupts(struct wl1271 *wl)
+static void wl1271_spi_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
 }
 
-void wl1271_spi_reset(struct wl1271 *wl)
+static void wl1271_spi_reset(struct wl1271 *wl)
 {
 	u8 *cmd;
 	struct spi_transfer t;
@@ -79,7 +109,7 @@ void wl1271_spi_reset(struct wl1271 *wl)
 	wl1271_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-void wl1271_spi_init(struct wl1271 *wl)
+static void wl1271_spi_init(struct wl1271 *wl)
 {
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
@@ -199,7 +229,7 @@ static void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 }
 #endif
 
-void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
+static void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 			 size_t len, bool fixed)
 {
 	struct spi_transfer t[3];
@@ -244,7 +274,7 @@ void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 	wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
 }
 
-void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
+static void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 			  size_t len, bool fixed)
 {
 	struct spi_transfer t[2];
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.h b/drivers/net/wireless/wl12xx/wl1271_spi.h
deleted file mode 100644
index 86ff161..0000000
--- a/drivers/net/wireless/wl12xx/wl1271_spi.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * This file is part of wl1271
- *
- * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
- * Copyright (C) 2008-2009 Nokia Corporation
- *
- * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
-#ifndef __WL1271_SPI_H__
-#define __WL1271_SPI_H__
-
-#include "wl1271_reg.h"
-
-#define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
-
-#define HW_PARTITION_REGISTERS_ADDR         0x1ffc0
-#define HW_PART0_SIZE_ADDR                  (HW_PARTITION_REGISTERS_ADDR)
-#define HW_PART0_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 4)
-#define HW_PART1_SIZE_ADDR                  (HW_PARTITION_REGISTERS_ADDR + 8)
-#define HW_PART1_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 12)
-#define HW_PART2_SIZE_ADDR                  (HW_PARTITION_REGISTERS_ADDR + 16)
-#define HW_PART2_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 20)
-#define HW_PART3_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 24)
-
-#define HW_ACCESS_REGISTER_SIZE             4
-
-#define HW_ACCESS_PRAM_MAX_RANGE		0x3c000
-
-#define WSPI_CMD_READ                 0x40000000
-#define WSPI_CMD_WRITE                0x00000000
-#define WSPI_CMD_FIXED                0x20000000
-#define WSPI_CMD_BYTE_LENGTH          0x1FFE0000
-#define WSPI_CMD_BYTE_LENGTH_OFFSET   17
-#define WSPI_CMD_BYTE_ADDR            0x0001FFFF
-
-#define WSPI_INIT_CMD_CRC_LEN       5
-
-#define WSPI_INIT_CMD_START         0x00
-#define WSPI_INIT_CMD_TX            0x40
-/* the extra bypass bit is sampled by the TNET as '1' */
-#define WSPI_INIT_CMD_BYPASS_BIT    0x80
-#define WSPI_INIT_CMD_FIXEDBUSY_LEN 0x07
-#define WSPI_INIT_CMD_EN_FIXEDBUSY  0x80
-#define WSPI_INIT_CMD_DIS_FIXEDBUSY 0x00
-#define WSPI_INIT_CMD_IOD           0x40
-#define WSPI_INIT_CMD_IP            0x20
-#define WSPI_INIT_CMD_CS            0x10
-#define WSPI_INIT_CMD_WS            0x08
-#define WSPI_INIT_CMD_WSPI          0x01
-#define WSPI_INIT_CMD_END           0x01
-
-#define WSPI_INIT_CMD_LEN           8
-
-#define HW_ACCESS_WSPI_FIXED_BUSY_LEN \
-		((WL1271_BUSY_WORD_LEN - 4) / sizeof(u32))
-#define HW_ACCESS_WSPI_INIT_CMD_MASK  0
-
-#define OCP_CMD_LOOP  32
-
-#define OCP_CMD_WRITE 0x1
-#define OCP_CMD_READ  0x2
-
-#define OCP_READY_MASK  BIT(18)
-#define OCP_STATUS_MASK (BIT(16) | BIT(17))
-
-#define OCP_STATUS_NO_RESP    0x00000
-#define OCP_STATUS_OK         0x10000
-#define OCP_STATUS_REQ_FAILED 0x20000
-#define OCP_STATUS_RESP_ERROR 0x30000
-
-void wl1271_spi_disable_interrupts(struct wl1271 *wl);
-void wl1271_spi_enable_interrupts(struct wl1271 *wl);
-
-/* Raw target IO, address is not translated */
-void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
-		      size_t len, bool fixed);
-void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
-		     size_t len, bool fixed);
-
-/* INIT and RESET words */
-void wl1271_spi_reset(struct wl1271 *wl);
-void wl1271_spi_init(struct wl1271 *wl);
-#endif /* __WL1271_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.c b/drivers/net/wireless/wl12xx/wl1271_testmode.c
index 3919102..2401e60 100644
--- a/drivers/net/wireless/wl12xx/wl1271_testmode.c
+++ b/drivers/net/wireless/wl12xx/wl1271_testmode.c
@@ -25,7 +25,6 @@
 #include <net/genetlink.h>
 
 #include "wl1271.h"
-#include "wl1271_spi.h"
 #include "wl1271_acx.h"
 
 #define WL1271_TM_MAX_DATA_LENGTH 1024
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 811e739..2b7dd9b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 
 #include "wl1271.h"
-#include "wl1271_spi.h"
 #include "wl1271_io.h"
 #include "wl1271_reg.h"
 #include "wl1271_ps.h"
-- 
1.6.3.3

