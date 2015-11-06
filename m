Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47185 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFJiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:04 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/26] staging: wilc1000: remove function pointer sdio_set_default_speed
Date: Fri, 6 Nov 2015 18:40:05 +0900
Message-ID: <1446802823-22598-9-git-send-email-glen.lee@atmel.com> (sfid-20151106_103809_040246_4AA0B65B)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer sdio_set_default_speed of wilc_sdio_t
and call linux_sdio_set_default_speed() directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 0ce2ecc..6f48839 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -17,7 +17,6 @@
 typedef struct {
 	void *os_context;
 	u32 block_size;
-	int (*sdio_set_default_speed)(void);
 	wilc_debug_func dPrint;
 	int nint;
 #define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */
@@ -572,8 +571,6 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 		return 0;
 	}
 
-	g_sdio.sdio_set_default_speed	= inp->io_func.u.sdio.sdio_set_default_speed;
-
 	/**
 	 *      function 0 csa enable
 	 **/
@@ -681,7 +678,7 @@ static void sdio_set_max_speed(void)
 
 static void sdio_set_default_speed(void)
 {
-	g_sdio.sdio_set_default_speed();
+	linux_sdio_set_default_speed();
 }
 
 static int sdio_read_size(u32 *size)
-- 
1.9.1

