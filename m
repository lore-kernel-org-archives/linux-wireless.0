Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:50673 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751530Ab1BFK1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 05:27:14 -0500
Cc: linux-wireless@vger.kernel.org, dsd@gentoo.org,
	linville@tuxdriver.com, kune@deine-taler.de,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
	gregkh@suse.de
Content-Type: text/plain; charset="utf-8"
Date: Sun, 06 Feb 2011 11:27:10 +0100
From: "Martin Schleier" <drahemmaps@gmx.net>
Message-ID: <20110206102710.152130@gmx.net>
MIME-Version: 1.0
Subject: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change
 endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith <m.sujith@...> writes:
> Jussi Kivilinna wrote:
> > +static int usb_endpoint_int_to_bulk(struct usb_device *udev, unsigned int pipe)
> > +{
> > +	struct usb_host_endpoint *ep;
> > +
> > +	ep = usb_pipe_endpoint(udev, pipe);
> > +	if (!ep)
> > +		return -EPIPE;
> > +
> > +	switch (ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
> > +	case USB_ENDPOINT_XFER_INT:
> > +		ep->desc.bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
> > +		ep->desc.bmAttributes |= USB_ENDPOINT_XFER_BULK;
> > +		ep->desc.bInterval = 0;
> > +		/* passthru */

Interesting, I know that interrupt and bulk endpoints share a lot of
common logic so I can see how this should work. But is it really
possible [and more to the point: sane?!] to override the endpoint
descriptors?

I know that usb_submit_urb checks [when config_usb_debug is enabled]
if the xfertype of the submitted urb matches the one of the endpoint,
so I wonder I started to wonder if we are fooling "just" the code
here, or ourselves in the process?
 
> ath9k_htc does the same thing (see ath/ath9k/hif_usb.c).
> It does seem to be working properly but I am wondering if the
> USB subsystem has to be updated after the driver messes around with bmAttributes.
> (lsusb would still show the endpoint type as INT).
> 
> You have a usb_reset_configuration() call before changing
> the endpoint type, why is that necessary ? And would that
> reset the endpoints as well ?
Huh, has this already catched on?
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
