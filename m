Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbYBKO2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 09:28:44 -0500
Subject: [RFT] ipw2200: fix ucode assertion for RX queue overrun
From: Dan Williams <dcbw@redhat.com>
To: Sebastian Siewior <ipw+2200@ml.breakpoint.cc>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Mon, 11 Feb 2008 09:27:50 -0500
Message-Id: <1202740070.2806.9.camel@localhost.localdomain> (sfid-20080211_142850_808591_1A705FF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restock the RX queue when there are a lot of unused frames so that the
RX ring buffer doesn't overrun, causing a ucode assertion.  Backport of
patch "iwlwifi: fix ucode assertion for RX queue overrun".

Signed-off-by: Dan Williams <dcbw@redhat.com>

-------------------------------

Sebastian, can you test and ensure that this works for you?  Also, can
you do some throughput testing to ensure that this patch doesn't cause a
throughput regression?  Thanks!

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 3e6ad7b..a56d9fc 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -3365,7 +3365,6 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
-	rxq->processed = RX_QUEUE_SIZE - 1;
 	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
@@ -3607,7 +3606,22 @@ static int ipw_load(struct ipw_priv *priv)
  * Driver allocates buffers of this size for Rx
  */
 
-static inline int ipw_queue_space(const struct clx2_queue *q)
+/**
+ * ipw_rx_queue_space - Return number of free slots available in queue.
+ */
+static int ipw_rx_queue_space(const struct ipw_rx_queue *q)
+{
+	int s = q->read - q->write;
+	if (s <= 0)
+		s += RX_QUEUE_SIZE;
+	/* keep some buffer to not confuse full and empty queue */
+	s -= 2;
+	if (s < 0)
+		s = 0;
+	return s;
+}
+
+static inline int ipw_tx_queue_space(const struct clx2_queue *q)
 {
 	int s = q->last_used - q->first_empty;
 	if (s <= 0)
@@ -4947,7 +4961,7 @@ static int ipw_queue_tx_reclaim(struct ipw_priv *priv,
 		priv->tx_packets++;
 	}
       done:
-	if ((ipw_queue_space(q) > q->low_mark) &&
+	if ((ipw_tx_queue_space(q) > q->low_mark) &&
 	    (qindex >= 0) &&
 	    (priv->status & STATUS_ASSOCIATED) && netif_running(priv->net_dev))
 		netif_wake_queue(priv->net_dev);
@@ -4965,7 +4979,7 @@ static int ipw_queue_tx_hcmd(struct ipw_priv *priv, int hcmd, void *buf,
 	struct clx2_queue *q = &txq->q;
 	struct tfd_frame *tfd;
 
-	if (ipw_queue_space(q) < (sync ? 1 : 2)) {
+	if (ipw_tx_queue_space(q) < (sync ? 1 : 2)) {
 		IPW_ERROR("No space for Tx\n");
 		return -EBUSY;
 	}
@@ -5070,7 +5084,7 @@ static void ipw_rx_queue_restock(struct ipw_priv *priv)
 
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write;
-	while ((rxq->write != rxq->processed) && (rxq->free_count)) {
+	while ((ipw_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
 		element = rxq->rx_free.next;
 		rxb = list_entry(element, struct ipw_rx_mem_buffer, list);
 		list_del(element);
@@ -5187,7 +5201,6 @@ static struct ipw_rx_queue *ipw_rx_queue_alloc(struct ipw_priv *priv)
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
-	rxq->processed = RX_QUEUE_SIZE - 1;
 	rxq->free_count = 0;
 
 	return rxq;
@@ -8223,13 +8236,17 @@ static void ipw_rx(struct ipw_priv *priv)
 	struct ieee80211_hdr_4addr *header;
 	u32 r, w, i;
 	u8 network_packet;
+	u8 fill_rx = 0;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 	DECLARE_MAC_BUF(mac3);
 
 	r = ipw_read32(priv, IPW_RX_READ_INDEX);
 	w = ipw_read32(priv, IPW_RX_WRITE_INDEX);
-	i = (priv->rxq->processed + 1) % RX_QUEUE_SIZE;
+	i = priv->rxq->read;
+
+	if (ipw_rx_queue_space (priv->rxq) > (RX_QUEUE_SIZE / 2))
+		fill_rx = 1;
 
 	while (i != r) {
 		rxb = priv->rxq->queue[i];
@@ -8404,11 +8421,17 @@ static void ipw_rx(struct ipw_priv *priv)
 		list_add_tail(&rxb->list, &priv->rxq->rx_used);
 
 		i = (i + 1) % RX_QUEUE_SIZE;
+
+		/* If there are a lot of unsued frames, restock the Rx queue
+		 * so the ucode won't assert */
+		if (fill_rx) {
+			priv->rxq->read = i;
+			ipw_rx_queue_replenish(priv);
+		}
 	}
 
 	/* Backtrack one entry */
-	priv->rxq->processed = (i ? i : RX_QUEUE_SIZE) - 1;
-
+	priv->rxq->read = i;
 	ipw_rx_queue_restock(priv);
 }
 
@@ -10336,7 +10359,7 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 	q->first_empty = ipw_queue_inc_wrap(q->first_empty, q->n_bd);
 	ipw_write32(priv, q->reg_w, q->first_empty);
 
-	if (ipw_queue_space(q) < q->high_mark)
+	if (ipw_tx_queue_space(q) < q->high_mark)
 		netif_stop_queue(priv->net_dev);
 
 	return NETDEV_TX_OK;
@@ -10357,7 +10380,7 @@ static int ipw_net_is_queue_full(struct net_device *dev, int pri)
 	struct clx2_tx_queue *txq = &priv->txq[0];
 #endif				/* CONFIG_IPW2200_QOS */
 
-	if (ipw_queue_space(&txq->q) < txq->q.high_mark)
+	if (ipw_tx_queue_space(&txq->q) < txq->q.high_mark)
 		return 1;
 
 	return 0;

