Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52234 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbJPEio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:38:44 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 04/40] staging: wilc1000: rename u8CtWindow of struct join_bss_param
Date: Fri, 16 Oct 2015 13:37:34 +0900
Message-ID: <1444970290-17609-4-git-send-email-tony.cho@atmel.com> (sfid-20151016_063900_772857_58794412)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8CtWindow of struct join_bss_param to ct_window
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 91e7072..07c5213 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -221,7 +221,7 @@ struct join_bss_param {
 	u32 tsf;
 	u8 noa_enabled;
 	u8 opp_enabled;
-	u8 u8CtWindow;
+	u8 ct_window;
 	u8 u8Count;
 	u8 u8Index;
 	u8 au8Duration[4];
@@ -1198,7 +1198,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		*(pu8CurrByte++) = ptstrJoinBssParam->opp_enabled;
 
 		if (ptstrJoinBssParam->opp_enabled)
-			*(pu8CurrByte++) = ptstrJoinBssParam->u8CtWindow;
+			*(pu8CurrByte++) = ptstrJoinBssParam->ct_window;
 
 		*(pu8CurrByte++) = ptstrJoinBssParam->u8Count;
 
@@ -4988,7 +4988,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 
 				if (pu8IEs[index + 10] & BIT(7)) {
 					pNewJoinBssParam->opp_enabled = 1;
-					pNewJoinBssParam->u8CtWindow = pu8IEs[index + 10];
+					pNewJoinBssParam->ct_window = pu8IEs[index + 10];
 				} else {
 					pNewJoinBssParam->opp_enabled = 0;
 				}
-- 
1.9.1

