Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39206 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYLSBy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 20:54:27 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: p54usb problems
Date: Fri, 19 Dec 2008 02:54:23 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4949753B.9000505@lwfinger.net> <200812172333.56596.chunkeey@web.de> <4949B566.20008@lwfinger.net>
In-Reply-To: <4949B566.20008@lwfinger.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_P7vSJIw57MghdB3"
Message-Id: <200812190254.23731.chunkeey@web.de> (sfid-20081219_025433_474311_3743CA35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_P7vSJIw57MghdB3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 18 December 2008 03:28:54 Larry Finger wrote:
> Christian Lamparter wrote:
> > hmm, I wonder why it's a "order:1" allocation, even on x86-64 the skb_shared_struct is less than 300 bytes
> > and the maximum rx_mtu size about 3240 so there should be room left.... of course, it's not really a big
> > deal for p54, since we don't have to support frames larger RTS or Fragmentation threshold anyway...
> > but what about 11n devices? aren't they suffer from the same problems under load?
> 
> The actual size requested is 520 bytes bigger than what is asked for plus the L1
> cache alignment, which is getting close to 4000 bytes. If I missed something, it
> could be over 4096.
> 
> Larry

Oh well, looks like iwlwifi had this problems as well:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=7b52beeab30692f4b92c8efc9f806794c6b03473

anyway, I've attached an early RFC, in which the RX refilling is offloaded into a workqueue.
The locking is a maybe a bit overkill, and make C=2 produces a warning, (not to mention checkpatch.pl ;) )
but it didn't crash/freeze/burn here and Its really late here.

Regards,
	Chr

--Boundary-00=_P7vSJIw57MghdB3
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="p54usb-refill-work.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54usb-refill-work.diff"

diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-19 00:31:46.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-19 02:42:05.000000000 +0100
@@ -85,6 +85,7 @@ static void p54u_rx_cb(struct urb *urb)
 	struct p54u_rx_info *info = (struct p54u_rx_info *)skb->cb;
 	struct ieee80211_hw *dev = info->dev;
 	struct p54u_priv *priv = dev->priv;
+	unsigned long flags;
 
 	skb_unlink(skb, &priv->rx_queue);
 
@@ -103,17 +104,17 @@ static void p54u_rx_cb(struct urb *urb)
 	}
 
 	if (p54_rx(dev, skb)) {
-		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
-		if (unlikely(!skb)) {
-			/* TODO check rx queue length and refill *somewhere* */
-			return;
-		}
-
-		info = (struct p54u_rx_info *) skb->cb;
-		info->urb = urb;
-		info->dev = dev;
-		urb->transfer_buffer = skb_tail_pointer(skb);
-		urb->context = skb;
+		spin_lock_irqsave(&priv->refill_lock, flags);
+		list_add_tail(&urb->urb_list, &priv->refill_list);
+		spin_unlock_irqrestore(&priv->refill_lock, flags);
+		urb->transfer_buffer = NULL;
+		urb->context = NULL;
+
+		/*
+		 * don't let the usb stack free the urb.
+		 */
+		usb_get_urb(urb);
+		schedule_work(&priv->work);
 	} else {
 		if (priv->hw_type == P54U_NET2280)
 			skb_push(skb, priv->common.tx_hdr_len);
@@ -128,13 +129,13 @@ static void p54u_rx_cb(struct urb *urb)
 			WARN_ON(1);
 			urb->transfer_buffer = skb_tail_pointer(skb);
 		}
-	}
-	skb_queue_tail(&priv->rx_queue, skb);
-	usb_anchor_urb(urb, &priv->submitted);
-	if (usb_submit_urb(urb, GFP_ATOMIC)) {
-		skb_unlink(skb, &priv->rx_queue);
-		usb_unanchor_urb(urb);
-		dev_kfree_skb_irq(skb);
+
+		usb_anchor_urb(urb, &priv->submitted);
+		if (usb_submit_urb(urb, GFP_ATOMIC)) {
+			usb_unanchor_urb(urb);
+			dev_kfree_skb_irq(skb);
+		} else
+			skb_queue_tail(&priv->rx_queue, skb);
 	}
 }
 
@@ -152,58 +153,101 @@ static void p54u_tx_cb(struct urb *urb)
 
 static void p54u_tx_dummy_cb(struct urb *urb) { }
 
+static void p54u_free_refill(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->refill_lock, flags);
+	list_for_each_entry_safe(entry, tmp, &priv->refill_list, urb_list) {
+		list_del(&entry->urb_list);
+		usb_free_urb(entry);
+	}
+	spin_unlock_irqrestore(&priv->refill_lock, flags);
+}
+
 static void p54u_free_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
 	usb_kill_anchored_urbs(&priv->submitted);
+	cancel_work_sync(&priv->work);
+	p54u_free_refill(dev);
 }
 
-static int p54u_init_urbs(struct ieee80211_hw *dev)
+static int p54u_refill_rx(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *entry = NULL;
-	struct sk_buff *skb;
-	struct p54u_rx_info *info;
-	int ret = 0;
+	struct urb* entry, *tmp;
+	unsigned long flags, flags2;
+
+	spin_lock_irqsave(&priv->refill_lock, flags);
+	list_for_each_entry_safe(entry, tmp, &priv->refill_list, urb_list) {
+		struct p54u_rx_info *info;
+		struct sk_buff *skb;
 
-	while (skb_queue_len(&priv->rx_queue) < 32) {
+		list_del(&entry->urb_list);
+		spin_unlock_irqrestore(&priv->refill_lock, flags);
 		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
-		if (!skb) {
-			ret = -ENOMEM;
-			goto err;
-		}
-		entry = usb_alloc_urb(0, GFP_KERNEL);
-		if (!entry) {
-			ret = -ENOMEM;
-			goto err;
+
+		if (unlikely(!skb)) {
+			spin_lock_irqsave(&priv->refill_lock, flags);
+			list_add(&entry->urb_list, &priv->refill_list);
+			continue;
 		}
 
 		usb_fill_bulk_urb(entry, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
 				  skb_tail_pointer(skb),
 				  priv->common.rx_mtu + 32, p54u_rx_cb, skb);
+
 		info = (struct p54u_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
-		skb_queue_tail(&priv->rx_queue, skb);
+		spin_lock_irqsave(&priv->rx_queue.lock, flags2);
+		__skb_queue_tail(&priv->rx_queue, skb);
 
 		usb_anchor_urb(entry, &priv->submitted);
-		ret = usb_submit_urb(entry, GFP_KERNEL);
-		if (ret) {
-			skb_unlink(skb, &priv->rx_queue);
-			usb_unanchor_urb(entry);
-			goto err;
+		if (usb_submit_urb(entry, GFP_ATOMIC)) {
+			__skb_unlink(skb, &priv->rx_queue);
+			spin_unlock_irqrestore(&priv->rx_queue.lock, flags2);
+			spin_lock_irqsave(&priv->refill_lock, flags);
+			list_add_tail(&entry->urb_list, &priv->refill_list);
+			spin_unlock_irqrestore(&priv->refill_lock, flags);
+			kfree_skb(skb);
 		}
+		spin_unlock_irqrestore(&priv->rx_queue.lock, flags2);
 		usb_free_urb(entry);
-		entry = NULL;
+		spin_lock_irqsave(&priv->refill_lock, flags);
 	}
-
+	spin_unlock_irqrestore(&priv->refill_lock, flags);
 	return 0;
+}
+
+static int p54u_init_urbs(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry;
+	unsigned long flags;
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < 32; i++) {
+		entry = usb_alloc_urb(0, GFP_KERNEL);
+		if (!entry) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		spin_lock_irqsave(&priv->refill_lock, flags);
+		list_add_tail(&entry->urb_list, &priv->refill_list);
+		spin_unlock_irqrestore(&priv->refill_lock, flags);
+	}
+
+	p54u_refill_rx(dev);
 
  err:
-	usb_free_urb(entry);
-	kfree_skb(skb);
-	p54u_free_urbs(dev);
+	p54u_free_refill(dev);
 	return ret;
 }
 
@@ -834,6 +878,12 @@ static int p54u_upload_firmware_net2280(
 	return err;
 }
 
+static void p54u_work(struct work_struct *work)
+{
+	struct p54u_priv *priv = container_of(work, struct p54u_priv, work);
+	p54u_refill_rx(priv->common.hw);
+}
+
 static int p54u_open(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -924,6 +974,9 @@ static int __devinit p54u_probe(struct u
 
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
+	INIT_WORK(&priv->work, p54u_work);
+	spin_lock_init(&priv->refill_lock);
+	INIT_LIST_HEAD(&priv->refill_list);
 
 	p54u_open(dev);
 	err = p54_read_eeprom(dev);
diff -Nurp a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-12-19 00:31:48.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.h	2008-12-19 01:33:06.000000000 +0100
@@ -134,6 +134,9 @@ struct p54u_priv {
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
 	struct usb_anchor submitted;
+	spinlock_t refill_lock;
+	struct list_head refill_list;
+	struct work_struct work;
 };
 
 #endif /* P54USB_H */

--Boundary-00=_P7vSJIw57MghdB3--
