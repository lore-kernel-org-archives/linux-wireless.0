Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20506 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab1CNR7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:41 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 20/38] ath6kl: remove-typedef HTC_EP_CALLBACKS
Date: Mon, 14 Mar 2011 10:58:54 -0700
Message-ID: <1300125552-24422-21-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_EP_CALLBACKS \
	"struct htc_ep_callbacks" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/htc_internal.h |    2 +-
 drivers/staging/ath6kl/include/htc_api.h   |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index 0e363a8..d574015 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -72,7 +72,7 @@ struct htc_endpoint {
     HTC_PACKET_QUEUE            TxQueue;        /* HTC frame buffer TX queue */
     HTC_PACKET_QUEUE            RxBuffers;      /* HTC frame buffer RX list */
     struct htc_endpoint_credit_dist    CreditDist;     /* credit distribution structure (exposed to driver layer) */
-    HTC_EP_CALLBACKS            EpCallBacks;    /* callbacks associated with this endpoint */
+    struct htc_ep_callbacks            EpCallBacks;    /* callbacks associated with this endpoint */
     int                         MaxTxQueueDepth;   /* max depth of the TX queue before we need to
                                                       call driver's full handler */
     int                         MaxMsgLength;        /* max length of endpoint message */
diff --git a/drivers/staging/ath6kl/include/htc_api.h b/drivers/staging/ath6kl/include/htc_api.h
index db3cbcf9..ad25d3e 100644
--- a/drivers/staging/ath6kl/include/htc_api.h
+++ b/drivers/staging/ath6kl/include/htc_api.h
@@ -116,7 +116,7 @@ typedef enum _HTC_SEND_FULL_ACTION {
  * must ONLY inspect the packet, it may not free or reclaim the packet. */
 typedef HTC_SEND_FULL_ACTION (*HTC_EP_SEND_QUEUE_FULL)(void *, HTC_PACKET *pPacket);
 
-typedef struct _HTC_EP_CALLBACKS {
+struct htc_ep_callbacks {
     void                     *pContext;     /* context for each callback */
     HTC_EP_SEND_PKT_COMPLETE EpTxComplete;  /* tx completion callback for connected endpoint */
     HTC_EP_RECV_PKT          EpRecv;        /* receive callback for connected endpoint */
@@ -136,7 +136,7 @@ typedef struct _HTC_EP_CALLBACKS {
                                                        when the recv queue drops below this value 
                                                        if set to 0, the refill is only called when packets 
                                                        are empty */
-} HTC_EP_CALLBACKS;
+};
 
 /* service connection information */
 typedef struct _HTC_SERVICE_CONNECT_REQ {
@@ -144,7 +144,7 @@ typedef struct _HTC_SERVICE_CONNECT_REQ {
     u16 ConnectionFlags;           /* connection flags, see htc protocol definition */
     u8 *pMetaData;                 /* ptr to optional service-specific meta-data */
     u8 MetaDataLength;            /* optional meta data length */
-    HTC_EP_CALLBACKS EpCallbacks;               /* endpoint callbacks */
+    struct htc_ep_callbacks EpCallbacks;               /* endpoint callbacks */
     int              MaxSendQueueDepth;         /* maximum depth of any send queue */
     u32 LocalConnectionFlags;      /* HTC flags for the host-side (local) connection */
     unsigned int     MaxSendMsgSize;            /* override max message size in send direction */
-- 
1.7.4.15.g7811d

