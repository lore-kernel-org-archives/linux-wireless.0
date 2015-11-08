Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33707 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302AbbKHHvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:51:02 -0500
Received: by pabfh17 with SMTP id fh17so166209846pab.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:51:02 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 30/32] staging: wilc1000: remove host_int_disconnect_station
Date: Sun,  8 Nov 2015 16:49:23 +0900
Message-Id: <1446968965-8958-30-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085106_569423_6AB07737)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes host_int_disconnect_station function definition and
declaration that is defined at host_interface.c and host_interface.h.
This function is defined but not used anywhere so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ------------
 drivers/staging/wilc1000/host_interface.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0575345..676b3c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3529,18 +3529,6 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	return result;
 }
 
-s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_DISCONNECT;
-	wid.type = WID_CHAR;
-	wid.val = (s8 *)&assoc_id;
-	wid.size = sizeof(char);
-
-	return 0;
-}
-
 s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv,
 				u8 *pu8AssocReqInfo,
 				u32 u32AssocReqInfoLen)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 52622df..e51a563 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -335,7 +335,6 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 			  u8 u8channel, void *pJoinParams);
 s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
-s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id);
 s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv,
 				u8 *pu8AssocReqInfo,
 				u32 u32AssocReqInfoLen);
-- 
2.6.3

