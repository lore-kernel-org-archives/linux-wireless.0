Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58440 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbbJ0J1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:27:08 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 21/27] staging: wilc1000: GetIfHandler: add argument struct wilc and use it
Date: Tue, 27 Oct 2015 18:27:57 +0900
Message-ID: <1445938083-20445-21-git-send-email-glen.lee@atmel.com> (sfid-20151027_104654_496038_D1E08EEE)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of
g_linux_wlan. And also pass wilc to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6293410..1f5c8f3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -374,7 +374,7 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 
 }
 
-struct net_device *GetIfHandler(u8 *pMacHeader)
+struct net_device *GetIfHandler(struct wilc *wilc, u8 *pMacHeader)
 {
 	u8 *Bssid, *Bssid1;
 	int i = 0;
@@ -382,20 +382,20 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 10;
 	Bssid1 = pMacHeader + 4;
 
-	for (i = 0; i < g_linux_wlan->vif_num; i++)
-		if (!memcmp(Bssid1, g_linux_wlan->vif[i].bssid, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->vif[i].bssid, ETH_ALEN))
-			return g_linux_wlan->vif[i].ndev;
+	for (i = 0; i < wilc->vif_num; i++)
+		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
+		    !memcmp(Bssid, wilc->vif[i].bssid, ETH_ALEN))
+			return wilc->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
 		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
-	for (i = 0; i < g_linux_wlan->vif_num; i++)
-		if (!memcmp(Bssid1, g_linux_wlan->vif[i].bssid, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->vif[i].bssid, ETH_ALEN))
-			return g_linux_wlan->vif[i].ndev;
+	for (i = 0; i < wilc->vif_num; i++)
+		if (!memcmp(Bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
+		    !memcmp(Bssid, wilc->vif[i].bssid, ETH_ALEN))
+			return wilc->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
@@ -1567,7 +1567,7 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	struct net_device *wilc_netdev;
 	perInterface_wlan_t *nic;
 
-	wilc_netdev = GetIfHandler(buff);
+	wilc_netdev = GetIfHandler(wilc, buff);
 	if (wilc_netdev == NULL)
 		return;
 
-- 
1.9.1

