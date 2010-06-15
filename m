Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:58414 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0FOR7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 13:59:17 -0400
Subject: Re: [PATCH] p54usb: Remove duplicate Medion MD40900 device id
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org,
	Ben Collins <ben.collins@ubuntu.com>
In-Reply-To: <20100614185549.GB2216@tuxdriver.com>
References: <1276208913.1221.3646.camel@emiko>
	 <4C1173E7.6010201@lwfinger.net>  <20100614185549.GB2216@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 10:59:05 -0700
Message-ID: <1276624745.6127.61.camel@emiko>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-14 at 14:55 -0400, John W. Linville wrote:
> On Thu, Jun 10, 2010 at 06:23:19PM -0500, Larry Finger wrote:
> > On 06/10/2010 05:28 PM, Leann Ogasawara wrote:
> > > The Medion MD40900 device id [0x0cde, 0x0006] is defined twice.  Remove
> > > the duplicate.
> > > 
> > > Originally-by: Ben Collins <ben.collins@ubuntu.com>
> > > Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
> > > ---
> > >  drivers/net/wireless/p54/p54usb.c |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> > > index 7307325..d6d8713 100644
> > > --- a/drivers/net/wireless/p54/p54usb.c
> > > +++ b/drivers/net/wireless/p54/p54usb.c
> > > @@ -69,7 +69,6 @@ static struct usb_device_id p54u_table[] __devinitdata = {
> > >  	{USB_DEVICE(0x0915, 0x2002)},	/* Cohiba Proto board */
> > >  	{USB_DEVICE(0x0baf, 0x0118)},   /* U.S. Robotics U5 802.11g Adapter*/
> > >  	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
> > > -	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
> > >  	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
> > >  	{USB_DEVICE(0x0cde, 0x0015)},	/* Zcomax XG-705A */
> > >  	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
> > 
> > Do you know for certain that this device is a Version 1 chip, and for
> > that reason, you are removing it from the version 2 list?
> > 
> > If not, NACK.
> 
> So, I guess you are concerned about the groupings because of the
> different firmwares or something like that?  Perhaps a comment that
> says "this could be a version 2 device" is just as handy?  Since the
> driver prints the name of the firmware it wants, is there any real
> need for grouping the IDs?
> 
> OTOH, is there any actual harm from the duplicate entry?  It "seems"
> wrong to me too, but I guess it does no harm...?

I don't believe there is any harm from the duplicate entry, it just
seemed unnecessary.

> Leann and/or Ben, was this just tidying-up?  I'm guessing there wasn't
> an actual bug involved?

Indeed, this was just a patch we'd been carrying to tidy things up.
There was no actual bug involved.  I'd be happy to send a v2 of the
patch which comments out the duplicate entry and adds a note as to why.
Or I'd be fine just leaving the code as is and we'll drop the patch
we're carrying locally in Ubuntu.

Thanks,
Leann

