Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36796 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbKHHuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:12 -0500
Received: by pacdm15 with SMTP id dm15so141907885pac.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:11 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/32] staging: wilc1000: fix argument name of host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:06 +0900
Message-Id: <1446968965-8958-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085017_120537_07376E93)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes struct host_if_drv of host_int_add_rx_gtk function
declaration from hWFIDrv to hif_drv.
With this change, first argument of this function declaration and
definition has same name as hif_drv.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2f10598..5f1b20c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -317,7 +317,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 mode, u8 cipher_mode, u8 index);
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
-int host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk,
+int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
-- 
2.6.3

