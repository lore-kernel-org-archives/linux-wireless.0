Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12267 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbcA1HQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 02:16:51 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/12] staging: wilc1000: rename variable s32Error
Date: Thu, 28 Jan 2016 16:13:42 +0900
Message-ID: <1453965226-6158-8-git-send-email-leo.kim@atmel.com> (sfid-20160128_081712_368882_9C9196B5)
In-Reply-To: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames variable s32Error to result
to avoid CamelCase naming convention.
Also, remove the unused variable s32Error and replace with direct return.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2a4e324..88e5661 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -356,30 +356,29 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 
 s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	if (pstrNetworkInfo) {
 		if (pstrNetworkInfo->pu8IEs) {
 			kfree(pstrNetworkInfo->pu8IEs);
 			pstrNetworkInfo->pu8IEs = NULL;
 		} else {
-			s32Error = -EFAULT;
+			result = -EFAULT;
 		}
 
 		kfree(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
 
 	} else {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
-	return s32Error;
+	return result;
 }
 
 s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 			       tstrConnectRespInfo **ppstrConnectRespInfo)
 {
-	s32 s32Error = 0;
 	tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 	u16 u16AssocRespLen = 0;
 	u8 *pu8IEs = NULL;
@@ -408,27 +407,27 @@ s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 
 	*ppstrConnectRespInfo = pstrConnectRespInfo;
 
-	return s32Error;
+	return 0;
 }
 
 s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	if (pstrConnectRespInfo) {
 		if (pstrConnectRespInfo->pu8RespIEs) {
 			kfree(pstrConnectRespInfo->pu8RespIEs);
 			pstrConnectRespInfo->pu8RespIEs = NULL;
 		} else {
-			s32Error = -EFAULT;
+			result = -EFAULT;
 		}
 
 		kfree(pstrConnectRespInfo);
 		pstrConnectRespInfo = NULL;
 
 	} else {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
-	return s32Error;
+	return result;
 }
-- 
1.9.1

