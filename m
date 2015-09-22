Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33085 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:47:58 -0400
Received: by pacex6 with SMTP id ex6so10024271pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:47:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/9] staging: wilc1000: replace kmalloc with kzalloc
Date: Tue, 22 Sep 2015 22:47:39 +0900
Message-Id: <1442929665-19709-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154801_490483_4F3A94C1)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc with kzalloc because it is initialized by 0
immediately after allcating memory.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 3813767..d8b8c3d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -439,12 +439,10 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u32 u32Tsf_Lo;
 		u32 u32Tsf_Hi;
 
-		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
+		pstrNetworkInfo = kzalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
 		if (!pstrNetworkInfo)
 			return -ENOMEM;
 
-		memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
-
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
 
 		/* Assign a pointer to msa "Mac Header Start Address" */
@@ -559,12 +557,10 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	u8 *pu8IEs = NULL;
 	u16 u16IEsLen = 0;
 
-	pstrConnectRespInfo = kmalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
+	pstrConnectRespInfo = kzalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
 	if (!pstrConnectRespInfo)
 		return -ENOMEM;
 
-	memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
-
 	/* u16AssocRespLen = pu8Buffer[0]; */
 	u16AssocRespLen = (u16)u32BufferLen;
 
-- 
2.5.1

