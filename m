Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755853AbeDYRUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:20:02 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 15/21] staging: wilc1000: rename wlan init and deinit function prefixed with wil1000
Date: Wed, 25 Apr 2018 22:48:20 +0530
Message-ID: <1524676706-13179-16-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192006_644590_6D4F4655)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename wilc1000_wlan_init() & wilc1000_wlan_deinit() function to avoid
unecessary 'wilc1000' prefix in function to be inline with other
function naming convension.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f09d6a8..b6a8165 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -604,7 +604,7 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	return -1;
 }
 
-void wilc1000_wlan_deinit(struct net_device *dev)
+void wilc_wlan_deinitialize(struct net_device *dev)
 {
 	struct wilc_vif *vif;
 	struct wilc *wl;
@@ -719,7 +719,7 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 	}
 }
 
-int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
+int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 {
 	int ret = 0;
 	struct wilc *wl = vif->wilc;
@@ -846,7 +846,7 @@ static int wilc_mac_open(struct net_device *ndev)
 	if (ret < 0)
 		return ret;
 
-	ret = wilc1000_wlan_init(ndev, vif);
+	ret = wilc_wlan_initialize(ndev, vif);
 	if (ret < 0) {
 		wilc_deinit_host_int(ndev);
 		return ret;
@@ -869,7 +869,7 @@ static int wilc_mac_open(struct net_device *ndev)
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		netdev_err(ndev, "Wrong MAC address\n");
 		wilc_deinit_host_int(ndev);
-		wilc1000_wlan_deinit(ndev);
+		wilc_wlan_deinitialize(ndev);
 		return -EINVAL;
 	}
 
@@ -1038,7 +1038,7 @@ static int wilc_mac_close(struct net_device *ndev)
 	if (wl->open_ifcs == 0) {
 		netdev_dbg(ndev, "Deinitializing wilc1000\n");
 		wl->close = 1;
-		wilc1000_wlan_deinit(ndev);
+		wilc_wlan_deinitialize(ndev);
 		WILC_WFI_deinit_mon_interface();
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4bc1899..0a91468 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -218,14 +218,14 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif);
+int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif);
 
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     int gpio, const struct wilc_hif_func *ops);
-void wilc1000_wlan_deinit(struct net_device *dev);
+void wilc_wlan_deinitialize(struct net_device *dev);
 void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 int wilc_wlan_get_firmware(struct net_device *dev);
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
-- 
2.7.4
