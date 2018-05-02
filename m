Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:63761 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbeEBHPb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:31 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/21] staging: wilc1000: rename WILC_WFI_deinit_mon_interface to avoid uppercase for function name
Date: Wed, 2 May 2018 12:43:38 +0530
Message-ID: <1525245227-3924-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093236_804142_1D4E7AAE)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes to avoid the use of uppercase for function name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 2 +-
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 1ee9ca3..a08ee9c 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -252,7 +252,7 @@ struct net_device *wilc_wfi_init_mon_interface(const char *name,
 	return wilc_wfi_mon;
 }
 
-int WILC_WFI_deinit_mon_interface(void)
+int wilc_wfi_deinit_mon_interface(void)
 {
 	bool rollback_lock = false;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f66704d..4208548 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1012,7 +1012,7 @@ static int wilc_mac_close(struct net_device *ndev)
 		netdev_dbg(ndev, "Deinitializing wilc1000\n");
 		wl->close = 1;
 		wilc_wlan_deinitialize(ndev);
-		WILC_WFI_deinit_mon_interface();
+		wilc_wfi_deinit_mon_interface();
 	}
 
 	vif->mac_opened = 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index f41ce84..c1a2421 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -8,7 +8,7 @@ void wilc_free_wiphy(struct net_device *net);
 int wilc_deinit_host_int(struct net_device *net);
 int wilc_init_host_int(struct net_device *net);
 void wilc_wfi_monitor_rx(u8 *buff, u32 size);
-int WILC_WFI_deinit_mon_interface(void);
+int wilc_wfi_deinit_mon_interface(void);
 struct net_device *wilc_wfi_init_mon_interface(const char *name,
 					       struct net_device *real_dev);
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
-- 
2.7.4
