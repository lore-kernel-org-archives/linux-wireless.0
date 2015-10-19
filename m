Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8319 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbbJSJ0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:26:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 4/6] staging: wilc1000: fixes unnecessary variable replacement
Date: Mon, 19 Oct 2015 18:26:11 +0900
Message-ID: <1445246773-22253-5-git-send-email-tony.cho@atmel.com> (sfid-20151019_112656_958904_2A03D293)
In-Reply-To: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
References: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
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
index 948b986..b1bfd9e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3167,9 +3167,8 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3204,9 +3203,8 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	u8 i;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3246,9 +3244,8 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	u32 i;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
@@ -3311,9 +3308,8 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
@@ -3370,9 +3366,8 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 
 
 	if (!hif_drv) {
-		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3514,9 +3509,8 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	struct host_if_msg msg;
 
 	if (!hif_drv || pfConnectResult == NULL) {
-		result = -EFAULT;
 		PRINT_ER("Driver is null\n");
-		return result;
+		return -EFAULT;
 	}
 
 	if (pJoinParams == NULL) {
@@ -3575,16 +3569,12 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
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

