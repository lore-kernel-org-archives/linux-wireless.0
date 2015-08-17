Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34863 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbbHQCFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 22:05:38 -0400
Received: by pacgr6 with SMTP id gr6so97255070pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2015 19:05:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/6] staging: wilc1000: coreconfigurator.c: fix kmalloc error check
Date: Mon, 17 Aug 2015 11:05:15 +0900
Message-Id: <1439777115-25861-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_040540_882376_870F46E1)
In-Reply-To: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is added and fixed error check when kmalloc is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index f44d2ce..64b57c0 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -801,6 +801,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u32 u32Tsf_Hi;
 
 		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
+		if (!pstrNetworkInfo)
+			return -ENOMEM;
+
 		memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
 
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
@@ -851,6 +854,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 		if (u16IEsLen > 0) {
 			pstrNetworkInfo->pu8IEs = kmalloc(u16IEsLen, GFP_KERNEL);
+			if (!pstrNetworkInfo->pu8IEs)
+				return -ENOMEM;
+
 			memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
 
 			memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
@@ -918,6 +924,9 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	u16 u16IEsLen = 0;
 
 	pstrConnectRespInfo = kmalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
+	if (!pstrConnectRespInfo)
+		return -ENOMEM;
+
 	memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
 
 	/* u16AssocRespLen = pu8Buffer[0]; */
@@ -938,6 +947,9 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
 		pstrConnectRespInfo->pu8RespIEs = kmalloc(u16IEsLen, GFP_KERNEL);
+		if (!pstrConnectRespInfo->pu8RespIEs)
+			return -ENOMEM;
+
 		memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
 
 		memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
@@ -1008,10 +1020,8 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 
 	pstrSurveyResults = kmalloc_array(u32SurveyResultsCount,
 				sizeof(wid_site_survey_reslts_s), GFP_KERNEL);
-	if (pstrSurveyResults == NULL) {
-		u32SurveyResultsCount = 0;
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
+	if (!pstrSurveyResults)
+		return -ENOMEM;
 
 	memset((void *)(pstrSurveyResults), 0, u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
 
-- 
1.9.1

