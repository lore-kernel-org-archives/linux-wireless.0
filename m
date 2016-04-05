Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33641 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbcDEGjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 02:39:07 -0400
Received: by mail-pa0-f66.google.com with SMTP id q6so481235pav.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 23:39:07 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/14] staging: wilc1000: remove unused hif_drv in wilc_set_mac_chnl_num
Date: Tue,  5 Apr 2016 15:38:28 +0900
Message-Id: <1459838312-16506-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20160405_083912_200643_BB7C176E)
In-Reply-To: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused hif_drv in wilc_set_mac_chnl_num.
There is no need to check null and print debug log.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8591c00..7b28ae5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3134,12 +3134,6 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 {
 	int result;
 	struct host_if_msg msg;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
-		return -EFAULT;
-	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
-- 
2.8.0

