Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36055 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422634AbcFMKi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 06:38:28 -0400
Received: by mail-pf0-f177.google.com with SMTP id t190so45125350pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 03:38:27 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 5/7] staging: wilc1000: Replace semaphore close_exit_sync with completion
Date: Mon, 13 Jun 2016 16:07:37 +0530
Message-Id: <1465814259-3009-6-git-send-email-binoy.jayan@linaro.org> (sfid-20160613_123914_817287_B7DFD994)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'close_exit_sync' is used as completion, so convert
it to a struct completion type.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 39fe350..ac537c7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -31,7 +31,7 @@ static struct notifier_block g_dev_notifier = {
 	.notifier_call = dev_state_ev_handler
 };
 
-static struct semaphore close_exit_sync;
+static struct completion close_exit_sync;
 
 static int wlan_deinit_locks(struct net_device *dev);
 static void wlan_deinitialize_threads(struct net_device *dev);
@@ -1088,7 +1088,7 @@ int wilc_mac_close(struct net_device *ndev)
 		WILC_WFI_deinit_mon_interface();
 	}
 
-	up(&close_exit_sync);
+	complete(&close_exit_sync);
 	vif->mac_opened = 0;
 
 	return 0;
@@ -1232,7 +1232,8 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	}
 
 	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
-		wilc_lock_timeout(wilc, &close_exit_sync, 5 * 1000);
+		wait_for_completion_timeout(&close_exit_sync,
+						msecs_to_jiffies(5000));
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i]->ndev)
@@ -1258,7 +1259,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	struct net_device *ndev;
 	struct wilc *wl;
 
-	sema_init(&close_exit_sync, 0);
+	init_completion(&close_exit_sync);
 
 	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
 	if (!wl)
-- 
2.7.4

