Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:52095 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752782Ab1BFPqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 10:46:15 -0500
Date: Sun, 6 Feb 2011 10:46:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sujith <m.sujith@gmail.com>
cc: Martin Schleier <drahemmaps@gmx.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	<linux-wireless@vger.kernel.org>, <dsd@gentoo.org>,
	<linville@tuxdriver.com>, <kune@deine-taler.de>,
	<linux-usb@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change
 endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
In-Reply-To: <19790.36590.884287.572619@gargle.gargle.HOWL>
Message-ID: <Pine.LNX.4.44L0.1102061037060.20379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 Feb 2011, Sujith wrote:

> Martin Schleier wrote:
> > Interesting, I know that interrupt and bulk endpoints share a lot of
> > common logic so I can see how this should work. But is it really
> > possible [and more to the point: sane?!] to override the endpoint
> > descriptors?
> > 
> > I know that usb_submit_urb checks [when config_usb_debug is enabled]
> > if the xfertype of the submitted urb matches the one of the endpoint,
> > so I wonder I started to wonder if we are fooling "just" the code
> > here, or ourselves in the process?
> >  
> > > ath9k_htc does the same thing (see ath/ath9k/hif_usb.c).
> > > It does seem to be working properly but I am wondering if the
> > > USB subsystem has to be updated after the driver messes around with bmAttributes.
> > > (lsusb would still show the endpoint type as INT).
> > > 
> > > You have a usb_reset_configuration() call before changing
> > > the endpoint type, why is that necessary ? And would that
> > > reset the endpoints as well ?
> > Huh, has this already catched on?
> 
> Well, for ath9k_htc, the FW changes the descriptor type after it is
> transferred to the target. The USB devs suggested that usb_device_reset()
> should be called by the driver in such cases, but in ath9k_htc's case,
> the device is disconnected and the error message "device firmware changed"
> is displayed.
> 
> Agreed, this is a dirty hack - but is there any way for a driver to make the USB
> subsystem re-configure the endpoints ?

Why do you want to?  Why does changing the endpoint type from interrupt
to bulk improve performance?  Yes, the description says that this
causes CPU usage to go from 10% to below 1%, but _why_ does it do that?

Maybe the same effect can be achieved simply by changing the interrupt
interval instead.

Alan Stern

