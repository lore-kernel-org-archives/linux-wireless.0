Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20535 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:08:37 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/16] staging: wilc1000: remove paltform define PLAT_WMS8304
Date: Wed, 18 Nov 2015 15:11:24 +0900
Message-ID: <1447827097-9436-4-git-send-email-glen.lee@atmel.com> (sfid-20151118_070840_324912_4610FE07)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes PLAT_WMS8304 and it's related codes as well. We will not
use this way of supporting other platform. This will be supported if necessary
by device tree later.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 161 ------------------------------
 1 file changed, 161 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 5e3bff0..bfd3cc3 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -66,88 +66,6 @@ int wilc_spi_init(void)
 	return 1;
 }
 
-#if defined(PLAT_WMS8304)
-#define TXRX_PHASE_SIZE (4096)
-#endif
-
-#if defined(TXRX_PHASE_SIZE)
-
-int wilc_spi_write(u8 *b, u32 len)
-{
-	struct spi_device *spi = to_spi_device(wilc_dev->dev);
-	int ret;
-
-	if (len > 0 && b != NULL) {
-		int i = 0;
-		int blk = len / TXRX_PHASE_SIZE;
-		int remainder = len % TXRX_PHASE_SIZE;
-
-		char *r_buffer = kzalloc(TXRX_PHASE_SIZE, GFP_KERNEL);
-		if (!r_buffer)
-			return -ENOMEM;
-
-		if (blk) {
-			while (i < blk)	{
-				struct spi_message msg;
-				struct spi_transfer tr = {
-					.tx_buf = b + (i * TXRX_PHASE_SIZE),
-					.len = TXRX_PHASE_SIZE,
-					.bits_per_word = 8,
-					.delay_usecs = 0,
-				};
-
-				tr.rx_buf = r_buffer;
-
-				memset(&msg, 0, sizeof(msg));
-				spi_message_init(&msg);
-				msg.spi = spi;
-				msg.is_dma_mapped = USE_SPI_DMA;
-
-				spi_message_add_tail(&tr, &msg);
-				ret = spi_sync(spi, &msg);
-				if (ret < 0) {
-					PRINT_ER("SPI transaction failed\n");
-				}
-				i++;
-
-			}
-		}
-		if (remainder) {
-			struct spi_message msg;
-			struct spi_transfer tr = {
-				.tx_buf = b + (blk * TXRX_PHASE_SIZE),
-				.len = remainder,
-				.bits_per_word = 8,
-				.delay_usecs = 0,
-			};
-			tr.rx_buf = r_buffer;
-
-			memset(&msg, 0, sizeof(msg));
-			spi_message_init(&msg);
-			msg.spi = spi;
-			msg.is_dma_mapped = USE_SPI_DMA;                                /* rachel */
-
-			spi_message_add_tail(&tr, &msg);
-			ret = spi_sync(spi, &msg);
-			if (ret < 0) {
-				PRINT_ER("SPI transaction failed\n");
-			}
-		}
-		kfree(r_buffer);
-	} else {
-		PRINT_ER("can't write data with the following length: %d\n", len);
-		PRINT_ER("FAILED due to NULL buffer or ZERO length check the following length: %d\n", len);
-		ret = -1;
-	}
-
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
-
-	return ret;
-
-}
-
-#else
 int wilc_spi_write(u8 *b, u32 len)
 {
 	struct spi_device *spi = to_spi_device(wilc_dev->dev);
@@ -194,83 +112,6 @@ int wilc_spi_write(u8 *b, u32 len)
 	return ret;
 }
 
-#endif
-
-#if defined(TXRX_PHASE_SIZE)
-
-int wilc_spi_read(u8 *rb, u32 rlen)
-{
-	struct spi_device *spi = to_spi_device(wilc_dev->dev);
-	int ret;
-
-	if (rlen > 0) {
-		int i = 0;
-
-		int blk = rlen / TXRX_PHASE_SIZE;
-		int remainder = rlen % TXRX_PHASE_SIZE;
-
-		char *t_buffer = kzalloc(TXRX_PHASE_SIZE, GFP_KERNEL);
-		if (!t_buffer)
-			return -ENOMEM;
-
-		if (blk) {
-			while (i < blk)	{
-				struct spi_message msg;
-				struct spi_transfer tr = {
-					.rx_buf = rb + (i * TXRX_PHASE_SIZE),
-					.len = TXRX_PHASE_SIZE,
-					.bits_per_word = 8,
-					.delay_usecs = 0,
-				};
-				tr.tx_buf = t_buffer;
-
-				memset(&msg, 0, sizeof(msg));
-				spi_message_init(&msg);
-				msg.spi = spi;
-				msg.is_dma_mapped = USE_SPI_DMA;
-
-				spi_message_add_tail(&tr, &msg);
-				ret = spi_sync(spi, &msg);
-				if (ret < 0) {
-					PRINT_ER("SPI transaction failed\n");
-				}
-				i++;
-			}
-		}
-		if (remainder) {
-			struct spi_message msg;
-			struct spi_transfer tr = {
-				.rx_buf = rb + (blk * TXRX_PHASE_SIZE),
-				.len = remainder,
-				.bits_per_word = 8,
-				.delay_usecs = 0,
-			};
-			tr.tx_buf = t_buffer;
-
-			memset(&msg, 0, sizeof(msg));
-			spi_message_init(&msg);
-			msg.spi = spi;
-			msg.is_dma_mapped = USE_SPI_DMA;                                /* rachel */
-
-			spi_message_add_tail(&tr, &msg);
-			ret = spi_sync(spi, &msg);
-			if (ret < 0) {
-				PRINT_ER("SPI transaction failed\n");
-			}
-		}
-
-		kfree(t_buffer);
-	} else {
-		PRINT_ER("can't read data with the following length: %u\n", rlen);
-		ret = -1;
-	}
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
-
-	return ret;
-}
-
-#else
 int wilc_spi_read(u8 *rb, u32 rlen)
 {
 	struct spi_device *spi = to_spi_device(wilc_dev->dev);
@@ -313,8 +154,6 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 	return ret;
 }
 
-#endif
-
 int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 {
 	struct spi_device *spi = to_spi_device(wilc_dev->dev);
-- 
1.9.1

