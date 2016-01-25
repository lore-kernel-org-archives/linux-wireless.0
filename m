Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40988 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbcAYHnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:43:23 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 12/26] staging: wilc1000: set proper bssid address
Date: Mon, 25 Jan 2016 16:35:16 +0900
Message-ID: <1453707330-13526-13-git-send-email-glen.lee@atmel.com> (sfid-20160125_084326_028547_98EE8C76)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes index 0 to index of vif which is currently beging used
because AP mode can run on any interface.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 95be39a..2db023f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2401,7 +2401,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	wilc_wlan_set_bssid(dev, wl->vif[0]->src_addr, AP_MODE);
+	wilc_wlan_set_bssid(dev, wl->vif[vif->u8IfIdx]->src_addr, AP_MODE);
 
 	s32Error = wilc_add_beacon(vif, settings->beacon_interval,
 				   settings->dtim_period, beacon->head_len,
-- 
1.9.1

