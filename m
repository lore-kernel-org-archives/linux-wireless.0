Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36583 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbcAEE0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 23:26:43 -0500
Received: by mail-pa0-f44.google.com with SMTP id yy13so115689789pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2016 20:26:42 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: rename pu8ssid in struct hidden_net_info
Date: Tue,  5 Jan 2016 13:26:30 +0900
Message-Id: <1451967993-12178-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_052647_414991_86E0D95B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8ssid to ssid that is a member of struct
hidden_net_info. There is no need to use pu8 prefix to show data type so
just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8f4589c..cd04048 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -842,7 +842,7 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 
 		for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++) {
 			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
-			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].pu8ssid, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen);
+			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].ssid, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen);
 			pu8Buffer += pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
 		}
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2877d78..9115b15 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -186,7 +186,7 @@ struct rcvd_net_info {
 };
 
 struct hidden_net_info {
-	u8  *pu8ssid;
+	u8  *ssid;
 	u8 u8ssidlen;
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index be5704b..acd0c8d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -651,8 +651,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 			for (i = 0; i < request->n_ssids; i++) {
 				if (request->ssids[i].ssid &&
 				    request->ssids[i].ssid_len != 0) {
-					strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
-					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
+					strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
+					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen = request->ssids[i].ssid_len;
 				} else {
 					PRINT_D(CFG80211_DBG, "Received one NULL SSID\n");
-- 
2.6.4

