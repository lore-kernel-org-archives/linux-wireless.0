Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41306 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJgN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:13 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/24] staging: wilc1000: move 'wilc_enable_ps' global variable into 'wilc' struct
Date: Tue, 14 Aug 2018 12:19:53 +0530
Message-ID: <1534229416-13254-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085027_674887_FD55800F)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having 'wilc_enable_ps' as global variable moved it to 'wilc'
structure. Rename 'wilc_enable_ps' to 'enable_ps' as its already part of
'wilc' structure

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  5 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 drivers/staging/wilc1000/wilc_wlan.h              |  1 -
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 01cf4bd..57e3176 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -12,8 +12,6 @@
 
 #include "wilc_wfi_cfgoperations.h"
 
-bool wilc_enable_ps = true;
-
 static int dev_state_ev_handler(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
@@ -54,7 +52,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
 			del_timer(&wilc_during_ip_timer);
 		}
 
-		if (wilc_enable_ps)
+		if (vif->wilc->enable_ps)
 			wilc_set_power_mgmt(vif, 1, 0);
 
 		netdev_dbg(dev, "[%s] Up IP\n", dev_iface->ifa_label);
@@ -1066,6 +1064,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	*wilc = wl;
 	wl->io_type = io_type;
 	wl->hif_func = ops;
+	wl->enable_ps = true;
 	INIT_LIST_HEAD(&wl->txq_head.list);
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7cd0330..4727a8a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1732,7 +1732,7 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (!priv->hif_drv)
 		return -EIO;
 
-	if (wilc_enable_ps)
+	if (vif->wilc->enable_ps)
 		wilc_set_power_mgmt(vif, enabled, timeout);
 
 	return 0;
@@ -1764,7 +1764,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		memset(priv->assoc_stainfo.sta_associated_bss, 0,
 		       MAX_NUM_STA * ETH_ALEN);
 
-		wilc_enable_ps = true;
+		wl->enable_ps = true;
 		wilc_set_power_mgmt(vif, 1, 0);
 		break;
 
@@ -1776,12 +1776,12 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		vif->iftype = CLIENT_MODE;
 		wilc_set_operation_mode(vif, STATION_MODE);
 
-		wilc_enable_ps = false;
+		wl->enable_ps = false;
 		wilc_set_power_mgmt(vif, 0, 0);
 		break;
 
 	case NL80211_IFTYPE_AP:
-		wilc_enable_ps = false;
+		wl->enable_ps = false;
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->iftype = AP_MODE;
@@ -1803,7 +1803,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		priv->wdev->iftype = type;
 		vif->iftype = GO_MODE;
 
-		wilc_enable_ps = false;
+		wl->enable_ps = false;
 		wilc_set_power_mgmt(vif, 0, 0);
 		break;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index b7eee77..8b74d61 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -166,6 +166,7 @@ struct wilc {
 	bool suspend_event;
 
 	struct rf_info dummy_statistics;
+	bool enable_ps;
 };
 
 struct wilc_wfi_mon_priv {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 7467188..1f874d1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -289,7 +289,6 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 void host_wakeup_notify(struct wilc *wilc);
 void host_sleep_notify(struct wilc *wilc);
-extern bool wilc_enable_ps;
 void chip_allow_sleep(struct wilc *wilc);
 void chip_wakeup(struct wilc *wilc);
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
-- 
2.7.4
