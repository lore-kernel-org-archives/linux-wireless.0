Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1649 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761646AbZFKCDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 3/7] wl12xx: introduce wl12xx_if_operations struct
Date: Wed, 10 Jun 2009 22:02:56 -0400
Message-Id: <1244685780-28930-4-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce an ops struct with read, write, and reset functions to
abstract away the details of the wl12xx bus interface.  Doing this
will allow SDIO to coexist with SPI by supplying its own I/O
routines.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/io.c     |    4 ++--
 drivers/net/wireless/wl12xx/io.h     |    9 ++-------
 drivers/net/wireless/wl12xx/main.c   |    6 ++++--
 drivers/net/wireless/wl12xx/spi.c    |   24 ++++++++++++++++++------
 drivers/net/wireless/wl12xx/spi.h    |    2 --
 drivers/net/wireless/wl12xx/wl12xx.h |    7 +++++++
 6 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index 15af799..611b644 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -53,7 +53,7 @@ void wl12xx_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len)
 
 	physical = wl12xx_translate_mem_addr(wl, addr);
 
-	wl12xx_spi_read(wl, physical, buf, len);
+	wl->if_ops->read(wl, physical, buf, len);
 }
 
 void wl12xx_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len)
@@ -62,7 +62,7 @@ void wl12xx_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len)
 
 	physical = wl12xx_translate_mem_addr(wl, addr);
 
-	wl12xx_spi_write(wl, physical, buf, len);
+	wl->if_ops->write(wl, physical, buf, len);
 }
 
 u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index 5f96871..ecc18b6 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -22,24 +22,19 @@
 #define __WL12XX_IO_H__
 
 #include "wl12xx.h"
-#include "spi.h"
-
-/* Raw target IO, address is not translated */
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf, size_t len);
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf, size_t len);
 
 static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
 {
 	u32 response;
 
-	wl12xx_spi_read(wl, addr, &response, sizeof(u32));
+	wl->if_ops->read(wl, addr, &response, sizeof(u32));
 
 	return response;
 }
 
 static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
 {
-	wl12xx_spi_write(wl, addr, &val, sizeof(u32));
+	wl->if_ops->write(wl, addr, &val, sizeof(u32));
 }
 
 /* Memory target IO, address is translated to partition 0 */
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 5e975c8..eb4b5da 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -171,8 +171,7 @@ static int wl12xx_chip_wakeup(struct wl12xx *wl)
 
 	wl12xx_power_on(wl);
 	msleep(wl->chip.power_on_sleep);
-	wl12xx_spi_reset(wl);
-	wl12xx_spi_init(wl);
+	wl->if_ops->reset(wl);
 
 	/* We don't need a real memory partition here, because we only want
 	 * to use the registers at this point. */
@@ -1173,6 +1172,8 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 	return 0;
 }
 
+extern struct wl12xx_if_operations wl12xx_spi_ops;
+
 #define WL12XX_DEFAULT_CHANNEL 1
 static int __devinit wl12xx_probe(struct spi_device *spi)
 {
@@ -1200,6 +1201,7 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	wl->hw = hw;
 	dev_set_drvdata(&spi->dev, wl);
 	wl->spi = spi;
+	wl->if_ops = &wl12xx_spi_ops;
 
 	wl->data_in_count = 0;
 
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index aabc487..085755d 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -31,7 +31,7 @@
 #include "spi.h"
 #include "ps.h"
 
-void wl12xx_spi_reset(struct wl12xx *wl)
+static void wl12xx_spi_reset(struct wl12xx *wl)
 {
 	u8 *cmd;
 	struct spi_transfer t;
@@ -57,7 +57,7 @@ void wl12xx_spi_reset(struct wl12xx *wl)
 	wl12xx_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-void wl12xx_spi_init(struct wl12xx *wl)
+static void wl12xx_spi_init(struct wl12xx *wl)
 {
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
@@ -111,6 +111,12 @@ void wl12xx_spi_init(struct wl12xx *wl)
 	wl12xx_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
+static void wl12xx_spi_reset_wake(struct wl12xx *wl)
+{
+	wl12xx_spi_reset(wl);
+	wl12xx_spi_init(wl);
+}
+
 /* Set the SPI partitions to access the chip addresses
  *
  * There are two VIRTUAL (SPI) partitions (the memory partition and the
@@ -228,8 +234,8 @@ void wl12xx_set_partition(struct wl12xx *wl,
 	spi_sync(wl->spi, &m);
 }
 
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
-		     size_t len)
+static void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
+			    size_t len)
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
@@ -265,8 +271,8 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 	wl12xx_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
 }
 
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
-		      size_t len)
+static void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
+			     size_t len)
 {
 	struct spi_transfer t[2];
 	struct spi_message m;
@@ -293,3 +299,9 @@ void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", &cmd, sizeof(cmd));
 	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
+
+const struct wl12xx_if_operations wl12xx_spi_ops = {
+	.read = wl12xx_spi_read,
+	.write = wl12xx_spi_write,
+	.reset = wl12xx_spi_reset_wake,
+};
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index 7c51475..761401b 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -73,8 +73,6 @@
 
 
 /* INIT and RESET words */
-void wl12xx_spi_reset(struct wl12xx *wl);
-void wl12xx_spi_init(struct wl12xx *wl);
 void wl12xx_set_partition(struct wl12xx *wl,
 			  u32 part_start, u32 part_size,
 			  u32 reg_start,  u32 reg_size);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4864143..bfabf8f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -276,11 +276,18 @@ struct wl12xx_debugfs {
 	struct dentry *excessive_retries;
 };
 
+struct wl12xx_if_operations {
+	void (*read)(struct wl12xx *wl, int addr, void *buf, size_t len);
+	void (*write)(struct wl12xx *wl, int addr, void *buf, size_t len);
+	void (*reset)(struct wl12xx *wl);
+};
+
 struct wl12xx {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
 	struct spi_device *spi;
+	struct wl12xx_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
 	int irq;
-- 
1.6.0.6


