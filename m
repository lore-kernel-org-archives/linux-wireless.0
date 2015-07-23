Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35125 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbbGWLTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 07:19:37 -0400
Received: by pdrg1 with SMTP id g1so155750976pdr.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 04:19:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/3] staging: wilc1000: coreconfigurator.c: fix kmalloc error check
Date: Thu, 23 Jul 2015 20:19:19 +0900
Message-Id: <1437650359-2051-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150723_131940_922879_26EB473D)
In-Reply-To: <1437650359-2051-1-git-send-email-chaehyun.lim@gmail.com>
References: <1437650359-2051-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return -ENOMEM if memory allocation is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b51c15f..eca21bf 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -675,11 +675,8 @@ s32 CoreConfiguratorInit(void)
 	sema_init(&SemHandlePktResp, 0);
 
 	gps8ConfigPacket = kmalloc(MAX_PACKET_BUFF_SIZE, GFP_ATOMIC);
-	if (gps8ConfigPacket == NULL) {
-		PRINT_ER("failed in gps8ConfigPacket allocation\n");
-		s32Error = WILC_NO_MEM;
-		goto _fail_;
-	}
+	if (gps8ConfigPacket == NULL)
+		return -ENOMEM;
 
 	WILC_memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
 
@@ -1032,10 +1029,8 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 
 	pstrSurveyResults = kmalloc_array(u32SurveyResultsCount,
 				sizeof(wid_site_survey_reslts_s), GFP_ATOMIC);
-	if (pstrSurveyResults == NULL) {
-		u32SurveyResultsCount = 0;
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
+	if (pstrSurveyResults == NULL)
+		return -ENOMEM;
 
 	WILC_memset((void *)(pstrSurveyResults), 0, u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
 
-- 
1.9.1

