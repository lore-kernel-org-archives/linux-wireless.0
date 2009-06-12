Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63947 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFLLQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:34 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 16/33] wl12xx: Add support for block reading from a fixed
	register address
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:00 +0300
Message-ID: <20090612111559.8877.68284.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add support for block reading (multiple bytes) from a fixed chipset
register address. This is required for the wl1271 TX data path.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/spi.c |   12 ++++++++----
 drivers/net/wireless/wl12xx/spi.h |    9 ++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index c3d5b73..9c9943f 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -301,7 +301,7 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 }
 
 void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
-		      size_t len)
+		      size_t len, bool fixed)
 {
 	struct spi_transfer t[2];
 	struct spi_message m;
@@ -314,6 +314,9 @@ void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
 	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
+	if (fixed)
+		*cmd |= WSPI_CMD_FIXED;
+
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
@@ -348,7 +351,7 @@ void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
 
 	physical = wl12xx_translate_mem_addr(wl, addr);
 
-	wl12xx_spi_write(wl, physical, buf, len);
+	wl12xx_spi_write(wl, physical, buf, len, false);
 }
 
 void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
@@ -361,13 +364,14 @@ void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
 	wl12xx_spi_read(wl, physical, buf, len, fixed);
 }
 
-void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len)
+void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
+			  bool fixed)
 {
 	int physical;
 
 	physical = wl12xx_translate_reg_addr(wl, addr);
 
-	wl12xx_spi_write(wl, physical, buf, len);
+	wl12xx_spi_write(wl, physical, buf, len, fixed);
 }
 
 u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index 30f9098..e48a552 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -71,7 +71,8 @@
 
 
 /* Raw target IO, address is not translated */
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
+		      size_t len, bool fixed);
 void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 		     size_t len, bool fixed);
 
@@ -84,7 +85,8 @@ void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
 /* Registers IO */
 void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
 			 bool fixed);
-void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf,size_t len);
+void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
+			  bool fixed);
 u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
 void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
 
@@ -106,7 +108,8 @@ static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
 static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
 {
 	wl->buffer_32 = val;
-	wl12xx_spi_write(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
+	wl12xx_spi_write(wl, addr, &wl->buffer_32,
+			 sizeof(wl->buffer_32), false);
 }
 
 #endif /* __WL12XX_SPI_H__ */

