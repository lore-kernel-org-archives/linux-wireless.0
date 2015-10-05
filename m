Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37136 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbbJEK3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:29:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 6/6] staging: wilc1000: change parameter names in send_config_pkt
Date: Mon, 5 Oct 2015 19:28:14 +0900
Message-ID: <1444040894-18709-6-git-send-email-tony.cho@atmel.com> (sfid-20151005_122910_144383_422406E4)
In-Reply-To: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
References: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the parameter names in send_config_pkt function as
the followings:

- u8Mode to mode
- pstrWIDs to wids
- u32WIDsCount to count
- drvHandler to drv

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 41 ++++++++++++++---------------
 drivers/staging/wilc1000/coreconfigurator.h |  3 +--
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4bc17b2..189be4a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -595,41 +595,40 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
  *  @date		1 Mar 2012
  *  @version	1.0
  */
-s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
-		    u32 u32WIDsCount, u32 drvHandler)
+s32 send_config_pkt(u8 mode, tstrWID *wids, u32 count, u32 drv)
 {
 	s32 counter = 0, ret = 0;
 
-	if (u8Mode == GET_CFG) {
-		for (counter = 0; counter < u32WIDsCount; counter++) {
+	if (mode == GET_CFG) {
+		for (counter = 0; counter < count; counter++) {
 			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
-				   (counter == u32WIDsCount - 1));
+				   (counter == count - 1));
 			if (!wilc_wlan_cfg_get(!counter,
-					       pstrWIDs[counter].u16WIDid,
-					       (counter == u32WIDsCount - 1),
-					       drvHandler)) {
+					       wids[counter].u16WIDid,
+					       (counter == count - 1),
+					       drv)) {
 				ret = -1;
 				printk("[Sendconfigpkt]Get Timed out\n");
 				break;
 			}
 		}
 		counter = 0;
-		for (counter = 0; counter < u32WIDsCount; counter++) {
-			pstrWIDs[counter].s32ValueSize = wilc_wlan_cfg_get_val(
-					pstrWIDs[counter].u16WIDid,
-					pstrWIDs[counter].ps8WidVal,
-					pstrWIDs[counter].s32ValueSize);
+		for (counter = 0; counter < count; counter++) {
+			wids[counter].s32ValueSize = wilc_wlan_cfg_get_val(
+					wids[counter].u16WIDid,
+					wids[counter].ps8WidVal,
+					wids[counter].s32ValueSize);
 
 		}
-	} else if (u8Mode == SET_CFG) {
-		for (counter = 0; counter < u32WIDsCount; counter++) {
-			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", pstrWIDs[counter].u16WIDid);
+	} else if (mode == SET_CFG) {
+		for (counter = 0; counter < count; counter++) {
+			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].u16WIDid);
 			if (!wilc_wlan_cfg_set(!counter,
-					       pstrWIDs[counter].u16WIDid,
-					       pstrWIDs[counter].ps8WidVal,
-					       pstrWIDs[counter].s32ValueSize,
-					       (counter == u32WIDsCount - 1),
-					       drvHandler)) {
+					       wids[counter].u16WIDid,
+					       wids[counter].ps8WidVal,
+					       wids[counter].s32ValueSize,
+					       (counter == count - 1),
+					       drv)) {
 				ret = -1;
 				printk("[Sendconfigpkt]Set Timed out\n");
 				break;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 4d65088..8ba30dc 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -128,8 +128,7 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
-		    u32 u32WIDsCount, u32 drvHandler);
+s32 send_config_pkt(u8 mode, tstrWID *wids, u32 count, u32 drv);
 s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
-- 
1.9.1

