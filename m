Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36085 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbJEKgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:36:08 -0400
Received: by pablk4 with SMTP id lk4so172817445pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:36:07 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 19/20] staging: wilc1000: fix NULL comparison in host_int_remove_wep_key
Date: Mon,  5 Oct 2015 19:35:03 +0900
Message-Id: <1444041304-7727-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123611_900191_6C1FD535)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes NULL comparison style in host_int_remove_wep_key found
by checkpatch.

CHECK: Comparison to NULL could be written "!wfi_drv"
FILE: drivers/staging/wilc1000/host_interface.c:4300

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6936bff..ade9be02 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4296,7 +4296,7 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 	int result = 0;
 	struct host_if_msg msg;
 
-	if (wfi_drv == NULL) {
+	if (!wfi_drv) {
 		result = -EFAULT;
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		return result;
-- 
2.6.0

