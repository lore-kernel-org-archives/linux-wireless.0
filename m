Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33933 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbJ0XT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 19:19:56 -0400
Received: by padhk11 with SMTP id hk11so236256306pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 16:19:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/10] staging: wilc1000: rename u8mode in host_int_add_wep_key_bss_ap
Date: Wed, 28 Oct 2015 08:19:25 +0900
Message-Id: <1445987968-18974-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151028_001958_931558_3123BE75)
In-Reply-To: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8mode to mode that is fifth argument of this
function to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c92e12a..fbafed9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3195,7 +3195,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *key,
 				u8 len,
 				u8 index,
-				u8 u8mode,
+				u8 mode,
 				enum AUTHTYPE tenuAuth_type)
 {
 	int result = 0;
@@ -3221,7 +3221,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	memcpy(msg.body.key_info.attr.wep.key, key, len);
 	msg.body.key_info.attr.wep.key_len = len;
 	msg.body.key_info.attr.wep.index = index;
-	msg.body.key_info.attr.wep.mode = u8mode;
+	msg.body.key_info.attr.wep.mode = mode;
 	msg.body.key_info.attr.wep.auth_type = tenuAuth_type;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ab88ed5..1927d4c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -421,7 +421,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 index, u8 u8mode, enum AUTHTYPE tenuAuth_type);
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 index, u8 mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
-- 
2.6.1

