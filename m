Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:57414 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbZKBWXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 17:23:19 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Mon, 2 Nov 2009 23:23:01 +0100
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <200910171606.02961.oliver@neukum.org> <20091102210519.7d309fb9@lxorguk.ukuu.org.uk> <1257198359.1027.67.camel@localhost.localdomain>
In-Reply-To: <1257198359.1027.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911022323.01832.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 02 November 2009 22:45:59 Dan Williams wrote:
> On Mon, 2009-11-02 at 21:05 +0000, Alan Cox wrote:
> > > apparently do use the driver CD thing to send Linux drivers and software
> > > to a few clients.  But by and large, the driver CD is completely
> > > useless.
> > 
> > And then every so often you need to rummage around the driver CD image to
> > extract the APN or other data you need to make your modem work. At which
> > point you end up having to recompile the kernel to get it. Very annoying
> > given it could be trivially done properly in user space.
>
> Maybe there's a better way as I said a bit lower in the thread; could we
> put the logic for ejection into the driver (and not usb_modeswitch or
> whatever) but put the decision into userspace in udev?
> 
> Right now the kernel drivers know what hardware they support, and that's
> a great place to also put how to eject the fake driver CD.  So the
> mechanism could live in the kernel still (instead of in usb_modeswitch
> in userspace) while the actual decision still gets made in userspace
> with udev rules.  The rules would say something like "if this USB
> storage device has an 'fakecd' attribute, then touch the 'ejectmeharder'
> attribute" instead of complex rules to run usb_modeswitch that duplicate
> all the device IDs in userspace.  If you need to rummage around on the
> driver CD for whatever reason, you disable the udev rule.  Maybe?
> 
> I simply hate the duplication of all the device IDs with one set in the
> kernel and one set in userspace because it's pretty pointless and makes
> twice the work when new hardware comes out.
>
well, there's more to Alan's theory here.

AVM provides a beta firmware [1] which allows the user to but the stick into
the mass storage mode again and stream the data over WLAN connection. 
(of course, you'll need a special AP which supports this)

[1]: (german only, they haven't bothered to do a translation)
http://www.avm.de/de/Service/Service-Portale/Service-Portal/Labor/7270_streaming_stick/labor_start_streaming_stick.php

Of course, I haven't tested, or even seen such setup yet.
But it appears to be working (based on google).

Therefore, it might be a good idea to start a new user app,
which does this 3-way usb-mode switching for these devices.

Regards,	
	Chr
