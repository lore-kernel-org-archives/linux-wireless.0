Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0073.outbound.protection.outlook.com ([104.47.38.73]:37088
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbeAVMrC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:02 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 03/11] qtnfmac: support 64-bit network interface stats
Date: Mon, 22 Jan 2018 15:46:26 +0300
Message-Id: <20180122124634.8430-4-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134709_172297_57EE3442)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

On 32-bit platforms packet counters are stored in a net_device_stats struct
as unsigned long integers. As a result, after some time of network activity
an overflow takes place in network packet counters. This patch makes use of
new structs for holding interface statistics.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c      | 81 +++++++++++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  5 ++
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    |  7 +-
 3 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index ccd982b1c957..c10f24f0a0ce 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -119,9 +119,38 @@ qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 /* Netdev handler for getting stats.
  */
-static struct net_device_stats *qtnf_netdev_get_stats(struct net_device *dev)
+static void qtnf_netdev_get_stats64(struct net_device *ndev,
+				    struct rtnl_link_stats64 *stats)
 {
-	return &dev->stats;
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	unsigned int start;
+	int cpu;
+
+	netdev_stats_to_stats64(stats, &ndev->stats);
+
+	if (!vif->stats64)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct pcpu_sw_netstats *stats64;
+		u64 rx_packets, rx_bytes;
+		u64 tx_packets, tx_bytes;
+
+		stats64 = per_cpu_ptr(vif->stats64, cpu);
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats64->syncp);
+			rx_packets = stats64->rx_packets;
+			rx_bytes = stats64->rx_bytes;
+			tx_packets = stats64->tx_packets;
+			tx_bytes = stats64->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&stats64->syncp, start));
+
+		stats->rx_packets += rx_packets;
+		stats->rx_bytes += rx_bytes;
+		stats->tx_packets += tx_packets;
+		stats->tx_bytes += tx_bytes;
+	}
 }
 
 /* Netdev handler for transmission timeout.
@@ -156,7 +185,7 @@ const struct net_device_ops qtnf_netdev_ops = {
 	.ndo_stop = qtnf_netdev_close,
 	.ndo_start_xmit = qtnf_netdev_hard_start_xmit,
 	.ndo_tx_timeout = qtnf_netdev_tx_timeout,
-	.ndo_get_stats = qtnf_netdev_get_stats,
+	.ndo_get_stats64 = qtnf_netdev_get_stats64,
 };
 
 static int qtnf_mac_init_single_band(struct wiphy *wiphy,
@@ -289,6 +318,11 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 		qtnf_sta_list_init(&mac->iflist[i].sta_list);
 		mutex_init(&mac->mac_lock);
 		timer_setup(&mac->scan_timeout, NULL, 0);
+		mac->iflist[i].stats64 =
+			netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+		if (!mac->iflist[i].stats64)
+			pr_warn("VIF%u.%u: per cpu stats allocation failed\n",
+				macid, i);
 	}
 
 	qtnf_mac_init_primary_intf(mac);
@@ -364,6 +398,7 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
 		}
 		rtnl_unlock();
 		qtnf_sta_list_free(&vif->sta_list);
+		free_percpu(vif->stats64);
 	}
 
 	if (mac->wiphy_registered)
@@ -643,6 +678,46 @@ void qtnf_wake_all_queues(struct net_device *ndev)
 }
 EXPORT_SYMBOL_GPL(qtnf_wake_all_queues);
 
+void qtnf_update_rx_stats(struct net_device *ndev, const struct sk_buff *skb)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	struct pcpu_sw_netstats *stats64;
+
+	if (unlikely(!vif || !vif->stats64)) {
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += skb->len;
+		return;
+	}
+
+	stats64 = this_cpu_ptr(vif->stats64);
+
+	u64_stats_update_begin(&stats64->syncp);
+	stats64->rx_packets++;
+	stats64->rx_bytes += skb->len;
+	u64_stats_update_end(&stats64->syncp);
+}
+EXPORT_SYMBOL_GPL(qtnf_update_rx_stats);
+
+void qtnf_update_tx_stats(struct net_device *ndev, const struct sk_buff *skb)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	struct pcpu_sw_netstats *stats64;
+
+	if (unlikely(!vif || !vif->stats64)) {
+		ndev->stats.tx_packets++;
+		ndev->stats.tx_bytes += skb->len;
+		return;
+	}
+
+	stats64 = this_cpu_ptr(vif->stats64);
+
+	u64_stats_update_begin(&stats64->syncp);
+	stats64->tx_packets++;
+	stats64->tx_bytes += skb->len;
+	u64_stats_update_end(&stats64->syncp);
+}
+EXPORT_SYMBOL_GPL(qtnf_update_tx_stats);
+
 MODULE_AUTHOR("Quantenna Communications");
 MODULE_DESCRIPTION("Quantenna 802.11 wireless LAN FullMAC driver.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index c10900162297..09fa5d28cc2a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -89,6 +89,8 @@ struct qtnf_vif {
 	struct qtnf_sta_list sta_list;
 	unsigned long cons_tx_timeout_cnt;
 	int generation;
+
+	struct pcpu_sw_netstats __percpu *stats64;
 };
 
 struct qtnf_mac_info {
@@ -157,6 +159,9 @@ int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac);
 struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid);
 struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb);
 void qtnf_wake_all_queues(struct net_device *ndev);
+void qtnf_update_rx_stats(struct net_device *ndev, const struct sk_buff *skb);
+void qtnf_update_tx_stats(struct net_device *ndev, const struct sk_buff *skb);
+
 void qtnf_virtual_intf_cleanup(struct net_device *ndev);
 
 void qtnf_netdev_updown(struct net_device *ndev, bool up);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 7e487622d87d..6f6190964320 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -615,8 +615,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
 					 PCI_DMA_TODEVICE);
 
 			if (skb->dev) {
-				skb->dev->stats.tx_packets++;
-				skb->dev->stats.tx_bytes += skb->len;
+				qtnf_update_tx_stats(skb->dev, skb);
 				if (unlikely(priv->tx_stopped)) {
 					qtnf_wake_all_queues(skb->dev);
 					priv->tx_stopped = 0;
@@ -855,9 +854,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, psize);
 			ndev = qtnf_classify_skb(bus, skb);
 			if (likely(ndev)) {
-				ndev->stats.rx_packets++;
-				ndev->stats.rx_bytes += skb->len;
-
+				qtnf_update_rx_stats(ndev, skb);
 				skb->protocol = eth_type_trans(skb, ndev);
 				napi_gro_receive(napi, skb);
 			} else {
-- 
2.11.0
