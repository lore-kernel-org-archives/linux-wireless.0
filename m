Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8642 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:22 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/18] staging: wilc1000: rename tWILCpfConnectResult
Date: Mon, 5 Oct 2015 15:25:38 +0900
Message-ID: <1444026353-29024-3-git-send-email-tony.cho@atmel.com> (sfid-20151005_082625_071682_51546A17)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames tWILCpfConnectResult to wilc_connect_result.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b9b57ca..2e2a7819 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -189,7 +189,7 @@ struct connect_attr {
 	u8 *pu8IEs;
 	size_t IEsLen;
 	u8 u8security;
-	tWILCpfConnectResult pfConnectResult;
+	wilc_connect_result pfConnectResult;
 	void *pvUserArg;
 	AUTHTYPE_T tenuAuth_type;
 	u8 u8channel;
@@ -4999,7 +4999,7 @@ s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource)
 s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
-				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
+				  wilc_connect_result pfConnectResult, void *pvUserArg,
 				  u8 u8security, AUTHTYPE_T tenuAuth_type,
 				  u8 u8channel,
 				  void *pJoinParams)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 458b1e1..bed8f98 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -184,7 +184,7 @@ typedef enum {
 typedef void (*wilc_scan_result)(tenuScanEvent, tstrNetworkInfo *, void *, void *);
 
 /*Connect callBack function definition*/
-typedef void (*tWILCpfConnectResult)(tenuConnDisconnEvent,
+typedef void (*wilc_connect_result)(tenuConnDisconnEvent,
 				     tstrConnectInfo *,
 				     u8,
 				     tstrDisconnectNotifInfo *,
@@ -245,7 +245,7 @@ typedef struct {
 	u8 *pu8ConnReqIEs;
 	size_t ConnReqIEsLen;
 	/* Connect user call back function */
-	tWILCpfConnectResult pfUserConnectResult;
+	wilc_connect_result pfUserConnectResult;
 	bool IsHTCapable;
 	/* User specific parameter to be delivered through the Connect User Callback function */
 	void *u32UserConnectPvoid;
@@ -698,7 +698,7 @@ s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource);
 s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
-				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
+				  wilc_connect_result pfConnectResult, void *pvUserArg,
 				  u8 u8security, AUTHTYPE_T tenuAuth_type,
 				  u8 u8channel,
 				  void *pJoinParams);
-- 
1.9.1

