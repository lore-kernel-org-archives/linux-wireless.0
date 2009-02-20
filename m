Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:42954
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916AbZBTXHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 18:07:38 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
Date: Fri, 20 Feb 2009 23:07:33 +0000
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902192316.11628.linux@baker-net.org.uk> <20090220074716.9AB622C4090@tippex.mynet.homeunix.org>
In-Reply-To: <20090220074716.9AB622C4090@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902202307.34035.linux@baker-net.org.uk> (sfid-20090221_000748_555841_C69D7088)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 February 2009, Anders Eriksson wrote:
> linux@baker-net.org.uk said:
> > The first thing to try would be to see if rmmod rt61pci; modprobe rt61pci
> > is enough to recover it. If it is actually a cardbus card then you could
> > also try unplugging and replugging it.
>
> It's a rt2500, so I use that module. Should I use rt61pci?

No, I'm getting confused with another post. rt2500pci is correct.

> If memory servers, rmmod/modprobe does not help. It is a PCI card with no
> loose parts on it so unplugging/plugging is not really an option.

rmmod / modprobe not working isn't a good sign. After a modprobe there is a 
pretty comprehensive reconfigure. When you say you currently have to power 
cycle, have you also tried a reboot

>
> linux@baker-net.org.uk said:
> > Neither of those is an ideal solution though. Do you fancy the task of
> > trying to diagnose the underlying fault which is likely to require at the
> > very least  making sure the driver is built with debugfs support enabled
> > and may require  adding a few printk statements into the kernel modules
> > to reveal more details  of the behaviour?
>
> No problem. I've never used debugfs, but I kind of know my way around the
> kernel. The problem has existed at least since the opensource driver got
> merged into mainline. I'm not sure if the closed source one had the same
> issue. So bisecting is not really an option.

The first thing to do is check that your kernel includes both 
CONFIG_MAC80211_DEBUGFS=y
and 
CONFIG_RT2X00_LIB_DEBUGFS=y

then you can mount the debugfs file system somewhere

mount -t debugfs none /mnt_point

and have a look in there under ieee80211/phy0/rt2500pci for first. Probable 
the most useful thing there is the queue counters which should let you see if 
the card is

a) trying to transmit anything
b) receiving anything

Would be good to know if the legacy driver has the same issue - if it does 
that might point to a hardware fault.

>
> So, where do I sprinkle the prink's, and what info is useful?
>

Adam.


