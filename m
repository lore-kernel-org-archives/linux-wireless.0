Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36089 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbbJOCHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:16 -0400
Received: by pabws5 with SMTP id ws5so7325741pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:15 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/33] staging: wilc1000: fix return type of host_int_add_wep_key_bss_ap
Date: Thu, 15 Oct 2015 11:06:32 +0900
Message-Id: <1444874822-31152-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040722_207132_BE08102E)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_wep_key_bss_ap from s32
to int. s32Error gets return value from wilc_mq_send that has return
type of int. It should be changed return type by int as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index aed259e..88a461e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3261,7 +3261,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 }
 
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *pu8WepKey,
 				u8 u8WepKeylen,
 				u8 u8Keyidx,
@@ -3269,7 +3269,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				enum AUTHTYPE tenuAuth_type)
 {
 
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	u8 i;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e5ba1d0..e2b84ae 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -420,7 +420,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKe
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
-- 
2.6.1

