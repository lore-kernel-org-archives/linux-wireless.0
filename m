Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33487 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbcGUH5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 03:57:05 -0400
Received: by mail-pf0-f179.google.com with SMTP id y134so27918850pfg.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 00:57:05 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH] staging: wilc1000: txq_event: Fix coding error
Date: Thu, 21 Jul 2016 13:26:56 +0530
Message-Id: <1469087816-16773-1-git-send-email-binoy.jayan@linaro.org> (sfid-20160721_095724_605106_C139E234)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix incorrect usage of completion interface by replacing
'wait_for_completion' with 'complete'. This error was introduced
accidentally while replacing semaphores with mutexes.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3a66255..3221511 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -648,7 +648,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 			mutex_unlock(&wl->hif_cs);
 		}
 		if (&wl->txq_event)
-			wait_for_completion(&wl->txq_event);
+			complete(&wl->txq_event);
 
 		wlan_deinitialize_threads(dev);
 		deinit_irq(dev);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

