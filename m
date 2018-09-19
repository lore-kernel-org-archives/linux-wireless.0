Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2297 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbeISLly (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:41:54 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/29] staging: wilc1000: change return type to 'void' for wilc_wlan_set_bssid()
Date: Wed, 19 Sep 2018 11:34:52 +0530
Message-ID: <1537337119-14952-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080537_171600_92F654D3)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use 'void' return type for wilc_wlan_set_bssid(),
as its always returns the same value.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 4 +---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 49afda6..d1d2c64 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -192,14 +192,12 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	return NULL;
 }
 
-int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode)
+void wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode)
 {
 	struct wilc_vif *vif = netdev_priv(wilc_netdev);
 
 	memcpy(vif->bssid, bssid, 6);
 	vif->mode = mode;
-
-	return 0;
 }
 
 int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 1837808..30151b2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -215,6 +215,6 @@ void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     const struct wilc_hif_func *ops);
 void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
+void wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
 
 #endif
-- 
2.7.4
