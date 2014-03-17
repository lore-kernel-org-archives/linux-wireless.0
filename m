Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbaCQNfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:14 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 18/21] wil6210: use GRO
Date: Mon, 17 Mar 2014 15:34:22 +0200
Message-ID: <1395063265-6522-19-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143522_831318_08A0258E)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GRO is easy to enable when already using NAPI framework,
and it improves CPU utilisation. Enable it by default.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c   | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 5991802..fdcaeb8 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -128,7 +128,7 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	ndev->netdev_ops = &wil_netdev_ops;
 	ndev->ieee80211_ptr = wdev;
 	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_SG;
+			    NETIF_F_SG | NETIF_F_GRO;
 	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 97d036ad..cfd36cc 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -488,7 +488,7 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
  */
 void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 {
-	int rc;
+	gro_result_t rc;
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	unsigned int len = skb->len;
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
@@ -497,17 +497,17 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 
 	skb_orphan(skb);
 
-	rc = netif_receive_skb(skb);
+	rc = napi_gro_receive(&wil->napi_rx, skb);
 
-	if (likely(rc == NET_RX_SUCCESS)) {
+	if (unlikely(rc == GRO_DROP)) {
+		ndev->stats.rx_dropped++;
+		stats->rx_dropped++;
+		wil_dbg_txrx(wil, "Rx drop %d bytes\n", len);
+	} else {
 		ndev->stats.rx_packets++;
 		stats->rx_packets++;
 		ndev->stats.rx_bytes += len;
 		stats->rx_bytes += len;
-
-	} else {
-		ndev->stats.rx_dropped++;
-		stats->rx_dropped++;
 	}
 }
 
-- 
1.8.3.2

