Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29939 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1CKCz7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:55:59 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:36 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/20] ath6kl: s|A_MEMCPY|memcpy|g
Date: Thu, 10 Mar 2011 18:55:29 -0800
Message-ID: <1299812147-12069-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for i in $(find ./drivers/staging/ath6kl/ -name \*.[ch]) ; do \
        sed -r -i -e "s/A_MEMCPY/memcpy/g" $i; done

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/bmi/src/bmi.c               |   74 +++++-----
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |   12 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |    8 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    2 +-
 drivers/staging/ath6kl/htc2/htc.c                  |    4 +-
 drivers/staging/ath6kl/htc2/htc_recv.c             |    6 +-
 drivers/staging/ath6kl/htc2/htc_services.c         |    6 +-
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   56 ++++----
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |    2 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   36 +++---
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    4 +-
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    2 -
 drivers/staging/ath6kl/os/linux/ioctl.c            |   30 ++--
 drivers/staging/ath6kl/os/linux/netbuf.c           |    8 +-
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |   26 ++--
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |    2 +-
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |    2 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |    2 +-
 drivers/staging/ath6kl/wmi/wmi.c                   |  146 ++++++++++----------
 21 files changed, 215 insertions(+), 217 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index 49aed8a..1e1e6ee 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -231,11 +231,11 @@ BMIReadMemory(HIF_DEVICE *device,
     {
         rxlen = (remaining < BMI_DATASZ_MAX) ? remaining : BMI_DATASZ_MAX;
         offset = 0;
-        A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+        memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
         offset += sizeof(cid);
-        A_MEMCPY(&(pBMICmdBuf[offset]), &address, sizeof(address));
+        memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
         offset += sizeof(address);
-        A_MEMCPY(&(pBMICmdBuf[offset]), &rxlen, sizeof(rxlen));
+        memcpy(&(pBMICmdBuf[offset]), &rxlen, sizeof(rxlen));
         offset += sizeof(length);
 
         status = bmiBufferSend(device, pBMICmdBuf, offset);
@@ -248,7 +248,7 @@ BMIReadMemory(HIF_DEVICE *device,
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read from the device\n"));
             return A_ERROR;
         }
-        A_MEMCPY(&buffer[length - remaining], pBMICmdBuf, rxlen);
+        memcpy(&buffer[length - remaining], pBMICmdBuf, rxlen);
         remaining -= rxlen; address += rxlen;
     }
 
@@ -300,13 +300,13 @@ BMIWriteMemory(HIF_DEVICE *device,
             txlen = (BMI_DATASZ_MAX - header);
         }
         offset = 0;
-        A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+        memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
         offset += sizeof(cid);
-        A_MEMCPY(&(pBMICmdBuf[offset]), &address, sizeof(address));
+        memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
         offset += sizeof(address);
-        A_MEMCPY(&(pBMICmdBuf[offset]), &txlen, sizeof(txlen));
+        memcpy(&(pBMICmdBuf[offset]), &txlen, sizeof(txlen));
         offset += sizeof(txlen);
-        A_MEMCPY(&(pBMICmdBuf[offset]), src, txlen);
+        memcpy(&(pBMICmdBuf[offset]), src, txlen);
         offset += txlen;
         status = bmiBufferSend(device, pBMICmdBuf, offset);
         if (status) {
@@ -345,11 +345,11 @@ BMIExecute(HIF_DEVICE *device,
     cid = BMI_EXECUTE;
 
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &address, sizeof(address));
+    memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
-    A_MEMCPY(&(pBMICmdBuf[offset]), param, sizeof(*param));
+    memcpy(&(pBMICmdBuf[offset]), param, sizeof(*param));
     offset += sizeof(*param);
     status = bmiBufferSend(device, pBMICmdBuf, offset);
     if (status) {
@@ -363,7 +363,7 @@ BMIExecute(HIF_DEVICE *device,
         return A_ERROR;
     }
 
-    A_MEMCPY(param, pBMICmdBuf, sizeof(*param));
+    memcpy(param, pBMICmdBuf, sizeof(*param));
 
     AR_DEBUG_PRINTF(ATH_DEBUG_BMI, ("BMI Execute: Exit (param: %d)\n", *param));
     return 0;
@@ -392,9 +392,9 @@ BMISetAppStart(HIF_DEVICE *device,
     cid = BMI_SET_APP_START;
 
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &address, sizeof(address));
+    memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
     status = bmiBufferSend(device, pBMICmdBuf, offset);
     if (status) {
@@ -430,9 +430,9 @@ BMIReadSOCRegister(HIF_DEVICE *device,
     cid = BMI_READ_SOC_REGISTER;
 
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &address, sizeof(address));
+    memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
 
     status = bmiBufferSend(device, pBMICmdBuf, offset);
@@ -446,7 +446,7 @@ BMIReadSOCRegister(HIF_DEVICE *device,
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read from the device\n"));
         return A_ERROR;
     }
-    A_MEMCPY(param, pBMICmdBuf, sizeof(*param));
+    memcpy(param, pBMICmdBuf, sizeof(*param));
 
     AR_DEBUG_PRINTF(ATH_DEBUG_BMI, ("BMI Read SOC Register: Exit (value: %d)\n", *param));
     return 0;
@@ -476,11 +476,11 @@ BMIWriteSOCRegister(HIF_DEVICE *device,
     cid = BMI_WRITE_SOC_REGISTER;
 
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &address, sizeof(address));
+    memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &param, sizeof(param));
+    memcpy(&(pBMICmdBuf[offset]), &param, sizeof(param));
     offset += sizeof(param);
     status = bmiBufferSend(device, pBMICmdBuf, offset);
     if (status) {
@@ -521,15 +521,15 @@ BMIrompatchInstall(HIF_DEVICE *device,
     cid = BMI_ROMPATCH_INSTALL;
 
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &ROM_addr, sizeof(ROM_addr));
+    memcpy(&(pBMICmdBuf[offset]), &ROM_addr, sizeof(ROM_addr));
     offset += sizeof(ROM_addr);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &RAM_addr, sizeof(RAM_addr));
+    memcpy(&(pBMICmdBuf[offset]), &RAM_addr, sizeof(RAM_addr));
     offset += sizeof(RAM_addr);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &nbytes, sizeof(nbytes));
+    memcpy(&(pBMICmdBuf[offset]), &nbytes, sizeof(nbytes));
     offset += sizeof(nbytes);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &do_activate, sizeof(do_activate));
+    memcpy(&(pBMICmdBuf[offset]), &do_activate, sizeof(do_activate));
     offset += sizeof(do_activate);
     status = bmiBufferSend(device, pBMICmdBuf, offset);
     if (status) {
@@ -542,7 +542,7 @@ BMIrompatchInstall(HIF_DEVICE *device,
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read from the device\n"));
         return A_ERROR;
     }
-    A_MEMCPY(rompatch_id, pBMICmdBuf, sizeof(*rompatch_id));
+    memcpy(rompatch_id, pBMICmdBuf, sizeof(*rompatch_id));
 
     AR_DEBUG_PRINTF(ATH_DEBUG_BMI, ("BMI rompatch Install: (rompatch_id=%d)\n", *rompatch_id));
     return 0;
@@ -571,9 +571,9 @@ BMIrompatchUninstall(HIF_DEVICE *device,
     cid = BMI_ROMPATCH_UNINSTALL;
 
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &rompatch_id, sizeof(rompatch_id));
+    memcpy(&(pBMICmdBuf[offset]), &rompatch_id, sizeof(rompatch_id));
     offset += sizeof(rompatch_id);
     status = bmiBufferSend(device, pBMICmdBuf, offset);
     if (status) {
@@ -611,12 +611,12 @@ _BMIrompatchChangeActivation(HIF_DEVICE *device,
     cid = do_activate ? BMI_ROMPATCH_ACTIVATE : BMI_ROMPATCH_DEACTIVATE;
 
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &rompatch_count, sizeof(rompatch_count));
+    memcpy(&(pBMICmdBuf[offset]), &rompatch_count, sizeof(rompatch_count));
     offset += sizeof(rompatch_count);
     length = rompatch_count * sizeof(*rompatch_list);
-    A_MEMCPY(&(pBMICmdBuf[offset]), rompatch_list, length);
+    memcpy(&(pBMICmdBuf[offset]), rompatch_list, length);
     offset += length;
     status = bmiBufferSend(device, pBMICmdBuf, offset);
     if (status) {
@@ -676,11 +676,11 @@ BMILZData(HIF_DEVICE *device,
         txlen = (remaining < (BMI_DATASZ_MAX - header)) ?
                                        remaining : (BMI_DATASZ_MAX - header);
         offset = 0;
-        A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+        memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
         offset += sizeof(cid);
-        A_MEMCPY(&(pBMICmdBuf[offset]), &txlen, sizeof(txlen));
+        memcpy(&(pBMICmdBuf[offset]), &txlen, sizeof(txlen));
         offset += sizeof(txlen);
-        A_MEMCPY(&(pBMICmdBuf[offset]), &buffer[length - remaining], txlen);
+        memcpy(&(pBMICmdBuf[offset]), &buffer[length - remaining], txlen);
         offset += txlen;
         status = bmiBufferSend(device, pBMICmdBuf, offset);
         if (status) {
@@ -717,9 +717,9 @@ BMILZStreamStart(HIF_DEVICE *device,
 
     cid = BMI_LZ_STREAM_START;
     offset = 0;
-    A_MEMCPY(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
+    memcpy(&(pBMICmdBuf[offset]), &cid, sizeof(cid));
     offset += sizeof(cid);
-    A_MEMCPY(&(pBMICmdBuf[offset]), &address, sizeof(address));
+    memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
     status = bmiBufferSend(device, pBMICmdBuf, offset);
     if (status) {
@@ -972,7 +972,7 @@ BMIFastDownload(HIF_DEVICE *device, u32 address, A_UCHAR *buffer, u32 length)
 
     if (unalignedBytes) {
             /* copy the last word into a zero padded buffer */
-        A_MEMCPY(&lastWord, &buffer[lastWordOffset], unalignedBytes);
+        memcpy(&lastWord, &buffer[lastWordOffset], unalignedBytes);
     }
 
     status = BMILZData(device, buffer, lastWordOffset);
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index ff0480b..cf75c20 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -254,7 +254,7 @@ int DevEnableInterrupts(AR6K_DEVICE *pDev)
         COUNTER_INT_STATUS_ENABLE_BIT_SET(AR6K_TARGET_DEBUG_INTR_MASK);
 
         /* copy into our temp area */
-    A_MEMCPY(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
+    memcpy(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
 
     UNLOCK_AR6K(pDev);
 
@@ -287,7 +287,7 @@ int DevDisableInterrupts(AR6K_DEVICE *pDev)
     pDev->IrqEnableRegisters.error_status_enable = 0;
     pDev->IrqEnableRegisters.counter_int_status_enable = 0;
         /* copy into our temp area */
-    A_MEMCPY(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
+    memcpy(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
 
     UNLOCK_AR6K(pDev);
 
@@ -419,7 +419,7 @@ static int DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, bool EnableRecv, bool
     }
 
         /* copy into our temp area */
-    A_MEMCPY(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
+    memcpy(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
     UNLOCK_AR6K(pDev);
 
     do {
@@ -435,7 +435,7 @@ static int DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, bool EnableRecv, bool
             }
 
                 /* copy values to write to our async I/O buffer */
-            A_MEMCPY(pIOPacket->pBuffer,&regs,AR6K_IRQ_ENABLE_REGS_SIZE);
+            memcpy(pIOPacket->pBuffer,&regs,AR6K_IRQ_ENABLE_REGS_SIZE);
 
                 /* stick in our completion routine when the I/O operation completes */
             pIOPacket->Completion = DevDoEnableDisableRecvAsyncHandler;
@@ -635,10 +635,10 @@ int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, bool FromDMA)
 
         if (FromDMA) {
                 /* from DMA buffer */
-            A_MEMCPY(pReq->ScatterList[i].pBuffer, pDMABuffer , length);
+            memcpy(pReq->ScatterList[i].pBuffer, pDMABuffer , length);
         } else {
                 /* to DMA buffer */
-            A_MEMCPY(pDMABuffer, pReq->ScatterList[i].pBuffer, length);
+            memcpy(pDMABuffer, pReq->ScatterList[i].pBuffer, length);
         }
 
         pDMABuffer += length;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index 4517bef..bee4850 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -752,7 +752,7 @@ void DumpAR6KDevState(AR6K_DEVICE *pDev)
 
     LOCK_AR6K(pDev);
         /* copy into our temp area */
-    A_MEMCPY(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
+    memcpy(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
     UNLOCK_AR6K(pDev);
 
         /* load the register table from the device */
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
index d58e418..46bcb27 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
@@ -93,7 +93,7 @@ static int DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE
             ~(COUNTER_INT_STATUS_ENABLE_BIT_SET(1 << AR6K_GMBOX_CREDIT_COUNTER));    
     }
         /* copy into our temp area */
-    A_MEMCPY(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
+    memcpy(&regs,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
 
     UNLOCK_AR6K(pDev);
 
@@ -110,7 +110,7 @@ static int DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE
             }
 
                 /* copy values to write to our async I/O buffer */
-            A_MEMCPY(pIOPacket->pBuffer,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
+            memcpy(pIOPacket->pBuffer,&pDev->IrqEnableRegisters,AR6K_IRQ_ENABLE_REGS_SIZE);
 
                 /* stick in our completion routine when the I/O operation completes */
             pIOPacket->Completion = DevGMboxIRQActionAsyncHandler;
@@ -216,7 +216,7 @@ int DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, bool A
             }
 
                 /* copy values to write to our async I/O buffer */
-            A_MEMCPY(pIOPacket->pBuffer,GMboxIntControl,sizeof(GMboxIntControl));
+            memcpy(pIOPacket->pBuffer,GMboxIntControl,sizeof(GMboxIntControl));
 
                 /* stick in our completion routine when the I/O operation completes */
             pIOPacket->Completion = DevGMboxIRQActionAsyncHandler;
@@ -667,7 +667,7 @@ int DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, u8 *pLookAheadBuffer, int *pLoo
         
         if (procRegs.gmbox_rx_avail > 0) {
             int bytes = procRegs.gmbox_rx_avail > maxCopy ? maxCopy : procRegs.gmbox_rx_avail;
-            A_MEMCPY(pLookAheadBuffer,&procRegs.rx_gmbox_lookahead_alias[0],bytes);
+            memcpy(pLookAheadBuffer,&procRegs.rx_gmbox_lookahead_alias[0],bytes);
             *pLookAheadBytes = bytes;
         }
         
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index cddb939..177f04d 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -961,7 +961,7 @@ HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_I
             break;    
         }
         
-        A_MEMCPY(&pProtocol->HCIConfig, pInfo, sizeof(HCI_TRANSPORT_CONFIG_INFO));
+        memcpy(&pProtocol->HCIConfig, pInfo, sizeof(HCI_TRANSPORT_CONFIG_INFO));
         
         A_ASSERT(pProtocol->HCIConfig.pHCIPktRecv != NULL);
         A_ASSERT(pProtocol->HCIConfig.pHCISendComplete != NULL);
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index e7adc45..c200cfd 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -130,7 +130,7 @@ HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
         target->Device.MessagePendingCallback = HTCRecvMessagePendingHandler;
         target->EpWaitingForBuffers = ENDPOINT_MAX;
 
-        A_MEMCPY(&target->HTCInitInfo,pInfo,sizeof(HTC_INIT_INFO));
+        memcpy(&target->HTCInitInfo,pInfo,sizeof(HTC_INIT_INFO));
         
         ResetEndpointStates(target);
           
@@ -556,7 +556,7 @@ bool HTCGetEndpointStatistics(HTC_HANDLE               HTCHandle,
     if (sample) {
         A_ASSERT(pStats != NULL);
             /* return the stats to the caller */
-        A_MEMCPY(pStats, &target->EndPoint[Endpoint].EndPointStats, sizeof(HTC_ENDPOINT_STATS));
+        memcpy(pStats, &target->EndPoint[Endpoint].EndPointStats, sizeof(HTC_ENDPOINT_STATS));
     }
 
     if (clearStats) {
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index 3445475..daa6efc 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -346,7 +346,7 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
             }
 
 #ifdef HTC_CAPTURE_LAST_FRAME
-            A_MEMCPY(target->LastTrailer, (pBuf + HTC_HDR_LENGTH + payloadLen - temp), temp);
+            memcpy(target->LastTrailer, (pBuf + HTC_HDR_LENGTH + payloadLen - temp), temp);
             target->LastTrailerLength = temp;
 #endif
                 /* trim length by trailer bytes */
@@ -372,7 +372,7 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
 #endif
     } else {
 #ifdef HTC_CAPTURE_LAST_FRAME
-        A_MEMCPY(&target->LastFrameHdr,pBuf,sizeof(HTC_FRAME_HDR));
+        memcpy(&target->LastFrameHdr,pBuf,sizeof(HTC_FRAME_HDR));
 #endif
         if (AR_DEBUG_LVL_CHECK(ATH_DEBUG_RECV)) {
             if (pPacket->ActualLength > 0) {
@@ -1155,7 +1155,7 @@ int HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLook
     }
         
         /* on first entry copy the lookaheads into our temp array for processing */
-    A_MEMCPY(lookAheads, MsgLookAheads, (sizeof(u32)) * NumLookAheads);
+    memcpy(lookAheads, MsgLookAheads, (sizeof(u32)) * NumLookAheads);
             
     while (true) {
         
diff --git a/drivers/staging/ath6kl/htc2/htc_services.c b/drivers/staging/ath6kl/htc2/htc_services.c
index 9ddf32c..61a332e 100644
--- a/drivers/staging/ath6kl/htc2/htc_services.c
+++ b/drivers/staging/ath6kl/htc2/htc_services.c
@@ -83,7 +83,7 @@ int HTCSendSetupComplete(HTC_TARGET *target)
                 setupFlags |= HTC_SETUP_COMPLETE_FLAGS_ENABLE_BUNDLE_RECV; 
                 pSetupCompleteEx->MaxMsgsPerBundledRecv = target->MaxMsgPerBundle;
             }    
-            A_MEMCPY(&pSetupCompleteEx->SetupFlags, &setupFlags, sizeof(pSetupCompleteEx->SetupFlags));            
+            memcpy(&pSetupCompleteEx->SetupFlags, &setupFlags, sizeof(pSetupCompleteEx->SetupFlags));            
             SET_HTC_PACKET_INFO_TX(pSendPacket,
                                    NULL,
                                    (u8 *)pSetupCompleteEx,
@@ -166,7 +166,7 @@ int HTCConnectService(HTC_HANDLE               HTCHandle,
             if ((pConnectReq->pMetaData != NULL) &&
                 (pConnectReq->MetaDataLength <= HTC_SERVICE_META_DATA_MAX_LENGTH)) {
                     /* copy meta data into message buffer (after header ) */
-                A_MEMCPY((u8 *)pConnectMsg + sizeof(HTC_CONNECT_SERVICE_MSG),
+                memcpy((u8 *)pConnectMsg + sizeof(HTC_CONNECT_SERVICE_MSG),
                          pConnectReq->pMetaData,
                          pConnectReq->MetaDataLength);
                 pConnectMsg->ServiceMetaLength = pConnectReq->MetaDataLength;
@@ -224,7 +224,7 @@ int HTCConnectService(HTC_HANDLE               HTCHandle,
                     /* caller supplied a buffer and the target responded with data */
                 int copyLength = min((int)pConnectResp->BufferLength, (int)pResponseMsg->ServiceMetaLength);
                     /* copy the meta data */
-                A_MEMCPY(pConnectResp->pMetaData,
+                memcpy(pConnectResp->pMetaData,
                          ((u8 *)pResponseMsg) + sizeof(HTC_CONNECT_SERVICE_RESPONSE_MSG),
                          copyLength);
                 pConnectResp->ActualLength = copyLength;
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
index 29873ac..005b3ba 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
@@ -153,7 +153,7 @@ int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
         opCodeBytes[1] = pHCICommand[HCI_CMD_OPCODE_BYTE_HI_OFFSET];
         
             /* copy HCI command */
-        A_MEMCPY(pBuffer + pConfig->pHCIProps->HeadRoom,pHCICommand,CmdLength);         
+        memcpy(pBuffer + pConfig->pHCIProps->HeadRoom,pHCICommand,CmdLength);         
             /* send command */
         status = SendHCICommand(pConfig,
                                 pBuffer + pConfig->pHCIProps->HeadRoom,
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 2148381..2111e99 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2280,7 +2280,7 @@ ar6000_init_control_info(AR_SOFTC_T *ar)
         ar->ap_profile_flag = 0;
         A_NETBUF_QUEUE_INIT(&ar->mcastpsq);
 
-        A_MEMCPY(ar->ap_country_code, DEF_AP_COUNTRY_CODE, 3);
+        memcpy(ar->ap_country_code, DEF_AP_COUNTRY_CODE, 3);
         ar->ap_wmode = DEF_AP_WMODE_G;
         ar->ap_dtim_period = DEF_AP_DTIM;
         ar->ap_beacon_interval = DEF_BEACON_INTERVAL;
@@ -2875,7 +2875,7 @@ ar6000_channelList_rx(void *devt, s8 numChan, u16 *chanList)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)devt;
 
-    A_MEMCPY(ar->arChannelList, chanList, numChan * sizeof (u16));
+    memcpy(ar->arChannelList, chanList, numChan * sizeof (u16));
     ar->arNumChannels = numChan;
 
     wake_up(&arEvent);
@@ -2914,7 +2914,7 @@ u8 ar6000_ibss_map_epid(struct sk_buff *skb, struct net_device *dev, u32 *mapNo)
         A_ASSERT(ar->arNodeNum <= MAX_NODE_NUM);
     }
 
-    A_MEMCPY(ar->arNodeMap[eptMap].macAddress, macHdr->dstMac, IEEE80211_ADDR_LEN);
+    memcpy(ar->arNodeMap[eptMap].macAddress, macHdr->dstMac, IEEE80211_ADDR_LEN);
 
     for (i = ENDPOINT_2; i <= ENDPOINT_5; i ++) {
         if (!ar->arTxPending[i]) {
@@ -3118,7 +3118,7 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
                     break;
                 }
                 A_NETBUF_PUT(newbuf, len);
-                A_MEMCPY(A_NETBUF_DATA(newbuf), A_NETBUF_DATA(skb), len);
+                memcpy(A_NETBUF_DATA(newbuf), A_NETBUF_DATA(skb), len);
                 A_NETBUF_FREE(skb);
                 skb = newbuf;
                 /* fall through and assemble header */
@@ -4239,7 +4239,7 @@ ar6000_ready_event(void *devt, u8 *datap, u8 phyCap, u32 sw_ver, u32 abi_ver)
     AR_SOFTC_T *ar = (AR_SOFTC_T *)devt;
     struct net_device *dev = ar->arNetDev;
 
-    A_MEMCPY(dev->dev_addr, datap, AR6000_ETH_ADDR_LEN);
+    memcpy(dev->dev_addr, datap, AR6000_ETH_ADDR_LEN);
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("mac address = %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x\n",
         dev->dev_addr[0], dev->dev_addr[1],
         dev->dev_addr[2], dev->dev_addr[3],
@@ -4260,8 +4260,8 @@ add_new_sta(AR_SOFTC_T *ar, u8 *mac, u16 aid, u8 *wpaie,
 {
     u8 free_slot=aid-1;
 
-        A_MEMCPY(ar->sta_list[free_slot].mac, mac, ATH_MAC_LEN);
-        A_MEMCPY(ar->sta_list[free_slot].wpa_ie, wpaie, ielen);
+        memcpy(ar->sta_list[free_slot].mac, mac, ATH_MAC_LEN);
+        memcpy(ar->sta_list[free_slot].wpa_ie, wpaie, ielen);
         ar->sta_list[free_slot].aid = aid;
         ar->sta_list[free_slot].keymgmt = keymgmt;
         ar->sta_list[free_slot].ucipher = ucipher;
@@ -4383,7 +4383,7 @@ skip_key:
 
         /* Send event to application */
         A_MEMZERO(&wrqu, sizeof(wrqu));
-        A_MEMCPY(wrqu.addr.sa_data, bssid, ATH_MAC_LEN);
+        memcpy(wrqu.addr.sa_data, bssid, ATH_MAC_LEN);
         wireless_send_event(ar->arNetDev, IWEVREGISTERED, &wrqu, NULL);
         /* In case the queue is stopped when we switch modes, this will
          * wake it up
@@ -4400,7 +4400,7 @@ skip_key:
                                 assocInfo);
 #endif /* ATH6K_CONFIG_CFG80211 */
 
-    A_MEMCPY(ar->arBssid, bssid, sizeof(ar->arBssid));
+    memcpy(ar->arBssid, bssid, sizeof(ar->arBssid));
     ar->arBssChannel = channel;
 
     A_PRINTF("AR6000 connected event on freq %d ", channel);
@@ -4543,7 +4543,7 @@ skip_key:
     reconnect_flag = 0;
 
     A_MEMZERO(&wrqu, sizeof(wrqu));
-    A_MEMCPY(wrqu.addr.sa_data, bssid, IEEE80211_ADDR_LEN);
+    memcpy(wrqu.addr.sa_data, bssid, IEEE80211_ADDR_LEN);
     wrqu.addr.sa_family = ARPHRD_ETHER;
     wireless_send_event(ar->arNetDev, SIOCGIWAP, &wrqu, NULL);
     if ((ar->arNetworkType == ADHOC_NETWORK) && ar->arIbssPsEnable) {
@@ -4653,7 +4653,7 @@ ar6000_disconnect_event(AR_SOFTC_T *ar, u8 reason, u8 *bssid,
         if(!IS_MAC_BCAST(bssid)) {
             /* Send event to application */
             A_MEMZERO(&wrqu, sizeof(wrqu));
-            A_MEMCPY(wrqu.addr.sa_data, bssid, ATH_MAC_LEN);
+            memcpy(wrqu.addr.sa_data, bssid, ATH_MAC_LEN);
             wireless_send_event(ar->arNetDev, IWEVEXPIRED, &wrqu, NULL);
         }
 
@@ -4826,7 +4826,7 @@ ar6000_hci_event_rcv_evt(struct ar6_softc *ar, WMI_HCI_EVENT *cmd)
      */
     *((short *)buf) = WMI_HCI_EVENT_EVENTID;
     buf += sizeof(int);
-    A_MEMCPY(buf, cmd->buf, cmd->evt_buf_sz);
+    memcpy(buf, cmd->buf, cmd->evt_buf_sz);
 
     if(ar6k_pal_config_g.fpar6k_pal_recv_pkt)
     {
@@ -4880,7 +4880,7 @@ ar6000_neighborReport_event(AR_SOFTC_T *ar, int numAps, WMI_NEIGHBOR_INFO *info)
         A_MEMZERO(pmkcand, sizeof(struct iw_pmkid_cand));
         pmkcand->index = i;
         pmkcand->flags = info->bssFlags;
-        A_MEMCPY(pmkcand->bssid.sa_data, info->bssid, ATH_MAC_LEN);
+        memcpy(pmkcand->bssid.sa_data, info->bssid, ATH_MAC_LEN);
         wrqu.data.length = sizeof(struct iw_pmkid_cand);
         wireless_send_event(ar->arNetDev, IWEVPMKIDCAND, &wrqu, (char *)pmkcand);
         A_FREE(pmkcand);
@@ -5302,9 +5302,9 @@ ar6000_bssInfo_event_rx(AR_SOFTC_T *ar, u8 *datap, int len)
     if ((skb = A_NETBUF_ALLOC_RAW(len)) != NULL) {
 
         A_NETBUF_PUT(skb, len);
-        A_MEMCPY(A_NETBUF_DATA(skb), datap, len);
+        memcpy(A_NETBUF_DATA(skb), datap, len);
         skb->dev = ar->arNetDev;
-        A_MEMCPY(skb_mac_header(skb), A_NETBUF_DATA(skb), 6);
+        memcpy(skb_mac_header(skb), A_NETBUF_DATA(skb), 6);
         skb->ip_summed = CHECKSUM_NONE;
         skb->pkt_type = PACKET_OTHERHOST;
         skb->protocol = __constant_htons(0x0019);
@@ -5468,19 +5468,19 @@ ar6000_btcoex_config_event(struct ar6_softc *ar,  u8 *ptr, u32 len)
 
     switch (pBtcoexConfig->btProfileType) {
         case WMI_BTCOEX_BT_PROFILE_SCO:
-            A_MEMCPY(&pArbtcoexConfig->info.scoConfigCmd, &pBtcoexConfig->info.scoConfigCmd,
+            memcpy(&pArbtcoexConfig->info.scoConfigCmd, &pBtcoexConfig->info.scoConfigCmd,
                                         sizeof(WMI_SET_BTCOEX_SCO_CONFIG_CMD));
             break;
         case WMI_BTCOEX_BT_PROFILE_A2DP:
-            A_MEMCPY(&pArbtcoexConfig->info.a2dpConfigCmd, &pBtcoexConfig->info.a2dpConfigCmd,
+            memcpy(&pArbtcoexConfig->info.a2dpConfigCmd, &pBtcoexConfig->info.a2dpConfigCmd,
                                         sizeof(WMI_SET_BTCOEX_A2DP_CONFIG_CMD));
             break;
         case WMI_BTCOEX_BT_PROFILE_ACLCOEX:
-            A_MEMCPY(&pArbtcoexConfig->info.aclcoexConfig, &pBtcoexConfig->info.aclcoexConfig,
+            memcpy(&pArbtcoexConfig->info.aclcoexConfig, &pBtcoexConfig->info.aclcoexConfig,
                                         sizeof(WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD));
             break;
         case WMI_BTCOEX_BT_PROFILE_INQUIRY_PAGE:
-           A_MEMCPY(&pArbtcoexConfig->info.btinquiryPageConfigCmd, &pBtcoexConfig->info.btinquiryPageConfigCmd,
+           memcpy(&pArbtcoexConfig->info.btinquiryPageConfigCmd, &pBtcoexConfig->info.btinquiryPageConfigCmd,
                                         sizeof(WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD));
             break;
     }
@@ -5497,7 +5497,7 @@ ar6000_btcoex_stats_event(struct ar6_softc *ar,  u8 *ptr, u32 len)
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("AR6000 BTCOEX CONFIG EVENT \n"));
 
-    A_MEMCPY(&ar->arBtcoexStats, pBtcoexStats, sizeof(WMI_BTCOEX_STATS_EVENT));
+    memcpy(&ar->arBtcoexStats, pBtcoexStats, sizeof(WMI_BTCOEX_STATS_EVENT));
 
     if (ar->statsUpdatePending) {
          ar->statsUpdatePending = false;
@@ -5596,8 +5596,8 @@ void ar6000_send_event_to_app(AR_SOFTC_T *ar, u16 eventId,
     }
 
     A_MEMZERO(buf, size);
-    A_MEMCPY(buf, &eventId, EVENT_ID_LEN);
-    A_MEMCPY(buf+EVENT_ID_LEN, datap, len);
+    memcpy(buf, &eventId, EVENT_ID_LEN);
+    memcpy(buf+EVENT_ID_LEN, datap, len);
 
     //AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("event ID = %d,len = %d\n",*(u16 *)buf, size));
     A_MEMZERO(&wrqu, sizeof(wrqu));
@@ -5641,8 +5641,8 @@ void ar6000_send_generic_event_to_app(AR_SOFTC_T *ar, u16 eventId,
     }
 
     A_MEMZERO(buf, size);
-    A_MEMCPY(buf, &eventId, EVENT_ID_LEN);
-    A_MEMCPY(buf+EVENT_ID_LEN, datap, len);
+    memcpy(buf, &eventId, EVENT_ID_LEN);
+    memcpy(buf+EVENT_ID_LEN, datap, len);
 
     A_MEMZERO(&wrqu, sizeof(wrqu));
     wrqu.data.length = size;
@@ -5989,7 +5989,7 @@ void ap_wapi_rekey_event(AR_SOFTC_T *ar, u8 type, u8 *mac)
 
     strcpy(buf, "WAPI_REKEY");
     buf[10] = type;
-    A_MEMCPY(&buf[11], mac, ATH_MAC_LEN);
+    memcpy(&buf[11], mac, ATH_MAC_LEN);
 
     A_MEMZERO(&wrqu, sizeof(wrqu));
     wrqu.data.length = 10+1+ATH_MAC_LEN;
@@ -6121,7 +6121,7 @@ ar6000_ap_mode_profile_commit(struct ar6_softc *ar)
 
     A_MEMZERO(&p,sizeof(p));
     p.ssidLength = ar->arSsidLen;
-    A_MEMCPY(p.ssid,ar->arSsid,p.ssidLength);
+    memcpy(p.ssid,ar->arSsid,p.ssidLength);
     p.channel = ar->arChannelHint;
     p.networkType = ar->arNetworkType;
 
@@ -6238,7 +6238,7 @@ ar6000_ap_mode_get_wpa_ie(struct ar6_softc *ar, struct ieee80211req_wpaie *wpaie
     A_MEMZERO(wpaie->rsn_ie, IEEE80211_MAX_IE);
 
     if(conn) {
-        A_MEMCPY(wpaie->wpa_ie, conn->wpa_ie, IEEE80211_MAX_IE);
+        memcpy(wpaie->wpa_ie, conn->wpa_ie, IEEE80211_MAX_IE);
     }
 
     return 0;
@@ -6453,7 +6453,7 @@ int ar6000_create_ap_interface(AR_SOFTC_T *ar, char *ap_ifname)
     arApNetDev = dev;
 
     /* Copy the MAC address */
-    A_MEMCPY(dev->dev_addr, ar->arNetDev->dev_addr, AR6000_ETH_ADDR_LEN);
+    memcpy(dev->dev_addr, ar->arNetDev->dev_addr, AR6000_ETH_ADDR_LEN);
 
     return 0;
 }
diff --git a/drivers/staging/ath6kl/os/linux/ar6k_pal.c b/drivers/staging/ath6kl/os/linux/ar6k_pal.c
index 831b2e3..fee7cb9 100644
--- a/drivers/staging/ath6kl/os/linux/ar6k_pal.c
+++ b/drivers/staging/ath6kl/os/linux/ar6k_pal.c
@@ -215,7 +215,7 @@ static int btpal_send_frame(struct sk_buff *skb)
 			bt_cb(txSkb)->pkt_type = bt_cb(skb)->pkt_type;
 			txSkb->dev = (void *)pHciPalInfo->hdev;
 			skb_reserve(txSkb, TX_PACKET_RSV_OFFSET + WMI_MAX_TX_META_SZ + sizeof(WMI_DATA_HDR));
-			A_MEMCPY(txSkb->data, skb->data, skb->len);
+			memcpy(txSkb->data, skb->data, skb->len);
 			skb_put(txSkb,skb->len);
 			/* Add WMI packet type */
 			osbuf = (void *)txSkb;
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 20b08c0..415b253 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -324,7 +324,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
     A_MEMZERO(ar->arSsid, sizeof(ar->arSsid));
     ar->arSsidLen = sme->ssid_len;
-    A_MEMCPY(ar->arSsid, sme->ssid, sme->ssid_len);
+    memcpy(ar->arSsid, sme->ssid, sme->ssid_len);
 
     if(sme->channel){
         ar->arChannelHint = sme->channel->center_freq;
@@ -333,7 +333,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
     A_MEMZERO(ar->arReqBssid, sizeof(ar->arReqBssid));
     if(sme->bssid){
         if(A_MEMCMP(&sme->bssid, bcast_mac, AR6000_ETH_ADDR_LEN)) {
-            A_MEMCPY(ar->arReqBssid, sme->bssid, sizeof(ar->arReqBssid));
+            memcpy(ar->arReqBssid, sme->bssid, sizeof(ar->arReqBssid));
         }
     }
 
@@ -365,7 +365,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
         key = &ar->keys[sme->key_idx];
         key->key_len = sme->key_len;
-        A_MEMCPY(key->key, sme->key, key->key_len);
+        memcpy(key->key, sme->key, key->key_len);
         key->cipher = ar->arPairwiseCrypto;
         ar->arDefTxKeyIndex = sme->key_idx;
 
@@ -493,7 +493,7 @@ ar6k_cfg80211_connect_event(AR_SOFTC_T *ar, u16 channel,
             if(ptr_ie_buf) {
                 *ptr_ie_buf++ = WLAN_EID_SSID;
                 *ptr_ie_buf++ = ar->arSsidLen;
-                A_MEMCPY(ptr_ie_buf, ar->arSsid, ar->arSsidLen);
+                memcpy(ptr_ie_buf, ar->arSsid, ar->arSsidLen);
                 ptr_ie_buf +=ar->arSsidLen;
 
                 *ptr_ie_buf++ = WLAN_EID_IBSS_PARAMS;
@@ -511,11 +511,11 @@ ar6k_cfg80211_connect_event(AR_SOFTC_T *ar, u16 channel,
             if(WEP_CRYPT == ar->arPairwiseCrypto) {
                 capability |= IEEE80211_CAPINFO_PRIVACY;
             }
-            A_MEMCPY(source_mac, ar->arNetDev->dev_addr, ATH_MAC_LEN);
+            memcpy(source_mac, ar->arNetDev->dev_addr, ATH_MAC_LEN);
             ptr_ie_buf = ie_buf;
         } else {
             capability = *(u16 *)(&assocInfo[beaconIeLen]);
-            A_MEMCPY(source_mac, bssid, ATH_MAC_LEN);
+            memcpy(source_mac, bssid, ATH_MAC_LEN);
             ptr_ie_buf = assocReqIe;
             ie_buf_len = assocReqLen;
         }
@@ -534,12 +534,12 @@ ar6k_cfg80211_connect_event(AR_SOFTC_T *ar, u16 channel,
         A_MEMZERO(ieeemgmtbuf, size);
         mgmt = (struct ieee80211_mgmt *)ieeemgmtbuf;
         mgmt->frame_control = (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
-        A_MEMCPY(mgmt->da, bcast_mac, ATH_MAC_LEN);
-        A_MEMCPY(mgmt->sa, source_mac, ATH_MAC_LEN);
-        A_MEMCPY(mgmt->bssid, bssid, ATH_MAC_LEN);
+        memcpy(mgmt->da, bcast_mac, ATH_MAC_LEN);
+        memcpy(mgmt->sa, source_mac, ATH_MAC_LEN);
+        memcpy(mgmt->bssid, bssid, ATH_MAC_LEN);
         mgmt->u.beacon.beacon_int = beaconInterval;
         mgmt->u.beacon.capab_info = capability;
-        A_MEMCPY(mgmt->u.beacon.variable, ptr_ie_buf, ie_buf_len);
+        memcpy(mgmt->u.beacon.variable, ptr_ie_buf, ie_buf_len);
 
         ibss_channel = ieee80211_get_channel(ar->wdev->wiphy, (int)channel);
 
@@ -712,10 +712,10 @@ ar6k_cfg80211_scan_node(void *arg, bss_t *ni)
        cfg80211 needs it, for time being just filling the da, sa and bssid fields alone.
     */
     mgmt = (struct ieee80211_mgmt *)ieeemgmtbuf;
-    A_MEMCPY(mgmt->da, bcast_mac, ATH_MAC_LEN);
-    A_MEMCPY(mgmt->sa, ni->ni_macaddr, ATH_MAC_LEN);
-    A_MEMCPY(mgmt->bssid, ni->ni_macaddr, ATH_MAC_LEN);
-    A_MEMCPY(ieeemgmtbuf + offsetof(struct ieee80211_mgmt, u),
+    memcpy(mgmt->da, bcast_mac, ATH_MAC_LEN);
+    memcpy(mgmt->sa, ni->ni_macaddr, ATH_MAC_LEN);
+    memcpy(mgmt->bssid, ni->ni_macaddr, ATH_MAC_LEN);
+    memcpy(ieeemgmtbuf + offsetof(struct ieee80211_mgmt, u),
              ni->ni_buf, ni->ni_framelen);
 
     freq    = cie->ie_chan;
@@ -862,9 +862,9 @@ ar6k_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
             return -EINVAL;
 
         key->key_len = params->key_len;
-        A_MEMCPY(key->key, params->key, key->key_len);
+        memcpy(key->key, params->key, key->key_len);
         key->seq_len = params->seq_len;
-        A_MEMCPY(key->seq, params->seq, key->seq_len);
+        memcpy(key->seq, params->seq, key->seq_len);
         key->cipher = params->cipher;
     }
 
@@ -1307,7 +1307,7 @@ ar6k_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
     }
 
     ar->arSsidLen = ibss_param->ssid_len;
-    A_MEMCPY(ar->arSsid, ibss_param->ssid, ar->arSsidLen);
+    memcpy(ar->arSsid, ibss_param->ssid, ar->arSsidLen);
 
     if(ibss_param->channel) {
         ar->arChannelHint = ibss_param->channel->center_freq;
@@ -1322,7 +1322,7 @@ ar6k_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
     A_MEMZERO(ar->arReqBssid, sizeof(ar->arReqBssid));
     if(ibss_param->bssid) {
         if(A_MEMCMP(&ibss_param->bssid, bcast_mac, AR6000_ETH_ADDR_LEN)) {
-            A_MEMCPY(ar->arReqBssid, ibss_param->bssid, sizeof(ar->arReqBssid));
+            memcpy(ar->arReqBssid, ibss_param->bssid, sizeof(ar->arReqBssid));
         }
     }
 
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index f170382..db38bbf 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -226,7 +226,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
     
     pHcidevInfo->pHCIDev = HCIHandle;
     
-    A_MEMCPY(&pHcidevInfo->HCIProps,pProps,sizeof(*pProps));
+    memcpy(&pHcidevInfo->HCIProps,pProps,sizeof(*pProps));
     
     AR_DEBUG_PRINTF(ATH_DEBUG_HCI_BRIDGE,("HCI ready (hci:0x%lX, headroom:%d, tailroom:%d blockpad:%d) \n", 
             (unsigned long)HCIHandle, 
@@ -778,7 +778,7 @@ static int bt_send_frame(struct sk_buff *skb)
         bt_cb(txSkb)->pkt_type = bt_cb(skb)->pkt_type;
         txSkb->dev = (void *)pHcidevInfo->pBtStackHCIDev;
         skb_reserve(txSkb, TX_PACKET_RSV_OFFSET + pHcidevInfo->HCIProps.HeadRoom);
-        A_MEMCPY(txSkb->data, skb->data, skb->len);
+        memcpy(txSkb->data, skb->data, skb->len);
         skb_put(txSkb,skb->len);
         
         pPacket = AllocHTCStruct(pHcidevInfo);        
diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index 1957de0..cdb4195 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -76,7 +76,6 @@
 #define A_CPU2BE16(x)      htons(x)
 #define A_CPU2BE32(x)      htonl(x)
 
-#define A_MEMCPY(dst, src, len)         memcpy((u8 *)(dst), (src), (len))
 #define A_MEMZERO(addr, len)            memset(addr, 0, len)
 #define A_MEMCMP(addr1, addr2, len)     memcmp((addr1), (addr2), (len))
 #define A_MALLOC(size)                  kmalloc((size), GFP_KERNEL)
@@ -364,7 +363,6 @@ static inline void *A_ALIGN_TO_CACHE_LINE(void *ptr) {
 #define PREPACK
 #define POSTPACK                __ATTRIB_PACK
 
-#define A_MEMCPY(dst, src, len)         memcpy((dst), (src), (len))
 #define A_MEMZERO(addr, len)            memset((addr), 0, (len))
 #define A_MEMCMP(addr1, addr2, len)     memcmp((addr1), (addr2), (len))
 #define A_MALLOC(size)                  malloc(size)
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index 4f30b25..9a7f920 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -281,7 +281,7 @@ ar6000_ioctl_set_country(struct net_device *dev, struct ifreq *rq)
     ar->ap_profile_flag = 1; /* There is a change in profile */
 
     ret = wmi_set_country(ar->arWmi, cmd.countryCode);
-    A_MEMCPY(ar->ap_country_code, cmd.countryCode, 3);
+    memcpy(ar->ap_country_code, cmd.countryCode, 3);
 
     switch (ret) {
         case 0:
@@ -430,7 +430,7 @@ ar6000_ioctl_set_rssi_threshold(struct net_device *dev, struct ifreq *rq)
     cmd.weight = rssiParams.weight;
     cmd.pollTime = rssiParams.pollTime;
 
-    A_MEMCPY(ar->rssi_map, &rssiParams.tholds, sizeof(ar->rssi_map));
+    memcpy(ar->rssi_map, &rssiParams.tholds, sizeof(ar->rssi_map));
     /*
      *  only 6 elements, so use bubble sorting, in ascending order
      */
@@ -702,8 +702,8 @@ ar6000_ioctl_tcmd_get_rx_report(struct net_device *dev,
     buf[1] = ar->tcmdRxRssi;
     buf[2] = ar->tcmdRxcrcErrPkt;
     buf[3] = ar->tcmdRxsecErrPkt;
-    A_MEMCPY(((A_UCHAR *)buf)+(4*sizeof(u32)), ar->tcmdRateCnt, sizeof(ar->tcmdRateCnt));
-    A_MEMCPY(((A_UCHAR *)buf)+(4*sizeof(u32))+(TCMD_MAX_RATES *sizeof(u16)), ar->tcmdRateCntShortGuard, sizeof(ar->tcmdRateCntShortGuard));
+    memcpy(((A_UCHAR *)buf)+(4*sizeof(u32)), ar->tcmdRateCnt, sizeof(ar->tcmdRateCnt));
+    memcpy(((A_UCHAR *)buf)+(4*sizeof(u32))+(TCMD_MAX_RATES *sizeof(u16)), ar->tcmdRateCntShortGuard, sizeof(ar->tcmdRateCntShortGuard));
 
     if (!ret && copy_to_user(rq->ifr_data, buf, sizeof(buf))) {
         ret = -EFAULT;
@@ -732,8 +732,8 @@ ar6000_tcmd_rx_report_event(void *devt, u8 *results, int len)
     ar->tcmdRxReport = 1;
     A_MEMZERO(ar->tcmdRateCnt,  sizeof(ar->tcmdRateCnt));
     A_MEMZERO(ar->tcmdRateCntShortGuard,  sizeof(ar->tcmdRateCntShortGuard));
-    A_MEMCPY(ar->tcmdRateCnt, rx_rep->u.report.rateCnt, sizeof(ar->tcmdRateCnt));
-    A_MEMCPY(ar->tcmdRateCntShortGuard, rx_rep->u.report.rateCntShortGuard, sizeof(ar->tcmdRateCntShortGuard));
+    memcpy(ar->tcmdRateCnt, rx_rep->u.report.rateCnt, sizeof(ar->tcmdRateCnt));
+    memcpy(ar->tcmdRateCntShortGuard, rx_rep->u.report.rateCntShortGuard, sizeof(ar->tcmdRateCntShortGuard));
 
     wake_up(&arEvent);
 }
@@ -1523,7 +1523,7 @@ ar6000_create_acl_data_osbuf(struct net_device *dev, u8 *userdata, void **p_osbu
 
         /* Real copy to osbuf */
         acl = (HCI_ACL_DATA_PKT *)(datap);
-        A_MEMCPY(acl, tmp_space, hdr_size);
+        memcpy(acl, tmp_space, hdr_size);
         if (a_copy_from_user(acl->data, userdata + hdr_size, acl->data_len)) {
             ret = A_EFAULT;
             break;
@@ -1770,7 +1770,7 @@ ar6000_ioctl_setkey(AR_SOFTC_T *ar, struct ieee80211req_key *ik)
          (0 == memcmp(ik->ik_macaddr, bcast_mac, IEEE80211_ADDR_LEN)) ) {
         keyUsage = GROUP_USAGE;
         if(ar->arNextMode == AP_NETWORK) {
-            A_MEMCPY(&ar->ap_mode_bkey, ik,
+            memcpy(&ar->ap_mode_bkey, ik,
                      sizeof(struct ieee80211req_key));
 #ifdef WAPI_ENABLE
             if(ar->arPairwiseCrypto == WAPI_CRYPT) {
@@ -1779,13 +1779,13 @@ ar6000_ioctl_setkey(AR_SOFTC_T *ar, struct ieee80211req_key *ik)
 #endif
         }
 #ifdef USER_KEYS
-        A_MEMCPY(&ar->user_saved_keys.bcast_ik, ik,
+        memcpy(&ar->user_saved_keys.bcast_ik, ik,
                  sizeof(struct ieee80211req_key));
 #endif
     } else {
         keyUsage = PAIRWISE_USAGE;
 #ifdef USER_KEYS
-        A_MEMCPY(&ar->user_saved_keys.ucast_ik, ik,
+        memcpy(&ar->user_saved_keys.ucast_ik, ik,
                  sizeof(struct ieee80211req_key));
 #endif
 #ifdef WAPI_ENABLE
@@ -1827,7 +1827,7 @@ ar6000_ioctl_setkey(AR_SOFTC_T *ar, struct ieee80211req_key *ik)
 
             A_MEMZERO(ar->arWepKeyList[index].arKey,
                             sizeof(ar->arWepKeyList[index].arKey));
-            A_MEMCPY(ar->arWepKeyList[index].arKey, ik->ik_keydata, ik->ik_keylen);
+            memcpy(ar->arWepKeyList[index].arKey, ik->ik_keydata, ik->ik_keylen);
             ar->arWepKeyList[index].arKeyLen = ik->ik_keylen;
 
             if(ik->ik_flags & IEEE80211_KEY_DEFAULT){
@@ -3133,7 +3133,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                 ret = -EFAULT;
             } else {
 
-                A_MEMCPY(ar->arReqBssid, adhocBssid.bssid, sizeof(ar->arReqBssid));
+                memcpy(ar->arReqBssid, adhocBssid.bssid, sizeof(ar->arReqBssid));
         }
             break;
         }
@@ -4114,7 +4114,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                 ap_get_sta_t temp;
                 A_MEMZERO(&temp, sizeof(temp));
                 for(i=0;i<AP_MAX_NUM_STA;i++) {
-                    A_MEMCPY(temp.sta[i].mac, ar->sta_list[i].mac, ATH_MAC_LEN);
+                    memcpy(temp.sta[i].mac, ar->sta_list[i].mac, ATH_MAC_LEN);
                     temp.sta[i].aid = ar->sta_list[i].aid;
                     temp.sta[i].keymgmt = ar->sta_list[i].keymgmt;
                     temp.sta[i].ucipher = ar->sta_list[i].ucipher;
@@ -4526,7 +4526,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
         case AR6000_XIOCTL_AP_GET_COUNTRY:
         {
             WMI_AP_SET_COUNTRY_CMD cty;
-            A_MEMCPY(cty.countryCode, ar->ap_country_code, 3);
+            memcpy(cty.countryCode, ar->ap_country_code, 3);
 
             if (ar->arWmiReady == false) {
                 ret = -EIO;
@@ -4743,7 +4743,7 @@ u8 acl_add_del_mac(WMI_AP_ACL *a, WMI_AP_ACL_MAC_CMD *acl)
         if((already_avail >= 0) || (free_slot == -1))
             return 0;
 
-        A_MEMCPY(a->acl_mac[free_slot], acl->mac, ATH_MAC_LEN);
+        memcpy(a->acl_mac[free_slot], acl->mac, ATH_MAC_LEN);
         a->index = a->index | (1 << free_slot);
         acl->index = free_slot;
         a->wildcard[free_slot] = acl->wildcard;
diff --git a/drivers/staging/ath6kl/os/linux/netbuf.c b/drivers/staging/ath6kl/os/linux/netbuf.c
index 0a41df0..63acedf 100644
--- a/drivers/staging/ath6kl/os/linux/netbuf.c
+++ b/drivers/staging/ath6kl/os/linux/netbuf.c
@@ -120,7 +120,7 @@ int
 a_netbuf_push_data(void *bufPtr, char *srcPtr, s32 len)
 {
     skb_push((struct sk_buff *) bufPtr, len);
-    A_MEMCPY(((struct sk_buff *)bufPtr)->data, srcPtr, len);
+    memcpy(((struct sk_buff *)bufPtr)->data, srcPtr, len);
 
     return 0;
 }
@@ -147,7 +147,7 @@ a_netbuf_put_data(void *bufPtr, char *srcPtr, s32 len)
     char *start = (char*)(((struct sk_buff *)bufPtr)->data +
         ((struct sk_buff *)bufPtr)->len);
     skb_put((struct sk_buff *)bufPtr, len);
-    A_MEMCPY(start, srcPtr, len);
+    memcpy(start, srcPtr, len);
 
     return 0;
 }
@@ -184,7 +184,7 @@ a_netbuf_trim_data(void *bufPtr, char *dstPtr, s32 len)
     char *start = (char*)(((struct sk_buff *)bufPtr)->data +
         (((struct sk_buff *)bufPtr)->len - len));
     
-    A_MEMCPY(dstPtr, start, len);
+    memcpy(dstPtr, start, len);
     skb_trim((struct sk_buff *)bufPtr, ((struct sk_buff *)bufPtr)->len - len);
 
     return 0;
@@ -217,7 +217,7 @@ a_netbuf_pull(void *bufPtr, s32 len)
 int
 a_netbuf_pull_data(void *bufPtr, char *dstPtr, s32 len)
 {
-    A_MEMCPY(dstPtr, ((struct sk_buff *)bufPtr)->data, len);
+    memcpy(dstPtr, ((struct sk_buff *)bufPtr)->data, len);
     skb_pull((struct sk_buff *)bufPtr, len);
 
     return 0;
diff --git a/drivers/staging/ath6kl/os/linux/wireless_ext.c b/drivers/staging/ath6kl/os/linux/wireless_ext.c
index baa8663..8262fde 100644
--- a/drivers/staging/ath6kl/os/linux/wireless_ext.c
+++ b/drivers/staging/ath6kl/os/linux/wireless_ext.c
@@ -112,7 +112,7 @@ ar6000_scan_node(void *arg, bss_t *ni)
         A_MEMZERO(&iwe, sizeof(iwe));
         iwe.cmd = SIOCGIWAP;
         iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-        A_MEMCPY(iwe.u.ap_addr.sa_data, ni->ni_macaddr, 6);
+        memcpy(iwe.u.ap_addr.sa_data, ni->ni_macaddr, 6);
         current_ev = IWE_STREAM_ADD_EVENT(param->info, current_ev, end_buf,
                                           &iwe, IW_EV_ADDR_LEN);
     }
@@ -506,7 +506,7 @@ ar6000_ioctl_siwessid(struct net_device *dev,
         /* SSID change for AP network - Will take effect on commit */
         if(A_MEMCMP(ar->arSsid,ssid,32) != 0) {
              ar->arSsidLen = data->length - 1;
-            A_MEMCPY(ar->arSsid, ssid, ar->arSsidLen);
+            memcpy(ar->arSsid, ssid, ar->arSsidLen);
             ar->ap_profile_flag = 1; /* There is a change in profile */
         }
         return 0;
@@ -641,7 +641,7 @@ ar6000_ioctl_siwessid(struct net_device *dev,
     }
 
     ar->arSsidLen = data->length - 1;
-    A_MEMCPY(ar->arSsid, ssid, ar->arSsidLen);
+    memcpy(ar->arSsid, ssid, ar->arSsidLen);
 
     if (ar6000_connect_to_ap(ar)!= 0) {
         up(&ar->arSem);
@@ -675,7 +675,7 @@ ar6000_ioctl_giwessid(struct net_device *dev,
 
     data->flags = 1;
     data->length = ar->arSsidLen;
-    A_MEMCPY(essid, ar->arSsid, ar->arSsidLen);
+    memcpy(essid, ar->arSsid, ar->arSsidLen);
 
     return 0;
 }
@@ -1080,7 +1080,7 @@ ar6000_ioctl_siwencode(struct net_device *dev,
 
             A_MEMZERO(ar->arWepKeyList[index].arKey,
                       sizeof(ar->arWepKeyList[index].arKey));
-            A_MEMCPY(ar->arWepKeyList[index].arKey, keybuf, erq->length);
+            memcpy(ar->arWepKeyList[index].arKey, keybuf, erq->length);
             ar->arWepKeyList[index].arKeyLen = erq->length;
             ar->arDot11AuthMode       = auth;
         } else {
@@ -1158,14 +1158,14 @@ ar6000_ioctl_giwencode(struct net_device *dev,
                 erq->length = wk->arKeyLen;
             }
             if (wk->arKeyLen) {
-                A_MEMCPY(key, wk->arKey, erq->length);
+                memcpy(key, wk->arKey, erq->length);
             }
         } else {
             erq->flags &= ~IW_ENCODE_DISABLED;
             if (ar->user_saved_keys.keyOk) {
                 erq->length = ar->user_saved_keys.ucast_ik.ik_keylen;
                 if (erq->length) {
-                    A_MEMCPY(key, ar->user_saved_keys.ucast_ik.ik_keydata, erq->length);
+                    memcpy(key, ar->user_saved_keys.ucast_ik.ik_keydata, erq->length);
                 }
             } else {
                 erq->length = 1;    // not really printing any key but let iwconfig know enc is on
@@ -1616,7 +1616,7 @@ static int ar6000_set_wapi_key(struct net_device *dev,
     }
     keyData = (u8 *)(ext + 1);
     keyLen = erq->length - sizeof(struct iw_encode_ext);
-    A_MEMCPY(wapiKeyRsc, ext->tx_seq, sizeof(wapiKeyRsc));
+    memcpy(wapiKeyRsc, ext->tx_seq, sizeof(wapiKeyRsc));
 
     if (A_MEMCMP(ext->addr.sa_data, broadcastMac, sizeof(broadcastMac)) == 0) {
         keyUsage |= GROUP_USAGE;
@@ -1737,7 +1737,7 @@ ar6000_ioctl_siwencodeext(struct net_device *dev,
                 if (!ar->arConnected) {
                     A_MEMZERO(ar->arWepKeyList[index].arKey,
                           sizeof(ar->arWepKeyList[index].arKey));
-                    A_MEMCPY(ar->arWepKeyList[index].arKey, keyData, keyLen);
+                    memcpy(ar->arWepKeyList[index].arKey, keyData, keyLen);
                     ar->arWepKeyList[index].arKeyLen = keyLen;
 
                     return 0;
@@ -1778,7 +1778,7 @@ ar6000_ioctl_siwencodeext(struct net_device *dev,
         }
 
         if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
-            A_MEMCPY(keyRsc, ext->rx_seq, sizeof(keyRsc));
+            memcpy(keyRsc, ext->rx_seq, sizeof(keyRsc));
         } else {
             A_MEMZERO(keyRsc, sizeof(keyRsc));
         }
@@ -2318,7 +2318,7 @@ ar6000_ioctl_siwap(struct net_device *dev,
     if (A_MEMCMP(&ap_addr->sa_data, bcast_mac, AR6000_ETH_ADDR_LEN) == 0) {
         A_MEMZERO(ar->arReqBssid, sizeof(ar->arReqBssid));
     } else {
-        A_MEMCPY(ar->arReqBssid, &ap_addr->sa_data,  sizeof(ar->arReqBssid));
+        memcpy(ar->arReqBssid, &ap_addr->sa_data,  sizeof(ar->arReqBssid));
     }
 
     return 0;
@@ -2344,7 +2344,7 @@ ar6000_ioctl_giwap(struct net_device *dev,
     }
 
     if (ar->arNetworkType == AP_NETWORK) {
-        A_MEMCPY(&ap_addr->sa_data, dev->dev_addr, ATH_MAC_LEN);
+        memcpy(&ap_addr->sa_data, dev->dev_addr, ATH_MAC_LEN);
         ap_addr->sa_family = ARPHRD_ETHER;
         return 0;
     }
@@ -2353,7 +2353,7 @@ ar6000_ioctl_giwap(struct net_device *dev,
         return -EINVAL;
     }
 
-    A_MEMCPY(&ap_addr->sa_data, ar->arBssid, sizeof(ar->arBssid));
+    memcpy(&ap_addr->sa_data, ar->arBssid, sizeof(ar->arBssid));
     ap_addr->sa_family = ARPHRD_ETHER;
 
     return 0;
diff --git a/drivers/staging/ath6kl/reorder/rcv_aggr.c b/drivers/staging/ath6kl/reorder/rcv_aggr.c
index 5cb4413..adb85eb 100644
--- a/drivers/staging/ath6kl/reorder/rcv_aggr.c
+++ b/drivers/staging/ath6kl/reorder/rcv_aggr.c
@@ -397,7 +397,7 @@ aggr_slice_amsdu(AGGR_INFO *p_aggr, RXTID *rxtid, void **osbuf)
             break;
         }
 
-        A_MEMCPY(A_NETBUF_DATA(new_buf), framep, frame_8023_len);
+        memcpy(A_NETBUF_DATA(new_buf), framep, frame_8023_len);
         A_NETBUF_PUT(new_buf, frame_8023_len);
         if (wmi_dot3_2_dix(new_buf) != 0) {
             A_PRINTF("dot3_2_dix err..\n");
diff --git a/drivers/staging/ath6kl/wlan/include/ieee80211.h b/drivers/staging/ath6kl/wlan/include/ieee80211.h
index 0b5441f..dfad19a 100644
--- a/drivers/staging/ath6kl/wlan/include/ieee80211.h
+++ b/drivers/staging/ath6kl/wlan/include/ieee80211.h
@@ -70,7 +70,7 @@
 #define IEEE80211_ADDR_EQ(addr1, addr2)     \
     (A_MEMCMP(addr1, addr2, IEEE80211_ADDR_LEN) == 0)
 
-#define IEEE80211_ADDR_COPY(dst,src)    A_MEMCPY(dst,src,IEEE80211_ADDR_LEN)
+#define IEEE80211_ADDR_COPY(dst,src)    memcpy(dst,src,IEEE80211_ADDR_LEN)
 
 #define IEEE80211_KEYBUF_SIZE 16
 #define IEEE80211_MICBUF_SIZE (8+8)  /* space for both tx and rx */
diff --git a/drivers/staging/ath6kl/wlan/src/wlan_node.c b/drivers/staging/ath6kl/wlan/src/wlan_node.c
index d61cb6e..c99a330 100644
--- a/drivers/staging/ath6kl/wlan/src/wlan_node.c
+++ b/drivers/staging/ath6kl/wlan/src/wlan_node.c
@@ -116,7 +116,7 @@ wlan_setup_node(struct ieee80211_node_table *nt, bss_t *ni,
     int hash;
     u32 timeoutValue = 0;
 
-    A_MEMCPY(ni->ni_macaddr, macaddr, IEEE80211_ADDR_LEN);
+    memcpy(ni->ni_macaddr, macaddr, IEEE80211_ADDR_LEN);
     hash = IEEE80211_NODE_HASH (macaddr);
     ieee80211_node_initref (ni);     /* mark referenced */
 
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index acbf6ed..bf9dd0b 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -422,8 +422,8 @@ wmi_dix_2_dot3(struct wmi_t *wmip, void *osbuf)
     /*
      * Save mac fields and length to be inserted later
      */
-    A_MEMCPY(macHdr.dstMac, datap, ATH_MAC_LEN);
-    A_MEMCPY(macHdr.srcMac, datap + ATH_MAC_LEN, ATH_MAC_LEN);
+    memcpy(macHdr.dstMac, datap, ATH_MAC_LEN);
+    memcpy(macHdr.srcMac, datap + ATH_MAC_LEN, ATH_MAC_LEN);
     macHdr.typeOrLen = A_CPU2BE16(A_NETBUF_LEN(osbuf) - sizeof(ATH_MAC_HDR) +
                                   sizeof(ATH_LLC_SNAP_HDR));
 
@@ -435,7 +435,7 @@ wmi_dix_2_dot3(struct wmi_t *wmip, void *osbuf)
     }
     datap = A_NETBUF_DATA(osbuf);
 
-    A_MEMCPY(datap, &macHdr, sizeof (ATH_MAC_HDR));
+    memcpy(datap, &macHdr, sizeof (ATH_MAC_HDR));
 
     llcHdr = (ATH_LLC_SNAP_HDR *)(datap + sizeof(ATH_MAC_HDR));
     llcHdr->dsap      = 0xAA;
@@ -484,7 +484,7 @@ int wmi_meta_add(struct wmi_t *wmip, void *osbuf, u8 *pVersion,void *pTxMetaS)
             		return A_NO_MEMORY;
         	}
          	pV2 = (WMI_TX_META_V2 *)A_NETBUF_DATA(osbuf);
-         	A_MEMCPY(pV2,(WMI_TX_META_V2 *)pTxMetaS,sizeof(WMI_TX_META_V2));
+         	memcpy(pV2,(WMI_TX_META_V2 *)pTxMetaS,sizeof(WMI_TX_META_V2));
 		return (0);
     		}
 #endif
@@ -654,8 +654,8 @@ wmi_dot11_hdr_add (struct wmi_t *wmip, void *osbuf, NETWORK_TYPE mode)
     /*
      * Save mac fields and length to be inserted later
      */
-    A_MEMCPY(macHdr.dstMac, datap, ATH_MAC_LEN);
-    A_MEMCPY(macHdr.srcMac, datap + ATH_MAC_LEN, ATH_MAC_LEN);
+    memcpy(macHdr.dstMac, datap, ATH_MAC_LEN);
+    memcpy(macHdr.srcMac, datap + ATH_MAC_LEN, ATH_MAC_LEN);
     macHdr.typeOrLen = A_CPU2BE16(A_NETBUF_LEN(osbuf) - sizeof(ATH_MAC_HDR) +
                                   sizeof(ATH_LLC_SNAP_HDR));
 
@@ -730,7 +730,7 @@ wmi_dot11_hdr_remove(struct wmi_t *wmip, void *osbuf)
     type = pwh->i_fc[0] & IEEE80211_FC0_TYPE_MASK;
     subtype = pwh->i_fc[0] & IEEE80211_FC0_SUBTYPE_MASK;
 
-    A_MEMCPY((u8 *)&wh, datap, sizeof(struct ieee80211_frame));
+    memcpy((u8 *)&wh, datap, sizeof(struct ieee80211_frame));
 
     /* strip off the 802.11 hdr*/
     if (subtype == IEEE80211_FC0_SUBTYPE_QOS) {
@@ -772,7 +772,7 @@ wmi_dot11_hdr_remove(struct wmi_t *wmip, void *osbuf)
     A_NETBUF_PUSH(osbuf, sizeof(ATH_MAC_HDR));
     datap = A_NETBUF_DATA(osbuf);
 
-    A_MEMCPY (datap, &macHdr, sizeof(ATH_MAC_HDR));
+    memcpy (datap, &macHdr, sizeof(ATH_MAC_HDR));
 
     return 0;
 }
@@ -791,7 +791,7 @@ wmi_dot3_2_dix(void *osbuf)
     A_ASSERT(osbuf != NULL);
     datap = A_NETBUF_DATA(osbuf);
 
-    A_MEMCPY(&macHdr, datap, sizeof(ATH_MAC_HDR));
+    memcpy(&macHdr, datap, sizeof(ATH_MAC_HDR));
     llcHdr = (ATH_LLC_SNAP_HDR *)(datap + sizeof(ATH_MAC_HDR));
     macHdr.typeOrLen = llcHdr->etherType;
 
@@ -801,7 +801,7 @@ wmi_dot3_2_dix(void *osbuf)
 
     datap = A_NETBUF_DATA(osbuf);
 
-    A_MEMCPY(datap, &macHdr, sizeof (ATH_MAC_HDR));
+    memcpy(datap, &macHdr, sizeof (ATH_MAC_HDR));
 
     return (0);
 }
@@ -999,7 +999,7 @@ wmi_control_rx(struct wmi_t *wmip, void *osbuf)
             */
             WMI_BSS_INFO_HDR2 bih2;
             WMI_BSS_INFO_HDR *bih;
-            A_MEMCPY(&bih2, datap, sizeof(WMI_BSS_INFO_HDR2));
+            memcpy(&bih2, datap, sizeof(WMI_BSS_INFO_HDR2));
 
             A_NETBUF_PUSH(osbuf, 4);
             datap = A_NETBUF_DATA(osbuf);
@@ -1011,7 +1011,7 @@ wmi_control_rx(struct wmi_t *wmip, void *osbuf)
             bih->snr = bih2.snr;
             bih->rssi = bih2.snr - 95;
             bih->ieMask = bih2.ieMask;
-            A_MEMCPY(bih->bssid, bih2.bssid, ATH_MAC_LEN);
+            memcpy(bih->bssid, bih2.bssid, ATH_MAC_LEN);
 
             status = wmi_bssInfo_event_rx(wmip, datap, len);
             A_WMI_SEND_GENERIC_EVENT_TO_APP(wmip->wmi_devt, id, datap, len);
@@ -1275,7 +1275,7 @@ wmi_connect_event_rx(struct wmi_t *wmip, u8 *datap, int len)
         ev->bssid[0], ev->bssid[1], ev->bssid[2],
         ev->bssid[3], ev->bssid[4], ev->bssid[5]));
 
-    A_MEMCPY(wmip->wmi_bssid, ev->bssid, ATH_MAC_LEN);
+    memcpy(wmip->wmi_bssid, ev->bssid, ATH_MAC_LEN);
 
     /* initialize pointer to start of assoc rsp IEs */
     pie = ev->assocInfo + ev->beaconIeLen + ev->assocReqLen +
@@ -1538,7 +1538,7 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, u8 *datap, int len)
 
         /* copy the first 14 bytes such as
          * time-stamp(8), beacon-interval(2), cap-info(2), ssid-id(1), ssid-len(1). */
-        A_MEMCPY(ni_buf, buf, SSID_IE_LEN_INDEX + 1);
+        memcpy(ni_buf, buf, SSID_IE_LEN_INDEX + 1);
 
         ni_buf[SSID_IE_LEN_INDEX] = cached_ssid_len;
         ni_buf += (SSID_IE_LEN_INDEX + 1);
@@ -1547,7 +1547,7 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, u8 *datap, int len)
         buf_len -= (SSID_IE_LEN_INDEX + 1);
 
         /* copy the cached ssid */
-        A_MEMCPY(ni_buf, cached_ssid_buf, cached_ssid_len);
+        memcpy(ni_buf, cached_ssid_buf, cached_ssid_len);
         ni_buf += cached_ssid_len;
 
         buf += beacon_ssid_len;
@@ -1557,10 +1557,10 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, u8 *datap, int len)
             buf_len -= (cached_ssid_len - beacon_ssid_len);
 
         /* now copy the rest of bytes */
-        A_MEMCPY(ni_buf, buf, buf_len);
+        memcpy(ni_buf, buf, buf_len);
     }
     else
-        A_MEMCPY(bss->ni_buf, buf, len);
+        memcpy(bss->ni_buf, buf, len);
 
     bss->ni_framelen = len;
     if (wlan_parse_beacon(bss->ni_buf, len, &bss->ni_cie) != 0) {
@@ -1614,7 +1614,7 @@ wmi_opt_frame_event_rx(struct wmi_t *wmip, u8 *datap, int len)
     bss->ni_snr        = bih->snr;
     bss->ni_cie.ie_chan = bih->channel;
     A_ASSERT(bss->ni_buf != NULL);
-    A_MEMCPY(bss->ni_buf, buf, len);
+    memcpy(bss->ni_buf, buf, len);
     wlan_setup_node(&wmip->wmi_scan_table, bss, bih->bssid);
 
     return 0;
@@ -2446,7 +2446,7 @@ wmi_connect_cmd(struct wmi_t *wmip, NETWORK_TYPE netType,
 
     if (ssidLength)
     {
-        A_MEMCPY(cc->ssid, ssid, ssidLength);
+        memcpy(cc->ssid, ssid, ssidLength);
     }
 
     cc->ssidLength          = ssidLength;
@@ -2461,7 +2461,7 @@ wmi_connect_cmd(struct wmi_t *wmip, NETWORK_TYPE netType,
     cc->ctrl_flags          = ctrl_flags;
 
     if (bssid != NULL) {
-        A_MEMCPY(cc->bssid, bssid, ATH_MAC_LEN);
+        memcpy(cc->bssid, bssid, ATH_MAC_LEN);
     }
 
     wmip->wmi_pair_crypto_type  = pairwiseCrypto;
@@ -2490,7 +2490,7 @@ wmi_reconnect_cmd(struct wmi_t *wmip, u8 *bssid, u16 channel)
     cc->channel = channel;
 
     if (bssid != NULL) {
-        A_MEMCPY(cc->bssid, bssid, ATH_MAC_LEN);
+        memcpy(cc->bssid, bssid, ATH_MAC_LEN);
     }
 
     return (wmi_cmd_send(wmip, osbuf, WMI_RECONNECT_CMDID, NO_SYNC_WMIFLAG));
@@ -2547,7 +2547,7 @@ wmi_startscan_cmd(struct wmi_t *wmip, WMI_SCAN_TYPE scanType,
     sc->forceScanInterval = forceScanInterval;
     sc->numChannels = numChan;
     if (numChan) {
-        A_MEMCPY(sc->channelList, channelList, numChan * sizeof(u16));
+        memcpy(sc->channelList, channelList, numChan * sizeof(u16));
     }
 
     return (wmi_cmd_send(wmip, osbuf, WMI_START_SCAN_CMDID, NO_SYNC_WMIFLAG));
@@ -2650,7 +2650,7 @@ wmi_probedSsid_cmd(struct wmi_t *wmip, u8 index, u8 flag,
     cmd->entryIndex = index;
     cmd->flag       = flag;
     cmd->ssidLength = ssidLength;
-    A_MEMCPY(cmd->ssid, ssid, ssidLength);
+    memcpy(cmd->ssid, ssid, ssidLength);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_PROBED_SSID_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -2720,7 +2720,7 @@ wmi_associnfo_cmd(struct wmi_t *wmip, u8 ieType,
     A_MEMZERO(cmd, cmdLen);
     cmd->ieType = ieType;
     cmd->bufferSize = ieLen;
-    A_MEMCPY(cmd->assocInfo, ieInfo, ieLen);
+    memcpy(cmd->assocInfo, ieInfo, ieLen);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_ASSOC_INFO_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -2880,18 +2880,18 @@ wmi_addKey_cmd(struct wmi_t *wmip, u8 keyIndex, CRYPTO_TYPE keyType,
     cmd->keyType  = keyType;
     cmd->keyUsage = keyUsage;
     cmd->keyLength = keyLength;
-    A_MEMCPY(cmd->key, keyMaterial, keyLength);
+    memcpy(cmd->key, keyMaterial, keyLength);
 #ifdef WAPI_ENABLE
     if (NULL != keyRSC && key_op_ctrl != KEY_OP_INIT_WAPIPN) {
 #else
     if (NULL != keyRSC) {
 #endif // WAPI_ENABLE
-        A_MEMCPY(cmd->keyRSC, keyRSC, sizeof(cmd->keyRSC));
+        memcpy(cmd->keyRSC, keyRSC, sizeof(cmd->keyRSC));
     }
     cmd->key_op_ctrl = key_op_ctrl;
 
     if(macAddr) {
-        A_MEMCPY(cmd->key_macaddr,macAddr,IEEE80211_ADDR_LEN);
+        memcpy(cmd->key_macaddr,macAddr,IEEE80211_ADDR_LEN);
     }
 
     return (wmi_cmd_send(wmip, osbuf, WMI_ADD_CIPHER_KEY_CMDID, sync_flag));
@@ -2912,7 +2912,7 @@ wmi_add_krk_cmd(struct wmi_t *wmip, u8 *krk)
 
     cmd = (WMI_ADD_KRK_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, sizeof(*cmd));
-    A_MEMCPY(cmd->krk, krk, WMI_KRK_LEN);
+    memcpy(cmd->krk, krk, WMI_KRK_LEN);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_ADD_KRK_CMDID, NO_SYNC_WMIFLAG));
 }
@@ -2971,9 +2971,9 @@ wmi_setPmkid_cmd(struct wmi_t *wmip, u8 *bssid, u8 *pmkId,
     A_NETBUF_PUT(osbuf, sizeof(*cmd));
 
     cmd = (WMI_SET_PMKID_CMD *)(A_NETBUF_DATA(osbuf));
-    A_MEMCPY(cmd->bssid, bssid, sizeof(cmd->bssid));
+    memcpy(cmd->bssid, bssid, sizeof(cmd->bssid));
     if (set == true) {
-        A_MEMCPY(cmd->pmkid, pmkId, sizeof(cmd->pmkid));
+        memcpy(cmd->pmkid, pmkId, sizeof(cmd->pmkid));
         cmd->enable = PMKID_ENABLE;
     } else {
         A_MEMZERO(cmd->pmkid, sizeof(cmd->pmkid));
@@ -3045,7 +3045,7 @@ wmi_set_pmkid_list_cmd(struct wmi_t *wmip,
     cmd->numPMKID = pmkInfo->numPMKID;
 
     for (i = 0; i < cmd->numPMKID; i++) {
-        A_MEMCPY(&cmd->pmkidList[i], &pmkInfo->pmkidList[i],
+        memcpy(&cmd->pmkidList[i], &pmkInfo->pmkidList[i],
                  WMI_PMKID_LEN);
     }
 
@@ -3258,7 +3258,7 @@ wmi_create_pstream_cmd(struct wmi_t *wmip, WMI_CREATE_PSTREAM_CMD *params)
 
     cmd = (WMI_CREATE_PSTREAM_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, sizeof(*cmd));
-    A_MEMCPY(cmd, params, sizeof(*cmd));
+    memcpy(cmd, params, sizeof(*cmd));
 
         /* this is an implicitly created Fat pipe */
     if ((u32)params->tsid == (u32)WMI_IMPLICIT_PSTREAM) {
@@ -3625,7 +3625,7 @@ wmi_set_channelParams_cmd(struct wmi_t *wmip, u8 scanParam,
     cmd->scanParam   = scanParam;
     cmd->phyMode     = mode;
     cmd->numChannels = numChan;
-    A_MEMCPY(cmd->channelList, channelList, numChan * sizeof(u16));
+    memcpy(cmd->channelList, channelList, numChan * sizeof(u16));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_CHANNEL_PARAMS_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -3724,7 +3724,7 @@ wmi_set_ip_cmd(struct wmi_t *wmip, WMI_SET_IP_CMD *ipCmd)
 
     A_NETBUF_PUT(osbuf, sizeof(WMI_SET_IP_CMD));
     cmd = (WMI_SET_IP_CMD *)(A_NETBUF_DATA(osbuf));
-    A_MEMCPY(cmd, ipCmd, sizeof(WMI_SET_IP_CMD));
+    memcpy(cmd, ipCmd, sizeof(WMI_SET_IP_CMD));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_IP_CMDID,
                             NO_SYNC_WMIFLAG));
@@ -3756,7 +3756,7 @@ wmi_set_host_sleep_mode_cmd(struct wmi_t *wmip,
 
     cmd = (WMI_SET_HOST_SLEEP_MODE_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
-    A_MEMCPY(cmd, hostModeCmd, sizeof(WMI_SET_HOST_SLEEP_MODE_CMD));
+    memcpy(cmd, hostModeCmd, sizeof(WMI_SET_HOST_SLEEP_MODE_CMD));
 
     if(hostModeCmd->asleep) {
         /*
@@ -3811,7 +3811,7 @@ wmi_set_wow_mode_cmd(struct wmi_t *wmip,
 
     cmd = (WMI_SET_WOW_MODE_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
-    A_MEMCPY(cmd, wowModeCmd, sizeof(WMI_SET_WOW_MODE_CMD));
+    memcpy(cmd, wowModeCmd, sizeof(WMI_SET_WOW_MODE_CMD));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_WOW_MODE_CMDID,
                             NO_SYNC_WMIFLAG));
@@ -3837,7 +3837,7 @@ wmi_get_wow_list_cmd(struct wmi_t *wmip,
 
     cmd = (WMI_GET_WOW_LIST_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
-    A_MEMCPY(cmd, wowListCmd, sizeof(WMI_GET_WOW_LIST_CMD));
+    memcpy(cmd, wowListCmd, sizeof(WMI_GET_WOW_LIST_CMD));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_GET_WOW_LIST_CMDID,
                             NO_SYNC_WMIFLAG));
@@ -3885,10 +3885,10 @@ int wmi_add_wow_pattern_cmd(struct wmi_t *wmip,
     cmd->filter_offset = addWowCmd->filter_offset;
     cmd->filter_size = addWowCmd->filter_size;
 
-    A_MEMCPY(cmd->filter, pattern, addWowCmd->filter_size);
+    memcpy(cmd->filter, pattern, addWowCmd->filter_size);
 
     filter_mask = (u8 *)(cmd->filter + cmd->filter_size);
-    A_MEMCPY(filter_mask, mask, addWowCmd->filter_size);
+    memcpy(filter_mask, mask, addWowCmd->filter_size);
 
 
     return (wmi_cmd_send(wmip, osbuf, WMI_ADD_WOW_PATTERN_CMDID,
@@ -3914,7 +3914,7 @@ wmi_del_wow_pattern_cmd(struct wmi_t *wmip,
 
     cmd = (WMI_DEL_WOW_PATTERN_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
-    A_MEMCPY(cmd, delWowCmd, sizeof(WMI_DEL_WOW_PATTERN_CMD));
+    memcpy(cmd, delWowCmd, sizeof(WMI_DEL_WOW_PATTERN_CMD));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_DEL_WOW_PATTERN_CMDID,
                             NO_SYNC_WMIFLAG));
@@ -4026,7 +4026,7 @@ wmi_set_lq_threshold_params(struct wmi_t *wmip,
 
     cmd = (WMI_LQ_THRESHOLD_PARAMS_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
-    A_MEMCPY(cmd, lqCmd, sizeof(WMI_LQ_THRESHOLD_PARAMS_CMD));
+    memcpy(cmd, lqCmd, sizeof(WMI_LQ_THRESHOLD_PARAMS_CMD));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_LQ_THRESHOLD_PARAMS_CMDID,
                             NO_SYNC_WMIFLAG));
@@ -4129,7 +4129,7 @@ wmi_addBadAp_cmd(struct wmi_t *wmip, u8 apIndex, u8 *bssid)
 
     cmd = (WMI_ADD_BAD_AP_CMD *)(A_NETBUF_DATA(osbuf));
     cmd->badApIndex = apIndex;
-    A_MEMCPY(cmd->bssid, bssid, sizeof(cmd->bssid));
+    memcpy(cmd->bssid, bssid, sizeof(cmd->bssid));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_ADD_BAD_AP_CMDID, SYNC_BEFORE_WMIFLAG));
 }
@@ -4244,7 +4244,7 @@ wmi_set_roam_ctrl_cmd(struct wmi_t *wmip, WMI_SET_ROAM_CTRL_CMD *p,
     cmd = (WMI_SET_ROAM_CTRL_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
 
-    A_MEMCPY(cmd, p, size);
+    memcpy(cmd, p, size);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_ROAM_CTRL_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -4276,7 +4276,7 @@ wmi_set_powersave_timers_cmd(struct wmi_t *wmip,
     cmd = (WMI_POWERSAVE_TIMERS_POLICY_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
 
-    A_MEMCPY(cmd, pCmd, size);
+    memcpy(cmd, pCmd, size);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_POWERSAVE_TIMERS_POLICY_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -4482,7 +4482,7 @@ void
 wmi_get_current_bssid(struct wmi_t *wmip, u8 *bssid)
 {
     if (bssid != NULL) {
-        A_MEMCPY(bssid, wmip->wmi_bssid, ATH_MAC_LEN);
+        memcpy(bssid, wmip->wmi_bssid, ATH_MAC_LEN);
     }
 }
 
@@ -4530,9 +4530,9 @@ wmi_opt_tx_frame_cmd(struct wmi_t *wmip,
     cmd->frmType    = frmType;
     cmd->optIEDataLen   = optIEDataLen;
     //cmd->optIEData     = (u8 *)((int)cmd + sizeof(*cmd));
-    A_MEMCPY(cmd->bssid, bssid, sizeof(cmd->bssid));
-    A_MEMCPY(cmd->dstAddr, dstMacAddr, sizeof(cmd->dstAddr));
-    A_MEMCPY(&cmd->optIEData[0], optIEData, optIEDataLen);
+    memcpy(cmd->bssid, bssid, sizeof(cmd->bssid));
+    memcpy(cmd->dstAddr, dstMacAddr, sizeof(cmd->dstAddr));
+    memcpy(&cmd->optIEData[0], optIEData, optIEDataLen);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_OPT_TX_FRAME_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -4858,7 +4858,7 @@ wmi_set_country(struct wmi_t *wmip, A_UCHAR *countryCode)
 
     cmd = (WMI_AP_SET_COUNTRY_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, sizeof(*cmd));
-    A_MEMCPY(cmd->countryCode,countryCode,3);
+    memcpy(cmd->countryCode,countryCode,3);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_SET_COUNTRY_CMDID,
             NO_SYNC_WMIFLAG));
@@ -4884,7 +4884,7 @@ wmi_test_cmd(struct wmi_t *wmip, u8 *buf, u32 len)
     }
     A_NETBUF_PUT(osbuf, len);
     data = A_NETBUF_DATA(osbuf);
-    A_MEMCPY(data, buf, len);
+    memcpy(data, buf, len);
 
     return(wmi_cmd_send(wmip, osbuf, WMI_TEST_CMDID,
          NO_SYNC_WMIFLAG));
@@ -4972,7 +4972,7 @@ wmi_set_bt_params_cmd(struct wmi_t *wmip, WMI_SET_BT_PARAMS_CMD* cmd)
 
     alloc_cmd = (WMI_SET_BT_PARAMS_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-    A_MEMCPY(alloc_cmd, cmd, sizeof(*cmd));
+    memcpy(alloc_cmd, cmd, sizeof(*cmd));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BT_PARAMS_CMDID,
             NO_SYNC_WMIFLAG));
@@ -4991,7 +4991,7 @@ wmi_set_btcoex_fe_ant_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_FE_ANT_CMD * cmd)
     A_NETBUF_PUT(osbuf, sizeof(*cmd));
     alloc_cmd = (WMI_SET_BTCOEX_FE_ANT_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_FE_ANT_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_FE_ANT_CMD));
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_FE_ANT_CMDID,
                          NO_SYNC_WMIFLAG));
 
@@ -5012,7 +5012,7 @@ wmi_set_btcoex_colocated_bt_dev_cmd(struct wmi_t *wmip,
     A_NETBUF_PUT(osbuf, sizeof(*cmd));
     alloc_cmd = (WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-    A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD));
+    memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD));
     A_PRINTF("colocated bt = %d\n", alloc_cmd->btcoexCoLocatedBTdev);
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -5033,7 +5033,7 @@ wmi_set_btcoex_btinquiry_page_config_cmd(struct wmi_t *wmip,
     A_NETBUF_PUT(osbuf, sizeof(*cmd));
     alloc_cmd = (WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMD));
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMDID,
                          NO_SYNC_WMIFLAG));
 
@@ -5053,7 +5053,7 @@ wmi_set_btcoex_sco_config_cmd(struct wmi_t *wmip,
     A_NETBUF_PUT(osbuf, sizeof(*cmd));
     alloc_cmd = (WMI_SET_BTCOEX_SCO_CONFIG_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_SCO_CONFIG_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_SCO_CONFIG_CMD));
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_SCO_CONFIG_CMDID ,
                          NO_SYNC_WMIFLAG));
 
@@ -5073,7 +5073,7 @@ wmi_set_btcoex_a2dp_config_cmd(struct wmi_t *wmip,
     A_NETBUF_PUT(osbuf, sizeof(*cmd));
     alloc_cmd = (WMI_SET_BTCOEX_A2DP_CONFIG_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_A2DP_CONFIG_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_A2DP_CONFIG_CMD));
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_A2DP_CONFIG_CMDID ,
                          NO_SYNC_WMIFLAG));
 
@@ -5093,7 +5093,7 @@ wmi_set_btcoex_aclcoex_config_cmd(struct wmi_t *wmip,
     A_NETBUF_PUT(osbuf, sizeof(*cmd));
     alloc_cmd = (WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD));
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMDID ,
                          NO_SYNC_WMIFLAG));
 
@@ -5112,7 +5112,7 @@ wmi_set_btcoex_debug_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_DEBUG_CMD * cmd)
 	A_NETBUF_PUT(osbuf, sizeof(*cmd));
 	alloc_cmd = (WMI_SET_BTCOEX_DEBUG_CMD *)(A_NETBUF_DATA(osbuf));
 	A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_DEBUG_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_DEBUG_CMD));
 	return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_DEBUG_CMDID ,
 							 NO_SYNC_WMIFLAG));
 
@@ -5132,7 +5132,7 @@ wmi_set_btcoex_bt_operating_status_cmd(struct wmi_t * wmip,
 	A_NETBUF_PUT(osbuf, sizeof(*cmd));
 	alloc_cmd = (WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMD *)(A_NETBUF_DATA(osbuf));
 	A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMD));
 	return (wmi_cmd_send(wmip, osbuf, WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMDID ,
 								 NO_SYNC_WMIFLAG));
 
@@ -5151,7 +5151,7 @@ wmi_get_btcoex_config_cmd(struct wmi_t * wmip, WMI_GET_BTCOEX_CONFIG_CMD * cmd)
 	A_NETBUF_PUT(osbuf, sizeof(*cmd));
 	alloc_cmd = (WMI_GET_BTCOEX_CONFIG_CMD *)(A_NETBUF_DATA(osbuf));
 	A_MEMZERO(alloc_cmd, sizeof(*cmd));
-	A_MEMCPY(alloc_cmd,cmd,sizeof(WMI_GET_BTCOEX_CONFIG_CMD));
+	memcpy(alloc_cmd,cmd,sizeof(WMI_GET_BTCOEX_CONFIG_CMD));
 	return (wmi_cmd_send(wmip, osbuf, WMI_GET_BTCOEX_CONFIG_CMDID ,
 							 NO_SYNC_WMIFLAG));
 
@@ -5225,7 +5225,7 @@ wmi_set_params_cmd(struct wmi_t *wmip, u32 opcode, u32 length, char *buffer)
     A_MEMZERO(cmd, sizeof(*cmd));
     cmd->opcode = opcode;
     cmd->length = length;
-    A_MEMCPY(cmd->buffer, buffer, length);
+    memcpy(cmd->buffer, buffer, length);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_PARAMS_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -5324,7 +5324,7 @@ wmi_set_appie_cmd(struct wmi_t *wmip, u8 mgmtFrmType, u8 ieLen,
 
     cmd->mgmtFrmType = mgmtFrmType;
     cmd->ieLen = ieLen;
-    A_MEMCPY(cmd->ieInfo, ieInfo, ieLen);
+    memcpy(cmd->ieInfo, ieInfo, ieLen);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_APPIE_CMDID, NO_SYNC_WMIFLAG));
 }
@@ -5344,7 +5344,7 @@ wmi_set_halparam_cmd(struct wmi_t *wmip, u8 *cmd, u16 dataLen)
 
     data = A_NETBUF_DATA(osbuf);
 
-    A_MEMCPY(data, cmd, dataLen);
+    memcpy(data, cmd, dataLen);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_WHALPARAM_CMDID, NO_SYNC_WMIFLAG));
 }
@@ -5933,7 +5933,7 @@ wmi_send_rssi_threshold_params(struct wmi_t *wmip,
 
     cmd = (WMI_RSSI_THRESHOLD_PARAMS_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
-    A_MEMCPY(cmd, rssiCmd, sizeof(WMI_RSSI_THRESHOLD_PARAMS_CMD));
+    memcpy(cmd, rssiCmd, sizeof(WMI_RSSI_THRESHOLD_PARAMS_CMD));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_RSSI_THRESHOLD_PARAMS_CMDID,
                             NO_SYNC_WMIFLAG));
@@ -5956,7 +5956,7 @@ wmi_send_snr_threshold_params(struct wmi_t *wmip,
     A_NETBUF_PUT(osbuf, size);
     cmd = (WMI_SNR_THRESHOLD_PARAMS_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cmd, size);
-    A_MEMCPY(cmd, snrCmd, sizeof(WMI_SNR_THRESHOLD_PARAMS_CMD));
+    memcpy(cmd, snrCmd, sizeof(WMI_SNR_THRESHOLD_PARAMS_CMD));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SNR_THRESHOLD_PARAMS_CMDID,
                             NO_SYNC_WMIFLAG));
@@ -5977,7 +5977,7 @@ wmi_set_target_event_report_cmd(struct wmi_t *wmip, WMI_SET_TARGET_EVENT_REPORT_
 
     alloc_cmd = (WMI_SET_TARGET_EVENT_REPORT_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(alloc_cmd, sizeof(*cmd));
-    A_MEMCPY(alloc_cmd, cmd, sizeof(*cmd));
+    memcpy(alloc_cmd, cmd, sizeof(*cmd));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_TARGET_EVENT_REPORT_CMDID,
             NO_SYNC_WMIFLAG));
@@ -6089,7 +6089,7 @@ wmi_ap_profile_commit(struct wmi_t *wmip, WMI_CONNECT_CMD *p)
     cm = (WMI_CONNECT_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(cm, sizeof(*cm));
 
-    A_MEMCPY(cm,p,sizeof(*cm));
+    memcpy(cm,p,sizeof(*cm));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_CONFIG_COMMIT_CMDID, NO_SYNC_WMIFLAG));
 }
@@ -6171,7 +6171,7 @@ wmi_ap_acl_mac_list(struct wmi_t *wmip, WMI_AP_ACL_MAC_CMD *acl)
     A_NETBUF_PUT(osbuf, sizeof(WMI_AP_ACL_MAC_CMD));
     a = (WMI_AP_ACL_MAC_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(a, sizeof(*a));
-    A_MEMCPY(a,acl,sizeof(*acl));
+    memcpy(a,acl,sizeof(*acl));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_ACL_MAC_LIST_CMDID, NO_SYNC_WMIFLAG));
 }
@@ -6199,7 +6199,7 @@ wmi_ap_set_mlme(struct wmi_t *wmip, u8 cmd, u8 *mac, u16 reason)
     A_MEMZERO(mlme, sizeof(*mlme));
 
     mlme->cmd = cmd;
-    A_MEMCPY(mlme->mac, mac, ATH_MAC_LEN);
+    memcpy(mlme->mac, mac, ATH_MAC_LEN);
     mlme->reason = reason;
 
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_SET_MLME_CMDID, NO_SYNC_WMIFLAG));
@@ -6392,7 +6392,7 @@ wmi_set_ht_cap_cmd(struct wmi_t *wmip, WMI_SET_HT_CAP_CMD *cmd)
 
     htCap = (WMI_SET_HT_CAP_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(htCap, sizeof(*htCap));
-    A_MEMCPY(htCap, cmd, sizeof(*htCap));
+    memcpy(htCap, cmd, sizeof(*htCap));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_HT_CAP_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -6434,7 +6434,7 @@ wmi_set_tx_select_rates_cmd(struct wmi_t *wmip, u32 *pMaskArray)
     A_NETBUF_PUT(osbuf, sizeof(*pData));
 
     pData = (WMI_SET_TX_SELECT_RATES_CMD *)(A_NETBUF_DATA(osbuf));
-    A_MEMCPY(pData, pMaskArray, sizeof(*pData));
+    memcpy(pData, pMaskArray, sizeof(*pData));
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_TX_SELECT_RATES_CMDID,
                          NO_SYNC_WMIFLAG));
@@ -6456,7 +6456,7 @@ wmi_send_hci_cmd(struct wmi_t *wmip, u8 *buf, u16 sz)
     cmd = (WMI_HCI_CMD *)(A_NETBUF_DATA(osbuf));
 
     cmd->cmd_buf_sz = sz;
-    A_MEMCPY(cmd->buf, buf, sz);
+    memcpy(cmd->buf, buf, sz);
     return (wmi_cmd_send(wmip, osbuf, WMI_HCI_CMD_CMDID, NO_SYNC_WMIFLAG));
 }
 
@@ -6604,7 +6604,7 @@ wmi_set_pmk_cmd(struct wmi_t *wmip, u8 *pmk)
     p = (WMI_SET_PMK_CMD *)(A_NETBUF_DATA(osbuf));
     A_MEMZERO(p, sizeof(*p));
 
-    A_MEMCPY(p->pmk, pmk, WMI_PMK_LEN);
+    memcpy(p->pmk, pmk, WMI_PMK_LEN);
 
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_PMK_CMDID, NO_SYNC_WMIFLAG));
 }
-- 
1.7.4.15.g7811d

