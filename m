Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29994 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab1CKC4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 20/20] ath6kl: remove-typedef DEV_SCATTER_DMA_VIRTUAL_INFO
Date: Thu, 10 Mar 2011 18:55:47 -0800
Message-ID: <1299812147-12069-21-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s DEV_SCATTER_DMA_VIRTUAL_INFO \
	"struct dev_scatter_dma_virtual_info" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c |   10 +++++-----
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 2797b55..a41ed12 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -585,7 +585,7 @@ void DevDumpRegisters(struct ar6k_device               *pDev,
 }
 
 
-#define DEV_GET_VIRT_DMA_INFO(p)  ((DEV_SCATTER_DMA_VIRTUAL_INFO *)((p)->HIFPrivate[0]))
+#define DEV_GET_VIRT_DMA_INFO(p)  ((struct dev_scatter_dma_virtual_info *)((p)->HIFPrivate[0]))
 
 static HIF_SCATTER_REQ *DevAllocScatterReq(HIF_DEVICE *Context)
 {
@@ -754,10 +754,10 @@ static int DevSetupVirtualScatterSupport(struct ar6k_device *pDev)
     int                     status = 0;
     int                          bufferSize, sgreqSize;
     int                          i;
-    DEV_SCATTER_DMA_VIRTUAL_INFO *pVirtualInfo;
+    struct dev_scatter_dma_virtual_info *pVirtualInfo;
     HIF_SCATTER_REQ              *pReq;
 
-    bufferSize = sizeof(DEV_SCATTER_DMA_VIRTUAL_INFO) +
+    bufferSize = sizeof(struct dev_scatter_dma_virtual_info) +
                 2 * (A_GET_CACHE_LINE_BYTES()) + AR6K_MAX_TRANSFER_SIZE_PER_SCATTER;
 
     sgreqSize = sizeof(HIF_SCATTER_REQ) +
@@ -775,8 +775,8 @@ static int DevSetupVirtualScatterSupport(struct ar6k_device *pDev)
         A_MEMZERO(pReq, sgreqSize);
 
             /* the virtual DMA starts after the scatter request struct */
-        pVirtualInfo = (DEV_SCATTER_DMA_VIRTUAL_INFO *)((u8 *)pReq + sgreqSize);
-        A_MEMZERO(pVirtualInfo, sizeof(DEV_SCATTER_DMA_VIRTUAL_INFO));
+        pVirtualInfo = (struct dev_scatter_dma_virtual_info *)((u8 *)pReq + sgreqSize);
+        A_MEMZERO(pVirtualInfo, sizeof(struct dev_scatter_dma_virtual_info));
 
         pVirtualInfo->pVirtDmaBuffer = &pVirtualInfo->DataArea[0];
             /* align buffer to cache line in case host controller can actually DMA this */
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 247cf56..3e4ece8 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -322,10 +322,10 @@ int DoMboxHWTest(struct ar6k_device *pDev);
 #endif
 
     /* completely virtual */
-typedef struct _DEV_SCATTER_DMA_VIRTUAL_INFO {
+struct dev_scatter_dma_virtual_info {
     u8 *pVirtDmaBuffer;      /* dma-able buffer - CPU accessible address */
     u8 DataArea[1];      /* start of data area */
-} DEV_SCATTER_DMA_VIRTUAL_INFO;
+};
 
 
 
-- 
1.7.4.15.g7811d

