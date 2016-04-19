Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36387 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbcDSAfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 20:35:40 -0400
Received: by mail-pf0-f195.google.com with SMTP id p185so95510pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 17:35:40 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/3] staging: wilc1000: change handle_set_ip_address's return type to void
Date: Tue, 19 Apr 2016 09:35:29 +0900
Message-Id: <1461026131-5841-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160419_023545_254687_1DA87DFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handle_set_ip_address is called in hostIFthread that is a kernel
thread, it is not checked return type of this function. This patch
changes return type to void and removes braces if statement due to have
a single statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ac620fb..87c8789 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -349,7 +349,7 @@ static void handle_set_operation_mode(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
 }
 
-static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
+static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -370,12 +370,8 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
 
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to set IP address\n");
-		return -EINVAL;
-	}
-
-	return result;
 }
 
 static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
-- 
2.8.0

