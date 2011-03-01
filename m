Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45319 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab1CAUgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:36:54 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so4952627wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:36:53 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 5/9] wl12xx_sdio: set interrupt as wake_up interrupt
Date: Tue,  1 Mar 2011 22:36:40 +0200
Message-Id: <1299011804-13899-6-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set the sdio interrupt as wake_up interrupt, so we will be able
to wake up the suspended system (Wake-On-Wireless)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index c3792cb..eec98a0 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -265,6 +265,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	}
 
 	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+	set_irq_wake(wl->irq, 1);
 
 	disable_irq(wl->irq);
 
@@ -303,6 +304,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	pm_runtime_get_noresume(&func->dev);
 
 	wl1271_unregister_hw(wl);
+	set_irq_wake(wl->irq, 0);
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
 }
-- 
1.7.0.4

