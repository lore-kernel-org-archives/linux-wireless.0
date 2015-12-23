Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:50235 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbbLWC32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 21:29:28 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: remove wilc_sdio_init
Date: Wed, 23 Dec 2015 11:33:23 +0900
Message-ID: <1450838003-24379-1-git-send-email-glen.lee@atmel.com> (sfid-20151223_032946_933700_7040D7D2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_sdio_init return always 1. It is needless, so just remove it and it's
related codes also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index e961b50..caad876 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -185,11 +185,6 @@ static void wilc_sdio_disable_interrupt(struct wilc *dev)
 	dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
 }
 
-static int wilc_sdio_init(void)
-{
-	return 1;
-}
-
 /********************************************
  *
  *      Function 0
@@ -611,13 +606,6 @@ static int sdio_init(struct wilc *wilc)
 
 	g_sdio.irq_gpio = (wilc->dev_irq_num);
 
-	if (!wilc_sdio_init()) {
-		dev_err(&func->dev, "Failed io init bus...\n");
-		return 0;
-	} else {
-		return 0;
-	}
-
 	/**
 	 *      function 0 csa enable
 	 **/
-- 
1.9.1

