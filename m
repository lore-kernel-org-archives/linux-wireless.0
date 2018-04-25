Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28418 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756054AbeDYRUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:20:15 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 20/21] staging: wilc1000: change function to static in linux_wlan
Date: Wed, 25 Apr 2018 22:48:25 +0530
Message-ID: <1524676706-13179-21-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192019_233979_F9393E75)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Defined function as static which are used only in single file. And also removed
their declaration from header file.
Below function are changed to static
wilc_wlan_initialize()
wilc_wlan_deinitialize()
wilc_wlan_get_firmware()

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b6a8165..1643166 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -315,7 +315,7 @@ static int linux_wlan_txq_task(void *vp)
 	return 0;
 }
 
-int wilc_wlan_get_firmware(struct net_device *dev)
+static int wilc_wlan_get_firmware(struct net_device *dev)
 {
 	struct wilc_vif *vif;
 	struct wilc *wilc;
@@ -604,7 +604,7 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	return -1;
 }
 
-void wilc_wlan_deinitialize(struct net_device *dev)
+static void wilc_wlan_deinitialize(struct net_device *dev)
 {
 	struct wilc_vif *vif;
 	struct wilc *wl;
@@ -719,7 +719,7 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 	}
 }
 
-int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
+static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 {
 	int ret = 0;
 	struct wilc *wl = vif->wilc;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 5f4dbff..ab94d78f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -207,16 +207,12 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif);
-
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     int gpio, const struct wilc_hif_func *ops);
-void wilc_wlan_deinitialize(struct net_device *dev);
 void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-int wilc_wlan_get_firmware(struct net_device *dev);
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
 
 #endif
-- 
2.7.4
