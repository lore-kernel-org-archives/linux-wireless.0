Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52327 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbJPEjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:39:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 09/40] staging: wilc1000: rename au8StartTime of struct join_bss_param
Date: Fri, 16 Oct 2015 13:37:39 +0900
Message-ID: <1444970290-17609-9-git-send-email-tony.cho@atmel.com> (sfid-20151016_063918_357662_198C894E)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8StartTime of struct join_bss_param to start_time
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5cbba1a..320073e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -226,7 +226,7 @@ struct join_bss_param {
 	u8 idx;
 	u8 duration[4];
 	u8 interval[4];
-	u8 au8StartTime[4];
+	u8 start_time[4];
 };
 
 enum scan_conn_timer {
@@ -1208,10 +1208,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, ptstrJoinBssParam->interval, sizeof(ptstrJoinBssParam->interval));
 		pu8CurrByte += sizeof(ptstrJoinBssParam->interval);
 
-		memcpy(pu8CurrByte, ptstrJoinBssParam->au8StartTime, sizeof(ptstrJoinBssParam->au8StartTime));
-
-		pu8CurrByte += sizeof(ptstrJoinBssParam->au8StartTime);
-
+		memcpy(pu8CurrByte, ptstrJoinBssParam->start_time, sizeof(ptstrJoinBssParam->start_time));
+		pu8CurrByte += sizeof(ptstrJoinBssParam->start_time);
 	} else
 		PRINT_D(HOSTINF_DBG, "NOA not present\n");
 
@@ -5004,7 +5002,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				memcpy(pNewJoinBssParam->interval, pu8IEs + u16P2P_count, 4);
 				u16P2P_count += 4;
 
-				memcpy(pNewJoinBssParam->au8StartTime, pu8IEs + u16P2P_count, 4);
+				memcpy(pNewJoinBssParam->start_time, pu8IEs + u16P2P_count, 4);
 
 				index += pu8IEs[index + 1] + 2;
 				continue;
-- 
1.9.1

