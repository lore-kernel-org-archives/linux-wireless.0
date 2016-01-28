Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12328 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbcA1HRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 02:17:02 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/12] staging: wilc1000: wilc_parse_assoc_resp_info(): renames local variables
Date: Thu, 28 Jan 2016 16:13:44 +0900
Message-ID: <1453965226-6158-10-git-send-email-leo.kim@atmel.com> (sfid-20160128_081709_085251_5152E7E7)
In-Reply-To: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames to avoid camelcase, changes follow are:
 - pstrConnectRespInfo to connect_resp_info
 - u16AssocRespLen to assoc_resp_len
 - pu8IEs to ies
 - u16IEsLen to ies_len

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 34 ++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 48c8573..c0be33d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -379,33 +379,33 @@ s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       tstrConnectRespInfo **ret_connect_resp_info)
 {
-	tstrConnectRespInfo *pstrConnectRespInfo = NULL;
-	u16 u16AssocRespLen = 0;
-	u8 *pu8IEs = NULL;
-	u16 u16IEsLen = 0;
+	tstrConnectRespInfo *connect_resp_info = NULL;
+	u16 assoc_resp_len = 0;
+	u8 *ies = NULL;
+	u16 ies_len = 0;
 
-	pstrConnectRespInfo = kzalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
-	if (!pstrConnectRespInfo)
+	connect_resp_info = kzalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
+	if (!connect_resp_info)
 		return -ENOMEM;
 
-	u16AssocRespLen = (u16)buffer_len;
+	assoc_resp_len = (u16)buffer_len;
 
-	pstrConnectRespInfo->u16ConnectStatus = get_asoc_status(buffer);
-	if (pstrConnectRespInfo->u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
-		pstrConnectRespInfo->u16capability = get_assoc_resp_cap_info(buffer);
-		pstrConnectRespInfo->u16AssocID = get_asoc_id(buffer);
+	connect_resp_info->u16ConnectStatus = get_asoc_status(buffer);
+	if (connect_resp_info->u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
+		connect_resp_info->u16capability = get_assoc_resp_cap_info(buffer);
+		connect_resp_info->u16AssocID = get_asoc_id(buffer);
 
-		pu8IEs = &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
-		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
+		ies = &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
+		ies_len = assoc_resp_len - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
-		pstrConnectRespInfo->pu8RespIEs = kmemdup(pu8IEs, u16IEsLen, GFP_KERNEL);
-		if (!pstrConnectRespInfo->pu8RespIEs)
+		connect_resp_info->pu8RespIEs = kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!connect_resp_info->pu8RespIEs)
 			return -ENOMEM;
 
-		pstrConnectRespInfo->u16RespIEsLen = u16IEsLen;
+		connect_resp_info->u16RespIEsLen = ies_len;
 	}
 
-	*ret_connect_resp_info = pstrConnectRespInfo;
+	*ret_connect_resp_info = connect_resp_info;
 
 	return 0;
 }
-- 
1.9.1

