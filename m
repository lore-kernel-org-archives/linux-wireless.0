Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbXLJRVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:21:54 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 37/48] libertas: clean up lbs_hard_start_xmit()
Message-Id: <E1J1kph-0006n6-2L@shinybook.infradead.org> (sfid-20071210_172157_929773_772FEC34)
Date: Mon, 10 Dec 2007 10:46:13 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 14:37:59 -0500

Having merged the nest of functions into one, now we can clean it up and
fix the error handling, and the duplication -- and at least make a start
on the locking.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/tx.c |  133 +++++++++++++++++-------------------
 1 files changed, 63 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 7bc2124..aefe524 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -58,22 +58,16 @@ static u32 convert_radiotap_rate_to_mv(u8 rate)
  */
 int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	unsigned long flags;
 	struct lbs_private *priv = dev->priv;
-	int ret = -1;
-	struct txpd localtxpd;
-	struct txpd *plocaltxpd = &localtxpd;
-	u8 *p802x_hdr;
-	struct tx_radiotap_hdr *pradiotap_hdr;
-	u32 new_rate;
-	u8 *ptr = priv->tmptxbuf;
+	struct txpd *txpd;
+	char *p802x_hdr;
+	uint16_t pkt_len;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_TX);
 
-	lbs_deb_hex(LBS_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
-
-	netif_stop_queue(priv->dev);
-	if (priv->mesh_dev)
-		netif_stop_queue(priv->mesh_dev);
+	ret = NETDEV_TX_BUSY;
 
 	if (priv->dnld_sent) {
 		lbs_pr_alert( "TX error: dnld_sent = %d, not sending\n",
@@ -94,98 +88,97 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (priv->surpriseremoved)
-		return -1;
+		goto drop;
 
 	if (!skb->len || (skb->len > MRVDRV_ETH_TX_PACKET_BUFFER_SIZE)) {
 		lbs_deb_tx("tx err: skb length %d 0 or > %zd\n",
 		       skb->len, MRVDRV_ETH_TX_PACKET_BUFFER_SIZE);
-		goto done_tx;
+		/* We'll never manage to send this one; drop it and return 'OK' */
+		goto drop;
 	}
 
-	ret = 0;
-	memset(plocaltxpd, 0, sizeof(struct txpd));
-
-	plocaltxpd->tx_packet_length = cpu_to_le16(skb->len);
+	lbs_deb_hex(LBS_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
 
-	/* offset of actual data */
-	plocaltxpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
+	txpd = (void *)priv->tmptxbuf;
+	memset(txpd, 0, sizeof(struct txpd));
 
 	p802x_hdr = skb->data;
-	if (priv->monitormode != LBS_MONITOR_OFF) {
+	pkt_len = skb->len;
 
-		/* locate radiotap header */
-		pradiotap_hdr = (struct tx_radiotap_hdr *)skb->data;
+	if (priv->monitormode != LBS_MONITOR_OFF) {
+		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
 		/* set txpd fields from the radiotap header */
-		new_rate = convert_radiotap_rate_to_mv(pradiotap_hdr->rate);
-		if (new_rate != 0) {
-			/* use new tx_control[4:0] */
-			plocaltxpd->tx_control = cpu_to_le32(new_rate);
-		}
+		txpd->tx_control = cpu_to_le32(convert_radiotap_rate_to_mv(rtap_hdr->rate));
 
 		/* skip the radiotap header */
-		p802x_hdr += sizeof(struct tx_radiotap_hdr);
-		plocaltxpd->tx_packet_length =
-			cpu_to_le16(le16_to_cpu(plocaltxpd->tx_packet_length)
-				    - sizeof(struct tx_radiotap_hdr));
+		p802x_hdr += sizeof(*rtap_hdr);
+		pkt_len -= sizeof(*rtap_hdr);
 
+		/* copy destination address from 802.11 header */
+		memcpy(txpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
+	} else {
+		/* copy destination address from 802.3 header */
+		memcpy(txpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
 	}
-	/* copy destination address from 802.3 or 802.11 header */
-	if (priv->monitormode != LBS_MONITOR_OFF)
-		memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
-	else
-		memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
 
-	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) plocaltxpd, sizeof(struct txpd));
+	txpd->tx_packet_length = cpu_to_le16(pkt_len);
+	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
 
-	if (IS_MESH_FRAME(skb)) {
-		plocaltxpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
-	}
+	if (dev == priv->mesh_dev)
+		txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
 
-	memcpy(ptr, plocaltxpd, sizeof(struct txpd));
+	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) &txpd, sizeof(struct txpd));
 
-	ptr += sizeof(struct txpd);
+	lbs_deb_hex(LBS_DEB_TX, "Tx Data", (u8 *) p802x_hdr, le16_to_cpu(txpd->tx_packet_length));
 
-	lbs_deb_hex(LBS_DEB_TX, "Tx Data", (u8 *) p802x_hdr, le16_to_cpu(plocaltxpd->tx_packet_length));
-	memcpy(ptr, p802x_hdr, le16_to_cpu(plocaltxpd->tx_packet_length));
-	ret = priv->hw_host_to_card(priv, MVMS_DAT,
-				    priv->tmptxbuf,
-				    le16_to_cpu(plocaltxpd->tx_packet_length) +
-				    sizeof(struct txpd));
+	memcpy(&txpd[1], p802x_hdr, le16_to_cpu(txpd->tx_packet_length));
 
-	if (ret) {
-		lbs_deb_tx("tx err: hw_host_to_card returned 0x%X\n", ret);
-		goto done_tx;
-	}
+	/* We need to protect against the queues being restarted before
+	   we get round to stopping them */
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	lbs_deb_tx("%s succeeds\n", __func__);
+	ret = priv->hw_host_to_card(priv, MVMS_DAT, priv->tmptxbuf,
+				    pkt_len + sizeof(struct txpd));
 
-done_tx:
 	if (!ret) {
+		lbs_deb_tx("%s succeeds\n", __func__);
+
+		/* Stop processing outgoing pkts before submitting */
+		netif_stop_queue(priv->dev);
+		if (priv->mesh_dev)
+			netif_stop_queue(priv->mesh_dev);
+
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += skb->len;
 
- 		dev->trans_start = jiffies;
-	} else {
-		priv->stats.tx_dropped++;
-		priv->stats.tx_errors++;
+		dev->trans_start = jiffies;
+
+		if (priv->monitormode != LBS_MONITOR_OFF) {
+			/* Keep the skb to echo it back once Tx feedback is
+			   received from FW */
+			skb_orphan(skb);
+
+			/* Keep the skb around for when we get feedback */
+			priv->currenttxskb = skb;
+		}
 	}
+	
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
-	if (!ret && priv->monitormode != LBS_MONITOR_OFF) {
-		/* Keep the skb to echo it back once Tx feedback is
-		   received from FW */
-		skb_orphan(skb);
-		/* stop processing outgoing pkts */
-		netif_stop_queue(priv->dev);
-		if (priv->mesh_dev)
-			netif_stop_queue(priv->mesh_dev);
+	if (ret) {
+		lbs_deb_tx("tx err: hw_host_to_card returned 0x%X\n", ret);
+drop:
+		priv->stats.tx_dropped++;
+		priv->stats.tx_errors++;
 
-		/* Keep the skb around for when we get feedback */
-		priv->currenttxskb = skb;
-	} else {
 		dev_kfree_skb_any(skb);
 	}
 
+	/* Even if we dropped the packet, return OK. Otherwise the
+	   packet gets requeued. */
+	ret = NETDEV_TX_OK;
+
 done:
 	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
 	return ret;
-- 
1.5.3.4

