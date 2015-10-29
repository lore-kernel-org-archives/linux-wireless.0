Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4591 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbbJ2C4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:56:34 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 02/64] staging: wilc1000: rename au8AssociatedBSSID of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:25 +0900
Message-ID: <1446087567-16728-2-git-send-email-glen.lee@atmel.com> (sfid-20151029_035637_324554_868A41E8)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8AssociatedBSSID of struct host_if_drv to assoc_bssid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4e01dbd..7216d83 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1581,7 +1581,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
 				    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-					memcpy(hif_drv->au8AssociatedBSSID,
+					memcpy(hif_drv->assoc_bssid,
 					       hif_drv->usr_conn_req.pu8bssid, ETH_ALEN);
 				}
 			}
@@ -1657,7 +1657,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				PRINT_ER("Connect result callback function is NULL\n");
 			}
 
-			eth_zero_addr(hif_drv->au8AssociatedBSSID);
+			eth_zero_addr(hif_drv->assoc_bssid);
 
 			hif_drv->usr_conn_req.ssidLen = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
@@ -1840,7 +1840,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			}
 
 			if (hif_drv->hif_state == HOST_IF_CONNECTED)
-				memcpy(pu8keybuf, hif_drv->au8AssociatedBSSID, ETH_ALEN);
+				memcpy(pu8keybuf, hif_drv->assoc_bssid, ETH_ALEN);
 			else
 				PRINT_ER("Couldn't handle WPARxGtk while state is not HOST_IF_CONNECTED\n");
 
@@ -2022,7 +2022,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 		hif_drv->hif_state = HOST_IF_IDLE;
 
-		eth_zero_addr(hif_drv->au8AssociatedBSSID);
+		eth_zero_addr(hif_drv->assoc_bssid);
 
 		hif_drv->usr_conn_req.ssidLen = 0;
 		kfree(hif_drv->usr_conn_req.pu8ssid);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index dcdb9c6..fcfdd21 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -301,7 +301,7 @@ struct host_if_drv {
 
 	enum host_if_state hif_state;
 
-	u8 au8AssociatedBSSID[ETH_ALEN];
+	u8 assoc_bssid[ETH_ALEN];
 	struct cfg_param_val strCfgValues;
 /* semaphores */
 	struct semaphore gtOsCfgValuesSem;
-- 
1.9.1

