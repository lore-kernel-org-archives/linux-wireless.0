Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51827 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbJWF0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:26:47 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/28] staging: wilc1000: linux_wlan_set_bssid: use wilc instead of g_linux_wlan
Date: Fri, 23 Oct 2015 14:28:25 +0900
Message-ID: <1445578124-31486-9-git-send-email-glen.lee@atmel.com> (sfid-20151023_074654_786415_3D962E17)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch use netdev private data memeber wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index af7e844..b8fd4ae 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -404,10 +404,15 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 {
 	int i = 0;
 	int ret = -1;
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
 
-	for (i = 0; i < g_linux_wlan->vif_num; i++)
-		if (g_linux_wlan->vif[i].ndev == wilc_netdev) {
-			memcpy(g_linux_wlan->vif[i].bssid, pBSSID, 6);
+	nic = netdev_priv(wilc_netdev);
+	wl = nic->wilc;
+
+	for (i = 0; i < wl->vif_num; i++)
+		if (wl->vif[i].ndev == wilc_netdev) {
+			memcpy(wl->vif[i].bssid, pBSSID, 6);
 			ret = 0;
 			break;
 		}
-- 
1.9.1

