Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33130 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbbJ0XUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 19:20:02 -0400
Received: by pabla5 with SMTP id la5so42958407pab.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 16:20:02 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/10] staging: wilc1000: replace kmalloc/memcpy with kmemdup
Date: Wed, 28 Oct 2015 08:19:27 +0900
Message-Id: <1445987968-18974-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151028_002007_221105_1F5AF13F)
In-Reply-To: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.
It is also added error checking to return -ENOMEM when kmemdup is
failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2f4f699..0b70ada 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3217,8 +3217,10 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY_AP;
 	msg.drv = hif_drv;
-	msg.body.key_info.attr.wep.key = kmalloc(len, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wep.key, key, len);
+	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
+	if (!msg.body.key_info.attr.wep.key)
+		return -ENOMEM;
+
 	msg.body.key_info.attr.wep.key_len = len;
 	msg.body.key_info.attr.wep.index = index;
 	msg.body.key_info.attr.wep.mode = mode;
-- 
2.6.1

