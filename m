Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36197 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbcEBKsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 06:48:08 -0400
Received: by mail-pa0-f66.google.com with SMTP id i5so17651426pag.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 03:48:08 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/7] staging: wilc1000: change handle_get_ip_address's return type to void
Date: Mon,  2 May 2016 19:47:49 +0900
Message-Id: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160502_124812_655623_2BB2F623)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handle_get_ip_address is called in hostIFthread that is a kernel
thread, it is not checked return type of this function. This patch
changes return type to void and removes braces if statement due to have
a single statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 605cf8f..ce1cd68 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -374,7 +374,7 @@ static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 		netdev_err(vif->ndev, "Failed to set IP address\n");
 }
 
-static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
+static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -394,12 +394,8 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
 		wilc_setup_ipaddress(vif, set_ip[idx], idx);
 
-	if (result != 0) {
+	if (result != 0)
 		netdev_err(vif->ndev, "Failed to get IP address\n");
-		return -EINVAL;
-	}
-
-	return result;
 }
 
 static s32 handle_get_mac_address(struct wilc_vif *vif,
-- 
2.8.2

