Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42686 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYBJMUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 07:20:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: Add new USB ID to rt2500usb
Date: Sun, 10 Feb 2008 13:19:59 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200802101121.58058.IvDoorn@gmail.com> <200802101131.13974.mb@bu3sch.de> <200802101136.28667.IvDoorn@gmail.com>
In-Reply-To: <200802101136.28667.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200802101320.00065.mb@bu3sch.de> (sfid-20080210_122040_921992_90DB6DBA)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 February 2008 11:36:28 Ivo van Doorn wrote:
> On Sunday 10 February 2008, Michael Buesch wrote:
> > On Sunday 10 February 2008 11:21:57 Ivo van Doorn wrote:
> > > 
> > > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > > ---
> > > John, please send this patch to the 2.6.24/2.6.25 stable trees.
> > > It is already present in the wireless-2.6 tree queued for 2.6.26.
> > > 
> > >  drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> > > index cba7f57..c4a6ab4 100644
> > > --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> > > +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> > > @@ -1871,11 +1871,11 @@ static struct usb_device_id rt2500usb_device_table[] = {
> > >  	/* Hercules */
> > >  	{ USB_DEVICE(0x06f8, 0xe000), USB_DEVICE_DATA(&rt2500usb_ops) },
> > >  	/* Melco */
> > > +	{ USB_DEVICE(0x0411, 0x005e), USB_DEVICE_DATA(&rt2500usb_ops) },
> > >  	{ USB_DEVICE(0x0411, 0x0066), USB_DEVICE_DATA(&rt2500usb_ops) },
> > >  	{ USB_DEVICE(0x0411, 0x0067), USB_DEVICE_DATA(&rt2500usb_ops) },
> > >  	{ USB_DEVICE(0x0411, 0x008b), USB_DEVICE_DATA(&rt2500usb_ops) },
> > >  	{ USB_DEVICE(0x0411, 0x0097), USB_DEVICE_DATA(&rt2500usb_ops) },
> > > -
> > >  	/* MSI */
> > >  	{ USB_DEVICE(0x0db0, 0x6861), USB_DEVICE_DATA(&rt2500usb_ops) },
> > >  	{ USB_DEVICE(0x0db0, 0x6865), USB_DEVICE_DATA(&rt2500usb_ops) },
> > 
> > I'm unsure on how this is an actual _fix_ that we need in a stable kernel.
> > We always handled adding IDs as features.
> 
> Ok, the user has to wait untill 2.6.26 then.

Oh, it seems that -stable does actually accept such patches:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=commitdiff;h=2cf220bb5b30a922aebdd5841a7975e02a70ce59
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=commitdiff;h=955ab48db7fb9e3d74dc770cca9aa6b194e53025

I wasn't aware of this, because we always had the rule of ID additions
being features, in the wireless team.
So well. I think John should probably make an official decision. :)

I would suggest the following: Unless there's another driver in
the tree that (partially) supports the device being added, adding the ID
can not cause a regression. So it's OK to add it, even in a stable cycle.

-- 
Greetings Michael.
