Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbbKEFgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:01 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 26/38] staging: wilc1000: rename Bssid1 of function get_if_handler
Date: Thu, 5 Nov 2015 14:36:27 +0900
Message-ID: <1446701799-24870-26-git-send-email-glen.lee@atmel.com> (sfid-20151105_063756_348441_434C9B66)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Bssid1 of function get_if_handler to bssid1
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 64b7c4f..6758cbc 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -333,14 +333,14 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 
 struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 {
-	u8 *bssid, *Bssid1;
+	u8 *bssid, *bssid1;
 	int i = 0;
 
 	bssid = mac_header + 10;
-	Bssid1 = mac_header + 4;
+	bssid1 = mac_header + 4;
 
 	for (i = 0; i < wilc->vif_num; i++)
-		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
+		if (!memcmp(bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
 		    !memcmp(bssid, wilc->vif[i].bssid, ETH_ALEN))
 			return wilc->vif[i].ndev;
 
@@ -348,9 +348,9 @@ struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	for (i = 0; i < 25; i++)
 		PRINT_D(INIT_DBG, "%02x ", mac_header[i]);
 	bssid = mac_header + 18;
-	Bssid1 = mac_header + 12;
+	bssid1 = mac_header + 12;
 	for (i = 0; i < wilc->vif_num; i++)
-		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
+		if (!memcmp(bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
 		    !memcmp(bssid, wilc->vif[i].bssid, ETH_ALEN))
 			return wilc->vif[i].ndev;
 
-- 
1.9.1

