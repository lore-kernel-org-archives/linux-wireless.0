Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:59959 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbZAUNut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 08:50:49 -0500
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id 34DB2F938903
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 14:50:47 +0100 (CET)
Received: from [129.13.72.197] (helo=blech.mobile)
	by smtp07.web.de with esmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1LPdTj-0001Zx-00
	for linux-wireless@vger.kernel.org; Wed, 21 Jan 2009 14:50:47 +0100
Received: from localhost (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id A0E60341461
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 14:50:55 +0100 (CET)
Received: from blech.mobile ([127.0.0.1])
	by localhost (blech.mobile [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tX+CP85AmsF6 for <linux-wireless@vger.kernel.org>;
	Wed, 21 Jan 2009 14:50:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTPS id 326BA341426
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 14:50:54 +0100 (CET)
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Wed, 21 Jan 2009 14:50:50 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901211450.50880.chunkeey@web.de> (sfid-20090121_145056_890396_FA3F23FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a long standing issue in p54usb.

Under high memory pressure, dev_alloc_skb couldn't always allocate a 
replacement skb. In such situations, we had to free the associated urb.
And over the time all urbs were eventually gone altogether and 
obviously the device remained mute from then on.

---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index bf264b1..e7b99bf 100644
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
@@ -150,58 +178,115 @@ static void p54u_tx_cb(struct urb *urb)
 
 static void p54u_tx_dummy_cb(struct urb *urb) { }
 
+static void p54u_rx_refill_free_list(struct ieee80211_hw *dev)
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
 	usb_kill_anchored_urbs(&priv->submitted);
+	cancel_work_sync(&priv->rx_refill_work);
+	p54u_rx_refill_free_list(dev);
 }
 
-static int p54u_init_urbs(struct ieee80211_hw *dev)
+static int p54u_rx_refill(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *entry = NULL;
-	struct sk_buff *skb;
-	struct p54u_rx_info *info;
-	int ret = 0;
+	struct urb* entry, *tmp;
+	unsigned long flags, flags2;
 
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
+		spin_lock_irqsave(&priv->rx_queue.lock, flags2);
+		__skb_queue_tail(&priv->rx_queue, skb);
 
 		usb_anchor_urb(entry, &priv->submitted);
-		ret = usb_submit_urb(entry, GFP_KERNEL);
-		if (ret) {
-			skb_unlink(skb, &priv->rx_queue);
-			usb_unanchor_urb(entry);
-			goto err;
+		if (usb_submit_urb(entry, GFP_ATOMIC)) {
+			/*
+			 * urb submittion failed.
+			 * free the associated skb and put the urb back into 
+			 * the front of the refill list, so we can 
+			 * try our luck next time.
+			 */
+
+			__skb_unlink(skb, &priv->rx_queue);
+			spin_unlock_irqrestore(&priv->rx_queue.lock, flags);
+			kfree_skb(skb);
+			spin_lock_irqsave(&priv->rx_refill_lock, flags);
+			list_add(&entry->urb_list, &priv->rx_refill_list);
+			spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
 		}
+		spin_unlock_irqrestore(&priv->rx_queue.lock, flags2);
 		usb_free_urb(entry);
-		entry = NULL;
+		spin_lock_irqsave(&priv->rx_refill_lock, flags);
 	}
-
+	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
 	return 0;
+}
 
- err:
-	usb_free_urb(entry);
-	kfree_skb(skb);
-	p54u_free_urbs(dev);
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
+		spin_lock_irqsave(&priv->rx_refill_lock, flags);
+		list_add_tail(&entry->urb_list, &priv->rx_refill_list);
+		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
+	}
+
+	p54u_rx_refill(dev);
+
+err:
+	p54u_rx_refill_free_list(dev);
 	return ret;
 }
 
@@ -878,6 +963,14 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
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
@@ -926,6 +1019,9 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->intf = intf;
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
+	INIT_WORK(&priv->rx_refill_work, p54u_rx_refill_work);
+	spin_lock_init(&priv->rx_refill_lock);
+	INIT_LIST_HEAD(&priv->rx_refill_list);
 
 	usb_get_dev(udev);
 
