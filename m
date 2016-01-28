Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12289 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbcA1HQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 02:16:57 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/12] staging: wilc1000: wilc_parse_assoc_resp_info(): renames function variables
Date: Thu, 28 Jan 2016 16:13:43 +0900
Message-ID: <1453965226-6158-9-git-send-email-leo.kim@atmel.com> (sfid-20160128_081706_072753_43A94D1D)
In-Reply-To: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames to avoid camelcase, changes follow are:
 - pu8Buffer to buffer
 - u32BufferLen to buffer_len
 - ppstrConnectRespInfo to ret_connect_resp_info

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 16 ++++++++--------
 drivers/staging/wilc1000/coreconfigurator.h |  5 ++---
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 88e5661..48c8573 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -376,8 +376,8 @@ s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
 	return result;
 }
 
-s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
-			       tstrConnectRespInfo **ppstrConnectRespInfo)
+s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
+			       tstrConnectRespInfo **ret_connect_resp_info)
 {
 	tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 	u16 u16AssocRespLen = 0;
@@ -388,14 +388,14 @@ s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 	if (!pstrConnectRespInfo)
 		return -ENOMEM;
 
-	u16AssocRespLen = (u16)u32BufferLen;
+	u16AssocRespLen = (u16)buffer_len;
 
-	pstrConnectRespInfo->u16ConnectStatus = get_asoc_status(pu8Buffer);
+	pstrConnectRespInfo->u16ConnectStatus = get_asoc_status(buffer);
 	if (pstrConnectRespInfo->u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
-		pstrConnectRespInfo->u16capability = get_assoc_resp_cap_info(pu8Buffer);
-		pstrConnectRespInfo->u16AssocID = get_asoc_id(pu8Buffer);
+		pstrConnectRespInfo->u16capability = get_assoc_resp_cap_info(buffer);
+		pstrConnectRespInfo->u16AssocID = get_asoc_id(buffer);
 
-		pu8IEs = &pu8Buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
+		pu8IEs = &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
 		pstrConnectRespInfo->pu8RespIEs = kmemdup(pu8IEs, u16IEsLen, GFP_KERNEL);
@@ -405,7 +405,7 @@ s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 		pstrConnectRespInfo->u16RespIEsLen = u16IEsLen;
 	}
 
-	*ppstrConnectRespInfo = pstrConnectRespInfo;
+	*ret_connect_resp_info = pstrConnectRespInfo;
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index aec0779..6a2c323 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -122,9 +122,8 @@ typedef struct {
 
 s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
 s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
-
-s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
-		       tstrConnectRespInfo **ppstrConnectRespInfo);
+s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
+			       tstrConnectRespInfo **ret_connect_resp_info);
 s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 				 u32 u32Length);
-- 
1.9.1

