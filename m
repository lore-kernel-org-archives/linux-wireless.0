Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:11394 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZAVWFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 17:05:41 -0500
Received: by ug-out-1314.google.com with SMTP id 39so578303ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 14:05:39 -0800 (PST)
Message-ID: <4978EDB1.502@gmail.com> (sfid-20090122_230547_523978_E69653FA)
Date: Thu, 22 Jan 2009 23:05:37 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <200901221701.59190.chunkeey@web.de> <4978C6B4.80601@gmail.com> <200901222202.48226.chunkeey@web.de>
In-Reply-To: <200901222202.48226.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 22 January 2009 20:19:16 Artur Skawina wrote:
>> This last version seems fine, just one thing: I can't convince myself
>> that not queuing the work after an urb fails with urb->status==true is
>> safe -- what if some temporary error condition causes the rx queue to
>> drain? Nothing will resubmit the urbs.
> well, the usb->status has to be "=! 0" 32 times in a row.
> So either the device, the system, or both have more serious problem and need
> some user attention/reset. However yes a few more unlikely paths wont hurt. ;-) 
> 
>> Wouldn't a usb_poison_anchored_urbs() instead of usb_kill_anchored_urbs()
>> in p54u_free_urbs() prevent p54u_rx_refill from resubmitting, and that early
>> return in the completion could then go? Or did i miss a case where it's
>> needed, other than stop()?
> size of the patch? because then we have to rewrite the p54u_start and
> p54u_stop to go a different path for ifdown/ifup (poison/unpoison) or
> suspend / disconnect (here we probably want kill).
> 
> But if you want to do that, you're welcome your post patches.

How about this? Can you see anything wrong w/ it? Survives a quick test here.

Yes, unpoisoning the urbs would make things much more complicated.
(mostly because usb_anchor_urb() poisons the urb, while usb_unanchor_urb()
 doesn't unpoison, so it would either have to done manually (extra locking
 to get the state of the anchor itself) or the un-/poisoning rules become
 quite complex)

This simple approach frees all urbs on stop() and reallocates them on open().
All urbs go through the completion, and all are moved to the refill list,
even the ones that failed. If they are not supposed to be resubmitted, all
currently in flight ones are killed and poisoned, and when they arrive in 
p54u_rx_refill() the submission will fail.

artur

[patch vs your last one]

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 32534c1..f0191fd 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -150,16 +150,12 @@ stash_urb:
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
 
@@ -195,8 +191,15 @@ static void p54u_free_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
 
+	usb_poison_anchored_urbs(&priv->submitted);
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
@@ -205,6 +208,7 @@ static int p54u_rx_refill(struct ieee80211_hw *dev)
 	struct urb *entry, *tmp;
 	unsigned long flags;
 	unsigned int filled = 0;
+	int ret = 0;
 
 	spin_lock_irqsave(&priv->rx_refill_lock, flags);
 	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
@@ -237,7 +241,8 @@ static int p54u_rx_refill(struct ieee80211_hw *dev)
 		info->dev = dev;
 
 		usb_anchor_urb(entry, &priv->submitted);
-		if (usb_submit_urb(entry, GFP_KERNEL)) {
+		ret=usb_submit_urb(entry, GFP_KERNEL);
+		if (ret) {
 			/*
 			 * urb submittion failed.
 			 * free the associated skb and put the urb back into
@@ -249,6 +254,8 @@ static int p54u_rx_refill(struct ieee80211_hw *dev)
 			kfree_skb(skb);
 			spin_lock_irqsave(&priv->rx_refill_lock, flags);
 			list_add(&entry->urb_list, &priv->rx_refill_list);
+			if (ret==-EPERM)   /* urb has been poisoned */
+				break;	   /* no point in trying to submit the rest */
 		} else {
 			skb_queue_tail(&priv->rx_queue, skb);
 			spin_lock_irqsave(&priv->rx_refill_lock, flags);
@@ -280,9 +287,9 @@ static int p54u_init_urbs(struct ieee80211_hw *dev)
 	}
 
 	p54u_rx_refill(dev);
-
 err:
-	p54u_free_rx_refill_list(dev);
+	if (ret)
+		p54u_free_rx_refill_list(dev);
 	return ret;
 }
 
@@ -979,7 +986,7 @@ static int p54u_open(struct ieee80211_hw *dev)
 		return err;
 	}
 
-	priv->common.open = p54u_rx_refill;
+	priv->common.open = p54u_init_urbs;
 
 	return 0;
 }

