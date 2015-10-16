Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52508 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbJPEkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:40:20 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 20/40] staging: wilc1000: rename variable gs8Rssi
Date: Fri, 16 Oct 2015 13:37:50 +0900
Message-ID: <1444970290-17609-20-git-send-email-tony.cho@atmel.com> (sfid-20151016_064700_906952_1D9CEF58)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gs8Rssi to rssi
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e309197..eda6382 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -253,7 +253,7 @@ static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
 static bool scan_while_connected;
 
-static s8 gs8Rssi;
+static s8 rssi;
 static s8 gs8lnkspd;
 static u8 gu8Chnl;
 static u8 gs8SetIP[2][4];
@@ -2165,7 +2165,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 
 	strWID.id = (u16)WID_RSSI;
 	strWID.type = WID_CHAR;
-	strWID.val = &gs8Rssi;
+	strWID.val = &rssi;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
@@ -3943,9 +3943,7 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 		return -EFAULT;
 	}
 
-
-	*ps8Rssi = gs8Rssi;
-
+	*ps8Rssi = rssi;
 
 	return s32Error;
 }
-- 
1.9.1

