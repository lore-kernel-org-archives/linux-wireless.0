Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:51228 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab2FWGmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:00 -0400
Received: by lbbgo11 with SMTP id go11so4355760lbb.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:41:57 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 03/18] wlcore: Change read/write ops to return errors
Date: Sat, 23 Jun 2012 09:41:14 +0300
Message-Id: <1340433689-24320-4-git-send-email-coelho@ti.com> (sfid-20120623_085130_863536_A9CD2DDA)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

While bus operations may fail, either due to HW or FW issues, these are
never propagated to higher layers. As a result, the core driver has no
way of knowing that the operations failed, and will only recover if high
level logic requires it (e.g. no command completion).

Change read/write bus operations to return errors to let higher layer
functionality handle these.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c     |   16 ++++++++++------
 drivers/net/wireless/ti/wlcore/spi.c      |   14 +++++++++-----
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    6 +++---
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 4edaa20..9069dc9 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -71,8 +71,8 @@ static void wl1271_sdio_set_block_size(struct device *child,
 	sdio_release_host(func);
 }
 
-static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
-				 size_t len, bool fixed)
+static int wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
+				size_t len, bool fixed)
 {
 	int ret;
 	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
@@ -103,12 +103,14 @@ static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 
 	sdio_release_host(func);
 
-	if (ret)
+	if (WARN_ON(ret))
 		dev_err(child->parent, "sdio read failed (%d)\n", ret);
+
+	return ret;
 }
 
-static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
-				  size_t len, bool fixed)
+static int wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
+				 size_t len, bool fixed)
 {
 	int ret;
 	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
@@ -139,8 +141,10 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 
 	sdio_release_host(func);
 
-	if (ret)
+	if (WARN_ON(ret))
 		dev_err(child->parent, "sdio write failed (%d)\n", ret);
+
+	return ret;
 }
 
 static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 553cd3c..d6768e9 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -193,8 +193,8 @@ static int wl12xx_spi_read_busy(struct device *child)
 	return -ETIMEDOUT;
 }
 
-static void wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
-				size_t len, bool fixed)
+static int wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
+			       size_t len, bool fixed)
 {
 	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
 	struct wl1271 *wl = dev_get_drvdata(child);
@@ -238,7 +238,7 @@ static void wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
 		if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1) &&
 		    wl12xx_spi_read_busy(child)) {
 			memset(buf, 0, chunk_len);
-			return;
+			return 0;
 		}
 
 		spi_message_init(&m);
@@ -256,10 +256,12 @@ static void wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
 		buf += chunk_len;
 		len -= chunk_len;
 	}
+
+	return 0;
 }
 
-static void wl12xx_spi_raw_write(struct device *child, int addr, void *buf,
-				 size_t len, bool fixed)
+static int wl12xx_spi_raw_write(struct device *child, int addr, void *buf,
+				size_t len, bool fixed)
 {
 	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
 	struct spi_transfer t[2 * WSPI_MAX_NUM_OF_CHUNKS];
@@ -304,6 +306,8 @@ static void wl12xx_spi_raw_write(struct device *child, int addr, void *buf,
 	}
 
 	spi_sync(to_spi_device(glue->dev), &m);
+
+	return 0;
 }
 
 static struct wl1271_if_operations spi_ops = {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 8260b1e..5ab31ff 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -209,9 +209,9 @@ struct wl1271_scan {
 };
 
 struct wl1271_if_operations {
-	void (*read)(struct device *child, int addr, void *buf, size_t len,
-		     bool fixed);
-	void (*write)(struct device *child, int addr, void *buf, size_t len,
+	int (*read)(struct device *child, int addr, void *buf, size_t len,
+		    bool fixed);
+	int (*write)(struct device *child, int addr, void *buf, size_t len,
 		     bool fixed);
 	void (*reset)(struct device *child);
 	void (*init)(struct device *child);
-- 
1.7.10

