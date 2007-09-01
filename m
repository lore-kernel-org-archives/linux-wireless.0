Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXIAEfa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:30 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 80DC4618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:29 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 13/35] Rename some long functions and fields
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:29 -0400
Message-ID: <20070901043528.2498.58304.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly try to avoid "bulk", which is a minor technical detail.  Also
avoid read/write in favor of more common rx/tx.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  101 ++++++++++++++++++---------------------
 drivers/net/wireless/at76_usb.h |    8 ++-
 2 files changed, 50 insertions(+), 59 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 2ed80eb..f49fb3d 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1538,7 +1538,7 @@ static inline int at76_calc_padding(int wlen)
 */
 /* Or maybe because our BH handler is preempting bttv's BH handler.. BHs don't
  * solve everything.. (alex) */
-static void at76_read_bulk_callback(struct urb *urb)
+static void at76_rx_callback(struct urb *urb)
 {
 	struct at76_priv *priv = urb->context;
 
@@ -1547,7 +1547,7 @@ static void at76_read_bulk_callback(struct urb *urb)
 	return;
 }
 
-static void at76_write_bulk_callback(struct urb *urb)
+static void at76_tx_callback(struct urb *urb)
 {
 	struct at76_priv *priv = urb->context;
 	struct net_device_stats *stats = &priv->stats;
@@ -1564,7 +1564,7 @@ static void at76_write_bulk_callback(struct urb *urb)
 		/* urb has been unlinked */
 		return;
 	default:
-		at76_dbg(DBG_URB, "%s - nonzero write bulk status received: %d",
+		at76_dbg(DBG_URB, "%s - nonzero tx status received: %d",
 			 __func__, urb->status);
 		stats->tx_errors++;
 		break;
@@ -1584,11 +1584,11 @@ static void at76_write_bulk_callback(struct urb *urb)
 	   to the length */
 	memcpy(priv->bulk_out_buffer, mgmt_buf,
 	       le16_to_cpu(mgmt_buf->wlength) + AT76_TX_HDRLEN);
-	usb_fill_bulk_urb(priv->write_urb, priv->udev, priv->tx_bulk_pipe,
+	usb_fill_bulk_urb(priv->tx_urb, priv->udev, priv->tx_pipe,
 			  priv->bulk_out_buffer,
 			  le16_to_cpu(mgmt_buf->wlength) + mgmt_buf->padding +
-			  AT76_TX_HDRLEN, at76_write_bulk_callback, priv);
-	ret = usb_submit_urb(priv->write_urb, GFP_ATOMIC);
+			  AT76_TX_HDRLEN, at76_tx_callback, priv);
+	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
 	if (ret)
 		err("%s: %s error in tx submit urb: %d",
 		    priv->netdev->name, __func__, ret);
@@ -1596,10 +1596,8 @@ static void at76_write_bulk_callback(struct urb *urb)
 	kfree(mgmt_buf);
 }
 
-/* Send a management frame on bulk-out.
-   txbuf->wlength must be set (in LE format !) */
-static int at76_send_mgmt_bulk(struct at76_priv *priv,
-			       struct at76_tx_buffer *txbuf)
+/* Send a management frame on bulk-out.  txbuf->wlength must be set */
+static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -1611,7 +1609,7 @@ static int at76_send_mgmt_bulk(struct at76_priv *priv,
 
 	spin_lock_irqsave(&priv->mgmt_spinlock, flags);
 
-	urb_status = priv->write_urb->status;
+	urb_status = priv->tx_urb->status;
 	if (urb_status == -EINPROGRESS) {
 		oldbuf = priv->next_mgmt_bulk;	/* to kfree below */
 		priv->next_mgmt_bulk = txbuf;
@@ -1648,11 +1646,11 @@ static int at76_send_mgmt_bulk(struct at76_priv *priv,
 	/* txbuf was not consumed above -> send mgmt msg immediately */
 	memcpy(priv->bulk_out_buffer, txbuf,
 	       le16_to_cpu(txbuf->wlength) + AT76_TX_HDRLEN);
-	usb_fill_bulk_urb(priv->write_urb, priv->udev, priv->tx_bulk_pipe,
+	usb_fill_bulk_urb(priv->tx_urb, priv->udev, priv->tx_pipe,
 			  priv->bulk_out_buffer,
 			  le16_to_cpu(txbuf->wlength) + txbuf->padding +
-			  AT76_TX_HDRLEN, at76_write_bulk_callback, priv);
-	ret = usb_submit_urb(priv->write_urb, GFP_ATOMIC);
+			  AT76_TX_HDRLEN, at76_tx_callback, priv);
+	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
 	if (ret)
 		err("%s: %s error in tx submit urb: %d",
 		    priv->netdev->name, __func__, ret);
@@ -1720,7 +1718,7 @@ static int at76_auth_req(struct at76_priv *priv, struct bss_info *bss,
 
 	/* either send immediately (if no data tx is pending
 	   or put it in pending list */
-	return at76_send_mgmt_bulk(priv, tx_buffer);
+	return at76_tx_mgmt(priv, tx_buffer);
 }
 
 static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
@@ -1794,7 +1792,7 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 
 	/* either send immediately (if no data tx is pending
 	   or put it in pending list */
-	return at76_send_mgmt_bulk(priv, tx_buffer);
+	return at76_tx_mgmt(priv, tx_buffer);
 }
 
 /* We got to check the bss_list for old entries */
@@ -3246,8 +3244,8 @@ static int at76_tx(struct sk_buff *skb, struct net_device *netdev)
 		return 0;
 	}
 
-	if (priv->write_urb->status == -EINPROGRESS) {
-		err("%s: %s called while priv->write_urb is pending for tx",
+	if (priv->tx_urb->status == -EINPROGRESS) {
+		err("%s: %s called while priv->tx_urb is pending for tx",
 		    netdev->name, __func__);
 		/* skip this packet */
 		dev_kfree_skb(skb);
@@ -3339,20 +3337,16 @@ static int at76_tx(struct sk_buff *skb, struct net_device *netdev)
 	netif_stop_queue(netdev);
 	netdev->trans_start = jiffies;
 
-	usb_fill_bulk_urb(priv->write_urb, priv->udev, priv->tx_bulk_pipe,
-			  tx_buffer, submit_len, at76_write_bulk_callback,
-			  priv);
-	ret = usb_submit_urb(priv->write_urb, GFP_ATOMIC);
+	usb_fill_bulk_urb(priv->tx_urb, priv->udev, priv->tx_pipe, tx_buffer,
+			  submit_len, at76_tx_callback, priv);
+	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
 	if (ret) {
 		stats->tx_errors++;
 		err("%s: error in tx submit urb: %d", netdev->name, ret);
 		if (ret == -EINVAL)
 			err("-EINVAL: urb %p urb->hcpriv %p urb->complete %p",
-			    priv->write_urb,
-			    priv->write_urb ? priv->write_urb->
-			    hcpriv : (void *)-1,
-			    priv->write_urb ? priv->write_urb->
-			    complete : (void *)-1);
+			    priv->tx_urb, priv->tx_urb->hcpriv,
+			    priv->tx_urb->complete);
 	} else {
 		stats->tx_bytes += skb->len;
 		dev_kfree_skb(skb);
@@ -3369,18 +3363,18 @@ static void at76_tx_timeout(struct net_device *netdev)
 		return;
 	warn("%s: tx timeout.", netdev->name);
 
-	usb_unlink_urb(priv->write_urb);
+	usb_unlink_urb(priv->tx_urb);
 	priv->stats.tx_errors++;
 }
 
-static int at76_submit_read_urb(struct at76_priv *priv)
+static int at76_submit_rx_urb(struct at76_priv *priv)
 {
 	int ret;
 	int size;
 	struct sk_buff *skb = priv->rx_skb;
 
-	if (!priv->read_urb) {
-		err("%s: priv->read_urb is NULL", __func__);
+	if (!priv->rx_urb) {
+		err("%s: priv->rx_urb is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -3399,10 +3393,9 @@ static int at76_submit_read_urb(struct at76_priv *priv)
 	}
 
 	size = skb_tailroom(skb);
-	usb_fill_bulk_urb(priv->read_urb, priv->udev, priv->rx_bulk_pipe,
-			  skb_put(skb, size), size, at76_read_bulk_callback,
-			  priv);
-	ret = usb_submit_urb(priv->read_urb, GFP_ATOMIC);
+	usb_fill_bulk_urb(priv->rx_urb, priv->udev, priv->rx_pipe,
+			  skb_put(skb, size), size, at76_rx_callback, priv);
+	ret = usb_submit_urb(priv->rx_urb, GFP_ATOMIC);
 	if (ret < 0) {
 		if (ret == -ENODEV)
 			at76_dbg(DBG_DEVSTART,
@@ -3457,9 +3450,9 @@ static int at76_open(struct net_device *netdev)
 	priv->last_scan = jiffies;
 	priv->nr_submit_rx_tries = NR_SUBMIT_RX_TRIES;	/* init counter */
 
-	ret = at76_submit_read_urb(priv);
+	ret = at76_submit_rx_urb(priv);
 	if (ret < 0) {
-		err("%s: open: submit_read_urb failed: %d", netdev->name, ret);
+		err("%s: open: submit_rx_urb failed: %d", netdev->name, ret);
 		goto error;
 	}
 
@@ -3492,9 +3485,9 @@ static int at76_stop(struct net_device *netdev)
 		 * device is not available anymore. */
 		at76_set_radio(priv, 0);
 
-		/* We unlink read_urb because at76_open() re-submits it.
+		/* We unlink rx_urb because at76_open() re-submits it.
 		 * If unplugged, at76_delete_device() takes care of it. */
-		usb_kill_urb(priv->read_urb);
+		usb_kill_urb(priv->rx_urb);
 	}
 
 	cancel_delayed_work(&priv->dwork_get_scan);
@@ -4285,7 +4278,7 @@ static void at76_work_submit_rx(struct work_struct *work)
 					      work_submit_rx);
 
 	mutex_lock(&priv->mtx);
-	at76_submit_read_urb(priv);
+	at76_submit_rx_urb(priv);
 	mutex_unlock(&priv->mtx);
 }
 
@@ -5064,7 +5057,7 @@ static struct sk_buff *at76_check_for_rx_frags(struct at76_priv *priv)
 	} else {
 		/* take the skb from priv->rx_skb */
 		optr->skb = priv->rx_skb;
-		/* let at76_submit_read_urb() allocate a new skb */
+		/* let at76_submit_rx_urb() allocate a new skb */
 		priv->rx_skb = NULL;
 
 		at76_dbg(DBG_RX_FRAGS, "%s: use a free entry",
@@ -5280,7 +5273,7 @@ static void at76_rx_tasklet(unsigned long param)
 		       priv->netdev->name, frame_ctl);
 	}
 exit:
-	at76_submit_read_urb(priv);
+	at76_submit_rx_urb(priv);
 }
 
 /* Load firmware into kernel memory and parse it */
@@ -5450,14 +5443,12 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 		return -ENXIO;
 	}
 
-	priv->rx_bulk_pipe =
-	    usb_rcvbulkpipe(priv->udev, ep_in->bEndpointAddress);
-	priv->tx_bulk_pipe =
-	    usb_sndbulkpipe(priv->udev, ep_out->bEndpointAddress);
+	priv->rx_pipe = usb_rcvbulkpipe(priv->udev, ep_in->bEndpointAddress);
+	priv->tx_pipe = usb_sndbulkpipe(priv->udev, ep_out->bEndpointAddress);
 
-	priv->read_urb = usb_alloc_urb(0, GFP_KERNEL);
-	priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!priv->read_urb || !priv->write_urb) {
+	priv->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
+	priv->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!priv->rx_urb || !priv->tx_urb) {
 		printk(KERN_ERR DRIVER_NAME ": cannot allocate URB\n");
 		return -ENOMEM;
 	}
@@ -5579,13 +5570,13 @@ static void at76_delete_device(struct at76_priv *priv)
 
 	kfree(priv->bulk_out_buffer);
 
-	if (priv->write_urb) {
-		usb_kill_urb(priv->write_urb);
-		usb_free_urb(priv->write_urb);
+	if (priv->tx_urb) {
+		usb_kill_urb(priv->tx_urb);
+		usb_free_urb(priv->tx_urb);
 	}
-	if (priv->read_urb) {
-		usb_kill_urb(priv->read_urb);
-		usb_free_urb(priv->read_urb);
+	if (priv->rx_urb) {
+		usb_kill_urb(priv->rx_urb);
+		usb_free_urb(priv->rx_urb);
 	}
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index fbae175..07bbf14 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -491,11 +491,11 @@ struct at76_priv {
 	struct sk_buff *rx_skb;	/* skbuff for receiving data */
 	void *bulk_out_buffer;	/* buffer for sending data */
 
-	struct urb *write_urb;	/* URB for sending data */
-	struct urb *read_urb;	/* URB for receiving data */
+	struct urb *tx_urb;	/* URB for sending data */
+	struct urb *rx_urb;	/* URB for receiving data */
 
-	unsigned int tx_bulk_pipe;	/* bulk out endpoint */
-	unsigned int rx_bulk_pipe;	/* bulk in endpoint */
+	unsigned int tx_pipe;	/* bulk out pipe */
+	unsigned int rx_pipe;	/* bulk in pipe */
 
 	struct mutex mtx;	/* locks this structure */
 
