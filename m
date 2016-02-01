Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33112 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:25 -0500
Received: by mail-pf0-f193.google.com with SMTP id x125so7540787pfb.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:25 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/11] staging: wilc1000: linux_mon: fix coding style of kmalloc usage
Date: Mon,  1 Feb 2016 21:26:45 +0900
Message-Id: <1454329607-9486-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132731_133098_FFAF23A8)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes coding style of kmalloc usage found by checkpatch.pl
CHECK: Prefer kmalloc(sizeof(*mgmt_tx)...) over kmalloc(sizeof(struct
tx_complete_mon_data)...)

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 255383c..a19755e 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -163,7 +163,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	}
 
 	netif_stop_queue(dev);
-	mgmt_tx = kmalloc(sizeof(struct tx_complete_mon_data), GFP_ATOMIC);
+	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_ATOMIC);
 	if (!mgmt_tx) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
 		return -EFAULT;
-- 
2.7.0

