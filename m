Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:57937 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab2FWGmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:11 -0400
Received: by lbgc1 with SMTP id c1so3794537lbg.15
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:08 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 11/18] wlcore: Force checking of io functions' return values
Date: Sat, 23 Jun 2012 09:41:22 +0300
Message-Id: <1340433689-24320-12-git-send-email-coelho@ti.com> (sfid-20120623_084225_858170_70D48C16)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

All io functions' return values should be propagated and handled. Add a
__must_check annotation to verify that the return values are checked and
to avoid future mistakes.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |    6 ++-
 drivers/net/wireless/ti/wl18xx/io.h       |    4 +-
 drivers/net/wireless/ti/wlcore/io.h       |   61 +++++++++++++++++------------
 drivers/net/wireless/ti/wlcore/sdio.c     |    8 ++--
 drivers/net/wireless/ti/wlcore/spi.c      |    8 ++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    8 ++--
 6 files changed, 55 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 3a4ab65..47ba2e0 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -688,7 +688,8 @@ out:
 	return ret;
 }
 
-static int wl12xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
+static int __must_check wl12xx_top_reg_write(struct wl1271 *wl, int addr,
+					     u16 val)
 {
 	int ret;
 
@@ -712,7 +713,8 @@ out:
 	return ret;
 }
 
-static int wl12xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out)
+static int __must_check wl12xx_top_reg_read(struct wl1271 *wl, int addr,
+					    u16 *out)
 {
 	u32 val;
 	int timeout = OCP_CMD_LOOP;
diff --git a/drivers/net/wireless/ti/wl18xx/io.h b/drivers/net/wireless/ti/wl18xx/io.h
index 0e1b8d2..c32ae30 100644
--- a/drivers/net/wireless/ti/wl18xx/io.h
+++ b/drivers/net/wireless/ti/wl18xx/io.h
@@ -22,7 +22,7 @@
 #ifndef __WL18XX_IO_H__
 #define __WL18XX_IO_H__
 
-int wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val);
-int wl18xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out);
+int __must_check wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val);
+int __must_check wl18xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out);
 
 #endif /* __WL18XX_IO_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 4a6688b..1cd545b 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -53,31 +53,36 @@ void wl1271_io_init(struct wl1271 *wl);
 int wlcore_translate_addr(struct wl1271 *wl, int addr);
 
 /* Raw target IO, address is not translated */
-static inline int wlcore_raw_write(struct wl1271 *wl, int addr, void *buf,
-				   size_t len, bool fixed)
+static inline int __must_check wlcore_raw_write(struct wl1271 *wl, int addr,
+						void *buf, size_t len,
+						bool fixed)
 {
 	return wl->if_ops->write(wl->dev, addr, buf, len, fixed);
 }
 
-static inline int wlcore_raw_read(struct wl1271 *wl, int addr, void *buf,
-				  size_t len, bool fixed)
+static inline int __must_check wlcore_raw_read(struct wl1271 *wl, int addr,
+					       void *buf, size_t len,
+					       bool fixed)
 {
 	return wl->if_ops->read(wl->dev, addr, buf, len, fixed);
 }
 
-static inline int wlcore_raw_read_data(struct wl1271 *wl, int reg, void *buf,
-				       size_t len, bool fixed)
+static inline int __must_check wlcore_raw_read_data(struct wl1271 *wl, int reg,
+						    void *buf, size_t len,
+						    bool fixed)
 {
 	return wlcore_raw_read(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline int wlcore_raw_write_data(struct wl1271 *wl, int reg, void *buf,
-					size_t len, bool fixed)
+static inline int __must_check wlcore_raw_write_data(struct wl1271 *wl, int reg,
+						     void *buf, size_t len,
+						     bool fixed)
 {
 	return wlcore_raw_write(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline int wlcore_raw_read32(struct wl1271 *wl, int addr, u32 *val)
+static inline int __must_check wlcore_raw_read32(struct wl1271 *wl, int addr,
+						 u32 *val)
 {
 	int ret;
 
@@ -92,15 +97,16 @@ static inline int wlcore_raw_read32(struct wl1271 *wl, int addr, u32 *val)
 	return 0;
 }
 
-static inline int wlcore_raw_write32(struct wl1271 *wl, int addr, u32 val)
+static inline int __must_check wlcore_raw_write32(struct wl1271 *wl, int addr,
+						  u32 val)
 {
 	wl->buffer_32 = cpu_to_le32(val);
 	return wlcore_raw_write(wl, addr, &wl->buffer_32,
 				sizeof(wl->buffer_32), false);
 }
 
-static inline int wlcore_read(struct wl1271 *wl, int addr, void *buf,
-			      size_t len, bool fixed)
+static inline int __must_check wlcore_read(struct wl1271 *wl, int addr,
+					   void *buf, size_t len, bool fixed)
 {
 	int physical;
 
@@ -109,8 +115,8 @@ static inline int wlcore_read(struct wl1271 *wl, int addr, void *buf,
 	return wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
-static inline int wlcore_write(struct wl1271 *wl, int addr, void *buf,
-			       size_t len, bool fixed)
+static inline int __must_check wlcore_write(struct wl1271 *wl, int addr,
+					    void *buf, size_t len, bool fixed)
 {
 	int physical;
 
@@ -119,20 +125,23 @@ static inline int wlcore_write(struct wl1271 *wl, int addr, void *buf,
 	return wlcore_raw_write(wl, physical, buf, len, fixed);
 }
 
-static inline int wlcore_write_data(struct wl1271 *wl, int reg, void *buf,
-				    size_t len, bool fixed)
+static inline int __must_check wlcore_write_data(struct wl1271 *wl, int reg,
+						 void *buf, size_t len,
+						 bool fixed)
 {
 	return wlcore_write(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline int wlcore_read_data(struct wl1271 *wl, int reg, void *buf,
-				    size_t len, bool fixed)
+static inline int __must_check wlcore_read_data(struct wl1271 *wl, int reg,
+						void *buf, size_t len,
+						bool fixed)
 {
 	return wlcore_read(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline int wlcore_read_hwaddr(struct wl1271 *wl, int hwaddr,
-				      void *buf, size_t len, bool fixed)
+static inline int __must_check wlcore_read_hwaddr(struct wl1271 *wl, int hwaddr,
+						  void *buf, size_t len,
+						  bool fixed)
 {
 	int physical;
 	int addr;
@@ -145,24 +154,28 @@ static inline int wlcore_read_hwaddr(struct wl1271 *wl, int hwaddr,
 	return wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
-static inline int wlcore_read32(struct wl1271 *wl, int addr, u32 *val)
+static inline int __must_check wlcore_read32(struct wl1271 *wl, int addr,
+					     u32 *val)
 {
 	return wlcore_raw_read32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
-static inline int wlcore_write32(struct wl1271 *wl, int addr, u32 val)
+static inline int __must_check wlcore_write32(struct wl1271 *wl, int addr,
+					      u32 val)
 {
 	return wlcore_raw_write32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
-static inline int wlcore_read_reg(struct wl1271 *wl, int reg, u32 *val)
+static inline int __must_check wlcore_read_reg(struct wl1271 *wl, int reg,
+					       u32 *val)
 {
 	return wlcore_raw_read32(wl,
 				 wlcore_translate_addr(wl, wl->rtable[reg]),
 				 val);
 }
 
-static inline int wlcore_write_reg(struct wl1271 *wl, int reg, u32 val)
+static inline int __must_check wlcore_write_reg(struct wl1271 *wl, int reg,
+						u32 val)
 {
 	return wlcore_raw_write32(wl,
 				  wlcore_translate_addr(wl, wl->rtable[reg]),
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 9069dc9..204e69f 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -71,8 +71,8 @@ static void wl1271_sdio_set_block_size(struct device *child,
 	sdio_release_host(func);
 }
 
-static int wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
-				size_t len, bool fixed)
+static int __must_check wl12xx_sdio_raw_read(struct device *child, int addr,
+					     void *buf, size_t len, bool fixed)
 {
 	int ret;
 	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
@@ -109,8 +109,8 @@ static int wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 	return ret;
 }
 
-static int wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
-				 size_t len, bool fixed)
+static int __must_check wl12xx_sdio_raw_write(struct device *child, int addr,
+					      void *buf, size_t len, bool fixed)
 {
 	int ret;
 	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index d6768e9..6420aba 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -193,8 +193,8 @@ static int wl12xx_spi_read_busy(struct device *child)
 	return -ETIMEDOUT;
 }
 
-static int wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
-			       size_t len, bool fixed)
+static int __must_check wl12xx_spi_raw_read(struct device *child, int addr,
+					    void *buf, size_t len, bool fixed)
 {
 	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
 	struct wl1271 *wl = dev_get_drvdata(child);
@@ -260,8 +260,8 @@ static int wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
 	return 0;
 }
 
-static int wl12xx_spi_raw_write(struct device *child, int addr, void *buf,
-				size_t len, bool fixed)
+static int __must_check wl12xx_spi_raw_write(struct device *child, int addr,
+					     void *buf, size_t len, bool fixed)
 {
 	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
 	struct spi_transfer t[2 * WSPI_MAX_NUM_OF_CHUNKS];
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 5ab31ff..e5a34dd 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -209,10 +209,10 @@ struct wl1271_scan {
 };
 
 struct wl1271_if_operations {
-	int (*read)(struct device *child, int addr, void *buf, size_t len,
-		    bool fixed);
-	int (*write)(struct device *child, int addr, void *buf, size_t len,
-		     bool fixed);
+	int __must_check (*read)(struct device *child, int addr, void *buf,
+				 size_t len, bool fixed);
+	int __must_check (*write)(struct device *child, int addr, void *buf,
+				  size_t len, bool fixed);
 	void (*reset)(struct device *child);
 	void (*init)(struct device *child);
 	int (*power)(struct device *child, bool enable);
-- 
1.7.10

