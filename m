Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33577 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbbKHHus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:48 -0500
Received: by pabfh17 with SMTP id fh17so166206340pab.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:47 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 25/32] staging: wilc1000: remove host_int_get_pmkid_info
Date: Sun,  8 Nov 2015 16:49:18 +0900
Message-Id: <1446968965-8958-25-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_091410_571872_44D4324D)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes host_int_get_pmkid_info function definition and
declaration that is defined at host_interface.c and host_interface.h.
This function is defined but not used anywhere in this driver so just
remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 --------------
 drivers/staging/wilc1000/host_interface.h |  2 --
 2 files changed, 16 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 51b6ddb..6015582 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3373,20 +3373,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	return result;
 }
 
-s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
-			    u8 *pu8PmkidInfoArray,
-			    u32 u32PmkidInfoLen)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_PMKID_INFO;
-	wid.type = WID_STR;
-	wid.size = u32PmkidInfoLen;
-	wid.val = pu8PmkidInfoArray;
-
-	return 0;
-}
-
 s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 					 u8 *pu8PassPhrase,
 					 u8 u8Psklength)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 91fbfa6..dd5a14a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -324,8 +324,6 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 mode, u8 cipher_mode);
 s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv,
 			    struct host_if_pmkid_attr *pu8PmkidInfoArray);
-s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
-			    u32 u32PmkidInfoLen);
 s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 					 u8 *pu8PassPhrase,
 					 u8 u8Psklength);
-- 
2.6.3

