Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53807 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZGIVCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 17:02:01 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: p54usb - problems with "no probe,response from AP ..."
Date: Thu, 9 Jul 2009 23:01:54 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4A5645A3.9000906@lwfinger.net>
In-Reply-To: <4A5645A3.9000906@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907092301.56485.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 July 2009 21:31:47 Larry Finger wrote:
> Christian,
> 
> I have not gotten very far with the problem in the subject; however, I
> have a few things to report:
> 
> I got a dump of the TX queues when the disassociation event came
> through. All were normal.
normal? as in completely empty? or just a soft dribble (possibly stalled)?

> I tested with 2.6.31-rc2 from Linus's tree. It does _NOT_ have the
> problem, thus it is something that was introduced in the process of
> splitting p54common.{ch} into the component parts.
> 
> In comparing the code, I see that the variable 'cached_beacon' was
> eliminated and the code that handles beacons was changed. When I made
> the following change, the "no probe response" message went away - the
> interface just hangs:
cached_beacon is only relevant when you run an AP/MESH/(IBSS).
The cached_beacon code was removed because its very racy
(we never knew whenever the pointer was still valid, as p54_free_skb
 could have freed that buffer already and did not NULL out the reference).

The replacement "beacon_req_id" suffers from the same flaw,
but at least its save against 2x kfree_skb.

so no, can you still toggle the LEDs (e.g /sys/class interface)
when the interface hangs? or is there some traffic
on a cooked monitor interface?
(iw phy phyX interface add monX type monitor; ifconfig monX up)

what could be related to that issue... and maybe even explain why I don't have
the very same issues are transmission errors:
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index e44460f..c0c2817 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -111,10 +111,12 @@ static void p54u_rx_cb(struct urb *urb)
 	struct p54u_rx_info *info = (struct p54u_rx_info *)skb->cb;
 	struct ieee80211_hw *dev = info->dev;
 	struct p54u_priv *priv = dev->priv;
+	int err;
 
 	skb_unlink(skb, &priv->rx_queue);
 
 	if (unlikely(urb->status)) {
+		printk(KERN_INFO "lost rx urb (%d)\n", urb->status);
 		dev_kfree_skb_irq(skb);
 		return;
 	}
@@ -153,7 +155,8 @@ static void p54u_rx_cb(struct urb *urb)
 	}
 	skb_queue_tail(&priv->rx_queue, skb);
 	usb_anchor_urb(urb, &priv->submitted);
-	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+	if ((err = usb_submit_urb(urb, GFP_ATOMIC))) {
+		printk(KERN_INFO "could not resubmit rx urb (%d)\n", err);
 		skb_unlink(skb, &priv->rx_queue);
 		usb_unanchor_urb(urb);
 		dev_kfree_skb_irq(skb);
@@ -244,9 +247,11 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct p54u_priv *priv = dev->priv;
 	struct urb *data_urb;
 	struct lm87_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
+	int err;
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!data_urb) {
+		printk(KERN_ERR "could not alloc tx urb - oom\n");
 		p54_free_skb(dev, skb);
 		return;
 	}
@@ -261,7 +266,8 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_anchor_urb(data_urb, &priv->submitted);
-	if (usb_submit_urb(data_urb, GFP_ATOMIC)) {
+	if ((err = usb_submit_urb(data_urb, GFP_ATOMIC))) {
+		printk(KERN_ERR "xmit urb failed (%d)\n", err);
 		usb_unanchor_urb(data_urb);
 		p54_free_skb(dev, skb);
 	}

---
if that doesn't work out (which will inevitably happen)...
I'm really out of ideas and if you can I request an (usbmon -iX -s 2400) dump
for inspiration from a crash/stall. Of course, it doesn't need to be
the whole log (~ 5 before and 20 after the freeze/disassoc) should be
more than enough to hopefully spot that *********** bug inside the driver.

Regards,
	Chr
