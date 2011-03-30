Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47182 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab1C3A5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 27/34] ath6kl: cleanup allocation and getting of the hif dev
Date: Tue, 29 Mar 2011 17:56:24 -0700
Message-ID: <1301446591-15236-28-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes verbose debug messages and checks that are just
not needed, and renames the functions to something more
sensible. While we clean this up, just move the routines
above and remove the forward declarations.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   65 +++++++++-----------
 1 files changed, 28 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 1752b33..c862a19 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -58,8 +58,6 @@ static int hifDeviceResume(struct device *dev);
 #endif /* CONFIG_PM */
 static int hifDeviceInserted(struct sdio_func *func, const struct sdio_device_id *id);
 static void hifDeviceRemoved(struct sdio_func *func);
-static struct hif_device *addHifDevice(struct sdio_func *func);
-static struct hif_device *getHifDevice(struct sdio_func *func);
 static void delHifDevice(struct hif_device * device);
 static int Func0_CMD52WriteByte(struct mmc_card *card, unsigned int address, unsigned char byte);
 static int Func0_CMD52ReadByte(struct mmc_card *card, unsigned int address, unsigned char *byte);
@@ -69,6 +67,26 @@ module_param(reset_sdio_on_unload, int, 0644);
 
 extern u32 nohifscattersupport;
 
+static struct hif_device *ath6kl_alloc_hifdev(struct sdio_func *func)
+{
+	struct hif_device *hifdevice;
+
+	hifdevice = kzalloc(sizeof(struct hif_device), GFP_KERNEL);
+
+#if HIF_USE_DMA_BOUNCE_BUFFER
+	hifdevice->dma_buffer = kmalloc(HIF_DMA_BUFFER_SIZE, GFP_KERNEL);
+#endif
+	hifdevice->func = func;
+	hifdevice->powerConfig = HIF_DEVICE_POWER_UP;
+	sdio_set_drvdata(func, hifdevice);
+
+	return hifdevice;
+}
+
+static struct hif_device *ath6kl_get_hifdev(struct sdio_func *func)
+{
+	return (struct hif_device *) sdio_get_drvdata(func);
+}
 
 /* ------ Static Variables ------ */
 static const struct sdio_device_id ar6k_id_table[] = {
@@ -774,7 +792,7 @@ hifIRQHandler(struct sdio_func *func)
     struct hif_device *device;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifIRQHandler\n"));
 
-    device = getHifDevice(func);
+    device = ath6kl_get_hifdev(func);
     atomic_set(&device->irqHandling, 1);
     /* release the host during ints so we can pick it back up when we process cmds */
     sdio_release_host(device->func);
@@ -829,8 +847,8 @@ static int hifDeviceInserted(struct sdio_func *func, const struct sdio_device_id
 		    ("AR6000: hifDeviceInserted, Function: 0x%X, Vendor ID: 0x%X, Device ID: 0x%X, block size: 0x%X/0x%X\n",
 		     func->num, func->vendor, func->device, func->max_blksize, func->cur_blksize));
 
-    addHifDevice(func);
-    device = getHifDevice(func);
+    ath6kl_alloc_hifdev(func);
+    device = ath6kl_get_hifdev(func);
 
     device->id = id;
     device->is_disabled = true;
@@ -951,7 +969,7 @@ static int hifDisableFunc(struct hif_device *device, struct sdio_func *func)
     int status = 0;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDisableFunc\n"));
-    device = getHifDevice(func);
+    device = ath6kl_get_hifdev(func);
     if (!IS_ERR(device->async_task)) {
         init_completion(&device->async_completion);
         device->async_shutdown = 1;
@@ -1000,7 +1018,7 @@ static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
     int ret = 0;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifEnableFunc\n"));
-    device = getHifDevice(func);
+    device = ath6kl_get_hifdev(func);
 
     if (device->is_disabled) {
        /* enable the SDIO function */
@@ -1079,7 +1097,7 @@ static int hifDeviceSuspend(struct device *dev)
     int status = 0;
     struct hif_device *device;   
 
-    device = getHifDevice(func);
+    device = ath6kl_get_hifdev(func);
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceSuspend\n"));
     if (device && device->claimedContext && osdrvCallbacks.deviceSuspendHandler) {
         device->is_suspend = true; /* set true first for PowerStateChangeNotify(..) */
@@ -1107,7 +1125,7 @@ static int hifDeviceResume(struct device *dev)
     int status = 0;
     struct hif_device *device;   
 
-    device = getHifDevice(func);
+    device = ath6kl_get_hifdev(func);
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceResume\n"));
     if (device && device->claimedContext && osdrvCallbacks.deviceSuspendHandler) {
         status = osdrvCallbacks.deviceResumeHandler(device->claimedContext);
@@ -1128,7 +1146,7 @@ static void hifDeviceRemoved(struct sdio_func *func)
     AR_DEBUG_ASSERT(func != NULL);
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceRemoved\n"));
-    device = getHifDevice(func);
+    device = ath6kl_get_hifdev(func);
     if (device->claimedContext != NULL) {
         status = osdrvCallbacks.deviceRemovedHandler(device->claimedContext, device);
     }
@@ -1178,33 +1196,6 @@ int hifWaitForPendingRecv(struct hif_device *device)
     return 0;
 }
     
-
-static struct hif_device *
-addHifDevice(struct sdio_func *func)
-{
-    struct hif_device *hifdevice;
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: addHifDevice\n"));
-    AR_DEBUG_ASSERT(func != NULL);
-    hifdevice = kzalloc(sizeof(struct hif_device), GFP_KERNEL);
-    AR_DEBUG_ASSERT(hifdevice != NULL);
-#if HIF_USE_DMA_BOUNCE_BUFFER
-    hifdevice->dma_buffer = kmalloc(HIF_DMA_BUFFER_SIZE, GFP_KERNEL);
-    AR_DEBUG_ASSERT(hifdevice->dma_buffer != NULL);
-#endif
-    hifdevice->func = func;
-    hifdevice->powerConfig = HIF_DEVICE_POWER_UP;
-    sdio_set_drvdata(func, hifdevice);
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: addHifDevice; 0x%p\n", hifdevice));
-    return hifdevice;
-}
-
-static struct hif_device *
-getHifDevice(struct sdio_func *func)
-{
-    AR_DEBUG_ASSERT(func != NULL);
-    return (struct hif_device *)sdio_get_drvdata(func);
-}
-
 static void
 delHifDevice(struct hif_device * device)
 {
-- 
1.7.0.4

