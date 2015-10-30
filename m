Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20803 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbbJ3DIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:08:39 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/17] staging: wilc1000: remove unused function wilc_wlan_global_reset
Date: Fri, 30 Oct 2015 12:10:35 +0900
Message-ID: <1446174642-28570-10-git-send-email-glen.lee@atmel.com> (sfid-20151030_040842_604008_018676E0)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused function wilc_wlan_global_reset.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d4eef3d..c464cd7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1589,15 +1589,6 @@ int wilc_wlan_start(void)
 	return (ret < 0) ? ret : 0;
 }
 
-void wilc_wlan_global_reset(void)
-{
-
-	wilc_wlan_dev_t *p = &g_wlan;
-
-	acquire_bus(ACQUIRE_AND_WAKEUP);
-	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, 0x0);
-	release_bus(RELEASE_ONLY);
-}
 int wilc_wlan_stop(struct net_device *dev)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
-- 
1.9.1

