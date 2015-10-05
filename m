Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8615 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbJEG0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:09 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/18] staging: wilc1000: rename tWILCpfScanResult
Date: Mon, 5 Oct 2015 15:25:36 +0900
Message-ID: <1444026353-29024-1-git-send-email-tony.cho@atmel.com> (sfid-20151005_082613_551989_01961B42)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames tWILCpfScanResult to wilc_scan_result.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9f715cf..86fa968 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -167,7 +167,7 @@ struct scan_attr {
 	u8 u8ChnlListLen;
 	u8 *pu8IEs;
 	size_t IEsLen;
-	tWILCpfScanResult pfScanResult;
+	wilc_scan_result pfScanResult;
 	void *pvUserArg;
 	tstrHiddenNetwork strHiddenNetwork;
 };
@@ -5715,7 +5715,7 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
 s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
-			  size_t IEsLen, tWILCpfScanResult ScanResult,
+			  size_t IEsLen, wilc_scan_result ScanResult,
 			  void *pvUserArg, tstrHiddenNetwork  *pstrHiddenNetwork)
 {
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index bc8acde..c9ea34e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -181,7 +181,7 @@ typedef enum {
 
 
 /*Scan callBack function definition*/
-typedef void (*tWILCpfScanResult)(tenuScanEvent, tstrNetworkInfo *, void *, void *);
+typedef void (*wilc_scan_result)(tenuScanEvent, tstrNetworkInfo *, void *, void *);
 
 /*Connect callBack function definition*/
 typedef void (*tWILCpfConnectResult)(tenuConnDisconnEvent,
@@ -228,7 +228,7 @@ typedef struct _tstrHiddenNetwork {
 
 typedef struct {
 	/* Scan user call back function */
-	tWILCpfScanResult pfUserScanResult;
+	wilc_scan_result pfUserScanResult;
 
 	/* User specific parameter to be delivered through the Scan User Callback function */
 	void *u32UserScanPvoid;
@@ -872,7 +872,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd);
 s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
-			  size_t IEsLen, tWILCpfScanResult ScanResult,
+			  size_t IEsLen, wilc_scan_result ScanResult,
 			  void *pvUserArg, tstrHiddenNetwork *pstrHiddenNetwork);
 /**
  *  @brief              sets configuration wids values
-- 
1.9.1

