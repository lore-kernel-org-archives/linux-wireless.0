Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1383 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbeEBHO6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:14:58 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/21] staging: wilc1000: remove inner block in wilc_netdev_init()
Date: Wed, 2 May 2018 12:43:27 +0530
Message-ID: <1525245227-3924-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092057_531745_C27E13B9)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove unnecessary inner block ( {/**/} ) in
wilc_netdev_init().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 35e30c5..491baeb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1141,6 +1141,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
+		struct wireless_dev *wdev;
+
 		ndev = alloc_etherdev(sizeof(struct wilc_vif));
 		if (!ndev)
 			return -ENOMEM;
@@ -1163,28 +1165,24 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 		ndev->netdev_ops = &wilc_netdev_ops;
 
-		{
-			struct wireless_dev *wdev;
-
-			wdev = wilc_create_wiphy(ndev, dev);
+		wdev = wilc_create_wiphy(ndev, dev);
 
-			if (dev)
-				SET_NETDEV_DEV(ndev, dev);
+		if (dev)
+			SET_NETDEV_DEV(ndev, dev);
 
-			if (!wdev) {
-				netdev_err(ndev, "Can't register WILC Wiphy\n");
-				return -1;
-			}
-
-			vif->ndev->ieee80211_ptr = wdev;
-			vif->ndev->ml_priv = vif;
-			wdev->netdev = vif->ndev;
-			vif->netstats.rx_packets = 0;
-			vif->netstats.tx_packets = 0;
-			vif->netstats.rx_bytes = 0;
-			vif->netstats.tx_bytes = 0;
+		if (!wdev) {
+			netdev_err(ndev, "Can't register WILC Wiphy\n");
+			return -1;
 		}
 
+		vif->ndev->ieee80211_ptr = wdev;
+		vif->ndev->ml_priv = vif;
+		wdev->netdev = vif->ndev;
+		vif->netstats.rx_packets = 0;
+		vif->netstats.tx_packets = 0;
+		vif->netstats.rx_bytes = 0;
+		vif->netstats.tx_bytes = 0;
+
 		ret = register_netdev(ndev);
 		if (ret)
 			return ret;
-- 
2.7.4
