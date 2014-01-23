Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaAWEnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 23:43:16 -0500
Date: Wed, 22 Jan 2014 20:44:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Realtek 8821 wireless PCI driver?
Message-ID: <20140123044405.GA9879@kroah.com> (sfid-20140123_054339_704460_21F8A488)
References: <20140120193249.GA25707@kroah.com>
 <52E066A1.9010009@lwfinger.net>
 <20140123021208.GA13639@kroah.com>
 <52E096F7.8040903@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52E096F7.8040903@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 10:13:43PM -0600, Larry Finger wrote:
> On 01/22/2014 08:12 PM, Greg KH wrote:
> > On Wed, Jan 22, 2014 at 06:47:29PM -0600, Larry Finger wrote:
> >> On 01/20/2014 01:32 PM, Greg KH wrote:
> >>> Hi all,
> >>>
> >>> I have a box here with a Realtek 8821 wireless PCI device.  We don't
> >>> seem to have a driver upstream for it yet, but there's a huge tarball
> >>> from Realtek on their site.
> >>>
> >>> Has anyone started picking the needed pieces out of the tarball to get
> >>> this merged "properly", or does this need to be done yet?
> >>>
> >>> Hm, I wonder if I should just dump the tarball into staging for now, to
> >>> get my box working, any objections to me doing that?
> >>
> >> I have had contact with the Realtek developers regarding a Linux driver for the
> >> RTL8821AE device with PCI ID 10ec:8821. On Dec 10, 2013, they indicated that
> >> there were still 802.11ac problems, and they were not yet ready to release it to
> >> me. I will write them again and check if the driver is now ready, and they just
> >> forgot to send it to me. Once they are ready, they will also be sending me
> >> sample devices.
> >>
> >> What is the URL for the driver that you found? I did a quick search on their
> >> site and did not find it.
> >
> > It came with a device I got at a conference, along with 1,000 other
> > people, so it's being used in the "wild" now, running Linux.  I'll send
> > you the patch off-list as it's not small.
> >
> >> To answer your question, I certainly would have no objections to your dumping
> >> the driver into staging. I can fix it up there as easily as in my own private
> >> stores. You will, of course, get a lot more intermediate patches, but I think
> >> you have already anticipated that. The PCI group usually send me mac80211-based
> >> drivers, thus the residence in staging may be short, but that is desirable.
> >
> > Ok, I spent an hour or so trying to see if I could just use the existing
> > rtlwifi module with this driver, but it seems that they are using a 2
> > year-old version of it, so I'll have to bundle it directly into the
> > driver for now, along with an "odd" bluetooth sharing module.  I'll work
> > on making the needed changes to the driver to get it to work with
> > rtlwifi first, and then clean up the rest over the next few months.  I
> > have the hardware here to test with, so that should make it easier than
> > the normal staging driver work I do.
> >
> > But for now, staging seems like a good idea, especially as one "distro"
> > is already shipping it in this form (SteamOS).
> 
> Too bad I couldn't get one of those devices.

They all seem to be sold-out at the moment, if I hear of a way to get
any more, I'll be sure to let you know.

> The "odd" bluetooth sharing module is part of a new driver that I am about to 
> push into drivers/net/wireless to be part of 3.15. This one drives the RTL8723BE 
> device, which is somewhat different from the existing RTL8723AE. Both of the 
> 8723 device are both wifi and BT, and it also seems that the 8821AE is also a 
> dual device.
> 
> I will merge the 8821 code with my current working version of rtlwifi and 
> becoexist, and send you patches for testing. I agree that staging is a good 
> place for now.

Wonderful, I didn't want to deal with becoexist at all, I'll gladly let
you do that :)

thanks,

greg k-h
