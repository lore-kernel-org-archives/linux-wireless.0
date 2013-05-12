Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21904 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3ELLoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 07:44:14 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/7] wil6210: use NAPI
Date: Sun, 12 May 2013 14:43:36 +0300
Message-ID: <1368359018-20870-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130512_134419_845478_8A9B32BE)
In-Reply-To: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce NAPI for Rx and Tx completion.

This fixes packet reordering that happens when Rx handled right in
the IRQ: netif_rx puts packet in 'percpu' queue, then network stack
fetches packets from 'percpu' queues for processing, with different
pattern of queue switching. As result, network stack see packets
in different order. This causes hard to understand TCP throughput
degradation in about 30min

Complete polling if only one packet was processed - this eliminates
empty polls that would be otherwise done at the end of each burst

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 23 +++++-------
 drivers/net/wireless/ath/wil6210/main.c      |  6 ++++
 drivers/net/wireless/ath/wil6210/netdev.c    | 54 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c      | 23 +++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h   | 16 ++++++---
 5 files changed, 94 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 5fe985c..8205d3e 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -104,14 +104,14 @@ static void wil6210_mask_irq_pseudo(struct wil6210_priv *wil)
 	clear_bit(wil_status_irqen, &wil->status);
 }
 
-static void wil6210_unmask_irq_tx(struct wil6210_priv *wil)
+void wil6210_unmask_irq_tx(struct wil6210_priv *wil)
 {
 	iowrite32(WIL6210_IMC_TX, wil->csr +
 		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
 		  offsetof(struct RGF_ICR, IMC));
 }
 
-static void wil6210_unmask_irq_rx(struct wil6210_priv *wil)
+void wil6210_unmask_irq_rx(struct wil6210_priv *wil)
 {
 	iowrite32(WIL6210_IMC_RX, wil->csr +
 		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
@@ -182,13 +182,14 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	if (isr & BIT_DMA_EP_RX_ICR_RX_DONE) {
 		wil_dbg_irq(wil, "RX done\n");
 		isr &= ~BIT_DMA_EP_RX_ICR_RX_DONE;
-		wil_rx_handle(wil);
+		wil_dbg_txrx(wil, "NAPI schedule\n");
+		napi_schedule(&wil->napi_rx);
 	}
 
 	if (isr)
 		wil_err(wil, "un-handled RX ISR bits 0x%08x\n", isr);
 
-	wil6210_unmask_irq_rx(wil);
+	/* Rx IRQ will be enabled when NAPI processing finished */
 
 	return IRQ_HANDLED;
 }
@@ -211,23 +212,17 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 	wil6210_mask_irq_tx(wil);
 
 	if (isr & BIT_DMA_EP_TX_ICR_TX_DONE) {
-		uint i;
 		wil_dbg_irq(wil, "TX done\n");
+		napi_schedule(&wil->napi_tx);
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
-		for (i = 0; i < 24; i++) {
-			u32 mask = BIT_DMA_EP_TX_ICR_TX_DONE_N(i);
-			if (isr & mask) {
-				isr &= ~mask;
-				wil_dbg_irq(wil, "TX done(%i)\n", i);
-				wil_tx_complete(wil, i);
-			}
-		}
+		/* clear also all VRING interrupts */
+		isr &= ~(BIT(25) - 1UL);
 	}
 
 	if (isr)
 		wil_err(wil, "un-handled TX ISR bits 0x%08x\n", isr);
 
-	wil6210_unmask_irq_tx(wil);
+	/* Tx IRQ will be enabled when NAPI processing finished */
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a0478e2..ea49c8a 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -365,6 +365,9 @@ static int __wil_up(struct wil6210_priv *wil)
 	/* Rx VRING. After MAC and beacon */
 	wil_rx_init(wil);
 
+	napi_enable(&wil->napi_rx);
+	napi_enable(&wil->napi_tx);
+
 	return 0;
 }
 
@@ -381,6 +384,9 @@ int wil_up(struct wil6210_priv *wil)
 
 static int __wil_down(struct wil6210_priv *wil)
 {
+	napi_disable(&wil->napi_rx);
+	napi_disable(&wil->napi_tx);
+
 	if (wil->scan_request) {
 		cfg80211_scan_done(wil->scan_request, true);
 		wil->scan_request = NULL;
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 098a8ec..29dd1e5 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -40,6 +40,55 @@ static const struct net_device_ops wil_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static int wil6210_netdev_poll_rx(struct napi_struct *napi, int budget)
+{
+	struct wil6210_priv *wil = container_of(napi, struct wil6210_priv,
+						napi_rx);
+	int quota = budget;
+	int done;
+
+	wil_rx_handle(wil, &quota);
+	done = budget - quota;
+
+	if (done <= 1) { /* burst ends - only one packet processed */
+		napi_complete(napi);
+		wil6210_unmask_irq_rx(wil);
+		wil_dbg_txrx(wil, "NAPI RX complete\n");
+	}
+
+	wil_dbg_txrx(wil, "NAPI RX poll(%d) done %d\n", budget, done);
+
+	return done;
+}
+
+static int wil6210_netdev_poll_tx(struct napi_struct *napi, int budget)
+{
+	struct wil6210_priv *wil = container_of(napi, struct wil6210_priv,
+						napi_tx);
+	int tx_done = 0;
+	uint i;
+
+	/* always process ALL Tx complete, regardless budget - it is fast */
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+		struct vring *vring = &wil->vring_tx[i];
+
+		if (!vring->va)
+			continue;
+
+		tx_done += wil_tx_complete(wil, i);
+	}
+
+	if (tx_done <= 1) { /* burst ends - only one packet processed */
+		napi_complete(napi);
+		wil6210_unmask_irq_tx(wil);
+		wil_dbg_txrx(wil, "NAPI TX complete\n");
+	}
+
+	wil_dbg_txrx(wil, "NAPI TX poll(%d) done %d\n", budget, tx_done);
+
+	return min(tx_done, budget);
+}
+
 void *wil_if_alloc(struct device *dev, void __iomem *csr)
 {
 	struct net_device *ndev;
@@ -81,6 +130,11 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 
+	netif_napi_add(ndev, &wil->napi_rx, wil6210_netdev_poll_rx,
+		       WIL6210_NAPI_BUDGET);
+	netif_napi_add(ndev, &wil->napi_tx, wil6210_netdev_poll_tx,
+		       WIL6210_NAPI_BUDGET);
+
 	wil_link_off(wil);
 
 	return wil;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index dfd9848..109f9bd 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -442,6 +442,7 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 
 /*
  * Pass Rx packet to the netif. Update statistics.
+ * Called in softirq context (NAPI poll).
  */
 static void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 {
@@ -450,10 +451,7 @@ static void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 
 	skb_orphan(skb);
 
-	if (in_interrupt())
-		rc = netif_rx(skb);
-	else
-		rc = netif_rx_ni(skb);
+	rc = netif_receive_skb(skb);
 
 	if (likely(rc == NET_RX_SUCCESS)) {
 		ndev->stats.rx_packets++;
@@ -467,9 +465,9 @@ static void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 /**
  * Proceed all completed skb's from Rx VRING
  *
- * Safe to call from IRQ
+ * Safe to call from NAPI poll, i.e. softirq with interrupts enabled
  */
-void wil_rx_handle(struct wil6210_priv *wil)
+void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct vring *v = &wil->vring_rx;
@@ -480,7 +478,8 @@ void wil_rx_handle(struct wil6210_priv *wil)
 		return;
 	}
 	wil_dbg_txrx(wil, "%s()\n", __func__);
-	while (NULL != (skb = wil_vring_reap_rx(wil, v))) {
+	while ((*quota > 0) && (NULL != (skb = wil_vring_reap_rx(wil, v)))) {
+		(*quota)--;
 
 		if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 			skb->dev = ndev;
@@ -790,17 +789,20 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 /**
  * Clean up transmitted skb's from the Tx VRING
  *
+ * Return number of descriptors cleared
+ *
  * Safe to call from IRQ
  */
-void wil_tx_complete(struct wil6210_priv *wil, int ringid)
+int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct device *dev = wil_to_dev(wil);
 	struct vring *vring = &wil->vring_tx[ringid];
+	int done = 0;
 
 	if (!vring->va) {
 		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
-		return;
+		return 0;
 	}
 
 	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
@@ -849,7 +851,10 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		d->dma.length = 0;
 		d->dma.status = TX_DMA_STATUS_DU;
 		vring->swtail = wil_vring_next_tail(vring);
+		done++;
 	}
 	if (wil_vring_avail_tx(vring) > vring->size/4)
 		netif_tx_wake_all_queues(wil_to_ndev(wil));
+
+	return done;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 484446e..2e3c26e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -34,9 +34,11 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 
 #define WIL6210_MEM_SIZE (2*1024*1024UL)
 
-#define WIL6210_RX_RING_SIZE (128)
-#define WIL6210_TX_RING_SIZE (128)
-#define WIL6210_MAX_TX_RINGS (24)
+#define WIL6210_RX_RING_SIZE	(128)
+#define WIL6210_TX_RING_SIZE	(128)
+#define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
+#define WIL6210_MAX_CID		(8) /* HW limit */
+#define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
 
 /* Hardware definitions begin */
 
@@ -239,6 +241,8 @@ struct wil6210_priv {
 	 * - consumed in thread by wmi_event_worker
 	 */
 	spinlock_t wmi_ev_lock;
+	struct napi_struct napi_rx;
+	struct napi_struct napi_tx;
 	/* DMA related */
 	struct vring vring_rx;
 	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
@@ -360,10 +364,12 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 void wil_vring_fini_tx(struct wil6210_priv *wil, int id);
 
 netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev);
-void wil_tx_complete(struct wil6210_priv *wil, int ringid);
+int wil_tx_complete(struct wil6210_priv *wil, int ringid);
+void wil6210_unmask_irq_tx(struct wil6210_priv *wil);
 
 /* RX API */
-void wil_rx_handle(struct wil6210_priv *wil);
+void wil_rx_handle(struct wil6210_priv *wil, int *quota);
+void wil6210_unmask_irq_rx(struct wil6210_priv *wil);
 
 int wil_iftype_nl2wmi(enum nl80211_iftype type);
 
-- 
1.8.1.2

