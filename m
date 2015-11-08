Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36744 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbKHHuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:06 -0500
Received: by pacdm15 with SMTP id dm15so141906438pac.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:05 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/32] staging: wilc1000: use kmemdup in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:49:04 +0900
Message-Id: <1446968965-8958-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085011_900777_2F513EBA)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes kmalloc followed by memcpy to kmemdup
The error checking is also added when kmemdup is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dd7e8ed..18623c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3239,8 +3239,9 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.key = kmalloc(ptk_key_len, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wpa.key, ptk, ptk_key_len);
+	msg.body.key_info.attr.wpa.key = kmemdup(ptk, ptk_key_len, GFP_KERNEL);
+	if (!msg.body.key_info.attr.wpa.key)
+		return -ENOMEM;
 
 	if (rx_mic) {
 		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic, RX_MIC_KEY_LEN);
-- 
2.6.3

