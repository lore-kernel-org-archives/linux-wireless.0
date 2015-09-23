Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18604 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbIWHIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 03:08:41 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/4] staging: wilc1000: remove ifdef OLD_FPGA_BITFILE line
Date: Wed, 23 Sep 2015 16:10:52 +0900
Message-ID: <1442992255-23005-1-git-send-email-glen.lee@atmel.com> (sfid-20150923_090845_201395_6EB5790B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OLD_FPGA_BITFILE is not used in the driver. Just delete ifdef line and it's
related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 0a930ec..9f5b5e6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1500,22 +1500,6 @@ static int wilc_wlan_start(void)
 	/**
 	 *      Set the host interface
 	 **/
-#ifdef OLD_FPGA_BITFILE
-	acquire_bus(ACQUIRE_ONLY);
-	ret = p->hif_func.hif_read_reg(WILC_VMM_CORE_CTL, &reg);
-	if (!ret) {
-		wilc_debug(N_ERR, "[wilc start]: fail read reg vmm_core_ctl...\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
-		return ret;
-	}
-	reg |= (p->io_func.io_type << 2);
-	ret = p->hif_func.hif_write_reg(WILC_VMM_CORE_CTL, reg);
-	if (!ret) {
-		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_ctl...\n");
-		release_bus(RELEASE_ONLY);
-		return ret;
-	}
-#else
 	if (p->io_func.io_type == HIF_SDIO) {
 		reg = 0;
 		reg |= (1 << 3); /* bug 4456 and 4557 */
@@ -1572,8 +1556,6 @@ static int wilc_wlan_start(void)
 		ret = -5;
 		return ret;
 	}
-#endif
-
 
 	/**
 	 *      Bus related
-- 
1.9.1

