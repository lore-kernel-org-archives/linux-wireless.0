Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58771 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbZAWVpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:45:22 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH v2] p54usb: rx refill revamp
Date: Fri, 23 Jan 2009 22:45:14 +0100
Cc: Artur Skawina <art.08.09@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901232245.15216.chunkeey@web.de> (sfid-20090123_224544_049129_5F6D3B5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a long standing issue in p54usb.

Under high memory pressure, dev_alloc_skb couldn't always allocate a 
replacement skb. In such situations, we had to free the associated urb.
And over the time all urbs were eventually gone altogether and 
obviously the device remained mute from then on.

Thanks go out to Artur Skawina for all the reviews, ideas and code! 
---
Changes:
	- remove workqueue check (now, the workqueue is always there!)
	- added Artur's comments
	- added Artur's ideas (use poison & unpoison, emergency refill etc...)
	- handle urb->status error codes
		So now it depends on the error-code if we resubmit the urb & skb,
		or queue it in rx_refill_list and free it later.

I hope Artur, I could meet all of your demands this time.;-)
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9539ddc..0d57614 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -80,6 +80,20 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(usb, p54u_table);
 
+static void p54u_queue_urb_for_refill(struct p54u_priv *priv, struct urb *urb)
+{
+	unsigned long flags;
+
+	/* reset essential pointers */
+	urb->transfer_buffer = NULL;
+	urb->context = NULL;
+	urb->complete = NULL;
+
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_add_tail(&urb->urb_list, &priv->rx_refill_list);
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+}
+
 static void p54u_rx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *) urb->context;
@@ -89,54 +103,102 @@ static void p54u_rx_cb(struct urb *urb)
 
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
+			p54u_queue_urb_for_refill(priv, urb);
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
+		p54u_queue_urb_for_refill(priv, urb);
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
+		p54u_queue_urb_for_refill(priv, urb);
+	} else
+		skb_queue_tail(&priv->rx_queue, skb);
+
+	return ;
 }
 
 static void p54u_tx_cb(struct urb *urb)
@@ -150,59 +212,165 @@ static void p54u_tx_cb(struct urb *urb)
 
 static void p54u_tx_dummy_cb(struct urb *urb) { }
 
-static void p54u_free_urbs(struct ieee80211_hw *dev)
+static void p54u_free_rx_refill_list(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	usb_kill_anchored_urbs(&priv->submitted);
+	struct urb *entry, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
+		list_del(&entry->urb_list);
+		usb_free_urb(entry);
+	}
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
 }
 
-static int p54u_init_urbs(struct ieee80211_hw *dev)
+static void p54u_unpoison_rx_refill_list(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *entry = NULL;
-	struct sk_buff *skb;
-	struct p54u_rx_info *info;
-	int ret = 0;
+	struct urb *entry;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_refill_lock, flags);
+	list_for_each_entry(entry, &priv->rx_refill_list, urb_list) {
+		usb_unpoison_urb(entry);
+	}
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+}
+
+static void p54u_cancel_urbs(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+
+	usb_poison_anchored_urbs(&priv->submitted);
 
-	while (skb_queue_len(&priv->rx_queue) < 32) {
+	/*
+	 * By now every RX URB has either finished or been canceled;
+	 * the p54u_rx_cb() completion has placed it on the refill
+	 * list; any attempts to resubmit from p54u_rx_refill(),
+	 * which could still be scheduled to run, will fail.
+	 */
+	cancel_work_sync(&priv->rx_refill_work);
+
+	/*
+	 * Unpoison all URBs in the rx_refill_list, so they can be reused.
+	 */
+	p54u_unpoison_rx_refill_list(dev);
+
+	/*
+	 * Unpoison the anchor itself; the old URBs are already gone,
+	 * p54u_rx_cb() has moved them all to the refill list.
+	 * Prevents new URBs from being poisoned when anchored.
+	 */
+	usb_unpoison_anchored_urbs(&priv->submitted);
+}
+
+static int p54u_rx_refill(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry, *tmp;
+	unsigned long flags;
+	unsigned int refilled_urbs = 0;
+	int err = -EINVAL;
+
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
+			 * In order to prevent a loop, we put the URB
+			 * back at the _front_ of the list, so we can
+			 * march on, in out-of-memory situations.
+			 */
+
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			list_add(&entry->urb_list, &priv->rx_refill_list);
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
 			usb_unanchor_urb(entry);
-			goto err;
+			kfree_skb(skb);
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			list_add(&entry->urb_list, &priv->rx_refill_list);
+		} else {
+			skb_queue_tail(&priv->rx_queue, skb);
+			refilled_urbs++;
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
 		}
-		usb_free_urb(entry);
-		entry = NULL;
+	}
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
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
+static int p54u_init_urbs(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *entry;
+	unsigned long flags;
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
+		spin_lock_irqsave(&priv->rx_refill_lock, flags);
+		list_add_tail(&entry->urb_list, &priv->rx_refill_list);
+		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+	}
+
+	if (err)
+		p54u_free_rx_refill_list(dev);
+	return err;
 }
 
 static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -880,28 +1048,12 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
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
+	struct p54u_priv *priv = container_of(work, struct p54u_priv,
+					      rx_refill_work);
 
-	priv->common.open = p54u_init_urbs;
-
-	return 0;
-}
-
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
@@ -928,6 +1080,9 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->intf = intf;
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
+	INIT_WORK(&priv->rx_refill_work, p54u_rx_refill_work);
+	spin_lock_init(&priv->rx_refill_lock);
+	INIT_LIST_HEAD(&priv->rx_refill_list);
 
 	usb_get_dev(udev);
 
@@ -949,8 +1104,7 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 			recognized_pipes++;
 		}
 	}
-	priv->common.open = p54u_open;
-	priv->common.stop = p54u_stop;
+
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
 		priv->hw_type = P54U_3887;
 		err = p54u_upload_firmware_3887(dev);
@@ -970,12 +1124,19 @@ static int __devinit p54u_probe(struct usb_interface *intf,
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
@@ -999,6 +1160,8 @@ static void __devexit p54u_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	p54u_free_rx_refill_list(dev);
+
 	ieee80211_unregister_hw(dev);
 
 	priv = dev->priv;
diff --git a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
index 8bc5898..986505c 100644
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -132,8 +132,11 @@ struct p54u_priv {
 		P54U_3887
 	} hw_type;
 
-	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	spinlock_t rx_refill_lock;
+	struct list_head rx_refill_list;
+	struct work_struct rx_refill_work;
+
 	struct usb_anchor submitted;
 };
 
