Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26609 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030348AbbKEFep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:34:45 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 13/38] staging: wilc1000: rename pstrWFIDrv of function wilc_set_multicast_list
Date: Thu, 5 Nov 2015 14:36:14 +0900
Message-ID: <1446701799-24870-13-git-send-email-glen.lee@atmel.com> (sfid-20151105_063448_515095_D6E525B7)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrWFIDrv of function wilc_set_multicast_list to hif_drv
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 75edfa3..6250abb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1290,11 +1290,11 @@ static void wilc_set_multicast_list(struct net_device *dev)
 
 	struct netdev_hw_addr *ha;
 	struct wilc_priv *priv;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *hif_drv;
 	int i = 0;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	if (!dev)
 		return;
@@ -1314,14 +1314,14 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		/* get all multicast packets */
-		host_int_setup_multicast_filter(pstrWFIDrv, false, 0);
+		host_int_setup_multicast_filter(hif_drv, false, 0);
 		return;
 	}
 
 	/* No multicast?  Just get our own stuff */
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		host_int_setup_multicast_filter(pstrWFIDrv, true, 0);
+		host_int_setup_multicast_filter(hif_drv, true, 0);
 		return;
 	}
 
@@ -1339,7 +1339,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		i++;
 	}
 
-	host_int_setup_multicast_filter(pstrWFIDrv, true, (dev->mc.count));
+	host_int_setup_multicast_filter(hif_drv, true, (dev->mc.count));
 
 	return;
 
-- 
1.9.1

