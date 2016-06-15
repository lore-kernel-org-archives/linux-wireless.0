Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36623 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbcFOFbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 01:31:13 -0400
Received: by mail-pa0-f45.google.com with SMTP id b5so3922621pas.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2016 22:31:13 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v3 5/5] staging: wilc1000: Remove semaphore close_exit_sync
Date: Wed, 15 Jun 2016 11:00:38 +0530
Message-Id: <1465968638-22129-6-git-send-email-binoy.jayan@linaro.org> (sfid-20160615_073135_215257_3FB15DE3)
In-Reply-To: <1465968638-22129-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
 <1465968638-22129-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'close_exit_sync' does not serve any purpose other
than delaying the deregistration of the device which it is trying
to protect from shared access. 'up' is called only when a subdevice
is closed and not when it is opened. So, the semaphore count only
goes up when the device is used.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 39fe350..f87a30f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -31,8 +31,6 @@ static struct notifier_block g_dev_notifier = {
 	.notifier_call = dev_state_ev_handler
 };
 
-static struct semaphore close_exit_sync;
-
 static int wlan_deinit_locks(struct net_device *dev);
 static void wlan_deinitialize_threads(struct net_device *dev);
 
@@ -1088,7 +1086,6 @@ int wilc_mac_close(struct net_device *ndev)
 		WILC_WFI_deinit_mon_interface();
 	}
 
-	up(&close_exit_sync);
 	vif->mac_opened = 0;
 
 	return 0;
@@ -1232,8 +1229,6 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	}
 
 	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
-		wilc_lock_timeout(wilc, &close_exit_sync, 5 * 1000);
-
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i]->ndev)
 				if (vif[i]->mac_opened)
@@ -1258,8 +1253,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	struct net_device *ndev;
 	struct wilc *wl;
 
-	sema_init(&close_exit_sync, 0);
-
 	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
 	if (!wl)
 		return -ENOMEM;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

