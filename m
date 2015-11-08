Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34305 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbbKHHu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:57 -0500
Received: by padhx2 with SMTP id hx2so157841689pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:56 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 28/32] staging: wilc1000: remove host_int_set_start_scan_req
Date: Sun,  8 Nov 2015 16:49:21 +0900
Message-Id: <1446968965-8958-28-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_091408_891285_C93A0274)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes host_int_set_start_scan_req function definition and
declaration that is defined at host_interface.c and host_interface.h.
This function is defined but not used anywhere in this driver so that
just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ------------
 drivers/staging/wilc1000/host_interface.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f7bbad0..174cb6a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3413,18 +3413,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return result;
 }
 
-s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_START_SCAN_REQ;
-	wid.type = WID_CHAR;
-	wid.val = (s8 *)&scanSource;
-	wid.size = sizeof(char);
-
-	return 0;
-}
-
 s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
 {
 	struct wid wid;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 976067a..14ce397 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -327,7 +327,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv,
 s32 hif_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 int host_int_wait_msg_queue_idle(void);
-s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
 s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource);
 s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
-- 
2.6.3

