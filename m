Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32791 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbbJHBuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:50:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/14] staging: wilc1000: remove typedef from tenuScanConnTimer
Date: Thu, 8 Oct 2015 10:49:19 +0900
Message-ID: <1444268961-7551-12-git-send-email-tony.cho@atmel.com> (sfid-20151008_035056_768907_83AEF0CD)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
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
index ebca521..b8b39b2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -435,11 +435,11 @@ struct join_bss_param {
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
@@ -4876,7 +4876,7 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 	s32 s32Error = 0;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
-	tenuScanConnTimer enuScanConnTimer;
+	enum scan_conn_timer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
 		s32Error = -EFAULT;
@@ -5583,7 +5583,7 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 	s32 s32Error = 0;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
-	tenuScanConnTimer enuScanConnTimer;
+	enum scan_conn_timer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || ScanResult == NULL) {
 		PRINT_ER("pstrWFIDrv or ScanResult = NULL\n");
-- 
1.9.1

