Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41261 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcAYHop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:44:45 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 26/26] staging: wilc1000: get mac address after setting drv handler
Date: Mon, 25 Jan 2016 16:35:30 +0900
Message-ID: <1453707330-13526-27-git-send-email-glen.lee@atmel.com> (sfid-20160125_084447_541897_00FC9ED6)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves wilc_get_mac_address and address memcpy function after
calling wilc_set_wif_drv_handler to get selected mac address.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e72ef39..8b8bf47 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1018,12 +1018,8 @@ int wilc_mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	wilc_get_mac_address(vif, mac_add);
-	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
-
 	for (i = 0; i < wl->vif_num; i++) {
 		if (ndev == wl->vif[i]->ndev) {
-			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
 			if (vif->iftype == AP_MODE) {
 				wilc_set_wfi_drv_handler(vif,
 							 wilc_get_vif_idx(vif),
@@ -1044,6 +1040,11 @@ int wilc_mac_open(struct net_device *ndev)
 							 1);
 			}
 			wilc_set_operation_mode(vif, vif->iftype);
+
+			wilc_get_mac_address(vif, mac_add);
+			netdev_dbg(ndev, "Mac address: %pM\n", mac_add);
+			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
+
 			break;
 		}
 	}
-- 
1.9.1

