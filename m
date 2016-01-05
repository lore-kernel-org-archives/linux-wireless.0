Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35180 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbcAEE0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 23:26:49 -0500
Received: by mail-pa0-f52.google.com with SMTP id ho8so1281972pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2016 20:26:49 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/4] staging: wilc1000: rename pstrHiddenNetworkInfo in struct hidden_network
Date: Tue,  5 Jan 2016 13:26:32 +0900
Message-Id: <1451967993-12178-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_052652_488585_13B9BDBF)
In-Reply-To: <1451967993-12178-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451967993-12178-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrHiddenNetworkInfo to net_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 14 +++++++-------
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c4d83b9..f5c6bfb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -830,7 +830,7 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 	strWIDList[u32WidsCount].type = WID_STR;
 
 	for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++)
-		valuesize += ((pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len) + 1);
+		valuesize += ((pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
 	if (strWIDList[u32WidsCount].val) {
@@ -841,9 +841,9 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 		PRINT_D(HOSTINF_DBG, "In Handle_ProbeRequest number of ssid %d\n", pstrHostIFscanAttr->hidden_network.u8ssidnum);
 
 		for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++) {
-			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len;
-			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len);
-			pu8Buffer += pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len;
+			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len;
+			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.net_info[i].ssid, pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len);
+			pu8Buffer += pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len;
 		}
 
 		strWIDList[u32WidsCount].size = (s32)(valuesize + 1);
@@ -912,8 +912,8 @@ ERRORHANDLER:
 
 	kfree(pstrHostIFscanAttr->ies);
 	pstrHostIFscanAttr->ies = NULL;
-	kfree(pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo);
-	pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo = NULL;
+	kfree(pstrHostIFscanAttr->hidden_network.net_info);
+	pstrHostIFscanAttr->hidden_network.net_info = NULL;
 
 	kfree(pu8HdnNtwrksWidVal);
 
@@ -3691,7 +3691,7 @@ s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	msg.id = HOST_IF_MSG_SCAN;
 
 	if (pstrHiddenNetwork) {
-		msg.body.scan_info.hidden_network.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
+		msg.body.scan_info.hidden_network.net_info = pstrHiddenNetwork->net_info;
 		msg.body.scan_info.hidden_network.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
 
 	} else
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3bc609a..93a9e9a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -191,7 +191,7 @@ struct hidden_net_info {
 };
 
 struct hidden_network {
-	struct hidden_net_info *pstrHiddenNetworkInfo;
+	struct hidden_net_info *net_info;
 	u8 u8ssidnum;
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 56d736c..f0dd38d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -644,16 +644,16 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		PRINT_D(CFG80211_DBG, "Number of SSIDs %d\n", request->n_ssids);
 
 		if (request->n_ssids >= 1) {
-			strHiddenNetwork.pstrHiddenNetworkInfo = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
+			strHiddenNetwork.net_info = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
 			strHiddenNetwork.u8ssidnum = request->n_ssids;
 
 
 			for (i = 0; i < request->n_ssids; i++) {
 				if (request->ssids[i].ssid &&
 				    request->ssids[i].ssid_len != 0) {
-					strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
-					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
-					strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid_len = request->ssids[i].ssid_len;
+					strHiddenNetwork.net_info[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
+					memcpy(strHiddenNetwork.net_info[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
+					strHiddenNetwork.net_info[i].ssid_len = request->ssids[i].ssid_len;
 				} else {
 					PRINT_D(CFG80211_DBG, "Received one NULL SSID\n");
 					strHiddenNetwork.u8ssidnum -= 1;
-- 
2.6.4

