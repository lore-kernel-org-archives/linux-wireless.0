Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38327 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933Ab3BYQDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:03:45 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: carl9170 A-MPDU transmit problem
Date: Mon, 25 Feb 2013 17:03:40 +0100
Cc: Seth Forshee <seth.forshee@canonical.com>,
	USB list <linux-usb@vger.kernel.org>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>
References: <Pine.LNX.4.44L0.1302251024200.1526-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302251024200.1526-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302251703.40801.chunkeey@googlemail.com> (sfid-20130225_170351_367482_076F4C8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 25, 2013 04:29:55 PM Alan Stern wrote:
> On Mon, 25 Feb 2013, Christian Lamparter wrote:
> > > In fact this is both normal and required.  Packets to any particular 
> > > endpoint must always be delivered in order.  Therefore the URBs have
> > > to complete in the same order as they were submitted.
> > Yes, I know that ;). I guess I should have said: "It's strange that
> > after such a long silence the urb tx trigger at 1519981417 seemd to
> > unfreeze the pending urb. It's almost as if a urb completion event
> > was lost and the urb_complete just had to wait until another tx urb
> > on the same ep went by to free it.   
> 
> That's quite possible.  The new URB may trigger something in the
> xhci-hcd driver or in the xHCI hardware.  Sarah (CC'ed), the maintainer
> for xhci-hcd, is the person who would know best.

Thanks (Hello Sarah).

One detail that might be important (to keep in mind):

Original report <http://www.spinics.net/lists/linux-wireless/msg103880.html>:
> On the air everything seems to go smoothly for a while, but 
> then the D-Link adapter stops transmitting *DATA* frames for a while. [...] 
> Eventually it sends the action frame with the *DELBA* request, but
> immediately before sending the action frame it sends a single *DATA*
> frame (1). This pattern repeats each time this happens.

Now if we take this and apply it to the usbmon recording in:
<http://www.spinics.net/lists/linux-wireless/msg103915.html>

> Normally the time between submission and callback for a given urb
> is short. However, some are much longer, e.g.:
>
>ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 ... <-- DATA
>
> [... long period where the device receives commands on EP4 and sends
> wifi data to the host via EP2 - so it is working!]
>
>ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 ... <-- DELBA
>ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > <-- DATA urb completion
>ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 > <-- DELBA urb completion

It would mean that the (delayed) urb with the *DATA* frame urb was not
sent (?or received?) by the usb dongle until the *DELBA* came along (1)
and triggered the TX for both (in quick succession). So, I think we 
should be looking for lost/unhandled interrupts/events.

One more thing: So far this issue only occurs with:
00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])

However, it not all xhci-hcd are affected. I have not seen this with
the NEC Corporation uPD720200 I have in my sandy bridge laptop:
19:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host Controller [1033:0194] (rev 04)

Regards,
	Chr
