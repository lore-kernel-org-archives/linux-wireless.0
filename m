Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:32163 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbZAXVlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 16:41:49 -0500
Received: by nf-out-0910.google.com with SMTP id d3so918023nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 13:41:46 -0800 (PST)
Message-ID: <497B8B18.6090408@gmail.com> (sfid-20090124_224152_698411_E7E43E2C)
Date: Sat, 24 Jan 2009 22:41:44 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH v2] p54usb: rx refill revamp
References: <200901232245.15216.chunkeey@web.de> <200901240215.44226.chunkeey@web.de> <497A967F.2010900@gmail.com> <200901241206.18690.chunkeey@web.de> <497B71E9.6080703@gmail.com> <497B808F.6060009@gmail.com>
In-Reply-To: <497B808F.6060009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina wrote:
> Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Saturday 24 January 2009 05:18:07 Artur Skawina wrote:
>>>> [My version schedules the work for every urb, even the poisoned ones]
>>> well, there's now a hard limit... no change of a endless loop now.
>> The whole point of the poisoning was to prevent resubmission when
>> canceling the urbs -- if you work around that manually, you could just
>> as well kill them, instead of poisoning.
>> I don't understand why want to add extra code to the rx irq just to
>> avoid scheduling a work when downing the i/f, and keep a nasty failure
>> case. The difference in down() performance is not going to be measurable,
>> and even if it was, it wouldn't matter.
> 
> Oh, and we could always do something like
> 
>         if (likely(atomic_read(&urb->reject)==0))
>                 queue_work(priv->common.hw->workqueue, &priv->rx_refill_work);
> 
> which should catch most cases when urbs are either killed or poisoned.

So the full patch vs wireless-testing would look like this:

[haven't merged the urb-cache and list->anchor-conversion changes yet]

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9539ddc..c24fc53 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -80,22 +80,33 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(usb, p54u_table);
 
+/*
+ * Every successfully submitted RX urb goes through this completion
+ * function. Each one must be added to the refill list after being
+ * processed, this includes the failed/cancelled ones (status!=0).
+ * p54u_rx_refill() will take care of resubmitting them later.
+ * Alternatively, an urb can be reanchored and resubmitted, it will
+ * then come back here again, after the I/O is done.
+ */
+
 static void p54u_rx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *) urb->context;
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
@@ -103,19 +114,12 @@ static void p54u_rx_cb(struct urb *urb)
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
@@ -129,14 +133,60 @@ static void p54u_rx_cb(struct urb *urb)
 			WARN_ON(1);
 			urb->transfer_buffer = skb_tail_pointer(skb);
 		}
+resubmit_urb:	/* Now both the urb and the skb are as good as new */
+		usb_anchor_urb(urb, &priv->submitted);
+		if (usb_submit_urb(urb, GFP_ATOMIC) == 0) {
+			skb_queue_tail(&priv->rx_queue, skb);
+			return ;
+		} else {
+			usb_unanchor_urb(urb);
+			dev_kfree_skb_irq(skb);
+		}
+	} else {
+		/*
+		 * This skb has been given away to the mac80211 layer.
+		 * We should put the urb on the refill list, where it
+		 * can be linked to a newly allocated skb later.
+		 * Except, if the workqueue that does the refilling can't
+		 * keep up, we'll try a bit harder and attempt to obtain
+		 * a new skb right here.
+		 */
+		if (skb_queue_len(&priv->rx_queue)<29) {
+			skb = dev_alloc_skb(priv->common.rx_mtu + 32);
+			if (skb) {
+				info = (struct p54u_rx_info *)skb->cb;
+				info->urb = urb;
+				info->dev = dev;
+				/* Update the urb to use the new skb */
+				urb->transfer_buffer = skb_tail_pointer(skb);
+				urb->context = skb;
+				goto resubmit_urb;
+			}
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
+	 * Put the now unused urb into a list and do the refill later on in
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
+	if (atomic_read(&urb->reject)==0 && !priv->common.hw->workqueue) {
+		printk(KERN_WARNING "p54u_rx_cb(): workqueue missing\n");
+		return;
 	}
+
+	if (likely(atomic_read(&urb->reject)==0))
+		queue_work(priv->common.hw->workqueue, &priv->rx_refill_work);
 }
 
 static void p54u_tx_cb(struct urb *urb)
@@ -150,58 +200,129 @@ static void p54u_tx_cb(struct urb *urb)
 
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
-	usb_kill_anchored_urbs(&priv->submitted);
+
+	usb_poison_anchored_urbs(&priv->submitted);
+	/*
+	 * By now every RX urb has either finished or been cancelled;
+	 * the p54u_rx_cb() completion has placed it on the refill
+	 * list; any attempts to resubmit from p54u_rx_refill(),
+	 * which could still be scheduled to run, will fail.
+	 */
+	cancel_work_sync(&priv->rx_refill_work);
+	p54u_free_rx_refill_list(dev);
+	/*
+	 * Unpoison the anchor itself; the old urbs are already gone,
+	 * p54u_rx_cb() has moved them all to the refill list.
+	 * Prevents new urbs from being poisoned when anchored.
+	 */
+	usb_unpoison_anchored_urbs(&priv->submitted);
 }
 
-static int p54u_init_urbs(struct ieee80211_hw *dev)
+static int p54u_rx_refill(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *entry = NULL;
-	struct sk_buff *skb;
-	struct p54u_rx_info *info;
+	struct urb *entry, *tmp;
+	unsigned long flags;
+	unsigned int filled = 0;
 	int ret = 0;
 
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
+		ret=usb_submit_urb(entry, GFP_KERNEL);
 		if (ret) {
-			skb_unlink(skb, &priv->rx_queue);
+			/*
+			 * urb submittion failed.
+			 * free the associated skb and put the urb back into
+			 * the front of the refill list, so we can try our luck
+			 * next time.
+			 */
+
 			usb_unanchor_urb(entry);
-			goto err;
+			kfree_skb(skb);
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			list_add(&entry->urb_list, &priv->rx_refill_list);
+			if (ret==-EPERM)   /* urb has been poisoned */
+				break;	   /* no point in trying to submit the rest */
+		} else {
+			skb_queue_tail(&priv->rx_queue, skb);
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			filled++;
 		}
-		usb_free_urb(entry);
-		entry = NULL;
 	}
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+	return filled ? 0 : -ENOMEM;
+}
 
-	return 0;
+static int p54u_init_urbs(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry;
+	unsigned long flags;
+	int ret = 0;
+	int i;
 
- err:
-	usb_free_urb(entry);
-	kfree_skb(skb);
-	p54u_free_urbs(dev);
+	for (i = 0; i < 32; i++) {
+		entry = usb_alloc_urb(0, GFP_KERNEL);
+		if (!entry) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		spin_lock_irqsave(&priv->rx_refill_lock, flags);
+		list_add_tail(&entry->urb_list, &priv->rx_refill_list);
+		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+	}
+
+	p54u_rx_refill(dev);
+err:
+	if (ret)
+		p54u_free_rx_refill_list(dev);
 	return ret;
 }
 
@@ -880,6 +1001,14 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
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
@@ -928,6 +1057,9 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->intf = intf;
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
+	INIT_WORK(&priv->rx_refill_work, p54u_rx_refill_work);
+	spin_lock_init(&priv->rx_refill_lock);
+	INIT_LIST_HEAD(&priv->rx_refill_list);
 
 	usb_get_dev(udev);
 
@@ -999,6 +1131,8 @@ static void __devexit p54u_disconnect(struct usb_interface *intf)
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
 
