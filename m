Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47184 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1C3A5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 28/34] ath6kl: style cleanup on struct sdio_driver components
Date: Tue, 29 Mar 2011 17:56:25 -0700
Message-ID: <1301446591-15236-29-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes except renames of the routines and
id data structure.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |  172 ++++++++++----------
 1 files changed, 85 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index c862a19..9420c40 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -56,12 +56,14 @@
 static int hifDeviceSuspend(struct device *dev);
 static int hifDeviceResume(struct device *dev);
 #endif /* CONFIG_PM */
-static int hifDeviceInserted(struct sdio_func *func, const struct sdio_device_id *id);
-static void hifDeviceRemoved(struct sdio_func *func);
 static void delHifDevice(struct hif_device * device);
 static int Func0_CMD52WriteByte(struct mmc_card *card, unsigned int address, unsigned char byte);
 static int Func0_CMD52ReadByte(struct mmc_card *card, unsigned int address, unsigned char *byte);
 
+static int hifEnableFunc(struct hif_device *device, struct sdio_func *func);
+static int hifDisableFunc(struct hif_device *device, struct sdio_func *func);
+OSDRV_CALLBACKS osdrvCallbacks;
+
 int reset_sdio_on_unload = 0;
 module_param(reset_sdio_on_unload, int, 0644);
 
@@ -88,21 +90,86 @@ static struct hif_device *ath6kl_get_hifdev(struct sdio_func *func)
 	return (struct hif_device *) sdio_get_drvdata(func);
 }
 
-/* ------ Static Variables ------ */
-static const struct sdio_device_id ar6k_id_table[] = {
-    {  SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6002_BASE | 0x0))  },
-    {  SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6002_BASE | 0x1))  },
-    {  SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6003_BASE | 0x0))  },
-    {  SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6003_BASE | 0x1))  },
-    { /* null */                                         },
+static const struct sdio_device_id ath6kl_hifdev_ids[] = {
+	{ SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6002_BASE | 0x0)) },
+	{ SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6002_BASE | 0x1)) },
+	{ SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6003_BASE | 0x0)) },
+	{ SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6003_BASE | 0x1)) },
+	{ /* null */                                         },
 };
-MODULE_DEVICE_TABLE(sdio, ar6k_id_table);
 
-static struct sdio_driver ar6k_driver = {
-	.name = "ar6k_wlan",
-	.id_table = ar6k_id_table,
-	.probe = hifDeviceInserted,
-	.remove = hifDeviceRemoved,
+MODULE_DEVICE_TABLE(sdio, ath6kl_hifdev_ids);
+
+static int ath6kl_hifdev_probe(struct sdio_func *func,
+			       const struct sdio_device_id *id)
+{
+	int ret;
+	struct hif_device *device;
+	int count;
+
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE,
+			("ath6kl: Function: 0x%X, Vendor ID: 0x%X, "
+			 "Device ID: 0x%X, block size: 0x%X/0x%X\n",
+			func->num, func->vendor, func->device,
+			func->max_blksize, func->cur_blksize));
+
+	ath6kl_alloc_hifdev(func);
+	device = ath6kl_get_hifdev(func);
+
+	device->id = id;
+	device->is_disabled = true;
+
+	spin_lock_init(&device->lock);
+	spin_lock_init(&device->asynclock);
+
+	DL_LIST_INIT(&device->ScatterReqHead);
+
+	/* Try to allow scatter unless globally overridden */
+	if (!nohifscattersupport)
+		device->scatter_enabled = true;
+
+	A_MEMZERO(device->busRequest, sizeof(device->busRequest));
+
+	for (count = 0; count < BUS_REQUEST_MAX_NUM; count++) {
+		sema_init(&device->busRequest[count].sem_req, 0);
+		hifFreeBusRequest(device, &device->busRequest[count]);
+	}
+
+	sema_init(&device->sem_async, 0);
+
+	ret = hifEnableFunc(device, func);
+
+	return ret;
+}
+
+static void ath6kl_hifdev_remove(struct sdio_func *func)
+{
+	int status = 0;
+	struct hif_device *device;
+	AR_DEBUG_ASSERT(func != NULL);
+
+	device = ath6kl_get_hifdev(func);
+	if (device->claimedContext != NULL)
+		status = osdrvCallbacks.
+			deviceRemovedHandler(device->claimedContext, device);
+
+	if (device->is_disabled)
+		device->is_disabled = false;
+	else
+		status = hifDisableFunc(device, func);
+
+	CleanupHIFScatterResources(device);
+
+	delHifDevice(device);
+	AR_DEBUG_ASSERT(status == 0);
+	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceRemoved\n"));
+}
+
+static struct sdio_driver ath6kl_hifdev_driver = {
+	.name = "ath6kl_hifdev",
+	.id_table = ath6kl_hifdev_ids,
+	.probe = ath6kl_hifdev_probe,
+	.remove = ath6kl_hifdev_remove,
 };
 
 #if defined(CONFIG_PM)
@@ -119,14 +186,11 @@ static struct dev_pm_ops ar6k_device_pm_ops = {
 /* make sure we only unregister when registered. */
 static int registered = 0;
 
-OSDRV_CALLBACKS osdrvCallbacks;
 extern u32 onebitmode;
 extern u32 busspeedlow;
 extern u32 debughif;
 
 static void ResetAllCards(void);
-static int hifDisableFunc(struct hif_device *device, struct sdio_func *func);
-static int hifEnableFunc(struct hif_device *device, struct sdio_func *func);
 
 #ifdef DEBUG
 
@@ -156,10 +220,10 @@ int HIFInit(OSDRV_CALLBACKS *callbacks)
 
 #if defined(CONFIG_PM)
 	if (callbacks->deviceSuspendHandler && callbacks->deviceResumeHandler)
-		ar6k_driver.drv.pm = &ar6k_device_pm_ops;
+		ath6kl_hifdev_driver.drv.pm = &ar6k_device_pm_ops;
 #endif /* CONFIG_PM */
 
-	r = sdio_register_driver(&ar6k_driver);
+	r = sdio_register_driver(&ath6kl_hifdev_driver);
 	if (r < 0)
 		return r;
 
@@ -777,7 +841,7 @@ HIFShutDownDevice(struct hif_device *device)
             registered = 0;
             AR_DEBUG_PRINTF(ATH_DEBUG_TRACE,
                             ("AR6000: Unregistering with the bus driver\n"));
-            sdio_unregister_driver(&ar6k_driver);
+            sdio_unregister_driver(&ath6kl_hifdev_driver);
             AR_DEBUG_PRINTF(ATH_DEBUG_TRACE,
                             ("AR6000: Unregistered\n"));
         }
@@ -837,48 +901,6 @@ static int enable_task(void *param)
 }
 #endif
 
-static int hifDeviceInserted(struct sdio_func *func, const struct sdio_device_id *id)
-{
-    int ret;
-    struct hif_device * device;
-    int count;
-
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE,
-		    ("AR6000: hifDeviceInserted, Function: 0x%X, Vendor ID: 0x%X, Device ID: 0x%X, block size: 0x%X/0x%X\n",
-		     func->num, func->vendor, func->device, func->max_blksize, func->cur_blksize));
-
-    ath6kl_alloc_hifdev(func);
-    device = ath6kl_get_hifdev(func);
-
-    device->id = id;
-    device->is_disabled = true;
-
-    spin_lock_init(&device->lock);
-
-    spin_lock_init(&device->asynclock);
-    
-    DL_LIST_INIT(&device->ScatterReqHead);
-    
-    if (!nohifscattersupport) {
-            /* try to allow scatter operation on all instances,
-             * unless globally overridden */
-        device->scatter_enabled = true;
-    }
-
-    /* Initialize the bus requests to be used later */
-    A_MEMZERO(device->busRequest, sizeof(device->busRequest));
-    for (count = 0; count < BUS_REQUEST_MAX_NUM; count ++) {
-        sema_init(&device->busRequest[count].sem_req, 0);
-        hifFreeBusRequest(device, &device->busRequest[count]);
-    }
-    sema_init(&device->sem_async, 0);
-    
-    ret  = hifEnableFunc(device, func);
-
-    return ret;
-}
-
-
 void
 HIFAckInterrupt(struct hif_device *device)
 {
@@ -1139,30 +1161,6 @@ static int hifDeviceResume(struct device *dev)
 }
 #endif /* CONFIG_PM */
 
-static void hifDeviceRemoved(struct sdio_func *func)
-{
-    int status = 0;
-    struct hif_device *device;
-    AR_DEBUG_ASSERT(func != NULL);
-
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceRemoved\n"));
-    device = ath6kl_get_hifdev(func);
-    if (device->claimedContext != NULL) {
-        status = osdrvCallbacks.deviceRemovedHandler(device->claimedContext, device);
-    }
-
-    if (device->is_disabled) {
-        device->is_disabled = false;
-    } else {
-        status = hifDisableFunc(device, func);
-    }
-    CleanupHIFScatterResources(device);
-     
-    delHifDevice(device);
-    AR_DEBUG_ASSERT(status == 0);
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceRemoved\n"));
-}
-
 /*
  * This should be moved to AR6K HTC layer.
  */
-- 
1.7.0.4

