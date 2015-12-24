Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59493 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbbLXF7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 00:59:02 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 2/2] staging: wilc1000: remove wilc_sdio_init
Date: Thu, 24 Dec 2015 15:02:52 +0900
Message-ID: <1450936972-5773-2-git-send-email-glen.lee@atmel.com> (sfid-20151224_065906_361740_CF48D63F)
In-Reply-To: <1450936972-5773-1-git-send-email-glen.lee@atmel.com>
References: <1450936972-5773-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_sdio_init return always 1, which is needless. Remove it and it's related
codes also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
Changes in v2: separate v1 patch into two patches.
---
 drivers/staging/wilc1000/wilc_sdio.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 464d27d..caad876 100644
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
@@ -611,11 +606,6 @@ static int sdio_init(struct wilc *wilc)
 
 	g_sdio.irq_gpio = (wilc->dev_irq_num);
 
-	if (!wilc_sdio_init()) {
-		dev_err(&func->dev, "Failed io init bus...\n");
-		return 0;
-	}
-
 	/**
 	 *      function 0 csa enable
 	 **/
-- 
1.9.1

