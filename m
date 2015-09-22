Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32888 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:34 -0400
Received: by pacex6 with SMTP id ex6so4750327pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 10/16] staging: wilc1000: host_int_init: replace kmalloc with kzalloc
Date: Tue, 22 Sep 2015 18:34:55 +0900
Message-Id: <1442914501-2315-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113538_948529_CE28E7F3)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc with kzalloc in host_int_init.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 317bc60..8c0c478 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6371,13 +6371,12 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 
 	/*Allocate host interface private structure*/
-	pstrWFIDrv  = kmalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
+	pstrWFIDrv  = kzalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (pstrWFIDrv == NULL) {
 		s32Error = -ENOMEM;
 		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
 	}
-	memset(pstrWFIDrv, 0, sizeof(tstrWILC_WFIDrv));
 	*phWFIDrv = pstrWFIDrv;
 	err = add_handler_in_list(pstrWFIDrv);
 	if (err) {
-- 
2.5.1

