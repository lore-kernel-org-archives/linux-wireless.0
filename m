Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34560 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbcBAM1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:32 -0500
Received: by mail-pa0-f68.google.com with SMTP id yy13so7151388pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:31 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/11] staging: wilc1000: linux_mon: remove debug message of kmalloc failure
Date: Mon,  1 Feb 2016 21:26:47 +0900
Message-Id: <1454329607-9486-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132736_416187_B7E69217)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to print debug message when kmalloc is failed.
This message is redundant. The code already show us that kmalloc is
failed. The braces of first if statement is remove as well because if
statement has a single statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 1443a23..e9bb0ec 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -164,14 +164,11 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 
 	netif_stop_queue(dev);
 	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_ATOMIC);
-	if (!mgmt_tx) {
-		PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
+	if (!mgmt_tx)
 		return -ENOMEM;
-	}
 
 	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
 	if (!mgmt_tx->buff) {
-		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 		kfree(mgmt_tx);
 		return -ENOMEM;
 	}
-- 
2.7.0

