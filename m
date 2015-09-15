Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:56647 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbbIOCyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 22:54:02 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/7] staging: wilc1000: remove definition WILC_ERRORCHECK
Date: Tue, 15 Sep 2015 11:53:37 +0900
Message-ID: <1442285621-29457-4-git-send-email-tony.cho@atmel.com> (sfid-20150915_045406_319348_C8CC813E)
In-Reply-To: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
References: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the definition WILC_ERRORCHECK which is not used
anymore and replaces PRINT_ER with printk.

There are build warnings from some functions because WILC_CATCH definition is
not used. So, this patch also removes WILC_CATCH from the functions.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  3 ++-
 drivers/staging/wilc1000/wilc_errorsupport.h      |  7 -------
 drivers/staging/wilc1000/wilc_msgqueue.c          |  5 ++++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 24 ++++++++---------------
 4 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 29491f6..273d547 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7250,7 +7250,8 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	WILC_ERRORCHECK(s32Error);
+	if (s32Error)
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
 	WILC_CATCH(s32Error)
 	{
diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
index 42495d9..769cef0 100644
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ b/drivers/staging/wilc1000/wilc_errorsupport.h
@@ -38,13 +38,6 @@
 
 
 
-#define WILC_ERRORCHECK(__status__) do { \
-		if (__status__ < WILC_SUCCESS) { \
-			PRINT_ER("PRINT_ER(%d)\n", __status__);	\
-			goto ERRORHANDLER; \
-		} \
-} while (0)
-
 #define WILC_ERRORREPORT(__status__, __err__) do { \
 		PRINT_ER("PRINT_ER(%d)\n", __err__); \
 		__status__ = __err__; \
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index f3d0d34..2f77e71 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -145,7 +145,10 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 	} else {
 		/* other non-timeout scenarios */
-		WILC_ERRORCHECK(s32RetStatus);
+		if (s32RetStatus) {
+			printk(KERN_ERR "%s: %d\n", __func__, s32RetStatus);
+			return s32RetStatus;
+		}
 
 		if (pHandle->bExiting) {
 			WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a182bdb..7083c77 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3308,11 +3308,9 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	s32Error = host_int_del_beacon(priv->hWILCWFIDrv);
 
-	WILC_ERRORCHECK(s32Error);
+	if (s32Error)
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
-	WILC_CATCH(s32Error)
-	{
-	}
 	return s32Error;
 }
 
@@ -3378,12 +3376,10 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
 		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
-		WILC_ERRORCHECK(s32Error);
+		if (s32Error)
+			printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 	}
 
-	WILC_CATCH(s32Error)
-	{
-	}
 	return s32Error;
 }
 
@@ -3423,10 +3419,8 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 		s32Error = host_int_del_station(priv->hWILCWFIDrv, mac);
 
-		WILC_ERRORCHECK(s32Error);
-	}
-	WILC_CATCH(s32Error)
-	{
+		if (s32Error)
+			printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 	}
 	return s32Error;
 }
@@ -3494,10 +3488,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
 		s32Error = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
-		WILC_ERRORCHECK(s32Error);
-	}
-	WILC_CATCH(s32Error)
-	{
+		if (s32Error)
+			printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 	}
 	return s32Error;
 }
-- 
1.9.1

