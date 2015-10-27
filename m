Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36121 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbbJ0XTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 19:19:50 -0400
Received: by pacfv9 with SMTP id fv9so246527867pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 16:19:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/10] staging: wilc1000: rename u8WepKeylen in host_int_add_wep_key_bss_ap
Date: Wed, 28 Oct 2015 08:19:23 +0900
Message-Id: <1445987968-18974-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151028_001953_236425_152C35D8)
In-Reply-To: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8WepKeylen to len that is third argument of this
function to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4be42cb..c3cf7a1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3193,7 +3193,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *key,
-				u8 u8WepKeylen,
+				u8 len,
 				u8 u8Keyidx,
 				u8 u8mode,
 				enum AUTHTYPE tenuAuth_type)
@@ -3210,16 +3210,16 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (INFO) {
-		for (i = 0; i < u8WepKeylen; i++)
+		for (i = 0; i < len; i++)
 			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", key[i]);
 	}
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY_AP;
 	msg.drv = hif_drv;
-	msg.body.key_info.attr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wep.key, key, (u8WepKeylen));
-	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
+	msg.body.key_info.attr.wep.key = kmalloc(len, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wep.key, key, len);
+	msg.body.key_info.attr.wep.key_len = len;
 	msg.body.key_info.attr.wep.index = u8Keyidx;
 	msg.body.key_info.attr.wep.mode = u8mode;
 	msg.body.key_info.attr.wep.auth_type = tenuAuth_type;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fa439f2..289dfd3 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -421,7 +421,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv, const u8 *key, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
-- 
2.6.1

