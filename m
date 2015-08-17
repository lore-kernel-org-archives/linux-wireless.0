Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33392 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbHQCFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 22:05:35 -0400
Received: by pabyb7 with SMTP id yb7so97251098pab.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2015 19:05:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/6] staging: wilc1000: coreconfigurator.c: use kmalloc instead of WILC_MALLOC
Date: Mon, 17 Aug 2015 11:05:14 +0900
Message-Id: <1439777115-25861-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_040537_778570_9D6D7CBB)
In-Reply-To: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kmalloc is used to handle host interface message within kernel thread.
The manipulation of host interface message is not called on IRQ context
and I could not find any spinlock inside function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4a6b975..f44d2ce 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -800,7 +800,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u32 u32Tsf_Lo;
 		u32 u32Tsf_Hi;
 
-		pstrNetworkInfo = WILC_MALLOC(sizeof(tstrNetworkInfo));
+		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
 		memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
 
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
@@ -850,7 +850,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (u16IEsLen > 0) {
-			pstrNetworkInfo->pu8IEs = WILC_MALLOC(u16IEsLen);
+			pstrNetworkInfo->pu8IEs = kmalloc(u16IEsLen, GFP_KERNEL);
 			memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
 
 			memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
@@ -917,7 +917,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	u8 *pu8IEs = 0;
 	u16 u16IEsLen = 0;
 
-	pstrConnectRespInfo = WILC_MALLOC(sizeof(tstrConnectRespInfo));
+	pstrConnectRespInfo = kmalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
 	memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
 
 	/* u16AssocRespLen = pu8Buffer[0]; */
@@ -937,7 +937,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		pu8IEs = &pu8Buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
-		pstrConnectRespInfo->pu8RespIEs = WILC_MALLOC(u16IEsLen);
+		pstrConnectRespInfo->pu8RespIEs = kmalloc(u16IEsLen, GFP_KERNEL);
 		memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
 
 		memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
@@ -1006,7 +1006,8 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 		}
 	}
 
-	pstrSurveyResults = WILC_MALLOC(u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
+	pstrSurveyResults = kmalloc_array(u32SurveyResultsCount,
+				sizeof(wid_site_survey_reslts_s), GFP_KERNEL);
 	if (pstrSurveyResults == NULL) {
 		u32SurveyResultsCount = 0;
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-- 
1.9.1

