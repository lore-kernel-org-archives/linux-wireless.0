Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35082 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbcBYAQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:15 -0500
Received: by mail-pf0-f171.google.com with SMTP id c10so22702368pfc.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:15 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/9] staging: wilc1000: rename u16RespIEsLen in struct connect_info
Date: Thu, 25 Feb 2016 09:15:47 +0900
Message-Id: <1456359350-17118-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011622_036865_9E5B6AAF)
In-Reply-To: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16RespIEsLen to resp_ies_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index bb4c256..408031f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -110,7 +110,7 @@ struct connect_info {
 	u8 *req_ies;
 	size_t req_ies_len;
 	u8 *resp_ies;
-	u16 u16RespIEsLen;
+	u16 resp_ies_len;
 	u16 u16ConnectStatus;
 };
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c273935..58902bf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1467,7 +1467,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 						if (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
 							if (pstrConnectRespInfo->ies) {
-								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->ies_len;
+								strConnectInfo.resp_ies_len = pstrConnectRespInfo->ies_len;
 								strConnectInfo.resp_ies = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
 								memcpy(strConnectInfo.resp_ies, pstrConnectRespInfo->ies,
 								       pstrConnectRespInfo->ies_len);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7e10d34..1dbeca5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -545,7 +545,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 		cfg80211_connect_result(dev, pstrConnectInfo->bssid,
 					pstrConnectInfo->req_ies, pstrConnectInfo->req_ies_len,
-					pstrConnectInfo->resp_ies, pstrConnectInfo->u16RespIEsLen,
+					pstrConnectInfo->resp_ies, pstrConnectInfo->resp_ies_len,
 					u16ConnectStatus, GFP_KERNEL);
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
 		wilc_optaining_ip = false;
-- 
2.7.1

