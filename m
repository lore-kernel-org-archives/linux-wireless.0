Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7183 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbbKBIsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:48:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/38] staging: wilc1000: rename pstrHostIfSetMacAddress of fuction Handle_SetMacAddress
Date: Mon, 2 Nov 2015 17:50:47 +0900
Message-ID: <1446454281-22484-4-git-send-email-glen.lee@atmel.com> (sfid-20151102_094843_345562_F780594E)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrHostIfSetMacAddress of fuction Handle_SetMacAddress
to set_mac_addr to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 23c15c3..7a58ce7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -479,7 +479,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 idx)
 }
 
 static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
-				struct set_mac_addr *pstrHostIfSetMacAddress)
+				struct set_mac_addr *set_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -492,7 +492,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 		PRINT_ER("No buffer to send mac address\n");
 		return -EFAULT;
 	}
-	memcpy(mac_buf, pstrHostIfSetMacAddress->mac_addr, ETH_ALEN);
+	memcpy(mac_buf, set_mac_addr->mac_addr, ETH_ALEN);
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
-- 
1.9.1

