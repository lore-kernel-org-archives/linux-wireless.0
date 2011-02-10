Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab1BJSUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 13:20:23 -0500
Subject: Re: rfkill API
From: Dan Williams <dcbw@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 10 Feb 2011 12:21:26 -0600
In-Reply-To: <4D4AFACC.3080603@candelatech.com>
References: <4D48DF01.1010401@candelatech.com>
		 <4D48E2C8.5010300@candelatech.com>
	 <1296758576.3668.89.camel@dcbw.foobar.com>
	 <4D4AFACC.3080603@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1297362087.17161.7.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-03 at 10:58 -0800, Ben Greear wrote:
> On 02/03/2011 10:42 AM, Dan Williams wrote:
> > On Tue, 2011-02-01 at 20:51 -0800, Ben Greear wrote:
> >> On 02/01/2011 08:35 PM, Ben Greear wrote:
> >>> Hello!
> >>>
> >>> I was looking at using one rfkill socket in wpa_supplicant, instead
> >>> of one per vif.
> >>>
> >>> Current wpa_supplicant code seems to treat the API as if there is only
> >>> as single rfkill object for the entire kernel. I would assume that
> >>> instead different NICs could have different rfkill status.
> >>>
> >>> Is there any way to coorelate a netdevice (or devices)
> >>> to the rfkill->idx in the
> >>>
> >>> struct rfkill_event {
> >>> u32 idx;
> >>> u8 type;
> >>> u8 op;
> >>> u8 soft;
> >>> u8 hard;
> >>> } STRUCT_PACKED;
> >>>
> >>>
> >>> ?
> >>>
> >>> Thanks,
> >>> Ben
> >>>
> >>
> >> Err, nevermind..looks like you can grub around in sysfs and find the phy,
> >> and from there, find the devices....
> >
> > Remember about platform devices.  An rfkill device is not always
> > associated with a netdevice, and sometimes platform rfkill devices can
> > block the netdevice rfkill.
> >
> > So, if you have a laptop with a BIOS rfkill switch, setting that rfkill
> > switch "softblocked" will hardblock the netdevice rfkill device.  Thus
> > you cannot unblock the netdevice rfkill until you unblock the
> > platform/BIOS device rfkill.
> >
> > Yes, this sucks.
> 
> I tried to make my patch treat anything that wasn't specifically a phy
> as 'all'..but likely it could still use some work.  I'll send it to the
> list for review/suggestions..in case you have the time.
> 
> Is there any specific way to tell if an rfkill device is a platform
> device?
> 
> For the platform rfkill blocking the netdevice rfkill:  Is this something
> that must be done in software (ie, supplicant), or is that already handled
> by the kernel/drivers/hardware?

It's something usually done in hardware/BIOS.  On my laptop (HP 2530p),
the iwlagn phy killswitch will be hardblocked when the BIOS switch (a
physical button) is flipped.  The BIOS presumably tells the EC to toggle
the 5350's rfkill GPIO or something.  So when I hit the laptop
killswitch, I get:

hpwmi - softblocked
iwlagn - hardblocked

and no amount of "rfkill unblock" will make the iwlagn switch change.  I
must first unblock the hpwmi switch, which then magically unblocks the
iwlagn one.  Yay.

This is the case with most of the platform devices I've seen from
mainstream vendors.

Dan


