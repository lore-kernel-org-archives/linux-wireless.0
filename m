Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58373 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab0EDVzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 17:55:00 -0400
Received: by mail-wy0-f174.google.com with SMTP id 20so2797546wye.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 14:54:59 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net, linville@tuxdriver.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: refactor xmit path
Date: Tue,  4 May 2010 22:54:41 +0100
Message-Id: <1273010082-15871-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1273010082-15871-1-git-send-email-kilroyd@googlemail.com>
References: <1273010082-15871-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... so orinoco_usb can share some common functionality.

Handle 802.2 encapsulation and MIC calculation in that function.
The 802.3 header is prepended to the SKB. The calculated MIC is written
to a specified buffer. Also modify the transmit control word that will
be passed onto the hardware to specify whether the MIC is present, and
the key used.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/main.c        |  169 +++++++++++++++++----------
 drivers/net/wireless/orinoco/orinoco.h     |    6 +
 drivers/net/wireless/orinoco/orinoco_usb.c |   91 +++++++--------
 3 files changed, 155 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 1d60c7e..3b9a5fb 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -340,18 +340,109 @@ EXPORT_SYMBOL(orinoco_change_mtu);
 /* Tx path                                                          */
 /********************************************************************/
 
+/* Add encapsulation and MIC to the existing SKB.
+ * The main xmit routine will then send the whole lot to the card.
+ * Need 8 bytes headroom
+ * Need 8 bytes tailroom
+ *
+ *                          With encapsulated ethernet II frame
+ *                          --------
+ *                          803.3 header (14 bytes)
+ *                           dst[6]
+ * --------                  src[6]
+ * 803.3 header (14 bytes)   len[2]
+ *  dst[6]                  803.2 header (8 bytes)
+ *  src[6]                   encaps[6]
+ *  len[2] <- leave alone -> len[2]
+ * --------                 -------- <-- 0
+ * Payload                  Payload
+ * ...                      ...
+ *
+ * --------                 --------
+ *                          MIC (8 bytes)
+ *                          --------
+ *
+ * returns 0 on success, -ENOMEM on error.
+ */
+int orinoco_process_xmit_skb(struct sk_buff *skb,
+			     struct net_device *dev,
+			     struct orinoco_private *priv,
+			     int *tx_control,
+			     u8 *mic_buf)
+{
+	struct orinoco_tkip_key *key;
+	struct ethhdr *eh;
+	int do_mic;
+
+	key = (struct orinoco_tkip_key *) priv->keys[priv->tx_key].key;
+
+	do_mic = ((priv->encode_alg == ORINOCO_ALG_TKIP) &&
+		  (key != NULL));
+
+	if (do_mic)
+		*tx_control |= (priv->tx_key << HERMES_MIC_KEY_ID_SHIFT) |
+			HERMES_TXCTRL_MIC;
+
+	eh = (struct ethhdr *)skb->data;
+
+	/* Encapsulate Ethernet-II frames */
+	if (ntohs(eh->h_proto) > ETH_DATA_LEN) { /* Ethernet-II frame */
+		struct header_struct {
+			struct ethhdr eth;	/* 802.3 header */
+			u8 encap[6];		/* 802.2 header */
+		} __attribute__ ((packed)) hdr;
+		int len = skb->len + sizeof(encaps_hdr) - (2 * ETH_ALEN);
+
+		if (skb_headroom(skb) < ENCAPS_OVERHEAD) {
+			if (net_ratelimit())
+				printk(KERN_ERR
+				       "%s: Not enough headroom for 802.2 headers %d\n",
+				       dev->name, skb_headroom(skb));
+			return -ENOMEM;
+		}
+
+		/* Fill in new header */
+		memcpy(&hdr.eth, eh, 2 * ETH_ALEN);
+		hdr.eth.h_proto = htons(len);
+		memcpy(hdr.encap, encaps_hdr, sizeof(encaps_hdr));
+
+		/* Make room for the new header, and copy it in */
+		eh = (struct ethhdr *) skb_push(skb, ENCAPS_OVERHEAD);
+		memcpy(eh, &hdr, sizeof(hdr));
+	}
+
+	/* Calculate Michael MIC */
+	if (do_mic) {
+		size_t len = skb->len - ETH_HLEN;
+		u8 *mic = &mic_buf[0];
+
+		/* Have to write to an even address, so copy the spare
+		 * byte across */
+		if (skb->len % 2) {
+			*mic = skb->data[skb->len - 1];
+			mic++;
+		}
+
+		orinoco_mic(priv->tx_tfm_mic, key->tx_mic,
+			    eh->h_dest, eh->h_source, 0 /* priority */,
+			    skb->data + ETH_HLEN,
+			    len, mic);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(orinoco_process_xmit_skb);
+
 static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
-	struct orinoco_tkip_key *key;
 	hermes_t *hw = &priv->hw;
 	int err = 0;
 	u16 txfid = priv->txfid;
-	struct ethhdr *eh;
 	int tx_control;
 	unsigned long flags;
-	int do_mic;
+	u8 mic_buf[MICHAEL_MIC_LEN+1];
 
 	if (!netif_running(dev)) {
 		printk(KERN_ERR "%s: Tx on stopped device!\n",
@@ -383,16 +474,12 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb->len < ETH_HLEN)
 		goto drop;
 
-	key = (struct orinoco_tkip_key *) priv->keys[priv->tx_key].key;
-
-	do_mic = ((priv->encode_alg == ORINOCO_ALG_TKIP) &&
-		  (key != NULL));
-
 	tx_control = HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX;
 
-	if (do_mic)
-		tx_control |= (priv->tx_key << HERMES_MIC_KEY_ID_SHIFT) |
-			HERMES_TXCTRL_MIC;
+	err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control,
+				       &mic_buf[0]);
+	if (err)
+		goto drop;
 
 	if (priv->has_alt_txcntl) {
 		/* WPA enabled firmwares have tx_cntl at the end of
@@ -435,34 +522,6 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 				   HERMES_802_3_OFFSET - HERMES_802_11_OFFSET);
 	}
 
-	eh = (struct ethhdr *)skb->data;
-
-	/* Encapsulate Ethernet-II frames */
-	if (ntohs(eh->h_proto) > ETH_DATA_LEN) { /* Ethernet-II frame */
-		struct header_struct {
-			struct ethhdr eth;	/* 802.3 header */
-			u8 encap[6];		/* 802.2 header */
-		} __attribute__ ((packed)) hdr;
-
-		/* Strip destination and source from the data */
-		skb_pull(skb, 2 * ETH_ALEN);
-
-		/* And move them to a separate header */
-		memcpy(&hdr.eth, eh, 2 * ETH_ALEN);
-		hdr.eth.h_proto = htons(sizeof(encaps_hdr) + skb->len);
-		memcpy(hdr.encap, encaps_hdr, sizeof(encaps_hdr));
-
-		/* Insert the SNAP header */
-		if (skb_headroom(skb) < sizeof(hdr)) {
-			printk(KERN_ERR
-			       "%s: Not enough headroom for 802.2 headers %d\n",
-			       dev->name, skb_headroom(skb));
-			goto drop;
-		}
-		eh = (struct ethhdr *) skb_push(skb, sizeof(hdr));
-		memcpy(eh, &hdr, sizeof(hdr));
-	}
-
 	err = hw->ops->bap_pwrite(hw, USER_BAP, skb->data, skb->len,
 				  txfid, HERMES_802_3_OFFSET);
 	if (err) {
@@ -471,32 +530,16 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto busy;
 	}
 
-	/* Calculate Michael MIC */
-	if (do_mic) {
-		u8 mic_buf[MICHAEL_MIC_LEN + 1];
-		u8 *mic;
-		size_t offset;
-		size_t len;
+	if (tx_control & HERMES_TXCTRL_MIC) {
+		size_t offset = HERMES_802_3_OFFSET + skb->len;
+		size_t len = MICHAEL_MIC_LEN;
 
-		if (skb->len % 2) {
-			/* MIC start is on an odd boundary */
-			mic_buf[0] = skb->data[skb->len - 1];
-			mic = &mic_buf[1];
-			offset = skb->len - 1;
-			len = MICHAEL_MIC_LEN + 1;
-		} else {
-			mic = &mic_buf[0];
-			offset = skb->len;
-			len = MICHAEL_MIC_LEN;
+		if (offset % 2) {
+			offset--;
+			len++;
 		}
-
-		orinoco_mic(priv->tx_tfm_mic, key->tx_mic,
-			    eh->h_dest, eh->h_source, 0 /* priority */,
-			    skb->data + ETH_HLEN, skb->len - ETH_HLEN, mic);
-
-		/* Write the MIC */
 		err = hw->ops->bap_pwrite(hw, USER_BAP, &mic_buf[0], len,
-					  txfid, HERMES_802_3_OFFSET + offset);
+					  txfid, offset);
 		if (err) {
 			printk(KERN_ERR "%s: Error %d writing MIC to BAP\n",
 			       dev->name, err);
@@ -2235,7 +2278,7 @@ int orinoco_if_add(struct orinoco_private *priv,
 	/* we use the default eth_mac_addr for setting the MAC addr */
 
 	/* Reserve space in skb for the SNAP header */
-	dev->hard_header_len += ENCAPS_OVERHEAD;
+	dev->needed_headroom = ENCAPS_OVERHEAD;
 
 	netif_carrier_off(dev);
 
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index e9f415a..a6da86e 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -200,6 +200,12 @@ extern irqreturn_t orinoco_interrupt(int irq, void *dev_id);
 extern void __orinoco_ev_info(struct net_device *dev, hermes_t *hw);
 extern void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw);
 
+int orinoco_process_xmit_skb(struct sk_buff *skb,
+			     struct net_device *dev,
+			     struct orinoco_private *priv,
+			     int *tx_control,
+			     u8 *mic);
+
 /* Common ndo functions exported for reuse by orinoco_usb */
 int orinoco_open(struct net_device *dev);
 int orinoco_stop(struct net_device *dev);
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index e220933..78f089b 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -67,6 +67,7 @@
 #include <linux/wireless.h>
 #include <linux/firmware.h>
 
+#include "mic.h"
 #include "orinoco.h"
 
 #ifndef URB_ASYNC_UNLINK
@@ -1198,11 +1199,9 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	struct ezusb_priv *upriv = priv->card;
+	u8 mic[MICHAEL_MIC_LEN+1];
 	int err = 0;
-	char *p;
-	struct ethhdr *eh;
-	int len, data_len, data_off;
-	__le16 tx_control;
+	int tx_control;
 	unsigned long flags;
 	struct request_context *ctx;
 	u8 *buf;
@@ -1222,7 +1221,7 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (orinoco_lock(priv, &flags) != 0) {
 		printk(KERN_ERR
-		       "%s: orinoco_xmit() called while hw_unavailable\n",
+		       "%s: ezusb_xmit() called while hw_unavailable\n",
 		       dev->name);
 		return NETDEV_TX_BUSY;
 	}
@@ -1232,53 +1231,46 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* Oops, the firmware hasn't established a connection,
 		   silently drop the packet (this seems to be the
 		   safest approach). */
-		stats->tx_errors++;
-		orinoco_unlock(priv, &flags);
-		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
+		goto drop;
 	}
 
+	/* Check packet length */
+	if (skb->len < ETH_HLEN)
+		goto drop;
+
 	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_TX, 0);
 	if (!ctx)
-		goto fail;
+		goto busy;
 
 	memset(ctx->buf, 0, BULK_BUF_SIZE);
 	buf = ctx->buf->data;
 
-	/* Length of the packet body */
-	/* FIXME: what if the skb is smaller than this? */
-	len = max_t(int, skb->len - ETH_HLEN, ETH_ZLEN - ETH_HLEN);
-
-	eh = (struct ethhdr *) skb->data;
-
-	tx_control = cpu_to_le16(0);
-	memcpy(buf, &tx_control, sizeof(tx_control));
-	buf += sizeof(tx_control);
-	/* Encapsulate Ethernet-II frames */
-	if (ntohs(eh->h_proto) > ETH_DATA_LEN) {	/* Ethernet-II frame */
-		struct header_struct *hdr = (void *) buf;
-		buf += sizeof(*hdr);
-		data_len = len;
-		data_off = sizeof(tx_control) + sizeof(*hdr);
-		p = skb->data + ETH_HLEN;
-
-		/* 802.3 header */
-		memcpy(hdr->dest, eh->h_dest, ETH_ALEN);
-		memcpy(hdr->src, eh->h_source, ETH_ALEN);
-		hdr->len = htons(data_len + ENCAPS_OVERHEAD);
-
-		/* 802.2 header */
-		memcpy(&hdr->dsap, &encaps_hdr, sizeof(encaps_hdr));
-
-		hdr->ethertype = eh->h_proto;
-	} else {		/* IEEE 802.3 frame */
-		data_len = len + ETH_HLEN;
-		data_off = sizeof(tx_control);
-		p = skb->data;
+	tx_control = 0;
+
+	err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control,
+				       &mic[0]);
+	if (err)
+		goto drop;
+
+	{
+		__le16 *tx_cntl = (__le16 *)buf;
+		*tx_cntl = cpu_to_le16(tx_control);
+		buf += sizeof(*tx_cntl);
 	}
 
-	memcpy(buf, p, data_len);
-	buf += data_len;
+	memcpy(buf, skb->data, skb->len);
+	buf += skb->len;
+
+	if (tx_control & HERMES_TXCTRL_MIC) {
+		u8 *m = mic;
+		/* Mic has been offset so it can be copied to an even
+		 * address. We're copying eveything anyway, so we
+		 * don't need to copy that first byte. */
+		if (skb->len % 2)
+			m++;
+		memcpy(buf, m, MICHAEL_MIC_LEN);
+		buf += MICHAEL_MIC_LEN;
+	}
 
 	/* Finally, we actually initiate the send */
 	netif_stop_queue(dev);
@@ -1294,20 +1286,23 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (net_ratelimit())
 			printk(KERN_ERR "%s: Error %d transmitting packet\n",
 				dev->name, err);
-		stats->tx_errors++;
-		goto fail;
+		goto busy;
 	}
 
 	dev->trans_start = jiffies;
-	stats->tx_bytes += data_off + data_len;
+	stats->tx_bytes += skb->len;
+	goto ok;
 
-	orinoco_unlock(priv, &flags);
+ drop:
+	stats->tx_errors++;
+	stats->tx_dropped++;
 
+ ok:
+	orinoco_unlock(priv, &flags);
 	dev_kfree_skb(skb);
-
 	return NETDEV_TX_OK;
 
- fail:
+ busy:
 	orinoco_unlock(priv, &flags);
 	return NETDEV_TX_BUSY;
 }
-- 
1.6.4.4

