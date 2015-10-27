Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34706 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbJ0XTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 19:19:37 -0400
Received: by padhk11 with SMTP id hk11so236249200pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 16:19:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/10] staging: wilc1000: fix return type of host_int_add_wep_key_bss_ap
Date: Wed, 28 Oct 2015 08:19:19 +0900
Message-Id: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151028_001941_162523_C78B6289)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_wep_key_bss_ap from s32
to int. The result variable gets return value from wilc_mq_send that has
return type of int. It should be changed return type of this function as
well as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5a23738..e0a4cf3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3191,14 +3191,14 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *pu8WepKey,
 				u8 u8WepKeylen,
 				u8 u8Keyidx,
 				u8 u8mode,
 				enum AUTHTYPE tenuAuth_type)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	u8 i;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a9f7d1d..cd6199b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -421,7 +421,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
-- 
2.6.1

