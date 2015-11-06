Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47449 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033054AbbKFJi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/26] staging: wilc1000: remove spi_trx of wilc_wlan_io_func_t
Date: Fri, 6 Nov 2015 18:40:14 +0900
Message-ID: <1446802823-22598-18-git-send-email-glen.lee@atmel.com> (sfid-20151106_103904_309219_244A849B)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes spi_trx of wilc_wlan_io_func_t which is not used anymore.
Delete it's related codes also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 1 -
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7a20765..935314c5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -898,7 +898,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 	nwi->io_func.io_type = HIF_SPI;
 	nwi->io_func.io_init = linux_spi_init;
 	nwi->io_func.io_deinit = linux_spi_deinit;
-	nwi->io_func.u.spi.spi_trx = linux_spi_write_read;
 	nwi->io_func.u.spi.spi_max_speed = linux_spi_set_max_speed;
 #endif
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b820a11..be73b02 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -79,7 +79,6 @@ typedef struct {
 	union {
 		struct {
 			int (*spi_max_speed)(void);
-			int (*spi_trx)(u8 *, u8 *, u32);
 		} spi;
 	} u;
 } wilc_wlan_io_func_t;
-- 
1.9.1

