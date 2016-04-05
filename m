Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35660 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbcDEGjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 02:39:10 -0400
Received: by mail-pf0-f195.google.com with SMTP id r187so498716pfr.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 23:39:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/14] staging: wilc1000: remove unused hif_drv in host_int_get_assoc_res_info
Date: Tue,  5 Apr 2016 15:38:29 +0900
Message-Id: <1459838312-16506-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20160405_085528_664232_3D3ADF03)
In-Reply-To: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused hif_drv in host_int_get_assoc_res_info.
There is no need to check null and print debug log.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7b28ae5..d23c8ba 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3106,12 +3106,6 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "Driver is null\n");
-		return -EFAULT;
-	}
 
 	wid.id = (u16)WID_ASSOC_RES_INFO;
 	wid.type = WID_STR;
-- 
2.8.0

