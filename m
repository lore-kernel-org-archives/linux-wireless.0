Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47132 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFJhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:37:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/26] staging: wilc1000: remove function pointer sdio_set_max_speed
Date: Fri, 6 Nov 2015 18:40:03 +0900
Message-ID: <1446802823-22598-7-git-send-email-glen.lee@atmel.com> (sfid-20151106_103759_979034_994C0740)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer sdio_set_max_speed of wilc_sdio_t and
call the function directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 1176946..0ce2ecc 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -17,7 +17,6 @@
 typedef struct {
 	void *os_context;
 	u32 block_size;
-	int (*sdio_set_max_speed)(void);
 	int (*sdio_set_default_speed)(void);
 	wilc_debug_func dPrint;
 	int nint;
@@ -573,7 +572,6 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 		return 0;
 	}
 
-	g_sdio.sdio_set_max_speed	= inp->io_func.u.sdio.sdio_set_max_speed;
 	g_sdio.sdio_set_default_speed	= inp->io_func.u.sdio.sdio_set_default_speed;
 
 	/**
@@ -678,7 +676,7 @@ _fail_:
 
 static void sdio_set_max_speed(void)
 {
-	g_sdio.sdio_set_max_speed();
+	linux_sdio_set_max_speed();
 }
 
 static void sdio_set_default_speed(void)
-- 
1.9.1

