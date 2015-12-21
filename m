Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11614 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbLUFRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:17:51 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 28/46] staging: wilc1000: remove unneeded function
Date: Mon, 21 Dec 2015 14:18:32 +0900
Message-ID: <1450675130-17866-29-git-send-email-glen.lee@atmel.com> (sfid-20151221_063107_913175_37FE69CD)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_spi_init in linux_wlan_spi.c is unneeded. It just return true. Rename
_wilc_spi_init in wlan_spi.c to wilc_spi_init.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c |  5 -----
 drivers/staging/wilc1000/linux_wlan_spi.h |  1 -
 drivers/staging/wilc1000/wilc_spi.c       | 11 ++---------
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index e9ad33f..06935cf 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -61,11 +61,6 @@ struct spi_driver wilc1000_spi_driver = {
 module_spi_driver(wilc1000_spi_driver);
 MODULE_LICENSE("GPL");
 
-int wilc_spi_init(void)
-{
-	return 1;
-}
-
 int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 5ff070b..d41c16a 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -4,7 +4,6 @@
 #include <linux/spi/spi.h>
 #include "wilc_wfi_netdevice.h"
 
-int wilc_spi_init(void);
 int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len);
 int wilc_spi_rx(struct wilc *wilc, u8 *rb, u32 rlen);
 int wilc_spi_tx_rx(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen);
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index ce12d29..0f730cd 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -676,7 +676,7 @@ static int _wilc_spi_deinit(struct wilc *wilc)
 	return 1;
 }
 
-static int _wilc_spi_init(struct wilc *wilc)
+static int wilc_spi_init(struct wilc *wilc)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
@@ -695,13 +695,6 @@ static int _wilc_spi_init(struct wilc *wilc)
 
 	memset(&g_spi, 0, sizeof(wilc_spi_t));
 
-	if (!wilc_spi_init()) {
-		dev_err(&spi->dev, "Failed io init bus...\n");
-		return 0;
-	} else {
-		return 0;
-	}
-
 	/**
 	 *      configure protocol
 	 **/
@@ -994,7 +987,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
  *
  ********************************************/
 const struct wilc_hif_func wilc_hif_spi = {
-	.hif_init = _wilc_spi_init,
+	.hif_init = wilc_spi_init,
 	.hif_deinit = _wilc_spi_deinit,
 	.hif_read_reg = wilc_spi_read_reg,
 	.hif_write_reg = wilc_spi_write_reg,
-- 
1.9.1

