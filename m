Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13016 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbbJLH7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:59:11 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 24/41] staging: wilc1000: remove typedef from tstrStatistics
Date: Mon, 12 Oct 2015 16:55:58 +0900
Message-ID: <1444636575-2486-24-git-send-email-tony.cho@atmel.com> (sfid-20151012_095916_088040_4102C92C)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrStatistics and
rename it to rf_info.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 6 +++---
 drivers/staging/wilc1000/host_interface.h         | 7 +++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fdde387..6f4eda6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2974,7 +2974,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 
 }
 
-s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrStatistics)
+s32 Handle_GetStatistics(struct host_if_drv *drvHandler, struct rf_info *pstrStatistics)
 {
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, s32Error = 0;
@@ -3987,7 +3987,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg.drv, (tstrStatistics *)msg.body.data);
+			Handle_GetStatistics(msg.drv, (struct rf_info *)msg.body.data);
 			break;
 
 		case HOST_IF_MSG_GET_CHNL:
@@ -5480,7 +5480,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, tstrStatistics *pstrStatistics)
+s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c3379ec..1097f10 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -57,14 +57,13 @@
 #define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC			2
 
-typedef struct _tstrStatistics {
+struct rf_info {
 	u8 u8LinkSpeed;
 	s8 s8RSSI;
 	u32 u32TxCount;
 	u32 u32RxCount;
 	u32 u32TxFailureCount;
-
-} tstrStatistics;
+};
 
 enum host_if_state {
 	HOST_IF_IDLE			= 0,
@@ -1176,6 +1175,6 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 
 void host_int_freeJoinParams(void *pJoinParams);
 
-s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, tstrStatistics *pstrStatistics);
+s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a5617de..dd96909 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1576,7 +1576,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (nic->iftype == STATION_MODE) {
-		tstrStatistics strStatistics;
+		struct rf_info strStatistics;
 
 		host_int_get_statistics(priv->hWILCWFIDrv, &strStatistics);
 
-- 
1.9.1

