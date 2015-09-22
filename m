Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33256 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:48:11 -0400
Received: by pacex6 with SMTP id ex6so10028613pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:48:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/9] staging: wilc1000: remove extern declaration
Date: Tue, 22 Sep 2015 22:47:43 +0900
Message-Id: <1442929665-19709-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154815_187429_6903A424)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes extern declaration of *gpstrWlanOps in
coreconfigurator.c file. It is defined extern declaration in
wilc_wlan_if.h file and then is included in coreconfigurator.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 47a37fa..bdf775a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -10,6 +10,7 @@
 
 
 #include "coreconfigurator.h"
+#include "wilc_wlan_if.h"
 #include <linux/errno.h>
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
@@ -654,7 +655,6 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 }
 #endif
 
-extern wilc_wlan_oup_t *gpstrWlanOps;
 /**
  *  @brief              sends certain Configuration Packet based on the input WIDs pstrWIDs
  *  using driver config layer
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 5f68b6a..668f1b8 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -912,6 +912,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup);
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
 u32 wilc_get_chipid(u8 update);
+extern wilc_wlan_oup_t *gpstrWlanOps;
 
 
 #endif
-- 
2.5.1

