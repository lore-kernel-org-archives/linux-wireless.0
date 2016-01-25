Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41191 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcAYHoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:44:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 22/26] staging: wilc1000: disable power save when AP mode
Date: Mon, 25 Jan 2016 16:35:26 +0900
Message-ID: <1453707330-13526-23-git-send-email-glen.lee@atmel.com> (sfid-20160125_084424_627067_EB4E55A0)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch disables power save mode in case of AP mode.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d3ad098..8930d1c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2203,6 +2203,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_ER("Error in setting channel\n");
 
 	wilc_wlan_set_bssid(dev, wl->vif[vif->u8IfIdx]->src_addr, AP_MODE);
+	wilc_set_power_mgmt(vif, 0, 0);
 
 	s32Error = wilc_add_beacon(vif, settings->beacon_interval,
 				   settings->dtim_period, beacon->head_len,
-- 
1.9.1

