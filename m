Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46797 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZK0DPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 22:15:15 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 2/2] iwmc3200wifi: rx aggregation support
Date: Fri, 27 Nov 2009 11:18:37 +0800
Message-Id: <1259291917-1399-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259291917-1399-1-git-send-email-yi.zhu@intel.com>
References: <1259291917-1399-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the device receives an A-MSDU frame (indicated by flag
IWM_RX_TICKET_AMSDU_MSK), use ieee80211_amsdu_to_8023s to convert
it to a list of 802.3 frames and handled them to upper layer.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: use __ version of sk_buff_head operations

 drivers/net/wireless/iwmc3200wifi/rx.c |   55 +++++++++++++++++++++++++++-----
 1 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 72c27a3..29e3d1d 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1534,6 +1534,34 @@ static void classify8023(struct sk_buff *skb)
 	}
 }
 
+static int iwm_rx_process_amsdu(struct iwm_priv *iwm, struct sk_buff *skb)
+{
+	struct wireless_dev *wdev = iwm_to_wdev(iwm);
+	struct net_device *ndev = iwm_to_ndev(iwm);
+	struct sk_buff_head list;
+	struct sk_buff *frame;
+	int ret;
+
+	IWM_HEXDUMP(iwm, DBG, RX, "A-MSDU: ", skb->data, skb->len);
+
+	__skb_queue_head_init(&list);
+	ret = ieee80211_amsdu_to_8023s(skb, &list, ndev->dev_addr,
+				       wdev->iftype);
+	if (ret) {
+		IWM_ERR(iwm, "decode A-MSDU frame failed\n");
+		return -EINVAL;
+	}
+
+	while ((frame = __skb_dequeue(&list))) {
+		if (netif_rx_ni(frame) == NET_RX_DROP) {
+			IWM_ERR(iwm, "Packet dropped\n");
+			ndev->stats.rx_dropped++;
+		}
+	}
+
+	return 0;
+}
+
 static void iwm_rx_process_packet(struct iwm_priv *iwm,
 				  struct iwm_rx_packet *packet,
 				  struct iwm_rx_ticket_node *ticket_node)
@@ -1548,25 +1576,36 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 	switch (le16_to_cpu(ticket_node->ticket->action)) {
 	case IWM_RX_TICKET_RELEASE:
 		IWM_DBG_RX(iwm, DBG, "RELEASE packet\n");
+
+		skb->dev = iwm_to_ndev(iwm);
+		skb->protocol = eth_type_trans(skb, ndev);
+		skb->ip_summed = CHECKSUM_NONE;
+		memset(skb->cb, 0, sizeof(skb->cb));
+
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += skb->len;
+
 		classify8023(skb);
 		iwm_rx_adjust_packet(iwm, packet, ticket_node);
+
+		if (le16_to_cpu(ticket_node->ticket->flags) &
+		    IWM_RX_TICKET_AMSDU_MSK) {			
+			ret = iwm_rx_process_amsdu(iwm, skb);
+			if (ret < 0)
+				kfree_skb(packet->skb);
+			break;
+		}
+
 		ret = ieee80211_data_to_8023(skb, ndev->dev_addr, wdev->iftype);
 		if (ret < 0) {
 			IWM_DBG_RX(iwm, DBG, "Couldn't convert 802.11 header - "
 				   "%d\n", ret);
+			kfree_skb(packet->skb);
 			break;
 		}
 
 		IWM_HEXDUMP(iwm, DBG, RX, "802.3: ", skb->data, skb->len);
 
-		skb->dev = iwm_to_ndev(iwm);
-		skb->protocol = eth_type_trans(skb, ndev);
-		skb->ip_summed = CHECKSUM_NONE;
-		memset(skb->cb, 0, sizeof(skb->cb));
-
-		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += skb->len;
-
 		if (netif_rx_ni(skb) == NET_RX_DROP) {
 			IWM_ERR(iwm, "Packet dropped\n");
 			ndev->stats.rx_dropped++;
-- 
1.6.0.4

