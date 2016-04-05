Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36643 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbcDEGjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 02:39:20 -0400
Received: by mail-pf0-f194.google.com with SMTP id q129so499785pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 23:39:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/14] staging: wilc1000: remove unused hif_drv in wilc_add_beacon
Date: Tue,  5 Apr 2016 15:38:32 +0900
Message-Id: <1459838312-16506-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20160405_085528_406877_D31C3DD2)
In-Reply-To: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused hif_drv in wilc_add_beacon.
There is no need to check null and print debug log.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2dba954..eb86fd4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3693,12 +3693,6 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 	int result = 0;
 	struct host_if_msg msg;
 	struct beacon_attr *beacon_info = &msg.body.beacon_info;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
-		return -EFAULT;
-	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-- 
2.8.0

