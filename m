Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33886 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbcAEE0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 23:26:46 -0500
Received: by mail-pf0-f182.google.com with SMTP id e65so160309840pfe.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2016 20:26:45 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: rename u8ssidlen in struct hidden_net_info
Date: Tue,  5 Jan 2016 13:26:31 +0900
Message-Id: <1451967993-12178-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_052648_442191_7E648D4B)
In-Reply-To: <1451967993-12178-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451967993-12178-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8ssidlen to ssid_len that is a member of
hidden_net_info. There is no need to use u8 prefix to show data type so
just rename it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 8 ++++----
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cd04048..c4d83b9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -830,7 +830,7 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 	strWIDList[u32WidsCount].type = WID_STR;
 
 	for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++)
-		valuesize += ((pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
+		valuesize += ((pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
 	if (strWIDList[u32WidsCount].val) {
@@ -841,9 +841,9 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 		PRINT_D(HOSTINF_DBG, "In Handle_ProbeRequest number of ssid %d\n", pstrHostIFscanAttr->hidden_network.u8ssidnum);
 
 		for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++) {
-			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
-			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen);
-			pu8Buffer += pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
+			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len;
+			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len);
+			pu8Buffer += pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid_len;
 		}
 
 		strWIDList[u32WidsCount].size = (s32)(valuesize + 1);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9115b15..3bc609a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -187,7 +187,7 @@ struct rcvd_net_info {
 
 struct hidden_net_info {
 	u8  *ssid;
-	u8 u8ssidlen;
+	u8 ssid_len;
 };
 
 struct hidden_network {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index acd0c8d..56d736c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -653,7 +653,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				    request->ssids[i].ssid_len != 0) {
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
 					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
-					strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen = request->ssids[i].ssid_len;
+					strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid_len = request->ssids[i].ssid_len;
 				} else {
 					PRINT_D(CFG80211_DBG, "Received one NULL SSID\n");
 					strHiddenNetwork.u8ssidnum -= 1;
-- 
2.6.4

