Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:11869 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbeA3QvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 11:51:19 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/7] staging: wilc1000: rename u32WidsCount to avoid camelCase
Date: Tue, 30 Jan 2018 22:20:30 +0530
Message-ID: <1517331033-5718-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180130_175123_035017_256ECC81)
In-Reply-To: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
References: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camleCase" issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 146 +++++++++++++++---------------
 1 file changed, 73 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 13ac482..496c72f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -907,7 +907,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid_list[8];
-	u32 u32WidsCount = 0, dummyval = 0;
+	u32 wid_cnt = 0, dummyval = 0;
 	u8 *pu8CurrByte = NULL;
 	struct join_bss_param *ptstrJoinBssParam;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -952,30 +952,30 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
 	hif_drv->usr_conn_req.arg = pstrHostIFconnectAttr->arg;
 
-	wid_list[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
-	wid_list[u32WidsCount].type = WID_INT;
-	wid_list[u32WidsCount].size = sizeof(u32);
-	wid_list[u32WidsCount].val = (s8 *)(&(dummyval));
-	u32WidsCount++;
+	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
+	wid_list[wid_cnt].type = WID_INT;
+	wid_list[wid_cnt].size = sizeof(u32);
+	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
+	wid_cnt++;
 
-	wid_list[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
-	wid_list[u32WidsCount].type = WID_INT;
-	wid_list[u32WidsCount].size = sizeof(u32);
-	wid_list[u32WidsCount].val = (s8 *)(&(dummyval));
-	u32WidsCount++;
+	wid_list[wid_cnt].id = WID_RECEIVED_FRAGMENT_COUNT;
+	wid_list[wid_cnt].type = WID_INT;
+	wid_list[wid_cnt].size = sizeof(u32);
+	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
+	wid_cnt++;
 
-	wid_list[u32WidsCount].id = WID_FAILED_COUNT;
-	wid_list[u32WidsCount].type = WID_INT;
-	wid_list[u32WidsCount].size = sizeof(u32);
-	wid_list[u32WidsCount].val = (s8 *)(&(dummyval));
-	u32WidsCount++;
+	wid_list[wid_cnt].id = WID_FAILED_COUNT;
+	wid_list[wid_cnt].type = WID_INT;
+	wid_list[wid_cnt].size = sizeof(u32);
+	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
+	wid_cnt++;
 
 	{
-		wid_list[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
-		wid_list[u32WidsCount].type = WID_BIN_DATA;
-		wid_list[u32WidsCount].val = hif_drv->usr_conn_req.ies;
-		wid_list[u32WidsCount].size = hif_drv->usr_conn_req.ies_len;
-		u32WidsCount++;
+		wid_list[wid_cnt].id = WID_INFO_ELEMENT_ASSOCIATE;
+		wid_list[wid_cnt].type = WID_BIN_DATA;
+		wid_list[wid_cnt].val = hif_drv->usr_conn_req.ies;
+		wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
+		wid_cnt++;
 
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 			info_element_size = hif_drv->usr_conn_req.ies_len;
@@ -984,39 +984,39 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 			       info_element_size);
 		}
 	}
-	wid_list[u32WidsCount].id = (u16)WID_11I_MODE;
-	wid_list[u32WidsCount].type = WID_CHAR;
-	wid_list[u32WidsCount].size = sizeof(char);
-	wid_list[u32WidsCount].val = (s8 *)&hif_drv->usr_conn_req.security;
-	u32WidsCount++;
+	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
+	wid_list[wid_cnt].type = WID_CHAR;
+	wid_list[wid_cnt].size = sizeof(char);
+	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.security;
+	wid_cnt++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
 		mode_11i = hif_drv->usr_conn_req.security;
 
-	wid_list[u32WidsCount].id = (u16)WID_AUTH_TYPE;
-	wid_list[u32WidsCount].type = WID_CHAR;
-	wid_list[u32WidsCount].size = sizeof(char);
-	wid_list[u32WidsCount].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
-	u32WidsCount++;
+	wid_list[wid_cnt].id = (u16)WID_AUTH_TYPE;
+	wid_list[wid_cnt].type = WID_CHAR;
+	wid_list[wid_cnt].size = sizeof(char);
+	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
+	wid_cnt++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
 		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
 
-	wid_list[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
-	wid_list[u32WidsCount].type = WID_STR;
-	wid_list[u32WidsCount].size = 112;
-	wid_list[u32WidsCount].val = kmalloc(wid_list[u32WidsCount].size, GFP_KERNEL);
+	wid_list[wid_cnt].id = (u16)WID_JOIN_REQ_EXTENDED;
+	wid_list[wid_cnt].type = WID_STR;
+	wid_list[wid_cnt].size = 112;
+	wid_list[wid_cnt].val = kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-		join_req_size = wid_list[u32WidsCount].size;
+		join_req_size = wid_list[wid_cnt].size;
 		join_req = kmalloc(join_req_size, GFP_KERNEL);
 	}
-	if (!wid_list[u32WidsCount].val) {
+	if (!wid_list[wid_cnt].val) {
 		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
-	pu8CurrByte = wid_list[u32WidsCount].val;
+	pu8CurrByte = wid_list[wid_cnt].val;
 
 	if (pstrHostIFconnectAttr->ssid) {
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
@@ -1095,8 +1095,8 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		pu8CurrByte += sizeof(ptstrJoinBssParam->start_time);
 	}
 
-	pu8CurrByte = wid_list[u32WidsCount].val;
-	u32WidsCount++;
+	pu8CurrByte = wid_list[wid_cnt].val;
+	wid_cnt++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 		memcpy(join_req, pu8CurrByte, join_req_size);
@@ -1108,7 +1108,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		       pstrHostIFconnectAttr->bssid, ETH_ALEN);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
-				      u32WidsCount,
+				      wid_cnt,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		netdev_err(vif->ndev, "failed to send config packet\n");
@@ -1893,40 +1893,40 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 				struct rf_info *pstrStatistics)
 {
 	struct wid wid_list[5];
-	u32 u32WidsCount = 0, result = 0;
-
-	wid_list[u32WidsCount].id = WID_LINKSPEED;
-	wid_list[u32WidsCount].type = WID_CHAR;
-	wid_list[u32WidsCount].size = sizeof(char);
-	wid_list[u32WidsCount].val = (s8 *)&pstrStatistics->link_speed;
-	u32WidsCount++;
-
-	wid_list[u32WidsCount].id = WID_RSSI;
-	wid_list[u32WidsCount].type = WID_CHAR;
-	wid_list[u32WidsCount].size = sizeof(char);
-	wid_list[u32WidsCount].val = (s8 *)&pstrStatistics->rssi;
-	u32WidsCount++;
-
-	wid_list[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
-	wid_list[u32WidsCount].type = WID_INT;
-	wid_list[u32WidsCount].size = sizeof(u32);
-	wid_list[u32WidsCount].val = (s8 *)&pstrStatistics->tx_cnt;
-	u32WidsCount++;
-
-	wid_list[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
-	wid_list[u32WidsCount].type = WID_INT;
-	wid_list[u32WidsCount].size = sizeof(u32);
-	wid_list[u32WidsCount].val = (s8 *)&pstrStatistics->rx_cnt;
-	u32WidsCount++;
-
-	wid_list[u32WidsCount].id = WID_FAILED_COUNT;
-	wid_list[u32WidsCount].type = WID_INT;
-	wid_list[u32WidsCount].size = sizeof(u32);
-	wid_list[u32WidsCount].val = (s8 *)&pstrStatistics->tx_fail_cnt;
-	u32WidsCount++;
+	u32 wid_cnt = 0, result = 0;
+
+	wid_list[wid_cnt].id = WID_LINKSPEED;
+	wid_list[wid_cnt].type = WID_CHAR;
+	wid_list[wid_cnt].size = sizeof(char);
+	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->link_speed;
+	wid_cnt++;
+
+	wid_list[wid_cnt].id = WID_RSSI;
+	wid_list[wid_cnt].type = WID_CHAR;
+	wid_list[wid_cnt].size = sizeof(char);
+	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->rssi;
+	wid_cnt++;
+
+	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
+	wid_list[wid_cnt].type = WID_INT;
+	wid_list[wid_cnt].size = sizeof(u32);
+	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->tx_cnt;
+	wid_cnt++;
+
+	wid_list[wid_cnt].id = WID_RECEIVED_FRAGMENT_COUNT;
+	wid_list[wid_cnt].type = WID_INT;
+	wid_list[wid_cnt].size = sizeof(u32);
+	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->rx_cnt;
+	wid_cnt++;
+
+	wid_list[wid_cnt].id = WID_FAILED_COUNT;
+	wid_list[wid_cnt].type = WID_INT;
+	wid_list[wid_cnt].size = sizeof(u32);
+	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->tx_fail_cnt;
+	wid_cnt++;
 
 	result = wilc_send_config_pkt(vif, GET_CFG, wid_list,
-				      u32WidsCount,
+				      wid_cnt,
 				      wilc_get_vif_idx(vif));
 
 	if (result)
-- 
2.7.4
