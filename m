Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:46969 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbbI3Jzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:55:42 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/32] staging: wilc1000: rename strHostIfSetMacAddress
Date: Wed, 30 Sep 2015 18:55:07 +0900
Message-ID: <1443606914-25563-3-git-send-email-tony.cho@atmel.com> (sfid-20150930_115546_925062_07D7AD47)
In-Reply-To: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfSetMacAddress to set_mac_info to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a66f78d..2fa1158 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -387,7 +387,7 @@ union message_body {
 	struct drv_handler drv;
 	struct set_multicast multicast_info;
 	struct op_mode mode;
-	struct set_mac_addr strHostIfSetMacAddress;
+	struct set_mac_addr set_mac_info;
 	struct get_mac_addr strHostIfGetMacAddress;
 	struct ba_session_info strHostIfBASessionInfo;
 	struct remain_ch strHostIfRemainOnChan;
@@ -4177,7 +4177,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-			Handle_SetMacAddress(msg.drvHandler, &msg.body.strHostIfSetMacAddress);
+			Handle_SetMacAddress(msg.drvHandler, &msg.body.set_mac_info);
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
@@ -4892,7 +4892,7 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	/* prepare setting mac address message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
-	memcpy(msg.body.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
+	memcpy(msg.body.set_mac_info.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

