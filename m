Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41579 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab1EMI5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:57:13 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so2644123wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 01:57:13 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/6] wl12xx_sdio: set interrupt as wake_up interrupt
Date: Fri, 13 May 2011 11:57:08 +0300
Message-Id: <1305277033-6662-2-git-send-email-eliad@wizery.com> (sfid-20110513_105718_123753_9666BFA8)
In-Reply-To: <1305277033-6662-1-git-send-email-eliad@wizery.com>
References: <1305277033-6662-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set the sdio interrupt as wake_up interrupt, so we will be able
to wake up the suspended system (Wake-On-Wireless)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index bcd4ad7..1298461 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -267,6 +267,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 		goto out_free;
 	}
 
+	enable_irq_wake(wl->irq);
+
 	disable_irq(wl->irq);
 
 	ret = wl1271_init_ieee80211(wl);
@@ -303,6 +305,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	pm_runtime_get_noresume(&func->dev);
 
 	wl1271_unregister_hw(wl);
+	disable_irq_wake(wl->irq);
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
 }
-- 
1.7.0.4

