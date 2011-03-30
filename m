Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47196 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1C3A5u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:25 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 30/34] ath6kl: cleanup and move the ath6kl pm ops to be assigned statically
Date: Tue, 29 Mar 2011 17:56:27 -0700
Message-ID: <1301446591-15236-31-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There should be no need to assign the pm ops dynamically, so
assign them statically and make them const. While we are
doing this just do some simple code style cleanup on the
routines and move them above prior to their assignment
into the driver ops.

This has no functional change other than assigning the
pm ops statically.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |  130 ++++++++++----------
 1 files changed, 64 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 9420c40..359261b 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -53,8 +53,6 @@
 #if defined(CONFIG_PM)
 #define dev_to_sdio_func(d)	container_of(d, struct sdio_func, dev)
 #define to_sdio_driver(d)      container_of(d, struct sdio_driver, drv)
-static int hifDeviceSuspend(struct device *dev);
-static int hifDeviceResume(struct device *dev);
 #endif /* CONFIG_PM */
 static void delHifDevice(struct hif_device * device);
 static int Func0_CMD52WriteByte(struct mmc_card *card, unsigned int address, unsigned char byte);
@@ -165,23 +163,77 @@ static void ath6kl_hifdev_remove(struct sdio_func *func)
 	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceRemoved\n"));
 }
 
+#if defined(CONFIG_PM)
+static int hifDeviceSuspend(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	int status = 0;
+	struct hif_device *device;
+
+	device = ath6kl_get_hifdev(func);
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceSuspend\n"));
+
+	if (device && device->claimedContext &&
+	    osdrvCallbacks.deviceSuspendHandler) {
+		/* set true first for PowerStateChangeNotify(..) */
+		device->is_suspend = true;
+		status = osdrvCallbacks.
+			deviceSuspendHandler(device->claimedContext);
+		if (status)
+			device->is_suspend = false;
+	}
+
+	CleanupHIFScatterResources(device);
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceSuspend\n"));
+
+	switch (status) {
+	case 0:
+		return 0;
+	case A_EBUSY:
+		/* Hack for kernel in order to support deep sleep and wow */
+		return -EBUSY;
+	default:
+		return -1;
+	}
+}
+
+static int hifDeviceResume(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	int status = 0;
+	struct hif_device *device;
+
+	device = ath6kl_get_hifdev(func);
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceResume\n"));
+	if (device && device->claimedContext &&
+	    osdrvCallbacks.deviceSuspendHandler) {
+		status = osdrvCallbacks.
+			deviceResumeHandler(device->claimedContext);
+		if (status == 0)
+			device->is_suspend = false;
+	}
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceResume\n"));
+
+	return status;
+}
+
+static const struct dev_pm_ops ar6k_device_pm_ops = {
+	.suspend = hifDeviceSuspend,
+	.resume = hifDeviceResume,
+};
+#endif /* CONFIG_PM */
+
 static struct sdio_driver ath6kl_hifdev_driver = {
 	.name = "ath6kl_hifdev",
 	.id_table = ath6kl_hifdev_ids,
 	.probe = ath6kl_hifdev_probe,
 	.remove = ath6kl_hifdev_remove,
-};
-
 #if defined(CONFIG_PM)
-/* New suspend/resume based on linux-2.6.32
- * Need to patch linux-2.6.32 with mmc2.6.32_suspend.patch
- * Need to patch with msmsdcc2.6.29_suspend.patch for msm_sdcc host
-     */
-static struct dev_pm_ops ar6k_device_pm_ops = {
-	.suspend = hifDeviceSuspend,
-	.resume = hifDeviceResume,
+	.drv = {
+		.pm = &ar6k_device_pm_ops,
+	},
+#endif
 };
-#endif /* CONFIG_PM */
 
 /* make sure we only unregister when registered. */
 static int registered = 0;
@@ -218,11 +270,6 @@ int HIFInit(OSDRV_CALLBACKS *callbacks)
 	/* Register with bus driver core */
 	registered = 1;
 
-#if defined(CONFIG_PM)
-	if (callbacks->deviceSuspendHandler && callbacks->deviceResumeHandler)
-		ath6kl_hifdev_driver.drv.pm = &ar6k_device_pm_ops;
-#endif /* CONFIG_PM */
-
 	r = sdio_register_driver(&ath6kl_hifdev_driver);
 	if (r < 0)
 		return r;
@@ -1112,55 +1159,6 @@ static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
     return ret;
 }
 
-#if defined(CONFIG_PM)
-static int hifDeviceSuspend(struct device *dev)
-{
-    struct sdio_func *func=dev_to_sdio_func(dev);
-    int status = 0;
-    struct hif_device *device;   
-
-    device = ath6kl_get_hifdev(func);
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceSuspend\n"));
-    if (device && device->claimedContext && osdrvCallbacks.deviceSuspendHandler) {
-        device->is_suspend = true; /* set true first for PowerStateChangeNotify(..) */
-        status = osdrvCallbacks.deviceSuspendHandler(device->claimedContext);
-        if (status) {
-            device->is_suspend = false;
-        }
-    }
-    CleanupHIFScatterResources(device);
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceSuspend\n"));
-
-    switch (status) {
-    case 0:
-        return 0;
-    case A_EBUSY:
-        return -EBUSY; /* Hack for kernel in order to support deep sleep and wow */
-    default:
-        return -1;
-    }
-}
-
-static int hifDeviceResume(struct device *dev)
-{
-    struct sdio_func *func=dev_to_sdio_func(dev);
-    int status = 0;
-    struct hif_device *device;   
-
-    device = ath6kl_get_hifdev(func);
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceResume\n"));
-    if (device && device->claimedContext && osdrvCallbacks.deviceSuspendHandler) {
-        status = osdrvCallbacks.deviceResumeHandler(device->claimedContext);
-        if (status == 0) {
-            device->is_suspend = false;
-        }
-    }
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceResume\n"));
-
-    return status;
-}
-#endif /* CONFIG_PM */
-
 /*
  * This should be moved to AR6K HTC layer.
  */
-- 
1.7.0.4

