Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47620 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032934AbbKFJjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/26] staging: wilc1000: linux_spi_init: remove parameter vp
Date: Fri, 6 Nov 2015 18:40:20 +0900
Message-ID: <1446802823-22598-24-git-send-email-glen.lee@atmel.com> (sfid-20151106_110754_653831_259D3419)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function parameter vp which is not used and modify it's
related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c     | 2 +-
 drivers/staging/wilc1000/linux_wlan_spi.c | 2 +-
 drivers/staging/wilc1000/linux_wlan_spi.h | 2 +-
 drivers/staging/wilc1000/wilc_spi.c       | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 00bc890..fcc669c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1566,7 +1566,7 @@ int wilc_netdev_init(struct wilc **wilc)
 	}
 
 	#ifndef WILC_SDIO
-	if (!linux_spi_init(&g_linux_wlan->wilc_spidev)) {
+	if (!linux_spi_init()) {
 		PRINT_ER("Can't initialize SPI\n");
 		return -1;
 	}
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 039d061..73c788f 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -93,7 +93,7 @@ void linux_spi_deinit(void *vp)
 
 
 
-int linux_spi_init(void *vp)
+int linux_spi_init(void)
 {
 	int ret = 1;
 	static int called;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 7356785..b956100 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -5,7 +5,7 @@
 extern struct spi_device *wilc_spi_dev;
 extern struct spi_driver wilc_bus;
 
-int linux_spi_init(void *vp);
+int linux_spi_init(void);
 void linux_spi_deinit(void *vp);
 int linux_spi_write(u8 *b, u32 len);
 int linux_spi_read(u8 *rb, u32 rlen);
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 30b1744..fe16d70 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -966,7 +966,7 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 
 	g_spi.dPrint = func;
 	g_spi.os_context = inp->os_context.os_private;
-	if (!linux_spi_init(g_spi.os_context)) {
+	if (!linux_spi_init()) {
 		PRINT_ER("[wilc spi]: Failed io init bus...\n");
 		return 0;
 	} else {
-- 
1.9.1

