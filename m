Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47211 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab1C3A56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 34/34] ath6kl: remove the HTC raw interface
Date: Tue, 29 Mar 2011 17:56:31 -0700
Message-ID: <1301446591-15236-35-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This uses ioctl, if this is required it should be replaced
with the nl80211 test command interface.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Kconfig                     |    6 -
 drivers/staging/ath6kl/Makefile                    |    5 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   36 --
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  455 --------------------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   20 -
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |   37 --
 6 files changed, 0 insertions(+), 559 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c

diff --git a/drivers/staging/ath6kl/Kconfig b/drivers/staging/ath6kl/Kconfig
index 1f15e1f..3db09ab 100644
--- a/drivers/staging/ath6kl/Kconfig
+++ b/drivers/staging/ath6kl/Kconfig
@@ -100,12 +100,6 @@ config AR600x_BT_RESET_PIN
 	help
 	WLAN GPIO to be used for resetting BT
 
-config ATH6KL_HTC_RAW_INTERFACE
-	bool "RAW HTC support"
-	depends on ATH6K_LEGACY
-	help
-	Enables raw HTC interface. Allows application to directly talk to the HTC interface via the ioctl interface
-
 config ATH6KL_VIRTUAL_SCATTER_GATHER
 	bool "Virtual Scatter-Gather support"
 	depends on ATH6K_LEGACY
diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index 1d3f239..dfba8f4 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -65,10 +65,6 @@ ifeq ($(CONFIG_ATH6KL_CONFIG_GPIO_BT_RESET),y)
 ccflags-y += -DATH6KL_CONFIG_GPIO_BT_RESET
 endif
 
-ifeq ($(CONFIG_ATH6KL_HTC_RAW_INTERFACE),y)
-ccflags-y += -DHTC_RAW_INTERFACE
-endif
-
 ifeq ($(CONFIG_ATH6KL_ENABLE_HOST_DEBUG),y)
 ccflags-y += -DDEBUG
 ccflags-y += -DATH_DEBUG_MODULE
@@ -103,7 +99,6 @@ ath6kl-y += htc2/htc.o
 ath6kl-y += bmi/src/bmi.o
 ath6kl-y += os/linux/cfg80211.o
 ath6kl-y += os/linux/ar6000_drv.o
-ath6kl-y += os/linux/ar6000_raw_if.o
 ath6kl-y += os/linux/ar6000_pm.o
 ath6kl-y += os/linux/netbuf.o
 ath6kl-y += os/linux/hci_bridge.o
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 666d5e6..31be5ca 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1000,19 +1000,6 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                 compressed = false;
             }
 #endif 
-#ifdef HTC_RAW_INTERFACE
-            if (!eppingtest && bypasswmi) {
-                if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
-                    filename = AR6003_REV1_ART_FIRMWARE_FILE;
-                } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
-                    filename = AR6003_REV2_ART_FIRMWARE_FILE;
-                } else {
-                    AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
-                    return A_ERROR;
-                }
-                compressed = false;
-            }
-#endif 
             break;
 
         case AR6K_PATCH_FILE:
@@ -1333,13 +1320,6 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 #endif /* CONFIG_ATH6KL_BT_UART_FC_POLARITY */
         }
 
-#ifdef HTC_RAW_INTERFACE
-        if (!eppingtest && bypasswmi) {
-            /* Don't run BMIDone for ART mode and force resetok=0 */
-            resetok = 0;
-            msleep(1000);
-        }
-#endif /* HTC_RAW_INTERFACE */
     }
 
     return 0;
@@ -1545,20 +1525,10 @@ static int __ath6kl_init_netdev(struct net_device *dev)
 	return 0;
 }
 
-#ifdef HTC_RAW_INTERFACE
 static int ath6kl_init_netdev_wmi(struct net_device *dev)
 {
-	if (!eppingtest && bypasswmi)
-		return 0;
-
 	return __ath6kl_init_netdev(dev);
 }
-#else
-static int ath6kl_init_netdev_wmi(struct net_device *dev)
-{
-	return __ath6kl_init_netdev(dev);
-}
-#endif
 
 static int ath6kl_init_netdev(struct ar6_softc *ar)
 {
@@ -2034,12 +2004,6 @@ ar6000_destroy(struct net_device *dev, unsigned int unregister)
     memset(tx_post, 0, sizeof(tx_post));
     memset(tx_complete, 0, sizeof(tx_complete));
 
-#ifdef HTC_RAW_INTERFACE
-    if (ar->arRawHtc) {
-        kfree(ar->arRawHtc);
-        ar->arRawHtc = NULL;
-    }
-#endif 
     /* Free up the device data structure */
     if (unregister && is_netdev_registered) {		
         unregister_netdev(dev);
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
deleted file mode 100644
index ae7c1dd..0000000
--- a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
+++ /dev/null
@@ -1,455 +0,0 @@
-//------------------------------------------------------------------------------
-// Copyright (c) 2004-2010 Atheros Communications Inc.
-// All rights reserved.
-//
-// 
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//
-// Author(s): ="Atheros"
-//------------------------------------------------------------------------------
-
-#include "ar6000_drv.h"
-
-#ifdef HTC_RAW_INTERFACE
-
-static void
-ar6000_htc_raw_read_cb(void *Context, struct htc_packet *pPacket)
-{
-    struct ar6_softc        *ar = (struct ar6_softc *)Context;
-    raw_htc_buffer    *busy;
-    HTC_RAW_STREAM_ID streamID; 
-    AR_RAW_HTC_T *arRaw = ar->arRawHtc;
-
-    busy = (raw_htc_buffer *)pPacket->pPktContext;
-    A_ASSERT(busy != NULL);
-
-    if (pPacket->Status == A_ECANCELED) {
-        /*
-         * HTC provides A_ECANCELED status when it doesn't want to be refilled
-         * (probably due to a shutdown)
-         */
-        return;
-    }
-
-    streamID = arEndpoint2RawStreamID(ar,pPacket->Endpoint);
-    A_ASSERT(streamID != HTC_RAW_STREAM_NOT_MAPPED);
-    
-#ifdef CF
-   if (down_trylock(&arRaw->raw_htc_read_sem[streamID])) {
-#else
-    if (down_interruptible(&arRaw->raw_htc_read_sem[streamID])) {
-#endif /* CF */
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Unable to down the semaphore\n"));
-    }
-
-    A_ASSERT((pPacket->Status != 0) ||
-             (pPacket->pBuffer == (busy->data + HTC_HEADER_LEN)));
-
-    busy->length = pPacket->ActualLength + HTC_HEADER_LEN;
-    busy->currPtr = HTC_HEADER_LEN;
-    arRaw->read_buffer_available[streamID] = true;
-    //AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("raw read cb:  0x%X 0x%X \n", busy->currPtr,busy->length);
-    up(&arRaw->raw_htc_read_sem[streamID]);
-
-    /* Signal the waiting process */
-    AR_DEBUG_PRINTF(ATH_DEBUG_HTC_RAW,("Waking up the StreamID(%d) read process\n", streamID));
-    wake_up_interruptible(&arRaw->raw_htc_read_queue[streamID]);
-}
-
-static void
-ar6000_htc_raw_write_cb(void *Context, struct htc_packet *pPacket)
-{
-    struct ar6_softc          *ar = (struct ar6_softc  *)Context;
-    raw_htc_buffer      *free;
-    HTC_RAW_STREAM_ID   streamID;
-    AR_RAW_HTC_T *arRaw = ar->arRawHtc;
-    
-    free = (raw_htc_buffer *)pPacket->pPktContext;
-    A_ASSERT(free != NULL);
-
-    if (pPacket->Status == A_ECANCELED) {
-        /*
-         * HTC provides A_ECANCELED status when it doesn't want to be refilled
-         * (probably due to a shutdown)
-         */
-        return;
-    }
-
-    streamID = arEndpoint2RawStreamID(ar,pPacket->Endpoint);
-    A_ASSERT(streamID != HTC_RAW_STREAM_NOT_MAPPED);
-    
-#ifdef CF
-    if (down_trylock(&arRaw->raw_htc_write_sem[streamID])) {
-#else
-    if (down_interruptible(&arRaw->raw_htc_write_sem[streamID])) {
-#endif
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Unable to down the semaphore\n"));
-    }
-
-    A_ASSERT(pPacket->pBuffer == (free->data + HTC_HEADER_LEN));
-
-    free->length = 0;
-    arRaw->write_buffer_available[streamID] = true;
-    up(&arRaw->raw_htc_write_sem[streamID]);
-
-    /* Signal the waiting process */
-    AR_DEBUG_PRINTF(ATH_DEBUG_HTC_RAW,("Waking up the StreamID(%d) write process\n", streamID));
-    wake_up_interruptible(&arRaw->raw_htc_write_queue[streamID]);
-}
-
-/* connect to a service */
-static int ar6000_connect_raw_service(struct ar6_softc        *ar,
-                                           HTC_RAW_STREAM_ID StreamID)
-{
-    int                 status;
-    struct htc_service_connect_resp response;
-    u8 streamNo;
-    struct htc_service_connect_req  connect;
-    
-    do {      
-        
-        A_MEMZERO(&connect,sizeof(connect));
-            /* pass the stream ID as meta data to the RAW streams service */
-        streamNo = (u8)StreamID;
-        connect.pMetaData = &streamNo;
-        connect.MetaDataLength = sizeof(u8);
-            /* these fields are the same for all endpoints */
-        connect.EpCallbacks.pContext = ar;
-        connect.EpCallbacks.EpTxComplete = ar6000_htc_raw_write_cb;   
-        connect.EpCallbacks.EpRecv = ar6000_htc_raw_read_cb;   
-            /* simple interface, we don't need these optional callbacks */      
-        connect.EpCallbacks.EpRecvRefill = NULL;
-        connect.EpCallbacks.EpSendFull = NULL;
-        connect.MaxSendQueueDepth = RAW_HTC_WRITE_BUFFERS_NUM;  
-        
-            /* connect to the raw streams service, we may be able to get 1 or more
-             * connections, depending on WHAT is running on the target */
-        connect.ServiceID = HTC_RAW_STREAMS_SVC;
-        
-        A_MEMZERO(&response,sizeof(response));
-        
-            /* try to connect to the raw stream, it is okay if this fails with 
-             * status HTC_SERVICE_NO_MORE_EP */
-        status = HTCConnectService(ar->arHtcTarget, 
-                                   &connect,
-                                   &response);
-        
-        if (status) {
-            if (response.ConnectRespCode == HTC_SERVICE_NO_MORE_EP) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HTC RAW , No more streams allowed \n"));
-                status = 0;
-            }
-            break;    
-        }
-
-            /* set endpoint mapping for the RAW HTC streams */
-        arSetRawStream2EndpointIDMap(ar,StreamID,response.Endpoint);
-
-        AR_DEBUG_PRINTF(ATH_DEBUG_HTC_RAW,("HTC RAW : stream ID: %d, endpoint: %d\n", 
-                        StreamID, arRawStream2EndpointID(ar,StreamID)));
-        
-    } while (false);
-    
-    return status;
-}
-
-int ar6000_htc_raw_open(struct ar6_softc *ar)
-{
-    int status;
-    int streamID, endPt, count2;
-    raw_htc_buffer *buffer;
-    HTC_SERVICE_ID servicepriority;
-    AR_RAW_HTC_T *arRaw = ar->arRawHtc;
-    if (!arRaw) {
-        arRaw = ar->arRawHtc = A_MALLOC(sizeof(AR_RAW_HTC_T));
-        if (arRaw) {
-            A_MEMZERO(arRaw, sizeof(AR_RAW_HTC_T));
-        }
-    }
-    A_ASSERT(ar->arHtcTarget != NULL);
-    if (!arRaw) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Faile to allocate memory for HTC RAW interface\n"));
-        return -ENOMEM;
-    }
-    /* wait for target */
-    status = HTCWaitTarget(ar->arHtcTarget);
-        
-    if (status) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HTCWaitTarget failed (%d)\n", status));
-        return -ENODEV;  
-    }
-    
-    for (endPt = 0; endPt < ENDPOINT_MAX; endPt++) {
-        arRaw->arEp2RawMapping[endPt] = HTC_RAW_STREAM_NOT_MAPPED;
-    }
-        
-    for (streamID = HTC_RAW_STREAM_0; streamID < HTC_RAW_STREAM_NUM_MAX; streamID++) {
-        /* Initialize the data structures */
-	sema_init(&arRaw->raw_htc_read_sem[streamID], 1);
-	sema_init(&arRaw->raw_htc_write_sem[streamID], 1);
-        init_waitqueue_head(&arRaw->raw_htc_read_queue[streamID]);
-        init_waitqueue_head(&arRaw->raw_htc_write_queue[streamID]);
-
-            /* try to connect to the raw service */
-        status = ar6000_connect_raw_service(ar,streamID);
-        
-        if (status) {
-            break;    
-        }
-        
-        if (arRawStream2EndpointID(ar,streamID) == 0) {
-            break;    
-        }
-        
-        for (count2 = 0; count2 < RAW_HTC_READ_BUFFERS_NUM; count2 ++) {
-            /* Initialize the receive buffers */
-            buffer = &arRaw->raw_htc_write_buffer[streamID][count2];
-            memset(buffer, 0, sizeof(raw_htc_buffer));
-            buffer = &arRaw->raw_htc_read_buffer[streamID][count2];
-            memset(buffer, 0, sizeof(raw_htc_buffer));
-            
-            SET_HTC_PACKET_INFO_RX_REFILL(&buffer->HTCPacket,
-                                          buffer,
-                                          buffer->data,
-                                          HTC_RAW_BUFFER_SIZE,
-                                          arRawStream2EndpointID(ar,streamID));
-            
-            /* Queue buffers to HTC for receive */
-            if ((status = HTCAddReceivePkt(ar->arHtcTarget, &buffer->HTCPacket)) != 0)
-            {
-                BMIInit();
-                return -EIO;
-            }
-        }
-
-        for (count2 = 0; count2 < RAW_HTC_WRITE_BUFFERS_NUM; count2 ++) {
-            /* Initialize the receive buffers */
-            buffer = &arRaw->raw_htc_write_buffer[streamID][count2];
-            memset(buffer, 0, sizeof(raw_htc_buffer));
-        }
-
-        arRaw->read_buffer_available[streamID] = false;
-        arRaw->write_buffer_available[streamID] = true;
-    }
-    
-    if (status) {
-        return -EIO;    
-    }
-    
-    AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("HTC RAW, number of streams the target supports: %d \n", streamID));
-            
-    servicepriority = HTC_RAW_STREAMS_SVC;  /* only 1 */
-    
-        /* set callbacks and priority list */
-    HTCSetCreditDistribution(ar->arHtcTarget,
-                             ar,
-                             NULL,  /* use default */
-                             NULL,  /* use default */
-                             &servicepriority,
-                             1);
-
-    /* Start the HTC component */
-    if ((status = HTCStart(ar->arHtcTarget)) != 0) {
-        BMIInit();
-        return -EIO;
-    }
-
-    (ar)->arRawIfInit = true;
-    
-    return 0;
-}
-
-int ar6000_htc_raw_close(struct ar6_softc *ar)
-{
-    A_PRINTF("ar6000_htc_raw_close called \n");
-    HTCStop(ar->arHtcTarget);
-    
-        /* reset the device */
-    ar6000_reset_device(ar->arHifDevice, ar->arTargetType, true, false);
-    /* Initialize the BMI component */
-    BMIInit();
-
-    return 0;
-}
-
-raw_htc_buffer *
-get_filled_buffer(struct ar6_softc *ar, HTC_RAW_STREAM_ID StreamID)
-{
-    int count;
-    raw_htc_buffer *busy;
-    AR_RAW_HTC_T *arRaw = ar->arRawHtc;
-
-    /* Check for data */
-    for (count = 0; count < RAW_HTC_READ_BUFFERS_NUM; count ++) {
-        busy = &arRaw->raw_htc_read_buffer[StreamID][count];
-        if (busy->length) {
-            break;
-        }
-    }
-    if (busy->length) {
-        arRaw->read_buffer_available[StreamID] = true;
-    } else {
-        arRaw->read_buffer_available[StreamID] = false;
-    }
-
-    return busy;
-}
-
-ssize_t ar6000_htc_raw_read(struct ar6_softc *ar, HTC_RAW_STREAM_ID StreamID, 
-                            char __user *buffer, size_t length)
-{
-    int readPtr;
-    raw_htc_buffer *busy;
-    AR_RAW_HTC_T *arRaw = ar->arRawHtc;
-
-    if (arRawStream2EndpointID(ar,StreamID) == 0) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("StreamID(%d) not connected! \n", StreamID));
-        return -EFAULT;    
-    }
-    
-    if (down_interruptible(&arRaw->raw_htc_read_sem[StreamID])) {
-        return -ERESTARTSYS;
-    }
-
-    busy = get_filled_buffer(ar,StreamID);
-    while (!arRaw->read_buffer_available[StreamID]) {
-        up(&arRaw->raw_htc_read_sem[StreamID]);
-
-        /* Wait for the data */
-        AR_DEBUG_PRINTF(ATH_DEBUG_HTC_RAW,("Sleeping StreamID(%d) read process\n", StreamID));
-        if (wait_event_interruptible(arRaw->raw_htc_read_queue[StreamID],
-                                     arRaw->read_buffer_available[StreamID]))
-        {
-            return -EINTR;
-        }
-        if (down_interruptible(&arRaw->raw_htc_read_sem[StreamID])) {
-            return -ERESTARTSYS;
-        }
-        busy = get_filled_buffer(ar,StreamID);
-    }
-
-    /* Read the data */
-    readPtr = busy->currPtr;
-    if (length > busy->length - HTC_HEADER_LEN) {
-        length = busy->length - HTC_HEADER_LEN;
-    }
-    if (copy_to_user(buffer, &busy->data[readPtr], length)) {
-        up(&arRaw->raw_htc_read_sem[StreamID]);
-        return -EFAULT;
-    }
-
-    busy->currPtr += length;
-        
-    if (busy->currPtr == busy->length)
-    {    
-        busy->currPtr = 0;
-        busy->length = 0;        
-        HTC_PACKET_RESET_RX(&busy->HTCPacket);                                          
-        //AR_DEBUG_PRINTF(ATH_DEBUG_HTC_RAW,("raw read ioctl:  ep for packet:%d \n", busy->HTCPacket.Endpoint));
-        HTCAddReceivePkt(ar->arHtcTarget, &busy->HTCPacket);
-    }
-    arRaw->read_buffer_available[StreamID] = false;
-    up(&arRaw->raw_htc_read_sem[StreamID]);
-
-    return length;
-}
-
-static raw_htc_buffer *
-get_free_buffer(struct ar6_softc *ar, HTC_ENDPOINT_ID StreamID)
-{
-    int count;
-    raw_htc_buffer *free;
-    AR_RAW_HTC_T *arRaw = ar->arRawHtc;
-
-    free = NULL;
-    for (count = 0; count < RAW_HTC_WRITE_BUFFERS_NUM; count ++) {
-        free = &arRaw->raw_htc_write_buffer[StreamID][count];
-        if (free->length == 0) {
-            break;
-        }
-    }
-    if (!free->length) {
-        arRaw->write_buffer_available[StreamID] = true;
-    } else {
-        arRaw->write_buffer_available[StreamID] = false;
-    }
-
-    return free;
-}
-
-ssize_t ar6000_htc_raw_write(struct ar6_softc *ar, HTC_RAW_STREAM_ID StreamID,
-                     char __user *buffer, size_t length)
-{
-    int writePtr;
-    raw_htc_buffer *free;
-    AR_RAW_HTC_T *arRaw = ar->arRawHtc;
-    if (arRawStream2EndpointID(ar,StreamID) == 0) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("StreamID(%d) not connected! \n", StreamID));
-        return -EFAULT;    
-    }
-    
-    if (down_interruptible(&arRaw->raw_htc_write_sem[StreamID])) {
-        return -ERESTARTSYS;
-    }
-
-    /* Search for a free buffer */
-    free = get_free_buffer(ar,StreamID);
-
-    /* Check if there is space to write else wait */
-    while (!arRaw->write_buffer_available[StreamID]) {
-        up(&arRaw->raw_htc_write_sem[StreamID]);
-
-        /* Wait for buffer to become free */
-        AR_DEBUG_PRINTF(ATH_DEBUG_HTC_RAW,("Sleeping StreamID(%d) write process\n", StreamID));
-        if (wait_event_interruptible(arRaw->raw_htc_write_queue[StreamID],
-                                     arRaw->write_buffer_available[StreamID]))
-        {
-            return -EINTR;
-        }
-        if (down_interruptible(&arRaw->raw_htc_write_sem[StreamID])) {
-            return -ERESTARTSYS;
-        }
-        free = get_free_buffer(ar,StreamID);
-    }
-
-    /* Send the data */
-    writePtr = HTC_HEADER_LEN;
-    if (length > (HTC_RAW_BUFFER_SIZE - HTC_HEADER_LEN)) {
-        length = HTC_RAW_BUFFER_SIZE - HTC_HEADER_LEN;
-    }
-
-    if (copy_from_user(&free->data[writePtr], buffer, length)) {
-        up(&arRaw->raw_htc_read_sem[StreamID]);
-        return -EFAULT;
-    }
-
-    free->length = length;
-        
-    SET_HTC_PACKET_INFO_TX(&free->HTCPacket,
-                           free,
-                           &free->data[writePtr],
-                           length,
-                           arRawStream2EndpointID(ar,StreamID),
-                           AR6K_DATA_PKT_TAG);
-    
-    HTCSendPkt(ar->arHtcTarget,&free->HTCPacket);
-    
-    arRaw->write_buffer_available[StreamID] = false;
-    up(&arRaw->raw_htc_write_sem[StreamID]);
-
-    return length;
-}
-#endif /* HTC_RAW_INTERFACE */
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index e47b078..ae57573 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -539,9 +539,6 @@ struct ar6_softc {
     u8 arHiAcStreamActivePri;
     u8 arEp2AcMapping[ENDPOINT_MAX];
     HTC_ENDPOINT_ID         arControlEp;
-#ifdef HTC_RAW_INTERFACE
-    AR_RAW_HTC_T            *arRawHtc;
-#endif
     bool                  arNetQueueStopped;
     bool                  arRawIfInit;
     int                     arDeviceIndex;
@@ -680,23 +677,6 @@ int ar6000_acl_data_tx(struct sk_buff *skb, struct net_device *dev);
 void ar6000_restart_endpoint(struct net_device *dev);
 void ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs);
 
-#ifdef HTC_RAW_INTERFACE
-
-#ifndef __user
-#define __user
-#endif
-
-int ar6000_htc_raw_open(struct ar6_softc *ar);
-int ar6000_htc_raw_close(struct ar6_softc *ar);
-ssize_t ar6000_htc_raw_read(struct ar6_softc *ar,
-                            HTC_RAW_STREAM_ID StreamID,
-                            char __user *buffer, size_t count);
-ssize_t ar6000_htc_raw_write(struct ar6_softc *ar,
-                             HTC_RAW_STREAM_ID StreamID,
-                             char __user *buffer, size_t count);
-
-#endif /* HTC_RAW_INTERFACE */
-
 /* AP mode */
 /*TODO: These routines should be moved to a file that is common across OS */
 sta_t *
diff --git a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
index 3d5f01d..f911799 100644
--- a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
@@ -309,43 +309,6 @@ extern "C" {
  */
 
 
-#ifdef HTC_RAW_INTERFACE
-/* HTC Raw Interface Ioctls */
-#define AR6000_XIOCTL_HTC_RAW_OPEN                              13
-/*
- * arguments:
- *   UINT32 cmd (AR6000_XIOCTL_HTC_RAW_OPEN)
- */
-
-#define AR6000_XIOCTL_HTC_RAW_CLOSE                             14
-/*
- * arguments:
- *   UINT32 cmd (AR6000_XIOCTL_HTC_RAW_CLOSE)
- */
-
-#define AR6000_XIOCTL_HTC_RAW_READ                              15
-/*
- * arguments:
- *   union {
- *     struct {
- *       UINT32 cmd (AR6000_XIOCTL_HTC_RAW_READ)
- *       UINT32 mailboxID
- *       UINT32 length
- *     }
- *     results[length]
- *   }
- */
-
-#define AR6000_XIOCTL_HTC_RAW_WRITE                             16
-/*
- * arguments:
- *   UINT32 cmd (AR6000_XIOCTL_HTC_RAW_WRITE)
- *   UINT32 mailboxID
- *   UINT32 length
- *   char buffer[length]
- */
-#endif /* HTC_RAW_INTERFACE */
-
 #define AR6000_XIOCTL_CHECK_TARGET_READY                        17
 /*
  * arguments:
-- 
1.7.0.4

