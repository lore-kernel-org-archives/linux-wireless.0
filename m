Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12379 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:05:45 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 03/29] staging: wilc1000: change return type to 'void' for lock init & deinit functions
Date: Thu, 20 Sep 2018 11:53:14 +0530
Message-ID: <1537424620-6982-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082406_114465_90E6415B)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use 'void' return type for wlan_deinit_locks() &
wlan_init_locks(), as same value is return.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d1d2c64..e2669b9 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -525,7 +525,7 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	return -1;
 }
 
-static int wlan_deinit_locks(struct net_device *dev)
+static void wlan_deinit_locks(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
@@ -533,8 +533,6 @@ static int wlan_deinit_locks(struct net_device *dev)
 	mutex_destroy(&wilc->hif_cs);
 	mutex_destroy(&wilc->rxq_cs);
 	mutex_destroy(&wilc->txq_add_to_head_cs);
-
-	return 0;
 }
 
 static void wlan_deinitialize_threads(struct net_device *dev)
@@ -588,7 +586,7 @@ static void wilc_wlan_deinitialize(struct net_device *dev)
 	}
 }
 
-static int wlan_init_locks(struct net_device *dev)
+static void wlan_init_locks(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wl = vif->wilc;
@@ -604,8 +602,6 @@ static int wlan_init_locks(struct net_device *dev)
 	init_completion(&wl->cfg_event);
 	init_completion(&wl->sync_event);
 	init_completion(&wl->txq_thread_started);
-
-	return 0;
 }
 
 static int wlan_initialize_threads(struct net_device *dev)
-- 
2.7.4
