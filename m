Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:5953 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbbJOE0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:26:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/40] staging: wilc1000: rename u8Count of struct join_bss_param
Date: Thu, 15 Oct 2015 13:24:46 +0900
Message-ID: <1444883121-31757-5-git-send-email-tony.cho@atmel.com> (sfid-20151015_062647_658640_7846DE5E)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8Count of struct join_bss_param to cnt
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 07c5213..e8a35d3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -222,7 +222,7 @@ struct join_bss_param {
 	u8 noa_enabled;
 	u8 opp_enabled;
 	u8 ct_window;
-	u8 u8Count;
+	u8 cnt;
 	u8 u8Index;
 	u8 au8Duration[4];
 	u8 au8Interval[4];
@@ -1200,7 +1200,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		if (ptstrJoinBssParam->opp_enabled)
 			*(pu8CurrByte++) = ptstrJoinBssParam->ct_window;
 
-		*(pu8CurrByte++) = ptstrJoinBssParam->u8Count;
+		*(pu8CurrByte++) = ptstrJoinBssParam->cnt;
 
 		memcpy(pu8CurrByte, ptstrJoinBssParam->au8Duration, sizeof(ptstrJoinBssParam->au8Duration));
 
@@ -4997,7 +4997,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				for (i = 0; i < pu8IEs[index + 7]; i++)
 					PRINT_D(GENERIC_DBG, " %x\n", pu8IEs[index + 9 + i]);
 
-				pNewJoinBssParam->u8Count = pu8IEs[index + 11];
+				pNewJoinBssParam->cnt = pu8IEs[index + 11];
 				u16P2P_count = index + 12;
 
 				memcpy(pNewJoinBssParam->au8Duration, pu8IEs + u16P2P_count, 4);
-- 
1.9.1

