Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53992 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab1BRVOM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:12 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:51 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 08/15] staging: ath6kl: Fixing a memory leak
Date: Fri, 18 Feb 2011 13:13:09 -0800
Message-ID: <1298063596-2096-8-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Virtual Scatter Gather Lists not getting freed during the HTCStop(). The
patch adds some clean up code in the code path.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c |    9 +++++++++
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h |    2 ++
 drivers/staging/ath6kl/htc2/htc.c         |    2 ++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 6083231..ff0480b 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -810,6 +810,15 @@ static int DevSetupVirtualScatterSupport(AR6K_DEVICE *pDev)
     return status;
 }
 
+int DevCleanupMsgBundling(AR6K_DEVICE *pDev)
+{
+    if(NULL != pDev)
+    {
+        DevCleanupVirtualScatterSupport(pDev);
+    }
+
+    return 0;
+}
 
 int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
 {
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index d3b6b30..19d8e70 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -297,6 +297,8 @@ static INLINE int DEV_PREPARE_SCATTER_OPERATION(HIF_SCATTER_REQ *pReq)  {
         
     
 int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer);
+
+int DevCleanupMsgBundling(AR6K_DEVICE *pDev);
                                   
 #define DEV_GET_MAX_MSG_PER_BUNDLE(pDev)        (pDev)->HifScatterInfo.MaxScatterEntries
 #define DEV_GET_MAX_BUNDLE_LENGTH(pDev)         (pDev)->HifScatterInfo.MaxTransferSizePerScatterReq
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index 684eca9..e7adc45 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -486,6 +486,8 @@ void HTCStop(HTC_HANDLE HTCHandle)
         /* flush all recv buffers */
     HTCFlushRecvBuffers(target);
 
+    DevCleanupMsgBundling(&target->Device);
+
     ResetEndpointStates(target);
    
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC, ("-HTCStop \n"));
-- 
1.6.3.3

