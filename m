Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33817 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbbJ0XTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 19:19:47 -0400
Received: by padhk11 with SMTP id hk11so236252982pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 16:19:46 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/10] staging: wilc1000: rename pu8WepKey in host_int_add_wep_key_bss_ap
Date: Wed, 28 Oct 2015 08:19:22 +0900
Message-Id: <1445987968-18974-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151028_001950_030598_B8DCFA6F)
In-Reply-To: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8WepKey to key that is second argument of this
function to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9a57d31a..4be42cb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3192,7 +3192,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 }
 
 int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
-				const u8 *pu8WepKey,
+				const u8 *key,
 				u8 u8WepKeylen,
 				u8 u8Keyidx,
 				u8 u8mode,
@@ -3211,14 +3211,14 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 	if (INFO) {
 		for (i = 0; i < u8WepKeylen; i++)
-			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", pu8WepKey[i]);
+			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", key[i]);
 	}
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY_AP;
 	msg.drv = hif_drv;
 	msg.body.key_info.attr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wep.key, pu8WepKey, (u8WepKeylen));
+	memcpy(msg.body.key_info.attr.wep.key, key, (u8WepKeylen));
 	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
 	msg.body.key_info.attr.wep.index = u8Keyidx;
 	msg.body.key_info.attr.wep.mode = u8mode;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0bbbf4f..fa439f2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -421,7 +421,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv, const u8 *key, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
-- 
2.6.1

