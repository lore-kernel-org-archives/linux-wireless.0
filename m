Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34611 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbJ0LlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 07:41:02 -0400
Received: by padhk11 with SMTP id hk11so220890268pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 04:41:01 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/8] staging: wilc1000: replace kmalloc/memcpy with kmemdup
Date: Tue, 27 Oct 2015 20:40:37 +0900
Message-Id: <1445946039-10390-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151027_124106_282768_8042A12D)
In-Reply-To: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.
It is also added error checking of kmemdup.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f7dc61b..50362c4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3177,8 +3177,10 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
-	msg.body.key_info.attr.wep.key = kmalloc(len, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wep.key, key, len);
+	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
+	if (!msg.body.key_info.attr.wep.key)
+		return -ENOMEM;
+
 	msg.body.key_info.attr.wep.key_len = len;
 	msg.body.key_info.attr.wep.index = index;
 
-- 
2.6.1

