Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20474 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab1CNR71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:27 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/38] ath6kl: remove-typedef HIF_DEVICE_SCATTER_SUPPORT_INFO
Date: Mon, 14 Mar 2011 10:58:44 -0700
Message-ID: <1300125552-24422-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_DEVICE_SCATTER_SUPPORT_INFO \
	"struct hif_device_scatter_support_info" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../hif/sdio/linux_sdio/include/hif_internal.h     |    4 ++--
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    2 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    2 +-
 drivers/staging/ath6kl/include/hif.h               |    6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
index b5d1ad4..e2d2266 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
@@ -110,13 +110,13 @@ typedef struct _HIF_SCATTER_REQ_PRIV {
 
 #define ATH_DEBUG_SCATTER  ATH_DEBUG_MAKE_MODULE_MASK(0)
 
-int SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo);
+int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support_info *pInfo);
 void CleanupHIFScatterResources(HIF_DEVICE *device);
 int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest);
 
 #else  // HIF_LINUX_MMC_SCATTER_SUPPORT
 
-static inline int SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo)
+static inline int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support_info *pInfo)
 {
     return A_ENOTSUP;
 }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 6d3b9f4..9c9fb1e 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -723,7 +723,7 @@ HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
             if (!device->scatter_enabled) {
                 return A_ENOTSUP;    
             }
-            status = SetupHIFScatterSupport(device, (HIF_DEVICE_SCATTER_SUPPORT_INFO *)config);
+            status = SetupHIFScatterSupport(device, (struct hif_device_scatter_support_info *)config);
             if (status) {
                 device->scatter_enabled = false;
             }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index 2a56a50..567993f 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -275,7 +275,7 @@ static int HifReadWriteScatter(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
 }
 
     /* setup of HIF scatter resources */
-int SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo)
+int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support_info *pInfo)
 {
     int              status = A_ERROR;
     int                   i;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 85c5915..08e9ef2 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -132,7 +132,7 @@ struct ar6k_device {
     struct hif_device_irq_yield_params     HifIRQYieldParams;
     bool                          DSRCanYield;
     int                             CurrentDSRRecvCount;
-    HIF_DEVICE_SCATTER_SUPPORT_INFO HifScatterInfo;
+    struct hif_device_scatter_support_info HifScatterInfo;
     struct dl_list                         ScatterReqHead; 
     bool                          ScatterIsVirtual;
     int                             MaxRecvBundleSize;
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 2c0f490..61e4392 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -203,7 +203,7 @@ typedef enum {
  *   
  *   HIF_CONFIGURE_QUERY_SCATTER_REQUEST_SUPPORT
  *   input : none
- *   output : HIF_DEVICE_SCATTER_SUPPORT_INFO
+ *   output : struct hif_device_scatter_support_info
  *   note:  This query checks if the HIF layer implements the SCATTER request interface.  Scatter requests
  *   allows upper layers to submit mailbox I/O operations using a list of buffers.  This is useful for
  *   multi-message transfers that can better utilize the bus interconnect.
@@ -306,14 +306,14 @@ typedef HIF_SCATTER_REQ * ( *HIF_ALLOCATE_SCATTER_REQUEST)(HIF_DEVICE *device);
 typedef void ( *HIF_FREE_SCATTER_REQUEST)(HIF_DEVICE *device, HIF_SCATTER_REQ *request);
 typedef int ( *HIF_READWRITE_SCATTER)(HIF_DEVICE *device, HIF_SCATTER_REQ *request);
 
-typedef struct _HIF_DEVICE_SCATTER_SUPPORT_INFO {
+struct hif_device_scatter_support_info {
         /* information returned from HIF layer */
     HIF_ALLOCATE_SCATTER_REQUEST    pAllocateReqFunc;
     HIF_FREE_SCATTER_REQUEST        pFreeReqFunc;
     HIF_READWRITE_SCATTER           pReadWriteScatterFunc;    
     int                             MaxScatterEntries;
     int                             MaxTransferSizePerScatterReq;
-} HIF_DEVICE_SCATTER_SUPPORT_INFO;
+};
                       
 struct hif_device_os_device_info {
     void    *pOSDevice;
-- 
1.7.4.15.g7811d

