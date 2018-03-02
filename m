Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:1969 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425214AbeCBOYA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:24:00 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/13] staging: wilc1000: rename handle_connect_timeout() variables to avoid camelCase
Date: Fri, 2 Mar 2018 19:52:47 +0530
Message-ID: <1520000569-27738-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_153349_799992_5E98AAAB)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ce04622..19c7483 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1182,9 +1182,9 @@ static s32 handle_connect(struct wilc_vif *vif,
 static s32 handle_connect_timeout(struct wilc_vif *vif)
 {
 	s32 result = 0;
-	struct connect_info strConnectInfo;
+	struct connect_info info;
 	struct wid wid;
-	u16 u16DummyReasonCode = 0;
+	u16 dummy_reason_code = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -1196,37 +1196,37 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 	scan_while_connected = false;
 
-	memset(&strConnectInfo, 0, sizeof(struct connect_info));
+	memset(&info, 0, sizeof(struct connect_info));
 
 	if (hif_drv->usr_conn_req.conn_result) {
 		if (hif_drv->usr_conn_req.bssid) {
-			memcpy(strConnectInfo.bssid,
+			memcpy(info.bssid,
 			       hif_drv->usr_conn_req.bssid, 6);
 		}
 
 		if (hif_drv->usr_conn_req.ies) {
-			strConnectInfo.req_ies_len = hif_drv->usr_conn_req.ies_len;
-			strConnectInfo.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-			memcpy(strConnectInfo.req_ies,
+			info.req_ies_len = hif_drv->usr_conn_req.ies_len;
+			info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
+			memcpy(info.req_ies,
 			       hif_drv->usr_conn_req.ies,
 			       hif_drv->usr_conn_req.ies_len);
 		}
 
 		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
-						  &strConnectInfo,
+						  &info,
 						  MAC_DISCONNECTED,
 						  NULL,
 						  hif_drv->usr_conn_req.arg);
 
-		kfree(strConnectInfo.req_ies);
-		strConnectInfo.req_ies = NULL;
+		kfree(info.req_ies);
+		info.req_ies = NULL;
 	} else {
 		netdev_err(vif->ndev, "Connect callback is NULL\n");
 	}
 
 	wid.id = (u16)WID_DISCONNECT;
 	wid.type = WID_CHAR;
-	wid.val = (s8 *)&u16DummyReasonCode;
+	wid.val = (s8 *)&dummy_reason_code;
 	wid.size = sizeof(char);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-- 
2.7.4
