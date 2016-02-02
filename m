Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9070 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbcBBMFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:05:18 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/26] staging: wilc1000: renames struct connect_resp_info variables
Date: Tue, 2 Feb 2016 21:02:14 +0900
Message-ID: <1454414556-9822-4-git-send-email-leo.kim@atmel.com> (sfid-20160202_130522_812574_0E585F3F)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames to avoid camelcase and remove prefix names,
changes follow are:
 - u16capability to capability
 - u16ConnectStatus to status
 - u16AssocID to assoc_id
 - pu8RespIEs to ies
 - u16RespIEsLen to ies_len

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 14 +++++++-------
 drivers/staging/wilc1000/coreconfigurator.h | 10 +++++-----
 drivers/staging/wilc1000/host_interface.c   | 14 +++++++-------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c456a32..e9f6262 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -367,19 +367,19 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 
 	assoc_resp_len = (u16)buffer_len;
 
-	connect_resp_info->u16ConnectStatus = get_asoc_status(buffer);
-	if (connect_resp_info->u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
-		connect_resp_info->u16capability = get_assoc_resp_cap_info(buffer);
-		connect_resp_info->u16AssocID = get_asoc_id(buffer);
+	connect_resp_info->status = get_asoc_status(buffer);
+	if (connect_resp_info->status == SUCCESSFUL_STATUSCODE) {
+		connect_resp_info->capability = get_assoc_resp_cap_info(buffer);
+		connect_resp_info->assoc_id = get_asoc_id(buffer);
 
 		ies = &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		ies_len = assoc_resp_len - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
-		connect_resp_info->pu8RespIEs = kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!connect_resp_info->pu8RespIEs)
+		connect_resp_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!connect_resp_info->ies)
 			return -ENOMEM;
 
-		connect_resp_info->u16RespIEsLen = ies_len;
+		connect_resp_info->ies_len = ies_len;
 	}
 
 	*ret_connect_resp_info = connect_resp_info;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 611486b..aa9aee6 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -98,11 +98,11 @@ typedef struct {
 } tstrNetworkInfo;
 
 struct connect_resp_info {
-	u16 u16capability;
-	u16 u16ConnectStatus;
-	u16 u16AssocID;
-	u8 *pu8RespIEs;
-	u16 u16RespIEsLen;
+	u16 capability;
+	u16 status;
+	u16 assoc_id;
+	u8 *ies;
+	u16 ies_len;
 };
 
 typedef struct {
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a5042bb..f8dc657 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1493,19 +1493,19 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 					if (s32Err) {
 						PRINT_ER("wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
-						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->u16ConnectStatus;
+						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->status;
 
 						if (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
-							if (pstrConnectRespInfo->pu8RespIEs) {
-								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->u16RespIEsLen;
-								strConnectInfo.pu8RespIEs = kmalloc(pstrConnectRespInfo->u16RespIEsLen, GFP_KERNEL);
-								memcpy(strConnectInfo.pu8RespIEs, pstrConnectRespInfo->pu8RespIEs,
-									    pstrConnectRespInfo->u16RespIEsLen);
+							if (pstrConnectRespInfo->ies) {
+								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->ies_len;
+								strConnectInfo.pu8RespIEs = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
+								memcpy(strConnectInfo.pu8RespIEs, pstrConnectRespInfo->ies,
+								       pstrConnectRespInfo->ies_len);
 							}
 						}
 
 						if (pstrConnectRespInfo) {
-							kfree(pstrConnectRespInfo->pu8RespIEs);
+							kfree(pstrConnectRespInfo->ies);
 							kfree(pstrConnectRespInfo);
 						}
 					}
-- 
1.9.1

