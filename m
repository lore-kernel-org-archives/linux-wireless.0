Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27171 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbKEFhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:37:04 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 37/38] staging: wilc1000: rename QueueCount of mac_xmit function
Date: Thu, 5 Nov 2015 14:36:38 +0900
Message-ID: <1446701799-24870-37-git-send-email-glen.lee@atmel.com> (sfid-20151105_063714_017288_9F3E2B70)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename QueueCount variable of mac_xmit function to queue_count
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f1dcdfb..7a07e43 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1218,7 +1218,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
 	struct tx_complete_data *tx_data = NULL;
-	int QueueCount;
+	int queue_count;
 	char *pu8UdpBuffer;
 	struct iphdr *ih;
 	struct ethhdr *eth_h;
@@ -1262,11 +1262,11 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
 	tx_data->pBssid = wilc->vif[nic->u8IfIdx].bssid;
-	QueueCount = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
-					       tx_data->buff, tx_data->size,
-					       linux_wlan_tx_complete);
+	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
+						tx_data->buff, tx_data->size,
+						linux_wlan_tx_complete);
 
-	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
+	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
 		netif_stop_queue(wilc->vif[0].ndev);
 		netif_stop_queue(wilc->vif[1].ndev);
 	}
-- 
1.9.1

