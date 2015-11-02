Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7680 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbbKBIuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:50:39 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/38] staging: wilc1000: rename pMacHeader of function get_if_handler
Date: Mon, 2 Nov 2015 17:51:07 +0900
Message-ID: <1446454281-22484-24-git-send-email-glen.lee@atmel.com> (sfid-20151102_095042_670329_8B398020)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pMacHeader of function get_if_handler to mac_header
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8321b76..166f240 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -332,13 +332,13 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 	}
 }
 
-struct net_device *get_if_handler(struct wilc *wilc, u8 *pMacHeader)
+struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 {
 	u8 *Bssid, *Bssid1;
 	int i = 0;
 
-	Bssid  = pMacHeader + 10;
-	Bssid1 = pMacHeader + 4;
+	Bssid = mac_header + 10;
+	Bssid1 = mac_header + 4;
 
 	for (i = 0; i < wilc->vif_num; i++)
 		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
@@ -347,9 +347,9 @@ struct net_device *get_if_handler(struct wilc *wilc, u8 *pMacHeader)
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
-		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
-	Bssid  = pMacHeader + 18;
-	Bssid1 = pMacHeader + 12;
+		PRINT_D(INIT_DBG, "%02x ", mac_header[i]);
+	Bssid = mac_header + 18;
+	Bssid1 = mac_header + 12;
 	for (i = 0; i < wilc->vif_num; i++)
 		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
 		    !memcmp(Bssid, wilc->vif[i].bssid, ETH_ALEN))
-- 
1.9.1

