Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36285 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbcDDLFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:20 -0400
Received: by mail-pa0-f67.google.com with SMTP id 1so19879869pal.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:20 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/8] staging: wilc1000: rename strWIDList in handle_scan
Date: Mon,  4 Apr 2016 20:04:48 +0900
Message-Id: <1459767890-9709-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130525_072250_96446D40)
In-Reply-To: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strWIDList to wid_list to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 48 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 23080ff..aae0028 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -734,7 +734,7 @@ unlock:
 static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 {
 	s32 result = 0;
-	struct wid strWIDList[5];
+	struct wid wid_list[5];
 	u32 u32WidsCount = 0;
 	u32 i;
 	u8 *pu8Buffer;
@@ -760,15 +760,15 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 
 	hif_drv->usr_scan_req.rcvd_ch_cnt = 0;
 
-	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
-	strWIDList[u32WidsCount].type = WID_STR;
+	wid_list[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
+	wid_list[u32WidsCount].type = WID_STR;
 
 	for (i = 0; i < scan_info->hidden_network.n_ssids; i++)
 		valuesize += ((scan_info->hidden_network.net_info[i].ssid_len) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
-	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
-	if (strWIDList[u32WidsCount].val) {
-		pu8Buffer = strWIDList[u32WidsCount].val;
+	wid_list[u32WidsCount].val = pu8HdnNtwrksWidVal;
+	if (wid_list[u32WidsCount].val) {
+		pu8Buffer = wid_list[u32WidsCount].val;
 
 		*pu8Buffer++ = scan_info->hidden_network.n_ssids;
 
@@ -778,24 +778,24 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 			pu8Buffer += scan_info->hidden_network.net_info[i].ssid_len;
 		}
 
-		strWIDList[u32WidsCount].size = (s32)(valuesize + 1);
+		wid_list[u32WidsCount].size = (s32)(valuesize + 1);
 		u32WidsCount++;
 	}
 
-	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
-	strWIDList[u32WidsCount].type = WID_BIN_DATA;
-	strWIDList[u32WidsCount].val = scan_info->ies;
-	strWIDList[u32WidsCount].size = scan_info->ies_len;
+	wid_list[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
+	wid_list[u32WidsCount].type = WID_BIN_DATA;
+	wid_list[u32WidsCount].val = scan_info->ies;
+	wid_list[u32WidsCount].size = scan_info->ies_len;
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
-	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&scan_info->type;
+	wid_list[u32WidsCount].id = WID_SCAN_TYPE;
+	wid_list[u32WidsCount].type = WID_CHAR;
+	wid_list[u32WidsCount].size = sizeof(char);
+	wid_list[u32WidsCount].val = (s8 *)&scan_info->type;
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
-	strWIDList[u32WidsCount].type = WID_BIN_DATA;
+	wid_list[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
+	wid_list[u32WidsCount].type = WID_BIN_DATA;
 
 	if (scan_info->ch_freq_list &&
 	    scan_info->ch_list_len > 0) {
@@ -807,14 +807,14 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 		}
 	}
 
-	strWIDList[u32WidsCount].val = scan_info->ch_freq_list;
-	strWIDList[u32WidsCount].size = scan_info->ch_list_len;
+	wid_list[u32WidsCount].val = scan_info->ch_freq_list;
+	wid_list[u32WidsCount].size = scan_info->ch_list_len;
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
-	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&scan_info->src;
+	wid_list[u32WidsCount].id = WID_START_SCAN_REQ;
+	wid_list[u32WidsCount].type = WID_CHAR;
+	wid_list[u32WidsCount].size = sizeof(char);
+	wid_list[u32WidsCount].val = (s8 *)&scan_info->src;
 	u32WidsCount++;
 
 	if (hif_drv->hif_state == HOST_IF_CONNECTED)
@@ -822,7 +822,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	else if (hif_drv->hif_state == HOST_IF_IDLE)
 		scan_while_connected = false;
 
-	result = wilc_send_config_pkt(vif, SET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
 				      u32WidsCount,
 				      wilc_get_vif_idx(vif));
 
-- 
2.8.0

