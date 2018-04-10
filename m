Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:39151 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753145AbeDJNab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 09:30:31 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: kvalo@codeaurora.org, davem@davemloft.net,
        arvind.yadav.cs@gmail.com, johannes.berg@intel.com,
        stephen@networkplumber.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/2] net: wireless: zydas: Replace GFP_ATOMIC with GFP_KERNEL in zd1201_fw_upload
Date: Tue, 10 Apr 2018 21:30:23 +0800
Message-Id: <1523367023-31981-1-git-send-email-baijiaju1990@gmail.com> (sfid-20180410_153100_154401_12B84B7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1201_probe() is never called in atomic context.

zd1201_fw_upload() is only called by zd1201_probe(), 
which is only set as ".probe" in struct usb_driver.

Despite never getting called from atomic context,
zd1201_fw_upload() calls kmalloc() with GFP_ATOMIC,
which does not sleep for allocation.
GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
which can sleep and improve the possibility of sucessful allocation.

This is found by a static analysis tool named DCNS written by myself.
And I also manually check it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/zydas/zd1201.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index 581e857..cba2bed 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -74,7 +74,7 @@ static int zd1201_fw_upload(struct usb_device *dev, int apfw)
 	data = fw_entry->data;
         len = fw_entry->size;
 
-	buf = kmalloc(1024, GFP_ATOMIC);
+	buf = kmalloc(1024, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto exit;
-- 
1.9.1
