Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rain.florz.de ([62.216.164.86]:34754 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507AbZLSSoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 13:44:19 -0500
Date: Sat, 19 Dec 2009 19:44:01 +0100
From: Florian Zumbiehl <florz@florz.de>
To: Andrea Merello <andreamrl@tiscali.it>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
Message-ID: <20091219184401.GH2512@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org> <4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org> <4B2C100A.9000507@lwfinger.net> <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com> <20091219011306.GG2512@florz.florz.dyndns.org> <c68f135e0912190230o566b3c3dk9be3038b0602cac5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c68f135e0912190230o566b3c3dk9be3038b0602cac5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > I'll play around with AP settings a bit and report back to you.
> > If you can think of any particular useful tests I could do, please
> > let me know, I'll see what I can do.
> >
> > But yeah - even if the device draws more than the allowed 500 mA,
> > I hope very much that it doesn't draw anywhere close to 3 A ... ;-)
> 
> On the AP you might set the beacon interval lower. And also, I'm not
> sure if the rtl8187 driver configure the BSSID register so that once
> you are associated to the network the card will filter all packets
> from other APs, but in case it does not you can try to set your AP on
> a channel where no other AP are working, otherwise other APs beacons
> will be reiceved.

I did some tests now, with some interesting results:

                                time spent in C0 / C2 / C3 [%] --\
     additional power consumption relative to (1) [W] --\        |
                                                        |        |
(1) No USB devices connected ...................:      0.0   ? /  ? / 98
(2) USB memory stick, idle .....................:      3.8   2 / 98 /  0
(3) RTL8187, interface down ....................:      3.8   2 / 98 /  0
(4) RTL8187, interface up, 100 ms beacons ......:     15.6  48 / 52 /  0
(5) RTL8187, interface up, 1 s beacons .........: 6.0-15.6  29 / 71 /  0

In test setup (5) the current into the laptop is fluctuating so heavily
that I don't have a clue what the average is. But apparently, it's low
enough to keep the fan off - with 100 ms beacons, the fan turns on
regularly.

The time spent in the different C states was measured with powertop, the
power consumption was measured using a DMM.

So, a base load of 3.8 W seems to be caused by any connected usb device
preventing C3 and some 250 ms polling done by uhci_hcd, plus a bit for
the device itself. According to
http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg19354.html
(why aren't there any message IDs on any of those archive sites, BTW?)
that's the expected behaviour.

What I don't quite understand, though, is, why the CPU stays in C0 for
so long when the wifi interface is up. If I let some CPU intensive
application run in parallel, its performance isn't reduced very much
by the RTL8187 being active. Also, top doesn't show anyone to be
consuming those 48 % of the cycles (powertop and top being at the
top with < 1 % ...).

> > I would assume that it's some timers you are using? As I understand it,
> > other interrupts (which cannot really be predicted) don't prevent
> > the power management code from switching the CPU into deep sleep
> > modes?!
> 
> Hmm.. I think I know not enough about C3 state rules.
> I think the rtl8187 does not use timers.
> The only difference is that the interrupt is raised by the (PCI) USB
> controller, then it forwards things to the USB layer, then it calls a
> callback on the rtl8187 driver, and then it passes to the mac80211
> layer. So the problem might be not the interrupt itself but the amount
> of work to do..

But that shouldn't need anywhere close to 350 million cycles per second,
should it? ;-)

> > Any suggestions as to how to recognize those? Or even a recommendation
> > for a specific device/chipset?
> 
> I know that intel ipw2200 and the older ipw2100 should be fullmac.

But there aren't any USB devices with those, are there?

Anyhow, I guess I'll stay with the cardbus prism card, for the USB
host controller being active already needs twice as much power as
the whole card needs.

Florian
