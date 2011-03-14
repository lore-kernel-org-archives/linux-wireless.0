Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20513 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab1CNR7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:45 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 22/38] ath6kl: remove-typedef HTC_INIT_INFO
Date: Mon, 14 Mar 2011 10:58:56 -0700
Message-ID: <1300125552-24422-23-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_INIT_INFO \
	"struct htc_init_info" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/htc.c            |    4 ++--
 drivers/staging/ath6kl/htc2/htc_internal.h   |    2 +-
 drivers/staging/ath6kl/include/htc_api.h     |    6 +++---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index 2a065b4..810fe7b 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -90,7 +90,7 @@ static void HTCCleanup(HTC_TARGET *target)
 }
 
 /* registered target arrival callback from the HIF layer */
-HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
+HTC_HANDLE HTCCreate(void *hif_handle, struct htc_init_info *pInfo)
 {
     HTC_TARGET              *target = NULL;
     int                 status = 0;
@@ -130,7 +130,7 @@ HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
         target->Device.MessagePendingCallback = HTCRecvMessagePendingHandler;
         target->EpWaitingForBuffers = ENDPOINT_MAX;
 
-        memcpy(&target->HTCInitInfo,pInfo,sizeof(HTC_INIT_INFO));
+        memcpy(&target->HTCInitInfo,pInfo,sizeof(struct htc_init_info));
         
         ResetEndpointStates(target);
           
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index deff62a..c5727ca 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -132,7 +132,7 @@ typedef struct _HTC_TARGET {
     u8 LastTrailer[256];
     u8 LastTrailerLength;
 #endif
-    HTC_INIT_INFO               HTCInitInfo;
+    struct htc_init_info               HTCInitInfo;
     u8 HTCTargetVersion;
     int                         MaxMsgPerBundle;       /* max messages per bundle for HTC */
     bool                      SendBundlingEnabled;   /* run time enable for send bundling (dynamic) */
diff --git a/drivers/staging/ath6kl/include/htc_api.h b/drivers/staging/ath6kl/include/htc_api.h
index ad25d3e..5878417 100644
--- a/drivers/staging/ath6kl/include/htc_api.h
+++ b/drivers/staging/ath6kl/include/htc_api.h
@@ -43,10 +43,10 @@ typedef void *HTC_HANDLE;
 
 typedef u16 HTC_SERVICE_ID;
 
-typedef struct _HTC_INIT_INFO {
+struct htc_init_info {
     void   *pContext;           /* context for target failure notification */
     void   (*TargetFailure)(void *Instance, int Status);
-} HTC_INIT_INFO;
+};
 
 /* per service connection send completion */
 typedef void   (*HTC_EP_SEND_PKT_COMPLETE)(void *,HTC_PACKET *);
@@ -269,7 +269,7 @@ struct htc_endpoint_stats {
   @example:
   @see also: HTCDestroy
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-HTC_HANDLE HTCCreate(void *HifDevice, HTC_INIT_INFO *pInfo);
+HTC_HANDLE HTCCreate(void *HifDevice, struct htc_init_info *pInfo);
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Get the underlying HIF device handle
   @function name: HTCGetHifDevice
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index b739943..ebfe1e8 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1599,7 +1599,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
     void *ar_netif;
     AR_SOFTC_T *ar;
     int device_index = 0;
-    HTC_INIT_INFO  htcInfo;
+    struct htc_init_info  htcInfo;
 #ifdef ATH6K_CONFIG_CFG80211
     struct wireless_dev *wdev;
 #endif /* ATH6K_CONFIG_CFG80211 */
-- 
1.7.4.15.g7811d

