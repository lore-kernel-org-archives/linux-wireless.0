Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3868 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbbIQIrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 04:47:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 2/2] staging: wilc1000: remove do-nothing ifdef statement
Date: Thu, 17 Sep 2015 17:47:25 +0900
Message-ID: <1442479645-10656-3-git-send-email-tony.cho@atmel.com> (sfid-20150917_104754_751164_4E035166)
In-Reply-To: <1442479645-10656-1-git-send-email-tony.cho@atmel.com>
References: <1442479645-10656-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes do-nothing ifdef, else statement and add ifdef WILC_SDIO
for disable_sdio_interrupt().

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c7034648..7f4ee80 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -982,17 +982,11 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 #endif
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
-		#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		#else
-		  #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-
-		  #else
+#ifdef WILC_SDIO
 		mutex_lock(&g_linux_wlan->hif_cs);
 		disable_sdio_interrupt();
 		mutex_unlock(&g_linux_wlan->hif_cs);
-		  #endif
-		#endif
-
+#endif
 		if (&g_linux_wlan->txq_event != NULL)
 			up(&g_linux_wlan->txq_event);
 
-- 
1.9.1

