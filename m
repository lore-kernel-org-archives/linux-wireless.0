Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34019 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:12:04 -0500
Received: by padhx2 with SMTP id hx2so110751702pad.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:12:03 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 08/12] staging: wilc1000: fix parameter name of host_int_add_station
Date: Fri,  6 Nov 2015 19:11:17 +0900
Message-Id: <1446804681-8873-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_111209_268468_502901B3)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes struct host_if_drv of host_int_add_station function
declaration from hWFIDrv to hif_drv.
With this change, first parameter of this function declaration and
definition has same name as hif_drv.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0949950..9788e6d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -378,7 +378,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 			u32 u32TailLen,
 			u8 *pu8tail);
 int host_int_del_beacon(struct host_if_drv *hif_drv);
-int host_int_add_station(struct host_if_drv *hWFIDrv,
+int host_int_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams);
 s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 			    u8 pu8MacAddr[][ETH_ALEN]);
-- 
2.6.3

