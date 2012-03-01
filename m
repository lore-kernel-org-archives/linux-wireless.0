Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51444 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965605Ab2CALrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 06:47:35 -0500
Received: by mail-lpp01m010-f45.google.com with SMTP id e6so734882lah.4
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 03:47:33 -0800 (PST)
Message-ID: <1330602450.18637.160.camel@cumari> (sfid-20120301_124739_020988_A8A32457)
Subject: Re: Problems with wl1271
From: Luciano Coelho <coelho@ti.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Date: Thu, 01 Mar 2012 13:47:30 +0200
In-Reply-To: <4F4F5EFB.3020400@mlbassoc.com>
References: <4F4E903B.2030501@mlbassoc.com> <4F4F5EFB.3020400@mlbassoc.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-01 at 04:35 -0700, Gary Thomas wrote: 
> On 2012-02-29 13:53, Gary Thomas wrote:
> > I'm trying to bring up a new hardware platform which includes
> > the TiWi-r02 (wl1271). Since the kernel for my target device
> > (AM3874) is stuck in the dark ages, Luciano suggested that I
> > try compat-wireless + iw. I've managed to build these now
> > (after encountering many problems that I'll help iron out later)
> > and now have the system ready to start using the device. Note:
> > I'm using compat-wireless-2012-02-28 and iw-3.2
> >
> > The kernel modules load and initialize now, with these messages:

[...]

> > wl12xx: loaded
> >
> > When I try to bring up the device, I get this:
> > # ifconfig wlan0 hw ether 2a:00:24:01:02:03
> > # ifconfig wlan0 up
> > wl12xx: firmware booted (Rev 6.3.5.0.98)
> > ADDRCONF(NETDEV_UP): wlan0: link is not ready
> >
> > If I try to scan for an access point, I get nothing:
> > # iw wlan0 scan
> > --- Nothing prints
> > #
> > I also see no additional messages in dmesg.
> >
> > Further checking of the device:

[...]

> > I don't know enough about this device to understand why it's not working.
> > Perhaps the line
> > Available Antennas: TX 0 RX 0
> > is a clue?
> >
> > Any ideas what's not working & how I need to do to move forward?
> >
> > Thanks in advance for all the help
> >
> 
> Any ideas at all?  Is there some debug info I can get to find
> out what's going on?
> 
> Note: I compared the output of 'iw list' from my non-functional system
> to that of a working one (OMAP4430 PandaBoard) and they are virtually
> identical, even the line about the antenna...

Yes, all this looks normal.  Try to enable some debugging in the driver.
You need to enable the dynamic debugging in your kernel config (if you
don't have it yet) and do something like this:

echo "module wl12xx +p" > /sys/kernel/debug/dynamic_debug/control
echo 0x101 > /sys/module/wlcore/parameters/debug_level

The 0x101 value enables IRQ and SCAN debug prints.  You can see more
options in drivers/net/wireless/wl12xx/debug.h.

Please try to scan with this debugging level and send me what you get.

-- 
Cheers,
Luca.

