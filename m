Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26773 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbbKEFf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:35:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 20/38] staging: wilc1000: remove warnings line over 80 characters
Date: Thu, 5 Nov 2015 14:36:21 +0900
Message-ID: <1446701799-24870-20-git-send-email-glen.lee@atmel.com> (sfid-20151105_063758_324929_00289468)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl
for line over 80 characters.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 40 +++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3aedc28..4b2afa0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -122,7 +122,8 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		return NOTIFY_DONE;
 	}
 
-	if ((memcmp(dev_iface->ifa_label, "wlan0", 5)) && (memcmp(dev_iface->ifa_label, "p2p0", 4))) {
+	if (memcmp(dev_iface->ifa_label, "wlan0", 5) &&
+	    memcmp(dev_iface->ifa_label, "p2p0", 4)) {
 		PRINT_D(GENERIC_DBG, "Interface is neither WLAN0 nor P2P0\n");
 		return NOTIFY_DONE;
 	}
@@ -305,7 +306,8 @@ int linux_wlan_lock_timeout(void *vp, u32 timeout)
 
 	PRINT_D(LOCK_DBG, "Locking %p\n", vp);
 	if (vp)
-		error = down_timeout((struct semaphore *)vp, msecs_to_jiffies(timeout));
+		error = down_timeout((struct semaphore *)vp,
+				     msecs_to_jiffies(timeout));
 	else
 		PRINT_ER("Failed, mutex is NULL\n");
 	return error;
@@ -316,7 +318,8 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 	int status;
 
 	if (flag == WILC_MAC_INDICATE_STATUS) {
-		wilc_wlan_cfg_get_val(WID_STATUS, (unsigned char *)&status, 4);
+		wilc_wlan_cfg_get_val(WID_STATUS,
+				      (unsigned char *)&status, 4);
 		if (wilc->mac_status == WILC_MAC_STATUS_INIT) {
 			wilc->mac_status = status;
 			up(&wilc->sync_event);
@@ -589,7 +592,9 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	PRINT_D(INIT_DBG, "Host = %p\n", hif_drv);
 
-	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n", mac_add[0], mac_add[1], mac_add[2], mac_add[3], mac_add[4], mac_add[5]);
+	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n",
+		mac_add[0], mac_add[1], mac_add[2],
+		mac_add[3], mac_add[4], mac_add[5]);
 	wilc_get_chipid(0);
 
 	*(int *)c_val = 1;
@@ -1133,10 +1138,14 @@ int mac_open(struct net_device *ndev)
 		goto _err_;
 	}
 
-	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
-				 nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
-	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
-				 nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
+	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy,
+				 nic->wilc_netdev->ieee80211_ptr,
+				 nic->g_struct_frame_reg[0].frame_type,
+				 nic->g_struct_frame_reg[0].reg);
+	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy,
+				 nic->wilc_netdev->ieee80211_ptr,
+				 nic->g_struct_frame_reg[1].frame_type,
+				 nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	wl->open_ifcs++;
 	nic->mac_opened = 1;
@@ -1168,14 +1177,16 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if (!dev)
 		return;
 
-	PRINT_D(INIT_DBG, "Setting Multicast List with count = %d.\n", dev->mc.count);
+	PRINT_D(INIT_DBG, "Setting Multicast List with count = %d.\n",
+		dev->mc.count);
 
 	if (dev->flags & IFF_PROMISC) {
 		PRINT_D(INIT_DBG, "Set promiscuous mode ON, retrive all packets\n");
 		return;
 	}
 
-	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
+	if ((dev->flags & IFF_ALLMULTI) ||
+	    (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		host_int_setup_multicast_filter(hif_drv, false, 0);
 		return;
@@ -1256,7 +1267,8 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
 
 	pu8UdpBuffer = (char *)ih + sizeof(struct iphdr);
-	if ((pu8UdpBuffer[1] == 68 && pu8UdpBuffer[3] == 67) || (pu8UdpBuffer[1] == 67 && pu8UdpBuffer[3] == 68))
+	if ((pu8UdpBuffer[1] == 68 && pu8UdpBuffer[3] == 67) ||
+	    (pu8UdpBuffer[1] == 67 && pu8UdpBuffer[3] == 68))
 		PRINT_D(GENERIC_DBG, "DHCP Message transmitted, type:%x %x %x\n", pu8UdpBuffer[248], pu8UdpBuffer[249], pu8UdpBuffer[250]);
 
 	PRINT_D(TX_DBG, "Sending packet - Size = %d - Address = %p - SKB = %p\n", tx_data->size, tx_data->buff, tx_data->skb);
@@ -1363,7 +1375,8 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 		size = wrq->u.data.length;
 
 		if (size && wrq->u.data.pointer) {
-			buff = memdup_user(wrq->u.data.pointer, wrq->u.data.length);
+			buff = memdup_user(wrq->u.data.pointer,
+					   wrq->u.data.length);
 			if (IS_ERR(buff))
 				return PTR_ERR(buff);
 
@@ -1568,7 +1581,8 @@ int wilc_netdev_init(struct wilc **wilc)
 		}
 
 		if (register_netdev(ndev)) {
-			PRINT_ER("Device couldn't be registered - %s\n", ndev->name);
+			PRINT_ER("Device couldn't be registered - %s\n",
+				 ndev->name);
 			return -1;
 		}
 
-- 
1.9.1

