Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6008 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbbJOE0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:26:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/40] staging: wilc1000: rename au8Duration of struct join_bss_param
Date: Thu, 15 Oct 2015 13:24:48 +0900
Message-ID: <1444883121-31757-7-git-send-email-tony.cho@atmel.com> (sfid-20151015_062633_478564_0DD78CC5)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8Duration of struct join_bss_param to duration
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 75a4279..0c5cf08 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -224,7 +224,7 @@ struct join_bss_param {
 	u8 ct_window;
 	u8 cnt;
 	u8 idx;
-	u8 au8Duration[4];
+	u8 duration[4];
 	u8 au8Interval[4];
 	u8 au8StartTime[4];
 };
@@ -1202,9 +1202,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 		*(pu8CurrByte++) = ptstrJoinBssParam->cnt;
 
-		memcpy(pu8CurrByte, ptstrJoinBssParam->au8Duration, sizeof(ptstrJoinBssParam->au8Duration));
-
-		pu8CurrByte += sizeof(ptstrJoinBssParam->au8Duration);
+		memcpy(pu8CurrByte, ptstrJoinBssParam->duration, sizeof(ptstrJoinBssParam->duration));
+		pu8CurrByte += sizeof(ptstrJoinBssParam->duration);
 
 		memcpy(pu8CurrByte, ptstrJoinBssParam->au8Interval, sizeof(ptstrJoinBssParam->au8Interval));
 
@@ -5000,7 +4999,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pNewJoinBssParam->cnt = pu8IEs[index + 11];
 				u16P2P_count = index + 12;
 
-				memcpy(pNewJoinBssParam->au8Duration, pu8IEs + u16P2P_count, 4);
+				memcpy(pNewJoinBssParam->duration, pu8IEs + u16P2P_count, 4);
 				u16P2P_count += 4;
 
 				memcpy(pNewJoinBssParam->au8Interval, pu8IEs + u16P2P_count, 4);
-- 
1.9.1

