Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36032 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbJEKgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:36:05 -0400
Received: by pablk4 with SMTP id lk4so172816233pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:36:04 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/20] staging: wilc1000: remove multiple blank in host_int_remove_wep_key
Date: Mon,  5 Oct 2015 19:35:02 +0900
Message-Id: <1444041304-7727-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123609_021277_48BE7051)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes multiple blank in host_int_remove_wep_key found by
checkpatch.

CHECK: Please don't use multiple blank lines
FILE: drivers/staging/wilc1000/host_interface.c:4299:
FILE: drivers/staging/wilc1000/host_interface.c:4309:
FILE: drivers/staging/wilc1000/host_interface.c:4315:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e284afb..6936bff 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4296,7 +4296,6 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 	int result = 0;
 	struct host_if_msg msg;
 
-
 	if (wfi_drv == NULL) {
 		result = -EFAULT;
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -4306,14 +4305,11 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 	/* prepare the Remove Wep Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = REMOVEKEY;
 	msg.drvHandler = wfi_drv;
 
-
-
 	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = index;
 
-- 
2.6.0

