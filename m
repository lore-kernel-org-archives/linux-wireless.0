Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34279 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbbKHHuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:54 -0500
Received: by padhx2 with SMTP id hx2so157841028pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:53 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 27/32] staging: wilc1000: remove host_int_get_RSNAConfigPSKPassPhrase
Date: Sun,  8 Nov 2015 16:49:20 +0900
Message-Id: <1446968965-8958-27-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_091409_651166_B35D2E7F)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes host_int_get_RSNAConfigPSKPassPhrase function
definition and declaration that is defined at host_interface.c and
host_interface.h. This function is defined but not used anywhere in this
driver so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 -------------
 drivers/staging/wilc1000/host_interface.h |  2 --
 2 files changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fb6f353..f7bbad0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3413,19 +3413,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return result;
 }
 
-s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
-					 u8 *pu8PassPhrase, u8 u8Psklength)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_11I_PSK;
-	wid.type = WID_STR;
-	wid.size = u8Psklength;
-	wid.val = pu8PassPhrase;
-
-	return 0;
-}
-
 s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 {
 	struct wid wid;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8113d76..976067a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -324,8 +324,6 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 mode, u8 cipher_mode);
 s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv,
 			    struct host_if_pmkid_attr *pu8PmkidInfoArray);
-s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
-					 u8 *pu8PassPhrase, u8 u8Psklength);
 s32 hif_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 int host_int_wait_msg_queue_idle(void);
-- 
2.6.3

