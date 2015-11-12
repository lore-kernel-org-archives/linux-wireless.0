Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43162 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbbKLCcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 21:32:13 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: fix bug in sdio/spi
Date: Thu, 12 Nov 2015 11:35:26 +0900
Message-ID: <1447295726-24486-1-git-send-email-glen.lee@atmel.com> (sfid-20151112_033241_510920_1902E830)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sdio_init and wilc_spi_init always return error, so it fails everytime.
Fix this by removing else statement.

This fixes c1af9db78950a778ec18343c5c5a6d4cfbf58a61,
bacd388547f55eb415ce266c8723cc6f1281a25d

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 --
 drivers/staging/wilc1000/wilc_spi.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8aacf55..1addc56 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -564,8 +564,6 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	if (!linux_sdio_init()) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
 		return 0;
-	} else {
-		return 0;
 	}
 
 	/**
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 3741836..cff61fd 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -968,8 +968,6 @@ static int wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 	if (!linux_spi_init()) {
 		PRINT_ER("[wilc spi]: Failed io init bus...\n");
 		return 0;
-	} else {
-		return 0;
 	}
 
 	/**
-- 
1.9.1

