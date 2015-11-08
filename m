Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36003 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbKHHum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:42 -0500
Received: by pacdm15 with SMTP id dm15so141914376pac.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:41 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 23/32] staging: wilc1000: use kmemdup in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:16 +0900
Message-Id: <1446968965-8958-23-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_091409_394410_960631AC)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes kmalloc followed by memcpy to kmemdup.
The error checking is also added when kmemdup is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0028bed..51b6ddb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3296,8 +3296,11 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 		key_len += TX_MIC_KEY_LEN;
 
 	if (key_rsc) {
-		msg.body.key_info.attr.wpa.seq = kmalloc(key_rsc_len, GFP_KERNEL);
-		memcpy(msg.body.key_info.attr.wpa.seq, key_rsc, key_rsc_len);
+		msg.body.key_info.attr.wpa.seq = kmemdup(key_rsc,
+							 key_rsc_len,
+							 GFP_KERNEL);
+		if (!msg.body.key_info.attr.wpa.seq)
+			return -ENOMEM;
 	}
 
 	msg.id = HOST_IF_MSG_KEY;
@@ -3311,8 +3314,11 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.key = kmalloc(key_len, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wpa.key, rx_gtk, gtk_key_len);
+	msg.body.key_info.attr.wpa.key = kmemdup(rx_gtk,
+						 key_len,
+						 GFP_KERNEL);
+	if (!msg.body.key_info.attr.wpa.key)
+		return -ENOMEM;
 
 	if (rx_mic)
 		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic,
-- 
2.6.3

