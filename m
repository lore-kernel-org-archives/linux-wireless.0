Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33529 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:59:06 -0400
Received: by pacex6 with SMTP id ex6so116414188pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:59:05 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/16] staging: wilc1000: host_int_init: fix kzalloc error check
Date: Mon, 21 Sep 2015 21:58:21 +0900
Message-Id: <1442840306-9657-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_151653_816078_5AE68E49)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes error check when kzalloc is failed.
NULL comparison style is changed to use ! operator and
PRINT_ER is also removed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
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

