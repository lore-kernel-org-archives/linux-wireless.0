Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9482 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbcBDJYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:24:04 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 12/70] staging: wilc1000: get mac address after setting drv handler
Date: Thu, 4 Feb 2016 18:15:29 +0900
Message-ID: <1454577387-509-13-git-send-email-glen.lee@atmel.com> (sfid-20160204_104502_992978_7CDEC1DB)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
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
index 2fafcc4..9de57ae 100644
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

