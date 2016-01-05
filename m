Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33520 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbcAEE0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 23:26:52 -0500
Received: by mail-pa0-f44.google.com with SMTP id cy9so208206673pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2016 20:26:52 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: rename u8ssidnum in struct hidden_network
Date: Tue,  5 Jan 2016 13:26:33 +0900
Message-Id: <1451967993-12178-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_052655_776672_56E9D747)
In-Reply-To: <1451967993-12178-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451967993-12178-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8ssidnum to n_ssids that is a member of struct
hidden_network. There is no need to use u8 prefix to show data type so
just rename it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f5c6bfb..27e18c9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -829,18 +829,18 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].type = WID_STR;
 
-	for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++)
+	for (i = 0; i < pstrHostIFscanAttr->hidden_network.n_ssids; i++)
 		valuesize += ((pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
 	if (strWIDList[u32WidsCount].val) {
 		pu8Buffer = strWIDList[u32WidsCount].val;
 
-		*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.u8ssidnum;
+		*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.n_ssids;
 
-		PRINT_D(HOSTINF_DBG, "In Handle_ProbeRequest number of ssid %d\n", pstrHostIFscanAttr->hidden_network.u8ssidnum);
+		PRINT_D(HOSTINF_DBG, "In Handle_ProbeRequest number of ssid %d\n", pstrHostIFscanAttr->hidden_network.n_ssids);
 
-		for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++) {
+		for (i = 0; i < pstrHostIFscanAttr->hidden_network.n_ssids; i++) {
 			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len;
 			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.net_info[i].ssid, pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len);
 			pu8Buffer += pstrHostIFscanAttr->hidden_network.net_info[i].ssid_len;
@@ -3692,7 +3692,7 @@ s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 
 	if (pstrHiddenNetwork) {
 		msg.body.scan_info.hidden_network.net_info = pstrHiddenNetwork->net_info;
-		msg.body.scan_info.hidden_network.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
+		msg.body.scan_info.hidden_network.n_ssids = pstrHiddenNetwork->n_ssids;
 
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 93a9e9a..8541d16 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -192,7 +192,7 @@ struct hidden_net_info {
 
 struct hidden_network {
 	struct hidden_net_info *net_info;
-	u8 u8ssidnum;
+	u8 n_ssids;
 };
 
 struct user_scan_req {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f0dd38d..792fdff 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -645,7 +645,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 		if (request->n_ssids >= 1) {
 			strHiddenNetwork.net_info = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
-			strHiddenNetwork.u8ssidnum = request->n_ssids;
+			strHiddenNetwork.n_ssids = request->n_ssids;
 
 
 			for (i = 0; i < request->n_ssids; i++) {
@@ -656,7 +656,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 					strHiddenNetwork.net_info[i].ssid_len = request->ssids[i].ssid_len;
 				} else {
 					PRINT_D(CFG80211_DBG, "Received one NULL SSID\n");
-					strHiddenNetwork.u8ssidnum -= 1;
+					strHiddenNetwork.n_ssids -= 1;
 				}
 			}
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-- 
2.6.4

