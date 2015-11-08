Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34982 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313AbbKHHvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:51:06 -0500
Received: by pasz6 with SMTP id z6so170560078pas.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:51:05 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 31/32] staging: wilc1000: remove host_int_get_assoc_req_info
Date: Sun,  8 Nov 2015 16:49:24 +0900
Message-Id: <1446968965-8958-31-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085109_660034_6B9C0536)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes host_int_get_assoc_req_info function definition and
declaration that is defined at host_interface.c and host_interface.h.
This function is defined but not used anywhere in this driver so just
remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 --------------
 drivers/staging/wilc1000/host_interface.h |  3 ---
 2 files changed, 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 676b3c7..ff15179 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3529,20 +3529,6 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	return result;
 }
 
-s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv,
-				u8 *pu8AssocReqInfo,
-				u32 u32AssocReqInfoLen)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_ASSOC_REQ_INFO;
-	wid.type = WID_STR;
-	wid.val = pu8AssocReqInfo;
-	wid.size = u32AssocReqInfoLen;
-
-	return 0;
-}
-
 s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 				u8 *pu8AssocRespInfo,
 				u32 u32MaxAssocRespInfoLen,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e51a563..8870458 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -335,9 +335,6 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 			  u8 u8channel, void *pJoinParams);
 s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
-s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv,
-				u8 *pu8AssocReqInfo,
-				u32 u32AssocReqInfoLen);
 s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv,
 				u8 *pu8AssocRespInfo,
 				u32 u32MaxAssocRespInfoLen,
-- 
2.6.3

