Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36013 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbbG3LlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 07:41:18 -0400
Received: by pdjr16 with SMTP id r16so23802621pdj.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 04:41:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [RESEND V2 1/3] staging: wilc1000: coreconfigurator.c: remove WILC_MALLOC
Date: Thu, 30 Jul 2015 20:41:03 +0900
Message-Id: <1438256465-19540-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150730_134120_746210_F528EFBD)
In-Reply-To: <1438256465-19540-1-git-send-email-chaehyun.lim@gmail.com>
References: <1438256465-19540-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kmalloc and kmalloc_array instead of WILC_MALLOC.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 342a336..37e09b8 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -674,7 +674,7 @@ s32 CoreConfiguratorInit(void)
 	sema_init(&SemHandleSendPkt, 1);
 	sema_init(&SemHandlePktResp, 0);
 
-	gps8ConfigPacket = (s8 *)WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
+	gps8ConfigPacket = kmalloc(MAX_PACKET_BUFF_SIZE, GFP_KERNEL);
 	if (gps8ConfigPacket == NULL) {
 		PRINT_ER("failed in gps8ConfigPacket allocation\n");
 		s32Error = WILC_NO_MEM;
@@ -811,7 +811,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u32 u32Tsf_Lo;
 		u32 u32Tsf_Hi;
 
-		pstrNetworkInfo = (tstrNetworkInfo *)WILC_MALLOC(sizeof(tstrNetworkInfo));
+		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
 		WILC_memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
 
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
@@ -861,7 +861,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (u16IEsLen > 0) {
-			pstrNetworkInfo->pu8IEs = (u8 *)WILC_MALLOC(u16IEsLen);
+			pstrNetworkInfo->pu8IEs = kmalloc(u16IEsLen, GFP_KERNEL);
 			WILC_memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
 
 			WILC_memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
@@ -928,7 +928,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	u8 *pu8IEs = 0;
 	u16 u16IEsLen = 0;
 
-	pstrConnectRespInfo = (tstrConnectRespInfo *)WILC_MALLOC(sizeof(tstrConnectRespInfo));
+	pstrConnectRespInfo = kmalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
 	WILC_memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
 
 	/* u16AssocRespLen = pu8Buffer[0]; */
@@ -948,7 +948,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		pu8IEs = &pu8Buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
-		pstrConnectRespInfo->pu8RespIEs = (u8 *)WILC_MALLOC(u16IEsLen);
+		pstrConnectRespInfo->pu8RespIEs = kmalloc(u16IEsLen, GFP_KERNEL);
 		WILC_memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
 
 		WILC_memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
@@ -1017,7 +1017,8 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 		}
 	}
 
-	pstrSurveyResults = (wid_site_survey_reslts_s *)WILC_MALLOC(u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
+	pstrSurveyResults = kmalloc_array(u32SurveyResultsCount,
+				sizeof(wid_site_survey_reslts_s), GFP_KERNEL);
 	if (pstrSurveyResults == NULL) {
 		u32SurveyResultsCount = 0;
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-- 
1.9.1

