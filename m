Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:41798 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbcCOJvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 05:51:21 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/7] staging: wilc1000: removes duplicate wilc variable setting
Date: Tue, 15 Mar 2016 18:48:11 +0900
Message-ID: <1458035294-13001-4-git-send-email-leo.kim@atmel.com> (sfid-20160315_105124_540778_9A273D8D)
In-Reply-To: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
References: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches removes duplicate wilc variable setting.
This value has already been set to wl variable previously.
Replace wilc with wl as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8a10831..1a5de2e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -896,7 +896,6 @@ static int mac_init_fn(struct net_device *ndev)
 int wilc_mac_open(struct net_device *ndev)
 {
 	struct wilc_vif *vif;
-	struct wilc *wilc;
 
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
@@ -912,7 +911,6 @@ int wilc_mac_open(struct net_device *ndev)
 		return -ENODEV;
 	}
 
-	wilc = vif->wilc;
 	priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 	netdev_dbg(ndev, "MAC OPEN[%p]\n", ndev);
 
@@ -932,13 +930,13 @@ int wilc_mac_open(struct net_device *ndev)
 				wilc_set_wfi_drv_handler(vif,
 							 wilc_get_vif_idx(vif),
 							 0);
-			} else if (!wilc_wlan_get_num_conn_ifcs(wilc)) {
+			} else if (!wilc_wlan_get_num_conn_ifcs(wl)) {
 				wilc_set_wfi_drv_handler(vif,
 							 wilc_get_vif_idx(vif),
-							 wilc->open_ifcs);
+							 wl->open_ifcs);
 			} else {
-				if (memcmp(wilc->vif[i ^ 1]->bssid,
-					   wilc->vif[i ^ 1]->src_addr, 6))
+				if (memcmp(wl->vif[i ^ 1]->bssid,
+					   wl->vif[i ^ 1]->src_addr, 6))
 					wilc_set_wfi_drv_handler(vif,
 							 wilc_get_vif_idx(vif),
 							 0);
-- 
1.9.1

