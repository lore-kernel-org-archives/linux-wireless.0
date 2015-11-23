Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48678 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbbKWJox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 04:44:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/10] staging: wilc1000: remove wilc_debug_func of hif_init
Date: Mon, 23 Nov 2015 18:48:00 +0900
Message-ID: <1448272088-13973-2-git-send-email-glen.lee@atmel.com> (sfid-20151123_104456_261424_2CE3A2F9)
In-Reply-To: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
References: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes wilc_debug_func of hif_init and remove it's related
functions as well because it is not used anymore.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 +-
 drivers/staging/wilc1000/wilc_spi.c  | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 30dd7f9..c2c10dd 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -512,7 +512,7 @@ static int sdio_sync(struct wilc *wilc)
 	return 1;
 }
 
-static int sdio_init(struct wilc *wilc, wilc_debug_func debug_func)
+static int sdio_init(struct wilc *wilc)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 2d51748..6032a8f 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -734,7 +734,7 @@ static int wilc_spi_sync(struct wilc *wilc)
 	return 1;
 }
 
-static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
+static int _wilc_spi_init(struct wilc *wilc)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 0427349..32ecc2d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1587,7 +1587,7 @@ int wilc_wlan_init(struct net_device *dev)
 
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
-	if (!wilc->hif_func->hif_init(wilc, wilc_debug)) {
+	if (!wilc->hif_func->hif_init(wilc)) {
 		ret = -EIO;
 		goto _fail_;
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 3666453..580e1d6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -226,7 +226,7 @@ struct rxq_entry_t {
  ********************************************/
 struct wilc;
 struct wilc_hif_func {
-	int (*hif_init)(struct wilc *, wilc_debug_func);
+	int (*hif_init)(struct wilc *);
 	int (*hif_deinit)(struct wilc *);
 	int (*hif_read_reg)(struct wilc *, u32, u32 *);
 	int (*hif_write_reg)(struct wilc *, u32, u32);
-- 
1.9.1

