Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4832 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbJMLDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:03:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 51/54] staging: wilc1000: rename au8IPAddr of struct set_ip_addr
Date: Tue, 13 Oct 2015 20:02:09 +0900
Message-ID: <1444734132-17858-6-git-send-email-tony.cho@atmel.com> (sfid-20151013_130304_096225_1190AF99)
In-Reply-To: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8IPAddr of struct set_ip_addr to ip_addr to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 97d1bd8..8fb6ef5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -159,7 +159,7 @@ struct power_mgmt_param {
 };
 
 struct set_ip_addr {
-	u8 *au8IPAddr;
+	u8 *ip_addr;
 	u8 idx;
 };
 
@@ -3079,12 +3079,12 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_SET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_set_IPAddress(msg.drv, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
+			Handle_set_IPAddress(msg.drv, msg.body.ip_info.ip_addr, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_get_IPAddress(msg.drv, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
+			Handle_get_IPAddress(msg.drv, msg.body.ip_info.ip_addr, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
@@ -5162,7 +5162,7 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
-	msg.body.ip_info.au8IPAddr = u16ipadd;
+	msg.body.ip_info.ip_addr = u16ipadd;
 	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
@@ -5189,7 +5189,7 @@ s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
-	msg.body.ip_info.au8IPAddr = u16ipadd;
+	msg.body.ip_info.ip_addr = u16ipadd;
 	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
-- 
1.9.1

