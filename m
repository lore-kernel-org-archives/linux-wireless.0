Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23692 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1CNSTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:19:45 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:19:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/38] ath6kl: remove-typedef HIF_SCATTER_ITEM
Date: Mon, 14 Mar 2011 11:04:24 -0700
Message-ID: <1300125864-24652-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_SCATTER_ITEM \
	"struct hif_scatter_item" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |    2 +-
 drivers/staging/ath6kl/include/hif.h               |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index 567993f..196d33d 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -306,7 +306,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
             pReqPriv->device = device;      
                 /* allocate the scatter request */
             pReqPriv->pHifScatterReq = (HIF_SCATTER_REQ *)A_MALLOC(sizeof(HIF_SCATTER_REQ) + 
-                                         (MAX_SCATTER_ENTRIES_PER_REQ - 1) * (sizeof(HIF_SCATTER_ITEM))); 
+                                         (MAX_SCATTER_ENTRIES_PER_REQ - 1) * (sizeof(struct hif_scatter_item))); 
            
             if (NULL == pReqPriv->pHifScatterReq) {
                 A_FREE(pReqPriv);
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index f9f411a..3ebf630 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -761,7 +761,7 @@ static int DevSetupVirtualScatterSupport(struct ar6k_device *pDev)
                 2 * (A_GET_CACHE_LINE_BYTES()) + AR6K_MAX_TRANSFER_SIZE_PER_SCATTER;
 
     sgreqSize = sizeof(HIF_SCATTER_REQ) +
-                    (AR6K_SCATTER_ENTRIES_PER_REQ - 1) * (sizeof(HIF_SCATTER_ITEM));
+                    (AR6K_SCATTER_ENTRIES_PER_REQ - 1) * (sizeof(struct hif_scatter_item));
 
     for (i = 0; i < AR6K_SCATTER_REQS; i++) {
             /* allocate the scatter request, buffer info and the actual virtual buffer itself */
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 8d0c94e..427e7b8 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -270,11 +270,11 @@ struct hif_device_irq_yield_params {
 };
 
 
-typedef struct _HIF_SCATTER_ITEM {
+struct hif_scatter_item {
     u8 *pBuffer;             /* CPU accessible address of buffer */
     int          Length;              /* length of transfer to/from this buffer */
     void        *pCallerContexts[2];  /* space for caller to insert a context associated with this item */
-} HIF_SCATTER_ITEM;
+};
 
 struct _HIF_SCATTER_REQ;
 
@@ -299,7 +299,7 @@ typedef struct _HIF_SCATTER_REQ {
     HIF_SCATTER_METHOD  ScatterMethod;        /* scatter method handled by HIF */  
     void                *HIFPrivate[4];     /* HIF private area */
     u8 *pScatterBounceBuffer;  /* bounce buffer for upper layers to copy to/from */
-    HIF_SCATTER_ITEM    ScatterList[1];     /* start of scatter list */
+    struct hif_scatter_item    ScatterList[1];     /* start of scatter list */
 } HIF_SCATTER_REQ;
 
 typedef HIF_SCATTER_REQ * ( *HIF_ALLOCATE_SCATTER_REQUEST)(HIF_DEVICE *device);
-- 
1.7.4.15.g7811d

