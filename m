Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35652 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbJ0Lkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 07:40:55 -0400
Received: by pasz6 with SMTP id z6so220474102pas.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 04:40:55 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/8] staging: wilc1000: rename u8WepKeylen in host_int_add_wep_key_bss_sta
Date: Tue, 27 Oct 2015 20:40:35 +0900
Message-Id: <1445946039-10390-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151027_124058_788871_DC36E0C8)
In-Reply-To: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8WepKeylen to len that is third argument of
host_int_add_wep_key_bss_sta to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1cb2095..b45bec4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3159,7 +3159,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 
 int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 const u8 *key,
-				 u8 u8WepKeylen,
+				 u8 len,
 				 u8 u8Keyidx)
 {
 	int result = 0;
@@ -3177,9 +3177,9 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
-	msg.body.key_info.attr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wep.key, key, u8WepKeylen);
-	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
+	msg.body.key_info.attr.wep.key = kmalloc(len, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wep.key, key, len);
+	msg.body.key_info.attr.wep.key_len = len;
 	msg.body.key_info.attr.wep.index = u8Keyidx;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 55a7274..0d8835d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -405,7 +405,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv, const u8 *key, u8 u8WepKeylen, u8 u8Keyidx);
+int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 u8Keyidx);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
-- 
2.6.1

