Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.wanadoo.co.uk ([193.252.22.157]:45540 "EHLO
	smtp2.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761683AbYBTAVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 19:21:47 -0500
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200802192046.14184.IvDoorn@gmail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802191026.57640.IvDoorn@gmail.com>
	 <200802191900.09543.chris2553@googlemail.com>
	 <200802192046.14184.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 23:04:07 +0000
Message-Id: <1203462247.6397.15.camel@boulder.homenet> (sfid-20080220_002152_642177_94CE4D84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-19 at 20:46 +0100, Ivo van Doorn wrote:
> Hi,
> 
> [added rt2400-devel (rt2x00 development mailinglist) to the CC list.]
> 
> > > > > I have a series of tests I would like to request from you,
> > > > > you mentioned you already enabled debugfs, and that is just what we need. ;)
> > > > > Please use attached script to create dumps of the hardware register contents.
> > > > > 
> > > > > There are specific moments that should be dumped:
> > > > > - kernel 2.6.24 (last known working version for you).
> > > > > - kernel 2.6.25-rc2 (after ifup, before TX dies)
> > > > > - kernel 2.6.25-rc2 (after ifup, after TX dies)
> > > > >  
> > > > 
> > > > These diagnostics are attached, with obvious filenames.
> > > 
> > > Thanks. I think I found something, please test below patch:
> > > 
> > 
> > I've tried the patch but, unfortunately, my wireless LAN still dies after a few pings.

rt2x00 2.0.14 is broken with my rt73 stick in the vanilla 2.6.25-rc2
kernel (not wireless-2.6/rt2x00 git).  The modules load when I plug the
stick in but I then get a complete kernel lock up with two flashing
leds.  Nothing is recorded to system logs.  The last logged messages are
that usbcore has registered new interface driver rt73usb, and that the
rate control algorithm has been selected on phy0.  This happens whether
the simple or pid mac80211 rate control algorithms have been chosen.

This is a shame because 2.0.14 was working really well for me until the
mac80211 changes 2 or 3 weeks ago broke it.  (Shortly followed by the
release of 2.1.*).

Chris



