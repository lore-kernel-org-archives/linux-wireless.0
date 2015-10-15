Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6298 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbJOE15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:27:57 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/40] staging: wilc1000: rename variable gu8Chnl
Date: Thu, 15 Oct 2015 13:25:03 +0900
Message-ID: <1444883121-31757-22-git-send-email-tony.cho@atmel.com> (sfid-20151015_064656_552979_BD1901F9)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu8Chnl to ch_no
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 79aaeaa..386267c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -255,7 +255,7 @@ bool scan_while_connected;
 
 static s8 rssi;
 static s8 link_speed;
-static u8 gu8Chnl;
+static u8 ch_no;
 static u8 gs8SetIP[2][4];
 static u8 gs8GetIP[2][4];
 static u32 gu32InactiveTime;
@@ -2137,7 +2137,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)&gu8Chnl;
+	strWID.val = (s8 *)&ch_no;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
@@ -3852,7 +3852,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 		PRINT_ER("wilc mq send fail\n");
 	down(&hif_drv->hSemGetCHNL);
 
-	*pu8ChNo = gu8Chnl;
+	*pu8ChNo = ch_no;
 
 	return s32Error;
 
-- 
1.9.1

