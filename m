Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:58187 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966738Ab3HHWGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 18:06:17 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: FUSB200 xhci issue
Date: Fri, 9 Aug 2013 00:06:06 +0200
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"ath9k_htc_fw" <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44L0.1308081617010.1120-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308081617010.1120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201308090006.07690.chunkeey@googlemail.com> (sfid-20130809_000623_690921_A1762F7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 August 2013 22:19:32 Alan Stern wrote:
> On Thu, 8 Aug 2013, Christian Lamparter wrote:
> 
> > Anyway, I do have a question about something else too.
> > 
> > in ath9k_htc's hif_usb:
> > 
> > > struct usb_host_interface *alt = &hif_dev->interface->altsetting[0];
> > > struct usb_endpoint_descriptor *endp;
> > > ...
> > > /* On downloading the firmware to the target, the USB descriptor of EP4
> > >  * is 'patched' to change the type of the endpoint to Bulk. This will
> > >  * bring down CPU usage during the scan period. */
> > >
> > > for (idx = 0; idx < alt->desc.bNumEndpoints; idx++) {
> > >   endp = &alt->endpoint[idx].desc;
> > >   if ((endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT) {
> > >     endp->bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
> > >     endp->bmAttributes |= USB_ENDPOINT_XFER_BULK;
> > >//     endp->bInterval = 0;
> > >   }
> > > }
> > 
> > Alan, can you please tell us, if it is really safe to
> > override the bmAttributes this way? After all (according to
> > the comment) the device has "morphed" (EP4 has changed).
> 
> This does not look like a good idea.  Why does the driver do it?

Probably because people use ath9k_htc devices with everything that
has some sort of usb port (devkits and embedded systems: Dockstar,
Rasberry Pi, ...) to get "wifi connectivity". ...


Yeah. I think we better ask "Rajkumar Manoharan" 
(before I write more text out of thin air :-D )

commit 4a0e8ecca4eeed38d4b3b7a317a3aaab4dd3cacd
Author: Rajkumar Manoharan <rmanoharan@atheros.com>
Date:   Tue Sep 14 14:35:55 2010 +0530

    ath9k_htc: Fix CPU usage issue during scan period

Does anyone know his Qualcomm Atheros address?
 
> > Or, is it necessary for the driver call "usb_reset_device"
> > or (usb_reset_configuration) in this case? 
> 
> After loading firmware, a reset generally is necessary.  Some devices 
> will do it themselves; others require you to call usb_reset_device().

This makes things complicated. Because, as far as I remember,
usb_reset_device() will cause the current driver to be unbound
unless its called during .probe, right?

You see, ath9k_htc loads its firmware asynchronously in ".probe"
(ath9k_htc's .probe routine finishes before the firmware is
retrieved via the firmware loader helper... so part of the
firmware download is done in a firmware_complete callback
on a workqueue). 

So, if we call usb_reset_device there and the driver is unbound
and later rebound. the next ath9k_htc .probe will start again and
again and again not knowing that it is already initialized 
(and we have a loop).


This could be solved, if the devices changes the usb-id again 
when a proper "wifi" ath9k_htc firmware was downloaded. So, the
driver would know that it doesn't have to download and reset
the device... But we need a "free" USB-ID for that.

Alan, Oleksij: What do you think?

Regards,
	Chr
