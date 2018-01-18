Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:30819 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756236AbeARNSa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:18:30 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/14] staging: wilc1000: rename pstrHostIFconnectAttr argument to avoid camelCase
Date: Thu, 18 Jan 2018 18:47:07 +0530
Message-ID: <1516281432-7724-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180118_141837_354604_37055E1D)
In-Reply-To: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 104 ++++++++++++++----------------
 1 file changed, 49 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e3931bc..4ddd1a8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -903,7 +903,7 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 
 u8 wilc_connected_ssid[6] = {0};
 static s32 Handle_Connect(struct wilc_vif *vif,
-			  struct connect_attr *pstrHostIFconnectAttr)
+			  struct connect_attr *attr)
 {
 	s32 result = 0;
 	struct wid wid_list[8];
@@ -912,45 +912,41 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	struct join_bss_param *ptstrJoinBssParam;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
+	if (memcmp(attr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
 		result = 0;
 		netdev_err(vif->ndev, "Discard connect request\n");
 		return result;
 	}
 
-	ptstrJoinBssParam = pstrHostIFconnectAttr->params;
+	ptstrJoinBssParam = attr->params;
 	if (!ptstrJoinBssParam) {
 		netdev_err(vif->ndev, "Required BSSID not found\n");
 		result = -ENOENT;
 		goto ERRORHANDLER;
 	}
 
-	if (pstrHostIFconnectAttr->bssid) {
+	if (attr->bssid) {
 		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(hif_drv->usr_conn_req.bssid, pstrHostIFconnectAttr->bssid, 6);
+		memcpy(hif_drv->usr_conn_req.bssid, attr->bssid, 6);
 	}
 
-	hif_drv->usr_conn_req.ssid_len = pstrHostIFconnectAttr->ssid_len;
-	if (pstrHostIFconnectAttr->ssid) {
-		hif_drv->usr_conn_req.ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
-		memcpy(hif_drv->usr_conn_req.ssid,
-		       pstrHostIFconnectAttr->ssid,
-		       pstrHostIFconnectAttr->ssid_len);
-		hif_drv->usr_conn_req.ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
+	hif_drv->usr_conn_req.ssid_len = attr->ssid_len;
+	if (attr->ssid) {
+		hif_drv->usr_conn_req.ssid = kmalloc(attr->ssid_len + 1, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.ssid, attr->ssid, attr->ssid_len);
+		hif_drv->usr_conn_req.ssid[attr->ssid_len] = '\0';
 	}
 
-	hif_drv->usr_conn_req.ies_len = pstrHostIFconnectAttr->ies_len;
-	if (pstrHostIFconnectAttr->ies) {
-		hif_drv->usr_conn_req.ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
-		memcpy(hif_drv->usr_conn_req.ies,
-		       pstrHostIFconnectAttr->ies,
-		       pstrHostIFconnectAttr->ies_len);
+	hif_drv->usr_conn_req.ies_len = attr->ies_len;
+	if (attr->ies) {
+		hif_drv->usr_conn_req.ies = kmalloc(attr->ies_len, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.ies, attr->ies, attr->ies_len);
 	}
 
-	hif_drv->usr_conn_req.security = pstrHostIFconnectAttr->security;
-	hif_drv->usr_conn_req.auth_type = pstrHostIFconnectAttr->auth_type;
-	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
-	hif_drv->usr_conn_req.arg = pstrHostIFconnectAttr->arg;
+	hif_drv->usr_conn_req.security = attr->security;
+	hif_drv->usr_conn_req.auth_type = attr->auth_type;
+	hif_drv->usr_conn_req.conn_result = attr->result;
+	hif_drv->usr_conn_req.arg = attr->arg;
 
 	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
 	wid_list[wid_cnt].type = WID_INT;
@@ -977,7 +973,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
 		wid_cnt++;
 
-		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
+		if (memcmp("DIRECT-", attr->ssid, 7)) {
 			info_element_size = hif_drv->usr_conn_req.ies_len;
 			info_element = kmalloc(info_element_size, GFP_KERNEL);
 			memcpy(info_element, hif_drv->usr_conn_req.ies,
@@ -990,7 +986,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.security;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
+	if (memcmp("DIRECT-", attr->ssid, 7))
 		mode_11i = hif_drv->usr_conn_req.security;
 
 	wid_list[wid_cnt].id = (u16)WID_AUTH_TYPE;
@@ -999,7 +995,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
+	if (memcmp("DIRECT-", attr->ssid, 7))
 		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
 
 	wid_list[wid_cnt].id = (u16)WID_JOIN_REQ_EXTENDED;
@@ -1007,7 +1003,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].size = 112;
 	wid_list[wid_cnt].val = kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
+	if (memcmp("DIRECT-", attr->ssid, 7)) {
 		join_req_size = wid_list[wid_cnt].size;
 		join_req = kmalloc(join_req_size, GFP_KERNEL);
 	}
@@ -1018,15 +1014,15 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 	cur_byte = wid_list[wid_cnt].val;
 
-	if (pstrHostIFconnectAttr->ssid) {
-		memcpy(cur_byte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
-		cur_byte[pstrHostIFconnectAttr->ssid_len] = '\0';
+	if (attr->ssid) {
+		memcpy(cur_byte, attr->ssid, attr->ssid_len);
+		cur_byte[attr->ssid_len] = '\0';
 	}
 	cur_byte += MAX_SSID_LEN;
 	*(cur_byte++) = INFRASTRUCTURE;
 
-	if (pstrHostIFconnectAttr->ch >= 1 && pstrHostIFconnectAttr->ch <= 14) {
-		*(cur_byte++) = pstrHostIFconnectAttr->ch;
+	if (attr->ch >= 1 && attr->ch <= 14) {
+		*(cur_byte++) = attr->ch;
 	} else {
 		netdev_err(vif->ndev, "Channel out of range\n");
 		*(cur_byte++) = 0xFF;
@@ -1034,12 +1030,12 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	*(cur_byte++)  = (ptstrJoinBssParam->cap_info) & 0xFF;
 	*(cur_byte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
 
-	if (pstrHostIFconnectAttr->bssid)
-		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
+	if (attr->bssid)
+		memcpy(cur_byte, attr->bssid, 6);
 	cur_byte += 6;
 
-	if (pstrHostIFconnectAttr->bssid)
-		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
+	if (attr->bssid)
+		memcpy(cur_byte, attr->bssid, 6);
 	cur_byte += 6;
 
 	*(cur_byte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
@@ -1098,14 +1094,14 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	cur_byte = wid_list[wid_cnt].val;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
+	if (memcmp("DIRECT-", attr->ssid, 7)) {
 		memcpy(join_req, cur_byte, join_req_size);
 		join_req_vif = vif;
 	}
 
-	if (pstrHostIFconnectAttr->bssid)
+	if (attr->bssid)
 		memcpy(wilc_connected_ssid,
-		       pstrHostIFconnectAttr->bssid, ETH_ALEN);
+		       attr->bssid, ETH_ALEN);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
 				      wid_cnt,
@@ -1126,23 +1122,21 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 		memset(&strConnectInfo, 0, sizeof(struct connect_info));
 
-		if (pstrHostIFconnectAttr->result) {
-			if (pstrHostIFconnectAttr->bssid)
-				memcpy(strConnectInfo.bssid, pstrHostIFconnectAttr->bssid, 6);
+		if (attr->result) {
+			if (attr->bssid)
+				memcpy(strConnectInfo.bssid, attr->bssid, 6);
 
-			if (pstrHostIFconnectAttr->ies) {
-				strConnectInfo.req_ies_len = pstrHostIFconnectAttr->ies_len;
-				strConnectInfo.req_ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
-				memcpy(strConnectInfo.req_ies,
-				       pstrHostIFconnectAttr->ies,
-				       pstrHostIFconnectAttr->ies_len);
+			if (attr->ies) {
+				strConnectInfo.req_ies_len = attr->ies_len;
+				strConnectInfo.req_ies = kmalloc(attr->ies_len, GFP_KERNEL);
+				memcpy(strConnectInfo.req_ies, attr->ies, attr->ies_len);
 			}
 
-			pstrHostIFconnectAttr->result(CONN_DISCONN_EVENT_CONN_RESP,
+			attr->result(CONN_DISCONN_EVENT_CONN_RESP,
 							       &strConnectInfo,
 							       MAC_DISCONNECTED,
 							       NULL,
-							       pstrHostIFconnectAttr->arg);
+							       attr->arg);
 			hif_drv->hif_state = HOST_IF_IDLE;
 			kfree(strConnectInfo.req_ies);
 			strConnectInfo.req_ies = NULL;
@@ -1152,14 +1146,14 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		}
 	}
 
-	kfree(pstrHostIFconnectAttr->bssid);
-	pstrHostIFconnectAttr->bssid = NULL;
+	kfree(attr->bssid);
+	attr->bssid = NULL;
 
-	kfree(pstrHostIFconnectAttr->ssid);
-	pstrHostIFconnectAttr->ssid = NULL;
+	kfree(attr->ssid);
+	attr->ssid = NULL;
 
-	kfree(pstrHostIFconnectAttr->ies);
-	pstrHostIFconnectAttr->ies = NULL;
+	kfree(attr->ies);
+	attr->ies = NULL;
 
 	kfree(cur_byte);
 	return result;
-- 
2.7.4
