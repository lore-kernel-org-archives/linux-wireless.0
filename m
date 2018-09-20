Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40789 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbeITMHY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:07:24 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 29/29] staging: wilc1000: return exact error of register_netdev() from wilc_netdev_init()
Date: Thu, 20 Sep 2018 11:53:40 +0530
Message-ID: <1537424620-6982-30-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082632_429298_D7DEAB89)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor wilc_netdev_init() to return the error code received from
register_netdev() during the failure condition.

Earlier discussion link
[1]. https://www.spinics.net/lists/linux-wireless/msg177304.html

Suggested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 29c1317..b5e6765 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1065,7 +1065,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	if (!wl)
 		return -ENOMEM;
 
-	if (wilc_wlan_cfg_init(wl))
+	ret = wilc_wlan_cfg_init(wl);
+	if (ret)
 		goto free_wl;
 
 	*wilc = wl;
@@ -1077,8 +1078,10 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 
 	wl->hif_workqueue = create_singlethread_workqueue("WILC_wq");
-	if (!wl->hif_workqueue)
+	if (!wl->hif_workqueue) {
+		ret = -ENOMEM;
 		goto free_cfg;
+	}
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
@@ -1086,8 +1089,10 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		struct wireless_dev *wdev;
 
 		ndev = alloc_etherdev(sizeof(struct wilc_vif));
-		if (!ndev)
+		if (!ndev) {
+			ret = -ENOMEM;
 			goto free_ndev;
+		}
 
 		vif = netdev_priv(ndev);
 		memset(vif, 0, sizeof(struct wilc_vif));
@@ -1110,6 +1115,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		wdev = wilc_create_wiphy(ndev, dev);
 		if (!wdev) {
 			netdev_err(ndev, "Can't register WILC Wiphy\n");
+			ret = -ENOMEM;
 			goto free_ndev;
 		}
 
@@ -1151,7 +1157,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	wilc_wlan_cfg_deinit(wl);
 free_wl:
 	kfree(wl);
-	return -ENOMEM;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_init);
 
-- 
2.7.4
