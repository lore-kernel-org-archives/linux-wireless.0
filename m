Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7715 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbKBIup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:50:45 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/38] staging: wilc1000: rename Bssid of function get_if_handler
Date: Mon, 2 Nov 2015 17:51:08 +0900
Message-ID: <1446454281-22484-25-git-send-email-glen.lee@atmel.com> (sfid-20151102_095047_805232_9CE0502D)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Bssid of function get_if_handler to bssid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 166f240..2cc7cd9 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -334,25 +334,25 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 
 struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 {
-	u8 *Bssid, *Bssid1;
+	u8 *bssid, *Bssid1;
 	int i = 0;
 
-	Bssid = mac_header + 10;
+	bssid = mac_header + 10;
 	Bssid1 = mac_header + 4;
 
 	for (i = 0; i < wilc->vif_num; i++)
 		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
-		    !memcmp(Bssid, wilc->vif[i].bssid, ETH_ALEN))
+		    !memcmp(bssid, wilc->vif[i].bssid, ETH_ALEN))
 			return wilc->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
 		PRINT_D(INIT_DBG, "%02x ", mac_header[i]);
-	Bssid = mac_header + 18;
+	bssid = mac_header + 18;
 	Bssid1 = mac_header + 12;
 	for (i = 0; i < wilc->vif_num; i++)
 		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
-		    !memcmp(Bssid, wilc->vif[i].bssid, ETH_ALEN))
+		    !memcmp(bssid, wilc->vif[i].bssid, ETH_ALEN))
 			return wilc->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "\n");
-- 
1.9.1

