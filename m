Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49862 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbcCYMUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:23 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/11] staging: wilc1000: removes unused dead codes
Date: Fri, 25 Mar 2016 21:16:51 +0900
Message-ID: <1458908216-12100-6-git-send-email-leo.kim@atmel.com> (sfid-20160325_132026_994245_3A24168A)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused dead codes that define custom feature.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 760d44d1..db624ef 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -691,14 +691,6 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 
 		wilc_wlan_stop(wl);
 		wilc_wlan_cleanup(dev);
-#if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-		if (!wl->dev_irq_num &&
-		    wl->hif_func->disable_interrupt) {
-			mutex_lock(&wl->hif_cs);
-			wl->hif_func->disable_interrupt(wl);
-			mutex_unlock(&wl->hif_cs);
-		}
-#endif
 		wlan_deinit_locks(dev);
 
 		wl->initialized = false;
-- 
1.9.1

