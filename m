Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33155 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbJ0Lkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 07:40:52 -0400
Received: by pabla5 with SMTP id la5so27614071pab.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 04:40:52 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/8] staging: wilc1000: rename pu8WepKey in host_int_add_wep_key_bss_sta
Date: Tue, 27 Oct 2015 20:40:34 +0900
Message-Id: <1445946039-10390-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151027_124055_334765_0B64EC42)
In-Reply-To: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8WepKey to key that is second argument of
host_int_add_wep_key_bss_sta to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 702b7c8..1cb2095 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3158,7 +3158,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 }
 
 int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
-				 const u8 *pu8WepKey,
+				 const u8 *key,
 				 u8 u8WepKeylen,
 				 u8 u8Keyidx)
 {
@@ -3178,7 +3178,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
 	msg.body.key_info.attr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wep.key, pu8WepKey, u8WepKeylen);
+	memcpy(msg.body.key_info.attr.wep.key, key, u8WepKeylen);
 	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
 	msg.body.key_info.attr.wep.index = u8Keyidx;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3579aac..55a7274 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -405,7 +405,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
+int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv, const u8 *key, u8 u8WepKeylen, u8 u8Keyidx);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
-- 
2.6.1

