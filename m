Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47554 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032934AbbKFJjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/26] staging: wilc1000: remove unused function pointer io_deinit
Date: Fri, 6 Nov 2015 18:40:18 +0900
Message-ID: <1446802823-22598-22-git-send-email-glen.lee@atmel.com> (sfid-20151106_110755_568216_ECE23A24)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer io_deinit which is never used, and delete
it's related codes also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 --
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 119f55d..00bc890 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -892,10 +892,8 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 
 #ifdef WILC_SDIO
 	nwi->io_func.io_type = HIF_SDIO;
-	nwi->io_func.io_deinit = linux_sdio_deinit;
 #else
 	nwi->io_func.io_type = HIF_SPI;
-	nwi->io_func.io_deinit = linux_spi_deinit;
 #endif
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index d0b5bc3..b43e439 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -74,7 +74,6 @@ typedef struct {
 
 typedef struct {
 	int io_type;
-	void (*io_deinit)(void *);
 } wilc_wlan_io_func_t;
 
 #define WILC_MAC_INDICATE_STATUS	0x1
-- 
1.9.1

