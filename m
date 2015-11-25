Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:53742 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbbKYJcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 04:32:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/4] staging: wilc1000: linux_sdio_probe: use return value
Date: Wed, 25 Nov 2015 18:35:27 +0900
Message-ID: <1448444129-11045-2-git-send-email-glen.lee@atmel.com> (sfid-20151125_103213_358935_26CD7F83)
In-Reply-To: <1448444129-11045-1-git-send-email-glen.lee@atmel.com>
References: <1448444129-11045-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return ret from wilc_netdev_init instead of -1 for proper error handling.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index e25811d..4b9cb55 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -91,7 +91,7 @@ static int linux_sdio_probe(struct sdio_func *func,
 			    const struct sdio_device_id *id)
 {
 	struct wilc *wilc;
-	int gpio;
+	int gpio, ret;
 
 	gpio = -1;
 	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
@@ -101,10 +101,11 @@ static int linux_sdio_probe(struct sdio_func *func,
 	}
 
 	dev_dbg(&func->dev, "Initializing netdev\n");
-	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
-			     &wilc_hif_sdio)) {
+	ret = wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
+			     &wilc_hif_sdio);
+	if (ret) {
 		dev_err(&func->dev, "Couldn't initialize netdev\n");
-		return -1;
+		return ret;
 	}
 	sdio_set_drvdata(func, wilc);
 	wilc->dev = &func->dev;
-- 
1.9.1

