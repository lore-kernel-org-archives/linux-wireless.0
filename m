Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51732 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZLSKac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 05:30:32 -0500
Received: by bwz27 with SMTP id 27so2634802bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2009 02:30:29 -0800 (PST)
MIME-Version: 1.0
Reply-To: andreamrl@tiscali.it
In-Reply-To: <20091219011306.GG2512@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org>
	<4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org>
	<4B2C100A.9000507@lwfinger.net> <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com>
	<20091219011306.GG2512@florz.florz.dyndns.org>
From: Andrea Merello <andreamrl@tiscali.it>
Date: Sat, 19 Dec 2009 11:30:09 +0100
Message-ID: <c68f135e0912190230o566b3c3dk9be3038b0602cac5@mail.gmail.com>
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
To: Florian Zumbiehl <florz@florz.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Well, it may be interesting to do a serious analisys about how much
>> power is drained by the card when it is up and in RX, when the
>> mac80211 sends probes, and how much is related to the CPU, however,
>> because you estimated that the power drain increase is too much for
>> being directly related to the usb stuff, I think is really possible
>> that the big problem is related to beacons.
>
> I'll play around with AP settings a bit and report back to you.
> If you can think of any particular useful tests I could do, please
> let me know, I'll see what I can do.
>
> But yeah - even if the device draws more than the allowed 500 mA,
> I hope very much that it doesn't draw anywhere close to 3 A ... ;-)

On the AP you might set the beacon interval lower. And also, I'm not
sure if the rtl8187 driver configure the BSSID register so that once
you are associated to the network the card will filter all packets
from other APs, but in case it does not you can try to set your AP on
a channel where no other AP are working, otherwise other APs beacons
will be reiceved.


> I would assume that it's some timers you are using? As I understand it,
> other interrupts (which cannot really be predicted) don't prevent
> the power management code from switching the CPU into deep sleep
> modes?!

Hmm.. I think I know not enough about C3 state rules.
I think the rtl8187 does not use timers.
The only difference is that the interrupt is raised by the (PCI) USB
controller, then it forwards things to the USB layer, then it calls a
callback on the rtl8187 driver, and then it passes to the mac80211
layer. So the problem might be not the interrupt itself but the amount
of work to do..


> It's only a PIII, which is too slow with frequency changes for
> the ondemand governor, and the speedstep driver also causes other
> yet-unresolved problems (audio stuttering) when loaded.
> So it's not really a solution in this case, even though you are
> right that the actual CPU cycles used would suggest that newer
> processors should be able to stay at their minimum frequency with
> the ondemand governor.

Hmm.. Well.. I guess that effectively a USB softmac card on a slow
computer might produce a noticeable overhead, even if I never tried
before..

>> So far If you are looking for a card that make you save power, I
>> suggest you to get a fullmac one.
>
> Any suggestions as to how to recognize those? Or even a recommendation
> for a specific device/chipset?

I know that intel ipw2200 and the older ipw2100 should be fullmac.
Some prism, as you said are fullmac, and even some Marvell (for sure
some PCI, I don't know about USB) are fullmac.

There might be other but I don't know for sure..
