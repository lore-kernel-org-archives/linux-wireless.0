Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58273 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459Ab2DZUHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 16:07:50 -0400
Received: by wejx9 with SMTP id x9so996311wej.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 13:07:49 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] wl1251: fix crash on remove due to premature kfree
Date: Thu, 26 Apr 2012 23:07:43 +0300
Message-Id: <1335470864-25422-1-git-send-email-notasas@gmail.com> (sfid-20120426_220801_798756_E28F00B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently SDIO glue frees it's own structure before calling
wl1251_free_hw(), which in turn calls ieee80211_unregister_hw().
The later call may result in a need to communicate with the chip
to stop it (as it happens now if the interface is still up before
rmmod), which means calls are made back to the glue, resulting in
freed memory access.

Fix this by freeing glue data last.

Cc: stable@vger.kernel.org # v2.6.37+
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
index f786942..1b851f6 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -315,8 +315,8 @@ static void __devexit wl1251_sdio_remove(struct sdio_func *func)
 
 	if (wl->irq)
 		free_irq(wl->irq, wl);
-	kfree(wl_sdio);
 	wl1251_free_hw(wl);
+	kfree(wl_sdio);
 
 	sdio_claim_host(func);
 	sdio_release_irq(func);
-- 
1.7.0.4

