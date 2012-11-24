Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49333 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2KXOuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:50:07 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so2324525wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:50:06 -0800 (PST)
Message-ID: <1353768600.2318.13.camel@user64-MCP7A> (sfid-20121124_155011_583643_3B7BD6E8)
Subject: [PATCH 08/10] staging: vt6656: extend wireless definitions to v22
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:50:00 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/iwctl.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index db5bc62..2cd8b0a 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -42,7 +42,6 @@
 #include "control.h"
 #include "rndis.h"
 
-#define SUPPORTED_WIRELESS_EXT 19
 
 static const long frequency_list[] = {
 	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
@@ -133,9 +132,9 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 			pItemSSID = (PWLAN_IE_SSID)abyScanSSID;
 			pItemSSID->byElementID = WLAN_EID_SSID;
 			memcpy(pItemSSID->abySSID, req->essid, (int)req->essid_len);
-			if (pItemSSID->abySSID[req->essid_len - 1] == '\0') {
+			if (pItemSSID->abySSID[req->essid_len] == '\0') {
 				if (req->essid_len > 0)
-					pItemSSID->len = req->essid_len - 1;
+					pItemSSID->len = req->essid_len;
 			} else {
 				pItemSSID->len = req->essid_len;
 			}
@@ -606,7 +605,7 @@ int iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		range->txpower[0] = 100;
 		range->num_txpower = 1;
 		range->txpower_capa = IW_TXPOW_MWATT;
-		range->we_version_source = SUPPORTED_WIRELESS_EXT;
+		range->we_version_source = WIRELESS_EXT;
 		range->we_version_compiled = WIRELESS_EXT;
 		range->retry_capa = IW_RETRY_LIMIT | IW_RETRY_LIFETIME;
 		range->retry_flags = IW_RETRY_LIMIT;
@@ -801,9 +800,9 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		pItemSSID->byElementID = WLAN_EID_SSID;
 
 		memcpy(pItemSSID->abySSID, extra, wrq->length);
-		if (pItemSSID->abySSID[wrq->length - 1] == '\0') {
+		if (pItemSSID->abySSID[wrq->length] == '\0') {
 			if (wrq->length>0)
-				pItemSSID->len = wrq->length - 1;
+				pItemSSID->len = wrq->length;
 		} else {
 			pItemSSID->len = wrq->length;
 		}
@@ -1400,12 +1399,15 @@ int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 		return 0;
 
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
-		wrq->value = (int)((pMgmt->wListenInterval * pMgmt->wCurrBeaconPeriod) << 10);
+		wrq->value = (int)((pMgmt->wListenInterval *
+			pMgmt->wCurrBeaconPeriod) / 100);
 		wrq->flags = IW_POWER_TIMEOUT;
 	} else {
-		wrq->value = (int)((pMgmt->wListenInterval * pMgmt->wCurrBeaconPeriod) << 10);
+		wrq->value = (int)((pMgmt->wListenInterval *
+			pMgmt->wCurrBeaconPeriod) / 100);
 		wrq->flags = IW_POWER_PERIOD;
 	}
+
 	wrq->flags |= IW_POWER_ALL_R;
 	return 0;
 }
-- 
1.7.10.4



