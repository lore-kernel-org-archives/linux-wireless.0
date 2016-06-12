Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36395 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbcFLX2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2016 19:28:41 -0400
Received: by mail-pf0-f193.google.com with SMTP id 62so9239239pfd.3
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2016 16:28:40 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/6] staging: wilc1000: remove unnecesary type cast of bss_type
Date: Mon, 13 Jun 2016 08:28:15 +0900
Message-Id: <20160612232815.12112-6-chaehyun.lim@gmail.com> (sfid-20160613_012843_889505_9CED2C44)
In-Reply-To: <20160612232815.12112-1-chaehyun.lim@gmail.com>
References: <20160612232815.12112-1-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to use type cast of bss_type because
hif_drv->cfg_values.bss_type is u8.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 828efff..5b2278b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -434,7 +434,7 @@ static void handle_cfg_param(struct wilc_vif *vif,
 			wid_list[i].val = (s8 *)&bss_type;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.bss_type = (u8)bss_type;
+			hif_drv->cfg_values.bss_type = bss_type;
 		} else {
 			netdev_err(vif->ndev, "check value 6 over\n");
 			goto unlock;
-- 
2.8.4

