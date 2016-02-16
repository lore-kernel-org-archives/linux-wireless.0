Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36154 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbcBPIkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 03:40:23 -0500
Received: by mail-pf0-f177.google.com with SMTP id e127so101536226pfe.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 00:40:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/7] staging: wilc1000: handle_set_mac_address: use netdev_err
Date: Tue, 16 Feb 2016 17:39:55 +0900
Message-Id: <1455611995-28773-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160216_094029_483146_9507A77E)
In-Reply-To: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses netdev_err instead of PRINT_ER that is a custom debug
print.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bfca0b4..d5859c5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -442,7 +442,7 @@ static void handle_set_mac_address(struct wilc_vif *vif,
 	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
 	if (ret)
-		PRINT_ER("Failed to set mac address\n");
+		netdev_err(vif->ndev, "Failed to set mac address\n");
 
 	kfree(mac_buf);
 }
-- 
2.7.1

