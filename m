Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21169 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1CNSF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:05:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:05:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 26/38] ath6kl: remove-typedef HTC_SERVICE_CONNECT_REQ
Date: Mon, 14 Mar 2011 10:59:00 -0700
Message-ID: <1300125552-24422-27-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_SERVICE_CONNECT_REQ \
	"struct htc_service_connect_req" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/htc.c               |    2 +-
 drivers/staging/ath6kl/htc2/htc_services.c      |    2 +-
 drivers/staging/ath6kl/include/htc_api.h        |    6 +++---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c    |    4 ++--
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index bf4fdb3..887a687 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -229,7 +229,7 @@ int HTCWaitTarget(HTC_HANDLE HTCHandle)
     struct htc_packet              *pPacket = NULL;
     HTC_READY_EX_MSG        *pRdyMsg;
 
-    HTC_SERVICE_CONNECT_REQ  connect;
+    struct htc_service_connect_req  connect;
     HTC_SERVICE_CONNECT_RESP resp;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC, ("HTCWaitTarget - Enter (target:0x%lX) \n", (unsigned long)target));
diff --git a/drivers/staging/ath6kl/htc2/htc_services.c b/drivers/staging/ath6kl/htc2/htc_services.c
index cb0731f..5c092fd 100644
--- a/drivers/staging/ath6kl/htc2/htc_services.c
+++ b/drivers/staging/ath6kl/htc2/htc_services.c
@@ -122,7 +122,7 @@ int HTCSendSetupComplete(HTC_TARGET *target)
 
 
 int HTCConnectService(HTC_HANDLE               HTCHandle,
-                           HTC_SERVICE_CONNECT_REQ  *pConnectReq,
+                           struct htc_service_connect_req  *pConnectReq,
                            HTC_SERVICE_CONNECT_RESP *pConnectResp)
 {
     HTC_TARGET *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
diff --git a/drivers/staging/ath6kl/include/htc_api.h b/drivers/staging/ath6kl/include/htc_api.h
index ae41f98..f8f00a0 100644
--- a/drivers/staging/ath6kl/include/htc_api.h
+++ b/drivers/staging/ath6kl/include/htc_api.h
@@ -139,7 +139,7 @@ struct htc_ep_callbacks {
 };
 
 /* service connection information */
-typedef struct _HTC_SERVICE_CONNECT_REQ {
+struct htc_service_connect_req {
     HTC_SERVICE_ID   ServiceID;                 /* service ID to connect to */
     u16 ConnectionFlags;           /* connection flags, see htc protocol definition */
     u8 *pMetaData;                 /* ptr to optional service-specific meta-data */
@@ -148,7 +148,7 @@ typedef struct _HTC_SERVICE_CONNECT_REQ {
     int              MaxSendQueueDepth;         /* maximum depth of any send queue */
     u32 LocalConnectionFlags;      /* HTC flags for the host-side (local) connection */
     unsigned int     MaxSendMsgSize;            /* override max message size in send direction */
-} HTC_SERVICE_CONNECT_REQ;
+};
 
 #define HTC_LOCAL_CONN_FLAGS_ENABLE_SEND_BUNDLE_PADDING (1 << 0)  /* enable send bundle padding for this endpoint */
 
@@ -362,7 +362,7 @@ int    HTCAddReceivePkt(HTC_HANDLE HTCHandle, struct htc_packet *pPacket);
   @see also: HTCStart
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 int    HTCConnectService(HTC_HANDLE HTCHandle,
-                              HTC_SERVICE_CONNECT_REQ  *pReq,
+                              struct htc_service_connect_req  *pReq,
                               HTC_SERVICE_CONNECT_RESP *pResp);
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Send an HTC packet
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index fab1e02..a7c57e3 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2339,7 +2339,7 @@ ar6000_close(struct net_device *dev)
 
 /* connect to a service */
 static int ar6000_connectservice(AR_SOFTC_T               *ar,
-                                      HTC_SERVICE_CONNECT_REQ  *pConnect,
+                                      struct htc_service_connect_req  *pConnect,
                                       char *pDesc)
 {
     int                 status;
@@ -2605,7 +2605,7 @@ int ar6000_init(struct net_device *dev)
     }
 
     do {
-        HTC_SERVICE_CONNECT_REQ connect;
+        struct htc_service_connect_req connect;
 
             /* the reason we have to wait for the target here is that the driver layer
              * has to init BMI in order to set the host block size,
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
index f8637f6..35de2fb 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
@@ -117,7 +117,7 @@ static int ar6000_connect_raw_service(AR_SOFTC_T        *ar,
     int                 status;
     HTC_SERVICE_CONNECT_RESP response;
     u8 streamNo;
-    HTC_SERVICE_CONNECT_REQ  connect;
+    struct htc_service_connect_req  connect;
     
     do {      
         
-- 
1.7.4.15.g7811d

