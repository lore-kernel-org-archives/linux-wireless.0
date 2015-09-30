Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:46990 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbbI3Jzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:55:48 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/32] staging: wilc1000: rename strHostIfGetMacAddress
Date: Wed, 30 Sep 2015 18:55:08 +0900
Message-ID: <1443606914-25563-4-git-send-email-tony.cho@atmel.com> (sfid-20150930_115629_414059_5B08E486)
In-Reply-To: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfGetMacAddress to get_mac_info to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2fa1158..a6702dd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -388,7 +388,7 @@ union message_body {
 	struct set_multicast multicast_info;
 	struct op_mode mode;
 	struct set_mac_addr set_mac_info;
-	struct get_mac_addr strHostIfGetMacAddress;
+	struct get_mac_addr get_mac_info;
 	struct ba_session_info strHostIfBASessionInfo;
 	struct remain_ch strHostIfRemainOnChan;
 	struct reg_frame strHostIfRegisterFrame;
@@ -4181,7 +4181,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			Handle_GetMacAddress(msg.drvHandler, &msg.body.strHostIfGetMacAddress);
+			Handle_GetMacAddress(msg.drvHandler, &msg.body.get_mac_info);
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
@@ -4858,7 +4858,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
-	msg.body.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
+	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
 	msg.drvHandler = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

