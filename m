Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33195 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbKHHuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:00 -0500
Received: by pabfh17 with SMTP id fh17so166195539pab.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:59 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/32] staging: wilc1000: replace u32 with int
Date: Sun,  8 Nov 2015 16:49:02 +0900
Message-Id: <1446968965-8958-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085005_162249_93A3CBA7)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The data type of variable i changes u32 to int.
It is used as array index to print debug message so that it is better to
use data type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fedd099..a959f48 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3215,7 +3215,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	int result = 0;
 	struct host_if_msg msg;
 	u8 u8KeyLen = ptk_key_len;
-	u32 i;
+	int i;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
-- 
2.6.3

