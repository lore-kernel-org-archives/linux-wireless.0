Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7210 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbbKBIsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:48:46 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/38] staging: wilc1000: rename pstrHostIfGetMacAddress of fuction Handle_GetMacAddress
Date: Mon, 2 Nov 2015 17:50:48 +0900
Message-ID: <1446454281-22484-5-git-send-email-glen.lee@atmel.com> (sfid-20151102_094856_869647_8DC356CA)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrHostIfGetMacAddress of fuction Handle_GetMacAddress
to get_mac_addr to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7a58ce7..69ec7eb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -512,7 +512,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 }
 
 static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
-				struct get_mac_addr *pstrHostIfGetMacAddress)
+				struct get_mac_addr *get_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -522,7 +522,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
-	wid.val = pstrHostIfGetMacAddress->mac_addr;
+	wid.val = get_mac_addr->mac_addr;
 	wid.size = ETH_ALEN;
 
 	result = send_config_pkt(dev, GET_CFG, &wid, 1,
-- 
1.9.1

