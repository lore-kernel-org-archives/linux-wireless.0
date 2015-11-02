Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7403 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbbKBIt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:49:28 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/38] staging: wilc1000: rename pstrWFIDrv of function linux_wlan_init_test_config
Date: Mon, 2 Nov 2015 17:50:55 +0900
Message-ID: <1446454281-22484-12-git-send-email-glen.lee@atmel.com> (sfid-20151102_094931_388619_98728465)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrWFIDrv of function linux_wlan_init_test_config to hif_drv
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b4e84e3..312e91a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -636,14 +636,14 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
 
 	struct wilc_priv *priv;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *hif_drv;
 
 	PRINT_D(TX_DBG, "Start configuring Firmware\n");
 	get_random_bytes(&mac_add[5], 1);
 	get_random_bytes(&mac_add[4], 1);
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
-	PRINT_D(INIT_DBG, "Host = %p\n", pstrWFIDrv);
+	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	PRINT_D(INIT_DBG, "Host = %p\n", hif_drv);
 
 	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n", mac_add[0], mac_add[1], mac_add[2], mac_add[3], mac_add[4], mac_add[5]);
 	wilc_get_chipid(0);
-- 
1.9.1

