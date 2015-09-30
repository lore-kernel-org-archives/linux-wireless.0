Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14215 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbbI3Jtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/32] staging: wilc1000: rename strHostIfStaInactiveT
Date: Wed, 30 Sep 2015 18:44:37 +0900
Message-ID: <1443606289-25407-20-git-send-email-tony.cho@atmel.com> (sfid-20150930_121655_463505_FB086304)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfStaInactiveT to mac_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index de64bd2..5a54608 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -382,7 +382,7 @@ union message_body {
 	struct del_sta del_sta_info;
 	struct add_sta_param edit_sta_info;
 	struct power_mgmt_param pwr_mgmt_info;
-	struct sta_inactive_t strHostIfStaInactiveT;
+	struct sta_inactive_t mac_info;
 	struct set_ip_addr strHostIfSetIP;
 	struct drv_handler strHostIfSetDrvHandler;
 	struct set_multicast strHostIfSetMulti;
@@ -4139,7 +4139,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(msg.drvHandler, &msg.body.strHostIfStaInactiveT);
+			Handle_Get_InActiveTime(msg.drvHandler, &msg.body.mac_info);
 			break;
 
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
@@ -5533,7 +5533,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	memcpy(msg.body.strHostIfStaInactiveT.mac,
+	memcpy(msg.body.mac_info.mac,
 		    mac, ETH_ALEN);
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
-- 
1.9.1

