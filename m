Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33117 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbcCCMG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 07:06:26 -0500
Received: by mail-pf0-f194.google.com with SMTP id 63so1210463pfe.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 04:06:26 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/6] staging: wilc1000: add enum cfg_type_cmd
Date: Thu,  3 Mar 2016 21:05:20 +0900
Message-Id: <1457006722-14400-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_130629_806117_99EB2803)
In-Reply-To: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
References: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a new enum cfg_type_cmd to change hard-coded command
type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 6a33187..9cf68b7 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -18,6 +18,13 @@
  *      Global Data
  *
  ********************************************/
+enum cfg_cmd_type {
+	CFG_BYTE_CMD	= 0,
+	CFG_HWORD_CMD	= 1,
+	CFG_WORD_CMD	= 2,
+	CFG_STR_CMD	= 3,
+	CFG_BIN_CMD	= 4
+};
 
 struct wilc_mac_cfg {
 	int mac_status;
@@ -371,18 +378,18 @@ int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 	u8 type = (id >> 12) & 0xf;
 	int ret = 0;
 
-	if (type == 0) {                                        /* byte command */
+	if (type == CFG_BYTE_CMD) {                                        /* byte command */
 		if (size >= 1)
 			ret = wilc_wlan_cfg_set_byte(frame, offset, id, *buf);
-	} else if (type == 1) {                 /* half word command */
+	} else if (type == CFG_HWORD_CMD) {                 /* half word command */
 		if (size >= 2)
 			ret = wilc_wlan_cfg_set_hword(frame, offset, id, *((u16 *)buf));
-	} else if (type == 2) {                 /* word command */
+	} else if (type == CFG_WORD_CMD) {                 /* word command */
 		if (size >= 4)
 			ret = wilc_wlan_cfg_set_word(frame, offset, id, *((u32 *)buf));
-	} else if (type == 3) {                 /* string command */
+	} else if (type == CFG_STR_CMD) {                 /* string command */
 		ret = wilc_wlan_cfg_set_str(frame, offset, id, buf, size);
-	} else if (type == 4) {                 /* binary command */
+	} else if (type == CFG_BIN_CMD) {                 /* binary command */
 		ret = wilc_wlan_cfg_set_bin(frame, offset, id, buf, size);
 	}
 
@@ -415,7 +422,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	}
 
 	i = 0;
-	if (type == 0) {                                        /* byte command */
+	if (type == CFG_BYTE_CMD) {                                        /* byte command */
 		do {
 			if (g_cfg_byte[i].id == WID_NIL)
 				break;
@@ -427,7 +434,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			}
 			i++;
 		} while (1);
-	} else if (type == 1) {                 /* half word command */
+	} else if (type == CFG_HWORD_CMD) {                 /* half word command */
 		do {
 			if (g_cfg_hword[i].id == WID_NIL)
 				break;
@@ -439,7 +446,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			}
 			i++;
 		} while (1);
-	} else if (type == 2) {                 /* word command */
+	} else if (type == CFG_WORD_CMD) {                 /* word command */
 		do {
 			if (g_cfg_word[i].id == WID_NIL)
 				break;
@@ -451,7 +458,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			}
 			i++;
 		} while (1);
-	} else if (type == 3) {                 /* string command */
+	} else if (type == CFG_STR_CMD) {                 /* string command */
 		do {
 			if (g_cfg_str[i].id == WID_NIL)
 				break;
-- 
2.7.1

