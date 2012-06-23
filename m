Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:50036 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258Ab2FWGmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:01 -0400
Received: by lbbgm6 with SMTP id gm6so4535913lbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:41:58 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 04/18] wlcore: Change raw io functions to return errors
Date: Sat, 23 Jun 2012 09:41:15 +0300
Message-Id: <1340433689-24320-5-git-send-email-coelho@ti.com> (sfid-20120623_084208_422593_A2999A8B)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Make wl1271_raw_write and wl1271_raw_read return errors so the driver
could handle these appropriately.
Since the prototype has changed, also rename the prefix of these
functions to wlcore.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/io.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index bbaf711..60b9503 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -53,33 +53,33 @@ void wl1271_io_init(struct wl1271 *wl);
 int wlcore_translate_addr(struct wl1271 *wl, int addr);
 
 /* Raw target IO, address is not translated */
-static inline void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
-				    size_t len, bool fixed)
+static inline int wlcore_raw_write(struct wl1271 *wl, int addr, void *buf,
+				   size_t len, bool fixed)
 {
-	wl->if_ops->write(wl->dev, addr, buf, len, fixed);
+	return wl->if_ops->write(wl->dev, addr, buf, len, fixed);
 }
 
-static inline void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
-				   size_t len, bool fixed)
+static inline int wlcore_raw_read(struct wl1271 *wl, int addr, void *buf,
+				  size_t len, bool fixed)
 {
-	wl->if_ops->read(wl->dev, addr, buf, len, fixed);
+	return wl->if_ops->read(wl->dev, addr, buf, len, fixed);
 }
 
 static inline void wlcore_raw_read_data(struct wl1271 *wl, int reg, void *buf,
 					size_t len, bool fixed)
 {
-	wl1271_raw_read(wl, wl->rtable[reg], buf, len, fixed);
+	wlcore_raw_read(wl, wl->rtable[reg], buf, len, fixed);
 }
 
 static inline void wlcore_raw_write_data(struct wl1271 *wl, int reg, void *buf,
 					 size_t len, bool fixed)
 {
-	wl1271_raw_write(wl, wl->rtable[reg], buf, len, fixed);
+	wlcore_raw_write(wl, wl->rtable[reg], buf, len, fixed);
 }
 
 static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
 {
-	wl1271_raw_read(wl, addr, &wl->buffer_32,
+	wlcore_raw_read(wl, addr, &wl->buffer_32,
 			    sizeof(wl->buffer_32), false);
 
 	return le32_to_cpu(wl->buffer_32);
@@ -88,7 +88,7 @@ static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
 static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
 {
 	wl->buffer_32 = cpu_to_le32(val);
-	wl1271_raw_write(wl, addr, &wl->buffer_32,
+	wlcore_raw_write(wl, addr, &wl->buffer_32,
 			     sizeof(wl->buffer_32), false);
 }
 
@@ -99,7 +99,7 @@ static inline void wl1271_read(struct wl1271 *wl, int addr, void *buf,
 
 	physical = wlcore_translate_addr(wl, addr);
 
-	wl1271_raw_read(wl, physical, buf, len, fixed);
+	wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
 static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
@@ -109,7 +109,7 @@ static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
 
 	physical = wlcore_translate_addr(wl, addr);
 
-	wl1271_raw_write(wl, physical, buf, len, fixed);
+	wlcore_raw_write(wl, physical, buf, len, fixed);
 }
 
 static inline void wlcore_write_data(struct wl1271 *wl, int reg, void *buf,
@@ -135,7 +135,7 @@ static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
 
 	physical = wlcore_translate_addr(wl, addr);
 
-	wl1271_raw_read(wl, physical, buf, len, fixed);
+	wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
 static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
-- 
1.7.10

