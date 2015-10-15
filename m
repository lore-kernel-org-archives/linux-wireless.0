Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:5982 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbbJOE0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:26:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/40] staging: wilc1000: rename u8Index of struct join_bss_param
Date: Thu, 15 Oct 2015 13:24:47 +0900
Message-ID: <1444883121-31757-6-git-send-email-tony.cho@atmel.com> (sfid-20151015_062620_854010_67752D3A)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8Index of struct join_bss_param to idx
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e8a35d3..75a4279 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -223,7 +223,7 @@ struct join_bss_param {
 	u8 opp_enabled;
 	u8 ct_window;
 	u8 cnt;
-	u8 u8Index;
+	u8 idx;
 	u8 au8Duration[4];
 	u8 au8Interval[4];
 	u8 au8StartTime[4];
@@ -1194,8 +1194,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 16) & 0xFF;
 		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 24) & 0xFF;
 
-		*(pu8CurrByte++) = ptstrJoinBssParam->u8Index;
 		*(pu8CurrByte++) = ptstrJoinBssParam->opp_enabled;
+		*(pu8CurrByte++) = ptstrJoinBssParam->idx;
 
 		if (ptstrJoinBssParam->opp_enabled)
 			*(pu8CurrByte++) = ptstrJoinBssParam->ct_window;
@@ -4984,7 +4984,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 
 				pNewJoinBssParam->tsf = ptstrNetworkInfo->u32Tsf;
 				pNewJoinBssParam->noa_enabled = 1;
-				pNewJoinBssParam->u8Index = pu8IEs[index + 9];
+				pNewJoinBssParam->idx = pu8IEs[index + 9];
 
 				if (pu8IEs[index + 10] & BIT(7)) {
 					pNewJoinBssParam->opp_enabled = 1;
-- 
1.9.1

