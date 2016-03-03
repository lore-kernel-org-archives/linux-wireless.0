Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34495 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbcCCMG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 07:06:29 -0500
Received: by mail-pf0-f195.google.com with SMTP id 184so1213680pff.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 04:06:28 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/6] staging: wilc1000: remove unnecessary comments
Date: Thu,  3 Mar 2016 21:05:21 +0900
Message-Id: <1457006722-14400-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_130632_413843_0C1E8954)
In-Reply-To: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
References: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary comments because enum cfg_cmd_type
shows each command type without it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 9cf68b7..92f6d32 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -378,18 +378,18 @@ int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 	u8 type = (id >> 12) & 0xf;
 	int ret = 0;
 
-	if (type == CFG_BYTE_CMD) {                                        /* byte command */
+	if (type == CFG_BYTE_CMD) {
 		if (size >= 1)
 			ret = wilc_wlan_cfg_set_byte(frame, offset, id, *buf);
-	} else if (type == CFG_HWORD_CMD) {                 /* half word command */
+	} else if (type == CFG_HWORD_CMD) {
 		if (size >= 2)
 			ret = wilc_wlan_cfg_set_hword(frame, offset, id, *((u16 *)buf));
-	} else if (type == CFG_WORD_CMD) {                 /* word command */
+	} else if (type == CFG_WORD_CMD) {
 		if (size >= 4)
 			ret = wilc_wlan_cfg_set_word(frame, offset, id, *((u32 *)buf));
-	} else if (type == CFG_STR_CMD) {                 /* string command */
+	} else if (type == CFG_STR_CMD) {
 		ret = wilc_wlan_cfg_set_str(frame, offset, id, buf, size);
-	} else if (type == CFG_BIN_CMD) {                 /* binary command */
+	} else if (type == CFG_BIN_CMD) {
 		ret = wilc_wlan_cfg_set_bin(frame, offset, id, buf, size);
 	}
 
@@ -422,7 +422,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	}
 
 	i = 0;
-	if (type == CFG_BYTE_CMD) {                                        /* byte command */
+	if (type == CFG_BYTE_CMD) {
 		do {
 			if (g_cfg_byte[i].id == WID_NIL)
 				break;
@@ -434,7 +434,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			}
 			i++;
 		} while (1);
-	} else if (type == CFG_HWORD_CMD) {                 /* half word command */
+	} else if (type == CFG_HWORD_CMD) {
 		do {
 			if (g_cfg_hword[i].id == WID_NIL)
 				break;
@@ -446,7 +446,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			}
 			i++;
 		} while (1);
-	} else if (type == CFG_WORD_CMD) {                 /* word command */
+	} else if (type == CFG_WORD_CMD) {
 		do {
 			if (g_cfg_word[i].id == WID_NIL)
 				break;
@@ -458,7 +458,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			}
 			i++;
 		} while (1);
-	} else if (type == CFG_STR_CMD) {                 /* string command */
+	} else if (type == CFG_STR_CMD) {
 		do {
 			if (g_cfg_str[i].id == WID_NIL)
 				break;
-- 
2.7.1

