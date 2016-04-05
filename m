Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34018 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbcDEGi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 02:38:58 -0400
Received: by mail-pa0-f68.google.com with SMTP id hb4so477816pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 23:38:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/14] staging: wilc1000: remove unused hif_drv in wilc_del_station
Date: Tue,  5 Apr 2016 15:38:25 +0900
Message-Id: <1459838312-16506-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160405_083901_117820_B666B3B2)
In-Reply-To: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused hif_drv in wilc_del_station.
There is no need to check null and print debug log.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4433f99..0c4a74e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3820,12 +3820,6 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	int result = 0;
 	struct host_if_msg msg;
 	struct del_sta *del_sta_info = &msg.body.del_sta_info;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
-		return -EFAULT;
-	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-- 
2.8.0

