Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32723 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbJHBud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:50:33 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/14] staging: wilc1000: remove typedef from tenuScanEvent
Date: Thu, 8 Oct 2015 10:49:16 +0900
Message-ID: <1444268961-7551-9-git-send-email-tony.cho@atmel.com> (sfid-20151008_035036_051089_21448C95)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the enum tenuScanEvent and
rename it to scan_event.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/host_interface.h         | 15 +++++++++------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e6e79c7..ebca521 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1370,7 +1370,7 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEvent)
+static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEvent)
 {
 	s32 s32Error = 0;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d01bb8e..8e20c30 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -153,10 +153,12 @@ struct found_net_info {
 	s8 s8rssi;
 };
 
-typedef enum {SCAN_EVENT_NETWORK_FOUND  = 0,
-	      SCAN_EVENT_DONE = 1,
-	      SCAN_EVENT_ABORTED = 2,
-	      SCAN_EVENT_FORCE_32BIT  = 0xFFFFFFFF} tenuScanEvent;
+enum scan_event {
+	SCAN_EVENT_NETWORK_FOUND	= 0,
+	SCAN_EVENT_DONE			= 1,
+	SCAN_EVENT_ABORTED		= 2,
+	SCAN_EVENT_FORCE_32BIT		= 0xFFFFFFFF
+};
 
 typedef enum {
 	CONN_DISCONN_EVENT_CONN_RESP		= 0,
@@ -173,7 +175,8 @@ enum KEY_TYPE {
 
 
 /*Scan callBack function definition*/
-typedef void (*wilc_scan_result)(tenuScanEvent, tstrNetworkInfo *, void *, void *);
+typedef void (*wilc_scan_result)(enum scan_event, tstrNetworkInfo *,
+				  void *, void *);
 
 /*Connect callBack function definition*/
 typedef void (*wilc_connect_result)(tenuConnDisconnEvent,
@@ -1171,7 +1174,7 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool
 s32 host_int_set_wfi_drv_handler(struct host_if_drv *u32address);
 s32 host_int_set_operation_mode(struct host_if_drv *hWFIDrv, u32 u32mode);
 
-static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEvent);
+static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEvent);
 
 void host_int_freeJoinParams(void *pJoinParams);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d5b0214..d39ef0b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -357,7 +357,7 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
  *  @date
  *  @version	1.0
  */
-static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
+static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
-- 
1.9.1

