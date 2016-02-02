Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9369 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbcBBMGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:06:31 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/26] staging: wilc1000: renames au8bssid of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:20 +0900
Message-ID: <1454414556-9822-10-git-send-email-leo.kim@atmel.com> (sfid-20160202_130634_275815_936819F3)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames au8bssid variable to bssid.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  2 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/host_interface.c         | 10 +++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 34 ++++++++++++-----------
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 273fad9..4a82576 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -323,7 +323,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		network_info->u64Tsf = tsf_lo | ((u64)tsf_hi << 32);
 
 		get_ssid(msa, network_info->ssid, &network_info->ssid_len);
-		get_BSSID(msa, network_info->au8bssid);
+		get_BSSID(msa, network_info->bssid);
 
 		network_info->u8channel = get_current_channel_802_11n(msa,
 							rx_len + FCS_LEN);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 39f3691..5404162 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -81,7 +81,7 @@ struct network_info {
 	u16 cap_info;
 	u8 ssid[MAX_SSID_LEN];
 	u8 ssid_len;
-	u8 au8bssid[6];
+	u8 bssid[6];
 	u16 u16BeaconPeriod;
 	u8 u8DtimPeriod;
 	u8 u8channel;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e9a3057..b465e9e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1369,9 +1369,9 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 
 		for (i = 0; i < hif_drv->usr_scan_req.rcvd_ch_cnt; i++) {
 			if ((hif_drv->usr_scan_req.net_info[i].au8bssid) &&
-			    (pstrNetworkInfo->au8bssid)) {
+			    (pstrNetworkInfo->bssid)) {
 				if (memcmp(hif_drv->usr_scan_req.net_info[i].au8bssid,
-					   pstrNetworkInfo->au8bssid, 6) == 0) {
+					   pstrNetworkInfo->bssid, 6) == 0) {
 					if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].s8rssi) {
 						goto done;
 					} else {
@@ -1388,9 +1388,9 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].s8rssi = pstrNetworkInfo->rssi;
 
 				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].au8bssid &&
-				    pstrNetworkInfo->au8bssid) {
+				    pstrNetworkInfo->bssid) {
 					memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].au8bssid,
-					       pstrNetworkInfo->au8bssid, 6);
+					       pstrNetworkInfo->bssid, 6);
 
 					hif_drv->usr_scan_req.rcvd_ch_cnt++;
 
@@ -4279,7 +4279,7 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
-		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
+		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->bssid, 6);
 		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->ssid,
 		       ptstrNetworkInfo->ssid_len + 1);
 		pNewJoinBssParam->ssid_len = ptstrNetworkInfo->ssid_len;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 577b8ca..c8b9a97 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -249,7 +249,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 					bss = cfg80211_inform_bss(wiphy,
 								  channel,
 								  CFG80211_BSS_FTYPE_UNKNOWN,
-								  network_info->au8bssid,
+								  network_info->bssid,
 								  network_info->u64Tsf,
 								  network_info->cap_info,
 								  network_info->u16BeaconPeriod,
@@ -332,8 +332,8 @@ static int is_network_in_shadow(struct network_info *pstrNetworkInfo,
 		state = -1;
 	} else {
 		for (i = 0; i < last_scanned_cnt; i++) {
-			if (memcmp(last_scanned_shadow[i].au8bssid,
-				   pstrNetworkInfo->au8bssid, 6) == 0) {
+			if (memcmp(last_scanned_shadow[i].bssid,
+				   pstrNetworkInfo->bssid, 6) == 0) {
 				state = i;
 				break;
 			}
@@ -371,8 +371,8 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
 	memcpy(last_scanned_shadow[ap_index].ssid,
 	       pstrNetworkInfo->ssid, pstrNetworkInfo->ssid_len);
-	memcpy(last_scanned_shadow[ap_index].au8bssid,
-	       pstrNetworkInfo->au8bssid, ETH_ALEN);
+	memcpy(last_scanned_shadow[ap_index].bssid,
+	       pstrNetworkInfo->bssid, ETH_ALEN);
 	last_scanned_shadow[ap_index].u16BeaconPeriod = pstrNetworkInfo->u16BeaconPeriod;
 	last_scanned_shadow[ap_index].u8DtimPeriod = pstrNetworkInfo->u8DtimPeriod;
 	last_scanned_shadow[ap_index].u8channel = pstrNetworkInfo->u8channel;
@@ -446,7 +446,7 @@ static void CfgScanResult(enum scan_event scan_event,
 							bss = cfg80211_inform_bss(wiphy,
 										  channel,
 										  CFG80211_BSS_FTYPE_UNKNOWN,
-										  network_info->au8bssid,
+										  network_info->bssid,
 										  network_info->u64Tsf,
 										  network_info->cap_info,
 										  network_info->u16BeaconPeriod,
@@ -461,7 +461,7 @@ static void CfgScanResult(enum scan_event scan_event,
 					u32 i;
 
 					for (i = 0; i < priv->u32RcvdChCount; i++) {
-						if (memcmp(last_scanned_shadow[i].au8bssid, network_info->au8bssid, 6) == 0) {
+						if (memcmp(last_scanned_shadow[i].bssid, network_info->bssid, 6) == 0) {
 							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].ssid);
 
 							last_scanned_shadow[i].rssi = network_info->rssi;
@@ -560,8 +560,9 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 
 			for (i = 0; i < last_scanned_cnt; i++) {
-				if (memcmp(last_scanned_shadow[i].au8bssid,
-					   pstrConnectInfo->au8bssid, ETH_ALEN) == 0) {
+				if (memcmp(last_scanned_shadow[i].bssid,
+					   pstrConnectInfo->au8bssid,
+					   ETH_ALEN) == 0) {
 					unsigned long now = jiffies;
 
 					if (time_after(now,
@@ -747,7 +748,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_INFO(CFG80211_DBG, "BSSID is not passed from the user\n");
 				break;
 			} else {
-				if (memcmp(last_scanned_shadow[i].au8bssid,
+				if (memcmp(last_scanned_shadow[i].bssid,
 					   sme->bssid,
 					   ETH_ALEN) == 0) {
 					PRINT_INFO(CFG80211_DBG, "BSSID is passed from the user and matched\n");
@@ -762,10 +763,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 		pstrNetworkInfo = &last_scanned_shadow[i];
 
-		PRINT_INFO(CFG80211_DBG, "network BSSID to be associated: %x%x%x%x%x%x\n",
-			   pstrNetworkInfo->au8bssid[0], pstrNetworkInfo->au8bssid[1],
-			   pstrNetworkInfo->au8bssid[2], pstrNetworkInfo->au8bssid[3],
-			   pstrNetworkInfo->au8bssid[4], pstrNetworkInfo->au8bssid[5]);
+		PRINT_INFO(CFG80211_DBG, "network BSSID to be associated:"
+			   "%x%x%x%x%x%x\n",
+			   pstrNetworkInfo->bssid[0], pstrNetworkInfo->bssid[1],
+			   pstrNetworkInfo->bssid[2], pstrNetworkInfo->bssid[3],
+			   pstrNetworkInfo->bssid[4], pstrNetworkInfo->bssid[5]);
 	} else {
 		s32Error = -ENOENT;
 		if (last_scanned_cnt == 0)
@@ -903,9 +905,9 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (!pstrWFIDrv->p2p_connect)
 		wlan_channel = pstrNetworkInfo->u8channel;
 
-	wilc_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid, STATION_MODE);
+	wilc_wlan_set_bssid(dev, pstrNetworkInfo->bssid, STATION_MODE);
 
-	s32Error = wilc_set_join_req(vif, pstrNetworkInfo->au8bssid, sme->ssid,
+	s32Error = wilc_set_join_req(vif, pstrNetworkInfo->bssid, sme->ssid,
 				     sme->ssid_len, sme->ie, sme->ie_len,
 				     CfgConnectResult, (void *)priv,
 				     u8security, tenuAuth_type,
-- 
1.9.1

