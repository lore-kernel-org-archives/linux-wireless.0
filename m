Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26324 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbbKEFde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:33:34 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 01/38] staging: wilc1000: rename pu8IPAddr of fuction Handle_set_IPAddress
Date: Thu, 5 Nov 2015 14:36:02 +0900
Message-ID: <1446701799-24870-1-git-send-email-glen.lee@atmel.com> (sfid-20151105_063337_812870_44E3AB40)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8IPAddr of fuction Handle_set_IPAddress to ip_addr
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 17826f3..b1d8b17 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -397,22 +397,23 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
+s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
 	char firmwareIPAddress[4] = {0};
 
-	if (pu8IPAddr[0] < 192)
-		pu8IPAddr[0] = 0;
+	if (ip_addr[0] < 192)
+		ip_addr[0] = 0;
 
-	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n", idx, pu8IPAddr);
+	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n",
+		   idx, ip_addr);
 
-	memcpy(set_ip[idx], pu8IPAddr, IP_ALEN);
+	memcpy(set_ip[idx], ip_addr, IP_ALEN);
 
 	wid.id = (u16)WID_IP_ADDRESS;
 	wid.type = WID_STR;
-	wid.val = (u8 *)pu8IPAddr;
+	wid.val = (u8 *)ip_addr;
 	wid.size = IP_ALEN;
 
 	result = send_config_pkt(SET_CFG, &wid, 1,
-- 
1.9.1

