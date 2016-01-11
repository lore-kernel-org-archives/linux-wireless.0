Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:54543 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005AbcAKDiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2016 22:38:10 -0500
From: Jia-Ju Bai <baijiaju1990@163.com>
To: kvalo@codeaurora.org, zajec5@gmail.com, joe@perches.com,
	davem@davemloft.net, m@bues.ch, johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] b43: Fix a memory leak in b43_bus_dev_ssb_init
Date: Mon, 11 Jan 2016 11:37:36 +0800
Message-Id: <1452483457-568-1-git-send-email-baijiaju1990@163.com> (sfid-20160111_043814_677206_E7D2B3E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The memory allocated by kzalloc in b43_bus_dev_ssb_init is not freed.
This patch fixes the bug by adding kfree in b43_ssb_remove.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/net/wireless/b43/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index ec013fb..6d251a0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5798,6 +5798,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 
 	b43_leds_unregister(wl);
 	b43_wireless_exit(dev, wl);
+	kfree(dev);
 }
 
 static struct ssb_driver b43_ssb_driver = {
-- 
1.7.9.5


