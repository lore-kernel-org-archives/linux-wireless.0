Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35302 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbcBPIkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 03:40:04 -0500
Received: by mail-pf0-f180.google.com with SMTP id c10so103493718pfc.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 00:40:04 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/7] staging: wilc1000: handle_set_mac_address: remove debug message of kmalloc failure
Date: Tue, 16 Feb 2016 17:39:49 +0900
Message-Id: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160216_094010_918665_D9DD8509)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to print debug message when kmalloc is failed. This
message is redundant. The code already show us that kmalloc is failed.
The brace of if statement is remove as well due to have a single
statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d1eedfb..579b90a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -431,10 +431,9 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	struct wid wid;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
-	if (!mac_buf) {
-		PRINT_ER("No buffer to send mac address\n");
+	if (!mac_buf)
 		return -EFAULT;
-	}
+
 	memcpy(mac_buf, set_mac_addr->mac_addr, ETH_ALEN);
 
 	wid.id = (u16)WID_MAC_ADDR;
-- 
2.7.1

