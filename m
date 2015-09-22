Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32940 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:38 -0400
Received: by pacex6 with SMTP id ex6so4751503pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 11/16] staging: wilc1000: host_int_init: fix kzalloc error check
Date: Tue, 22 Sep 2015 18:34:56 +0900
Message-Id: <1442914501-2315-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_114653_831589_798F9721)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes error check when kzalloc is failed.
NULL comparison style is changed to use ! operator and
PRINT_ER is also removed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8c0c478..2150c89 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6372,9 +6372,8 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = kzalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
-	if (pstrWFIDrv == NULL) {
+	if (!pstrWFIDrv) {
 		s32Error = -ENOMEM;
-		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
 	}
 	*phWFIDrv = pstrWFIDrv;
-- 
2.5.1

