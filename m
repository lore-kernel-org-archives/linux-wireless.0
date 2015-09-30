Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14260 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbbI3Jtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:53 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/32] staging: wilc1000: rename strHostIfSetIP
Date: Wed, 30 Sep 2015 18:44:39 +0900
Message-ID: <1443606289-25407-22-git-send-email-tony.cho@atmel.com> (sfid-20150930_121654_337076_A2A93FF0)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfSetIP to ip_info to avoid CamelCase naming
convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b8ef165..596d68f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -383,7 +383,7 @@ union message_body {
 	struct add_sta_param edit_sta_info;
 	struct power_mgmt_param pwr_mgmt_info;
 	struct sta_inactive_t mac_info;
-	struct set_ip_addr strHostIfSetIP;
+	struct set_ip_addr ip_info;
 	struct drv_handler drv;
 	struct set_multicast strHostIfSetMulti;
 	struct op_mode strHostIfSetOperationMode;
@@ -4168,12 +4168,12 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_SET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_set_IPAddress(msg.drvHandler, msg.body.strHostIfSetIP.au8IPAddr, msg.body.strHostIfSetIP.idx);
+			Handle_set_IPAddress(msg.drvHandler, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_get_IPAddress(msg.drvHandler, msg.body.strHostIfSetIP.au8IPAddr, msg.body.strHostIfSetIP.idx);
+			Handle_get_IPAddress(msg.drvHandler, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
@@ -7232,9 +7232,9 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
-	msg.body.strHostIfSetIP.au8IPAddr = u16ipadd;
+	msg.body.ip_info.au8IPAddr = u16ipadd;
 	msg.drvHandler = hWFIDrv;
-	msg.body.strHostIfSetIP.idx = idx;
+	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -7269,9 +7269,9 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
-	msg.body.strHostIfSetIP.au8IPAddr = u16ipadd;
+	msg.body.ip_info.au8IPAddr = u16ipadd;
 	msg.drvHandler = hWFIDrv;
-	msg.body.strHostIfSetIP.idx = idx;
+	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
-- 
1.9.1

