Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52205 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbJWF23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:28:29 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/28] staging: wilc1000: mac_xmit: use netdev private wilc instead of g_linux_wlan
Date: Fri, 23 Oct 2015 14:28:42 +0900
Message-ID: <1445578124-31486-26-git-send-email-glen.lee@atmel.com> (sfid-20151023_074700_631831_F778053B)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses netdev private data member wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a2d8053..7a2599a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1359,8 +1359,10 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	char *pu8UdpBuffer;
 	struct iphdr *ih;
 	struct ethhdr *eth_h;
+	struct wilc *wl;
 
 	nic = netdev_priv(ndev);
+	wl = nic->wilc;
 
 	PRINT_D(TX_DBG, "Sending packet just received from TCP/IP\n");
 
@@ -1403,14 +1405,14 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = g_linux_wlan->vif[nic->u8IfIdx].bssid;
+	tx_data->pBssid = wl->vif[nic->u8IfIdx].bssid;
 	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
 					       tx_data->size,
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(g_linux_wlan->vif[0].ndev);
-		netif_stop_queue(g_linux_wlan->vif[1].ndev);
+		netif_stop_queue(wl->vif[0].ndev);
+		netif_stop_queue(wl->vif[1].ndev);
 	}
 
 	return 0;
-- 
1.9.1

