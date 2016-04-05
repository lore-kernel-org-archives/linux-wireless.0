Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36514 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbcDEGiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 02:38:55 -0400
Received: by mail-pf0-f195.google.com with SMTP id q129so498824pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 23:38:55 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/14] staging: wilc1000: remove unused hif_drv in wilc_del_allstation
Date: Tue,  5 Apr 2016 15:38:24 +0900
Message-Id: <1459838312-16506-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160405_083857_870977_9E97D724)
In-Reply-To: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused hif_drv in wilc_del_allstation.
There is no need to check null and print debug log.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3222a5d..4433f99 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3848,16 +3848,10 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	int result = 0;
 	struct host_if_msg msg;
 	struct del_all_sta *del_all_sta_info = &msg.body.del_all_sta_info;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 zero_addr[ETH_ALEN] = {0};
 	int i;
 	u8 assoc_sta = 0;
 
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
-		return -EFAULT;
-	}
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
-- 
2.8.0

