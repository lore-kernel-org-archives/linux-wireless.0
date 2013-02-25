Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3BYTOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 14:14:21 -0500
Date: Mon, 25 Feb 2013 11:13:57 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130225191357.GE6605@xanatos> (sfid-20130225_201426_181563_F47C9A12)
References: <Pine.LNX.4.44L0.1302251024200.1526-100000@iolanthe.rowland.org>
 <201302251703.40801.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302251703.40801.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 25, 2013 at 05:03:40PM +0100, Christian Lamparter wrote:
> On Monday, February 25, 2013 04:29:55 PM Alan Stern wrote:
> > On Mon, 25 Feb 2013, Christian Lamparter wrote:
> One detail that might be important (to keep in mind):
> 
> Original report <http://www.spinics.net/lists/linux-wireless/msg103880.html>:
> > On the air everything seems to go smoothly for a while, but 
> > then the D-Link adapter stops transmitting *DATA* frames for a while. [...] 
> > Eventually it sends the action frame with the *DELBA* request, but
> > immediately before sending the action frame it sends a single *DATA*
> > frame (1). This pattern repeats each time this happens.
> 
> Now if we take this and apply it to the usbmon recording in:
> <http://www.spinics.net/lists/linux-wireless/msg103915.html>
> 
> > Normally the time between submission and callback for a given urb
> > is short. However, some are much longer, e.g.:
> >
> >ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 ... <-- DATA
> >
> > [... long period where the device receives commands on EP4 and sends
> > wifi data to the host via EP2 - so it is working!]
> >
> >ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 ... <-- DELBA
> >ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > <-- DATA urb completion
> >ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 > <-- DELBA urb completion
> 
> It would mean that the (delayed) urb with the *DATA* frame urb was not
> sent (?or received?) by the usb dongle until the *DELBA* came along (1)
> and triggered the TX for both (in quick succession). So, I think we 
> should be looking for lost/unhandled interrupts/events.
> 
> One more thing: So far this issue only occurs with:
> 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])

Which kernel version are you testing under?  Can you please recompile
with CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on, and
send me dmesg?  I should be able to see if there's an unhandled pending
event on the xHCI rings if the data URB stalls for longer than say, a
minute.

As for lost interrupts, the only issue we had with that particular xHCI
host had to do with lost isochronous transfers.  We fixed that with a
quirk to avoid the BEI flag on that platform.  But your data is being
sent via a bulk endpoint, so we shouldn't have any issues there.

> However, it not all xhci-hcd are affected. I have not seen this with
> the NEC Corporation uPD720200 I have in my sandy bridge laptop:
> 19:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host Controller [1033:0194] (rev 04)

Hmm, yeah, that kind of points to an Intel xHCI hardware issue.  It's
too bad you don't have a USB analyzer (the high speed ones are about
$480).  Can you send me a link so I can purchase the device and test it
with my analyzer?

Sarah Sharp
