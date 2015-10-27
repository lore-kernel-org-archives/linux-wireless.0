Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34400 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbJ0Lkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 07:40:46 -0400
Received: by padhk11 with SMTP id hk11so220884290pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 04:40:45 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/8] staging: wilc1000: fix return type of host_int_add_wep_key_bss_sta
Date: Tue, 27 Oct 2015 20:40:32 +0900
Message-Id: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151027_124049_299047_D4782688)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_wep_key_bss_sta from s32
to int. The result variable gets return value from wilc_mq_send that has
return type of int. It should be changed return type of this function
as well as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 930dcba..702b7c8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3157,12 +3157,12 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
+int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 const u8 *pu8WepKey,
 				 u8 u8WepKeylen,
 				 u8 u8Keyidx)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f3fb628..fd8257b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -405,7 +405,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
+int host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
-- 
2.6.1

