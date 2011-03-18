Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52942 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755Ab1CROUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:35 -0400
Received: by mail-ww0-f52.google.com with SMTP id 40so4500377wwj.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:07 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 05/14] wl12xx: 1281/1283 support - add block size handling for sdio and spi
Date: Fri, 18 Mar 2011 16:19:20 +0200
Message-Id: <1300457969-19601-6-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the the set_block_size op in the SDIO and in the SPI modules.
Since it is only used with SDIO, just explicitly set the op to NULL in
spi.c

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   18 +++++++++++++++++-
 drivers/net/wireless/wl12xx/spi.c  |    3 ++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 58d0208..55dc6e3 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -51,6 +51,18 @@ static const struct sdio_device_id wl1271_devices[] = {
 };
 MODULE_DEVICE_TABLE(sdio, wl1271_devices);
 
+/* The max SDIO block size is 256 when working with tx padding to SDIO block */
+#define TX_PAD_SDIO_BLK_SIZE                  256
+
+static void wl1271_sdio_set_block_size(struct wl1271 *wl)
+{
+	wl->block_size = TX_PAD_SDIO_BLK_SIZE;
+
+	sdio_claim_host(wl->if_priv);
+	sdio_set_block_size(wl->if_priv, TX_PAD_SDIO_BLK_SIZE);
+	sdio_release_host(wl->if_priv);
+}
+
 static inline struct sdio_func *wl_to_func(struct wl1271 *wl)
 {
 	return wl->if_priv;
@@ -166,6 +178,9 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 
+	/* Set the default block size in case it was modified */
+	sdio_set_block_size(func, 0);
+
 out:
 	return ret;
 }
@@ -203,7 +218,8 @@ static struct wl1271_if_operations sdio_ops = {
 	.power		= wl1271_sdio_set_power,
 	.dev		= wl1271_sdio_wl_to_dev,
 	.enable_irq	= wl1271_sdio_enable_interrupts,
-	.disable_irq	= wl1271_sdio_disable_interrupts
+	.disable_irq	= wl1271_sdio_disable_interrupts,
+	.set_block_size = wl1271_sdio_set_block_size,
 };
 
 static int __devinit wl1271_probe(struct sdio_func *func,
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 2993715..2a57583 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -355,7 +355,8 @@ static struct wl1271_if_operations spi_ops = {
 	.power		= wl1271_spi_set_power,
 	.dev		= wl1271_spi_wl_to_dev,
 	.enable_irq	= wl1271_spi_enable_interrupts,
-	.disable_irq	= wl1271_spi_disable_interrupts
+	.disable_irq	= wl1271_spi_disable_interrupts,
+	.set_block_size = NULL,
 };
 
 static int __devinit wl1271_probe(struct spi_device *spi)
-- 
1.7.1

