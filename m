Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33682 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbJBMpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 08:45:18 -0400
Received: by pacex6 with SMTP id ex6so106323995pac.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 05:45:18 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/10] staging: wilc1000: replace PRINT_ER with pr_err
Date: Fri,  2 Oct 2015 21:44:50 +0900
Message-Id: <1443789896-7082-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_144522_910098_34E6A47A)
In-Reply-To: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces PRINT_ER with pr_err.
It would be better to use netdev_err, but it cannot use it in this
function, so just use pr_err.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 566e618..802d87a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5322,7 +5322,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	struct host_if_msg msg;
 
 	if (!pstrWFIDrv) {
-		PRINT_ER("driver is null\n");
+		pr_err("driver is null\n");
 		return -EFAULT;
 	}
 
@@ -5334,7 +5334,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("wilc mq send fail\n");
+		pr_err("wilc mq send fail\n");
 		result = -EINVAL;
 	}
 
-- 
2.6.0

