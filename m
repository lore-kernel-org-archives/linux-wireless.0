Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33981 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbcDDLFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:17 -0400
Received: by mail-pf0-f194.google.com with SMTP id d184so5244216pfc.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/8] staging: wilc1000: rename pstrHostIFscanAttr in handle_scan
Date: Mon,  4 Apr 2016 20:04:47 +0900
Message-Id: <1459767890-9709-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130546_343485_DA3771E4)
In-Reply-To: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrHostIFscanAttr to scan_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 55 +++++++++++++++----------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 053e6f1..23080ff 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -731,8 +731,7 @@ unlock:
 	return result;
 }
 
-static s32 handle_scan(struct wilc_vif *vif,
-		       struct scan_attr *pstrHostIFscanAttr)
+static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 {
 	s32 result = 0;
 	struct wid strWIDList[5];
@@ -743,8 +742,8 @@ static s32 handle_scan(struct wilc_vif *vif,
 	u8 *pu8HdnNtwrksWidVal = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	hif_drv->usr_scan_req.scan_result = pstrHostIFscanAttr->result;
-	hif_drv->usr_scan_req.arg = pstrHostIFscanAttr->arg;
+	hif_drv->usr_scan_req.scan_result = scan_info->result;
+	hif_drv->usr_scan_req.arg = scan_info->arg;
 
 	if ((hif_drv->hif_state >= HOST_IF_SCANNING) &&
 	    (hif_drv->hif_state < HOST_IF_CONNECTED)) {
@@ -764,19 +763,19 @@ static s32 handle_scan(struct wilc_vif *vif,
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].type = WID_STR;
 
-	for (i = 0; i < pstrHostIFscanAttr->hidden_network.n_ssids; i++)
-		valuesize += ((pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len) + 1);
+	for (i = 0; i < scan_info->hidden_network.n_ssids; i++)
+		valuesize += ((scan_info->hidden_network.net_info[i].ssid_len) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
 	if (strWIDList[u32WidsCount].val) {
 		pu8Buffer = strWIDList[u32WidsCount].val;
 
-		*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.n_ssids;
+		*pu8Buffer++ = scan_info->hidden_network.n_ssids;
 
-		for (i = 0; i < pstrHostIFscanAttr->hidden_network.n_ssids; i++) {
-			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len;
-			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.net_info[i].ssid, pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len);
-			pu8Buffer += pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len;
+		for (i = 0; i < scan_info->hidden_network.n_ssids; i++) {
+			*pu8Buffer++ = scan_info->hidden_network.net_info[i].ssid_len;
+			memcpy(pu8Buffer, scan_info->hidden_network.net_info[i].ssid, scan_info->hidden_network.net_info[i].ssid_len);
+			pu8Buffer += scan_info->hidden_network.net_info[i].ssid_len;
 		}
 
 		strWIDList[u32WidsCount].size = (s32)(valuesize + 1);
@@ -785,37 +784,37 @@ static s32 handle_scan(struct wilc_vif *vif,
 
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
-	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ies;
-	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->ies_len;
+	strWIDList[u32WidsCount].val = scan_info->ies;
+	strWIDList[u32WidsCount].size = scan_info->ies_len;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&pstrHostIFscanAttr->type;
+	strWIDList[u32WidsCount].val = (s8 *)&scan_info->type;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 
-	if (pstrHostIFscanAttr->ch_freq_list &&
-	    pstrHostIFscanAttr->ch_list_len > 0) {
+	if (scan_info->ch_freq_list &&
+	    scan_info->ch_list_len > 0) {
 		int i;
 
-		for (i = 0; i < pstrHostIFscanAttr->ch_list_len; i++)	{
-			if (pstrHostIFscanAttr->ch_freq_list[i] > 0)
-				pstrHostIFscanAttr->ch_freq_list[i] = pstrHostIFscanAttr->ch_freq_list[i] - 1;
+		for (i = 0; i < scan_info->ch_list_len; i++)	{
+			if (scan_info->ch_freq_list[i] > 0)
+				scan_info->ch_freq_list[i] = scan_info->ch_freq_list[i] - 1;
 		}
 	}
 
-	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ch_freq_list;
-	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->ch_list_len;
+	strWIDList[u32WidsCount].val = scan_info->ch_freq_list;
+	strWIDList[u32WidsCount].size = scan_info->ch_list_len;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&pstrHostIFscanAttr->src;
+	strWIDList[u32WidsCount].val = (s8 *)&scan_info->src;
 	u32WidsCount++;
 
 	if (hif_drv->hif_state == HOST_IF_CONNECTED)
@@ -836,13 +835,13 @@ ERRORHANDLER:
 		Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
 	}
 
-	kfree(pstrHostIFscanAttr->ch_freq_list);
-	pstrHostIFscanAttr->ch_freq_list = NULL;
+	kfree(scan_info->ch_freq_list);
+	scan_info->ch_freq_list = NULL;
 
-	kfree(pstrHostIFscanAttr->ies);
-	pstrHostIFscanAttr->ies = NULL;
-	kfree(pstrHostIFscanAttr->hidden_network.net_info);
-	pstrHostIFscanAttr->hidden_network.net_info = NULL;
+	kfree(scan_info->ies);
+	scan_info->ies = NULL;
+	kfree(scan_info->hidden_network.net_info);
+	scan_info->hidden_network.net_info = NULL;
 
 	kfree(pu8HdnNtwrksWidVal);
 
-- 
2.8.0

