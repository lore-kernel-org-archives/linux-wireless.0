Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47200 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1C3A5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 31/34] ath6kl: rename the pm ops to something more sensible
Date: Tue, 29 Mar 2011 17:56:28 -0700
Message-ID: <1301446591-15236-32-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has no functional changes.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 359261b..314c552 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -164,14 +164,14 @@ static void ath6kl_hifdev_remove(struct sdio_func *func)
 }
 
 #if defined(CONFIG_PM)
-static int hifDeviceSuspend(struct device *dev)
+static int ath6kl_hifdev_suspend(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	int status = 0;
 	struct hif_device *device;
 
 	device = ath6kl_get_hifdev(func);
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceSuspend\n"));
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +ath6kl_hifdev_suspend\n"));
 
 	if (device && device->claimedContext &&
 	    osdrvCallbacks.deviceSuspendHandler) {
@@ -184,7 +184,7 @@ static int hifDeviceSuspend(struct device *dev)
 	}
 
 	CleanupHIFScatterResources(device);
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceSuspend\n"));
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -ath6kl_hifdev_suspend\n"));
 
 	switch (status) {
 	case 0:
@@ -197,14 +197,14 @@ static int hifDeviceSuspend(struct device *dev)
 	}
 }
 
-static int hifDeviceResume(struct device *dev)
+static int ath6kl_hifdev_resume(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	int status = 0;
 	struct hif_device *device;
 
 	device = ath6kl_get_hifdev(func);
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceResume\n"));
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +ath6kl_hifdev_resume\n"));
 	if (device && device->claimedContext &&
 	    osdrvCallbacks.deviceSuspendHandler) {
 		status = osdrvCallbacks.
@@ -212,14 +212,14 @@ static int hifDeviceResume(struct device *dev)
 		if (status == 0)
 			device->is_suspend = false;
 	}
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceResume\n"));
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -ath6kl_hifdev_resume\n"));
 
 	return status;
 }
 
-static const struct dev_pm_ops ar6k_device_pm_ops = {
-	.suspend = hifDeviceSuspend,
-	.resume = hifDeviceResume,
+static const struct dev_pm_ops ath6kl_hifdev_pmops = {
+	.suspend = ath6kl_hifdev_suspend,
+	.resume = ath6kl_hifdev_resume,
 };
 #endif /* CONFIG_PM */
 
@@ -230,7 +230,7 @@ static struct sdio_driver ath6kl_hifdev_driver = {
 	.remove = ath6kl_hifdev_remove,
 #if defined(CONFIG_PM)
 	.drv = {
-		.pm = &ar6k_device_pm_ops,
+		.pm = &ath6kl_hifdev_pmops,
 	},
 #endif
 };
-- 
1.7.0.4

