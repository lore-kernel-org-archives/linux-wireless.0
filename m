Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13194 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbbJLH7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:59:37 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 28/41] staging: wilc1000: remove typedef from tenuScanConnTimer
Date: Mon, 12 Oct 2015 16:56:02 +0900
Message-ID: <1444636575-2486-28-git-send-email-tony.cho@atmel.com> (sfid-20151012_095939_716397_FC53067A)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the enum tenuScanConnTimer and
renames it to scan_conn_timer.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 54b2a61..6826298 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -436,11 +436,11 @@ struct join_bss_param {
 	u8 au8StartTime[4];
 };
 
-typedef enum {
+enum scan_conn_timer {
 	SCAN_TIMER = 0,
 	CONNECT_TIMER	= 1,
 	SCAN_CONNECT_TIMER_FORCE_32BIT = 0xFFFFFFFF
-} tenuScanConnTimer;
+};
 
 /*****************************************************************************/
 /*																			 */
@@ -4872,7 +4872,7 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 	s32 s32Error = 0;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
-	tenuScanConnTimer enuScanConnTimer;
+	enum scan_conn_timer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
 		s32Error = -EFAULT;
@@ -5530,7 +5530,7 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 	s32 s32Error = 0;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
-	tenuScanConnTimer enuScanConnTimer;
+	enum scan_conn_timer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || ScanResult == NULL) {
 		PRINT_ER("pstrWFIDrv or ScanResult = NULL\n");
-- 
1.9.1

