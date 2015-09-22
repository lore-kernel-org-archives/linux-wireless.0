Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34161 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:48:17 -0400
Received: by padhy16 with SMTP id hy16so10104489pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:48:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 9/9] staging: wilc1000: parse_network_info: remove s32Error
Date: Tue, 22 Sep 2015 22:47:45 +0900
Message-Id: <1442929665-19709-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154821_246437_C3F760B7)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s32Error is defined, but not used anywhere in this function.
Then just delete it and return 0 at the end of this function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 3c71b9f..68e3c7f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -362,7 +362,6 @@ u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
  */
 s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 {
-	s32 s32Error = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	u8 u8MsgType = 0;
 	u8 u8MsgID = 0;
@@ -466,7 +465,7 @@ s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 	*ppstrNetworkInfo = pstrNetworkInfo;
 
-	return s32Error;
+	return 0;
 }
 
 /**
-- 
2.5.1

