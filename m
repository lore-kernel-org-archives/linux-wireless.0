Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33167 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:48:04 -0400
Received: by pacex6 with SMTP id ex6so10026356pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:48:04 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/9] staging: wilc1000: replace kmalloc_array/memset with kcalloc
Date: Tue, 22 Sep 2015 22:47:41 +0900
Message-Id: <1442929665-19709-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154809_829307_66FCFAF2)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc_array followed by memset with kcalloc.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 875b769..8b56b92 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -644,13 +644,11 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 		}
 	}
 
-	pstrSurveyResults = kmalloc_array(u32SurveyResultsCount,
-				sizeof(wid_site_survey_reslts_s), GFP_KERNEL);
+	pstrSurveyResults = kcalloc(u32SurveyResultsCount,
+				    sizeof(wid_site_survey_reslts_s), GFP_KERNEL);
 	if (!pstrSurveyResults)
 		return -ENOMEM;
 
-	memset((void *)(pstrSurveyResults), 0, u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
-
 	u32SurveyResultsCount = 0;
 
 	for (i = 0; i < u32RcvdSurveyResultsNum; i++) {
-- 
2.5.1

