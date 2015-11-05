Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26350 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbbKEFdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:33:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 02/38] staging: wilc1000: rename firmwareIPAddress of fuction Handle_set_IPAddress
Date: Thu, 5 Nov 2015 14:36:03 +0900
Message-ID: <1446701799-24870-2-git-send-email-glen.lee@atmel.com> (sfid-20151105_063343_124329_D1F09902)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames firmwareIPAddress of fuction Handle_set_IPAddress to
firmware_ip_addr to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b1d8b17..4ad0dd0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -401,7 +401,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
-	char firmwareIPAddress[4] = {0};
+	char firmware_ip_addr[4] = {0};
 
 	if (ip_addr[0] < 192)
 		ip_addr[0] = 0;
@@ -419,7 +419,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
-	host_int_get_ipaddress(hif_drv, firmwareIPAddress, idx);
+	host_int_get_ipaddress(hif_drv, firmware_ip_addr, idx);
 
 	if (result) {
 		PRINT_ER("Failed to set IP address\n");
-- 
1.9.1

