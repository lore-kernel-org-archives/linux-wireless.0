Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52185 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbbJPEid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:38:33 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 02/40] staging: wilc1000: rename u8NoaEnbaled of struct join_bss_param
Date: Fri, 16 Oct 2015 13:37:32 +0900
Message-ID: <1444970290-17609-2-git-send-email-tony.cho@atmel.com> (sfid-20151016_063858_392000_C96FFEE2)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8NoaEnbaled of struct join_bss_param to noa_enabled
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e2588ef..2b8e412 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -219,7 +219,7 @@ struct join_bss_param {
 	u8 rsn_auth_policy[3];
 	u8 rsn_cap[2];
 	u32 tsf;
-	u8 u8NoaEnbaled;
+	u8 noa_enabled;
 	u8 u8OppEnable;
 	u8 u8CtWindow;
 	u8 u8Count;
@@ -1184,9 +1184,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_cap);
 
 	*(pu8CurrByte++) = REAL_JOIN_REQ;
+	*(pu8CurrByte++) = ptstrJoinBssParam->noa_enabled;
 
-	*(pu8CurrByte++) = ptstrJoinBssParam->u8NoaEnbaled;
-	if (ptstrJoinBssParam->u8NoaEnbaled) {
+	if (ptstrJoinBssParam->noa_enabled) {
 		PRINT_D(HOSTINF_DBG, "NOA present\n");
 
 		*(pu8CurrByte++) = (ptstrJoinBssParam->tsf) & 0xFF;
@@ -4984,7 +4984,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				u16 u16P2P_count;
 
 				pNewJoinBssParam->tsf = ptstrNetworkInfo->u32Tsf;
-				pNewJoinBssParam->u8NoaEnbaled = 1;
+				pNewJoinBssParam->noa_enabled = 1;
 				pNewJoinBssParam->u8Index = pu8IEs[index + 9];
 
 				if (pu8IEs[index + 10] & BIT(7)) {
-- 
1.9.1

