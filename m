Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35971 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbbJBMpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 08:45:12 -0400
Received: by pablk4 with SMTP id lk4so105513234pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 05:45:12 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/10] staging: wilc1000: fix NULL comparison style
Date: Fri,  2 Oct 2015 21:44:48 +0900
Message-Id: <1443789896-7082-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_144517_033766_F6A90686)
In-Reply-To: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes NULL comparison style to use ! operator found by
checkpatch.pl

CHECK: Comparison to NULL could be written "!pstrWFIDrv"
drivers/staging/wilc1000/host_interface.c:5324:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c635b84..65bd325 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5321,7 +5321,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!pstrWFIDrv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
-- 
2.6.0

