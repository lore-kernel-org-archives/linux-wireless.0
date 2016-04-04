Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34013 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbcDDLFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:23 -0400
Received: by mail-pf0-f193.google.com with SMTP id d184so5244471pfc.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:23 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/8] staging: wilc1000: rename u32WidsCount in handle_scan
Date: Mon,  4 Apr 2016 20:04:49 +0900
Message-Id: <1459767890-9709-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130543_257799_5C3BD550)
In-Reply-To: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32WidsCount to index to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 58 +++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index aae0028..a5f109a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -735,7 +735,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 {
 	s32 result = 0;
 	struct wid wid_list[5];
-	u32 u32WidsCount = 0;
+	u32 index = 0;
 	u32 i;
 	u8 *pu8Buffer;
 	u8 valuesize = 0;
@@ -760,15 +760,15 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 
 	hif_drv->usr_scan_req.rcvd_ch_cnt = 0;
 
-	wid_list[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
-	wid_list[u32WidsCount].type = WID_STR;
+	wid_list[index].id = (u16)WID_SSID_PROBE_REQ;
+	wid_list[index].type = WID_STR;
 
 	for (i = 0; i < scan_info->hidden_network.n_ssids; i++)
 		valuesize += ((scan_info->hidden_network.net_info[i].ssid_len) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
-	wid_list[u32WidsCount].val = pu8HdnNtwrksWidVal;
-	if (wid_list[u32WidsCount].val) {
-		pu8Buffer = wid_list[u32WidsCount].val;
+	wid_list[index].val = pu8HdnNtwrksWidVal;
+	if (wid_list[index].val) {
+		pu8Buffer = wid_list[index].val;
 
 		*pu8Buffer++ = scan_info->hidden_network.n_ssids;
 
@@ -778,24 +778,24 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 			pu8Buffer += scan_info->hidden_network.net_info[i].ssid_len;
 		}
 
-		wid_list[u32WidsCount].size = (s32)(valuesize + 1);
-		u32WidsCount++;
+		wid_list[index].size = (s32)(valuesize + 1);
+		index++;
 	}
 
-	wid_list[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
-	wid_list[u32WidsCount].type = WID_BIN_DATA;
-	wid_list[u32WidsCount].val = scan_info->ies;
-	wid_list[u32WidsCount].size = scan_info->ies_len;
-	u32WidsCount++;
+	wid_list[index].id = WID_INFO_ELEMENT_PROBE;
+	wid_list[index].type = WID_BIN_DATA;
+	wid_list[index].val = scan_info->ies;
+	wid_list[index].size = scan_info->ies_len;
+	index++;
 
-	wid_list[u32WidsCount].id = WID_SCAN_TYPE;
-	wid_list[u32WidsCount].type = WID_CHAR;
-	wid_list[u32WidsCount].size = sizeof(char);
-	wid_list[u32WidsCount].val = (s8 *)&scan_info->type;
-	u32WidsCount++;
+	wid_list[index].id = WID_SCAN_TYPE;
+	wid_list[index].type = WID_CHAR;
+	wid_list[index].size = sizeof(char);
+	wid_list[index].val = (s8 *)&scan_info->type;
+	index++;
 
-	wid_list[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
-	wid_list[u32WidsCount].type = WID_BIN_DATA;
+	wid_list[index].id = WID_SCAN_CHANNEL_LIST;
+	wid_list[index].type = WID_BIN_DATA;
 
 	if (scan_info->ch_freq_list &&
 	    scan_info->ch_list_len > 0) {
@@ -807,15 +807,15 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 		}
 	}
 
-	wid_list[u32WidsCount].val = scan_info->ch_freq_list;
-	wid_list[u32WidsCount].size = scan_info->ch_list_len;
-	u32WidsCount++;
+	wid_list[index].val = scan_info->ch_freq_list;
+	wid_list[index].size = scan_info->ch_list_len;
+	index++;
 
-	wid_list[u32WidsCount].id = WID_START_SCAN_REQ;
-	wid_list[u32WidsCount].type = WID_CHAR;
-	wid_list[u32WidsCount].size = sizeof(char);
-	wid_list[u32WidsCount].val = (s8 *)&scan_info->src;
-	u32WidsCount++;
+	wid_list[index].id = WID_START_SCAN_REQ;
+	wid_list[index].type = WID_CHAR;
+	wid_list[index].size = sizeof(char);
+	wid_list[index].val = (s8 *)&scan_info->src;
+	index++;
 
 	if (hif_drv->hif_state == HOST_IF_CONNECTED)
 		scan_while_connected = true;
@@ -823,7 +823,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 		scan_while_connected = false;
 
 	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
-				      u32WidsCount,
+				      index,
 				      wilc_get_vif_idx(vif));
 
 	if (result)
-- 
2.8.0

