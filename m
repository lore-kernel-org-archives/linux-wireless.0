Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33965 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcAEOHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:34 -0500
Received: by mail-pf0-f170.google.com with SMTP id e65so167954585pfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:34 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/13] staging: wilc1000: use kmemdup instead of kmalloc/memcpy
Date: Tue,  5 Jan 2016 23:06:55 +0900
Message-Id: <1452002817-30937-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150737_436118_38ED3771)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.
It is also added error checking to return -ENOMEM when kmemdup is
failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 85aae56..8d022a0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3704,12 +3704,16 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	msg.body.scan_info.arg = user_arg;
 
 	msg.body.scan_info.ch_list_len = ch_list_len;
-	msg.body.scan_info.ch_freq_list = kmalloc(ch_list_len, GFP_KERNEL);
-	memcpy(msg.body.scan_info.ch_freq_list, ch_freq_list, ch_list_len);
+	msg.body.scan_info.ch_freq_list = kmemdup(ch_freq_list,
+						  ch_list_len,
+						  GFP_KERNEL);
+	if (!msg.body.scan_info.ch_freq_list)
+		return -ENOMEM;
 
 	msg.body.scan_info.ies_len = ies_len;
-	msg.body.scan_info.ies = kmalloc(ies_len, GFP_KERNEL);
-	memcpy(msg.body.scan_info.ies, ies, ies_len);
+	msg.body.scan_info.ies = kmemdup(ies, ies_len, GFP_KERNEL);
+	if (!msg.body.scan_info.ies)
+		return -ENOMEM;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-- 
2.6.4

