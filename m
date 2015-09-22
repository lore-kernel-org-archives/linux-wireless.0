Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33125 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:48:01 -0400
Received: by pacex6 with SMTP id ex6so10025299pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:48:01 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/9] staging: wilc1000: replace kmalloc/memcpy with kmemdup
Date: Tue, 22 Sep 2015 22:47:40 +0900
Message-Id: <1442929665-19709-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154806_234329_2905AF5C)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memset and memcpy with kmemdup.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index d8b8c3d..875b769 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -488,13 +488,10 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (u16IEsLen > 0) {
-			pstrNetworkInfo->pu8IEs = kmalloc(u16IEsLen, GFP_KERNEL);
+			pstrNetworkInfo->pu8IEs = kmemdup(pu8IEs, u16IEsLen,
+							  GFP_KERNEL);
 			if (!pstrNetworkInfo->pu8IEs)
 				return -ENOMEM;
-
-			memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
-
-			memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
 		}
 		pstrNetworkInfo->u16IEsLen = u16IEsLen;
 
@@ -578,13 +575,10 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		pu8IEs = &pu8Buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
-		pstrConnectRespInfo->pu8RespIEs = kmalloc(u16IEsLen, GFP_KERNEL);
+		pstrConnectRespInfo->pu8RespIEs = kmemdup(pu8IEs, u16IEsLen, GFP_KERNEL);
 		if (!pstrConnectRespInfo->pu8RespIEs)
 			return -ENOMEM;
 
-		memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
-
-		memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
 		pstrConnectRespInfo->u16RespIEsLen = u16IEsLen;
 	}
 
-- 
2.5.1

