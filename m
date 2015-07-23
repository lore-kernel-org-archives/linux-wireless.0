Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34420 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbbGWX4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 19:56:09 -0400
Received: by pdbbh15 with SMTP id bh15so3834533pdb.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 16:56:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 3/3] staging: wilc1000: coreconfigurator.c: fix kmalloc error check
Date: Fri, 24 Jul 2015 08:55:55 +0900
Message-Id: <1437695755-9731-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150724_015613_786571_5412E7AD)
In-Reply-To: <1437695755-9731-1-git-send-email-chaehyun.lim@gmail.com>
References: <1437695755-9731-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return -ENOMEM if memory allocation is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: Use ! operator instead of NULL comparison
V3: this patch is rebased by previous modification

 drivers/staging/wilc1000/coreconfigurator.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 0ff9705..b2abd8b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -675,11 +675,8 @@ s32 CoreConfiguratorInit(void)
 	sema_init(&SemHandlePktResp, 0);
 
 	gps8ConfigPacket = kmalloc(MAX_PACKET_BUFF_SIZE, GFP_KERNEL);
-	if (gps8ConfigPacket == NULL) {
-		PRINT_ER("failed in gps8ConfigPacket allocation\n");
-		s32Error = WILC_NO_MEM;
-		goto _fail_;
-	}
+	if (!gps8ConfigPacket)
+		return -ENOMEM;
 
 	WILC_memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
 
@@ -1032,10 +1029,8 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 
 	pstrSurveyResults = kmalloc_array(u32SurveyResultsCount,
 				sizeof(wid_site_survey_reslts_s), GFP_KERNEL);
-	if (pstrSurveyResults == NULL) {
-		u32SurveyResultsCount = 0;
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
+	if (!pstrSurveyResults)
+		return -ENOMEM;
 
 	WILC_memset((void *)(pstrSurveyResults), 0, u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
 
-- 
1.9.1

