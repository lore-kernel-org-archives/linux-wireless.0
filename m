Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34722 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbcBYAQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:22 -0500
Received: by mail-pf0-f172.google.com with SMTP id x65so21963034pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:21 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 8/9] staging: wilc1000: rename struct tstrDisconnectNotifInfo
Date: Thu, 25 Feb 2016 09:15:49 +0900
Message-Id: <1456359350-17118-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011628_204291_EFEB281B)
In-Reply-To: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames struct tstrDisconnectNotifInfo to disconnect_info to
avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 4 ++--
 drivers/staging/wilc1000/host_interface.c         | 8 ++++----
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 9fbd52b..6256d71 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -114,11 +114,11 @@ struct connect_info {
 	u16 status;
 };
 
-typedef struct {
+struct disconnect_info {
 	u16 u16reason;
 	u8 *ie;
 	size_t ie_len;
-} tstrDisconnectNotifInfo;
+};
 
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1ebe08a..4cdd3403 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1411,7 +1411,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	u8 u8MacStatusReasonCode;
 	u8 u8MacStatusAdditionalInfo;
 	struct connect_info strConnectInfo;
-	tstrDisconnectNotifInfo strDisconnectNotifInfo;
+	struct disconnect_info strDisconnectNotifInfo;
 	s32 s32Err = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -1545,7 +1545,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ies = NULL;
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
-			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
+			memset(&strDisconnectNotifInfo, 0, sizeof(struct disconnect_info));
 
 			if (hif_drv->usr_scan_req.scan_result) {
 				del_timer(&hif_drv->scan_timer);
@@ -1885,9 +1885,9 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send dissconect\n");
 	} else {
-		tstrDisconnectNotifInfo strDisconnectNotifInfo;
+		struct disconnect_info strDisconnectNotifInfo;
 
-		memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
+		memset(&strDisconnectNotifInfo, 0, sizeof(struct disconnect_info));
 
 		strDisconnectNotifInfo.u16reason = 0;
 		strDisconnectNotifInfo.ie = NULL;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f4a3e4f..795c18c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -174,7 +174,7 @@ typedef void (*wilc_scan_result)(enum scan_event, struct network_info *,
 typedef void (*wilc_connect_result)(enum conn_event,
 				     struct connect_info *,
 				     u8,
-				     tstrDisconnectNotifInfo *,
+				     struct disconnect_info *,
 				     void *);
 
 typedef void (*wilc_remain_on_chan_expired)(void *, u32);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c492423..ed34727 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -481,7 +481,7 @@ int wilc_connecting;
 static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			     struct connect_info *pstrConnectInfo,
 			     u8 u8MacStatus,
-			     tstrDisconnectNotifInfo *pstrDisconnectNotifInfo,
+			     struct disconnect_info *pstrDisconnectNotifInfo,
 			     void *pUserVoid)
 {
 	struct wilc_priv *priv;
-- 
2.7.1

