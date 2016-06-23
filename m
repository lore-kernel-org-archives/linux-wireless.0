Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33485 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbcFWR5Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 13:57:16 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] staging: wilc1000: arrays can't be NULL
Date: Thu, 23 Jun 2016 18:57:09 +0100
Message-Id: <1466704629-26084-1-git-send-email-luisbg@osg.samsung.com> (sfid-20160623_195735_317913_579F9503)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hif_drv->usr_scan_req.net.net_info[i] contains found_net_info structs
which have the following element:
u8 bssid[6];

pstrNetworkInfo, of type network_info, also contains an u8 array named
bssid.

request->ssids is an array of cfg80211_ssid structs. Making ssid:
u8 ssid[IEEE80211_MAX_SSID_LEN];

In these 3 cases the arrays are being checked against NULL, which can't
happen. Removing the checks since they will always be true.

Found with smatch:
drivers/staging/wilc1000/host_interface.c:1234 Handle_RcvdNtwrkInfo() warn: this array is probably non-NULL. 'hif_drv->usr_scan_req.net_info[i].bssid'
drivers/staging/wilc1000/host_interface.c:1235 Handle_RcvdNtwrkInfo() warn: this array is probably non-NULL. 'pstrNetworkInfo->bssid'
drivers/staging/wilc1000/host_interface.c:1253 Handle_RcvdNtwrkInfo() warn: this array is probably non-NULL. 'hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid'
drivers/staging/wilc1000/host_interface.c:1254 Handle_RcvdNtwrkInfo() warn: this array is probably non-NULL. 'pstrNetworkInfo->bssid'

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
Hi,

I am aware this patch gives a few checkpatch.pl warnings about lines being
over 80 characters. Fixing that would be a completely different issue, and
a lengthy one since the file has loads of them.

Hopefully somebody else picks that up. Maybe I should send a hit to the
kernelnewbies mailing list :)

Thanks,
Luis


 drivers/staging/wilc1000/host_interface.c         | 38 ++++++++++-------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  3 +-
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9535842..7d5745a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1231,17 +1231,14 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 		}
 
 		for (i = 0; i < hif_drv->usr_scan_req.rcvd_ch_cnt; i++) {
-			if ((hif_drv->usr_scan_req.net_info[i].bssid) &&
-			    (pstrNetworkInfo->bssid)) {
-				if (memcmp(hif_drv->usr_scan_req.net_info[i].bssid,
-					   pstrNetworkInfo->bssid, 6) == 0) {
-					if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].rssi) {
-						goto done;
-					} else {
-						hif_drv->usr_scan_req.net_info[i].rssi = pstrNetworkInfo->rssi;
-						bNewNtwrkFound = false;
-						break;
-					}
+			if (memcmp(hif_drv->usr_scan_req.net_info[i].bssid,
+				   pstrNetworkInfo->bssid, 6) == 0) {
+				if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].rssi) {
+					goto done;
+				} else {
+					hif_drv->usr_scan_req.net_info[i].rssi = pstrNetworkInfo->rssi;
+					bNewNtwrkFound = false;
+					break;
 				}
 			}
 		}
@@ -1250,20 +1247,17 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
 				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].rssi = pstrNetworkInfo->rssi;
 
-				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid &&
-				    pstrNetworkInfo->bssid) {
-					memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid,
-					       pstrNetworkInfo->bssid, 6);
+				memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid,
+				       pstrNetworkInfo->bssid, 6);
 
-					hif_drv->usr_scan_req.rcvd_ch_cnt++;
+				hif_drv->usr_scan_req.rcvd_ch_cnt++;
 
-					pstrNetworkInfo->new_network = true;
-					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
+				pstrNetworkInfo->new_network = true;
+				pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
-					hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-									  hif_drv->usr_scan_req.arg,
-									  pJoinParams);
-				}
+				hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+								  hif_drv->usr_scan_req.arg,
+								  pJoinParams);
 			}
 		} else {
 			pstrNetworkInfo->new_network = false;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 51aff4f..3ddfa4a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -625,8 +625,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 
 			for (i = 0; i < request->n_ssids; i++) {
-				if (request->ssids[i].ssid &&
-				    request->ssids[i].ssid_len != 0) {
+				if (request->ssids[i].ssid_len != 0) {
 					strHiddenNetwork.net_info[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
 					memcpy(strHiddenNetwork.net_info[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
 					strHiddenNetwork.net_info[i].ssid_len = request->ssids[i].ssid_len;
-- 
2.5.1

