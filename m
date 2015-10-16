Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52309 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbbJPEjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:39:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 08/40] staging: wilc1000: rename au8Interval of struct join_bss_param
Date: Fri, 16 Oct 2015 13:37:38 +0900
Message-ID: <1444970290-17609-8-git-send-email-tony.cho@atmel.com> (sfid-20151016_063912_537443_6DCBAA4D)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8Interval of struct join_bss_param to interval
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0c5cf08..5cbba1a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -225,7 +225,7 @@ struct join_bss_param {
 	u8 cnt;
 	u8 idx;
 	u8 duration[4];
-	u8 au8Interval[4];
+	u8 interval[4];
 	u8 au8StartTime[4];
 };
 
@@ -1205,9 +1205,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, ptstrJoinBssParam->duration, sizeof(ptstrJoinBssParam->duration));
 		pu8CurrByte += sizeof(ptstrJoinBssParam->duration);
 
-		memcpy(pu8CurrByte, ptstrJoinBssParam->au8Interval, sizeof(ptstrJoinBssParam->au8Interval));
-
-		pu8CurrByte += sizeof(ptstrJoinBssParam->au8Interval);
+		memcpy(pu8CurrByte, ptstrJoinBssParam->interval, sizeof(ptstrJoinBssParam->interval));
+		pu8CurrByte += sizeof(ptstrJoinBssParam->interval);
 
 		memcpy(pu8CurrByte, ptstrJoinBssParam->au8StartTime, sizeof(ptstrJoinBssParam->au8StartTime));
 
@@ -5002,7 +5001,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				memcpy(pNewJoinBssParam->duration, pu8IEs + u16P2P_count, 4);
 				u16P2P_count += 4;
 
-				memcpy(pNewJoinBssParam->au8Interval, pu8IEs + u16P2P_count, 4);
+				memcpy(pNewJoinBssParam->interval, pu8IEs + u16P2P_count, 4);
 				u16P2P_count += 4;
 
 				memcpy(pNewJoinBssParam->au8StartTime, pu8IEs + u16P2P_count, 4);
-- 
1.9.1

