Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53737 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZAUSYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 13:24:53 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Wed, 21 Jan 2009 19:24:54 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <49774794.507@gmail.com>
In-Reply-To: <49774794.507@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2h2dJPyreREVa6l"
Message-Id: <200901211924.54660.chunkeey@web.de> (sfid-20090121_192458_793949_4ECD2DD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_2h2dJPyreREVa6l
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 21 January 2009 17:04:36 Artur Skawina wrote:
> Yes, that's one of the things that is (well, was) on my todo list after 
> reading p54usb.c, so i obviously like the idea ;)
well, this patch is not so "new" anymore, I posted it a while a go.
But then we found a different, smaller fix and this work _stalled_.

> I'll write down some of the other things as they are related to this.
> It will take at least a few days for me do do and properly test, hence
> if you find the comments below useful i won't mind. ;)
not at all ;)

> This patch makes the usb rx path alloc-less (except for the actual urb
> submission call) which is good, but i wonder if we should try a GFP_NOWAIT
> allocation, and only fallback if that one fails.
Not necessary, we waste quite a lot memory by filling the rx ring with 32 useable packets.
So there should be no shortage (anymore).

> The net2280 tx path does at least three allocs, one tiny never-changing buffer
> and two urbs, i'd like to get rid of all of them. 
why? AFAIK kernel memory alloc already provides a good amount of (small) buffer caches,
so why should stockpile them only for ourself?

You know, 802.11b/g isn't exactly fast by any standards - heck even a 15 year old ethernet NIC
is easily 5-6 times faster. So, "optimizations" are a bit useless when we have these bottlenecks. 
In fact, if you have more than one GHz in your box, you should let your CPU do the
encryption/decryption instead of the 30Mhz ARM CPU.... 
this will give you a better latency for next to nothing.

> The constant buffer is easy - we can just kmalloc a cacheline-sized chunk on init, and (re)use that.
only a single constant buffer? are you sure that's a good idea, on dual cores?
(Or is this a misunderstanding and you plan to have up to 32/64 constant buffers?)

> As to the urbs, i originally wanted to put (at least one of) them in the skb
> headroom. But the fact that the skb can be freed before the completions run   
> makes that impossible.
Not only that, but you'll shift the alloc stuff to mac80211, which uses GFP_ATOMIC to expand the head,
if it's necessary.

> Do you have a git tree, or some kind of patch queue, with all the pending p54 patches? 
No, In fact, Linville do all the accouting in wireless-testing :-D already.

> Working on top of wireless-testing makes it harder to test. 
> What was this patch made against?
Strange? It should be apply cleanly on top of wireless-testing... well, give Linville some time to catch up ;-)

> >  static void p54u_tx_cb(struct urb *urb)
> > @@ -150,58 +178,115 @@ static void p54u_tx_cb(struct urb *urb)
> >  
> >  static void p54u_tx_dummy_cb(struct urb *urb) { }
> >  
> > +static void p54u_rx_refill_free_list(struct ieee80211_hw *dev)
> 
> the name is a bit misleading...
> s/p54u_rx_refill_free_list/p54u_free_rx_refill_list/ ?
dunno, it's more a namespace thing( easier to copy, paste & remember).
but on the other hand, p54u_free_rx is better for the eyes.

> > +static int p54u_rx_refill(struct ieee80211_hw *dev)
> >  {
> >  	struct p54u_priv *priv = dev->priv;
> > +	struct urb* entry, *tmp;
> > +	unsigned long flags, flags2;
> >  
> > +	spin_lock_irqsave(&priv->rx_refill_lock, flags);
> > +	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
> > +		struct p54u_rx_info *info;
> > +		struct sk_buff *skb;
> > +
> > +		list_del(&entry->urb_list);
> > +		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
> >  		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
> > +
> > +		if (unlikely(!skb)) {
> > +			/*
> > +			 * In order to prevent a loop, we put the urb
> > +			 * back at the _front_ of the list, so we can
> > +			 * march on, in out-of-memory situations.
> > +			 */
> > +
> > +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> > +			list_add(&entry->urb_list, &priv->rx_refill_list);
> > +			continue;
> >  		}
> >  
> >  		usb_fill_bulk_urb(entry, priv->udev,
> >  				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
> >  				  skb_tail_pointer(skb),
> >  				  priv->common.rx_mtu + 32, p54u_rx_cb, skb);
> > +
> >  		info = (struct p54u_rx_info *) skb->cb;
> >  		info->urb = entry;
> >  		info->dev = dev;
> > +		spin_lock_irqsave(&priv->rx_queue.lock, flags2);
> > +		__skb_queue_tail(&priv->rx_queue, skb);
> >  
> >  		usb_anchor_urb(entry, &priv->submitted);
> > +		if (usb_submit_urb(entry, GFP_ATOMIC)) {
> 
> GFP_KERNEL? [would need dropping rx_queue.lock earlier and retaking in the
> (hopefully rare) error path]
why not... I don't remember the real reason why I did this complicated lock, probably
because of resume/suspend (which does not work, in case you're looking for "real" work :-D ).

> > +			/*
> > +			 * urb submittion failed.
> > +			 * free the associated skb and put the urb back into 
> > +			 * the front of the refill list, so we can 
> > +			 * try our luck next time.
> > +			 */
> > +
> > +			__skb_unlink(skb, &priv->rx_queue);
> > +			spin_unlock_irqrestore(&priv->rx_queue.lock, flags);
> > +			kfree_skb(skb);
> > +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> > +			list_add(&entry->urb_list, &priv->rx_refill_list);
> > +			spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
> 
> 'entry' is now both anchored in priv->submitted and in the rx_refill_list.
thats right, in the error path the entry has to be unachored.

A updated patch is attached (as file)

Regards,
	Chr

--Boundary-00=_2h2dJPyreREVa6l
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="p54usb-refill-work.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54usb-refill-work.diff"

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index bf264b1..5087eae 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -86,6 +86,7 @@ static void p54u_rx_cb(struct urb *urb)
 	struct p54u_rx_info *info = (struct p54u_rx_info *)skb->cb;
 	struct ieee80211_hw *dev = info->dev;
 	struct p54u_priv *priv = dev->priv;
+	unsigned long flags;
 
 	skb_unlink(skb, &priv->rx_queue);
 
@@ -96,6 +97,7 @@ static void p54u_rx_cb(struct urb *urb)
 
 	skb_put(skb, urb->actual_length);
 
+	/* remove firmware/device specific headers in front of the frame */
 	if (priv->hw_type == P54U_NET2280)
 		skb_pull(skb, priv->common.tx_hdr_len);
 	if (priv->common.fw_interface == FW_LM87) {
@@ -103,19 +105,12 @@ static void p54u_rx_cb(struct urb *urb)
 		skb_put(skb, 4);
 	}
 
-	if (p54_rx(dev, skb)) {
-		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
-		if (unlikely(!skb)) {
-			/* TODO check rx queue length and refill *somewhere* */
-			return;
-		}
+	if (p54_rx(dev, skb) == 0) {
+		/*
+		 * This skb can be reused.
+		 * Undo all modifications and resubmit it.
+		 */
 
-		info = (struct p54u_rx_info *) skb->cb;
-		info->urb = urb;
-		info->dev = dev;
-		urb->transfer_buffer = skb_tail_pointer(skb);
-		urb->context = skb;
-	} else {
 		if (priv->hw_type == P54U_NET2280)
 			skb_push(skb, priv->common.tx_hdr_len);
 		if (priv->common.fw_interface == FW_LM87) {
@@ -129,14 +124,47 @@ static void p54u_rx_cb(struct urb *urb)
 			WARN_ON(1);
 			urb->transfer_buffer = skb_tail_pointer(skb);
 		}
+
+		usb_anchor_urb(urb, &priv->submitted);
+		if (usb_submit_urb(urb, GFP_ATOMIC) == 0) {
+			skb_queue_tail(&priv->rx_queue, skb);
+			return ;
+		} else {
+			usb_unanchor_urb(urb);
+			dev_kfree_skb_irq(skb);
+		}
 	}
-	skb_queue_tail(&priv->rx_queue, skb);
-	usb_anchor_urb(urb, &priv->submitted);
-	if (usb_submit_urb(urb, GFP_ATOMIC)) {
-		skb_unlink(skb, &priv->rx_queue);
-		usb_unanchor_urb(urb);
-		dev_kfree_skb_irq(skb);
+
+	/*
+	 * This skb CANNOT be reused.
+	 * Put the now unused urb into a list and do the refilled later on in
+	 * the less critical workqueue thread.
+	 * This eases the memory pressure and prevents latency spikes.
+	 */
+
+	urb->transfer_buffer = NULL;
+	urb->context = NULL;
+
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_add_tail(&urb->urb_list, &priv->rx_refill_list);
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+
+	/*
+	 * Don't let the usb stack free the queued urb after this completion
+	 * callback has finished.
+	 */
+	usb_get_urb(urb);
+
+	if (unlikely(!priv->common.hw->workqueue)) {
+		/*
+		 * Huh? mac80211 isn't fully initialized yet?
+		 * Please check your system, something bad is going on.
+		 */
+		WARN_ON(1);
+		return;
 	}
+
+	queue_work(priv->common.hw->workqueue, &priv->rx_refill_work);
 }
 
 static void p54u_tx_cb(struct urb *urb)
@@ -150,58 +178,112 @@ static void p54u_tx_cb(struct urb *urb)
 
 static void p54u_tx_dummy_cb(struct urb *urb) { }
 
+static void p54u_free_rx_refill_list(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
+		list_del(&entry->urb_list);
+		usb_free_urb(entry);
+	}
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+}
+
 static void p54u_free_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
+
+	cancel_work_sync(&priv->rx_refill_work);
+	p54u_free_rx_refill_list(dev);
 	usb_kill_anchored_urbs(&priv->submitted);
 }
 
-static int p54u_init_urbs(struct ieee80211_hw *dev)
+static int p54u_rx_refill(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *entry = NULL;
-	struct sk_buff *skb;
-	struct p54u_rx_info *info;
-	int ret = 0;
+	struct urb *entry, *tmp;
+	unsigned long flags;
 
-	while (skb_queue_len(&priv->rx_queue) < 32) {
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
+		struct p54u_rx_info *info;
+		struct sk_buff *skb;
+
+		list_del(&entry->urb_list);
+		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
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
+			/*
+			 * In order to prevent a loop, we put the urb
+			 * back at the _front_ of the list, so we can
+			 * march on, in out-of-memory situations.
+			 */
+
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			list_add(&entry->urb_list, &priv->rx_refill_list);
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
 
 		usb_anchor_urb(entry, &priv->submitted);
-		ret = usb_submit_urb(entry, GFP_KERNEL);
-		if (ret) {
-			skb_unlink(skb, &priv->rx_queue);
+		if (usb_submit_urb(entry, GFP_KERNEL)) {
+			/*
+			 * urb submittion failed.
+			 * free the associated skb and put the urb back into
+			 * the front of the refill list, so we can try our luck
+			 * next time.
+			 */
+
 			usb_unanchor_urb(entry);
+			kfree_skb(skb);
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			list_add(&entry->urb_list, &priv->rx_refill_list);
+		} else {
+			skb_queue_tail(&priv->rx_queue, skb);
+			usb_free_urb(entry);
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+	return 0;
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
 			goto err;
 		}
-		usb_free_urb(entry);
-		entry = NULL;
+
+		spin_lock_irqsave(&priv->rx_refill_lock, flags);
+		list_add_tail(&entry->urb_list, &priv->rx_refill_list);
+		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
 	}
 
-	return 0;
+	p54u_rx_refill(dev);
 
- err:
-	usb_free_urb(entry);
-	kfree_skb(skb);
-	p54u_free_urbs(dev);
+err:
+	p54u_free_rx_refill_list(dev);
 	return ret;
 }
 
@@ -878,6 +960,14 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 	return err;
 }
 
+static void p54u_rx_refill_work(struct work_struct *work)
+{
+	struct p54u_priv *priv = container_of(work, struct p54u_priv,
+					      rx_refill_work);
+
+	p54u_rx_refill(priv->common.hw);
+}
+
 static int p54u_open(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -926,6 +1016,9 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->intf = intf;
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
+	INIT_WORK(&priv->rx_refill_work, p54u_rx_refill_work);
+	spin_lock_init(&priv->rx_refill_lock);
+	INIT_LIST_HEAD(&priv->rx_refill_list);
 
 	usb_get_dev(udev);
 

--Boundary-00=_2h2dJPyreREVa6l--
