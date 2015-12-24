Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59459 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbbLXF6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 00:58:55 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 1/2] staging: wilc1000: fix always return 0 error
Date: Thu, 24 Dec 2015 15:02:51 +0900
Message-ID: <1450936972-5773-1-git-send-email-glen.lee@atmel.com> (sfid-20151224_065858_627009_E2DB33BD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug that return always 0 so it fails every time.

Fixes: c1af9db78950 ("staging: wilc1000: call linux_sdio_init instead of io_init")
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
Changes in v2: separate v1 patch into two patches.
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index e961b50..464d27d 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -614,8 +614,6 @@ static int sdio_init(struct wilc *wilc)
 	if (!wilc_sdio_init()) {
 		dev_err(&func->dev, "Failed io init bus...\n");
 		return 0;
-	} else {
-		return 0;
 	}
 
 	/**
-- 
1.9.1

