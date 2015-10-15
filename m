Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6578 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbbJOE3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:29:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 38/40] staging: wilc1000: fixes unnecessary variable replacement
Date: Thu, 15 Oct 2015 13:25:19 +0900
Message-ID: <1444883121-31757-38-git-send-email-tony.cho@atmel.com> (sfid-20151015_062948_865832_1ED42123)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes an unnecessary variable use for the errors and
returns errors directly without a result variable.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2d771f5..1898f18 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3200,9 +3200,8 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3237,9 +3236,8 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	u8 i;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3279,9 +3277,8 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	u32 i;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
@@ -3344,9 +3341,8 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
@@ -3403,9 +3399,8 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3548,9 +3543,8 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	enum scan_conn_timer enuScanConnTimer;
 
 	if (!hif_drv || pfConnectResult == NULL) {
-		result = -EFAULT;
 		PRINT_ER("Driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	if (pJoinParams == NULL) {
@@ -3610,16 +3604,12 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 	s32 result = 0;
 	struct host_if_msg msg;
 
-	if (!join_req) {
-		result = -EFAULT;
-		return result;
-	}
-
+	if (!join_req)
+		return -EFAULT;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("Driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
-- 
1.9.1

