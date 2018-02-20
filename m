Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeBTO6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:37 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/12] staging: wilc1000: rename strDisconnectNotifInfo to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:57 +0530
Message-ID: <1519138681-1982-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155845_092410_46A29D7E)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 593f7f1..64a2060 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1330,7 +1330,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 	u8 u8MacStatusReasonCode;
 	u8 u8MacStatusAdditionalInfo;
 	struct connect_info strConnectInfo;
-	struct disconnect_info strDisconnectNotifInfo;
+	struct disconnect_info disconn_info;
 	s32 s32Err = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -1462,16 +1462,16 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ies = NULL;
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
-			memset(&strDisconnectNotifInfo, 0, sizeof(struct disconnect_info));
+			memset(&disconn_info, 0, sizeof(struct disconnect_info));
 
 			if (hif_drv->usr_scan_req.scan_result) {
 				del_timer(&hif_drv->scan_timer);
 				handle_scan_done(vif, SCAN_EVENT_ABORTED);
 			}
 
-			strDisconnectNotifInfo.reason = 0;
-			strDisconnectNotifInfo.ie = NULL;
-			strDisconnectNotifInfo.ie_len = 0;
+			disconn_info.reason = 0;
+			disconn_info.ie = NULL;
+			disconn_info.ie_len = 0;
 
 			if (hif_drv->usr_conn_req.conn_result) {
 				wilc_optaining_ip = false;
@@ -1480,7 +1480,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 				hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 								  NULL,
 								  0,
-								  &strDisconnectNotifInfo,
+								  &disconn_info,
 								  hif_drv->usr_conn_req.arg);
 			} else {
 				netdev_err(vif->ndev, "Connect result NULL\n");
@@ -1800,13 +1800,13 @@ static void handle_disconnect(struct wilc_vif *vif)
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send dissconect\n");
 	} else {
-		struct disconnect_info strDisconnectNotifInfo;
+		struct disconnect_info disconn_info;
 
-		memset(&strDisconnectNotifInfo, 0, sizeof(struct disconnect_info));
+		memset(&disconn_info, 0, sizeof(struct disconnect_info));
 
-		strDisconnectNotifInfo.reason = 0;
-		strDisconnectNotifInfo.ie = NULL;
-		strDisconnectNotifInfo.ie_len = 0;
+		disconn_info.reason = 0;
+		disconn_info.ie = NULL;
+		disconn_info.ie_len = 0;
 
 		if (hif_drv->usr_scan_req.scan_result) {
 			del_timer(&hif_drv->scan_timer);
@@ -1824,7 +1824,7 @@ static void handle_disconnect(struct wilc_vif *vif)
 			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 							  NULL,
 							  0,
-							  &strDisconnectNotifInfo,
+							  &disconn_info,
 							  hif_drv->usr_conn_req.arg);
 		} else {
 			netdev_err(vif->ndev, "conn_result = NULL\n");
-- 
2.7.4
