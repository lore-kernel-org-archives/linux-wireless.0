Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36258 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbLVAti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:38 -0500
Received: by mail-pf0-f175.google.com with SMTP id o64so96680894pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:38 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/13] staging: wilc1000: replace u32 with int
Date: Tue, 22 Dec 2015 09:49:04 +0900
Message-Id: <1450745349-16811-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014941_369302_5F559870)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The data type of variable i changes u32 to int.
It is used as array index to copy some data with memcpy function
so that it is better to use data type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c976c1f..3ad4b0e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3297,7 +3297,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
-	u32 i;
+	int i;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
-- 
2.6.4

