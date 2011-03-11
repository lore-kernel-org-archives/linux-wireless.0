Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29991 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab1CKC4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:49 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 19/20] ath6kl: remove-typedef COMMON_CREDIT_STATE_INFO
Date: Thu, 10 Mar 2011 18:55:46 -0800
Message-ID: <1299812147-12069-20-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s COMMON_CREDIT_STATE_INFO \
	"struct common_credit_state_info" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/common_drv.h        |    6 +++---
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |   18 +++++++++---------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ath6kl/include/common_drv.h b/drivers/staging/ath6kl/include/common_drv.h
index 6ed4901..f5bc9c3 100644
--- a/drivers/staging/ath6kl/include/common_drv.h
+++ b/drivers/staging/ath6kl/include/common_drv.h
@@ -29,12 +29,12 @@
 /* structure that is the state information for the default credit distribution callback
  * drivers should instantiate (zero-init as well) this structure in their driver instance
  * and pass it as a context to the HTC credit distribution functions */
-typedef struct _COMMON_CREDIT_STATE_INFO {
+struct common_credit_state_info {
     int TotalAvailableCredits;      /* total credits in the system at startup */
     int CurrentFreeCredits;         /* credits available in the pool that have not been
                                        given out to endpoints */
     HTC_ENDPOINT_CREDIT_DIST *pLowestPriEpDist;  /* pointer to the lowest priority endpoint dist struct */
-} COMMON_CREDIT_STATE_INFO;
+};
 
 typedef struct {
     s32 (*setupTransport)(void *ar);
@@ -64,7 +64,7 @@ extern "C" {
 #endif
 
 /* OS-independent APIs */
-int ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, COMMON_CREDIT_STATE_INFO *pCredInfo);
+int ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, struct common_credit_state_info *pCredInfo);
 
 int ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
 
diff --git a/drivers/staging/ath6kl/miscdrv/credit_dist.c b/drivers/staging/ath6kl/miscdrv/credit_dist.c
index 68b1ed6..8c418d2 100644
--- a/drivers/staging/ath6kl/miscdrv/credit_dist.c
+++ b/drivers/staging/ath6kl/miscdrv/credit_dist.c
@@ -41,14 +41,14 @@
 #define DATA_SVCS_USED 4
 #endif
 
-static void RedistributeCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
+static void RedistributeCredits(struct common_credit_state_info *pCredInfo,
                                 HTC_ENDPOINT_CREDIT_DIST *pEPDistList);
 
-static void SeekCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
+static void SeekCredits(struct common_credit_state_info *pCredInfo,
                         HTC_ENDPOINT_CREDIT_DIST *pEPDistList);
 
 /* reduce an ep's credits back to a set limit */
-static INLINE void ReduceCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
+static INLINE void ReduceCredits(struct common_credit_state_info *pCredInfo,
                                 HTC_ENDPOINT_CREDIT_DIST  *pEpDist,
                                 int                       Limit)
 {
@@ -86,7 +86,7 @@ static void ar6000_credit_init(void                     *Context,
 {
     HTC_ENDPOINT_CREDIT_DIST *pCurEpDist;
     int                      count;
-    COMMON_CREDIT_STATE_INFO *pCredInfo = (COMMON_CREDIT_STATE_INFO *)Context;
+    struct common_credit_state_info *pCredInfo = (struct common_credit_state_info *)Context;
 
     pCredInfo->CurrentFreeCredits = TotalCredits;
     pCredInfo->TotalAvailableCredits = TotalCredits;
@@ -179,7 +179,7 @@ static void ar6000_credit_distribute(void                     *Context,
                                      HTC_CREDIT_DIST_REASON   Reason)
 {
     HTC_ENDPOINT_CREDIT_DIST *pCurEpDist;
-    COMMON_CREDIT_STATE_INFO *pCredInfo = (COMMON_CREDIT_STATE_INFO *)Context;
+    struct common_credit_state_info *pCredInfo = (struct common_credit_state_info *)Context;
 
     switch (Reason) {
         case HTC_CREDIT_DIST_SEND_COMPLETE :
@@ -243,7 +243,7 @@ static void ar6000_credit_distribute(void                     *Context,
 }
 
 /* redistribute credits based on activity change */
-static void RedistributeCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
+static void RedistributeCredits(struct common_credit_state_info *pCredInfo,
                                 HTC_ENDPOINT_CREDIT_DIST *pEPDistList)
 {
     HTC_ENDPOINT_CREDIT_DIST *pCurEpDist = pEPDistList;
@@ -283,7 +283,7 @@ static void RedistributeCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
 }
 
 /* HTC has an endpoint that needs credits, pEPDist is the endpoint in question */
-static void SeekCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
+static void SeekCredits(struct common_credit_state_info *pCredInfo,
                         HTC_ENDPOINT_CREDIT_DIST *pEPDist)
 {
     HTC_ENDPOINT_CREDIT_DIST *pCurEpDist;
@@ -393,11 +393,11 @@ static void SeekCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
 }
 
 /* initialize and setup credit distribution */
-int ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, COMMON_CREDIT_STATE_INFO *pCredInfo)
+int ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, struct common_credit_state_info *pCredInfo)
 {
     HTC_SERVICE_ID servicepriority[5];
 
-    A_MEMZERO(pCredInfo,sizeof(COMMON_CREDIT_STATE_INFO));
+    A_MEMZERO(pCredInfo,sizeof(struct common_credit_state_info));
 
     servicepriority[0] = WMI_CONTROL_SVC;  /* highest */
     servicepriority[1] = WMI_DATA_VO_SVC;
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 2c6f873..2373ed5 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -550,7 +550,7 @@ typedef struct ar6_softc {
     bool                  arNetQueueStopped;
     bool                  arRawIfInit;
     int                     arDeviceIndex;
-    COMMON_CREDIT_STATE_INFO arCreditStateInfo;
+    struct common_credit_state_info arCreditStateInfo;
     bool                  arWMIControlEpFull;
     bool                  dbgLogFetchInProgress;
     u8                 log_buffer[DBGLOG_HOST_LOG_BUFFER_SIZE];
-- 
1.7.4.15.g7811d

