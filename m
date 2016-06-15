Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33768 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbcFOFbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 01:31:09 -0400
Received: by mail-pf0-f182.google.com with SMTP id i123so1316099pfg.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2016 22:31:08 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v3 4/5] staging: wilc1000: Replace semaphore sync_event with completion
Date: Wed, 15 Jun 2016 11:00:37 +0530
Message-Id: <1465968638-22129-5-git-send-email-binoy.jayan@linaro.org> (sfid-20160615_073142_854639_75A6FBE9)
In-Reply-To: <1465968638-22129-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
 <1465968638-22129-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'sync_event' is used as completion, so convert
it to a struct completion type. Also, return -ETIME if the return
value of wait_for_completion_timeout is 0.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 81a469a..39fe350 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -241,7 +241,7 @@ void wilc_mac_indicate(struct wilc *wilc, int flag)
 				      (unsigned char *)&status, 4);
 		if (wilc->mac_status == WILC_MAC_STATUS_INIT) {
 			wilc->mac_status = status;
-			up(&wilc->sync_event);
+			complete(&wilc->sync_event);
 		} else {
 			wilc->mac_status = status;
 		}
@@ -386,9 +386,9 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = wilc_lock_timeout(wilc, &wilc->sync_event, 5000);
-	if (ret)
-		return ret;
+	if (!wait_for_completion_timeout(&wilc->sync_event,
+					msecs_to_jiffies(5000)))
+		return -ETIME;
 
 	return 0;
 }
@@ -684,7 +684,7 @@ static int wlan_init_locks(struct net_device *dev)
 	init_completion(&wl->txq_event);
 
 	init_completion(&wl->cfg_event);
-	sema_init(&wl->sync_event, 0);
+	init_completion(&wl->sync_event);
 	init_completion(&wl->txq_thread_started);
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 5fbc07c..5cc6a82 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -179,7 +179,7 @@ struct wilc {
 	struct mutex hif_cs;
 
 	struct completion cfg_event;
-	struct semaphore sync_event;
+	struct completion sync_event;
 	struct completion txq_event;
 	struct completion txq_thread_started;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

