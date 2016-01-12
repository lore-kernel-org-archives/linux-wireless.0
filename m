Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52360 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbcALHgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:36:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/26] staging: wilc1000: sdio_init: add resume argument
Date: Tue, 12 Jan 2016 16:39:34 +0900
Message-ID: <1452584395-24910-6-git-send-email-glen.lee@atmel.com> (sfid-20160112_083615_339141_AA9D720E)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Part of sdio init codes should not run when sdio init function is called on
sdio resume so skip them.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 34 +++++++++++++++++++---------------
 drivers/staging/wilc1000/wilc_spi.c  |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c |  2 +-
 drivers/staging/wilc1000/wilc_wlan.h |  2 +-
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ece2f58..c8d003b 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -42,7 +42,7 @@ static wilc_sdio_t g_sdio;
 
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data);
 static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data);
-static int sdio_init(struct wilc *wilc);
+static int sdio_init(struct wilc *wilc, bool resume);
 
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
@@ -196,7 +196,7 @@ static int wilc_sdio_resume(struct device *dev)
 	dev_info(dev, "sdio resume\n");
 	sdio_release_host(func);
 	chip_wakeup(wilc);
-	sdio_init(wilc);
+	sdio_init(wilc, true);
 
 	if(wilc->suspend_event)
 		host_wakeup_notify(wilc);
@@ -667,16 +667,17 @@ static int sdio_deinit(struct wilc *wilc)
 	return 1;
 }
 
-static int sdio_init(struct wilc *wilc)
+static int sdio_init(struct wilc *wilc, bool resume)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
 	int loop, ret;
 	u32 chipid;
 
-	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
-
-	g_sdio.irq_gpio = (wilc->dev_irq_num);
+	if (!resume) {
+		memset(&g_sdio, 0, sizeof(wilc_sdio_t));
+		g_sdio.irq_gpio = (wilc->dev_irq_num);
+	}
 
 	/**
 	 *      function 0 csa enable
@@ -766,16 +767,19 @@ static int sdio_init(struct wilc *wilc)
 	/**
 	 *      make sure can read back chip id correctly
 	 **/
-	if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
-		dev_err(&func->dev, "Fail cmd read chip id...\n");
-		goto _fail_;
+	if (!resume) {
+		if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
+			dev_err(&func->dev, "Fail cmd read chip id...\n");
+			goto _fail_;
+		}
+		dev_err(&func->dev, "chipid (%08x)\n", chipid);
+		if ((chipid & 0xfff) > 0x2a0)
+			g_sdio.has_thrpt_enh3 = 1;
+		else
+			g_sdio.has_thrpt_enh3 = 0;
+		dev_info(&func->dev, "has_thrpt_enh3 = %d...\n",
+			 g_sdio.has_thrpt_enh3);
 	}
-	dev_err(&func->dev, "chipid (%08x)\n", chipid);
-	if ((chipid & 0xfff) > 0x2a0)
-		g_sdio.has_thrpt_enh3 = 1;
-	else
-		g_sdio.has_thrpt_enh3 = 0;
-	dev_info(&func->dev, "has_thrpt_enh3 = %d...\n", g_sdio.has_thrpt_enh3);
 
 	return 1;
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 86de50c..356a446 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -852,7 +852,7 @@ static int _wilc_spi_deinit(struct wilc *wilc)
 	return 1;
 }
 
-static int wilc_spi_init(struct wilc *wilc)
+static int wilc_spi_init(struct wilc *wilc, bool resume)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8a39a05..aed1dd2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1530,7 +1530,7 @@ int wilc_wlan_init(struct net_device *dev)
 
 	wilc->quit = 0;
 
-	if (!wilc->hif_func->hif_init(wilc)) {
+	if (!wilc->hif_func->hif_init(wilc, false)) {
 		ret = -EIO;
 		goto _fail_;
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 53e56ff..a1096ed 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -227,7 +227,7 @@ struct rxq_entry_t {
  ********************************************/
 struct wilc;
 struct wilc_hif_func {
-	int (*hif_init)(struct wilc *);
+	int (*hif_init)(struct wilc *, bool resume);
 	int (*hif_deinit)(struct wilc *);
 	int (*hif_read_reg)(struct wilc *, u32, u32 *);
 	int (*hif_write_reg)(struct wilc *, u32, u32);
-- 
1.9.1

