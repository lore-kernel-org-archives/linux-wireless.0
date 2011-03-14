Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20479 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab1CNR7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 12/38] ath6kl: remove-typedef HIF_PENDING_EVENTS_INFO
Date: Mon, 14 Mar 2011 10:58:46 -0700
Message-ID: <1300125552-24422-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_PENDING_EVENTS_INFO \
	"struct hif_pending_events_info" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/bmi/src/bmi.c             |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c |    8 ++++----
 drivers/staging/ath6kl/include/hif.h             |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index a9615b7..34d1bef 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -790,7 +790,7 @@ bmiBufferReceive(HIF_DEVICE *device,
     int status;
     u32 address;
     u32 mboxAddress[HTC_MAILBOX_NUM_MAX];
-    HIF_PENDING_EVENTS_INFO     hifPendingEvents;
+    struct hif_pending_events_info     hifPendingEvents;
     static HIF_PENDING_EVENTS_FUNC getPendingEventsFunc = NULL;
     
     if (!pendingEventsFuncCheck) {
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index bac4f93..ca6abb4 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -74,7 +74,7 @@ int DevPollMboxMsgRecv(struct ar6k_device *pDev,
 
         if (pDev->GetPendingEventsFunc != NULL) {
 
-            HIF_PENDING_EVENTS_INFO events;
+            struct hif_pending_events_info events;
 
 #ifdef THREAD_X
 			events.Polling =1;
@@ -319,7 +319,7 @@ static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
 
         if (pDev->GetPendingEventsFunc != NULL) {
                 /* the HIF layer collected the information for us */
-            HIF_PENDING_EVENTS_INFO *pEvents = (HIF_PENDING_EVENTS_INFO *)pPacket->pBuffer;
+            struct hif_pending_events_info *pEvents = (struct hif_pending_events_info *)pPacket->pBuffer;
             if (pEvents->Events & HIF_RECV_MSG_AVAIL) {
                 lookAhead = pEvents->LookAhead;
                 if (0 == lookAhead) {
@@ -439,7 +439,7 @@ int DevCheckPendingRecvMsgsAsync(void *context)
         if (pDev->GetPendingEventsFunc) {
                 /* HIF layer has it's own mechanism, pass the IO to it.. */
             status = pDev->GetPendingEventsFunc(pDev->HIFDevice,
-                                                (HIF_PENDING_EVENTS_INFO *)pIOPacket->pBuffer,
+                                                (struct hif_pending_events_info *)pIOPacket->pBuffer,
                                                 pIOPacket);
 
         } else {
@@ -490,7 +490,7 @@ static int ProcessPendingIRQs(struct ar6k_device *pDev, bool *pDone, bool *pASyn
             }
 
             if (pDev->GetPendingEventsFunc != NULL) {
-                HIF_PENDING_EVENTS_INFO events;
+                struct hif_pending_events_info events;
 
 #ifdef THREAD_X
             events.Polling= 0;
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 4f9be8a..8d0c94e 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -343,7 +343,7 @@ typedef struct osdrv_callbacks {
                                            needs to read the register table to figure out what */
 #define HIF_RECV_MSG_AVAIL   (1 << 1)   /* pending recv packet */
 
-typedef struct _HIF_PENDING_EVENTS_INFO {
+struct hif_pending_events_info {
     u32 Events;
     u32 LookAhead;
     u32 AvailableRecvBytes;
@@ -351,12 +351,12 @@ typedef struct _HIF_PENDING_EVENTS_INFO {
     u32 Polling;
     u32 INT_CAUSE_REG;
 #endif
-} HIF_PENDING_EVENTS_INFO;
+};
 
     /* function to get pending events , some HIF modules use special mechanisms
      * to detect packet available and other interrupts */
 typedef int ( *HIF_PENDING_EVENTS_FUNC)(HIF_DEVICE              *device,
-                                             HIF_PENDING_EVENTS_INFO *pEvents,
+                                             struct hif_pending_events_info *pEvents,
                                              void                    *AsyncContext);
 
 #define HIF_MASK_RECV    true
-- 
1.7.4.15.g7811d

