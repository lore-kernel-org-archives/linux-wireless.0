Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:11103 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYABTND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 14:13:03 -0500
Received: by fk-out-0910.google.com with SMTP id z23so6272658fkz.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2008 11:13:01 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Wed, 2 Jan 2008 20:12:52 +0100
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200712291614.55732.IvDoorn@gmail.com> <1199261473.4172.58.camel@johannes.berg>
In-Reply-To: <1199261473.4172.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801022012.52287.IvDoorn@gmail.com> (sfid-20080102_191310_144395_8FAB4448)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Happy New Year!

You too. :)

> I was out since Saturday just before you sent your 
> message, sorry for the late reply.
> 
> > 	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
> > 	if (header_size % 4 == 2) {
> > 		/*
> > 		 * Move entire frame 2 bytes to the front.
> > 		 */
> > 		skb_push(entry->skb, 2);
> > 		memmove(entry->skb->data, entry->skb->data + 2,
> > 			entry->skb->len - 2);
> > 	}
> 
> That doesn't really look right, I'd think the skb will be two bytes too
> long after this.

Yeah, fixed this in rt2x00.git :)

> It's probably more efficient to decide where to copy 
> the frame and do the realignment while you're copying it anyway rather
> than doing a copy and then a memmove.
>
> I guess you should also try talk to Ralink to get firmware to do it
> (where possible), it's probably not too hard to insert padding before
> the frame.

Well the problem is a bit bigger than this, the bug is reported very rarely,
so I can't say for sure which drivers are affected by this. But since most
Ralink chipsets look alike, I think the safest assumption is that all are
affected.

rt2400pci, rt2500pci and rt2500usb don't have firmware, for rt61pci and
rt73usb there is, but looking at how the TX and RX registers are working
I *assume* the firmware isn't doing much in this area. (My personal
guess for the firmware is that it only handles the hardware encryption
and perhaps beaconing & virtual interfaces)
Additionally firmware for rt61 and rt73 have been discontinued,
all their work is currently going to rt2860 and rt2870. (Porting these to
rt2x00 has already begun, but I haven't arrived at the header alignment yet)

For PCI drivers I could indeed optimize the code by making the memcpy
perform the operation on the 4 byte aligned code. But for this I need
to check what is better, RX directly into a skbuff and use memmove
or RX into DMA and use memcpy to a skbuff.
But for USB this is not possible, since it directly performs the RX into
the skbuff already, so I either have to change that or perform memmove anyway.

> If you absolutely can't get the hardware to do it and would otherwise do
> DMA right into the skb we should try to evaluate the performance hit on
> platforms where unaligned access *is* possible to be able to balance it
> against the performance hit caused by the memmove(). Ultimately, though,
> I value correctness on all platforms over performance on some, hence the
> warning when unaligned packets are handed up to mac80211.

Overall correctness sounds as the best solution to me too.

Ivo

