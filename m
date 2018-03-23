Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34176 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbeCWPJL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 11:09:11 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/9] staging: wilc1000: remove unused global variables related to p2p
Date: Fri, 23 Mar 2018 20:38:50 +0530
Message-ID: <1521817738-7557-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180323_160914_527567_5884BE3A)
In-Reply-To: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unused global variables defined for p2p.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 59 -------------------------------
 1 file changed, 59 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5082ede..a13998d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -254,13 +254,6 @@ static u32 inactive_time;
 static u8 del_beacon;
 static u32 clients_count;
 
-static u8 *join_req;
-static u8 *info_element;
-static u8 mode_11i;
-static u8 auth_type;
-static u32 join_req_size;
-static u32 info_element_size;
-static struct wilc_vif *join_req_vif;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79
@@ -995,39 +988,23 @@ static s32 handle_connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
-		info_element_size = hif_drv->usr_conn_req.ies_len;
-		info_element = kmalloc(info_element_size, GFP_KERNEL);
-		memcpy(info_element, hif_drv->usr_conn_req.ies,
-		       info_element_size);
-	}
 	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
 	wid_list[wid_cnt].type = WID_CHAR;
 	wid_list[wid_cnt].size = sizeof(char);
 	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.security;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", conn_attr->ssid, 7))
-		mode_11i = hif_drv->usr_conn_req.security;
-
 	wid_list[wid_cnt].id = (u16)WID_AUTH_TYPE;
 	wid_list[wid_cnt].type = WID_CHAR;
 	wid_list[wid_cnt].size = sizeof(char);
 	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", conn_attr->ssid, 7))
-		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
-
 	wid_list[wid_cnt].id = (u16)WID_JOIN_REQ_EXTENDED;
 	wid_list[wid_cnt].type = WID_STR;
 	wid_list[wid_cnt].size = 112;
 	wid_list[wid_cnt].val = kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);
 
-	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
-		join_req_size = wid_list[wid_cnt].size;
-		join_req = kmalloc(join_req_size, GFP_KERNEL);
-	}
 	if (!wid_list[wid_cnt].val) {
 		result = -EFAULT;
 		goto error;
@@ -1120,11 +1097,6 @@ static s32 handle_connect(struct wilc_vif *vif,
 	cur_byte = wid_list[wid_cnt].val;
 	wid_cnt++;
 
-	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
-		memcpy(join_req, cur_byte, join_req_size);
-		join_req_vif = vif;
-	}
-
 	if (conn_attr->bssid)
 		memcpy(wilc_connected_ssid,
 		       conn_attr->bssid, ETH_ALEN);
@@ -1254,16 +1226,6 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 	eth_zero_addr(wilc_connected_ssid);
 
-	if (join_req && join_req_vif == vif) {
-		kfree(join_req);
-		join_req = NULL;
-	}
-
-	if (info_element && join_req_vif == vif) {
-		kfree(info_element);
-		info_element = NULL;
-	}
-
 	return result;
 }
 
@@ -1519,17 +1481,6 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
 			hif_drv->usr_conn_req.ies = NULL;
-
-			if (join_req && join_req_vif == vif) {
-				kfree(join_req);
-				join_req = NULL;
-			}
-
-			if (info_element && join_req_vif == vif) {
-				kfree(info_element);
-				info_element = NULL;
-			}
-
 			hif_drv->hif_state = HOST_IF_IDLE;
 			scan_while_connected = false;
 
@@ -1866,16 +1817,6 @@ static void handle_disconnect(struct wilc_vif *vif)
 	kfree(conn_req->ies);
 	conn_req->ies = NULL;
 
-	if (join_req && join_req_vif == vif) {
-		kfree(join_req);
-		join_req = NULL;
-	}
-
-	if (info_element && join_req_vif == vif) {
-		kfree(info_element);
-		info_element = NULL;
-	}
-
 out:
 
 	complete(&hif_drv->comp_test_disconn_block);
-- 
2.7.4
