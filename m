Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33729 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730841AbeISLnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:43:14 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 24/29] staging: wilc1000: remove p2p related static variables to wilc_vif struct
Date: Wed, 19 Sep 2018 11:35:14 +0530
Message-ID: <1537337119-14952-25-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080657_211657_FD6E3D22)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid use of static variable and move them as part of private
data(wilc_priv) struct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  2 +
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 60 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  7 +++
 3 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 560c168..695d5b2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -729,6 +729,7 @@ static int wilc_mac_open(struct net_device *ndev)
 {
 	struct wilc_vif *vif = netdev_priv(ndev);
 	struct wilc *wl = vif->wilc;
+	struct wilc_priv *priv = wdev_priv(vif->ndev->ieee80211_ptr);
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
 	int i = 0;
@@ -782,6 +783,7 @@ static int wilc_mac_open(struct net_device *ndev)
 				 vif->frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	wl->open_ifcs++;
+	priv->p2p.local_random = 0x01;
 	vif->mac_opened = 1;
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1a4d262..4fbbbbd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -137,10 +137,7 @@ struct p2p_mgmt_data {
 static u8 wlan_channel = INVALID_CHANNEL;
 static u8 curr_channel;
 static u8 p2p_oui[] = {0x50, 0x6f, 0x9A, 0x09};
-static u8 p2p_local_random = 0x01;
-static u8 p2p_recv_random;
 static u8 p2p_vendor_spec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
-static bool wilc_ie;
 
 static struct ieee80211_supported_band wilc_band_2ghz = {
 	.channels = ieee80211_2ghz_channels,
@@ -515,9 +512,9 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 					GFP_KERNEL);
 	} else if (conn_disconn_evt == CONN_DISCONN_EVENT_DISCONN_NOTIF) {
 		vif->obtaining_ip = false;
-		p2p_local_random = 0x01;
-		p2p_recv_random = 0x00;
-		wilc_ie = false;
+		priv->p2p.local_random = 0x01;
+		priv->p2p.recv_random = 0x00;
+		priv->p2p.is_wilc_ie = false;
 		eth_zero_addr(priv->associated_bss);
 		wilc_wlan_set_bssid(priv->dev, null_bssid, STATION_MODE);
 
@@ -829,9 +826,9 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev,
 		wlan_channel = INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, null_bssid, STATION_MODE);
 
-	p2p_local_random = 0x01;
-	p2p_recv_random = 0x00;
-	wilc_ie = false;
+	priv->p2p.local_random = 0x01;
+	priv->p2p.recv_random = 0x00;
+	priv->p2p.is_wilc_ie = false;
 	wfi_drv->p2p_timeout = 0;
 
 	ret = wilc_disconnect(vif, reason_code);
@@ -1330,20 +1327,21 @@ static void wilc_wfi_cfg_parse_rx_vendor_spec(struct wilc_priv *priv, u8 *buff,
 	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	subtype = buff[P2P_PUB_ACTION_SUBTYPE];
-	if ((subtype == GO_NEG_REQ || subtype == GO_NEG_RSP) && !wilc_ie) {
+	if ((subtype == GO_NEG_REQ || subtype == GO_NEG_RSP) &&
+	    !priv->p2p.is_wilc_ie) {
 		for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++) {
 			if (!memcmp(p2p_vendor_spec, &buff[i], 6)) {
-				p2p_recv_random = buff[i + 6];
-				wilc_ie = true;
+				priv->p2p.recv_random = buff[i + 6];
+				priv->p2p.is_wilc_ie = true;
 				break;
 			}
 		}
 	}
 
-	if (p2p_local_random <= p2p_recv_random) {
+	if (priv->p2p.local_random <= priv->p2p.recv_random) {
 		netdev_dbg(vif->ndev,
 			   "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n",
-			   p2p_local_random, p2p_recv_random);
+			   priv->p2p.local_random, priv->p2p.recv_random);
 		return;
 	}
 
@@ -1411,7 +1409,7 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 								  size);
 
 			if ((subtype == GO_NEG_REQ || subtype == GO_NEG_RSP) &&
-			    wilc_ie)
+			    priv->p2p.is_wilc_ie)
 				size -= 7;
 
 			break;
@@ -1503,7 +1501,8 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 			priv->remain_on_ch_params.listen_session_id);
 }
 
-static void wilc_wfi_cfg_tx_vendor_spec(struct p2p_mgmt_data *mgmt_tx,
+static void wilc_wfi_cfg_tx_vendor_spec(struct wilc_priv *priv,
+					struct p2p_mgmt_data *mgmt_tx,
 					struct cfg80211_mgmt_tx_params *params,
 					u8 iftype, u32 buf_len)
 {
@@ -1513,17 +1512,16 @@ static void wilc_wfi_cfg_tx_vendor_spec(struct p2p_mgmt_data *mgmt_tx,
 	u8 subtype = buf[P2P_PUB_ACTION_SUBTYPE];
 
 	if (subtype == GO_NEG_REQ || subtype == GO_NEG_RSP) {
-		if (p2p_local_random == 1 &&
-		    p2p_recv_random < p2p_local_random) {
-			get_random_bytes(&p2p_local_random, 1);
-			p2p_local_random++;
+		if (priv->p2p.local_random == 1 &&
+		    priv->p2p.recv_random < priv->p2p.local_random) {
+			get_random_bytes(&priv->p2p.local_random, 1);
+			priv->p2p.local_random++;
 		}
 	}
 
-	if (p2p_local_random <= p2p_recv_random || !(subtype == GO_NEG_REQ ||
-						     subtype == GO_NEG_RSP ||
-						     subtype == P2P_INV_REQ ||
-						     subtype == P2P_INV_RSP))
+	if (priv->p2p.local_random <= priv->p2p.recv_random ||
+	    !(subtype == GO_NEG_REQ || subtype == GO_NEG_RSP ||
+	      subtype == P2P_INV_REQ || subtype == P2P_INV_RSP))
 		return;
 
 	for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
@@ -1547,7 +1545,7 @@ static void wilc_wfi_cfg_tx_vendor_spec(struct p2p_mgmt_data *mgmt_tx,
 
 		memcpy(&mgmt_tx->buff[len], p2p_vendor_spec,
 		       vendor_spec_len);
-		mgmt_tx->buff[len + vendor_spec_len] = p2p_local_random;
+		mgmt_tx->buff[len + vendor_spec_len] = priv->p2p.local_random;
 		mgmt_tx->size = buf_len;
 	}
 }
@@ -1566,7 +1564,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 	struct host_if_drv *wfi_drv = priv->hif_drv;
 	struct wilc_vif *vif = netdev_priv(wdev->netdev);
-	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(p2p_local_random);
+	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(priv->p2p.local_random);
 	int ret = 0;
 
 	*cookie = (unsigned long)buf;
@@ -1614,8 +1612,8 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 		case PUBLIC_ACT_VENDORSPEC:
 			if (!memcmp(p2p_oui, &buf[ACTION_SUBTYPE_ID + 1], 4))
-				wilc_wfi_cfg_tx_vendor_spec(mgmt_tx, params,
-							    vif->iftype,
+				wilc_wfi_cfg_tx_vendor_spec(priv, mgmt_tx,
+							    params, vif->iftype,
 							    buf_len);
 			else
 				netdev_dbg(vif->ndev,
@@ -1743,9 +1741,9 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wl = vif->wilc;
 
-	p2p_local_random = 0x01;
-	p2p_recv_random = 0x00;
-	wilc_ie = false;
+	priv->p2p.local_random = 0x01;
+	priv->p2p.recv_random = 0x00;
+	priv->p2p.is_wilc_ie = false;
 	vif->obtaining_ip = false;
 	del_timer(&vif->during_ip_timer);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4ba5887..4f05a16 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -69,6 +69,12 @@ struct wilc_wfi_p2p_listen_params {
 	u32 listen_session_id;
 };
 
+struct wilc_p2p_var {
+	u8 local_random;
+	u8 recv_random;
+	bool is_wilc_ie;
+};
+
 struct wilc_priv {
 	struct wireless_dev *wdev;
 	struct cfg80211_scan_request *scan_req;
@@ -98,6 +104,7 @@ struct wilc_priv {
 	struct timer_list aging_timer;
 	struct network_info scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 	int scanned_cnt;
+	struct wilc_p2p_var p2p;
 };
 
 struct frame_reg {
-- 
2.7.4
