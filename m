Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:60254 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1BFLdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 06:33:41 -0500
Message-ID: <20110206133331.1766181dzo99jt34@hayate.sektori.org>
Date: Sun, 06 Feb 2011 13:33:31 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Martin Schleier <drahemmaps@gmx.net>
Cc: linux-wireless@vger.kernel.org, dsd@gentoo.org,
	linville@tuxdriver.com, kune@deine-taler.de,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
	gregkh@suse.de
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw:
 change endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
References: <20110206102710.152130@gmx.net>
In-Reply-To: <20110206102710.152130@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Martin Schleier <drahemmaps@gmx.net>:

> Sujith <m.sujith@...> writes:
>> Jussi Kivilinna wrote:
>> > +static int usb_endpoint_int_to_bulk(struct usb_device *udev,  
>> unsigned int pipe)
>> > +{
>> > +	struct usb_host_endpoint *ep;
>> > +
>> > +	ep = usb_pipe_endpoint(udev, pipe);
>> > +	if (!ep)
>> > +		return -EPIPE;
>> > +
>> > +	switch (ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
>> > +	case USB_ENDPOINT_XFER_INT:
>> > +		ep->desc.bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
>> > +		ep->desc.bmAttributes |= USB_ENDPOINT_XFER_BULK;
>> > +		ep->desc.bInterval = 0;
>> > +		/* passthru */
>
> Interesting, I know that interrupt and bulk endpoints share a lot of
> common logic so I can see how this should work. But is it really
> possible [and more to the point: sane?!] to override the endpoint
> descriptors?
>
> I know that usb_submit_urb checks [when config_usb_debug is enabled]
> if the xfertype of the submitted urb matches the one of the endpoint,
> so I wonder I started to wonder if we are fooling "just" the code
> here, or ourselves in the process?
>

Would USB quirk like 'USB_QUIRK_NEED_BULK_ON_INTR_EP' that avoids USB  
debug check make more sense?

-Jussi

