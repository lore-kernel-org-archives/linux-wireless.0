Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:51779 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZGEWFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 18:05:54 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Mon, 6 Jul 2009 00:05:55 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200907040053.05654.chunkeey@web.de> <200907051559.32958.chunkeey@web.de> <4A50E7C5.4040309@lwfinger.net>
In-Reply-To: <4A50E7C5.4040309@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907060005.55329.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 05 July 2009 19:49:57 Larry Finger wrote:
> How sure are you of the locking? It seems that the more threads that
> I'm using, the more likely that it is to happen. Similarly, the
> disassociation errors could be overloading the firmware by adding too
> many entries. Of course, it could result from a firmware error when
> the device is driven hard.
> 
> I've only given it one trial, but p54usb only survived for 24 minutes
> running my other torture test with repeating tcpperf in one terminal
> and a flood ping in  a second. This one got the disassociation error
> and also a "failure to remove key" (error code -95) and two "failed to
> uodate LEDs" (error code -12).
hmm, can you please give this a go? (I hope this patch still applies...)
I'm curious if you can dump the tx_queue when p54_alloc_skb fail?
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 461d88f..1dc1a09 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -246,8 +246,10 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct lm87_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!data_urb)
+	if (!data_urb) {
+		p54_free_skb(dev, skb);
 		return;
+	}
 
 	hdr->chksum = p54u_lm87_chksum((__le32 *)skb->data, skb->len);
 	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
@@ -269,27 +271,22 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *int_urb, *data_urb;
+	struct urb *int_urb = NULL, *data_urb = NULL;
 	struct net2280_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
-	struct net2280_reg_write *reg;
-	int err = 0;
+	struct net2280_reg_write *reg = NULL;
+	int err = -ENOMEM;
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
-		return;
+		goto out;
 
 	int_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!int_urb) {
-		kfree(reg);
-		return;
-	}
+	if (!int_urb)
+		goto out;
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!data_urb) {
-		kfree(reg);
-		usb_free_urb(int_urb);
-		return;
-	}
+	if (!data_urb)
+		goto out;
 
 	reg->port = cpu_to_le16(NET2280_DEV_U32);
 	reg->addr = cpu_to_le32(P54U_DEV_BASE);
@@ -329,14 +326,12 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 		usb_unanchor_urb(data_urb);
 		goto out;
 	}
- out:
+out:
 	usb_free_urb(int_urb);
 	usb_free_urb(data_urb);
 
-	if (err) {
-		skb_pull(skb, sizeof(*hdr));
+	if (err)
 		p54_free_skb(dev, skb);
-	}
 }
 
 static int p54u_write(struct p54u_priv *priv,
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index ea074a6..01eadb1 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -199,7 +199,7 @@ static int p54_tx_qos_accounting_alloc(struct p54_common *priv,
 	queue = &priv->tx_stats[p54_queue];
 
 	spin_lock_irqsave(&priv->tx_stats_lock, flags);
-	if (unlikely(queue->len > queue->limit && IS_QOS_QUEUE(p54_queue))) {
+	if (unlikely(queue->len >= queue->limit && IS_QOS_QUEUE(p54_queue))) {
 		spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
 		return -ENOSPC;
 	}
@@ -222,8 +222,11 @@ static void p54_tx_qos_accounting_free(struct p54_common *priv,
 	if (skb && IS_DATA_FRAME(skb)) {
 		struct p54_hdr *hdr = (void *) skb->data;
 		struct p54_tx_data *data = (void *) hdr->data;
+		unsigned long flags;
 
+		spin_lock_irqsave(&priv->tx_stats_lock, flags);
 		priv->tx_stats[data->hw_queue].len--;
+		spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
 	}
 	p54_wake_queues(priv);
 }
@@ -504,7 +507,6 @@ static void p54_rx_eeprom_readback(struct p54_common *priv,
 
 	priv->eeprom = NULL;
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
-	p54_tx_qos_accounting_free(priv, tmp);
 	dev_kfree_skb_any(tmp);
 	complete(&priv->eeprom_comp);
 }
@@ -531,7 +533,6 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	priv->noise = p54_rssi_to_dbm(priv, le32_to_cpu(stats->noise));
 
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
-	p54_tx_qos_accounting_free(priv, tmp);
 	dev_kfree_skb_any(tmp);
 }
 
