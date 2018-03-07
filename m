Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:27181 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933513AbeCHPwU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:20 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/10] staging: wilc1000: fix line over 80 char in handle_connect()
Date: Wed, 7 Mar 2018 07:43:54 +0530
Message-ID: <1520388839-7048-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165223_322545_142F8915)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 48 +++++++++++++++++--------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a218497..22d7bcc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -948,7 +948,8 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 	hif_drv->usr_conn_req.ssid_len = conn_attr->ssid_len;
 	if (conn_attr->ssid) {
-		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1, GFP_KERNEL);
+		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1,
+						     GFP_KERNEL);
 		memcpy(hif_drv->usr_conn_req.ssid,
 		       conn_attr->ssid,
 		       conn_attr->ssid_len);
@@ -957,7 +958,8 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 	hif_drv->usr_conn_req.ies_len = conn_attr->ies_len;
 	if (conn_attr->ies) {
-		hif_drv->usr_conn_req.ies = kmalloc(conn_attr->ies_len, GFP_KERNEL);
+		hif_drv->usr_conn_req.ies = kmalloc(conn_attr->ies_len,
+						    GFP_KERNEL);
 		memcpy(hif_drv->usr_conn_req.ies,
 		       conn_attr->ies,
 		       conn_attr->ies_len);
@@ -986,19 +988,17 @@ static s32 handle_connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
 	wid_cnt++;
 
-	{
-		wid_list[wid_cnt].id = WID_INFO_ELEMENT_ASSOCIATE;
-		wid_list[wid_cnt].type = WID_BIN_DATA;
-		wid_list[wid_cnt].val = hif_drv->usr_conn_req.ies;
-		wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
-		wid_cnt++;
-
-		if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
-			info_element_size = hif_drv->usr_conn_req.ies_len;
-			info_element = kmalloc(info_element_size, GFP_KERNEL);
-			memcpy(info_element, hif_drv->usr_conn_req.ies,
-			       info_element_size);
-		}
+	wid_list[wid_cnt].id = WID_INFO_ELEMENT_ASSOCIATE;
+	wid_list[wid_cnt].type = WID_BIN_DATA;
+	wid_list[wid_cnt].val = hif_drv->usr_conn_req.ies;
+	wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
+	wid_cnt++;
+
+	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
+		info_element_size = hif_drv->usr_conn_req.ies_len;
+		info_element = kmalloc(info_element_size, GFP_KERNEL);
+		memcpy(info_element, hif_drv->usr_conn_req.ies,
+		       info_element_size);
 	}
 	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
 	wid_list[wid_cnt].type = WID_CHAR;
@@ -1075,10 +1075,12 @@ static s32 handle_connect(struct wilc_vif *vif,
 	*(cur_byte++)  =  bss_param->rsn_grp_policy;
 	*(cur_byte++) =  bss_param->mode_802_11i;
 
-	memcpy(cur_byte, bss_param->rsn_pcip_policy, sizeof(bss_param->rsn_pcip_policy));
+	memcpy(cur_byte, bss_param->rsn_pcip_policy,
+	       sizeof(bss_param->rsn_pcip_policy));
 	cur_byte += sizeof(bss_param->rsn_pcip_policy);
 
-	memcpy(cur_byte, bss_param->rsn_auth_policy, sizeof(bss_param->rsn_auth_policy));
+	memcpy(cur_byte, bss_param->rsn_auth_policy,
+	       sizeof(bss_param->rsn_auth_policy));
 	cur_byte += sizeof(bss_param->rsn_auth_policy);
 
 	memcpy(cur_byte, bss_param->rsn_cap, sizeof(bss_param->rsn_cap));
@@ -1101,13 +1103,16 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 		*(cur_byte++) = bss_param->cnt;
 
-		memcpy(cur_byte, bss_param->duration, sizeof(bss_param->duration));
+		memcpy(cur_byte, bss_param->duration,
+		       sizeof(bss_param->duration));
 		cur_byte += sizeof(bss_param->duration);
 
-		memcpy(cur_byte, bss_param->interval, sizeof(bss_param->interval));
+		memcpy(cur_byte, bss_param->interval,
+		       sizeof(bss_param->interval));
 		cur_byte += sizeof(bss_param->interval);
 
-		memcpy(cur_byte, bss_param->start_time, sizeof(bss_param->start_time));
+		memcpy(cur_byte, bss_param->start_time,
+		       sizeof(bss_param->start_time));
 		cur_byte += sizeof(bss_param->start_time);
 	}
 
@@ -1148,7 +1153,8 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 			if (conn_attr->ies) {
 				conn_info.req_ies_len = conn_attr->ies_len;
-				conn_info.req_ies = kmalloc(conn_attr->ies_len, GFP_KERNEL);
+				conn_info.req_ies = kmalloc(conn_attr->ies_len,
+							    GFP_KERNEL);
 				memcpy(conn_info.req_ies,
 				       conn_attr->ies,
 				       conn_attr->ies_len);
-- 
2.7.4
