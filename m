Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0069.outbound.protection.outlook.com ([104.47.38.69]:1922
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932549AbdJ3KOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:14:17 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 4/5] qtnfmac: modify full Tx queue recovery
Date: Mon, 30 Oct 2017 13:13:49 +0300
Message-Id: <20171030101350.21251-5-sergey.matyukevich.os@quantenna.com> (sfid-20171030_111427_263789_2403774E)
In-Reply-To: <20171030101350.21251-1-sergey.matyukevich.os@quantenna.com>
References: <20171030101350.21251-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current recovery approach is to wake s/w Tx queues for skb->dev netdevice.
However this approach doesn't cover the case when h/w queue is full of
packets from a single wireless interface. Suppose xmit attempt from the
second wireless interface fails due to failed reclaim. Then the second
interface will not have a chance to recover even if subsequent reclaims
succeed. Possible solution is to attempt to wake all the s/w queues
belonging to driver interfaces.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c      | 27 ++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  1 +
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 13 +++++++----
 .../quantenna/qtnfmac/pearl/pcie_bus_priv.h        |  1 +
 4 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index aa7f146278a7..6a6e5ffb0348 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -618,6 +618,33 @@ struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(qtnf_classify_skb);
 
+void qtnf_wake_all_queues(struct net_device *ndev)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	struct qtnf_wmac *mac;
+	struct qtnf_bus *bus;
+	int macid;
+	int i;
+
+	if (unlikely(!vif || !vif->mac || !vif->mac->bus))
+		return;
+
+	bus = vif->mac->bus;
+
+	for (macid = 0; macid < QTNF_MAX_MAC; macid++) {
+		if (!(bus->hw_info.mac_bitmap & BIT(macid)))
+			continue;
+
+		mac = bus->mac[macid];
+		for (i = 0; i < QTNF_MAX_INTF; i++) {
+			vif = &mac->iflist[i];
+			if (vif->netdev && netif_queue_stopped(vif->netdev))
+				netif_tx_wake_all_queues(vif->netdev);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(qtnf_wake_all_queues);
+
 MODULE_AUTHOR("Quantenna Communications");
 MODULE_DESCRIPTION("Quantenna 802.11 wireless LAN FullMAC driver.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 49ae700f66f0..da2c24e2271d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -153,6 +153,7 @@ int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac);
 
 struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid);
 struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb);
+void qtnf_wake_all_queues(struct net_device *ndev);
 void qtnf_virtual_intf_cleanup(struct net_device *ndev);
 
 void qtnf_netdev_updown(struct net_device *ndev, bool up);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 146e42a132e7..7e487622d87d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -617,9 +617,10 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
 			if (skb->dev) {
 				skb->dev->stats.tx_packets++;
 				skb->dev->stats.tx_bytes += skb->len;
-
-				if (netif_queue_stopped(skb->dev))
-					netif_wake_queue(skb->dev);
+				if (unlikely(priv->tx_stopped)) {
+					qtnf_wake_all_queues(skb->dev);
+					priv->tx_stopped = 0;
+				}
 			}
 
 			dev_kfree_skb_any(skb);
@@ -669,8 +670,10 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	spin_lock_irqsave(&priv->tx0_lock, flags);
 
 	if (!qtnf_tx_queue_ready(priv)) {
-		if (skb->dev)
-			netif_stop_queue(skb->dev);
+		if (skb->dev) {
+			netif_tx_stop_all_queues(skb->dev);
+			priv->tx_stopped = 1;
+		}
 
 		spin_unlock_irqrestore(&priv->tx0_lock, flags);
 		return NETDEV_TX_BUSY;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
index 86ac1ccedb52..397875a50fc2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
@@ -37,6 +37,7 @@ struct qtnf_pcie_bus_priv {
 	/* lock for tx0 operations */
 	spinlock_t tx0_lock;
 	u8 msi_enabled;
+	u8 tx_stopped;
 	int mps;
 
 	struct workqueue_struct *workqueue;
-- 
2.11.0
