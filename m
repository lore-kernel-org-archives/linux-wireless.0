Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33142 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbcCCMGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 07:06:32 -0500
Received: by mail-pf0-f193.google.com with SMTP id 63so1210584pfe.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 04:06:32 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/6] staging: wilc1000: use switch statement instead of multiple if statement
Date: Thu,  3 Mar 2016 21:05:22 +0900
Message-Id: <1457006722-14400-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_130635_180962_2C66C763)
In-Reply-To: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
References: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is more readable than multiple if-else statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 92f6d32..b3425b9 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -378,19 +378,31 @@ int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 	u8 type = (id >> 12) & 0xf;
 	int ret = 0;
 
-	if (type == CFG_BYTE_CMD) {
+	switch (type) {
+	case CFG_BYTE_CMD:
 		if (size >= 1)
 			ret = wilc_wlan_cfg_set_byte(frame, offset, id, *buf);
-	} else if (type == CFG_HWORD_CMD) {
+		break;
+
+	case CFG_HWORD_CMD:
 		if (size >= 2)
-			ret = wilc_wlan_cfg_set_hword(frame, offset, id, *((u16 *)buf));
-	} else if (type == CFG_WORD_CMD) {
+			ret = wilc_wlan_cfg_set_hword(frame, offset, id,
+						      *((u16 *)buf));
+		break;
+
+	case CFG_WORD_CMD:
 		if (size >= 4)
-			ret = wilc_wlan_cfg_set_word(frame, offset, id, *((u32 *)buf));
-	} else if (type == CFG_STR_CMD) {
+			ret = wilc_wlan_cfg_set_word(frame, offset, id,
+						     *((u32 *)buf));
+		break;
+
+	case CFG_STR_CMD:
 		ret = wilc_wlan_cfg_set_str(frame, offset, id, buf, size);
-	} else if (type == CFG_BIN_CMD) {
+		break;
+
+	case CFG_BIN_CMD:
 		ret = wilc_wlan_cfg_set_bin(frame, offset, id, buf, size);
+		break;
 	}
 
 	return ret;
-- 
2.7.1

