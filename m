Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:55385 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbeCHPKw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:10:52 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/10] staging: wilc1000: rename pstrNetworkInfo to avoid camelCase
Date: Wed, 7 Mar 2018 07:02:22 +0530
Message-ID: <1520386350-31607-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161056_040900_3B9817C2)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camleCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 51 +++++++++++------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index dd7ab51..2fda90d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -294,8 +294,7 @@ static void clear_duringIP(struct timer_list *unused)
 	wilc_optaining_ip = false;
 }
 
-static int is_network_in_shadow(struct network_info *pstrNetworkInfo,
-				void *user_void)
+static int is_network_in_shadow(struct network_info *nw_info, void *user_void)
 {
 	int state = -1;
 	int i;
@@ -306,7 +305,7 @@ static int is_network_in_shadow(struct network_info *pstrNetworkInfo,
 	} else {
 		for (i = 0; i < last_scanned_cnt; i++) {
 			if (memcmp(last_scanned_shadow[i].bssid,
-				   pstrNetworkInfo->bssid, 6) == 0) {
+				   nw_info->bssid, 6) == 0) {
 				state = i;
 				break;
 			}
@@ -315,10 +314,10 @@ static int is_network_in_shadow(struct network_info *pstrNetworkInfo,
 	return state;
 }
 
-static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
+static void add_network_to_shadow(struct network_info *nw_info,
 				  void *user_void, void *pJoinParams)
 {
-	int ap_found = is_network_in_shadow(pstrNetworkInfo, user_void);
+	int ap_found = is_network_in_shadow(nw_info, user_void);
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
@@ -332,30 +331,30 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 		ap_index = ap_found;
 	}
 	rssi_index = last_scanned_shadow[ap_index].rssi_history.index;
-	last_scanned_shadow[ap_index].rssi_history.samples[rssi_index++] = pstrNetworkInfo->rssi;
+	last_scanned_shadow[ap_index].rssi_history.samples[rssi_index++] = nw_info->rssi;
 	if (rssi_index == NUM_RSSI) {
 		rssi_index = 0;
 		last_scanned_shadow[ap_index].rssi_history.full = true;
 	}
 	last_scanned_shadow[ap_index].rssi_history.index = rssi_index;
-	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
-	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
-	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
+	last_scanned_shadow[ap_index].rssi = nw_info->rssi;
+	last_scanned_shadow[ap_index].cap_info = nw_info->cap_info;
+	last_scanned_shadow[ap_index].ssid_len = nw_info->ssid_len;
 	memcpy(last_scanned_shadow[ap_index].ssid,
-	       pstrNetworkInfo->ssid, pstrNetworkInfo->ssid_len);
+	       nw_info->ssid, nw_info->ssid_len);
 	memcpy(last_scanned_shadow[ap_index].bssid,
-	       pstrNetworkInfo->bssid, ETH_ALEN);
-	last_scanned_shadow[ap_index].beacon_period = pstrNetworkInfo->beacon_period;
-	last_scanned_shadow[ap_index].dtim_period = pstrNetworkInfo->dtim_period;
-	last_scanned_shadow[ap_index].ch = pstrNetworkInfo->ch;
-	last_scanned_shadow[ap_index].ies_len = pstrNetworkInfo->ies_len;
-	last_scanned_shadow[ap_index].tsf_hi = pstrNetworkInfo->tsf_hi;
+	       nw_info->bssid, ETH_ALEN);
+	last_scanned_shadow[ap_index].beacon_period = nw_info->beacon_period;
+	last_scanned_shadow[ap_index].dtim_period = nw_info->dtim_period;
+	last_scanned_shadow[ap_index].ch = nw_info->ch;
+	last_scanned_shadow[ap_index].ies_len = nw_info->ies_len;
+	last_scanned_shadow[ap_index].tsf_hi = nw_info->tsf_hi;
 	if (ap_found != -1)
 		kfree(last_scanned_shadow[ap_index].ies);
-	last_scanned_shadow[ap_index].ies = kmalloc(pstrNetworkInfo->ies_len,
+	last_scanned_shadow[ap_index].ies = kmalloc(nw_info->ies_len,
 						    GFP_KERNEL);
 	memcpy(last_scanned_shadow[ap_index].ies,
-	       pstrNetworkInfo->ies, pstrNetworkInfo->ies_len);
+	       nw_info->ies, nw_info->ies_len);
 	last_scanned_shadow[ap_index].time_scan = jiffies;
 	last_scanned_shadow[ap_index].time_scan_cached = jiffies;
 	last_scanned_shadow[ap_index].found = 1;
@@ -654,7 +653,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
-	struct network_info *pstrNetworkInfo = NULL;
+	struct network_info *nw_info = NULL;
 	struct wilc_vif *vif;
 
 	wilc_connecting = 1;
@@ -689,7 +688,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (sel_bssi_idx < last_scanned_cnt) {
-		pstrNetworkInfo = &last_scanned_shadow[sel_bssi_idx];
+		nw_info = &last_scanned_shadow[sel_bssi_idx];
 	} else {
 		ret = -ENOENT;
 		wilc_connecting = 0;
@@ -782,19 +781,19 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	curr_channel = pstrNetworkInfo->ch;
+	curr_channel = nw_info->ch;
 
 	if (!wfi_drv->p2p_connect)
-		wlan_channel = pstrNetworkInfo->ch;
+		wlan_channel = nw_info->ch;
 
-	wilc_wlan_set_bssid(dev, pstrNetworkInfo->bssid, STATION_MODE);
+	wilc_wlan_set_bssid(dev, nw_info->bssid, STATION_MODE);
 
-	ret = wilc_set_join_req(vif, pstrNetworkInfo->bssid, sme->ssid,
+	ret = wilc_set_join_req(vif, nw_info->bssid, sme->ssid,
 				sme->ssid_len, sme->ie, sme->ie_len,
 				cfg_connect_result, (void *)priv,
 				u8security, auth_type,
-				pstrNetworkInfo->ch,
-				pstrNetworkInfo->join_params);
+				nw_info->ch,
+				nw_info->join_params);
 	if (ret != 0) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret = -ENOENT;
-- 
2.7.4
