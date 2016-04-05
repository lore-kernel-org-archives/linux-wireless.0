Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35560 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbcDEGit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 02:38:49 -0400
Received: by mail-pf0-f193.google.com with SMTP id r187so497969pfr.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 23:38:48 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/14] staging: wilc1000: remove unused hif_drv in wilc_set_power_mgmt
Date: Tue,  5 Apr 2016 15:38:22 +0900
Message-Id: <1459838312-16506-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160405_083851_713312_0E66F822)
In-Reply-To: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459838312-16506-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused hif_drv in wilc_set_power_mgmt.
There is no need to check null and print debug log.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a47666c..bfb738a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3922,12 +3922,6 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	int result = 0;
 	struct host_if_msg msg;
 	struct power_mgmt_param *pwr_mgmt_info = &msg.body.pwr_mgmt_info;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
-		return -EFAULT;
-	}
 
 	if (wilc_wlan_get_num_conn_ifcs(vif->wilc) == 2 && enabled)
 		return 0;
-- 
2.8.0

