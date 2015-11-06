Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47486 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032984AbbKFJjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:04 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/26] staging: wilc1000: remove function pointer spi_max_speed
Date: Fri, 6 Nov 2015 18:40:15 +0900
Message-ID: <1446802823-22598-19-git-send-email-glen.lee@atmel.com> (sfid-20151106_103908_340474_30048E63)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer spi_max_speed of wilc_spi_t and just call
the function linux_spi_set_max_speed directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 789635b..bda7b10 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -14,7 +14,6 @@
 
 typedef struct {
 	void *os_context;
-	int (*spi_max_speed)(void);
 	wilc_debug_func dPrint;
 	int crc_off;
 	int nint;
@@ -975,7 +974,6 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	} else {
 		return 0;
 	}
-	g_spi.spi_max_speed = inp->io_func.u.spi.spi_max_speed;
 
 	/**
 	 *      configure protocol
@@ -1025,7 +1023,7 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 
 static void wilc_spi_max_bus_speed(void)
 {
-	g_spi.spi_max_speed();
+	linux_spi_set_max_speed();
 }
 
 static void wilc_spi_default_bus_speed(void)
-- 
1.9.1

