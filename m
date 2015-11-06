Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47225 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbbKFJiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:10 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/26] staging: wilc1000: remove varialbe sdio_set_default_speed
Date: Fri, 6 Nov 2015 18:40:06 +0900
Message-ID: <1446802823-22598-10-git-send-email-glen.lee@atmel.com> (sfid-20151106_103823_685266_961979E2)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes sdio_set_default_speed of wilc_wlan_io_func_t which is
not used anymore and also remove struct sdio since it is empty.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 1 -
 drivers/staging/wilc1000/wilc_wlan_if.h | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9ecf307..b37ef4d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -894,7 +894,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 	nwi->io_func.io_type = HIF_SDIO;
 	nwi->io_func.io_init = linux_sdio_init;
 	nwi->io_func.io_deinit = linux_sdio_deinit;
-	nwi->io_func.u.sdio.sdio_set_default_speed = linux_sdio_set_default_speed;
 #else
 	nwi->io_func.io_type = HIF_SPI;
 	nwi->io_func.io_init = linux_spi_init;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 2caad28..4568457 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -78,9 +78,6 @@ typedef struct {
 	void (*io_deinit)(void *);
 	union {
 		struct {
-			int (*sdio_set_default_speed)(void);
-		} sdio;
-		struct {
 			int (*spi_max_speed)(void);
 			int (*spi_tx)(u8 *, u32);
 			int (*spi_rx)(u8 *, u32);
-- 
1.9.1

