Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbZKBUSx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 15:18:53 -0500
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
From: Dan Williams <dcbw@redhat.com>
To: Frank Schaefer <schaefer.frank@gmx.net>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <4AEF3CAD.10809@gmx.net>
References: <200910171606.02961.oliver@neukum.org>
	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>
	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>
	 <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>
	 <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net>
	 <4AEF3CAD.10809@gmx.net>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 12:18:35 -0800
Message-Id: <1257193115.1027.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-02 at 21:10 +0100, Frank Schaefer wrote:
> Matthew Dharm schrieb:
> > On Sun, Nov 01, 2009 at 09:11:49PM +0100, Frank Schaefer wrote:
> >   
> >> Josua Dietze schrieb:
> >>     
> >>> Frank Schaefer schrieb:
> >>>       
> >>>> I really think the mode-switching should be done in the kernel and not
> >>>> in user-space for reasons of usability.
> >>>>         
> >>> What is wrong with an udev rule entry? By the way, did the "eject"
> >>> command line tool work as well?
> >>>       
> >> It returns an error but the device is ejected.
> >> But do you really want the users to open a terminal window and call
> >> "eject" each time they plug their device in ;) ?
> >>     
> >
> > If 'eject' worked, then why not use a simple udev entry?  That way nobody
> > has to call anything by hand...
> >
> > Matt
> >   
> And who will create this udev-entry ;) ? How can you make sure that this
> is done on all systems ?

You can't.  The distros have to make sure it works.  Personally, I think
these should all be in the kernel, but the kernel doesn't contain
policy.  And unfortunately, for some devices (3G modems specifically)
ejecting the driver CD thing *is* policy.  Option for example protested
mightily when I sent a patch to auto-eject their driver CD, because they
apparently do use the driver CD thing to send Linux drivers and software
to a few clients.  But by and large, the driver CD is completely
useless.

Devices with fake driver CDs and how they are handled currently:

Zydas WLAN   - kernel
Huawei 3G    - kernel  (unusual_devs entry)
Sierra 3G    - kernel  (drivers/usb/serial/sierra.c)
Option 3G    - udev rules, 'rezero', or usb_modeswitch
ZTE 3G       - udev rules, simple 'eject'

Dan

