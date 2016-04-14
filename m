Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35055 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbcDNPTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 11:19:14 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: remove unused variables
Date: Thu, 14 Apr 2016 20:48:49 +0530
Message-Id: <1460647129-22740-2-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160414_172009_049841_C3470B5B)
In-Reply-To: <1460647129-22740-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1460647129-22740-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These variables were havnig the pointer returned by wiphy_priv() but
they were never used.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5643a3d..8cc8e8d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -865,7 +865,6 @@ int wilc_mac_open(struct net_device *ndev)
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
 	int i = 0;
-	struct wilc_priv *priv;
 	struct wilc *wl;
 
 	vif = netdev_priv(ndev);
@@ -876,7 +875,6 @@ int wilc_mac_open(struct net_device *ndev)
 		return -ENODEV;
 	}
 
-	priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 	netdev_dbg(ndev, "MAC OPEN[%p]\n", ndev);
 
 	ret = wilc_init_host_int(ndev);
@@ -953,14 +951,10 @@ static struct net_device_stats *mac_stats(struct net_device *dev)
 static void wilc_set_multicast_list(struct net_device *dev)
 {
 	struct netdev_hw_addr *ha;
-	struct wilc_priv *priv;
-	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 	int i = 0;
 
-	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	vif = netdev_priv(dev);
-	hif_drv = (struct host_if_drv *)priv->hif_drv;
 
 	if (dev->flags & IFF_PROMISC)
 		return;
@@ -1114,7 +1108,6 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	s8 rssi;
 	u32 size = 0, length = 0;
 	struct wilc_vif *vif;
-	struct wilc_priv *priv;
 	s32 ret = 0;
 	struct wilc *wilc;
 
@@ -1138,7 +1131,6 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 				return PTR_ERR(buff);
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
-				priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 				ret = wilc_get_rssi(vif, &rssi);
 				netdev_info(ndev, "RSSI :%d\n", rssi);
 
-- 
1.9.1

