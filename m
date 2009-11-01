Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:40316 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZKAUuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 15:50:17 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Frank Schaefer <schaefer.frank@gmx.net>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Sun, 1 Nov 2009 21:49:56 +0100
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <200910171606.02961.oliver@neukum.org> <20091101183553.GB24436@one-eyed-alien.net> <4AEDEE7C.4010406@gmx.net>
In-Reply-To: <4AEDEE7C.4010406@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911012149.57966.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 01 November 2009 21:24:28 Frank Schaefer wrote:
> Matthew Dharm schrieb:
> > On Sun, Nov 01, 2009 at 07:29:20PM +0100, Josua Dietze wrote:
> >   
> >> Frank Schaefer schrieb:
> >>
> >>     
> >>> I really think the mode-switching should be done in the kernel and not
> >>> in user-space for reasons of usability.
> >>>       
> >> What is wrong with an udev rule entry? By the way, did the "eject" 
> >> command line tool work as well?
> >>     
> >
> > And I think it should be done in userspace for issues of maintainability
> > and useability.  It is much easier for users to upgrade their udev then
> > their kernel.
> >   
> Maintainability for whom ? The kernel-devs or the distro-people and the
> users ? ;)
> 
> Please think about the users. They don't know that they have to create
> udev-rules or have to install additional packages like usb_modeswitch
> (which is nevertheless a great tool !).
> And even if they know, they don't want to do that. So it's up to the
> distros to do this automatically, which will in reality never come true
> for all devices and distros.
yes, please think about the users!

All not-so-trival-changes have to go through wireless-testing / wireless-next,
net-next, linux-next until it hits finally the mainline... And then only users
which are able to update their kernels will benefit, *everyone else* has
to wait until their distros to pick up the new kernel... this could be easily more
than a year before the device will work right out of the box for *everyone else*.

Therefore udev should be the way to go... and as a bonus: a userspace/udev solution 
does work with older kernels right away!

Regards,
	Chr
