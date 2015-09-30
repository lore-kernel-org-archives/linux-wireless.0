Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:46914 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbbI3Jz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:55:29 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/32] staging: wilc1000: rename strHostIfSetMulti
Date: Wed, 30 Sep 2015 18:55:05 +0900
Message-ID: <1443606914-25563-1-git-send-email-tony.cho@atmel.com> (sfid-20150930_115534_153034_5A3820FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfSetMulti to multicast_info to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 596d68f..034e3d9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -385,7 +385,7 @@ union message_body {
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
-	struct set_multicast strHostIfSetMulti;
+	struct set_multicast multicast_info;
 	struct op_mode strHostIfSetOperationMode;
 	struct set_mac_addr strHostIfSetMacAddress;
 	struct get_mac_addr strHostIfGetMacAddress;
@@ -4200,7 +4200,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_MULTICAST_FILTER\n");
-			Handle_SetMulticastFilter(msg.drvHandler, &msg.body.strHostIfSetMulti);
+			Handle_SetMulticastFilter(msg.drvHandler, &msg.body.multicast_info);
 			break;
 
 		case HOST_IF_MSG_ADD_BA_SESSION:
@@ -6860,7 +6860,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct set_multicast *pstrMulticastFilterParam = &msg.body.strHostIfSetMulti;
+	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
 
 
 	if (pstrWFIDrv == NULL) {
-- 
1.9.1

