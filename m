Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19647 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404AbZHGKdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:33:24 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 04/23] wl1251: introduce wl1251_if_operations struct
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:33:11 +0300
Message-ID: <20090807103310.31717.28235.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Introduce an ops struct with read, write, and reset functions to
abstract away the details of the wl1251 bus interface.  Doing this
will allow SDIO to coexist with SPI by supplying its own I/O
routines.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h      |    7 +++++++
 drivers/net/wireless/wl12xx/wl1251_boot.c |    1 +
 drivers/net/wireless/wl12xx/wl1251_io.c   |    4 ++--
 drivers/net/wireless/wl12xx/wl1251_io.h   |    9 ++-------
 drivers/net/wireless/wl12xx/wl1251_main.c |    6 ++++--
 drivers/net/wireless/wl12xx/wl1251_ops.c  |    1 +
 drivers/net/wireless/wl12xx/wl1251_spi.c  |   23 +++++++++++++++++++----
 drivers/net/wireless/wl12xx/wl1251_spi.h  |    3 ---
 8 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 665aca0..284bb50 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -281,11 +281,18 @@ struct wl1251_debugfs {
 	struct dentry *excessive_retries;
 };
 
+struct wl1251_if_operations {
+	void (*read)(struct wl1251 *wl, int addr, void *buf, size_t len);
+	void (*write)(struct wl1251 *wl, int addr, void *buf, size_t len);
+	void (*reset)(struct wl1251 *wl);
+};
+
 struct wl1251 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
 	struct spi_device *spi;
+	struct wl1251_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
 	int irq;
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 5702398..5c6f327 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -26,6 +26,7 @@
 #include "reg.h"
 #include "wl1251_boot.h"
 #include "wl1251_io.h"
+#include "wl1251_spi.h"
 #include "wl1251_event.h"
 
 static void wl1251_boot_enable_interrupts(struct wl1251 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.c b/drivers/net/wireless/wl12xx/wl1251_io.c
index 1fa2674..bc95785 100644
--- a/drivers/net/wireless/wl12xx/wl1251_io.c
+++ b/drivers/net/wireless/wl12xx/wl1251_io.c
@@ -53,7 +53,7 @@ void wl1251_mem_read(struct wl1251 *wl, int addr, void *buf, size_t len)
 
 	physical = wl1251_translate_mem_addr(wl, addr);
 
-	wl1251_spi_read(wl, physical, buf, len);
+	wl->if_ops->read(wl, physical, buf, len);
 }
 
 void wl1251_mem_write(struct wl1251 *wl, int addr, void *buf, size_t len)
@@ -62,7 +62,7 @@ void wl1251_mem_write(struct wl1251 *wl, int addr, void *buf, size_t len)
 
 	physical = wl1251_translate_mem_addr(wl, addr);
 
-	wl1251_spi_write(wl, physical, buf, len);
+	wl->if_ops->write(wl, physical, buf, len);
 }
 
 u32 wl1251_mem_read32(struct wl1251 *wl, int addr)
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.h b/drivers/net/wireless/wl12xx/wl1251_io.h
index e2bb954..1fa2ab1 100644
--- a/drivers/net/wireless/wl12xx/wl1251_io.h
+++ b/drivers/net/wireless/wl12xx/wl1251_io.h
@@ -22,24 +22,19 @@
 #define __WL1251_IO_H__
 
 #include "wl1251.h"
-#include "wl1251_spi.h"
-
-/* Raw target IO, address is not translated */
-void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf, size_t len);
-void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len);
 
 static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
 {
 	u32 response;
 
-	wl1251_spi_read(wl, addr, &response, sizeof(u32));
+	wl->if_ops->read(wl, addr, &response, sizeof(u32));
 
 	return response;
 }
 
 static inline void wl1251_write32(struct wl1251 *wl, int addr, u32 val)
 {
-	wl1251_spi_write(wl, addr, &val, sizeof(u32));
+	wl->if_ops->write(wl, addr, &val, sizeof(u32));
 }
 
 /* Memory target IO, address is translated to partition 0 */
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 953cdb4..0f30d0a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -168,8 +168,7 @@ static int wl1251_chip_wakeup(struct wl1251 *wl)
 
 	wl1251_power_on(wl);
 	msleep(wl->chip.power_on_sleep);
-	wl1251_spi_reset(wl);
-	wl1251_spi_init(wl);
+	wl->if_ops->reset(wl);
 
 	/* We don't need a real memory partition here, because we only want
 	 * to use the registers at this point. */
@@ -1192,6 +1191,8 @@ static int wl1251_init_ieee80211(struct wl1251 *wl)
 	return 0;
 }
 
+extern struct wl1251_if_operations wl1251_spi_ops;
+
 #define WL1251_DEFAULT_CHANNEL 1
 static int __devinit wl1251_probe(struct spi_device *spi)
 {
@@ -1219,6 +1220,7 @@ static int __devinit wl1251_probe(struct spi_device *spi)
 	wl->hw = hw;
 	dev_set_drvdata(&spi->dev, wl);
 	wl->spi = spi;
+	wl->if_ops = &wl1251_spi_ops;
 
 	wl->data_in_count = 0;
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.c b/drivers/net/wireless/wl12xx/wl1251_ops.c
index 506123f..758280a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.c
@@ -27,6 +27,7 @@
 #include "wl1251_ops.h"
 #include "reg.h"
 #include "wl1251_io.h"
+#include "wl1251_spi.h"
 #include "wl1251_boot.h"
 #include "wl1251_event.h"
 #include "wl1251_acx.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 031a3ba..61a0852 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -29,7 +29,7 @@
 #include "reg.h"
 #include "wl1251_spi.h"
 
-void wl1251_spi_reset(struct wl1251 *wl)
+static void wl1251_spi_reset(struct wl1251 *wl)
 {
 	u8 *cmd;
 	struct spi_transfer t;
@@ -55,7 +55,7 @@ void wl1251_spi_reset(struct wl1251 *wl)
 	wl1251_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-void wl1251_spi_init(struct wl1251 *wl)
+static void wl1251_spi_init(struct wl1251 *wl)
 {
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
@@ -109,6 +109,13 @@ void wl1251_spi_init(struct wl1251 *wl)
 	wl1251_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
+static void wl1251_spi_reset_wake(struct wl1251 *wl)
+{
+	wl1251_spi_reset(wl);
+	wl1251_spi_init(wl);
+}
+
+
 /* Set the SPI partitions to access the chip addresses
  *
  * There are two VIRTUAL (SPI) partitions (the memory partition and the
@@ -232,7 +239,8 @@ int wl1251_set_partition(struct wl1251 *wl,
 	return 0;
 }
 
-void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf, size_t len)
+static void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
+			    size_t len)
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
@@ -271,7 +279,8 @@ void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf, size_t len)
 	wl1251_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
 }
 
-void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len)
+static void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
+			     size_t len)
 {
 	struct spi_transfer t[2];
 	struct spi_message m;
@@ -300,3 +309,9 @@ void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len)
 	wl1251_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
 	wl1251_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
+
+const struct wl1251_if_operations wl1251_spi_ops = {
+	.read = wl1251_spi_read,
+	.write = wl1251_spi_write,
+	.reset = wl1251_spi_reset_wake,
+};
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl12xx/wl1251_spi.h
index ca9a851..7c6da21 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.h
@@ -69,9 +69,6 @@
 		((WL1251_BUSY_WORD_LEN - 4) / sizeof(u32))
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
-/* INIT and RESET words */
-void wl1251_spi_reset(struct wl1251 *wl);
-void wl1251_spi_init(struct wl1251 *wl);
 int wl1251_set_partition(struct wl1251 *wl,
 			 u32 part_start, u32 part_size,
 			 u32 reg_start,  u32 reg_size);

