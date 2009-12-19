Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rain.florz.de ([62.216.164.86]:45347 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755386AbZLSBNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 20:13:17 -0500
Date: Sat, 19 Dec 2009 02:13:06 +0100
From: Florian Zumbiehl <florz@florz.de>
To: Andrea Merello <andreamrl@tiscali.it>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
Message-ID: <20091219011306.GG2512@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org> <4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org> <4B2C100A.9000507@lwfinger.net> <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[...]
> As someone told before this management traffic is for examples beacons.

IC - I hadn't thought that softmac really meant basically "radio only" =:-)

> Probably your prism2 card was a so called "fullmac" card. That menas
> that all this management stuff can be done on the wifi card without
> generating load on the host CPU.

Yeah, it is.

> One thing I can say is that the ieee 802.11 protocol allows certains
> power save functionalities but, provided that mac80211 / rtl8187
> driver support it (and I'm really not sure), this will probably only
> reduces power consumption on the USB, not on the host processor.

That certainly would be nice, too, but it seems that most of the power
consumption really comes from the host processor. I guess I should
measure the current going through the USB connetion ...

> Well, it may be interesting to do a serious analisys about how much
> power is drained by the card when it is up and in RX, when the
> mac80211 sends probes, and how much is related to the CPU, however,
> because you estimated that the power drain increase is too much for
> being directly related to the usb stuff, I think is really possible
> that the big problem is related to beacons.

I'll play around with AP settings a bit and report back to you.
If you can think of any particular useful tests I could do, please
let me know, I'll see what I can do.

But yeah - even if the device draws more than the allowed 500 mA,
I hope very much that it doesn't draw anywhere close to 3 A ... ;-)

[...]
> This means that, IMHO, there is no way to avoid the CPU work on
> rtl8187 when you are connected to a network (unless the network AP is
> yours and you reduce beacon interval as someone suggested). Maybe you
> can force some powersave mode on the CPU, by scaling the cpu clock
> frequency, avoiding taht some "ondemand" policy can rise the clock
> when the CPU is loaded (I doubt beacons processing is enough to
> trigger this), but If you tracked down that interrupts are the causes
> of the CPU don't entering C3 state, I _think_ you can't do much..

I would assume that it's some timers you are using? As I understand it,
other interrupts (which cannot really be predicted) don't prevent
the power management code from switching the CPU into deep sleep
modes?!

It's only a PIII, which is too slow with frequency changes for
the ondemand governor, and the speedstep driver also causes other
yet-unresolved problems (audio stuttering) when loaded.
So it's not really a solution in this case, even though you are
right that the actual CPU cycles used would suggest that newer
processors should be able to stay at their minimum frequency with
the ondemand governor.

> So far If you are looking for a card that make you save power, I
> suggest you to get a fullmac one.

Any suggestions as to how to recognize those? Or even a recommendation
for a specific device/chipset?

Florian
