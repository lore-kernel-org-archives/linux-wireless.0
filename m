Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57968 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbJ0JZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:49 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 08/27] staging: wilc1000: linux_wlan_set_bssid: use wilc instead of g_linux_wlan
Date: Tue, 27 Oct 2015 18:27:44 +0900
Message-ID: <1445938083-20445-8-git-send-email-glen.lee@atmel.com> (sfid-20151027_102552_140653_6BD36FF6)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses netdev private data memeber wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 227dedb..8c81de9 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -405,10 +405,15 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 {
 	int i = 0;
 	int ret = -1;
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
 
-	for (i = 0; i < g_linux_wlan->vif_num; i++)
-		if (g_linux_wlan->vif[i].ndev == wilc_netdev) {
-			memcpy(g_linux_wlan->vif[i].bssid, pBSSID, 6);
+	nic = netdev_priv(wilc_netdev);
+	wilc = nic->wilc;
+
+	for (i = 0; i < wilc->vif_num; i++)
+		if (wilc->vif[i].ndev == wilc_netdev) {
+			memcpy(wilc->vif[i].bssid, pBSSID, 6);
 			ret = 0;
 			break;
 		}
-- 
1.9.1

