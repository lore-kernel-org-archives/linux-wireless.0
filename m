Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63891 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZFLLQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:01 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 13/33] wl12xx: add support for fixed address in wl12xx_spi_read
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:41 +0300
Message-ID: <20090612111540.8877.71432.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

In the wl1271 implementation, we need to read memory from the register
partition using fixed addresses.  This change adds the possibility to request
fixed address when calling wl12xx_spi_read() or wl12xx_spi_reg_read().

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/spi.c |   12 ++++++++----
 drivers/net/wireless/wl12xx/spi.h |    9 ++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 0d2b13a..c3d5b73 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -258,7 +258,7 @@ int wl12xx_set_partition(struct wl12xx *wl,
 }
 
 void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
-		     size_t len)
+		     size_t len, bool fixed)
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
@@ -273,6 +273,9 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
 	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
+	if (fixed)
+		*cmd |= WSPI_CMD_FIXED;
+
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
@@ -335,7 +338,7 @@ void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf,
 
 	physical = wl12xx_translate_mem_addr(wl, addr);
 
-	wl12xx_spi_read(wl, physical, buf, len);
+	wl12xx_spi_read(wl, physical, buf, len, false);
 }
 
 void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
@@ -348,13 +351,14 @@ void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
 	wl12xx_spi_write(wl, physical, buf, len);
 }
 
-void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len)
+void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
+			 bool fixed)
 {
 	int physical;
 
 	physical = wl12xx_translate_reg_addr(wl, addr);
 
-	wl12xx_spi_read(wl, physical, buf, len);
+	wl12xx_spi_read(wl, physical, buf, len, fixed);
 }
 
 void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len)
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index 0996e48..30f9098 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -71,8 +71,9 @@
 
 
 /* Raw target IO, address is not translated */
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf, size_t len);
 void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
+		     size_t len, bool fixed);
 
 /* Memory target IO, address is tranlated to partition 0 */
 void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len);
@@ -81,7 +82,8 @@ u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
 void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
 
 /* Registers IO */
-void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
+			 bool fixed);
 void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf,size_t len);
 u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
 void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
@@ -95,7 +97,8 @@ int wl12xx_set_partition(struct wl12xx *wl,
 
 static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
 {
-	wl12xx_spi_read(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
+	wl12xx_spi_read(wl, addr, &wl->buffer_32,
+			sizeof(wl->buffer_32), false);
 
 	return wl->buffer_32;
 }

