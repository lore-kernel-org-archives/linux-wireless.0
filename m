Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22609 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab1CNSOB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:14:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:13:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 38/38] ath6kl: remove-typedef HIF_DEVICE
Date: Mon, 14 Mar 2011 10:59:12 -0700
Message-ID: <1300125552-24422-39-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_DEVICE \
	"struct hif_device" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |    4 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |   40 +++++-----
 .../hif/sdio/linux_sdio/include/hif_internal.h     |   18 ++--
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   84 ++++++++++----------
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   12 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |   10 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    2 +-
 drivers/staging/ath6kl/include/ar3kconfig.h        |    2 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |   12 ++--
 drivers/staging/ath6kl/include/bmi.h               |   34 ++++----
 drivers/staging/ath6kl/include/common_drv.h        |   18 ++--
 drivers/staging/ath6kl/include/hif.h               |   34 ++++----
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   38 +++++-----
 drivers/staging/ath6kl/os/linux/eeprom.c           |    6 +-
 .../staging/ath6kl/os/linux/export_hci_transport.c |    6 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    4 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    4 +-
 .../ath6kl/os/linux/include/export_hci_transport.h |    6 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            |    2 +-
 19 files changed, 168 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/include/bmi_internal.h b/drivers/staging/ath6kl/bmi/include/bmi_internal.h
index e13fb01..6ae2ea7 100644
--- a/drivers/staging/ath6kl/bmi/include/bmi_internal.h
+++ b/drivers/staging/ath6kl/bmi/include/bmi_internal.h
@@ -42,12 +42,12 @@
 static bool bmiDone;
 
 int
-bmiBufferSend(HIF_DEVICE *device,
+bmiBufferSend(struct hif_device *device,
               u8 *buffer,
               u32 length);
 
 int
-bmiBufferReceive(HIF_DEVICE *device,
+bmiBufferReceive(struct hif_device *device,
                  u8 *buffer,
                  u32 length,
                  bool want_timeout);
diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index 34d1bef..9268bf3 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -106,7 +106,7 @@ BMICleanup(void)
 }
 
 int
-BMIDone(HIF_DEVICE *device)
+BMIDone(struct hif_device *device)
 {
     int status;
     u32 cid;
@@ -142,7 +142,7 @@ BMIDone(HIF_DEVICE *device)
 }
 
 int
-BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
+BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info)
 {
     int status;
     u32 cid;
@@ -201,7 +201,7 @@ BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
 }
 
 int
-BMIReadMemory(HIF_DEVICE *device,
+BMIReadMemory(struct hif_device *device,
               u32 address,
               u8 *buffer,
               u32 length)
@@ -257,7 +257,7 @@ BMIReadMemory(HIF_DEVICE *device,
 }
 
 int
-BMIWriteMemory(HIF_DEVICE *device,
+BMIWriteMemory(struct hif_device *device,
                u32 address,
                u8 *buffer,
                u32 length)
@@ -322,7 +322,7 @@ BMIWriteMemory(HIF_DEVICE *device,
 }
 
 int
-BMIExecute(HIF_DEVICE *device,
+BMIExecute(struct hif_device *device,
            u32 address,
            u32 *param)
 {
@@ -370,7 +370,7 @@ BMIExecute(HIF_DEVICE *device,
 }
 
 int
-BMISetAppStart(HIF_DEVICE *device,
+BMISetAppStart(struct hif_device *device,
                u32 address)
 {
     u32 cid;
@@ -407,7 +407,7 @@ BMISetAppStart(HIF_DEVICE *device,
 }
 
 int
-BMIReadSOCRegister(HIF_DEVICE *device,
+BMIReadSOCRegister(struct hif_device *device,
                    u32 address,
                    u32 *param)
 {
@@ -453,7 +453,7 @@ BMIReadSOCRegister(HIF_DEVICE *device,
 }
 
 int
-BMIWriteSOCRegister(HIF_DEVICE *device,
+BMIWriteSOCRegister(struct hif_device *device,
                     u32 address,
                     u32 param)
 {
@@ -493,7 +493,7 @@ BMIWriteSOCRegister(HIF_DEVICE *device,
 }
 
 int
-BMIrompatchInstall(HIF_DEVICE *device,
+BMIrompatchInstall(struct hif_device *device,
                    u32 ROM_addr,
                    u32 RAM_addr,
                    u32 nbytes,
@@ -549,7 +549,7 @@ BMIrompatchInstall(HIF_DEVICE *device,
 }
 
 int
-BMIrompatchUninstall(HIF_DEVICE *device,
+BMIrompatchUninstall(struct hif_device *device,
                      u32 rompatch_id)
 {
     u32 cid;
@@ -586,7 +586,7 @@ BMIrompatchUninstall(HIF_DEVICE *device,
 }
 
 static int
-_BMIrompatchChangeActivation(HIF_DEVICE *device,
+_BMIrompatchChangeActivation(struct hif_device *device,
                              u32 rompatch_count,
                              u32 *rompatch_list,
                              u32 do_activate)
@@ -630,7 +630,7 @@ _BMIrompatchChangeActivation(HIF_DEVICE *device,
 }
 
 int
-BMIrompatchActivate(HIF_DEVICE *device,
+BMIrompatchActivate(struct hif_device *device,
                     u32 rompatch_count,
                     u32 *rompatch_list)
 {
@@ -638,7 +638,7 @@ BMIrompatchActivate(HIF_DEVICE *device,
 }
 
 int
-BMIrompatchDeactivate(HIF_DEVICE *device,
+BMIrompatchDeactivate(struct hif_device *device,
                       u32 rompatch_count,
                       u32 *rompatch_list)
 {
@@ -646,7 +646,7 @@ BMIrompatchDeactivate(HIF_DEVICE *device,
 }
 
 int
-BMILZData(HIF_DEVICE *device,
+BMILZData(struct hif_device *device,
           u8 *buffer,
           u32 length)
 {
@@ -696,7 +696,7 @@ BMILZData(HIF_DEVICE *device,
 }
 
 int
-BMILZStreamStart(HIF_DEVICE *device,
+BMILZStreamStart(struct hif_device *device,
                  u32 address)
 {
     u32 cid;
@@ -734,7 +734,7 @@ BMILZStreamStart(HIF_DEVICE *device,
 
 /* BMI Access routines */
 int
-bmiBufferSend(HIF_DEVICE *device,
+bmiBufferSend(struct hif_device *device,
               u8 *buffer,
               u32 length)
 {
@@ -782,7 +782,7 @@ bmiBufferSend(HIF_DEVICE *device,
 }
 
 int
-bmiBufferReceive(HIF_DEVICE *device,
+bmiBufferReceive(struct hif_device *device,
                  u8 *buffer,
                  u32 length,
                  bool want_timeout)
@@ -958,7 +958,7 @@ bmiBufferReceive(HIF_DEVICE *device,
 }
 
 int
-BMIFastDownload(HIF_DEVICE *device, u32 address, u8 *buffer, u32 length)
+BMIFastDownload(struct hif_device *device, u32 address, u8 *buffer, u32 length)
 {
     int status = A_ERROR;
     u32 lastWord = 0;
@@ -998,13 +998,13 @@ BMIFastDownload(HIF_DEVICE *device, u32 address, u8 *buffer, u32 length)
 }
 
 int
-BMIRawWrite(HIF_DEVICE *device, u8 *buffer, u32 length)
+BMIRawWrite(struct hif_device *device, u8 *buffer, u32 length)
 {
     return bmiBufferSend(device, buffer, length);
 }
 
 int
-BMIRawRead(HIF_DEVICE *device, u8 *buffer, u32 length, bool want_timeout)
+BMIRawRead(struct hif_device *device, u8 *buffer, u32 length, bool want_timeout)
 {
     return bmiBufferReceive(device, buffer, length, want_timeout);
 }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
index 04fc284..6341560 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
@@ -88,9 +88,9 @@ struct hif_device {
 #define CMD53_FIXED_ADDRESS 1
 #define CMD53_INCR_ADDRESS  2
 
-BUS_REQUEST *hifAllocateBusRequest(HIF_DEVICE *device);
-void hifFreeBusRequest(HIF_DEVICE *device, BUS_REQUEST *busrequest);
-void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest);
+BUS_REQUEST *hifAllocateBusRequest(struct hif_device *device);
+void hifFreeBusRequest(struct hif_device *device, BUS_REQUEST *busrequest);
+void AddToAsyncList(struct hif_device *device, BUS_REQUEST *busrequest);
 
 #ifdef HIF_LINUX_MMC_SCATTER_SUPPORT
 
@@ -100,7 +100,7 @@ void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest);
 
 struct hif_scatter_req_priv {
     struct hif_scatter_req     *pHifScatterReq;  /* HIF scatter request with allocated entries */   
-    HIF_DEVICE          *device;          /* this device */
+    struct hif_device          *device;          /* this device */
     BUS_REQUEST         *busrequest;      /* request associated with request */
         /* scatter list for linux */    
     struct scatterlist  sgentries[MAX_SCATTER_ENTRIES_PER_REQ];   
@@ -108,18 +108,18 @@ struct hif_scatter_req_priv {
 
 #define ATH_DEBUG_SCATTER  ATH_DEBUG_MAKE_MODULE_MASK(0)
 
-int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support_info *pInfo);
-void CleanupHIFScatterResources(HIF_DEVICE *device);
-int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest);
+int SetupHIFScatterSupport(struct hif_device *device, struct hif_device_scatter_support_info *pInfo);
+void CleanupHIFScatterResources(struct hif_device *device);
+int DoHifReadWriteScatter(struct hif_device *device, BUS_REQUEST *busrequest);
 
 #else  // HIF_LINUX_MMC_SCATTER_SUPPORT
 
-static inline int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support_info *pInfo)
+static inline int SetupHIFScatterSupport(struct hif_device *device, struct hif_device_scatter_support_info *pInfo)
 {
     return A_ENOTSUP;
 }
 
-static inline int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
+static inline int DoHifReadWriteScatter(struct hif_device *device, BUS_REQUEST *busrequest)
 {
     return A_ENOTSUP;
 }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 9c9fb1e..e6d9cd8 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -58,9 +58,9 @@ static int hifDeviceResume(struct device *dev);
 #endif /* CONFIG_PM */
 static int hifDeviceInserted(struct sdio_func *func, const struct sdio_device_id *id);
 static void hifDeviceRemoved(struct sdio_func *func);
-static HIF_DEVICE *addHifDevice(struct sdio_func *func);
-static HIF_DEVICE *getHifDevice(struct sdio_func *func);
-static void delHifDevice(HIF_DEVICE * device);
+static struct hif_device *addHifDevice(struct sdio_func *func);
+static struct hif_device *getHifDevice(struct sdio_func *func);
+static void delHifDevice(struct hif_device * device);
 static int Func0_CMD52WriteByte(struct mmc_card *card, unsigned int address, unsigned char byte);
 static int Func0_CMD52ReadByte(struct mmc_card *card, unsigned int address, unsigned char *byte);
 
@@ -107,8 +107,8 @@ extern u32 busspeedlow;
 extern u32 debughif;
 
 static void ResetAllCards(void);
-static int hifDisableFunc(HIF_DEVICE *device, struct sdio_func *func);
-static int hifEnableFunc(HIF_DEVICE *device, struct sdio_func *func);
+static int hifDisableFunc(struct hif_device *device, struct sdio_func *func);
+static int hifEnableFunc(struct hif_device *device, struct sdio_func *func);
 
 #ifdef DEBUG
 
@@ -153,7 +153,7 @@ int HIFInit(OSDRV_CALLBACKS *callbacks)
 }
 
 static int
-__HIFReadWrite(HIF_DEVICE *device,
+__HIFReadWrite(struct hif_device *device,
              u32 address,
              u8 *buffer,
              u32 length,
@@ -304,7 +304,7 @@ __HIFReadWrite(HIF_DEVICE *device,
     return status;
 }
 
-void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest)
+void AddToAsyncList(struct hif_device *device, BUS_REQUEST *busrequest)
 {
     unsigned long flags;
     BUS_REQUEST *async;
@@ -330,7 +330,7 @@ void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 
 /* queue a read/write request */
 int
-HIFReadWrite(HIF_DEVICE *device,
+HIFReadWrite(struct hif_device *device,
              u32 address,
              u8 *buffer,
              u32 length,
@@ -400,12 +400,12 @@ HIFReadWrite(HIF_DEVICE *device,
 /* thread to serialize all requests, both sync and async */
 static int async_task(void *param)
  {
-    HIF_DEVICE *device;
+    struct hif_device *device;
     BUS_REQUEST *request;
     int status;
     unsigned long flags;
 
-    device = (HIF_DEVICE *)param;
+    device = (struct hif_device *)param;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: async task\n"));
     set_current_state(TASK_INTERRUPTIBLE);
     while(!device->async_shutdown) {
@@ -465,7 +465,7 @@ static int async_task(void *param)
     return 0;
 }
 
-static s32 IssueSDCommand(HIF_DEVICE *device, u32 opcode, u32 arg, u32 flags, u32 *resp)
+static s32 IssueSDCommand(struct hif_device *device, u32 opcode, u32 arg, u32 flags, u32 *resp)
 {
     struct mmc_command cmd;
     s32 err;
@@ -488,7 +488,7 @@ static s32 IssueSDCommand(HIF_DEVICE *device, u32 opcode, u32 arg, u32 flags, u3
     return err;
 }
 
-int ReinitSDIO(HIF_DEVICE *device)
+int ReinitSDIO(struct hif_device *device)
 {
     s32 err;
     struct mmc_host *host;
@@ -648,7 +648,7 @@ int ReinitSDIO(HIF_DEVICE *device)
 }
 
 int
-PowerStateChangeNotify(HIF_DEVICE *device, HIF_DEVICE_POWER_CHANGE_TYPE config)
+PowerStateChangeNotify(struct hif_device *device, HIF_DEVICE_POWER_CHANGE_TYPE config)
 {
     int status = 0;
 #if defined(CONFIG_PM)
@@ -691,7 +691,7 @@ PowerStateChangeNotify(HIF_DEVICE *device, HIF_DEVICE_POWER_CHANGE_TYPE config)
 }
 
 int
-HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
+HIFConfigureDevice(struct hif_device *device, HIF_DEVICE_CONFIG_OPCODE opcode,
                    void *config, u32 configLen)
 {
     u32 count;
@@ -745,7 +745,7 @@ HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
 }
 
 void
-HIFShutDownDevice(HIF_DEVICE *device)
+HIFShutDownDevice(struct hif_device *device)
 {
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +HIFShutDownDevice\n"));
     if (device != NULL) {
@@ -775,7 +775,7 @@ static void
 hifIRQHandler(struct sdio_func *func)
 {
     int status;
-    HIF_DEVICE *device;
+    struct hif_device *device;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifIRQHandler\n"));
 
     device = getHifDevice(func);
@@ -792,9 +792,9 @@ hifIRQHandler(struct sdio_func *func)
 /* handle HTC startup via thread*/
 static int startup_task(void *param)
 {
-    HIF_DEVICE *device;
+    struct hif_device *device;
 
-    device = (HIF_DEVICE *)param;
+    device = (struct hif_device *)param;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: call HTC from startup_task\n"));
         /* start  up inform DRV layer */
     if ((osdrvCallbacks.deviceInsertedHandler(osdrvCallbacks.context,device)) != 0) {
@@ -806,8 +806,8 @@ static int startup_task(void *param)
 #if defined(CONFIG_PM)
 static int enable_task(void *param)
 {
-    HIF_DEVICE *device;
-    device = (HIF_DEVICE *)param;
+    struct hif_device *device;
+    device = (struct hif_device *)param;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: call  from resume_task\n"));
 
         /* start  up inform DRV layer */
@@ -826,7 +826,7 @@ static int enable_task(void *param)
 static int hifDeviceInserted(struct sdio_func *func, const struct sdio_device_id *id)
 {
     int ret;
-    HIF_DEVICE * device;
+    struct hif_device * device;
     int count;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE,
@@ -866,7 +866,7 @@ static int hifDeviceInserted(struct sdio_func *func, const struct sdio_device_id
 
 
 void
-HIFAckInterrupt(HIF_DEVICE *device)
+HIFAckInterrupt(struct hif_device *device)
 {
     AR_DEBUG_ASSERT(device != NULL);
 
@@ -874,7 +874,7 @@ HIFAckInterrupt(HIF_DEVICE *device)
 }
 
 void
-HIFUnMaskInterrupt(HIF_DEVICE *device)
+HIFUnMaskInterrupt(struct hif_device *device)
 {
     int ret;
 
@@ -890,7 +890,7 @@ HIFUnMaskInterrupt(HIF_DEVICE *device)
     AR_DEBUG_ASSERT(ret == 0);
 }
 
-void HIFMaskInterrupt(HIF_DEVICE *device)
+void HIFMaskInterrupt(struct hif_device *device)
 {
     int ret;
     AR_DEBUG_ASSERT(device != NULL);
@@ -910,7 +910,7 @@ void HIFMaskInterrupt(HIF_DEVICE *device)
     AR_DEBUG_ASSERT(ret == 0);
 }
 
-BUS_REQUEST *hifAllocateBusRequest(HIF_DEVICE *device)
+BUS_REQUEST *hifAllocateBusRequest(struct hif_device *device)
 {
     BUS_REQUEST *busrequest;
     unsigned long flag;
@@ -930,7 +930,7 @@ BUS_REQUEST *hifAllocateBusRequest(HIF_DEVICE *device)
 }
 
 void
-hifFreeBusRequest(HIF_DEVICE *device, BUS_REQUEST *busrequest)
+hifFreeBusRequest(struct hif_device *device, BUS_REQUEST *busrequest)
 {
     unsigned long flag;
 
@@ -949,7 +949,7 @@ hifFreeBusRequest(HIF_DEVICE *device, BUS_REQUEST *busrequest)
     spin_unlock_irqrestore(&device->lock, flag);
 }
 
-static int hifDisableFunc(HIF_DEVICE *device, struct sdio_func *func)
+static int hifDisableFunc(struct hif_device *device, struct sdio_func *func)
 {
     int ret;
     int status = 0;
@@ -996,7 +996,7 @@ static int hifDisableFunc(HIF_DEVICE *device, struct sdio_func *func)
     return status;
 }
 
-static int hifEnableFunc(HIF_DEVICE *device, struct sdio_func *func)
+static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
 {
     struct task_struct* pTask;
     const char *taskName = NULL;
@@ -1081,7 +1081,7 @@ static int hifDeviceSuspend(struct device *dev)
 {
     struct sdio_func *func=dev_to_sdio_func(dev);
     int status = 0;
-    HIF_DEVICE *device;   
+    struct hif_device *device;   
 
     device = getHifDevice(func);
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceSuspend\n"));
@@ -1109,7 +1109,7 @@ static int hifDeviceResume(struct device *dev)
 {
     struct sdio_func *func=dev_to_sdio_func(dev);
     int status = 0;
-    HIF_DEVICE *device;   
+    struct hif_device *device;   
 
     device = getHifDevice(func);
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceResume\n"));
@@ -1128,7 +1128,7 @@ static int hifDeviceResume(struct device *dev)
 static void hifDeviceRemoved(struct sdio_func *func)
 {
     int status = 0;
-    HIF_DEVICE *device;
+    struct hif_device *device;
     AR_DEBUG_ASSERT(func != NULL);
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDeviceRemoved\n"));
@@ -1152,7 +1152,7 @@ static void hifDeviceRemoved(struct sdio_func *func)
 /*
  * This should be moved to AR6K HTC layer.
  */
-int hifWaitForPendingRecv(HIF_DEVICE *device)
+int hifWaitForPendingRecv(struct hif_device *device)
 {
     s32 cnt = 10;
     u8 host_int_status;
@@ -1183,13 +1183,13 @@ int hifWaitForPendingRecv(HIF_DEVICE *device)
 }
     
 
-static HIF_DEVICE *
+static struct hif_device *
 addHifDevice(struct sdio_func *func)
 {
-    HIF_DEVICE *hifdevice;
+    struct hif_device *hifdevice;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: addHifDevice\n"));
     AR_DEBUG_ASSERT(func != NULL);
-    hifdevice = kzalloc(sizeof(HIF_DEVICE), GFP_KERNEL);
+    hifdevice = kzalloc(sizeof(struct hif_device), GFP_KERNEL);
     AR_DEBUG_ASSERT(hifdevice != NULL);
 #if HIF_USE_DMA_BOUNCE_BUFFER
     hifdevice->dma_buffer = kmalloc(HIF_DMA_BUFFER_SIZE, GFP_KERNEL);
@@ -1202,15 +1202,15 @@ addHifDevice(struct sdio_func *func)
     return hifdevice;
 }
 
-static HIF_DEVICE *
+static struct hif_device *
 getHifDevice(struct sdio_func *func)
 {
     AR_DEBUG_ASSERT(func != NULL);
-    return (HIF_DEVICE *)sdio_get_drvdata(func);
+    return (struct hif_device *)sdio_get_drvdata(func);
 }
 
 static void
-delHifDevice(HIF_DEVICE * device)
+delHifDevice(struct hif_device * device)
 {
     AR_DEBUG_ASSERT(device!= NULL);
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: delHifDevice; 0x%p\n", device));
@@ -1222,17 +1222,17 @@ static void ResetAllCards(void)
 {
 }
 
-void HIFClaimDevice(HIF_DEVICE  *device, void *context)
+void HIFClaimDevice(struct hif_device  *device, void *context)
 {
     device->claimedContext = context;
 }
 
-void HIFReleaseDevice(HIF_DEVICE  *device)
+void HIFReleaseDevice(struct hif_device  *device)
 {
     device->claimedContext = NULL;
 }
 
-int HIFAttachHTC(HIF_DEVICE *device, HTC_CALLBACKS *callbacks)
+int HIFAttachHTC(struct hif_device *device, HTC_CALLBACKS *callbacks)
 {
     if (device->htcCallbacks.context != NULL) {
             /* already in use! */
@@ -1242,7 +1242,7 @@ int HIFAttachHTC(HIF_DEVICE *device, HTC_CALLBACKS *callbacks)
     return 0;
 }
 
-void HIFDetachHTC(HIF_DEVICE *device)
+void HIFDetachHTC(struct hif_device *device)
 {
     A_MEMZERO(&device->htcCallbacks,sizeof(device->htcCallbacks));
 }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index 2c64abe..a1fdcc1 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -48,7 +48,7 @@
             (((address) & 0x1FFFF) << 9)        | \
             ((bytes_blocks) & 0x1FF)
             
-static void FreeScatterReq(HIF_DEVICE *device, struct hif_scatter_req *pReq)
+static void FreeScatterReq(struct hif_device *device, struct hif_scatter_req *pReq)
 {   
     unsigned long flag;
 
@@ -60,7 +60,7 @@ static void FreeScatterReq(HIF_DEVICE *device, struct hif_scatter_req *pReq)
         
 }
 
-static struct hif_scatter_req *AllocScatterReq(HIF_DEVICE *device) 
+static struct hif_scatter_req *AllocScatterReq(struct hif_device *device) 
 {
     struct dl_list       *pItem; 
     unsigned long flag;
@@ -79,7 +79,7 @@ static struct hif_scatter_req *AllocScatterReq(HIF_DEVICE *device)
 }
 
     /* called by async task to perform the operation synchronously using direct MMC APIs  */
-int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
+int DoHifReadWriteScatter(struct hif_device *device, BUS_REQUEST *busrequest)
 {
     int                     i;
     u8 rw;
@@ -199,7 +199,7 @@ int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 }
 
     /* callback to issue a read-write scatter request */
-static int HifReadWriteScatter(HIF_DEVICE *device, struct hif_scatter_req *pReq)
+static int HifReadWriteScatter(struct hif_device *device, struct hif_scatter_req *pReq)
 {
     int             status = A_EINVAL;
     u32 request = pReq->Request;
@@ -275,7 +275,7 @@ static int HifReadWriteScatter(HIF_DEVICE *device, struct hif_scatter_req *pReq)
 }
 
     /* setup of HIF scatter resources */
-int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support_info *pInfo)
+int SetupHIFScatterSupport(struct hif_device *device, struct hif_device_scatter_support_info *pInfo)
 {
     int              status = A_ERROR;
     int                   i;
@@ -356,7 +356,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
 }
 
     /* clean up scatter support */
-void CleanupHIFScatterResources(HIF_DEVICE *device)
+void CleanupHIFScatterResources(struct hif_device *device)
 {
     struct hif_scatter_req_priv    *pReqPriv;
     struct hif_scatter_req         *pReq;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 91e763a..eeddf60 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -587,7 +587,7 @@ void DevDumpRegisters(struct ar6k_device               *pDev,
 
 #define DEV_GET_VIRT_DMA_INFO(p)  ((struct dev_scatter_dma_virtual_info *)((p)->HIFPrivate[0]))
 
-static struct hif_scatter_req *DevAllocScatterReq(HIF_DEVICE *Context)
+static struct hif_scatter_req *DevAllocScatterReq(struct hif_device *Context)
 {
     struct dl_list *pItem;
     struct ar6k_device *pDev = (struct ar6k_device *)Context;
@@ -600,7 +600,7 @@ static struct hif_scatter_req *DevAllocScatterReq(HIF_DEVICE *Context)
     return NULL;
 }
 
-static void DevFreeScatterReq(HIF_DEVICE *Context, struct hif_scatter_req *pReq)
+static void DevFreeScatterReq(struct hif_device *Context, struct hif_scatter_req *pReq)
 {
     struct ar6k_device *pDev = (struct ar6k_device *)Context;
     LOCK_AR6K(pDev);
@@ -664,7 +664,7 @@ static void DevReadWriteScatterAsyncHandler(void *Context, struct htc_packet *pP
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("-DevReadWriteScatterAsyncHandler \n"));
 }
 
-static int DevReadWriteScatter(HIF_DEVICE *Context, struct hif_scatter_req *pReq)
+static int DevReadWriteScatter(struct hif_device *Context, struct hif_scatter_req *pReq)
 {
     struct ar6k_device     *pDev = (struct ar6k_device *)Context;
     int        status = 0;
@@ -739,7 +739,7 @@ static void DevCleanupVirtualScatterSupport(struct ar6k_device *pDev)
     struct hif_scatter_req *pReq;
 
     while (1) {
-        pReq = DevAllocScatterReq((HIF_DEVICE *)pDev);
+        pReq = DevAllocScatterReq((struct hif_device *)pDev);
         if (NULL == pReq) {
             break;
         }
@@ -787,7 +787,7 @@ static int DevSetupVirtualScatterSupport(struct ar6k_device *pDev)
         pReq->ScatterMethod = HIF_SCATTER_DMA_BOUNCE;
         pReq->pScatterBounceBuffer = pVirtualInfo->pVirtDmaBuffer;
             /* free request to the list */
-        DevFreeScatterReq((HIF_DEVICE *)pDev,pReq);
+        DevFreeScatterReq((struct hif_device *)pDev,pReq);
     }
 
     if (status) {
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 8cf46b1..c6488e0 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -1233,7 +1233,7 @@ int HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
 int HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, u32 Baud)
 {
     struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans;
-    HIF_DEVICE *pHIFDevice = (HIF_DEVICE *)(pProt->pDev->HIFDevice);
+    struct hif_device *pHIFDevice = (struct hif_device *)(pProt->pDev->HIFDevice);
     u32 scaledBaud, scratchAddr;
     int status = 0;
 
diff --git a/drivers/staging/ath6kl/include/ar3kconfig.h b/drivers/staging/ath6kl/include/ar3kconfig.h
index 80f948e..91bc4ee 100644
--- a/drivers/staging/ath6kl/include/ar3kconfig.h
+++ b/drivers/staging/ath6kl/include/ar3kconfig.h
@@ -42,7 +42,7 @@ struct ar3k_config_info {
     u32 Flags;           /* config flags */
     void                     *pHCIDev;        /* HCI bridge device     */
     struct hci_transport_properties *pHCIProps;      /* HCI bridge props      */
-    HIF_DEVICE               *pHIFDevice;     /* HIF layer device      */
+    struct hif_device               *pHIFDevice;     /* HIF layer device      */
     
     u32 AR3KBaudRate;    /* AR3K operational baud rate */
     u16 AR6KScale;       /* AR6K UART scale value */
diff --git a/drivers/staging/ath6kl/include/ar6000_diag.h b/drivers/staging/ath6kl/include/ar6000_diag.h
index ca0961a..739c01c 100644
--- a/drivers/staging/ath6kl/include/ar6000_diag.h
+++ b/drivers/staging/ath6kl/include/ar6000_diag.h
@@ -26,23 +26,23 @@
 
 
 int
-ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
+ar6000_ReadRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data);
 
 int
-ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
+ar6000_WriteRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data);
 
 int
-ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,
+ar6000_ReadDataDiag(struct hif_device *hifDevice, u32 address,
                     u8 *data, u32 length);
 
 int
-ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, u32 address,
+ar6000_WriteDataDiag(struct hif_device *hifDevice, u32 address,
                      u8 *data, u32 length);
 
 int
-ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, u32 *regval);
+ar6k_ReadTargetRegister(struct hif_device *hifDevice, int regsel, u32 *regval);
 
 void
-ar6k_FetchTargetRegs(HIF_DEVICE *hifDevice, u32 *targregs);
+ar6k_FetchTargetRegs(struct hif_device *hifDevice, u32 *targregs);
 
 #endif /*AR6000_DIAG_H_*/
diff --git a/drivers/staging/ath6kl/include/bmi.h b/drivers/staging/ath6kl/include/bmi.h
index b44988d..eb1e756 100644
--- a/drivers/staging/ath6kl/include/bmi.h
+++ b/drivers/staging/ath6kl/include/bmi.h
@@ -44,44 +44,44 @@ void
 BMICleanup(void);
 
 int
-BMIDone(HIF_DEVICE *device);
+BMIDone(struct hif_device *device);
 
 int
-BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info);
+BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info);
 
 int
-BMIReadMemory(HIF_DEVICE *device,
+BMIReadMemory(struct hif_device *device,
               u32 address,
               u8 *buffer,
               u32 length);
 
 int
-BMIWriteMemory(HIF_DEVICE *device,
+BMIWriteMemory(struct hif_device *device,
                u32 address,
                u8 *buffer,
                u32 length);
 
 int
-BMIExecute(HIF_DEVICE *device,
+BMIExecute(struct hif_device *device,
            u32 address,
            u32 *param);
 
 int
-BMISetAppStart(HIF_DEVICE *device,
+BMISetAppStart(struct hif_device *device,
                u32 address);
 
 int
-BMIReadSOCRegister(HIF_DEVICE *device,
+BMIReadSOCRegister(struct hif_device *device,
                    u32 address,
                    u32 *param);
 
 int
-BMIWriteSOCRegister(HIF_DEVICE *device,
+BMIWriteSOCRegister(struct hif_device *device,
                     u32 address,
                     u32 param);
 
 int
-BMIrompatchInstall(HIF_DEVICE *device,
+BMIrompatchInstall(struct hif_device *device,
                    u32 ROM_addr,
                    u32 RAM_addr,
                    u32 nbytes,
@@ -89,41 +89,41 @@ BMIrompatchInstall(HIF_DEVICE *device,
                    u32 *patch_id);
 
 int
-BMIrompatchUninstall(HIF_DEVICE *device,
+BMIrompatchUninstall(struct hif_device *device,
                      u32 rompatch_id);
 
 int
-BMIrompatchActivate(HIF_DEVICE *device,
+BMIrompatchActivate(struct hif_device *device,
                     u32 rompatch_count,
                     u32 *rompatch_list);
 
 int
-BMIrompatchDeactivate(HIF_DEVICE *device,
+BMIrompatchDeactivate(struct hif_device *device,
                       u32 rompatch_count,
                       u32 *rompatch_list);
 
 int
-BMILZStreamStart(HIF_DEVICE *device,
+BMILZStreamStart(struct hif_device *device,
                  u32 address);
 
 int
-BMILZData(HIF_DEVICE *device,
+BMILZData(struct hif_device *device,
           u8 *buffer,
           u32 length);
 
 int
-BMIFastDownload(HIF_DEVICE *device,
+BMIFastDownload(struct hif_device *device,
                 u32 address,
                 u8 *buffer,
                 u32 length);
 
 int
-BMIRawWrite(HIF_DEVICE *device,
+BMIRawWrite(struct hif_device *device,
             u8 *buffer,
             u32 length);
 
 int
-BMIRawRead(HIF_DEVICE *device, 
+BMIRawRead(struct hif_device *device, 
            u8 *buffer, 
            u32 length,
            bool want_timeout);
diff --git a/drivers/staging/ath6kl/include/common_drv.h b/drivers/staging/ath6kl/include/common_drv.h
index 3508df4..b606334 100644
--- a/drivers/staging/ath6kl/include/common_drv.h
+++ b/drivers/staging/ath6kl/include/common_drv.h
@@ -66,30 +66,30 @@ extern "C" {
 /* OS-independent APIs */
 int ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, struct common_credit_state_info *pCredInfo);
 
-int ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
+int ar6000_ReadRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data);
 
-int ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
+int ar6000_WriteRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data);
 
-int ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,  u8 *data, u32 length);
+int ar6000_ReadDataDiag(struct hif_device *hifDevice, u32 address,  u8 *data, u32 length);
 
-int ar6000_reset_device(HIF_DEVICE *hifDevice, u32 TargetType, bool waitForCompletion, bool coldReset);
+int ar6000_reset_device(struct hif_device *hifDevice, u32 TargetType, bool waitForCompletion, bool coldReset);
 
-void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, u32 TargetType);
+void ar6000_dump_target_assert_info(struct hif_device *hifDevice, u32 TargetType);
 
-int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
+int ar6000_set_htc_params(struct hif_device *hifDevice,
                                u32 TargetType,
                                u32 MboxIsrYieldValue,
                                u8 HtcControlBuffers);
 
-int ar6000_prepare_target(HIF_DEVICE *hifDevice,
+int ar6000_prepare_target(struct hif_device *hifDevice,
                                u32 TargetType,
                                u32 TargetVersion);
 
-int ar6000_set_hci_bridge_flags(HIF_DEVICE *hifDevice,
+int ar6000_set_hci_bridge_flags(struct hif_device *hifDevice,
                                      u32 TargetType,
                                      u32 Flags);
 
-void ar6000_copy_cust_data_from_target(HIF_DEVICE *hifDevice, u32 TargetType);
+void ar6000_copy_cust_data_from_target(struct hif_device *hifDevice, u32 TargetType);
 
 u8 *ar6000_get_cust_data_buffer(u32 TargetType);
 
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 3dcb787..83650d5 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -38,7 +38,7 @@ extern "C" {
 
 
 typedef struct htc_callbacks HTC_CALLBACKS;
-typedef struct hif_device HIF_DEVICE;
+struct hif_device;
 
 /*
  * direction - Direction of transfer (HIF_READ/HIF_WRITE).
@@ -301,9 +301,9 @@ struct hif_scatter_req {
     struct hif_scatter_item    ScatterList[1];     /* start of scatter list */
 };
 
-typedef struct hif_scatter_req * ( *HIF_ALLOCATE_SCATTER_REQUEST)(HIF_DEVICE *device);
-typedef void ( *HIF_FREE_SCATTER_REQUEST)(HIF_DEVICE *device, struct hif_scatter_req *request);
-typedef int ( *HIF_READWRITE_SCATTER)(HIF_DEVICE *device, struct hif_scatter_req *request);
+typedef struct hif_scatter_req * ( *HIF_ALLOCATE_SCATTER_REQUEST)(struct hif_device *device);
+typedef void ( *HIF_FREE_SCATTER_REQUEST)(struct hif_device *device, struct hif_scatter_req *request);
+typedef int ( *HIF_READWRITE_SCATTER)(struct hif_device *device, struct hif_scatter_req *request);
 
 struct hif_device_scatter_support_info {
         /* information returned from HIF layer */
@@ -354,14 +354,14 @@ struct hif_pending_events_info {
 
     /* function to get pending events , some HIF modules use special mechanisms
      * to detect packet available and other interrupts */
-typedef int ( *HIF_PENDING_EVENTS_FUNC)(HIF_DEVICE              *device,
+typedef int ( *HIF_PENDING_EVENTS_FUNC)(struct hif_device              *device,
                                              struct hif_pending_events_info *pEvents,
                                              void                    *AsyncContext);
 
 #define HIF_MASK_RECV    true
 #define HIF_UNMASK_RECV  false
     /* function to mask recv events */
-typedef int ( *HIF_MASK_UNMASK_RECV_EVENT)(HIF_DEVICE  *device,
+typedef int ( *HIF_MASK_UNMASK_RECV_EVENT)(struct hif_device  *device,
                                                 bool      Mask,
                                                 void        *AsyncContext);
 
@@ -376,14 +376,14 @@ int HIFInit(OSDRV_CALLBACKS *callbacks);
 /* This API claims the HIF device and provides a context for handling removal.
  * The device removal callback is only called when the OSDRV layer claims
  * a device.  The claimed context must be non-NULL */
-void HIFClaimDevice(HIF_DEVICE *device, void *claimedContext);
+void HIFClaimDevice(struct hif_device *device, void *claimedContext);
 /* release the claimed device */
-void HIFReleaseDevice(HIF_DEVICE *device);
+void HIFReleaseDevice(struct hif_device *device);
 
 /* This API allows the HTC layer to attach to the HIF device */
-int HIFAttachHTC(HIF_DEVICE *device, HTC_CALLBACKS *callbacks);
+int HIFAttachHTC(struct hif_device *device, HTC_CALLBACKS *callbacks);
 /* This API detaches the HTC layer from the HIF device */
-void     HIFDetachHTC(HIF_DEVICE *device);
+void     HIFDetachHTC(struct hif_device *device);
 
 /*
  * This API is used to provide the read/write interface over the specific bus
@@ -398,7 +398,7 @@ void     HIFDetachHTC(HIF_DEVICE *device);
  * request - Characterizes the attributes of the command.
  */
 int
-HIFReadWrite(HIF_DEVICE    *device,
+HIFReadWrite(struct hif_device    *device,
              u32 address,
              u8       *buffer,
              u32 length,
@@ -409,7 +409,7 @@ HIFReadWrite(HIF_DEVICE    *device,
  * This can be initiated from the unload driver context when the OSDRV layer has no more use for
  * the device.
  */
-void HIFShutDownDevice(HIF_DEVICE *device);
+void HIFShutDownDevice(struct hif_device *device);
 
 /*
  * This should translate to an acknowledgment to the bus driver indicating that
@@ -418,11 +418,11 @@ void HIFShutDownDevice(HIF_DEVICE *device);
  * This should prevent the bus driver from raising an interrupt unless the
  * previous one has been serviced and acknowledged using the previous API.
  */
-void HIFAckInterrupt(HIF_DEVICE *device);
+void HIFAckInterrupt(struct hif_device *device);
 
-void HIFMaskInterrupt(HIF_DEVICE *device);
+void HIFMaskInterrupt(struct hif_device *device);
 
-void HIFUnMaskInterrupt(HIF_DEVICE *device);
+void HIFUnMaskInterrupt(struct hif_device *device);
  
 #ifdef THREAD_X
 /*
@@ -441,14 +441,14 @@ int HIFRWCompleteEventNotify(void);
 #endif
 
 int
-HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
+HIFConfigureDevice(struct hif_device *device, HIF_DEVICE_CONFIG_OPCODE opcode,
                    void *config, u32 configLen);
 
 /* 
  * This API wait for the remaining MBOX messages to be drained
  * This should be moved to HTC AR6K layer
  */
-int hifWaitForPendingRecv(HIF_DEVICE *device);
+int hifWaitForPendingRecv(struct hif_device *device);
 
 #ifdef __cplusplus
 }
diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index 3ada331..a23a524 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -83,7 +83,7 @@ static u8 custDataAR6003[AR6003_CUST_DATA_SIZE];
 #ifdef USE_4BYTE_REGISTER_ACCESS
 
     /* set the window address register (using 4-byte register access ). */
-int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, u32 RegisterAddr, u32 Address)
+int ar6000_SetAddressWindowRegister(struct hif_device *hifDevice, u32 RegisterAddr, u32 Address)
 {
     int status;
     u8 addrValue[4];
@@ -144,7 +144,7 @@ int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, u32 RegisterAddr, u32
 #else
 
     /* set the window address register */
-int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, u32 RegisterAddr, u32 Address)
+int ar6000_SetAddressWindowRegister(struct hif_device *hifDevice, u32 RegisterAddr, u32 Address)
 {
     int status;
 
@@ -187,7 +187,7 @@ int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, u32 RegisterAddr, u32
  * No cooperation from the Target is required for this.
  */
 int
-ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data)
+ar6000_ReadRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data)
 {
     int status;
 
@@ -221,7 +221,7 @@ ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data)
  * No cooperation from the Target is required for this.
  */
 int
-ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data)
+ar6000_WriteRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data)
 {
     int status;
 
@@ -244,7 +244,7 @@ ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data)
     }
 
 int
-ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,
+ar6000_ReadDataDiag(struct hif_device *hifDevice, u32 address,
                     u8 *data, u32 length)
 {
     u32 count;
@@ -262,7 +262,7 @@ ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,
 }
 
 int
-ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, u32 address,
+ar6000_WriteDataDiag(struct hif_device *hifDevice, u32 address,
                     u8 *data, u32 length)
 {
     u32 count;
@@ -280,7 +280,7 @@ ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, u32 address,
 }
 
 int
-ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, u32 *regval)
+ar6k_ReadTargetRegister(struct hif_device *hifDevice, int regsel, u32 *regval)
 {
     int status;
     u8 vals[4];
@@ -316,7 +316,7 @@ ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, u32 *regval)
 }
 
 void
-ar6k_FetchTargetRegs(HIF_DEVICE *hifDevice, u32 *targregs)
+ar6k_FetchTargetRegs(struct hif_device *hifDevice, u32 *targregs)
 {
     int i;
     u32 val;
@@ -330,7 +330,7 @@ ar6k_FetchTargetRegs(HIF_DEVICE *hifDevice, u32 *targregs)
 
 #if 0
 static int
-_do_write_diag(HIF_DEVICE *hifDevice, u32 addr, u32 value)
+_do_write_diag(struct hif_device *hifDevice, u32 addr, u32 value)
 {
     int status;
 
@@ -358,7 +358,7 @@ _do_write_diag(HIF_DEVICE *hifDevice, u32 addr, u32 value)
  */
 #if 0
 static int
-_delay_until_target_alive(HIF_DEVICE *hifDevice, s32 wait_msecs, u32 TargetType)
+_delay_until_target_alive(struct hif_device *hifDevice, s32 wait_msecs, u32 TargetType)
 {
     s32 actual_wait;
     s32 i;
@@ -399,7 +399,7 @@ _delay_until_target_alive(HIF_DEVICE *hifDevice, s32 wait_msecs, u32 TargetType)
 #define AR6002_RESET_CONTROL_ADDRESS 0x00004000
 #define AR6003_RESET_CONTROL_ADDRESS 0x00004000
 /* reset device */
-int ar6000_reset_device(HIF_DEVICE *hifDevice, u32 TargetType, bool waitForCompletion, bool coldReset)
+int ar6000_reset_device(struct hif_device *hifDevice, u32 TargetType, bool waitForCompletion, bool coldReset)
 {
     int status = 0;
     u32 address;
@@ -481,7 +481,7 @@ int ar6000_reset_device(HIF_DEVICE *hifDevice, u32 TargetType, bool waitForCompl
 
 /* This should be called in BMI phase after firmware is downloaded */
 void
-ar6000_copy_cust_data_from_target(HIF_DEVICE *hifDevice, u32 TargetType)
+ar6000_copy_cust_data_from_target(struct hif_device *hifDevice, u32 TargetType)
 {
     u32 eepHeaderAddr;
     u8 AR6003CustDataShadow[AR6003_CUST_DATA_SIZE+4];
@@ -552,7 +552,7 @@ u8 *ar6000_get_cust_data_buffer(u32 TargetType)
 #endif
 
 
-void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, u32 TargetType)
+void ar6000_dump_target_assert_info(struct hif_device *hifDevice, u32 TargetType)
 {
     u32 address;
     u32 regDumpArea = 0;
@@ -624,7 +624,7 @@ void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, u32 TargetType)
 
 /* set HTC/Mbox operational parameters, this can only be called when the target is in the
  * BMI phase */
-int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
+int ar6000_set_htc_params(struct hif_device *hifDevice,
                                u32 TargetType,
                                u32 MboxIsrYieldValue,
                                u8 HtcControlBuffers)
@@ -684,7 +684,7 @@ int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
 }
 
 
-static int prepare_ar6002(HIF_DEVICE *hifDevice, u32 TargetVersion)
+static int prepare_ar6002(struct hif_device *hifDevice, u32 TargetVersion)
 {
     int status = 0;
 
@@ -693,7 +693,7 @@ static int prepare_ar6002(HIF_DEVICE *hifDevice, u32 TargetVersion)
     return status;
 }
 
-static int prepare_ar6003(HIF_DEVICE *hifDevice, u32 TargetVersion)
+static int prepare_ar6003(struct hif_device *hifDevice, u32 TargetVersion)
 {
     int status = 0;
 
@@ -703,7 +703,7 @@ static int prepare_ar6003(HIF_DEVICE *hifDevice, u32 TargetVersion)
 }
 
 /* this function assumes the caller has already initialized the BMI APIs */
-int ar6000_prepare_target(HIF_DEVICE *hifDevice,
+int ar6000_prepare_target(struct hif_device *hifDevice,
                                u32 TargetType,
                                u32 TargetVersion)
 {
@@ -725,7 +725,7 @@ int ar6000_prepare_target(HIF_DEVICE *hifDevice,
  * TBDXXX: Remove this function when REV 1.x is desupported.
  */
 int
-ar6002_REV1_reset_force_host (HIF_DEVICE *hifDevice)
+ar6002_REV1_reset_force_host (struct hif_device *hifDevice)
 {
     s32 i;
     struct forceROM_s {
@@ -998,7 +998,7 @@ void a_module_debug_support_cleanup(void)
 }
 
     /* can only be called during bmi init stage */
-int ar6000_set_hci_bridge_flags(HIF_DEVICE *hifDevice,
+int ar6000_set_hci_bridge_flags(struct hif_device *hifDevice,
                                      u32 TargetType,
                                      u32 Flags)
 {
diff --git a/drivers/staging/ath6kl/os/linux/eeprom.c b/drivers/staging/ath6kl/os/linux/eeprom.c
index 7d049df..4cff9da 100644
--- a/drivers/staging/ath6kl/os/linux/eeprom.c
+++ b/drivers/staging/ath6kl/os/linux/eeprom.c
@@ -55,7 +55,7 @@ char *p_mac = NULL;
 
 static u8 eeprom_data[EEPROM_SZ];
 static u32 sys_sleep_reg;
-static HIF_DEVICE *p_bmi_device;
+static struct hif_device *p_bmi_device;
 
 //
 // Functions
@@ -158,7 +158,7 @@ BMI_write_mem(u32 address, u8 *p_data, u32 sz)
  * so we can access the EEPROM.
  */
 static void
-enable_SI(HIF_DEVICE *p_device)
+enable_SI(struct hif_device *p_device)
 {
     u32 regval;
 
@@ -361,7 +361,7 @@ commit_4bytes(int offset, u32 data)
 }
 /* ATHENV */
 #ifdef ANDROID_ENV
-void eeprom_ar6000_transfer(HIF_DEVICE *device, char *fake_file, char *p_mac)
+void eeprom_ar6000_transfer(struct hif_device *device, char *fake_file, char *p_mac)
 {
     u32 first_word;
     u32 board_data_addr;
diff --git a/drivers/staging/ath6kl/os/linux/export_hci_transport.c b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
index 787a8bd..442a286 100644
--- a/drivers/staging/ath6kl/os/linux/export_hci_transport.c
+++ b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
@@ -70,7 +70,7 @@ int ar6000_register_hci_transport(struct hci_transport_callbacks *hciTransCallba
 }
 
 int
-ar6000_get_hif_dev(HIF_DEVICE *device, void *config)
+ar6000_get_hif_dev(struct hif_device *device, void *config)
 {
     int status;
 
@@ -81,7 +81,7 @@ ar6000_get_hif_dev(HIF_DEVICE *device, void *config)
     return status;
 }
 
-int ar6000_set_uart_config(HIF_DEVICE *hifDevice,
+int ar6000_set_uart_config(struct hif_device *hifDevice,
                                 u32 scale,
                                 u32 step)
 {
@@ -97,7 +97,7 @@ int ar6000_set_uart_config(HIF_DEVICE *hifDevice,
     return status;
 }
 
-int ar6000_get_core_clock_config(HIF_DEVICE *hifDevice, u32 *data)
+int ar6000_get_core_clock_config(struct hif_device *hifDevice, u32 *data)
 {
     u32 regAddress;
     int status;
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index 1ff71e8..39e5798 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -270,7 +270,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
         ar3kconfig.pHCIDev = pHcidevInfo->pHCIDev;
         ar3kconfig.pHCIProps = &pHcidevInfo->HCIProps;
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        ar3kconfig.pHIFDevice = (HIF_DEVICE *)(pHcidevInfo->HCITransHdl.hifDevice);
+        ar3kconfig.pHIFDevice = (struct hif_device *)(pHcidevInfo->HCITransHdl.hifDevice);
 #else
         ar3kconfig.pHIFDevice = pHcidevInfo->ar->arHifDevice;
 #endif
@@ -868,7 +868,7 @@ static int bt_setup_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
         A_MEMZERO(&osDevInfo,sizeof(osDevInfo));
             /* get the underlying OS device */
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        status = ar6000_get_hif_dev((HIF_DEVICE *)(pHcidevInfo->HCITransHdl.hifDevice), 
+        status = ar6000_get_hif_dev((struct hif_device *)(pHcidevInfo->HCITransHdl.hifDevice), 
                                     &osDevInfo);
 #else
         status = HIFConfigureDevice(pHcidevInfo->ar->arHifDevice, 
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 9b5c0a3..89fd80a 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -121,8 +121,8 @@ struct USER_SAVEDKEYS {
 #define DBG_DEFAULTS    (DBG_ERROR|DBG_WARNING)
 
 
-int ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
-int ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
+int ar6000_ReadRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data);
+int ar6000_WriteRegDiag(struct hif_device *hifDevice, u32 *address, u32 *data);
 
 #ifdef __cplusplus
 extern "C" {
diff --git a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
index 31f4f78..74f9861 100644
--- a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
+++ b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
@@ -63,9 +63,9 @@ extern int    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTrans, bo
 
 extern int ar6000_register_hci_transport(struct hci_transport_callbacks *hciTransCallbacks);
 
-extern int ar6000_get_hif_dev(HIF_DEVICE *device, void *config);
+extern int ar6000_get_hif_dev(struct hif_device *device, void *config);
 
-extern int ar6000_set_uart_config(HIF_DEVICE *hifDevice, u32 scale, u32 step);
+extern int ar6000_set_uart_config(struct hif_device *hifDevice, u32 scale, u32 step);
 
 /* get core clock register settings
  * data: 0 - 40/44MHz
@@ -73,4 +73,4 @@ extern int ar6000_set_uart_config(HIF_DEVICE *hifDevice, u32 scale, u32 step);
  *       where (5G band/2.4G band)
  * assume 2.4G band for now
  */
-extern int ar6000_get_core_clock_config(HIF_DEVICE *hifDevice, u32 *data);
+extern int ar6000_get_core_clock_config(struct hif_device *hifDevice, u32 *data);
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index c650faa..0daa201 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -1865,7 +1865,7 @@ ar6000_ioctl_setkey(struct ar6_softc *ar, struct ieee80211req_key *ik)
 int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
     struct ar6_softc *ar = (struct ar6_softc *)ar6k_priv(dev);
-    HIF_DEVICE *hifDevice = ar->arHifDevice;
+    struct hif_device *hifDevice = ar->arHifDevice;
     int ret = 0, param;
     unsigned int address = 0;
     unsigned int length = 0;
-- 
1.7.4.15.g7811d

