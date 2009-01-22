Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50332 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbZAVPAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:00:21 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Thu, 22 Jan 2009 16:00:14 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <200901212156.27152.chunkeey@web.de> <4977AE28.2080109@gmail.com>
In-Reply-To: <4977AE28.2080109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901221600.14130.chunkeey@web.de> (sfid-20090122_160027_671468_1548064A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 January 2009 00:22:16 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Wednesday 21 January 2009 20:32:43 Artur Skawina wrote:
> >> Not allocating-on-receive at all worries me a bit. Will test under load. (i already
> >> had instrumented the cb, but the crashes prevented any useful testing).
> > 
> > no problem... I'll wait for your data before removing the RFC/RFT tags
> 
> That part is probably fine, and i'm just being paranoid. Ignore me.
so, green light? (I'll wait till friday / saturday anyway)

> >>> The net2280 tx path does at least three allocs, one tiny never-changing buffer
> >>>> and two urbs, i'd like to get rid of all of them. 
> >>> why? AFAIK kernel memory alloc already provides a good amount of (small) buffer caches,
> >>> so why should stockpile them only for ourself?
> >>>
> >>> You know, 802.11b/g isn't exactly fast by any standards - heck even a 15 year old ethernet NIC
> >>> is easily 5-6 times faster. So, "optimizations" are a bit useless when we have these bottlenecks. 
> >> no, i don't expect it do much difference performance-wise; i don't want it to
> >> fail under memory pressure. preallocating ~three small buffers isn't that bad ;)
> > 
> > well, the memory pressure is not sooo bad in a (prioritized) kernel thread.
> > After all, the kernel reserves extra space for the kernel only and the OOM killer will become active as well...
> > So unless you got a machine with 8mb (afaik that's the lowest limit linux boots now a days and is
> > still useable!?) and a no/slowwwww swap, you'll have a really hard time to get any shortage of rx urbs at all.
> 
> TX, not RX. 
> I'll try stealing^Hborrowing the urbs from the refill queue (fixing up
> the rx code to allow for this first, of course).

Ah, well you have to increase the number of urbs in the "rx_list" to a total of 64 (for LM87) / 96 (for usb v1 and the old isl3887 fws)
And then add a check into the p54u_rx_refill so that it will stop as soon as there're 32 urb (with a skb) in the rx_queue. 

> >>>> The constant buffer is easy - we can just kmalloc a cacheline-sized chunk on init, and (re)use that.
> >>> only a single constant buffer? are you sure that's a good idea, on dual cores?
> >>> (Or is this a misunderstanding and you plan to have up to 32/64 constant buffers?)
> >> why not? the content never changes, and will only be read by the usb host controller;
> >> the cpu shouldn't even need to see it after the initial setup.
> > Ok, I guess we're talking about different things here.
> > Please, show me a patch, before it gets too confusing ;-)
> 
> ok, I was just saying that that all this:
> 
> >         reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
> >         if (!reg) {
> >                 printk(KERN_INFO "tx_net2280 kmalloc(reg), txqlen = %d\n",
> >                           skb_queue_len(&priv->common.tx_queue) );
> >                 return;
> >         }
> > [...]
> >         reg->port = cpu_to_le16(NET2280_DEV_U32);
> >         reg->addr = cpu_to_le32(P54U_DEV_BASE);
> >         reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
> 
> does not need to happen for every single tx-ed frame.
Ah, yes that's true. what do you say about this...
Instead of using kmalloc in the init procedure, we let gcc already do it.
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9b78fee..247376f 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -376,47 +376,35 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	const static struct net2280_reg_write reg = {
+		.port = cpu_to_le16(NET2280_DEV_U32),
+		.addr = cpu_to_le32(P54U_DEV_BASE),
+		.val = cpu_to_le32(ISL38XX_DEV_INT_DATA),
+	};
+
 	struct p54u_priv *priv = dev->priv;
 	struct urb *int_urb, *data_urb;
 	struct net2280_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
-	struct net2280_reg_write *reg;
 	int err = 0;
 
-	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
-	if (!reg)
-		return;
-
 	int_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!int_urb) {
-		kfree(reg);
+	if (!int_urb)
 		return;
-	}
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!data_urb) {
-		kfree(reg);
 		usb_free_urb(int_urb);
 		return;
 	}
 
-	reg->port = cpu_to_le16(NET2280_DEV_U32);
-	reg->addr = cpu_to_le32(P54U_DEV_BASE);
-	reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
-
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->len = cpu_to_le16(skb->len);
 	hdr->device_addr = ((struct p54_hdr *) skb->data)->req_id;
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
-		p54u_tx_dummy_cb, dev);
-
-	/*
-	 * This flag triggers a code path in the USB subsystem that will
-	 * free what's inside the transfer_buffer after the callback routine
-	 * has completed.
-	 */
-	int_urb->transfer_flags |= URB_FREE_BUFFER | URB_ZERO_PACKET;
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV),
+			  (void *) &reg, sizeof(reg), p54u_tx_dummy_cb, dev);
+	int_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 
---

> 
> >>>>> +		if (usb_submit_urb(entry, GFP_ATOMIC)) {
> >>>> GFP_KERNEL? [would need dropping rx_queue.lock earlier and retaking in the
> >>>> (hopefully rare) error path]
> >>> why not... I don't remember the real reason why I did this complicated lock, probably
> >> You were already doing this for the skb allocation anyway ;)
> > do you mean the old "init_urbs"? 
> 
> I meant that you were already dropping a spinlock around one allocation, so it
> seemed odd to not to do that for the other call.
> 
> 
> > Well the bits I've still in mind about the "complicated lock". Was something about
> > a theroeticall race between p54u_rx_cb, the workqueue and free_urbs.
> > 
> > but of course, I've never seen a oops because of it.
> >>> A updated patch is attached (as file)
> >> Will test.
> >> Are the free_urb/get_urb calls necessary? IOW why drop the reference
> >> when preparing the urb, only to grab it again in the completion?
> > 
> > Oh,  I'm not arguing with Alan Stern about it:.
> > http://lkml.org/lkml/2008/12/6/166
> 
> 0) urb is allocated, refcount==1  # and placed on the refill list; p54u_init_urbs()
> 1) p54u_rx_refill()
> 2) urb is anchored   refcount==2  # p54u_rx_refill
> 3) submit_urb()      refcount==3  # in drivers/usb/core/hcd.c:usb_hcd_submit_urb
> 4) free_urb()        refcount==2
> 5) ... usb transfer happens ... refcount==2
> 6) urb is unanchored refcount==1  # in drivers/usb/core/hcd.c:usb_hcd_giveback_urb()
> 7) p54u_rx_cb()                   # completion is called
> 8) usb_get_urb(urb)  refcount==2  # unconditionally called in p54u_rx_cb()
> 9) p54u_rx_cb() returns
> 10) usb_put_urb()    refcount==1  # in drivers/usb/core/hcd.c:usb_hcd_giveback_urb()
> 11) urb sits on the refill list
> 12) goto 1.
> 
> IOW step 4 causes the refcount to temporarily drop to 1, but as you
> never want the urb freed in the completion, step 8 grabs another reference,
> and the refcount can never become 0.
> (for the skb-reuse case, you anchor and resubmit in step 7 (rc==3),
> then return from completion (rc==2) and restart at step 5.)
> 
> Unless i missed something (i'm only looking at the patch).
> So if you omit steps 4 and 8 nothing changes, except that the refcount 
> increases by one, in steps 5..7. 
> The urbs are freed by p54u_free_rx_refill_list(), which drops the last ref;
> (it would need to get them all though, IOW would have to call
> usb_kill_anchored_urbs() _before_ p54u_free_rx_refill_list(). )
> 
> 
> Oh, and I just realized urbs are getting lost in the 'unlikely(urb->status)'
> case, both before your patch, and after.
> A simple fix, with your new code, would be to place them on the refill list,
> from where they will be eventually resubmitted.

I hope I addressed all concerns this time...
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index bf264b1..8b8dbc0 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -86,16 +86,18 @@ static void p54u_rx_cb(struct urb *urb)
 	struct p54u_rx_info *info = (struct p54u_rx_info *)skb->cb;
 	struct ieee80211_hw *dev = info->dev;
 	struct p54u_priv *priv = dev->priv;
+	unsigned long flags;
 
 	skb_unlink(skb, &priv->rx_queue);
 
 	if (unlikely(urb->status)) {
 		dev_kfree_skb_irq(skb);
-		return;
+		goto stash_urb;
 	}
 
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
@@ -129,14 +124,46 @@ static void p54u_rx_cb(struct urb *urb)
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
+stash_urb:
+	urb->transfer_buffer = NULL;
+	urb->context = NULL;
+
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_add_tail(&urb->urb_list, &priv->rx_refill_list);
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+
+	if (unlikely(urb->status)) {
+		return;
+	}
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
@@ -150,58 +177,112 @@ static void p54u_tx_cb(struct urb *urb)
 
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
+	unsigned int filled = 0;
+
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
+		struct p54u_rx_info *info;
+		struct sk_buff *skb;
 
-	while (skb_queue_len(&priv->rx_queue) < 32) {
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
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			filled++;
+		}
+	}
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+	return filled ? 0 : -ENOMEM;
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
 
@@ -878,6 +959,14 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
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
@@ -888,7 +977,7 @@ static int p54u_open(struct ieee80211_hw *dev)
 		return err;
 	}
 
-	priv->common.open = p54u_init_urbs;
+	priv->common.open = p54u_rx_refill;
 
 	return 0;
 }
@@ -926,6 +1015,9 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->intf = intf;
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
+	INIT_WORK(&priv->rx_refill_work, p54u_rx_refill_work);
+	spin_lock_init(&priv->rx_refill_lock);
+	INIT_LIST_HEAD(&priv->rx_refill_list);
 
 	usb_get_dev(udev);
 
@@ -997,6 +1089,8 @@ static void __devexit p54u_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	p54u_free_rx_refill_list(dev);
+
 	ieee80211_unregister_hw(dev);
 
 	priv = dev->priv;
diff --git a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
index 8bc5898..04c7258 100644
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -134,6 +134,10 @@ struct p54u_priv {
 
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	spinlock_t rx_refill_lock;
+	struct list_head rx_refill_list;
+	struct work_struct rx_refill_work;
+
 	struct usb_anchor submitted;
 };
 
