Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:4000 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZAWBLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 20:11:41 -0500
Received: by ey-out-2122.google.com with SMTP id 22so900690eye.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 17:11:39 -0800 (PST)
Message-ID: <49791949.2010507@gmail.com> (sfid-20090123_021146_967928_B981C085)
Date: Fri, 23 Jan 2009 02:11:37 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <200901221701.59190.chunkeey@web.de> <4978C6B4.80601@gmail.com> <200901222202.48226.chunkeey@web.de> <4978EDB1.502@gmail.com>
In-Reply-To: <4978EDB1.502@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> that not queuing the work after an urb fails with urb->status==true is
>>> safe -- what if some temporary error condition causes the rx queue to
>>> drain? Nothing will resubmit the urbs.

Here's an updated version, hopefully the extra commentary makes it
a bit more obvious. I added the allocate-in-irq fallback too.
Tested, including the fallback path, works.

The !priv->common.hw->workqueue path only triggers when freeing the urbs
after reading the eeprom (ie while killing/poisoning the urbs), hence it is
completely harmless and i would replace it w/ just:

	if (priv->common.hw->workqueue)
		queue_work(priv->common.hw->workqueue, &priv->rx_refill_work);

Other than that, patch seems ready.

Thanks,
artur


commit c93ede1be61a0db0a904424738afe3b75425a782
Author: Artur Skawina <art.08.09@gmail.com>
Date:   Thu Jan 22 21:01:32 2009 +0100

    Signed-off-by: Artur Skawina <art.08.09@gmail.com>

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 32534c1..872ace1 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -80,6 +80,15 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(usb, p54u_table);
 
+/*
+ * Every successfully submitted RX urb goes through this completion
+ * function. Each urb must be added to the refill list after being
+ * processed, this includes the failed/canceled ones (status!=0).
+ * p54u_rx_refill() will take care of resubmitting them later.
+ * Alternatively, an urb can be reanchored and resubmitted, it will
+ * then come back here again, after the I/O is done.
+ */
+
 static void p54u_rx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *) urb->context;
@@ -124,7 +133,7 @@ static void p54u_rx_cb(struct urb *urb)
 			WARN_ON(1);
 			urb->transfer_buffer = skb_tail_pointer(skb);
 		}
-
+resubmit_urb:	/* Now both the urb and the skb are as good as new */
 		usb_anchor_urb(urb, &priv->submitted);
 		if (usb_submit_urb(urb, GFP_ATOMIC) == 0) {
 			skb_queue_tail(&priv->rx_queue, skb);
@@ -133,11 +142,32 @@ static void p54u_rx_cb(struct urb *urb)
 			usb_unanchor_urb(urb);
 			dev_kfree_skb_irq(skb);
 		}
+	} else {
+		/*
+		 * This skb has been given away to the mac80211 layer.
+		 * We should put the urb on the refill list, where it
+		 * can be linked to a newly allocated skb later.
+		 * Except, if the workqueue that does the refilling can't
+		 * keep up, we'll try a bit harder and attempt to obtain
+		 * a new skb right here.
+		 */
+		if (skb_queue_len(&priv->rx_queue)<4) {
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
 
 	/*
 	 * This skb CANNOT be reused.
-	 * Put the now unused urb into a list and do the refilled later on in
+	 * Put the now unused urb into a list and do the refill later on in
 	 * the less critical workqueue thread.
 	 * This eases the memory pressure and prevents latency spikes.
 	 */
@@ -150,16 +180,12 @@ stash_urb:
 	list_add_tail(&urb->urb_list, &priv->rx_refill_list);
 	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
 
-	if (unlikely(urb->status)) {
-		return;
-	}
-
 	if (unlikely(!priv->common.hw->workqueue)) {
 		/*
 		 * Huh? mac80211 isn't fully initialized yet?
 		 * Please check your system, something bad is going on.
 		 */
-		WARN_ON(1);
+		printk(KERN_WARNING "p54u_rx_cb(): workqueue missing\n");
 		return;
 	}
 
@@ -195,8 +221,21 @@ static void p54u_free_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
 
+	usb_poison_anchored_urbs(&priv->submitted);
+	/*
+	 * By now every RX urb has either finished or been cancelled;
+	 * the p54u_rx_cb() completion has placed it on the refill
+	 * list; any attempts to resubmit from p54u_rx_refill(),
+	 * which could still be scheduled to run, will fail.
+	 */
 	cancel_work_sync(&priv->rx_refill_work);
-	usb_kill_anchored_urbs(&priv->submitted);
+	p54u_free_rx_refill_list(dev);
+	/*
+	 * Unpoison the anchor itself; the old urbs are already gone,
+	 * p54u_rx_cb() has moved them all to the refill list.
+	 * Prevents new urbs from being poisoned when anchored.
+	 */
+	usb_unpoison_anchored_urbs(&priv->submitted);
 }
 
 static int p54u_rx_refill(struct ieee80211_hw *dev)
@@ -205,6 +244,7 @@ static int p54u_rx_refill(struct ieee80211_hw *dev)
 	struct urb *entry, *tmp;
 	unsigned long flags;
 	unsigned int filled = 0;
+	int ret = 0;
 
 	spin_lock_irqsave(&priv->rx_refill_lock, flags);
 	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
@@ -237,7 +277,8 @@ static int p54u_rx_refill(struct ieee80211_hw *dev)
 		info->dev = dev;
 
 		usb_anchor_urb(entry, &priv->submitted);
-		if (usb_submit_urb(entry, GFP_KERNEL)) {
+		ret=usb_submit_urb(entry, GFP_KERNEL);
+		if (ret) {
 			/*
 			 * urb submittion failed.
 			 * free the associated skb and put the urb back into
@@ -249,6 +290,8 @@ static int p54u_rx_refill(struct ieee80211_hw *dev)
 			kfree_skb(skb);
 			spin_lock_irqsave(&priv->rx_refill_lock, flags);
 			list_add(&entry->urb_list, &priv->rx_refill_list);
+			if (ret==-EPERM)   /* urb has been poisoned */
+				break;	   /* no point in trying to submit the rest */
 		} else {
 			skb_queue_tail(&priv->rx_queue, skb);
 			spin_lock_irqsave(&priv->rx_refill_lock, flags);
@@ -280,9 +323,9 @@ static int p54u_init_urbs(struct ieee80211_hw *dev)
 	}
 
 	p54u_rx_refill(dev);
-
 err:
-	p54u_free_rx_refill_list(dev);
+	if (ret)
+		p54u_free_rx_refill_list(dev);
 	return ret;
 }
 
@@ -979,7 +1022,7 @@ static int p54u_open(struct ieee80211_hw *dev)
 		return err;
 	}
 
-	priv->common.open = p54u_rx_refill;
+	priv->common.open = p54u_init_urbs;
 
 	return 0;
 }
