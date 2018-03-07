Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:35471 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756005AbeCHPwG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:06 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/10] staging: wilc1000: rename pstrHostIFconnectAttr to avoid camelCase issue
Date: Wed, 7 Mar 2018 07:43:50 +0530
Message-ID: <1520388839-7048-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165209_632697_1F9ACCE5)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 104 +++++++++++++++---------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a4ee175..41fed8c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -917,7 +917,7 @@ static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 
 u8 wilc_connected_ssid[6] = {0};
 static s32 handle_connect(struct wilc_vif *vif,
-			  struct connect_attr *pstrHostIFconnectAttr)
+			  struct connect_attr *conn_attr)
 {
 	s32 result = 0;
 	struct wid wid_list[8];
@@ -926,45 +926,45 @@ static s32 handle_connect(struct wilc_vif *vif,
 	struct join_bss_param *bss_param;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
+	if (memcmp(conn_attr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
 		result = 0;
 		netdev_err(vif->ndev, "Discard connect request\n");
 		return result;
 	}
 
-	bss_param = pstrHostIFconnectAttr->params;
+	bss_param = conn_attr->params;
 	if (!bss_param) {
 		netdev_err(vif->ndev, "Required BSSID not found\n");
 		result = -ENOENT;
 		goto ERRORHANDLER;
 	}
 
-	if (pstrHostIFconnectAttr->bssid) {
+	if (conn_attr->bssid) {
 		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(hif_drv->usr_conn_req.bssid, pstrHostIFconnectAttr->bssid, 6);
+		memcpy(hif_drv->usr_conn_req.bssid, conn_attr->bssid, 6);
 	}
 
-	hif_drv->usr_conn_req.ssid_len = pstrHostIFconnectAttr->ssid_len;
-	if (pstrHostIFconnectAttr->ssid) {
-		hif_drv->usr_conn_req.ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
+	hif_drv->usr_conn_req.ssid_len = conn_attr->ssid_len;
+	if (conn_attr->ssid) {
+		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1, GFP_KERNEL);
 		memcpy(hif_drv->usr_conn_req.ssid,
-		       pstrHostIFconnectAttr->ssid,
-		       pstrHostIFconnectAttr->ssid_len);
-		hif_drv->usr_conn_req.ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
+		       conn_attr->ssid,
+		       conn_attr->ssid_len);
+		hif_drv->usr_conn_req.ssid[conn_attr->ssid_len] = '\0';
 	}
 
-	hif_drv->usr_conn_req.ies_len = pstrHostIFconnectAttr->ies_len;
-	if (pstrHostIFconnectAttr->ies) {
-		hif_drv->usr_conn_req.ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
+	hif_drv->usr_conn_req.ies_len = conn_attr->ies_len;
+	if (conn_attr->ies) {
+		hif_drv->usr_conn_req.ies = kmalloc(conn_attr->ies_len, GFP_KERNEL);
 		memcpy(hif_drv->usr_conn_req.ies,
-		       pstrHostIFconnectAttr->ies,
-		       pstrHostIFconnectAttr->ies_len);
+		       conn_attr->ies,
+		       conn_attr->ies_len);
 	}
 
-	hif_drv->usr_conn_req.security = pstrHostIFconnectAttr->security;
-	hif_drv->usr_conn_req.auth_type = pstrHostIFconnectAttr->auth_type;
-	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
-	hif_drv->usr_conn_req.arg = pstrHostIFconnectAttr->arg;
+	hif_drv->usr_conn_req.security = conn_attr->security;
+	hif_drv->usr_conn_req.auth_type = conn_attr->auth_type;
+	hif_drv->usr_conn_req.conn_result = conn_attr->result;
+	hif_drv->usr_conn_req.arg = conn_attr->arg;
 
 	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
 	wid_list[wid_cnt].type = WID_INT;
@@ -991,7 +991,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 		wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
 		wid_cnt++;
 
-		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
+		if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
 			info_element_size = hif_drv->usr_conn_req.ies_len;
 			info_element = kmalloc(info_element_size, GFP_KERNEL);
 			memcpy(info_element, hif_drv->usr_conn_req.ies,
@@ -1004,7 +1004,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.security;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
+	if (memcmp("DIRECT-", conn_attr->ssid, 7))
 		mode_11i = hif_drv->usr_conn_req.security;
 
 	wid_list[wid_cnt].id = (u16)WID_AUTH_TYPE;
@@ -1013,7 +1013,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
+	if (memcmp("DIRECT-", conn_attr->ssid, 7))
 		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
 
 	wid_list[wid_cnt].id = (u16)WID_JOIN_REQ_EXTENDED;
@@ -1021,7 +1021,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].size = 112;
 	wid_list[wid_cnt].val = kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
+	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
 		join_req_size = wid_list[wid_cnt].size;
 		join_req = kmalloc(join_req_size, GFP_KERNEL);
 	}
@@ -1032,15 +1032,15 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 	cur_byte = wid_list[wid_cnt].val;
 
-	if (pstrHostIFconnectAttr->ssid) {
-		memcpy(cur_byte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
-		cur_byte[pstrHostIFconnectAttr->ssid_len] = '\0';
+	if (conn_attr->ssid) {
+		memcpy(cur_byte, conn_attr->ssid, conn_attr->ssid_len);
+		cur_byte[conn_attr->ssid_len] = '\0';
 	}
 	cur_byte += MAX_SSID_LEN;
 	*(cur_byte++) = INFRASTRUCTURE;
 
-	if (pstrHostIFconnectAttr->ch >= 1 && pstrHostIFconnectAttr->ch <= 14) {
-		*(cur_byte++) = pstrHostIFconnectAttr->ch;
+	if (conn_attr->ch >= 1 && conn_attr->ch <= 14) {
+		*(cur_byte++) = conn_attr->ch;
 	} else {
 		netdev_err(vif->ndev, "Channel out of range\n");
 		*(cur_byte++) = 0xFF;
@@ -1048,12 +1048,12 @@ static s32 handle_connect(struct wilc_vif *vif,
 	*(cur_byte++)  = (bss_param->cap_info) & 0xFF;
 	*(cur_byte++)  = ((bss_param->cap_info) >> 8) & 0xFF;
 
-	if (pstrHostIFconnectAttr->bssid)
-		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
+	if (conn_attr->bssid)
+		memcpy(cur_byte, conn_attr->bssid, 6);
 	cur_byte += 6;
 
-	if (pstrHostIFconnectAttr->bssid)
-		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
+	if (conn_attr->bssid)
+		memcpy(cur_byte, conn_attr->bssid, 6);
 	cur_byte += 6;
 
 	*(cur_byte++)  = (bss_param->beacon_period) & 0xFF;
@@ -1112,14 +1112,14 @@ static s32 handle_connect(struct wilc_vif *vif,
 	cur_byte = wid_list[wid_cnt].val;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
+	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
 		memcpy(join_req, cur_byte, join_req_size);
 		join_req_vif = vif;
 	}
 
-	if (pstrHostIFconnectAttr->bssid)
+	if (conn_attr->bssid)
 		memcpy(wilc_connected_ssid,
-		       pstrHostIFconnectAttr->bssid, ETH_ALEN);
+		       conn_attr->bssid, ETH_ALEN);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
 				      wid_cnt,
@@ -1140,23 +1140,23 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 		memset(&strConnectInfo, 0, sizeof(struct connect_info));
 
-		if (pstrHostIFconnectAttr->result) {
-			if (pstrHostIFconnectAttr->bssid)
-				memcpy(strConnectInfo.bssid, pstrHostIFconnectAttr->bssid, 6);
+		if (conn_attr->result) {
+			if (conn_attr->bssid)
+				memcpy(strConnectInfo.bssid, conn_attr->bssid, 6);
 
-			if (pstrHostIFconnectAttr->ies) {
-				strConnectInfo.req_ies_len = pstrHostIFconnectAttr->ies_len;
-				strConnectInfo.req_ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
+			if (conn_attr->ies) {
+				strConnectInfo.req_ies_len = conn_attr->ies_len;
+				strConnectInfo.req_ies = kmalloc(conn_attr->ies_len, GFP_KERNEL);
 				memcpy(strConnectInfo.req_ies,
-				       pstrHostIFconnectAttr->ies,
-				       pstrHostIFconnectAttr->ies_len);
+				       conn_attr->ies,
+				       conn_attr->ies_len);
 			}
 
-			pstrHostIFconnectAttr->result(CONN_DISCONN_EVENT_CONN_RESP,
+			conn_attr->result(CONN_DISCONN_EVENT_CONN_RESP,
 							       &strConnectInfo,
 							       MAC_DISCONNECTED,
 							       NULL,
-							       pstrHostIFconnectAttr->arg);
+							       conn_attr->arg);
 			hif_drv->hif_state = HOST_IF_IDLE;
 			kfree(strConnectInfo.req_ies);
 			strConnectInfo.req_ies = NULL;
@@ -1166,14 +1166,14 @@ static s32 handle_connect(struct wilc_vif *vif,
 		}
 	}
 
-	kfree(pstrHostIFconnectAttr->bssid);
-	pstrHostIFconnectAttr->bssid = NULL;
+	kfree(conn_attr->bssid);
+	conn_attr->bssid = NULL;
 
-	kfree(pstrHostIFconnectAttr->ssid);
-	pstrHostIFconnectAttr->ssid = NULL;
+	kfree(conn_attr->ssid);
+	conn_attr->ssid = NULL;
 
-	kfree(pstrHostIFconnectAttr->ies);
-	pstrHostIFconnectAttr->ies = NULL;
+	kfree(conn_attr->ies);
+	conn_attr->ies = NULL;
 
 	kfree(cur_byte);
 	return result;
-- 
2.7.4
