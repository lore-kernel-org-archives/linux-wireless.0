Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19626 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZHGKdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:33:01 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 01/23] wl1251: remove fixed address support from spi commands
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:32:48 +0300
Message-ID: <20090807103247.31717.58766.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The fixed addresses are not used in wl1251, only in wl1271. So it can
be safely removed.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_spi.c |   26 ++++++++------------------
 drivers/net/wireless/wl12xx/wl1251_spi.h |   18 ++++++------------
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index c5da79d..c2b813f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -255,8 +255,7 @@ int wl1251_set_partition(struct wl1251 *wl,
 	return 0;
 }
 
-void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
-		     size_t len, bool fixed)
+void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf, size_t len)
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
@@ -271,9 +270,6 @@ void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
 	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
 	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
-	if (fixed)
-		*cmd |= WSPI_CMD_FIXED;
-
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
@@ -298,8 +294,7 @@ void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
 	wl1251_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
 }
 
-void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
-		      size_t len, bool fixed)
+void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len)
 {
 	struct spi_transfer t[2];
 	struct spi_message m;
@@ -312,9 +307,6 @@ void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
 	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
 	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
-	if (fixed)
-		*cmd |= WSPI_CMD_FIXED;
-
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
@@ -339,7 +331,7 @@ void wl1251_spi_mem_read(struct wl1251 *wl, int addr, void *buf,
 
 	physical = wl1251_translate_mem_addr(wl, addr);
 
-	wl1251_spi_read(wl, physical, buf, len, false);
+	wl1251_spi_read(wl, physical, buf, len);
 }
 
 void wl1251_spi_mem_write(struct wl1251 *wl, int addr, void *buf,
@@ -349,27 +341,25 @@ void wl1251_spi_mem_write(struct wl1251 *wl, int addr, void *buf,
 
 	physical = wl1251_translate_mem_addr(wl, addr);
 
-	wl1251_spi_write(wl, physical, buf, len, false);
+	wl1251_spi_write(wl, physical, buf, len);
 }
 
-void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len,
-			 bool fixed)
+void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len)
 {
 	int physical;
 
 	physical = wl1251_translate_reg_addr(wl, addr);
 
-	wl1251_spi_read(wl, physical, buf, len, fixed);
+	wl1251_spi_read(wl, physical, buf, len);
 }
 
-void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len,
-			  bool fixed)
+void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len)
 {
 	int physical;
 
 	physical = wl1251_translate_reg_addr(wl, addr);
 
-	wl1251_spi_write(wl, physical, buf, len, fixed);
+	wl1251_spi_write(wl, physical, buf, len);
 }
 
 u32 wl1251_mem_read32(struct wl1251 *wl, int addr)
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl12xx/wl1251_spi.h
index 6e8daf4..7076352 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.h
@@ -71,10 +71,8 @@
 
 
 /* Raw target IO, address is not translated */
-void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
-		      size_t len, bool fixed);
-void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
-		     size_t len, bool fixed);
+void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf, size_t len);
+void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf, size_t len);
 
 /* Memory target IO, address is tranlated to partition 0 */
 void wl1251_spi_mem_read(struct wl1251 *wl, int addr, void *buf, size_t len);
@@ -83,10 +81,8 @@ u32 wl1251_mem_read32(struct wl1251 *wl, int addr);
 void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val);
 
 /* Registers IO */
-void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len,
-			 bool fixed);
-void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len,
-			  bool fixed);
+void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len);
+void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len);
 u32 wl1251_reg_read32(struct wl1251 *wl, int addr);
 void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val);
 
@@ -99,8 +95,7 @@ int wl1251_set_partition(struct wl1251 *wl,
 
 static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
 {
-	wl1251_spi_read(wl, addr, &wl->buffer_32,
-			sizeof(wl->buffer_32), false);
+	wl1251_spi_read(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
 
 	return wl->buffer_32;
 }
@@ -108,8 +103,7 @@ static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
 static inline void wl1251_write32(struct wl1251 *wl, int addr, u32 val)
 {
 	wl->buffer_32 = val;
-	wl1251_spi_write(wl, addr, &wl->buffer_32,
-			 sizeof(wl->buffer_32), false);
+	wl1251_spi_write(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
 }
 
 #endif /* __WL1251_SPI_H__ */

