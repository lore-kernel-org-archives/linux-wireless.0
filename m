Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36378 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbcBAM13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:29 -0500
Received: by mail-pf0-f193.google.com with SMTP id n128so7472838pfn.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:28 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/11] staging: wilc1000: linux_mon: fix error code of kmalloc
Date: Mon,  1 Feb 2016 21:26:46 +0900
Message-Id: <1454329607-9486-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132735_278941_3FF66DB5)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes error codes as -ENOMEM instead of using -EFAULT if
kmalloc is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index a19755e..1443a23 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -166,14 +166,14 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_ATOMIC);
 	if (!mgmt_tx) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
-		return -EFAULT;
+		return -ENOMEM;
 	}
 
 	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
 	if (!mgmt_tx->buff) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 		kfree(mgmt_tx);
-		return -EFAULT;
+		return -ENOMEM;
 	}
 
 	mgmt_tx->size = len;
-- 
2.7.0

