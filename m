Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35697 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbJ0Lk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 07:40:58 -0400
Received: by pasz6 with SMTP id z6so220475338pas.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 04:40:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/8] staging: wilc1000: rename u8Keyidx in host_int_add_wep_key_bss_sta
Date: Tue, 27 Oct 2015 20:40:36 +0900
Message-Id: <1445946039-10390-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151027_124101_551186_1CC0992D)
In-Reply-To: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8Keyidx to index that is fourth argument of
host_int_add_wep_key_bss_sta to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b45bec4..f7dc61b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3160,7 +3160,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 const u8 *key,
 				 u8 len,
-				 u8 u8Keyidx)
+				 u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3180,7 +3180,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.attr.wep.key = kmalloc(len, GFP_KERNEL);
 	memcpy(msg.body.key_info.attr.wep.key, key, len);
 	msg.body.key_info.attr.wep.key_len = len;
-	msg.body.key_info.attr.wep.index = u8Keyidx;
+	msg.body.key_info.attr.wep.index = index;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0d8835d..1e134d4 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -405,7 +405,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 u8Keyidx);
+int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 index);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
-- 
2.6.1

