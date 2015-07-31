Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44397 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbbGaHkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:40:37 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/28] staging: wilc1000: fix cast from pointer to integer warning
Date: Fri, 31 Jul 2015 16:38:23 +0900
Message-ID: <1438328316-30197-16-git-send-email-tony.cho@atmel.com> (sfid-20150731_094039_828761_2F0D58AB)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch removes unnecessary type cast because drvHandler type was change with
WILC_WFIDrvHandle.

drivers/staging/wilc1000/linux_wlan.c:2014:51: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]
    g_linux_wlan->strInterfaceInfo[i].drvHandler = (u32)priv->hWILCWFIDrv;

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a808722..5dcb30c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2011,7 +2011,7 @@ int mac_open(struct net_device *ndev)
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
 		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
 			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = (u32)priv->hWILCWFIDrv;
+			g_linux_wlan->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 	}
-- 
1.9.1

