Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38833 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbeDJNaR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 09:30:17 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: kvalo@codeaurora.org, davem@davemloft.net,
        stephen@networkplumber.org, arvind.yadav.cs@gmail.com,
        johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 1/2] net: wireless: zydas: Replace mdelay with msleep in zd1201_probe
Date: Tue, 10 Apr 2018 21:30:04 +0800
Message-Id: <1523367004-31935-1-git-send-email-baijiaju1990@gmail.com> (sfid-20180410_153059_544524_F14BE5F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1201_probe() is never called in atomic context.

zd1201_probe() is only set as ".probe" in struct usb_driver.

Despite never getting called from atomic context, zd1201_probe()
calls mdelay() to busily wait.
This is not necessary and can be replaced with msleep() to
avoid busy waiting.

This is found by a static analysis tool named DCNS written by myself.
And I also manually check it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/zydas/zd1201.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index 581e857..12774e9 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -1767,7 +1767,7 @@ static int zd1201_probe(struct usb_interface *interface,
 		goto err_zd;
 	}
 
-	mdelay(100);
+	msleep(100);
 	err = zd1201_drvr_start(zd);
 	if (err)
 		goto err_zd;
-- 
1.9.1
