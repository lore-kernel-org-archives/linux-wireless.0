Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49992 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966329Ab3HHUTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 16:19:33 -0400
Date: Thu, 8 Aug 2013 16:19:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Christian Lamparter <chunkeey@googlemail.com>
cc: Oleksij Rempel <linux@rempel-privat.de>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: FUSB200 xhci issue
In-Reply-To: <201308082109.04485.chunkeey@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.1308081617010.1120-100000@iolanthe.rowland.org> (sfid-20130808_221939_004119_B0E01125)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Aug 2013, Christian Lamparter wrote:

> Anyway, I do have a question about something else too.
> 
> in ath9k_htc's hif_usb:
> 
> > struct usb_host_interface *alt = &hif_dev->interface->altsetting[0];
> > struct usb_endpoint_descriptor *endp;
> > ...
> > /* On downloading the firmware to the target, the USB descriptor of EP4
> >  * is 'patched' to change the type of the endpoint to Bulk. This will
> >  * bring down CPU usage during the scan period. */
> >
> > for (idx = 0; idx < alt->desc.bNumEndpoints; idx++) {
> >   endp = &alt->endpoint[idx].desc;
> >   if ((endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT) {
> >     endp->bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
> >     endp->bmAttributes |= USB_ENDPOINT_XFER_BULK;
> >//     endp->bInterval = 0;
> >   }
> > }
> 
> Alan, can you please tell us, if it is really safe to
> override the bmAttributes this way? After all (according to
> the comment) the device has "morphed" (EP4 has changed).

This does not look like a good idea.  Why does the driver do it?

> Or, is it necessary for the driver call "usb_reset_device"
> or (usb_reset_configuration) in this case? 

After loading firmware, a reset generally is necessary.  Some devices 
will do it themselves; others require you to call usb_reset_device().

Alan Stern

