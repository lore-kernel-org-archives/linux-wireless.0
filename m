Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:43672 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755275AbeCHPKt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:10:49 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/10] staging: wilc1000: rename strHiddenNetwork to avoid camelCase
Date: Wed, 7 Mar 2018 07:02:21 +0530
Message-ID: <1520386350-31607-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161052_459102_989129DF)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 205304c..dd7ab51 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -584,7 +584,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	u32 i;
 	s32 ret = 0;
 	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
-	struct hidden_network strHiddenNetwork;
+	struct hidden_network hidden_ntwk;
 	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
@@ -602,21 +602,21 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 			au8ScanChanList[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
 
 		if (request->n_ssids >= 1) {
-			strHiddenNetwork.net_info =
+			hidden_ntwk.net_info =
 				kmalloc_array(request->n_ssids,
 					      sizeof(struct hidden_network),
 					      GFP_KERNEL);
-			if (!strHiddenNetwork.net_info)
+			if (!hidden_ntwk.net_info)
 				return -ENOMEM;
-			strHiddenNetwork.n_ssids = request->n_ssids;
+			hidden_ntwk.n_ssids = request->n_ssids;
 
 			for (i = 0; i < request->n_ssids; i++) {
 				if (request->ssids[i].ssid_len != 0) {
-					strHiddenNetwork.net_info[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
-					memcpy(strHiddenNetwork.net_info[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
-					strHiddenNetwork.net_info[i].ssid_len = request->ssids[i].ssid_len;
+					hidden_ntwk.net_info[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
+					memcpy(hidden_ntwk.net_info[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
+					hidden_ntwk.net_info[i].ssid_len = request->ssids[i].ssid_len;
 				} else {
-					strHiddenNetwork.n_ssids -= 1;
+					hidden_ntwk.n_ssids -= 1;
 				}
 			}
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
@@ -624,7 +624,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 					request->n_channels,
 					(const u8 *)request->ie,
 					request->ie_len, CfgScanResult,
-					(void *)priv, &strHiddenNetwork);
+					(void *)priv, &hidden_ntwk);
 		} else {
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
 					au8ScanChanList,
-- 
2.7.4
