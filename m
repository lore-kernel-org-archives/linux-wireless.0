Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43635 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbbJNLsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:48:02 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/16] staging: wilc1000: rename aBSSID in the struct wilc_vif
Date: Wed, 14 Oct 2015 20:46:37 +0900
Message-ID: <1444823204-16736-9-git-send-email-tony.cho@atmel.com> (sfid-20151014_134811_531203_A3CA4D2F)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames aBSSID in the struct wilc_vif to the bssid.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 14 +++++++-------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 +++---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ed21ba8..6478f6e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -367,8 +367,8 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid1 = pMacHeader + 4;
 
 	for (i = 0; i < wl->vif_num; i++)
-		if (!memcmp(Bssid1, wl->vif[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, wl->vif[i].aBSSID, ETH_ALEN))
+		if (!memcmp(Bssid1, wl->vif[i].bssid, ETH_ALEN) ||
+		    !memcmp(Bssid, wl->vif[i].bssid, ETH_ALEN))
 			return wl->vif[i].wilc_netdev;
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
@@ -377,8 +377,8 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
 	for (i = 0; i < wl->vif_num; i++)
-		if (!memcmp(Bssid1, wl->vif[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, wl->vif[i].aBSSID, ETH_ALEN))
+		if (!memcmp(Bssid1, wl->vif[i].bssid, ETH_ALEN) ||
+		    !memcmp(Bssid, wl->vif[i].bssid, ETH_ALEN))
 			return wl->vif[i].wilc_netdev;
 
 	PRINT_INFO(INIT_DBG, "\n");
@@ -393,7 +393,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
 	for (i = 0; i < wl->vif_num; i++)
 		if (wl->vif[i].wilc_netdev == wilc_netdev) {
-			memcpy(wl->vif[i].aBSSID, pBSSID, 6);
+			memcpy(wl->vif[i].bssid, pBSSID, 6);
 			ret = 0;
 			break;
 		}
@@ -409,7 +409,7 @@ int linux_wlan_get_num_conn_ifcs(void)
 	u8 ret_val = 0;
 
 	for (i = 0; i < wl->vif_num; i++)
-		if (memcmp(wl->vif[i].aBSSID, null_bssid, 6))
+		if (memcmp(wl->vif[i].bssid, null_bssid, 6))
 			ret_val++;
 
 	return ret_val;
@@ -1470,7 +1470,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = wl->vif[nic->u8IfIdx].aBSSID;
+	tx_data->pBssid = wl->vif[nic->u8IfIdx].bssid;
 	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
 					       tx_data->size,
 					       linux_wlan_tx_complete);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 19bca5d..150397a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2572,7 +2572,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized) {
 			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-						      wl->vif[0].aBSSID,
+						      wl->vif[0].bssid,
 						      TID);
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
@@ -2649,7 +2649,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
 		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-					      wl->vif[0].aBSSID, TID);
+					      wl->vif[0].bssid, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2760,7 +2760,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
 		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-					      wl->vif[0].aBSSID,
+					      wl->vif[0].bssid,
 					      TID);
 		bEnablePS = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 32efa2b..14bfd05 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -150,7 +150,7 @@ typedef struct {
 
 struct wilc_vif {
 	u8 src_addr[ETH_ALEN];
-	u8 aBSSID[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
 	struct host_if_drv *drvHandler;
 	struct net_device *wilc_netdev;
 };
-- 
1.9.1

