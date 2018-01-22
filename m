Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39610 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeAVKXD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 05:23:03 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 03/14] staging: wilc1000: fix alignments to match open parenthesis
Date: Mon, 22 Jan 2018 15:52:16 +0530
Message-ID: <1516616547-24654-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180122_112306_690117_F540DDA6)
In-Reply-To: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Alignment should match open parenthesis" issues reported by
checkpatch.pl script. changes to comply with linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         |  4 +--
 drivers/staging/wilc1000/linux_wlan.c             |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 38 +++++++++++------------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 46e2d55..358354b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3730,8 +3730,8 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->rates_len > 0) {
 		add_sta_info->rates = kmemdup(sta_param->rates,
-				      add_sta_info->rates_len,
-				      GFP_KERNEL);
+					      add_sta_info->rates_len,
+					      GFP_KERNEL);
 		if (!add_sta_info->rates)
 			return -ENOMEM;
 	}
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3c3f1863..d9725ef 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -695,7 +695,7 @@ static int wlan_initialize_threads(struct net_device *dev)
 	wilc = vif->wilc;
 
 	wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
-				     "K_TXQ_TASK");
+				       "K_TXQ_TASK");
 	if (IS_ERR(wilc->txq_thread)) {
 		netdev_err(dev, "couldn't create TXQ thread\n");
 		wilc->close = 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index fb4a142..621810d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -470,10 +470,10 @@ static void CfgScanResult(enum scan_event scan_event,
 int wilc_connecting;
 
 static void cfg_connect_result(enum conn_event conn_disconn_evt,
-			     struct connect_info *conn_info,
-			     u8 mac_status,
-			     struct disconnect_info *disconn_info,
-			     void *priv_data)
+			       struct connect_info *conn_info,
+			       u8 mac_status,
+			       struct disconnect_info *disconn_info,
+			       void *priv_data)
 {
 	struct wilc_priv *priv;
 	struct net_device *dev;
@@ -623,18 +623,18 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				}
 			}
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
-					     au8ScanChanList,
-					     request->n_channels,
-					     (const u8 *)request->ie,
-					     request->ie_len, CfgScanResult,
-					     (void *)priv, &strHiddenNetwork);
+					au8ScanChanList,
+					request->n_channels,
+					(const u8 *)request->ie,
+					request->ie_len, CfgScanResult,
+					(void *)priv, &strHiddenNetwork);
 		} else {
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
-					     au8ScanChanList,
-					     request->n_channels,
-					     (const u8 *)request->ie,
-					     request->ie_len, CfgScanResult,
-					     (void *)priv, NULL);
+					au8ScanChanList,
+					request->n_channels,
+					(const u8 *)request->ie,
+					request->ie_len, CfgScanResult,
+					(void *)priv, NULL);
 		}
 	} else {
 		netdev_err(priv->dev, "Requested scanned channels over\n");
@@ -793,11 +793,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	wilc_wlan_set_bssid(dev, pstrNetworkInfo->bssid, STATION_MODE);
 
 	ret = wilc_set_join_req(vif, pstrNetworkInfo->bssid, sme->ssid,
-				     sme->ssid_len, sme->ie, sme->ie_len,
-				     cfg_connect_result, (void *)priv,
-				     u8security, auth_type,
-				     pstrNetworkInfo->ch,
-				     pstrNetworkInfo->join_params);
+				sme->ssid_len, sme->ie, sme->ie_len,
+				cfg_connect_result, (void *)priv,
+				u8security, auth_type,
+				pstrNetworkInfo->ch,
+				pstrNetworkInfo->join_params);
 	if (ret != 0) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret = -ENOENT;
-- 
2.7.4
