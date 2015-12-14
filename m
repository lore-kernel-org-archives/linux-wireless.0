Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13854 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbbLNFo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:44:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/12] staging: wilc1000: set hif_drv before it is used
Date: Mon, 14 Dec 2015 14:47:02 +0900
Message-ID: <1450072023-13013-12-git-send-email-glen.lee@atmel.com> (sfid-20151214_070059_106486_3211E9A5)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are using hif_drv of vif, so it needs to be set before it is used.
Set hif_drv to vif->hifdrv soon after it is allocated.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++++++
 drivers/staging/wilc1000/linux_wlan.c     | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f97ea49..0125e3d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3775,6 +3775,7 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 	struct wilc *wilc;
+	int i;
 
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
@@ -3791,6 +3792,11 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		goto _fail_;
 	}
 	*hif_drv_handler = hif_drv;
+	for (i = 0; i < wilc->vif_num; i++)
+		if (dev == wilc->vif[i]->ndev) {
+			wilc->vif[i]->hif_drv = hif_drv;
+			break;
+		}
 
 	wilc_optaining_ip = false;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a50e3ff..54fe9d7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1036,7 +1036,6 @@ int wilc_mac_open(struct net_device *ndev)
 	for (i = 0; i < wl->vif_num; i++) {
 		if (ndev == wl->vif[i]->ndev) {
 			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
-			wl->vif[i]->hif_drv = priv->hWILCWFIDrv;
 			break;
 		}
 	}
-- 
1.9.1

