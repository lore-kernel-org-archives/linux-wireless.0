Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26427 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbbKEFd6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:33:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 05/38] staging: wilc1000: rename pstrHostIfGetMacAddress of fuction Handle_GetMacAddress
Date: Thu, 5 Nov 2015 14:36:06 +0900
Message-ID: <1446701799-24870-5-git-send-email-glen.lee@atmel.com> (sfid-20151105_063402_740930_A45A018C)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
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
index 35e9460..06994fb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -496,14 +496,14 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 }
 
 static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
-				struct get_mac_addr *pstrHostIfGetMacAddress)
+				struct get_mac_addr *get_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
-	wid.val = pstrHostIfGetMacAddress->mac_addr;
+	wid.val = get_mac_addr->mac_addr;
 	wid.size = ETH_ALEN;
 
 	result = send_config_pkt(GET_CFG, &wid, 1,
-- 
1.9.1

