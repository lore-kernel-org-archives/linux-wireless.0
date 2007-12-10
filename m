Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbXLJPqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:20 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 44/48] libertas: Move actual transmission to main thread
Message-Id: <E1J1kpo-0006nf-Eu@shinybook.infradead.org> (sfid-20071210_154642_689785_F370C5A4)
Date: Mon, 10 Dec 2007 10:46:20 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 23:54:27 -0500

The locking issues with TX, especially TX from multiple netdevs, get
_so_ much easier if you do it like this.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/dev.h  |    5 +-
 drivers/net/wireless/libertas/main.c |   24 ++++++++
 drivers/net/wireless/libertas/tx.c   |  103 ++++++++++++++--------------------
 3 files changed, 71 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 04cf33d..4681405 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -164,7 +164,10 @@ struct lbs_private {
 
 	struct mutex lock;
 
-	u8 tmptxbuf[LBS_UPLD_SIZE];
+	/* TX packet ready to be sent... */
+	int tx_pending_len;		/* -1 while building packet */
+
+	u8 tx_pending_buf[LBS_UPLD_SIZE];
 	/* protected by hard_start_xmit serialization */
 
 	/** command-related variables */
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 42b64b5..f16c93b 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -739,6 +739,8 @@ static int lbs_thread(void *data)
 			shouldsleep = 0;	/* Interrupt pending. Deal with it now */
 		else if (priv->dnld_sent)
 			shouldsleep = 1;	/* Something is en route to the device already */
+		else if (priv->tx_pending_len > 0)
+			shouldsleep = 0;	/* We've a packet to send */
 		else if (priv->cur_cmd)
 			shouldsleep = 1;	/* Can't send a command; one already running */
 		else if (!list_empty(&priv->cmdpendingq))
@@ -852,6 +854,28 @@ static int lbs_thread(void *data)
 		 */
 		if (!list_empty(&priv->cmdpendingq))
 			wake_up_all(&priv->cmd_pending);
+
+		spin_lock_irq(&priv->driver_lock);
+		if (!priv->dnld_sent && priv->tx_pending_len > 0) {
+			int ret = priv->hw_host_to_card(priv, MVMS_DAT,
+							priv->tx_pending_buf,
+							priv->tx_pending_len);
+			if (ret) {
+				lbs_deb_tx("host_to_card failed %d\n", ret);
+				priv->dnld_sent = DNLD_RES_RECEIVED;
+			}
+			priv->tx_pending_len = 0;
+			if (!priv->currenttxskb) {
+				/* We can wake the queues immediately if we aren't
+				   waiting for TX feedback */
+				if (priv->connect_status == LBS_CONNECTED)
+					netif_wake_queue(priv->dev);
+				if (priv->mesh_dev &&
+				    priv->mesh_connect_status == LBS_CONNECTED)
+					netif_wake_queue(priv->mesh_dev);
+			}
+		}
+		spin_unlock_irq(&priv->driver_lock);
 	}
 
 	del_timer(&priv->command_timer);
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 300aa05..e2141f0 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -67,39 +67,45 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	lbs_deb_enter(LBS_DEB_TX);
 
-	ret = NETDEV_TX_BUSY;
-
-	if (priv->dnld_sent) {
-		lbs_pr_alert( "TX error: dnld_sent = %d, not sending\n",
-		       priv->dnld_sent);
-		goto done;
-	}
-
-	if (priv->currenttxskb) {
-		lbs_pr_err("%s while TX skb pending\n", __func__);
-		goto done;
-	}
+	ret = NETDEV_TX_OK;
 
-	if ((priv->psstate == PS_STATE_SLEEP) ||
-	    (priv->psstate == PS_STATE_PRE_SLEEP)) {
-		lbs_pr_alert("TX error: packet xmit in %ssleep mode\n",
-			     priv->psstate == PS_STATE_SLEEP?"":"pre-");
-		goto done;
-	}
+	/* We need to protect against the queues being restarted before
+	   we get round to stopping them */
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	if (priv->surpriseremoved)
-		goto drop;
+		goto free;
 
 	if (!skb->len || (skb->len > MRVDRV_ETH_TX_PACKET_BUFFER_SIZE)) {
 		lbs_deb_tx("tx err: skb length %d 0 or > %zd\n",
 		       skb->len, MRVDRV_ETH_TX_PACKET_BUFFER_SIZE);
 		/* We'll never manage to send this one; drop it and return 'OK' */
-		goto drop;
+
+		priv->stats.tx_dropped++;
+		priv->stats.tx_errors++;
+		goto free;
+	}
+
+
+	netif_stop_queue(priv->dev);
+	if (priv->mesh_dev)
+		netif_stop_queue(priv->mesh_dev);
+
+	if (priv->tx_pending_len) {
+		/* This can happen if packets come in on the mesh and eth 
+		   device simultaneously -- there's no mutual exclusion on 
+		   hard_start_xmit() calls between devices. */
+		lbs_deb_tx("Packet on %s while busy\n", dev->name);
+		ret = NETDEV_TX_BUSY;
+		goto unlock;
 	}
 
+	priv->tx_pending_len = -1;
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+
 	lbs_deb_hex(LBS_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
 
-	txpd = (void *)priv->tmptxbuf;
+	txpd = (void *)priv->tx_pending_buf;
 	memset(txpd, 0, sizeof(struct txpd));
 
 	p802x_hdr = skb->data;
@@ -134,54 +140,31 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	memcpy(&txpd[1], p802x_hdr, le16_to_cpu(txpd->tx_packet_length));
 
-	/* We need to protect against the queues being restarted before
-	   we get round to stopping them */
 	spin_lock_irqsave(&priv->driver_lock, flags);
+	priv->tx_pending_len = pkt_len + sizeof(struct txpd);
 
-	ret = priv->hw_host_to_card(priv, MVMS_DAT, priv->tmptxbuf,
-				    pkt_len + sizeof(struct txpd));
-
-	if (!ret) {
-		lbs_deb_tx("%s succeeds\n", __func__);
-
-		/* Stop processing outgoing pkts before submitting */
-		netif_stop_queue(priv->dev);
-		if (priv->mesh_dev)
-			netif_stop_queue(priv->mesh_dev);
-
-		priv->stats.tx_packets++;
-		priv->stats.tx_bytes += skb->len;
-
-		dev->trans_start = jiffies;
+	lbs_deb_tx("%s lined up packet\n", __func__);
 
-		if (priv->monitormode != LBS_MONITOR_OFF) {
-			/* Keep the skb to echo it back once Tx feedback is
-			   received from FW */
-			skb_orphan(skb);
+	priv->stats.tx_packets++;
+	priv->stats.tx_bytes += skb->len;
 
-			/* Keep the skb around for when we get feedback */
-			priv->currenttxskb = skb;
-		} else
-			dev_kfree_skb_any(skb);
-		
-	}
-	
-	spin_unlock_irqrestore(&priv->driver_lock, flags);
+	dev->trans_start = jiffies;
 
-	if (ret) {
-		lbs_deb_tx("tx err: hw_host_to_card returned 0x%X\n", ret);
-drop:
-		priv->stats.tx_dropped++;
-		priv->stats.tx_errors++;
+	if (priv->monitormode != LBS_MONITOR_OFF) {
+		/* Keep the skb to echo it back once Tx feedback is
+		   received from FW */
+		skb_orphan(skb);
 
+		/* Keep the skb around for when we get feedback */
+		priv->currenttxskb = skb;
+	} else {
+ free:
 		dev_kfree_skb_any(skb);
 	}
+ unlock:
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+	wake_up(&priv->waitq);
 
-	/* Even if we dropped the packet, return OK. Otherwise the
-	   packet gets requeued. */
-	ret = NETDEV_TX_OK;
-
-done:
 	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
 	return ret;
 }
-- 
1.5.3.4

