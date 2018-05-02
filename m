Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:3905 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbeEBHP2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:28 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/21] staging: wilc1000: rename WILC_WFI_init_mon_interface to avoid uppercase in function name
Date: Wed, 2 May 2018 12:43:37 +0530
Message-ID: <1525245227-3924-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092102_234584_19FBAC6C)
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
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index d5af736..1ee9ca3 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -222,7 +222,7 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
 
 };
 
-struct net_device *WILC_WFI_init_mon_interface(const char *name,
+struct net_device *wilc_wfi_init_mon_interface(const char *name,
 					       struct net_device *real_dev)
 {
 	struct wilc_wfi_mon_priv *priv;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 827afe9..579e04a2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2065,7 +2065,7 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 	vif = netdev_priv(priv->wdev->netdev);
 
 	if (type == NL80211_IFTYPE_MONITOR) {
-		new_ifc = WILC_WFI_init_mon_interface(name, vif->ndev);
+		new_ifc = wilc_wfi_init_mon_interface(name, vif->ndev);
 		if (new_ifc) {
 			vif = netdev_priv(priv->wdev->netdev);
 			vif->monitor_flag = 1;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index a0a07b4..f41ce84 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -9,7 +9,8 @@ int wilc_deinit_host_int(struct net_device *net);
 int wilc_init_host_int(struct net_device *net);
 void wilc_wfi_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
-struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
+struct net_device *wilc_wfi_init_mon_interface(const char *name,
+					       struct net_device *real_dev);
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      u16 frame_type, bool reg);
 
-- 
2.7.4
