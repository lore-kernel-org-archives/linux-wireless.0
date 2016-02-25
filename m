Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34439 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbcBYAQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:30 -0500
Received: by mail-pa0-f54.google.com with SMTP id fy10so21443197pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:29 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 9/9] staging: wilc1000: rename u16reason in disconnect_info
Date: Thu, 25 Feb 2016 09:15:50 +0900
Message-Id: <1456359350-17118-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011633_207073_1D08C0B2)
In-Reply-To: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16reason to reason to remove u16 prefix. There is no
need to use prefix to show data type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 6256d71..63eca24 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -115,7 +115,7 @@ struct connect_info {
 };
 
 struct disconnect_info {
-	u16 u16reason;
+	u16 reason;
 	u8 *ie;
 	size_t ie_len;
 };
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4cdd3403..a6b7a22 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1552,7 +1552,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
 			}
 
-			strDisconnectNotifInfo.u16reason = 0;
+			strDisconnectNotifInfo.reason = 0;
 			strDisconnectNotifInfo.ie = NULL;
 			strDisconnectNotifInfo.ie_len = 0;
 
@@ -1889,7 +1889,7 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 
 		memset(&strDisconnectNotifInfo, 0, sizeof(struct disconnect_info));
 
-		strDisconnectNotifInfo.u16reason = 0;
+		strDisconnectNotifInfo.reason = 0;
 		strDisconnectNotifInfo.ie = NULL;
 		strDisconnectNotifInfo.ie_len = 0;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ed34727..d554df1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -559,11 +559,11 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		if (!pstrWFIDrv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
 		if ((pstrWFIDrv->IFC_UP) && (dev == wl->vif[1]->ndev)) {
-			pstrDisconnectNotifInfo->u16reason = 3;
+			pstrDisconnectNotifInfo->reason = 3;
 		} else if ((!pstrWFIDrv->IFC_UP) && (dev == wl->vif[1]->ndev)) {
-			pstrDisconnectNotifInfo->u16reason = 1;
+			pstrDisconnectNotifInfo->reason = 1;
 		}
-		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
+		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->reason, pstrDisconnectNotifInfo->ie,
 				      pstrDisconnectNotifInfo->ie_len, false,
 				      GFP_KERNEL);
 	}
-- 
2.7.1

