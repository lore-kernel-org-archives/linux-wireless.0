Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34554 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbcEBKsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 06:48:17 -0400
Received: by mail-pa0-f66.google.com with SMTP id yl2so17627142pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 03:48:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/7] staging: wilc1000: fix comparison style of if statement in handle_get_ip_address
Date: Mon,  2 May 2016 19:47:52 +0900
Message-Id: <1462186075-8549-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160502_124820_421498_58F5E98B)
In-Reply-To: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
References: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes conditional comparison of if statement as if (ret)
instead of using if (ret != 0)

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1d48214..8a269fd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -394,7 +394,7 @@ static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
 		wilc_setup_ipaddress(vif, set_ip[idx], idx);
 
-	if (ret != 0)
+	if (ret)
 		netdev_err(vif->ndev, "Failed to get IP address\n");
 }
 
-- 
2.8.2

