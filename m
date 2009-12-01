Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZLACPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 21:15:19 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <samuel@sortiz.org>
Subject: [PATCH v4 2/2] iwmc3200wifi: rx aggregation support
Date: Tue,  1 Dec 2009 10:18:38 +0800
Message-Id: <1259633918-17517-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259633918-17517-1-git-send-email-yi.zhu@intel.com>
References: <1259633918-17517-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the device receives an A-MSDU frame (indicated by flag
IWM_RX_TICKET_AMSDU_MSK), use ieee80211_amsdu_to_8023s to convert
it to a list of 802.3 frames and handled them to upper layer.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: use __ version of sk_buff_head operations
V3: pass 0 as parameter extra_headroom to ieee80211_amsdu_to_8023s
V4: set skb->protocol for every packet in the return list

 drivers/net/wireless/iwmc3200wifi/rx.c |   46 ++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 72c27a3..6bd253a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1534,6 +1534,33 @@ static void classify8023(struct sk_buff *skb)
 	}
 }
 
+static void iwm_rx_process_amsdu(struct iwm_priv *iwm, struct sk_buff *skb)
+{
+	struct wireless_dev *wdev = iwm_to_wdev(iwm);
+	struct net_device *ndev = iwm_to_ndev(iwm);
+	struct sk_buff_head list;
+	struct sk_buff *frame;
+
+	IWM_HEXDUMP(iwm, DBG, RX, "A-MSDU: ", skb->data, skb->len);
+
+	__skb_queue_head_init(&list);
+	ieee80211_amsdu_to_8023s(skb, &list, ndev->dev_addr, wdev->iftype, 0);
+
+	while ((frame = __skb_dequeue(&list))) {
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += frame->len;
+
+		frame->protocol = eth_type_trans(frame, ndev);
+		frame->ip_summed = CHECKSUM_NONE;
+		memset(frame->cb, 0, sizeof(frame->cb));
+
+		if (netif_rx_ni(frame) == NET_RX_DROP) {
+			IWM_ERR(iwm, "Packet dropped\n");
+			ndev->stats.rx_dropped++;
+		}
+	}
+}
+
 static void iwm_rx_process_packet(struct iwm_priv *iwm,
 				  struct iwm_rx_packet *packet,
 				  struct iwm_rx_ticket_node *ticket_node)
@@ -1548,25 +1575,34 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 	switch (le16_to_cpu(ticket_node->ticket->action)) {
 	case IWM_RX_TICKET_RELEASE:
 		IWM_DBG_RX(iwm, DBG, "RELEASE packet\n");
-		classify8023(skb);
+
 		iwm_rx_adjust_packet(iwm, packet, ticket_node);
+		skb->dev = iwm_to_ndev(iwm);
+		classify8023(skb);
+
+		if (le16_to_cpu(ticket_node->ticket->flags) &
+		    IWM_RX_TICKET_AMSDU_MSK) {
+			iwm_rx_process_amsdu(iwm, skb);
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
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += skb->len;
+
 		skb->protocol = eth_type_trans(skb, ndev);
 		skb->ip_summed = CHECKSUM_NONE;
 		memset(skb->cb, 0, sizeof(skb->cb));
 
-		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += skb->len;
-
 		if (netif_rx_ni(skb) == NET_RX_DROP) {
 			IWM_ERR(iwm, "Packet dropped\n");
 			ndev->stats.rx_dropped++;
-- 
1.6.0.4

