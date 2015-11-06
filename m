Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47502 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032984AbbKFJjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:10 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/26] staging: wilc1000: remove spi_max_speed of wilc_wlan_io_func_t
Date: Fri, 6 Nov 2015 18:40:16 +0900
Message-ID: <1446802823-22598-20-git-send-email-glen.lee@atmel.com> (sfid-20151106_110756_281815_FEEC1E13)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes spi_max_speed of wilc_wlan_io_func_t which is not used
anymore and removes union u and struct spi, which does not have members in it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 1 -
 drivers/staging/wilc1000/wilc_wlan_if.h | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 935314c5..3aa636a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -898,7 +898,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 	nwi->io_func.io_type = HIF_SPI;
 	nwi->io_func.io_init = linux_spi_init;
 	nwi->io_func.io_deinit = linux_spi_deinit;
-	nwi->io_func.u.spi.spi_max_speed = linux_spi_set_max_speed;
 #endif
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index be73b02..0f15795 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -76,11 +76,6 @@ typedef struct {
 	int io_type;
 	int (*io_init)(void *);
 	void (*io_deinit)(void *);
-	union {
-		struct {
-			int (*spi_max_speed)(void);
-		} spi;
-	} u;
 } wilc_wlan_io_func_t;
 
 #define WILC_MAC_INDICATE_STATUS	0x1
-- 
1.9.1

