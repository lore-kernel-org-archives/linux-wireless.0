Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64722 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbCOOAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:52 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 2/3] wil6210: re-submit Rx frames to the wireless media if appropriate
Date: Sun, 15 Mar 2015 16:00:18 +0200
Message-Id: <1426428024-4538-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150055_166431_D3A509CB)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is for AP only. If Rx data frame targeted to one of associated clients,
transmit it back to the wireless media and don't deliver to the host.
For the multicast frames, deliver to both host and wireless media.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 72 ++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 7f2f560..08d3cac 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -492,17 +492,71 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
  */
 void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 {
-	gro_result_t rc;
+	gro_result_t rc = GRO_NORMAL;
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	struct wireless_dev *wdev = wil_to_wdev(wil);
 	unsigned int len = skb->len;
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
 	int cid = wil_rxdesc_cid(d);
+	struct ethhdr *eth = (void *)skb->data;
+	/* here looking for DA, not A1, thus Rxdesc's 'mcast' indication
+	 * is not suitable, need to look at data
+	 */
+	int mcast = is_multicast_ether_addr(eth->h_dest);
 	struct wil_net_stats *stats = &wil->sta[cid].stats;
+	struct sk_buff *xmit_skb = NULL;
+	static const char * const gro_res_str[] = {
+		[GRO_MERGED]		= "GRO_MERGED",
+		[GRO_MERGED_FREE]	= "GRO_MERGED_FREE",
+		[GRO_HELD]		= "GRO_HELD",
+		[GRO_NORMAL]		= "GRO_NORMAL",
+		[GRO_DROP]		= "GRO_DROP",
+	};
 
 	skb_orphan(skb);
 
-	rc = napi_gro_receive(&wil->napi_rx, skb);
+	if (wdev->iftype == NL80211_IFTYPE_AP) {
+		if (mcast) {
+			/* send multicast frames both to higher layers in
+			 * local net stack and back to the wireless medium
+			 */
+			xmit_skb = skb_copy(skb, GFP_ATOMIC);
+		} else {
+			int xmit_cid = wil_find_cid(wil, eth->h_dest);
+
+			if (xmit_cid >= 0) {
+				/* The destination station is associated to
+				 * this AP (in this VLAN), so send the frame
+				 * directly to it and do not pass it to local
+				 * net stack.
+				 */
+				xmit_skb = skb;
+				skb = NULL;
+			}
+		}
+	}
+	if (xmit_skb) {
+		/* Send to wireless media and increase priority by 256 to
+		 * keep the received priority instead of reclassifying
+		 * the frame (see cfg80211_classify8021d).
+		 */
+		xmit_skb->dev = ndev;
+		xmit_skb->priority += 256;
+		xmit_skb->protocol = htons(ETH_P_802_3);
+		skb_reset_network_header(xmit_skb);
+		skb_reset_mac_header(xmit_skb);
+		wil_dbg_txrx(wil, "Rx -> Tx %d bytes\n", len);
+		dev_queue_xmit(xmit_skb);
+	}
+
+	if (skb) { /* deliver to local stack */
 
+		skb->protocol = eth_type_trans(skb, ndev);
+		rc = napi_gro_receive(&wil->napi_rx, skb);
+		wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
+			     len, gro_res_str[rc]);
+	}
+	/* statistics. rc set to GRO_NORMAL for AP bridging */
 	if (unlikely(rc == GRO_DROP)) {
 		ndev->stats.rx_dropped++;
 		stats->rx_dropped++;
@@ -512,17 +566,8 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		stats->rx_packets++;
 		ndev->stats.rx_bytes += len;
 		stats->rx_bytes += len;
-	}
-	{
-		static const char * const gro_res_str[] = {
-			[GRO_MERGED]		= "GRO_MERGED",
-			[GRO_MERGED_FREE]	= "GRO_MERGED_FREE",
-			[GRO_HELD]		= "GRO_HELD",
-			[GRO_NORMAL]		= "GRO_NORMAL",
-			[GRO_DROP]		= "GRO_DROP",
-		};
-		wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
-			     len, gro_res_str[rc]);
+		if (mcast)
+			ndev->stats.multicast++;
 	}
 }
 
@@ -553,7 +598,6 @@ void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 			skb->protocol = htons(ETH_P_802_2);
 			wil_netif_rx_any(skb, ndev);
 		} else {
-			skb->protocol = eth_type_trans(skb, ndev);
 			wil_rx_reorder(wil, skb);
 		}
 	}
-- 
2.1.0

