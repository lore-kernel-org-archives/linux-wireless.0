Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47347 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbbKFJie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:34 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/26] staging: wilc1000: remove function pointer spi_tx of wilc_wlan_io_function_t
Date: Fri, 6 Nov 2015 18:40:10 +0900
Message-ID: <1446802823-22598-14-git-send-email-glen.lee@atmel.com> (sfid-20151106_103841_325885_7234FAF9)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer spi_tx of wilc_wlan_io_func_t because
it is not used anymore.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 1 -
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b37ef4d..fb2fea5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -898,7 +898,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 	nwi->io_func.io_type = HIF_SPI;
 	nwi->io_func.io_init = linux_spi_init;
 	nwi->io_func.io_deinit = linux_spi_deinit;
-	nwi->io_func.u.spi.spi_tx = linux_spi_write;
 	nwi->io_func.u.spi.spi_rx = linux_spi_read;
 	nwi->io_func.u.spi.spi_trx = linux_spi_write_read;
 	nwi->io_func.u.spi.spi_max_speed = linux_spi_set_max_speed;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 4568457..4c05a46a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -79,7 +79,6 @@ typedef struct {
 	union {
 		struct {
 			int (*spi_max_speed)(void);
-			int (*spi_tx)(u8 *, u32);
 			int (*spi_rx)(u8 *, u32);
 			int (*spi_trx)(u8 *, u8 *, u32);
 		} spi;
-- 
1.9.1

