Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:5910 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbbJOEZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:25:52 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/40] staging: wilc1000: rename u8OppEnable of struct join_bss_param
Date: Thu, 15 Oct 2015 13:24:44 +0900
Message-ID: <1444883121-31757-3-git-send-email-tony.cho@atmel.com> (sfid-20151015_062555_053945_CA9DF6D3)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8OppEnable of struct join_bss_param to opp_enabled
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2b8e412..91e7072 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -220,7 +220,7 @@ struct join_bss_param {
 	u8 rsn_cap[2];
 	u32 tsf;
 	u8 noa_enabled;
-	u8 u8OppEnable;
+	u8 opp_enabled;
 	u8 u8CtWindow;
 	u8 u8Count;
 	u8 u8Index;
@@ -1195,10 +1195,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 24) & 0xFF;
 
 		*(pu8CurrByte++) = ptstrJoinBssParam->u8Index;
+		*(pu8CurrByte++) = ptstrJoinBssParam->opp_enabled;
 
-		*(pu8CurrByte++) = ptstrJoinBssParam->u8OppEnable;
-
-		if (ptstrJoinBssParam->u8OppEnable)
+		if (ptstrJoinBssParam->opp_enabled)
 			*(pu8CurrByte++) = ptstrJoinBssParam->u8CtWindow;
 
 		*(pu8CurrByte++) = ptstrJoinBssParam->u8Count;
@@ -4988,10 +4987,11 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pNewJoinBssParam->u8Index = pu8IEs[index + 9];
 
 				if (pu8IEs[index + 10] & BIT(7)) {
-					pNewJoinBssParam->u8OppEnable = 1;
+					pNewJoinBssParam->opp_enabled = 1;
 					pNewJoinBssParam->u8CtWindow = pu8IEs[index + 10];
-				} else
-					pNewJoinBssParam->u8OppEnable = 0;
+				} else {
+					pNewJoinBssParam->opp_enabled = 0;
+				}
 
 				PRINT_D(GENERIC_DBG, "P2P Dump\n");
 				for (i = 0; i < pu8IEs[index + 7]; i++)
-- 
1.9.1

