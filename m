Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:46205 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZAXLGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 06:06:22 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][PATCH v2] p54usb: rx refill revamp
Date: Sat, 24 Jan 2009 12:06:18 +0100
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200901232245.15216.chunkeey@web.de> <200901240215.44226.chunkeey@web.de> <497A967F.2010900@gmail.com>
In-Reply-To: <497A967F.2010900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901241206.18690.chunkeey@web.de> (sfid-20090124_120631_047694_0429E3F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 24 January 2009 05:18:07 Artur Skawina wrote:
> Christian Lamparter wrote:
> > 1) urb_poison_anchored_urbs gets called
> > 	1) poison anchor structure
> > 	2) poison & killing every single urb
> > 2) the usb_hcd_giveback_urb is called
> > 	1) >>unanchores<< the urb form anchor_list
> > 	2) calles urb->complete (urb)
> > 		3) p54u_rx_cb -here- but nothing interesting there
> > 3) ... [time goes by]
> > 4) urb_unpoison_anchored_urb is called
> > 	1) unpoison the anchor structure
> > 	2) tries to unpoison the anchored urbs... But there's not a single one in the anchor_list,
> > 	     since step 2.1 (usb_hcd_giveback_urb) killed them off. 
> 
> I assume that's just how it's supposed to be. You could always anchor
> the urbs to another anchor in the completion_. Or free any buffers and
> drop the last ref before leaving the completion. (in fact, the former
> is basically what you're doing, just using a list instead)
true! In fact --- behold the clean up patch which uses another anchor instead of the list ---

> >> I'm curious why you keep the urbs around in the stopped state?
> > well, in most cases the "stopped state" is very short and most wlan-adapters are always connected.
> > So, why throw them away when we need them again in a few seconds?
> > (usually wpa_supplicant/NM has the bad habit of doing a interface up/down dance... sometimes)
> 
> ok. (i don't know about most wlans being always up, but it seems a
> reasonable compromise. still, that's 100k+ wasted ram in the down
> state.)

??? We don't waste 100k+.
We recycle the skbs, so the only thing left is 32 urb structures.

> > well, we don't schedule the workqueue if we canceling the urbs now,
> > ( that's what the urb->status switch is supposed to do/( or in this context )stop...)
> 
> yep, noticed that later, see below.
> 
> > Another maybe related thing: ( a bit above)
> > 	 * In order to prevent a loop, we put the URB
> > 	 * back at the _front_ of the list, so we can
> > 	 * march on, in out-of-memory situations.
> > 
> > I guess this could be true for -EPERM as well?
> > As far as I know list_for_each_entry_* iterates until it hits (head)
> > and since we insert the -EPERM "urb" with list_add (_head),
> > we will never do more than 32 iterations?! (since list_add put the elements in (head)->next )
> > 
> > But if we cancel on -EPERM, we should bail out on -ENODEV
> > (or -ECONNRESET, what ever says that the device is unavailable ) as well...
> 
> I'm not sure I follow.. Ah, the only reason I bailed out on -EPERM
> is that usb_submit_urb() will return -EPERM for poisoned urbs and
> i didn't want to retry this call for every other urb as they would
> all fail. Each try involves a useless skb alloc and free...
> [My version schedules the work for every urb, even the poisoned ones]
well, there's now a hard limit... no change of a endless loop now.
 
> >>> +	if (skb_queue_len(&priv->rx_queue) != 32) {
> >>> +		dev_err(&priv->udev->dev, "Not enough useable transfer buffers "
> >>> +			"available to initialize the device.");
> >>> +		return -ENOMEM;
> >> Why 32 urbs?
> > Well, that's the firmware/hardware limit for all prism54 chips
> > (doesn't matter if usb/pci fullmac/softmac etc...)
> > all have 32 rx and tx slots in the "normal priority" queue/ring-buffer.
> > 
> >> And why should open() fail if, say, only 28 got successfully allocated?
> >> Shouldn't the device function nonetheless?
> > Well, what's the point of supporting a system that has problems finding 32 pages with GFP_KERNEL?
> > you know "one allocation on device init isn't worth avoiding."   :-p
> 
> ok. that's not something this patch changes anyway ;)
> 
> 
> I looked at your v2 briefly yesterday and even wrote a reply, but
> didn't send it. I really liked your v1 much better, the new version
> makes the code much harder to follow, and still can stall the device
> after a few consecutive urb completion or submission (this is new)
> errors happen. Uhm, i probably should shut up now ;)

be prepared to write the reply again ;-)

Yeah, it's always easier to follow your own code, however its sometimes
harder to find bugs, because you assumed you did everything right in the first place...
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9539ddc..64da6cb 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -89,54 +89,102 @@ static void p54u_rx_cb(struct urb *urb)
 
 	skb_unlink(skb, &priv->rx_queue);
 
-	if (unlikely(urb->status)) {
-		dev_kfree_skb_irq(skb);
-		return;
-	}
-
-	skb_put(skb, urb->actual_length);
+	switch (urb->status) {
+	case 0:
+		/*
+		 * The device sent us a packet for processing.
+		 */
+		skb_put(skb, urb->actual_length);
+
+		/*
+		 * remove firmware/device specific headers in
+		 * front of the frame.
+		 */
+		if (priv->hw_type == P54U_NET2280)
+			skb_pull(skb, priv->common.tx_hdr_len);
+		if (priv->common.fw_interface == FW_LM87) {
+			skb_pull(skb, 4);
+			skb_put(skb, 4);
+		}
 
-	if (priv->hw_type == P54U_NET2280)
-		skb_pull(skb, priv->common.tx_hdr_len);
-	if (priv->common.fw_interface == FW_LM87) {
-		skb_pull(skb, 4);
-		skb_put(skb, 4);
-	}
+		if (p54_rx(dev, skb)) {
+			/*
+			 * This skb has been accepted by library and now
+			 * belongs to the mac80211 layer.
+			 * We should put the URB on the refill list, where it
+			 * can be linked to a newly allocated skb later.
+			 * Except, if the workqueue that does the refilling
+			 * can't keep up, we'll try a bit harder and attempt
+			 * to obtain a new skb right here.
+			 */
+
+			if (skb_queue_len(&priv->rx_queue) < 4) {
+				skb = dev_alloc_skb(priv->common.rx_mtu + 32);
+				if (skb) {
+					info = (struct p54u_rx_info *) skb->cb;
+					info->urb = urb;
+					info->dev = dev;
+					/* Update the urb to use the new skb */
+					urb->context = skb;
+					break;
+				}
+			}
 
-	if (p54_rx(dev, skb)) {
-		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
-		if (unlikely(!skb)) {
-			/* TODO check rx queue length and refill *somewhere* */
-			return;
+			usb_anchor_urb(urb, &priv->urb_pool);
+			queue_work(priv->common.hw->workqueue,
+				   &priv->rx_refill_work);
+			return ;
 		}
 
-		info = (struct p54u_rx_info *) skb->cb;
-		info->urb = urb;
-		info->dev = dev;
-		urb->transfer_buffer = skb_tail_pointer(skb);
-		urb->context = skb;
-	} else {
+		/* Reverse all modifications, it must look like new. */
 		if (priv->hw_type == P54U_NET2280)
 			skb_push(skb, priv->common.tx_hdr_len);
 		if (priv->common.fw_interface == FW_LM87) {
 			skb_push(skb, 4);
 			skb_put(skb, 4);
 		}
-		skb_reset_tail_pointer(skb);
-		skb_trim(skb, 0);
-		if (urb->transfer_buffer != skb_tail_pointer(skb)) {
-			/* this should not happen */
-			WARN_ON(1);
-			urb->transfer_buffer = skb_tail_pointer(skb);
-		}
+
+		break;
+
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ENODEV:
+	case -ESHUTDOWN:
+		/*
+		 * The device has been stopped or disconnected.
+		 * Free the skb and put the URBs into the refill_list.
+		 */
+
+		usb_anchor_urb(urb, &priv->urb_pool);
+		dev_kfree_skb_irq(skb);
+		return;
+
+	default:
+		/*
+		 * USB error
+		 * This frame is lost, but we can resubmit URB + skb and
+		 * wait for a successful retry.
+		 */
+		break;
 	}
-	skb_queue_tail(&priv->rx_queue, skb);
+
+	/*
+	 * Reuse the URB and its associated skb.
+	 * Reset all data pointers into their original state and resubmit it.
+	 */
+	skb_reset_tail_pointer(skb);
+	skb_trim(skb, 0);
+	urb->transfer_buffer = skb_tail_pointer(skb);
+
 	usb_anchor_urb(urb, &priv->submitted);
 	if (usb_submit_urb(urb, GFP_ATOMIC)) {
-		skb_unlink(skb, &priv->rx_queue);
 		usb_unanchor_urb(urb);
 		dev_kfree_skb_irq(skb);
-	}
+		usb_anchor_urb(urb, &priv->urb_pool);
+	} else
+		skb_queue_tail(&priv->rx_queue, skb);
+
+	return ;
 }
 
 static void p54u_tx_cb(struct urb *urb)
@@ -150,59 +198,146 @@ static void p54u_tx_cb(struct urb *urb)
 
 static void p54u_tx_dummy_cb(struct urb *urb) { }
 
-static void p54u_free_urbs(struct ieee80211_hw *dev)
+static void p54u_cancel_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	usb_kill_anchored_urbs(&priv->submitted);
+
+	usb_poison_anchored_urbs(&priv->submitted);
+
+	/*
+	 * By now every RX URB has either finished or been canceled;
+	 * the p54u_rx_cb() completion has placed it on the refill
+	 * list; any attempts to resubmit from p54u_rx_refill(),
+	 * which could still be scheduled to run, will fail.
+	 */
+	cancel_work_sync(&priv->rx_refill_work);
+
+	/*
+	 * Unpoison the anchor itself; the old URBs are already gone,
+	 * p54u_rx_cb() has moved them all to the refill list.
+	 * Prevents new URBs from being poisoned when anchored.
+	 */
+	usb_unpoison_anchored_urbs(&priv->submitted);
+
+	/*
+	 * Unpoison all unused URBs in the pool, in case we want to reuse them.
+	 */
+	usb_unpoison_anchored_urbs(&priv->urb_pool);
 }
 
-static int p54u_init_urbs(struct ieee80211_hw *dev)
+static int p54u_rx_refill(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *entry = NULL;
-	struct sk_buff *skb;
-	struct p54u_rx_info *info;
-	int ret = 0;
+	struct urb *entry;
+	unsigned int refilled_urbs = 0, cnt = 0;
+	int err = -EINVAL;
+
+	while (cnt++ != 32 && (entry = usb_get_from_anchor(&priv->urb_pool))) {
+		struct p54u_rx_info *info;
+		struct sk_buff *skb;
 
-	while (skb_queue_len(&priv->rx_queue) < 32) {
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
+			 * In order to prevent a loop, we put the URB
+			 * back at the _front_ of the list, so we can
+			 * march on, in out-of-memory situations.
+			 */
+
+			usb_anchor_urb(entry, &priv->urb_pool);
+			usb_free_urb(entry);
+			err = -ENOMEM;
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
+		err = usb_submit_urb(entry, GFP_KERNEL);
+		if (err) {
+			/*
+			 * URB submission failed.
+			 * Free the associated skb and put the URB back into
+			 * the front of the refill list, so we can try our luck
+			 * next time.
+			 */
+
+			dev_err(&priv->udev->dev, "failed to resubmit %p\n",
+				entry);
+
 			usb_unanchor_urb(entry);
-			goto err;
+			kfree_skb(skb);
+			usb_anchor_urb(entry, &priv->urb_pool);
+		} else {
+			skb_queue_tail(&priv->rx_queue, skb);
+			refilled_urbs++;
 		}
 		usb_free_urb(entry);
-		entry = NULL;
+	}
+
+	return refilled_urbs ? 0 : err;
+}
+
+static int p54u_open(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	int err;
+
+	err = p54u_rx_refill(dev);
+	if (err)
+		return err;
+
+	if (skb_queue_len(&priv->rx_queue) != 32) {
+		dev_err(&priv->udev->dev, "Not enough useable transfer buffers "
+			"available to initialize the device.");
+		p54u_cancel_urbs(dev);
+		return -ENOMEM;
 	}
 
 	return 0;
+}
 
- err:
-	usb_free_urb(entry);
-	kfree_skb(skb);
-	p54u_free_urbs(dev);
-	return ret;
+static void p54u_drain_urb_pool(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry;
+
+	while ((entry = usb_get_from_anchor(&priv->urb_pool))) {
+		usb_free_urb(entry);
+		usb_free_urb(entry);
+	}
+}
+
+
+static int p54u_init_urbs(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry;
+	int err = 0;
+	int i;
+
+	for (i = 0; i < 32; i++) {
+		entry = usb_alloc_urb(0, GFP_KERNEL);
+		if (!entry) {
+			err = -ENOMEM;
+			break;
+		}
+
+		usb_anchor_urb(entry, &priv->urb_pool);
+	}
+
+	if (err)
+		p54u_drain_urb_pool(dev);
+
+	return err;
 }
 
 static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -880,28 +1015,12 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 	return err;
 }
 
-static int p54u_open(struct ieee80211_hw *dev)
+static void p54u_rx_refill_work(struct work_struct *work)
 {
-	struct p54u_priv *priv = dev->priv;
-	int err;
-
-	err = p54u_init_urbs(dev);
-	if (err) {
-		return err;
-	}
-
-	priv->common.open = p54u_init_urbs;
-
-	return 0;
-}
+	struct p54u_priv *priv = container_of(work, struct p54u_priv,
+					      rx_refill_work);
 
-static void p54u_stop(struct ieee80211_hw *dev)
-{
-	/* TODO: figure out how to reliably stop the 3887 and net2280 so
-	   the hardware is still usable next time we want to start it.
-	   until then, we just stop listening to the hardware.. */
-	p54u_free_urbs(dev);
-	return;
+	p54u_rx_refill(priv->common.hw);
 }
 
 static int __devinit p54u_probe(struct usb_interface *intf,
@@ -928,6 +1047,8 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->intf = intf;
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
+	init_usb_anchor(&priv->urb_pool);
+	INIT_WORK(&priv->rx_refill_work, p54u_rx_refill_work);
 
 	usb_get_dev(udev);
 
@@ -949,8 +1070,7 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 			recognized_pipes++;
 		}
 	}
-	priv->common.open = p54u_open;
-	priv->common.stop = p54u_stop;
+
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
 		priv->hw_type = P54U_3887;
 		err = p54u_upload_firmware_3887(dev);
@@ -970,12 +1090,19 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	if (err)
 		goto err_free_dev;
 
-	p54u_open(dev);
+	err = p54u_init_urbs(dev);
+	if (err)
+		goto err_free_dev;
+	err = p54u_open(dev);
+	if (err)
+		goto err_free_dev;
 	err = p54_read_eeprom(dev);
-	p54u_stop(dev);
+	p54u_cancel_urbs(dev);
 	if (err)
 		goto err_free_dev;
 
+	priv->common.open = p54u_open;
+	priv->common.stop = p54u_cancel_urbs;
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		dev_err(&udev->dev, "(p54usb) Cannot register netdevice\n");
@@ -999,9 +1126,12 @@ static void __devexit p54u_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	priv = dev->priv;
+
+	p54u_drain_urb_pool(dev);
+
 	ieee80211_unregister_hw(dev);
 
-	priv = dev->priv;
 	usb_put_dev(interface_to_usbdev(intf));
 	p54_free_common(dev);
 	ieee80211_free_hw(dev);
diff --git a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
index 8bc5898..4a5d8b2 100644
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -132,9 +132,10 @@ struct p54u_priv {
 		P54U_3887
 	} hw_type;
 
-	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	struct work_struct rx_refill_work;
 	struct usb_anchor submitted;
+	struct usb_anchor urb_pool;
 };
 
 #endif /* P54USB_H */
