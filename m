Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7150 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbbKBIsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:48:35 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/38] staging: wilc1000: remove unused parameter of fuction Handle_get_IPAddress
Date: Mon, 2 Nov 2015 17:50:46 +0900
Message-ID: <1446454281-22484-3-git-send-email-glen.lee@atmel.com> (sfid-20151102_094837_628002_DCDE1EDB)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes parameter pu8IPAddr of fuction Handle_get_IPAddress because
it is not used in the function. Remove argument in the function call also.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d2628fd..23c15c3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -441,7 +441,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 	return result;
 }
 
-s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
+s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -3072,7 +3072,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_get_IPAddress(msg.drv, msg.body.ip_info.ip_addr, msg.body.ip_info.idx);
+			Handle_get_IPAddress(msg.drv, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-- 
1.9.1

