Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12606 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbeIDLE4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:56 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 25/26] staging: wilc1000: refactor wilc_netdev_init() to handle memory free in error path
Date: Tue, 4 Sep 2018 12:09:41 +0530
Message-ID: <1536043182-19735-26-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084123_797596_87AEDB6F)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the wilc_netdev_init() to cleanup the memory for error
scenario and remove unnecessary 'dev' pointer check.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 36 ++++++++++++++++-------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 +++-
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d7d43fd..91a45a7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1073,10 +1073,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 
 	wl->hif_workqueue = create_singlethread_workqueue("WILC_wq");
-	if (!wl->hif_workqueue) {
-		kfree(wl);
-		return -ENOMEM;
-	}
+	if (!wl->hif_workqueue)
+		goto free_wl;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
@@ -1085,7 +1083,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 		ndev = alloc_etherdev(sizeof(struct wilc_vif));
 		if (!ndev)
-			return -ENOMEM;
+			goto free_ndev;
 
 		vif = netdev_priv(ndev);
 		memset(vif, 0, sizeof(struct wilc_vif));
@@ -1106,15 +1104,13 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		wdev = wilc_create_wiphy(ndev, dev);
-
-		if (dev)
-			SET_NETDEV_DEV(ndev, dev);
-
 		if (!wdev) {
 			netdev_err(ndev, "Can't register WILC Wiphy\n");
-			return -1;
+			goto free_ndev;
 		}
 
+		SET_NETDEV_DEV(ndev, dev);
+
 		vif->ndev->ieee80211_ptr = wdev;
 		vif->ndev->ml_priv = vif;
 		wdev->netdev = vif->ndev;
@@ -1125,11 +1121,29 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 		ret = register_netdev(ndev);
 		if (ret)
-			return ret;
+			goto free_ndev;
 
 		vif->iftype = STATION_MODE;
 		vif->mac_opened = 0;
 	}
 
 	return 0;
+
+free_ndev:
+	for (; i >= 0; i--) {
+		if (wl->vif[i]) {
+			if (wl->vif[i]->iftype == STATION_MODE)
+				unregister_netdev(wl->vif[i]->ndev);
+
+			if (wl->vif[i]->ndev) {
+				wilc_free_wiphy(wl->vif[i]->ndev);
+				free_netdev(wl->vif[i]->ndev);
+			}
+		}
+	}
+	unregister_inetaddr_notifier(&g_dev_notifier);
+	destroy_workqueue(wl->hif_workqueue);
+free_wl:
+	kfree(wl);
+	return -ENOMEM;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d103dce2..37c26d4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2145,8 +2145,12 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net,
 	set_wiphy_dev(wdev->wiphy, dev);
 
 	ret = wiphy_register(wdev->wiphy);
-	if (ret)
+	if (ret) {
 		netdev_err(net, "Cannot register wiphy device\n");
+		wiphy_free(wdev->wiphy);
+		kfree(wdev);
+		return NULL;
+	}
 
 	priv->dev = net;
 	return wdev;
-- 
2.7.4
