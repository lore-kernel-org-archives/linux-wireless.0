Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11629 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbLUFR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:17:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 29/46] staging: wilc1000: linux_wlan_spi.c: move all the codes to wilc_spi.c
Date: Mon, 21 Dec 2015 14:18:33 +0900
Message-ID: <1450675130-17866-30-git-send-email-glen.lee@atmel.com> (sfid-20151221_063105_624803_18566269)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves all the codes in linux_wlan_spi.c to wilc_spi.c to make
one spi module. Make wilc_spi_tx, wilc_spi_rx and wilc_spi_tx_rx static
functions. Remove function declaration in linux_wlan_spi.h, which is unnedded
now. No modification has been made inside the codes.
linux_wlan_spi.[ch] will be remove in the next patch.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 165 ---------------------------
 drivers/staging/wilc1000/linux_wlan_spi.h |   4 -
 drivers/staging/wilc1000/wilc_spi.c       | 180 +++++++++++++++++++++++++++++-
 3 files changed, 178 insertions(+), 171 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 06935cf..c4315f5 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -14,168 +14,3 @@
 #include "wilc_wfi_netdevice.h"
 #include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
-
-#define USE_SPI_DMA     0
-
-static const struct wilc1000_ops wilc1000_spi_ops;
-
-static int wilc_bus_probe(struct spi_device *spi)
-{
-	int ret, gpio;
-	struct wilc *wilc;
-
-	gpio = of_get_gpio(spi->dev.of_node, 0);
-	if (gpio < 0)
-		gpio = GPIO_NUM;
-
-	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM, &wilc_hif_spi);
-	if (ret)
-		return ret;
-
-	spi_set_drvdata(spi, wilc);
-	wilc->dev = &spi->dev;
-
-	return 0;
-}
-
-static int wilc_bus_remove(struct spi_device *spi)
-{
-	wilc_netdev_cleanup(spi_get_drvdata(spi));
-	return 0;
-}
-
-static const struct of_device_id wilc1000_of_match[] = {
-	{ .compatible = "atmel,wilc_spi", },
-	{}
-};
-MODULE_DEVICE_TABLE(of, wilc1000_of_match);
-
-struct spi_driver wilc1000_spi_driver = {
-	.driver = {
-		.name = MODALIAS,
-		.of_match_table = wilc1000_of_match,
-	},
-	.probe =  wilc_bus_probe,
-	.remove = wilc_bus_remove,
-};
-module_spi_driver(wilc1000_spi_driver);
-MODULE_LICENSE("GPL");
-
-int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len)
-{
-	struct spi_device *spi = to_spi_device(wilc->dev);
-	int ret;
-	struct spi_message msg;
-
-	if (len > 0 && b) {
-		struct spi_transfer tr = {
-			.tx_buf = b,
-			.len = len,
-			.delay_usecs = 0,
-		};
-		char *r_buffer = kzalloc(len, GFP_KERNEL);
-
-		if (!r_buffer)
-			return -ENOMEM;
-
-		tr.rx_buf = r_buffer;
-		dev_dbg(&spi->dev, "Request writing %d bytes\n", len);
-
-		memset(&msg, 0, sizeof(msg));
-		spi_message_init(&msg);
-		msg.spi = spi;
-		msg.is_dma_mapped = USE_SPI_DMA;
-		spi_message_add_tail(&tr, &msg);
-
-		ret = spi_sync(spi, &msg);
-		if (ret < 0)
-			dev_err(&spi->dev, "SPI transaction failed\n");
-
-		kfree(r_buffer);
-	} else {
-		dev_err(&spi->dev,
-			"can't write data with the following length: %d\n",
-			len);
-		dev_err(&spi->dev,
-			"FAILED due to NULL buffer or ZERO length check the following length: %d\n",
-			len);
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-int wilc_spi_rx(struct wilc *wilc, u8 *rb, u32 rlen)
-{
-	struct spi_device *spi = to_spi_device(wilc->dev);
-	int ret;
-
-	if (rlen > 0) {
-		struct spi_message msg;
-		struct spi_transfer tr = {
-			.rx_buf = rb,
-			.len = rlen,
-			.delay_usecs = 0,
-
-		};
-		char *t_buffer = kzalloc(rlen, GFP_KERNEL);
-
-		if (!t_buffer)
-			return -ENOMEM;
-
-		tr.tx_buf = t_buffer;
-
-		memset(&msg, 0, sizeof(msg));
-		spi_message_init(&msg);
-		msg.spi = spi;
-		msg.is_dma_mapped = USE_SPI_DMA;
-		spi_message_add_tail(&tr, &msg);
-
-		ret = spi_sync(spi, &msg);
-		if (ret < 0)
-			dev_err(&spi->dev, "SPI transaction failed\n");
-		kfree(t_buffer);
-	} else {
-		dev_err(&spi->dev,
-			"can't read data with the following length: %u\n",
-			rlen);
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-int wilc_spi_tx_rx(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
-{
-	struct spi_device *spi = to_spi_device(wilc->dev);
-	int ret;
-
-	if (rlen > 0) {
-		struct spi_message msg;
-		struct spi_transfer tr = {
-			.rx_buf = rb,
-			.tx_buf = wb,
-			.len = rlen,
-			.bits_per_word = 8,
-			.delay_usecs = 0,
-
-		};
-
-		memset(&msg, 0, sizeof(msg));
-		spi_message_init(&msg);
-		msg.spi = spi;
-		msg.is_dma_mapped = USE_SPI_DMA;
-
-		spi_message_add_tail(&tr, &msg);
-		ret = spi_sync(spi, &msg);
-		if (ret < 0)
-			dev_err(&spi->dev, "SPI transaction failed\n");
-	} else {
-		dev_err(&spi->dev,
-			"can't read data with the following length: %u\n",
-			rlen);
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index d41c16a..32e3926 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -3,8 +3,4 @@
 
 #include <linux/spi/spi.h>
 #include "wilc_wfi_netdevice.h"
-
-int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len);
-int wilc_spi_rx(struct wilc *wilc, u8 *rb, u32 rlen);
-int wilc_spi_tx_rx(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 0f730cd..86de50c 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -6,11 +6,22 @@
 /*  */
 /*  */
 /* //////////////////////////////////////////////////////////////////////////// */
-
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+#include <linux/device.h>
+#include <linux/spi/spi.h>
+#include <linux/of_gpio.h>
+
+#include "linux_wlan_common.h"
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
-#include "linux_wlan_spi.h"
 #include "wilc_wfi_netdevice.h"
 
 typedef struct {
@@ -107,6 +118,171 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 #define DATA_PKT_SZ_8K				(8 * 1024)
 #define DATA_PKT_SZ					DATA_PKT_SZ_8K
 
+#define USE_SPI_DMA     0
+
+static const struct wilc1000_ops wilc1000_spi_ops;
+
+static int wilc_bus_probe(struct spi_device *spi)
+{
+	int ret, gpio;
+	struct wilc *wilc;
+
+	gpio = of_get_gpio(spi->dev.of_node, 0);
+	if (gpio < 0)
+		gpio = GPIO_NUM;
+
+	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM, &wilc_hif_spi);
+	if (ret)
+		return ret;
+
+	spi_set_drvdata(spi, wilc);
+	wilc->dev = &spi->dev;
+
+	return 0;
+}
+
+static int wilc_bus_remove(struct spi_device *spi)
+{
+	wilc_netdev_cleanup(spi_get_drvdata(spi));
+	return 0;
+}
+
+static const struct of_device_id wilc1000_of_match[] = {
+	{ .compatible = "atmel,wilc_spi", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, wilc1000_of_match);
+
+struct spi_driver wilc1000_spi_driver = {
+	.driver = {
+		.name = MODALIAS,
+		.of_match_table = wilc1000_of_match,
+	},
+	.probe =  wilc_bus_probe,
+	.remove = wilc_bus_remove,
+};
+module_spi_driver(wilc1000_spi_driver);
+MODULE_LICENSE("GPL");
+
+static int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len)
+{
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	int ret;
+	struct spi_message msg;
+
+	if (len > 0 && b) {
+		struct spi_transfer tr = {
+			.tx_buf = b,
+			.len = len,
+			.delay_usecs = 0,
+		};
+		char *r_buffer = kzalloc(len, GFP_KERNEL);
+
+		if (!r_buffer)
+			return -ENOMEM;
+
+		tr.rx_buf = r_buffer;
+		dev_dbg(&spi->dev, "Request writing %d bytes\n", len);
+
+		memset(&msg, 0, sizeof(msg));
+		spi_message_init(&msg);
+		msg.spi = spi;
+		msg.is_dma_mapped = USE_SPI_DMA;
+		spi_message_add_tail(&tr, &msg);
+
+		ret = spi_sync(spi, &msg);
+		if (ret < 0)
+			dev_err(&spi->dev, "SPI transaction failed\n");
+
+		kfree(r_buffer);
+	} else {
+		dev_err(&spi->dev,
+			"can't write data with the following length: %d\n",
+			len);
+		dev_err(&spi->dev,
+			"FAILED due to NULL buffer or ZERO length check the following length: %d\n",
+			len);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int wilc_spi_rx(struct wilc *wilc, u8 *rb, u32 rlen)
+{
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	int ret;
+
+	if (rlen > 0) {
+		struct spi_message msg;
+		struct spi_transfer tr = {
+			.rx_buf = rb,
+			.len = rlen,
+			.delay_usecs = 0,
+
+		};
+		char *t_buffer = kzalloc(rlen, GFP_KERNEL);
+
+		if (!t_buffer)
+			return -ENOMEM;
+
+		tr.tx_buf = t_buffer;
+
+		memset(&msg, 0, sizeof(msg));
+		spi_message_init(&msg);
+		msg.spi = spi;
+		msg.is_dma_mapped = USE_SPI_DMA;
+		spi_message_add_tail(&tr, &msg);
+
+		ret = spi_sync(spi, &msg);
+		if (ret < 0)
+			dev_err(&spi->dev, "SPI transaction failed\n");
+		kfree(t_buffer);
+	} else {
+		dev_err(&spi->dev,
+			"can't read data with the following length: %u\n",
+			rlen);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int wilc_spi_tx_rx(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
+{
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	int ret;
+
+	if (rlen > 0) {
+		struct spi_message msg;
+		struct spi_transfer tr = {
+			.rx_buf = rb,
+			.tx_buf = wb,
+			.len = rlen,
+			.bits_per_word = 8,
+			.delay_usecs = 0,
+
+		};
+
+		memset(&msg, 0, sizeof(msg));
+		spi_message_init(&msg);
+		msg.spi = spi;
+		msg.is_dma_mapped = USE_SPI_DMA;
+
+		spi_message_add_tail(&tr, &msg);
+		ret = spi_sync(spi, &msg);
+		if (ret < 0)
+			dev_err(&spi->dev, "SPI transaction failed\n");
+	} else {
+		dev_err(&spi->dev,
+			"can't read data with the following length: %u\n",
+			rlen);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			    u8 clockless)
 {
-- 
1.9.1

