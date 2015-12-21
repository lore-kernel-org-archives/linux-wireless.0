Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11435 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbLUFQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:16:41 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 16/46] staging: wilc1000: linux_wlan_spi.c: remove braces for single statement
Date: Mon, 21 Dec 2015 14:18:20 +0900
Message-ID: <1450675130-17866-17-git-send-email-glen.lee@atmel.com> (sfid-20151221_063104_171397_EF25898D)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches fixes checkpatch warning: braces {} are not necessary for single
statement blocks. Remove some comments also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 01fa6fa..6fcf7b3 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -15,7 +15,7 @@
 #include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
 
-#define USE_SPI_DMA     0       /* johnny add */
+#define USE_SPI_DMA     0
 
 static const struct wilc1000_ops wilc1000_spi_ops;
 
@@ -87,16 +87,13 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
-/* [[johnny add */
 		msg.spi = spi;
 		msg.is_dma_mapped = USE_SPI_DMA;
-/* ]] */
 		spi_message_add_tail(&tr, &msg);
 
 		ret = spi_sync(spi, &msg);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(&spi->dev, "SPI transaction failed\n");
-		}
 
 		kfree(r_buffer);
 	} else {
@@ -137,16 +134,13 @@ int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
 
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
-/* [[ johnny add */
 		msg.spi = spi;
 		msg.is_dma_mapped = USE_SPI_DMA;
-/* ]] */
 		spi_message_add_tail(&tr, &msg);
 
 		ret = spi_sync(spi, &msg);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(&spi->dev, "SPI transaction failed\n");
-		}
 		kfree(t_buffer);
 	} else {
 		dev_err(&spi->dev,
@@ -183,9 +177,8 @@ int wilc_spi_write_read(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
 
 		spi_message_add_tail(&tr, &msg);
 		ret = spi_sync(spi, &msg);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(&spi->dev, "SPI transaction failed\n");
-		}
 	} else {
 		dev_err(&spi->dev,
 			"can't read data with the following length: %u\n",
-- 
1.9.1

