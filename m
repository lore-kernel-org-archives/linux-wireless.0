Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:41318 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZAVWMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 17:12:25 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Thu, 22 Jan 2009 23:12:31 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <200901222239.29656.chunkeey@web.de> <4978E908.4060103@gmail.com>
In-Reply-To: <4978E908.4060103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901222312.31063.chunkeey@web.de> (sfid-20090122_231230_069168_EFC35094)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 January 2009 22:45:44 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Thursday 22 January 2009 16:43:20 Artur Skawina wrote:
> >> Christian Lamparter wrote:
> >>> On Thursday 22 January 2009 00:22:16 Artur Skawina wrote:
> >>> +	if (unlikely(!priv->common.hw->workqueue)) {
> >>> +		/*
> >>> +		 * Huh? mac80211 isn't fully initialized yet?
> >>> +		 * Please check your system, something bad is going on.
> >>> +		 */
> >>> +		WARN_ON(1);
> >> please do not add WARN_ON's unless you're actually interested in the
> >> stacktrace, In this case it's a usb completion, so in most cases the
> >> backtrace isn't very interesting, wouldn't a printk be enough?
> >> [i was hitting this when testing, and it took several seconds to 
> >> get all the data to the console]
> > 
> > Ahh, wait!
> > 
> > In fact we "should" call BUG_ON here, as mac80211 is not fully initialized at
> > this point and we might have accidently submitted a dataframe to the stack.
> > (Of course, this attempt by the device to send garbage to the stack is
> > caught by the common-code... so no oops here)
> 
> Wouldn't you then want to catch it _before_ p54_rx()?
Well neither the device's MAC/BBP nor radio is initialized... so its garbage. 
but I hoped the
+        if (unlikely(urb->status)) {
+                return;
+      }
        if (unlikely(!priv->common.hw->workqueue)) {
                /*
resolved this issue when usb_kill_anchored_urbs is called...
(the urb completion callback is always called, even if we don't want it...
that's why we don't reschedule a p54u_rx_refill_work and wait until urb
with a good status arrives.. )

> > However, I wonder if the WARN_ON gets triggered under normal operation or not.
> > (Just in case, no it does not trigger with the ISL3887 chips)
> 
> i have never seen it, after the initial 32 times.
> As-is, it currently triggers on every init however...

well, it clearly shouldn't do that.... 

Off topic:

On Thursday 22 January 2009 16:43:20 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Thursday 22 January 2009 00:22:16 Artur Skawina wrote:
> >> Christian Lamparter wrote:
> >>>         reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
> >>>         if (!reg) {
> >>>                 printk(KERN_INFO "tx_net2280 kmalloc(reg), txqlen = %d\n",
> >>>                           skb_queue_len(&priv->common.tx_queue) );
> >>>                 return;
> >>>         }
> >>> [...]
> >>>         reg->port = cpu_to_le16(NET2280_DEV_U32);
> >>>         reg->addr = cpu_to_le32(P54U_DEV_BASE);
> >>>         reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
> >> does not need to happen for every single tx-ed frame.
> > Ah, yes that's true. what do you say about this...
> > Instead of using kmalloc in the init procedure, we let gcc already do it.
> 
> apparently there are archs where dmaing from not-kmalloced areas doesn't work
> that well, this mostly applies to the stack, but i'd rather be safe and 
> stick to a kmalloc buffer. one allocation on device init isn't worth avoiding.

agreed, the static definition is not a good idea and the usb stack also recommends
to use usb_buffer_alloc over kmalloc to avoid DMA bounce buffers usage etc...

Regards,
	Chr
