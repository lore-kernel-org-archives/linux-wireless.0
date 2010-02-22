Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20502 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab0BVGlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:25 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 04/22] wl1271: Inlined IO functions
Date: Mon, 22 Feb 2010 08:38:24 +0200
Message-Id: <1266820722-20202-5-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Changed IO functions to static inline.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_io.c  |   70 ----------------------
 drivers/net/wireless/wl12xx/wl1271_io.h  |   96 ++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl1271_spi.c |    2 +-
 3 files changed, 78 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/wl1271_io.c
index d00f7ed..c082658 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.c
+++ b/drivers/net/wireless/wl12xx/wl1271_io.c
@@ -31,11 +31,6 @@
 #include "wl1271_spi.h"
 #include "wl1271_io.h"
 
-struct device *wl1271_wl_to_dev(struct wl1271 *wl)
-{
-	return wl->if_ops->dev(wl);
-}
-
 void wl1271_disable_interrupts(struct wl1271 *wl)
 {
 	wl->if_ops->disable_irq(wl);
@@ -46,29 +41,6 @@ void wl1271_enable_interrupts(struct wl1271 *wl)
 	wl->if_ops->enable_irq(wl);
 }
 
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
-
 /* Set the SPI partitions to access the chip addresses
  *
  * To simplify driver code, a fixed (virtual) memory map is defined for
@@ -140,48 +112,6 @@ void wl1271_io_init(struct wl1271 *wl)
 	wl->if_ops->init(wl);
 }
 
-void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
-		      size_t len, bool fixed)
-{
-	wl->if_ops->write(wl, addr, buf, len, fixed);
-}
-
-void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
-		     size_t len, bool fixed)
-{
-	wl->if_ops->read(wl, addr, buf, len, fixed);
-}
-
-void wl1271_read(struct wl1271 *wl, int addr, void *buf, size_t len,
-		     bool fixed)
-{
-	int physical;
-
-	physical = wl1271_translate_addr(wl, addr);
-
-	wl1271_raw_read(wl, physical, buf, len, fixed);
-}
-
-void wl1271_write(struct wl1271 *wl, int addr, void *buf, size_t len,
-		  bool fixed)
-{
-	int physical;
-
-	physical = wl1271_translate_addr(wl, addr);
-
-	wl1271_raw_write(wl, physical, buf, len, fixed);
-}
-
-u32 wl1271_read32(struct wl1271 *wl, int addr)
-{
-	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
-}
-
-void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
-{
-	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
-}
-
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 {
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index f2b6325..8501898 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -33,28 +33,24 @@ void wl1271_enable_interrupts(struct wl1271 *wl);
 void wl1271_io_reset(struct wl1271 *wl);
 void wl1271_io_init(struct wl1271 *wl);
 
-struct device *wl1271_wl_to_dev(struct wl1271 *wl);
-
-/* Raw target IO, address is not translated */
-void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
-		      size_t len, bool fixed);
-void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
-		     size_t len, bool fixed);
+static inline struct device *wl1271_wl_to_dev(struct wl1271 *wl)
+{
+	return wl->if_ops->dev(wl);
+}
 
-/* Translated target IO */
-void wl1271_read(struct wl1271 *wl, int addr, void *buf, size_t len,
-		     bool fixed);
-void wl1271_write(struct wl1271 *wl, int addr, void *buf, size_t len,
-		      bool fixed);
-u32 wl1271_read32(struct wl1271 *wl, int addr);
-void wl1271_write32(struct wl1271 *wl, int addr, u32 val);
 
-/* Top Register IO */
-void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
-u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
+/* Raw target IO, address is not translated */
+static inline void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
+				    size_t len, bool fixed)
+{
+	wl->if_ops->write(wl, addr, buf, len, fixed);
+}
 
-int wl1271_set_partition(struct wl1271 *wl,
-			 struct wl1271_partition_set *p);
+static inline void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
+				   size_t len, bool fixed)
+{
+	wl->if_ops->read(wl, addr, buf, len, fixed);
+}
 
 static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
 {
@@ -71,6 +67,68 @@ static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
 			     sizeof(wl->buffer_32), false);
 }
 
+/* Translated target IO */
+static inline int wl1271_translate_addr(struct wl1271 *wl, int addr)
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
+static inline void wl1271_read(struct wl1271 *wl, int addr, void *buf,
+			       size_t len, bool fixed)
+{
+	int physical;
+
+	physical = wl1271_translate_addr(wl, addr);
+
+	wl1271_raw_read(wl, physical, buf, len, fixed);
+}
+
+static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
+				size_t len, bool fixed)
+{
+	int physical;
+
+	physical = wl1271_translate_addr(wl, addr);
+
+	wl1271_raw_write(wl, physical, buf, len, fixed);
+}
+
+static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
+{
+	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
+}
+
+static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
+{
+	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
+}
+
+
+/* Top Register IO */
+void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
+u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
+
+int wl1271_set_partition(struct wl1271 *wl,
+			 struct wl1271_partition_set *p);
+
 /* Functions from wl1271_main.c */
 
 int wl1271_register_hw(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index a0f4169..f89e1b3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -33,7 +33,7 @@
 #include "wl1271_spi.h"
 #include "wl1271_io.h"
 
-static struct spi_device *wl_to_spi(struct wl1271 *wl)
+static inline struct spi_device *wl_to_spi(struct wl1271 *wl)
 {
 	return wl->if_priv;
 }
-- 
1.6.3.3

