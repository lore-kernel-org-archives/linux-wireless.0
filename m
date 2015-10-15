Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6264 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbJOE1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:27:44 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/40] staging: wilc1000: rename variable gs8Rssi
Date: Thu, 15 Oct 2015 13:25:01 +0900
Message-ID: <1444883121-31757-20-git-send-email-tony.cho@atmel.com> (sfid-20151015_064655_772207_5A91CE29)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
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
index a09db2c..14cd253 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -253,7 +253,7 @@ static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
 bool scan_while_connected;
 
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

