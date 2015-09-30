Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14202 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbbI3Jte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:34 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/32] staging: wilc1000: rename strPowerMgmtparam
Date: Wed, 30 Sep 2015 18:44:36 +0900
Message-ID: <1443606289-25407-19-git-send-email-tony.cho@atmel.com> (sfid-20150930_121655_729781_8284FE22)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strPowerMgmtparam to pwr_mgmt_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7d51122..de64bd2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -381,7 +381,7 @@ union message_body {
 	struct add_sta_param add_sta_info;
 	struct del_sta del_sta_info;
 	struct add_sta_param edit_sta_info;
-	struct power_mgmt_param strPowerMgmtparam;
+	struct power_mgmt_param pwr_mgmt_info;
 	struct sta_inactive_t strHostIfStaInactiveT;
 	struct set_ip_addr strHostIfSetIP;
 	struct drv_handler strHostIfSetDrvHandler;
@@ -4154,7 +4154,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(msg.drvHandler, &msg.body.strPowerMgmtparam);
+			Handle_PowerManagement(msg.drvHandler, &msg.body.pwr_mgmt_info);
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
@@ -6826,7 +6826,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.strPowerMgmtparam;
+	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
-- 
1.9.1

