Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57888 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJga (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:30 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/24] staging: wilc1000: move during_ip_timer & wilc_optaining_ip to 'wilc_vif' struct
Date: Tue, 14 Aug 2018 12:19:58 +0530
Message-ID: <1534229416-13254-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085044_971406_B8D98C8C)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move global variable 'wilc_during_ip_timer' and 'wilc_optaining_ip' to
'wilc_vif' structure.

Rename these variables like below

wilc_during_ip_timer -> during_ip_timer
wilc_optaining_ip -> obtaining_ip.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 15 +++++++-------
 drivers/staging/wilc1000/host_interface.h         |  2 --
 drivers/staging/wilc1000/linux_wlan.c             |  6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 24 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 ++
 5 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 42d8acc..11eb632 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -186,7 +186,6 @@ struct join_bss_param {
 };
 
 static struct host_if_drv *terminated_handle;
-bool wilc_optaining_ip;
 static u8 p2p_listen_state;
 static struct workqueue_struct *hif_workqueue;
 static struct completion hif_driver_comp;
@@ -791,7 +790,7 @@ static void handle_scan(struct work_struct *work)
 		goto error;
 	}
 
-	if (wilc_optaining_ip || wilc_connecting) {
+	if (vif->obtaining_ip || wilc_connecting) {
 		netdev_err(vif->ndev, "Don't do obss scan\n");
 		result = -EBUSY;
 		goto error;
@@ -1562,8 +1561,8 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 
 		hif_drv->hif_state = HOST_IF_CONNECTED;
 
-		wilc_optaining_ip = true;
-		mod_timer(&wilc_during_ip_timer,
+		vif->obtaining_ip = true;
+		mod_timer(&vif->during_ip_timer,
 			  jiffies + msecs_to_jiffies(10000));
 	} else {
 		hif_drv->hif_state = HOST_IF_IDLE;
@@ -1595,7 +1594,7 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 	disconn_info.ie_len = 0;
 
 	if (conn_result) {
-		wilc_optaining_ip = false;
+		vif->obtaining_ip = false;
 		wilc_set_power_mgmt(vif, 0, 0);
 
 		conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL, 0,
@@ -1942,7 +1941,7 @@ static void handle_disconnect(struct work_struct *work)
 	wid.val = (s8 *)&dummy_reason_code;
 	wid.size = sizeof(char);
 
-	wilc_optaining_ip = false;
+	vif->obtaining_ip = false;
 	wilc_set_power_mgmt(vif, 0, 0);
 
 	eth_zero_addr(wilc_connected_ssid);
@@ -2397,7 +2396,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 		goto error;
 	}
 
-	if (wilc_optaining_ip || wilc_connecting) {
+	if (vif->obtaining_ip || wilc_connecting) {
 		result = -EBUSY;
 		goto error;
 	}
@@ -3455,7 +3454,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 			break;
 		}
 
-	wilc_optaining_ip = false;
+	vif->obtaining_ip = false;
 
 	if (clients_count == 0) {
 		init_completion(&hif_driver_comp);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 84866a6..d026f44 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -361,11 +361,9 @@ int wilc_get_vif_idx(struct wilc_vif *vif);
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
 int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
 
-extern bool wilc_optaining_ip;
 extern u8 wilc_connected_ssid[6];
 extern u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 extern int wilc_connecting;
-extern struct timer_list wilc_during_ip_timer;
 
 #endif
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 57e3176..283bb74 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -48,8 +48,8 @@ static int dev_state_ev_handler(struct notifier_block *this,
 	case NETDEV_UP:
 		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
 			hif_drv->ifc_up = 1;
-			wilc_optaining_ip = false;
-			del_timer(&wilc_during_ip_timer);
+			vif->obtaining_ip = false;
+			del_timer(&vif->during_ip_timer);
 		}
 
 		if (vif->wilc->enable_ps)
@@ -68,7 +68,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
 	case NETDEV_DOWN:
 		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
 			hif_drv->ifc_up = 0;
-			wilc_optaining_ip = false;
+			vif->obtaining_ip = false;
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1eac244..1690890 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -82,7 +82,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY
 };
 
-struct timer_list wilc_during_ip_timer;
 static u8 op_ifcs;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
@@ -261,9 +260,11 @@ static void remove_network_from_shadow(struct timer_list *t)
 			  jiffies + msecs_to_jiffies(AGING_TIME));
 }
 
-static void clear_during_ip(struct timer_list *unused)
+static void clear_during_ip(struct timer_list *t)
 {
-	wilc_optaining_ip = false;
+	struct wilc_vif *vif = from_timer(vif, t, during_ip_timer);
+
+	vif->obtaining_ip = false;
 }
 
 static int is_network_in_shadow(struct network_info *nw_info,
@@ -518,7 +519,7 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 					conn_info->resp_ies_len, connect_status,
 					GFP_KERNEL);
 	} else if (conn_disconn_evt == CONN_DISCONN_EVENT_DISCONN_NOTIF) {
-		wilc_optaining_ip = false;
+		vif->obtaining_ip = false;
 		p2p_local_random = 0x01;
 		p2p_recv_random = 0x00;
 		wilc_ie = false;
@@ -1743,8 +1744,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
 	wilc_ie = false;
-	wilc_optaining_ip = false;
-	del_timer(&wilc_during_ip_timer);
+	vif->obtaining_ip = false;
+	del_timer(&vif->during_ip_timer);
 
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
@@ -1789,8 +1790,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	case NL80211_IFTYPE_P2P_GO:
-		wilc_optaining_ip = true;
-		mod_timer(&wilc_during_ip_timer,
+		vif->obtaining_ip = true;
+		mod_timer(&vif->during_ip_timer,
 			  jiffies + msecs_to_jiffies(DURING_IP_TIME_OUT));
 		wilc_set_operation_mode(vif, AP_MODE);
 		dev->ieee80211_ptr->iftype = type;
@@ -2159,10 +2160,10 @@ int wilc_init_host_int(struct net_device *net)
 {
 	int ret;
 	struct wilc_priv *priv = wdev_priv(net->ieee80211_ptr);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	timer_setup(&priv->aging_timer, remove_network_from_shadow, 0);
-	if (op_ifcs == 0)
-		timer_setup(&wilc_during_ip_timer, clear_during_ip, 0);
+	timer_setup(&vif->during_ip_timer, clear_during_ip, 0);
 	op_ifcs++;
 
 	priv->p2p_listen_state = false;
@@ -2190,8 +2191,7 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	del_timer_sync(&priv->aging_timer);
 	clear_shadow_scan(priv);
-	if (op_ifcs == 0)
-		del_timer_sync(&wilc_during_ip_timer);
+	del_timer_sync(&vif->during_ip_timer);
 
 	if (ret)
 		netdev_err(net, "Error while deinitializing host interface\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3767e31..8e56a28 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -118,6 +118,8 @@ struct wilc_vif {
 	struct net_device *ndev;
 	u8 mode;
 	u8 ifc_id;
+	struct timer_list during_ip_timer;
+	bool obtaining_ip;
 };
 
 struct wilc {
-- 
2.7.4
