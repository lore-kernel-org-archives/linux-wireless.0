Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7123 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbKBIs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:48:28 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/38] staging: wilc1000: rename firmwareIPAddress of fuction Handle_set_IPAddress
Date: Mon, 2 Nov 2015 17:50:45 +0900
Message-ID: <1446454281-22484-2-git-send-email-glen.lee@atmel.com> (sfid-20151102_094831_175524_41057C22)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
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
index 4cb491f..d2628fd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -408,7 +408,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
-	char firmwareIPAddress[4] = {0};
+	char firmware_ip_addr[4] = {0};
 	struct net_device *dev;
 
 	dev = hif_drv->priv->dev;
@@ -429,7 +429,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
-	host_int_get_ipaddress(hif_drv, firmwareIPAddress, idx);
+	host_int_get_ipaddress(hif_drv, firmware_ip_addr, idx);
 
 	if (result) {
 		PRINT_ER("Failed to set IP address\n");
-- 
1.9.1

