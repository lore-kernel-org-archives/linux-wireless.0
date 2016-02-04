Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9900 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbcBDJZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:25:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 23/70] staging: wilc1000: fixes variable dereferenced before check
Date: Thu, 4 Feb 2016 18:15:40 +0900
Message-ID: <1454577387-509-24-git-send-email-glen.lee@atmel.com> (sfid-20160204_103028_088319_E5D3DFEA)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warning reported by smatch.
 - wilc_wlan_get_firmware() warn: variable dereferenced before check 'vif'
 - wilc_set_multicast_list() warn: variable dereferenced before check 'dev'

Just delete them and no need add null check since they are net_device from
ndo_set_rx_mode of net_device_ops and vif of netdev_priv.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9ca33536..22a2f98 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -397,9 +397,6 @@ int wilc_wlan_get_firmware(struct net_device *dev)
 
 	netdev_info(dev, "loading firmware %s\n", firmware);
 
-	if (!vif)
-		goto _fail_;
-
 	if (!(&vif->ndev->dev))
 		goto _fail_;
 
@@ -1017,9 +1014,6 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	vif = netdev_priv(dev);
 	hif_drv = (struct host_if_drv *)priv->hif_drv;
 
-	if (!dev)
-		return;
-
 	if (dev->flags & IFF_PROMISC)
 		return;
 
-- 
1.9.1

