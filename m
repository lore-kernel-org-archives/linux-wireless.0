Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33872 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbbGWNB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 09:01:28 -0400
Received: by pdbbh15 with SMTP id bh15so111295411pdb.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 06:01:27 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 2/3] staging: wilc1000: coreconfigurator.c: add kmalloc error check
Date: Thu, 23 Jul 2015 22:01:18 +0900
Message-Id: <1437656479-6173-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150723_150148_366892_9520D2DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add error check if memory allocation is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: use ! operator instead of NULL comparison

 drivers/staging/wilc1000/coreconfigurator.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 7e2b2ab41..9c3ecaa 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -812,6 +812,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u32 u32Tsf_Hi;
 
 		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_ATOMIC);
+		if (!pstrNetworkInfo)
+			return -ENOMEM;
+
 		WILC_memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
 
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
@@ -863,6 +866,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 		if (u16IEsLen > 0) {
 			pstrNetworkInfo->pu8IEs = kmalloc(u16IEsLen, GFP_ATOMIC);
+			if (!pstrNetworkInfo->pu8IEs)
+				return -ENOMEM;
+
 			WILC_memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
 
 			WILC_memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
@@ -930,6 +936,9 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	u16 u16IEsLen = 0;
 
 	pstrConnectRespInfo = kmalloc(sizeof(tstrConnectRespInfo), GFP_ATOMIC);
+	if (!pstrConnectRespInfo)
+		return -ENOMEM;
+
 	WILC_memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
 
 	/* u16AssocRespLen = pu8Buffer[0]; */
@@ -950,6 +959,9 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
 		pstrConnectRespInfo->pu8RespIEs = kmalloc(u16IEsLen, GFP_ATOMIC);
+		if (!pstrConnectRespInfo->pu8RespIEs)
+			return -ENOMEM;
+
 		WILC_memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
 
 		WILC_memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
-- 
1.9.1

