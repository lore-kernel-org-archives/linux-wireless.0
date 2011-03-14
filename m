Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20483 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024Ab1CNR7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:32 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 14/38] ath6kl: remove-typedef HIF_SCATTER_REQ_PRIV
Date: Mon, 14 Mar 2011 10:58:48 -0700
Message-ID: <1300125552-24422-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_SCATTER_REQ_PRIV \
	"struct hif_scatter_req_priv" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../hif/sdio/linux_sdio/include/hif_internal.h     |    8 +++-----
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   14 +++++++-------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
index e2d2266..99885e3 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
@@ -47,8 +47,6 @@
 #define HIF_MBOX2_BLOCK_SIZE               HIF_MBOX_BLOCK_SIZE
 #define HIF_MBOX3_BLOCK_SIZE               HIF_MBOX_BLOCK_SIZE
 
-struct _HIF_SCATTER_REQ_PRIV;
-
 typedef struct bus_request {
     struct bus_request *next;       /* link list of available requests */
     struct bus_request *inusenext;  /* link list of in use requests */
@@ -59,7 +57,7 @@ typedef struct bus_request {
     u32 request;
     void *context;
     int status;
-    struct _HIF_SCATTER_REQ_PRIV *pScatterReq;      /* this request is a scatter request */
+    struct hif_scatter_req_priv *pScatterReq;      /* this request is a scatter request */
 } BUS_REQUEST;
 
 struct hif_device {
@@ -100,13 +98,13 @@ void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest);
 #define MAX_SCATTER_ENTRIES_PER_REQ      16
 #define MAX_SCATTER_REQ_TRANSFER_SIZE    32*1024
 
-typedef struct _HIF_SCATTER_REQ_PRIV {
+struct hif_scatter_req_priv {
     HIF_SCATTER_REQ     *pHifScatterReq;  /* HIF scatter request with allocated entries */   
     HIF_DEVICE          *device;          /* this device */
     BUS_REQUEST         *busrequest;      /* request associated with request */
         /* scatter list for linux */    
     struct scatterlist  sgentries[MAX_SCATTER_ENTRIES_PER_REQ];   
-} HIF_SCATTER_REQ_PRIV;
+};
 
 #define ATH_DEBUG_SCATTER  ATH_DEBUG_MAKE_MODULE_MASK(0)
 
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index 196d33d..9f07040 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -87,7 +87,7 @@ int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
     struct mmc_request      mmcreq;
     struct mmc_command      cmd;
     struct mmc_data         data;
-    HIF_SCATTER_REQ_PRIV   *pReqPriv;   
+    struct hif_scatter_req_priv   *pReqPriv;   
     HIF_SCATTER_REQ        *pReq;       
     int                status = 0;
     struct                  scatterlist *pSg;
@@ -203,7 +203,7 @@ static int HifReadWriteScatter(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
 {
     int             status = A_EINVAL;
     u32 request = pReq->Request;
-    HIF_SCATTER_REQ_PRIV *pReqPriv = (HIF_SCATTER_REQ_PRIV *)pReq->HIFPrivate[0];
+    struct hif_scatter_req_priv *pReqPriv = (struct hif_scatter_req_priv *)pReq->HIFPrivate[0];
     
     do {
         
@@ -279,7 +279,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
 {
     int              status = A_ERROR;
     int                   i;
-    HIF_SCATTER_REQ_PRIV *pReqPriv;
+    struct hif_scatter_req_priv *pReqPriv;
     BUS_REQUEST          *busrequest;
         
     do {
@@ -297,11 +297,11 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
         
         for (i = 0; i < MAX_SCATTER_REQUESTS; i++) {    
                 /* allocate the private request blob */
-            pReqPriv = (HIF_SCATTER_REQ_PRIV *)A_MALLOC(sizeof(HIF_SCATTER_REQ_PRIV));
+            pReqPriv = (struct hif_scatter_req_priv *)A_MALLOC(sizeof(struct hif_scatter_req_priv));
             if (NULL == pReqPriv) {
                 break;    
             }
-            A_MEMZERO(pReqPriv, sizeof(HIF_SCATTER_REQ_PRIV));
+            A_MEMZERO(pReqPriv, sizeof(struct hif_scatter_req_priv));
                 /* save the device instance*/
             pReqPriv->device = device;      
                 /* allocate the scatter request */
@@ -358,7 +358,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
     /* clean up scatter support */
 void CleanupHIFScatterResources(HIF_DEVICE *device)
 {
-    HIF_SCATTER_REQ_PRIV    *pReqPriv;
+    struct hif_scatter_req_priv    *pReqPriv;
     HIF_SCATTER_REQ         *pReq;
     
         /* empty the free list */
@@ -371,7 +371,7 @@ void CleanupHIFScatterResources(HIF_DEVICE *device)
             break;    
         }   
         
-        pReqPriv = (HIF_SCATTER_REQ_PRIV *)pReq->HIFPrivate[0];
+        pReqPriv = (struct hif_scatter_req_priv *)pReq->HIFPrivate[0];
         A_ASSERT(pReqPriv != NULL);
         
         if (pReqPriv->busrequest != NULL) {
-- 
1.7.4.15.g7811d

