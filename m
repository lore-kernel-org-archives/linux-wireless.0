Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54767 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965396Ab1JGLfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:35:12 -0400
Received: by mail-bw0-f52.google.com with SMTP id 5so4378321bke.25
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 04:35:11 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 2/2] wl12xx: spi: use dev_err instead of wl1271_error
Date: Fri,  7 Oct 2011 14:34:57 +0300
Message-Id: <1317987297-18172-2-git-send-email-coelho@ti.com> (sfid-20111007_133520_649429_AA12A2E0)
In-Reply-To: <1317987297-18172-1-git-send-email-coelho@ti.com>
References: <1317987297-18172-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prevent a useless dependency between the spi module and the wl12xx
module, we need to replace the wl1271_error macros with dev_err.

At the same time, remove the SPI data hexdump, since this produces way
too much data and is not particularly useful.  There's no
print_hex_dump() equivalent for dynamic debug, so it's hard to control
when the dumps are printed out.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/spi.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index bcc7d7c..976d3d5 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 
 #include "wl12xx.h"
-#include "debug.h"
 #include "wl12xx_80211.h"
 #include "io.h"
 
@@ -85,7 +84,8 @@ static void wl12xx_spi_reset(struct device *child)
 
 	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 	if (!cmd) {
-		wl1271_error("could not allocate cmd for spi reset");
+		dev_err(child->parent,
+			"could not allocate cmd for spi reset\n");
 		return;
 	}
 
@@ -100,7 +100,6 @@ static void wl12xx_spi_reset(struct device *child)
 
 	spi_sync(to_spi_device(glue->dev), &m);
 
-	wl1271_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 	kfree(cmd);
 }
 
@@ -113,7 +112,8 @@ static void wl12xx_spi_init(struct device *child)
 
 	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 	if (!cmd) {
-		wl1271_error("could not allocate cmd for spi init");
+		dev_err(child->parent,
+			"could not allocate cmd for spi init\n");
 		return;
 	}
 
@@ -155,7 +155,6 @@ static void wl12xx_spi_init(struct device *child)
 	spi_message_add_tail(&t, &m);
 
 	spi_sync(to_spi_device(glue->dev), &m);
-	wl1271_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 	kfree(cmd);
 }
 
@@ -192,7 +191,7 @@ static int wl12xx_spi_read_busy(struct device *child)
 	}
 
 	/* The SPI bus is unresponsive, the read failed. */
-	wl1271_error("SPI read busy-word timeout!\n");
+	dev_err(child->parent, "SPI read busy-word timeout!\n");
 	return -ETIMEDOUT;
 }
 
@@ -254,9 +253,6 @@ static void wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
 
 		spi_sync(to_spi_device(glue->dev), &m);
 
-		wl1271_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
-		wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, chunk_len);
-
 		if (!fixed)
 			addr += chunk_len;
 		buf += chunk_len;
@@ -302,9 +298,6 @@ static void wl12xx_spi_raw_write(struct device *child, int addr, void *buf,
 		t[i].len = chunk_len;
 		spi_message_add_tail(&t[i++], &m);
 
-		wl1271_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
-		wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, chunk_len);
-
 		if (!fixed)
 			addr += chunk_len;
 		buf += chunk_len;
@@ -332,7 +325,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	pdata = spi->dev.platform_data;
 	if (!pdata) {
-		wl1271_error("no platform data");
+		dev_err(&spi->dev, "no platform data\n");
 		return -ENODEV;
 	}
 
@@ -340,7 +333,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
-		wl1271_error("can't allocate glue");
+		dev_err(&spi->dev, "can't allocate glue\n");
 		goto out;
 	}
 
@@ -354,13 +347,13 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	ret = spi_setup(spi);
 	if (ret < 0) {
-		wl1271_error("spi_setup failed");
+		dev_err(glue->dev, "spi_setup failed\n");
 		goto out_free_glue;
 	}
 
 	glue->core = platform_device_alloc("wl12xx-spi", -1);
 	if (!glue->core) {
-		wl1271_error("can't allocate platform_device");
+		dev_err(glue->dev, "can't allocate platform_device\n");
 		ret = -ENOMEM;
 		goto out_free_glue;
 	}
@@ -375,19 +368,19 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
 	if (ret) {
-		wl1271_error("can't add resources");
+		dev_err(glue->dev, "can't add resources\n");
 		goto out_dev_put;
 	}
 
 	ret = platform_device_add_data(glue->core, pdata, sizeof(*pdata));
 	if (ret) {
-		wl1271_error("can't add platform data");
+		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
 	}
 
 	ret = platform_device_add(glue->core);
 	if (ret) {
-		wl1271_error("can't register platform device");
+		dev_err(glue->dev, "can't register platform device\n");
 		goto out_dev_put;
 	}
 
-- 
1.7.1

